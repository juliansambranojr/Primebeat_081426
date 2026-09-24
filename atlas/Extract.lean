/-
Extract.lean -- the atlas's reader of a built Lean project, run by Lean itself.

    lake env lean --run atlas/Extract.lean OUT.json [--path DIR]... EMIT... -- PROJ...

EMIT are the modules whose declarations are written; PROJ are the module
names (EMIT included) that count as the project when a reference is kept.
Everything else (Mathlib, PNT+, core) is outside the atlas.

A declaration is KEPT when its user name (private prefix removed) is not an
internal detail (`Name.isInternalDetail`: `_`, `eq_n`, `match_n`,
`proof_n`, ...), it is not a recursor, quotient, auxiliary recursor or
`noConfusion`, it is not a notation's parser (type `ParserDescr` or
`TrailingParserDescr`), and Lean holds a declaration range for it.

Per kept declaration: name (user form), private flag, kind, module, line,
end line, `sorry` (its type or value names `sorryAx`, looking through the
project's own non-kept auxiliary constants such as `foo.proof_1`), `uses`
(the kept project constants its type and value name, again looking through
non-kept auxiliaries), and its type pretty-printed at width 100.

No file is changed; the JSON is sorted by module, line, name.
-/
import Lean
open Lean Meta

def kindOf (env : Environment) : ConstantInfo → String
  | .thmInfo _ => "theorem"
  | .defnInfo v => if isInstanceCore env v.name then "instance" else "def"
  | .axiomInfo _ => "axiom"
  | .opaqueInfo _ => "opaque"
  | .inductInfo v => if isStructure env v.name then "structure" else "inductive"
  | .ctorInfo _ => "constructor"
  | .recInfo _ => "recursor"
  | .quotInfo _ => "quot"

def usedOf (ci : ConstantInfo) : Array Name :=
  let t := ci.type.getUsedConstants
  match ci.value? (allowOpaque := true) with
  | some v => t ++ v.getUsedConstants
  | none => t

def userName (n : Name) : Name := privateToUserName n

def isKeptShape (env : Environment) (ci : ConstantInfo) : Bool :=
  let n := ci.name
  !(userName n).isInternalDetail
    && !(match ci with | .recInfo _ => true | .quotInfo _ => true | _ => false)
    && !ci.type.isConstOf ``Lean.ParserDescr && !ci.type.isConstOf ``Lean.TrailingParserDescr
    && !isAuxRecursor env n && !isNoConfusion env n

structure Row where
  name : Name
  mod : Name
  line : Nat
  json : Json

def main (args : List String) : IO UInt32 := do
  let out :: rest := args | IO.eprintln "usage: OUT.json [--path DIR]... EMIT... -- PROJ..."; return 2
  let mut paths : Array System.FilePath := #[]
  let mut emit : Array Name := #[]
  let mut proj : Array Name := #[]
  let mut inProj := false
  let mut i := 0
  let ra := rest.toArray
  while i < ra.size do
    let a := ra[i]!
    if a == "--path" then
      paths := paths.push ra[i+1]!
      i := i + 2
      continue
    if a == "--" then inProj := true
    else if inProj then proj := proj.push a.toName
    else emit := emit.push a.toName
    i := i + 1
  initSearchPath (← findSysroot)
  searchPathRef.modify (paths.toList ++ ·)
  unsafe enableInitializersExecution
  let env ← importModules (emit.map fun m => { module := m }) {} (trustLevel := 1024) (loadExts := true)
  let projSet : NameSet := (proj ++ emit).foldl (·.insert ·) {}
  let modNames := env.header.moduleNames
  let isProj (n : Name) : Bool :=
    match env.getModuleIdxFor? n with
    | some idx => projSet.contains modNames[idx.toNat]!
    | none => false
  let opts : Options := ({} : Options) |>.setBool `pp.fullNames false
  let ctx : Core.Context := { fileName := "<atlas>", fileMap := default, options := opts,
                              maxHeartbeats := 0 }
  let cstate : Core.State := { env := env }
  -- pass 1: the kept declarations of the emitted modules and of the project
  let mut kept : NameSet := {}
  let mut ranges : NameMap DeclarationRanges := {}
  for idx in [0:modNames.size] do
    let m := modNames[idx]!
    unless projSet.contains m do continue
    for n in env.header.moduleData[idx]!.constNames do
      let some ci := env.find? n | continue
      unless isKeptShape env ci do continue
      let r? ← (findDeclarationRanges? n : CoreM _).toIO' ctx cstate
      if let some r := r? then
        kept := kept.insert n
        ranges := ranges.insert n r
  -- pass 2: rows for the emitted modules
  let emitSet : NameSet := emit.foldl (·.insert ·) {}
  let mut rows : Array Row := #[]
  let mut nerr := 0
  for idx in [0:modNames.size] do
    let m := modNames[idx]!
    unless emitSet.contains m do continue
    for n in env.header.moduleData[idx]!.constNames do
      unless kept.contains n do continue
      let some ci := env.find? n | continue
      -- uses and sorry, looking through non-kept project auxiliaries
      let mut uses : NameSet := {}
      let mut hasSorry := false
      let mut seen : NameSet := ({} : NameSet).insert n
      let mut work : Array Name := usedOf ci
      while h : work.size > 0 do
        let c := work[work.size - 1]
        work := work.pop
        if c == ``sorryAx then hasSorry := true; continue
        if seen.contains c then continue
        seen := seen.insert c
        unless isProj c do continue
        if kept.contains c then uses := uses.insert c
        else if let some cc := env.find? c then work := work ++ usedOf cc
      let tyStr ← try
          let f ← (ppExpr ci.type : MetaM Format).run' {} {} |>.toIO' ctx cstate
          pure (f.pretty 100)
        catch e => do nerr := nerr + 1; pure s!"<pp failed: {e}>"
      let r := ranges.find? n |>.get!
      let modOf (c : Name) : String :=
        match env.getModuleIdxFor? c with
        | some j => modNames[j.toNat]!.toString
        | none => ""
      let usesArr := uses.toArray.qsort (fun a b => a.toString < b.toString)
      let j := Json.mkObj [
        ("name", Json.str (userName n).toString),
        ("private", Json.bool (isPrivateName n)),
        ("kind", Json.str (kindOf env ci)),
        ("module", Json.str m.toString),
        ("line", Json.num r.range.pos.line),
        ("end_line", Json.num r.range.endPos.line),
        ("sorry", Json.bool hasSorry),
        ("uses", Json.arr (usesArr.map fun c =>
            Json.arr #[Json.str (modOf c), Json.str (userName c).toString])),
        ("type", Json.str tyStr)]
      rows := rows.push { name := userName n, mod := m, line := r.range.pos.line, json := j }
  let sorted := rows.qsort fun a b =>
    if a.mod != b.mod then a.mod.toString < b.mod.toString
    else if a.line != b.line then a.line < b.line
    else a.name.toString < b.name.toString
  let doc := Json.mkObj [
    ("lean", Json.str Lean.versionString),
    ("emit", Json.arr (emit.map (Json.str ·.toString))),
    ("pp_failures", Json.num nerr),
    ("decls", Json.arr (sorted.map (·.json)))]
  IO.FS.writeFile out (doc.compress ++ "\n")
  IO.println s!"atlas extract: {rows.size} declarations from {emit.size} modules, {nerr} pp failures"
  return 0
