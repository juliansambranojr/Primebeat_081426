/-
RvMCrude — hNT slice 1, corrected: Backlund's decomposition, assembled
over an abstract continuous phase.

Entry 130 measured the budget: the census survives any
`Riemann_vonMangoldt_bound B₁ B₂ B₃` up to `B = (100, 100, 1000)` —
Rosser's `(0.137, 0.443, 6.1)` is seventy times sharper than needed, so
the hNT leaf's real target is a CRUDE explicit band. Backlund's proof
has two halves; this module names each against an abstract phase
function `θ : ℝ → ℝ` and proves the assembly:

  StmtBacklundPhase θ B₁ B₃   the Stirling half: the phase tracks the
                              RvM main term to within `B₁·log T + B₃`
  StmtBacklundArg θ B₁ B₃     the argument-principle half: the count
                              tracks `θ(T)/π + 1` to within
                              `B₁·log T + B₃` — the distance is `S(T)`,
                              the quantity O69 measured at under 2
                              windings in 10⁵
  RvM_of_phase_arg            the assembly: ANY phase θ satisfying both
                              gives `Riemann_vonMangoldt_bound
                              (B₁+B₁′) 0 (B₃+B₃′)` — a triangle,
                              kernel-checked; `b₂ = 0` is a legitimate
                              instance of the Prop

CORRECTION (entry 132). The first version of this module defined the
phase as `arg Γ(1/4 + iT/2) − (T/2)·log π` with Mathlib's principal
`arg`. The principal branch lives in `(−π, π]` and wraps; the classical
`θ(T)` is the continuous branch, which grows like `T·log T`. With the
principal branch both sub-leaves are unsatisfiable for large `T` — the
assembly was true but undischargeable. The phase is therefore abstract
here, and supplying a continuous phase (Binet's integral, or Im log Γ
along a path) is part of the Stirling half's discharge.

The two sub-leaves are strictly smaller than hNT: the Stirling half is
Γ-asymptotics with a generous error (no zeros involved; PNT+'s
sorry-free GammaStirlingAux / GammaBounds / StripBounds are norm-level
groundwork, and the arg layer is the work), and the argument half is
the classical `S(T) = O(log T)` with any explicit constant —
Borel–Carathéodory and the ZetaBounds growth estimates, both
sorry-free in the dependency, are its toolkit.

Consumes (same tree, no weld): `riemannZeta.RvM`,
`Riemann_vonMangoldt_bound`, `zetaCountingMainTerm`, `riemannZeta.N`.
The weld caveat from Stage3.lean applies to composition with the bench.
Companion to notes entries 131, 132.
-/
import Mathlib
import PrimeNumberTheoremAnd.IEANTN.KadiriZeroCounting
import Stage3.ZeroSum

namespace Stage3

open Kadiri

noncomputable section

/-- **The Stirling half of Backlund**, against an abstract phase: the
phase tracks the RvM main term. Pure Γ-asymptotics — no zeros involved;
the discharge supplies a continuous phase and a generous explicit
Stirling error. -/
def StmtBacklundPhase (θ : ℝ → ℝ) (B₁ B₃ : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T →
    |θ T / Real.pi + 1 - zetaCountingMainTerm T| ≤ B₁ * Real.log T + B₃

/-- **The argument-principle half of Backlund**, against the same
phase: the count tracks `θ(T)/π + 1` — this distance is `S(T)`,
measured by O69 at under 2 windings in 10⁵. Any explicit constant
works; Borel–Carathéodory plus the ZetaBounds growth estimates are the
classical route. -/
def StmtBacklundArg (θ : ℝ → ℝ) (B₁ B₃ : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T →
    |riemannZeta.N T - (θ T / Real.pi + 1)| ≤ B₁ * Real.log T + B₃

/-- **The assembly: Backlund's two halves give the RvM band**, for any
phase satisfying both. With `b₂ = 0` — a legitimate instance of
`Riemann_vonMangoldt_bound`; entry 130's budget accepts any
`B₁ + B₁′ ≤ 100`, `B₃ + B₃′ ≤ 1000`. -/
theorem RvM_of_phase_arg {θ : ℝ → ℝ} {B₁ B₃ B₁' B₃' : ℝ}
    (hPhase : StmtBacklundPhase θ B₁ B₃) (hArg : StmtBacklundArg θ B₁' B₃') :
    riemannZeta.Riemann_vonMangoldt_bound (B₁ + B₁') 0 (B₃ + B₃') := by
  intro T hT
  have hp := hPhase T hT
  have ha := hArg T hT
  unfold riemannZeta.RvM
  unfold zetaCountingMainTerm at hp
  have htri : |riemannZeta.N T
        - (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
          - T / (2 * Real.pi) + 7 / 8)|
      ≤ |riemannZeta.N T - (θ T / Real.pi + 1)|
        + |θ T / Real.pi + 1
          - (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
            - T / (2 * Real.pi) + 7 / 8)| := abs_sub_le _ _ _
  calc |riemannZeta.N T
        - (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
          - T / (2 * Real.pi) + 7 / 8)|
      ≤ (B₁' * Real.log T + B₃') + (B₁ * Real.log T + B₃) := by
        refine le_trans htri ?_
        exact add_le_add ha hp
    _ = (B₁ + B₁') * Real.log T + 0 * Real.log (Real.log T) + (B₃ + B₃') := by
        ring

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.RvM_of_phase_arg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.RvM_of_phase_arg

end Stage3
