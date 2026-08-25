/-
RvMCrude — hNT slice 1: Backlund's decomposition, assembled.

Entry 130 measured the budget: the census survives any
`Riemann_vonMangoldt_bound B₁ B₂ B₃` up to `B = (100, 100, 1000)` —
Rosser's `(0.137, 0.443, 6.1)` is seventy times sharper than needed, so
the hNT leaf's real target is a CRUDE explicit band. Backlund's proof
has two halves, and this module gives each its name and proves the
assembly:

  rsTheta                the Riemann–Siegel phase,
                         `arg Γ(1/4 + iT/2) − (T/2)·log π`
  StmtPhaseCrude B₁ B₃   the Stirling half: the smooth phase tracks the
                         RvM main term to within `B₁·log T + B₃`
  StmtArgCrude B₁ B₃     the argument-principle half: the count tracks
                         `θ(T)/π + 1` to within `B₁·log T + B₃` — this
                         is `S(T)`, the quantity O69 measured at under
                         2 windings in 10⁵
  RvM_of_phase_arg       the assembly: the two halves give
                         `Riemann_vonMangoldt_bound (B₁+B₁′) 0 (B₃+B₃′)`
                         — a triangle, kernel-checked; `b₂ = 0` is a
                         legitimate instance of the Prop

The two sub-leaves are strictly smaller than hNT: `StmtPhaseCrude` is
Stirling with a generous error (no zeros involved at all), and
`StmtArgCrude` is the classical `S(T) = O(log T)` with any explicit
constant — Borel–Carathéodory and the ZetaBounds growth estimates, both
sorry-free in the dependency, are its toolkit. Discharge slices follow;
this slice is the architecture, same pattern as entries 113 and 125.

Consumes (same tree, no weld): `riemannZeta.RvM`,
`Riemann_vonMangoldt_bound`, `zetaCountingMainTerm`, `riemannZeta.N`.
The weld caveat from Stage3.lean applies to composition with the bench.
Companion to notes entry 131.
-/
import Mathlib
import PrimeNumberTheoremAnd.IEANTN.KadiriZeroCounting
import Stage3.ZeroSum

namespace Stage3

open Kadiri

noncomputable section

/-- The Riemann–Siegel phase: `θ(T) = arg Γ(1/4 + iT/2) − (T/2)·log π`.
The smooth part of the zero count: `N(T) ≈ θ(T)/π + 1`. -/
def rsTheta (T : ℝ) : ℝ :=
  (Complex.Gamma (1 / 4 + T / 2 * Complex.I)).arg - T / 2 * Real.log Real.pi

/-- **The Stirling half of Backlund:** the smooth phase tracks the RvM
main term. Pure asymptotics of `Γ` — no zeros involved; a generous
explicit Stirling error is all it needs. -/
def StmtPhaseCrude (B₁ B₃ : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T →
    |rsTheta T / Real.pi + 1 - zetaCountingMainTerm T| ≤ B₁ * Real.log T + B₃

/-- **The argument-principle half of Backlund:** the count tracks the
smooth phase — this distance is `S(T)`, measured by O69 at under 2
windings in 10⁵. Any explicit constant works; Borel–Carathéodory plus
the ZetaBounds growth estimates are the classical route. -/
def StmtArgCrude (B₁ B₃ : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T →
    |riemannZeta.N T - (rsTheta T / Real.pi + 1)| ≤ B₁ * Real.log T + B₃

/-- **The assembly: Backlund's two halves give the RvM band.** With
`b₂ = 0` — a legitimate instance of `Riemann_vonMangoldt_bound`, and
entry 130's budget accepts any `B₁ + B₁′ ≤ 100`, `B₃ + B₃′ ≤ 1000`. -/
theorem RvM_of_phase_arg {B₁ B₃ B₁' B₃' : ℝ}
    (hPhase : StmtPhaseCrude B₁ B₃) (hArg : StmtArgCrude B₁' B₃') :
    riemannZeta.Riemann_vonMangoldt_bound (B₁ + B₁') 0 (B₃ + B₃') := by
  intro T hT
  have hp := hPhase T hT
  have ha := hArg T hT
  unfold riemannZeta.RvM
  unfold zetaCountingMainTerm at hp
  have htri : |riemannZeta.N T
        - (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
          - T / (2 * Real.pi) + 7 / 8)|
      ≤ |riemannZeta.N T - (rsTheta T / Real.pi + 1)|
        + |rsTheta T / Real.pi + 1
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
