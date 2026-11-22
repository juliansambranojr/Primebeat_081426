/-
Dump — what the kernel knows. For every constant declared in this tree's own
modules: its kind, its module, and the constants of this tree that occur in
its statement and in its proof term; whether it uses ζ directly (`z`); and
whether it uses analysis directly (`a`). One JSON object per line on stdout.

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

/-- Names whose use marks a declaration as reading ζ: the zeta function, its
zeros, its L-series and Euler product, and the Riemann hypothesis. -/
def zetaRoots : List Name :=
  [`riemannZeta, `RiemannHypothesis, `LSeries, `completedRiemannZeta, `completedRiemannZeta₀,
   `HurwitzZeta, `Kadiri, `ZetaTwoThree, `DirichletCharacter]

/-- Library modules that are about ζ. A constant from one of them marks its
user as reading ζ. -/
def zetaModules : List String :=
  ["PrimeNumberTheoremAnd", "Mathlib.NumberTheory.LSeries", "Mathlib.NumberTheory.ZetaValues",
   "Mathlib.NumberTheory.EulerProduct", "Mathlib.NumberTheory.Harmonic.ZetaAsymp", "ZetaTwoThree"]

/-- Library modules of analysis: the real and complex numbers, limits,
integrals. A constant from one of them marks its user as using analysis.
`Mathlib.Analysis.Normed` is left out on purpose: the integers' ring structure
is sometimes found through a normed-ring instance, which is plumbing; a real
use of norms names `Real` or `Complex` and is caught by the root test. -/
def analysisModules : List String :=
  ["Mathlib.Analysis.SpecialFunctions", "Mathlib.Analysis.Calculus", "Mathlib.Analysis.Complex",
   "Mathlib.Analysis.Asymptotics", "Mathlib.Analysis.Analytic", "Mathlib.Analysis.Fourier",
   "Mathlib.MeasureTheory", "Mathlib.Topology.Algebra.InfiniteSum", "Mathlib.Data.Real",
   "Mathlib.Data.Complex", "Mathlib.NumberTheory.Chebyshev", "Mathlib.Order.Filter"]

def dumpAll (roots : List Name) : CoreM Unit := do
  let env ← getEnv
  let mods := env.header.moduleNames
  let zeta (c : Name) : Bool :=
    zetaRoots.contains c.getRoot ||
      (match env.getModuleIdxFor? c with
       | some idx => zetaModules.any (fun p => p.isPrefixOf (toString mods[idx.toNat]!))
       | none => false)
  let analysis (c : Name) : Bool :=
    c.getRoot == `Real || c.getRoot == `Complex ||
      (match env.getModuleIdxFor? c with
       | some idx => analysisModules.any (fun p => p.isPrefixOf (toString mods[idx.toNat]!))
       | none => false)
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
        ("ty", toJson (keep tyUses)), ("pf", toJson (keep valUses)),
        ("z", toJson (tyUses.any zeta || valUses.any zeta)),
        ("a", toJson (tyUses.any analysis || valUses.any analysis))]
      IO.println j.compress
