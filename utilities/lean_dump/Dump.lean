/-
Dump — what the kernel knows. For every constant declared in this tree's own
modules: its kind, its module, and the constants of this tree that occur in
its statement and in its proof term. One JSON object per line on stdout.

`python3 utilities/lean_map.py --dump` puts the tree's imports above this body,
adds `#eval dumpAll [roots]` below it, and runs the result with `lake env lean`
inside each tree.
-/
import Lean
open Lean

def kindOf : ConstantInfo → String
  | .thmInfo _ => "theorem"
  | .defnInfo _ => "def"
  | .axiomInfo _ => "axiom"
  | .opaqueInfo _ => "opaque"
  | .inductInfo _ => "inductive"
  | .ctorInfo _ => "ctor"
  | .recInfo _ => "rec"
  | .quotInfo _ => "quot"

def dumpAll (roots : List Name) : CoreM Unit := do
  let env ← getEnv
  let mods := env.header.moduleNames
  let ours (n : Name) : Option Name :=
    match env.getModuleIdxFor? n with
    | some idx =>
      let m := mods[idx.toNat]!
      if roots.contains m.getRoot then some m else none
    | none => none
  for (n, ci) in env.constants.toList do
    match ours n with
    | none => pure ()
    | some m =>
      let tyUses := ci.type.getUsedConstants
      -- read the proof term directly: `ConstantInfo.value?` hides a theorem's from v4.29 on
      let valUses := match ci with
        | .thmInfo v => v.value.getUsedConstants
        | .defnInfo v => v.value.getUsedConstants
        | .opaqueInfo v => v.value.getUsedConstants
        | _ => #[]
      let keep (a : Array Name) : Array String :=
        (a.filter (fun c => c != n && (ours c).isSome)).map toString
      let j := Json.mkObj [
        ("n", toString n), ("k", kindOf ci), ("m", toString m),
        ("ty", toJson (keep tyUses)), ("pf", toJson (keep valUses))]
      IO.println j.compress
