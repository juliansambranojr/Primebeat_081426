/-
ArgCrude — hNT slice 2: the argument-principle half of Backlund,
decomposed to the point where the Jensen zero-count is the only
analytic content left.

Entry 141 mapped the route for `StmtBacklundArg`: the rectangle
argument-principle identity, plus Jensen / Borel–Carathéodory disk
counts to bound `S(T)`. Entry 156 recorded that upstream PR #1751
landed `ZerosBound` — the Jensen disk count itself — sorry-free, so
the count is now an import rather than a build.

This module names the three pieces and proves the assembly:

  StmtArgIdentity θ S    the identity `N T = θ T / π + 1 + S T`;
                         pure argument principle, no bounds — this
                         is what the rectangle contour delivers
  StmtLocalCount cnt     a local zero count growing like `log T`;
                         the Jensen piece, and the one now cheap
  StmtSFromLocal S cnt   `|S T| ≤ a · cnt T + b` — Backlund's step
                         from the count to the argument
  argCrude_of_pieces     the assembly: the three give
                         `StmtBacklundArg θ (a·A₁) (a·A₃+b)`

The count is abstract (`cnt : ℝ → ℝ`) for the same reason the phase
was abstract in `RvMCrude`: entry 132's correction was a statement
that could not be satisfied, and keeping the shape parametric is what
makes the discharge testable before it is attempted. Entry 130's
budget accepts any `B₁ ≤ 100`, `B₃ ≤ 1000`, so every constant here
may be crude by two orders and still feed the census.

THE CONCRETE COUNT, for the discharge slice. Upstream's `ZeroWindow`
is centred at `3/2 + it` with radius `3/4` — `Re ρ ∈ [3/4, 9/4]`,
which does not reach the critical line, because it exists for their
zero-free-strip work. Backlund's count needs a disk crossing
`Re = 1/2` in a segment of positive length, i.e.
`f z = ζ (2z + 2 + iT) / ζ (2 + iT)` on the unit ball with
`r = 7/8`, covering `|s - (2+iT)| ≤ 7/4`; `R = 15/16` gives the
majorant radius `15/8`, and the pole at `s = 1` stays outside
because `‖(2+iT) - 1‖ = √(1+T²) ≥ √5 > 2` for `T ≥ 2`.

THE RADIUS IS `7/4`. A radius-`3/2` disk about `2 + iT` is tangent
to the critical line: a zero at `1/2 + iγ` sits at distance
`√((3/2)² + (T-γ)²)`, inside only when `γ = T` exactly. That count
is `0` for almost every `T`, and `StmtSFromLocal` below would then
read `|S T| ≤ b`, a bounded-`S` claim, which is false. Radius `7/4`
reaches `|γ - T| ≤ √(13/16)` ≈ `0.901`; O77
(`results/leaf_instantiation.json`) measured the count vanishing on
12% of a `T`-grid to `900`, with `|S T| ≤ 0.462 · cnt T + 0.508`
holding across it. `Stage3/JensenCount.lean` carries the discharge,
at `A₁ = 15`, `A₃ = 73`.

Consumes: `riemannZeta.N`, `StmtBacklundArg` (Stage3.RvMCrude).
Companion to notes entries 130, 141, 156.
-/
import Mathlib
import Stage3.RvMCrude

namespace Stage3

noncomputable section

/-- **The rectangle identity**: the zero count is the phase plus one,
plus `S`. Pure argument principle — no bound is asserted here, which
is the point of naming it separately. -/
def StmtArgIdentity (θ S : ℝ → ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T → riemannZeta.N T = θ T / Real.pi + 1 + S T

/-- **The crude argument bound**: `|S T| ≤ B₁ log T + B₃`. This is
`StmtBacklundArg`'s content once the identity is available. -/
def StmtSCrude (S : ℝ → ℝ) (B₁ B₃ : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T → |S T| ≤ B₁ * Real.log T + B₃

/-- **The Jensen piece**: a local zero count that grows like `log T`.
Abstract in `cnt` so the discharge target is a statement, not a
construction — upstream `ZerosBound` is what discharges it. -/
def StmtLocalCount (cnt : ℝ → ℝ) (A₁ A₃ : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T → cnt T ≤ A₁ * Real.log T + A₃

/-- **Backlund's step**: the argument is controlled by the local
count. `a` and `b` are crude by design. -/
def StmtSFromLocal (S cnt : ℝ → ℝ) (a b : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T → |S T| ≤ a * cnt T + b

/-- **Count to argument bound.** Needs `0 ≤ a`; the count enters
positively. -/
theorem sCrude_of_local {S cnt : ℝ → ℝ} {a b A₁ A₃ : ℝ} (ha : 0 ≤ a)
    (hSF : StmtSFromLocal S cnt a b) (hL : StmtLocalCount cnt A₁ A₃) :
    StmtSCrude S (a * A₁) (a * A₃ + b) := by
  intro T hT
  have h1 := hSF T hT
  have h2 := hL T hT
  have h3 : a * cnt T ≤ a * (A₁ * Real.log T + A₃) :=
    mul_le_mul_of_nonneg_left h2 ha
  calc |S T| ≤ a * cnt T + b := h1
    _ ≤ a * (A₁ * Real.log T + A₃) + b := by linarith
    _ = a * A₁ * Real.log T + (a * A₃ + b) := by ring

/-- **Identity plus bound gives the Arg half.** -/
theorem backlundArg_of_identity {θ S : ℝ → ℝ} {B₁ B₃ : ℝ}
    (hid : StmtArgIdentity θ S) (hS : StmtSCrude S B₁ B₃) :
    StmtBacklundArg θ B₁ B₃ := by
  intro T hT
  have hrw : riemannZeta.N T - (θ T / Real.pi + 1) = S T := by
    rw [hid T hT]; ring
  rw [hrw]
  exact hS T hT

/-- **THE ASSEMBLY.** The rectangle identity, the Jensen count and
Backlund's step give the argument half of the decomposition, with
every constant explicit. What remains open after this module is
exactly: the identity, the step, and a concrete `cnt` discharged from
upstream `ZerosBound`. -/
theorem argCrude_of_pieces {θ S cnt : ℝ → ℝ} {a b A₁ A₃ : ℝ}
    (ha : 0 ≤ a) (hid : StmtArgIdentity θ S)
    (hSF : StmtSFromLocal S cnt a b) (hL : StmtLocalCount cnt A₁ A₃) :
    StmtBacklundArg θ (a * A₁) (a * A₃ + b) :=
  backlundArg_of_identity hid (sCrude_of_local ha hSF hL)

/-- **The full hNT band from the two halves, restated through this
decomposition.** With the Stirling half already discharged
(`Stage3.backlundPhase_holds : StmtBacklundPhase phaseTheta 97 98`,
entry 140), supplying the three pieces here delivers
`Riemann_vonMangoldt_bound`. -/
theorem rvM_of_stirling_and_pieces {θ S cnt : ℝ → ℝ}
    {B₁ B₃ a b A₁ A₃ : ℝ} (ha : 0 ≤ a)
    (hPhase : StmtBacklundPhase θ B₁ B₃) (hid : StmtArgIdentity θ S)
    (hSF : StmtSFromLocal S cnt a b) (hL : StmtLocalCount cnt A₁ A₃) :
    riemannZeta.Riemann_vonMangoldt_bound (B₁ + a * A₁) 0
      (B₃ + (a * A₃ + b)) :=
  RvM_of_phase_arg hPhase (argCrude_of_pieces ha hid hSF hL)

end

/-! ## Axiom check

Each `#guard_msgs` block pins the exact axiom list of one result: if a proof
ever starts depending on anything not listed, the docstring stops matching the
compiler and **`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.sCrude_of_local' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.sCrude_of_local

/-- info: 'Stage3.backlundArg_of_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.backlundArg_of_identity

/-- info: 'Stage3.argCrude_of_pieces' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.argCrude_of_pieces

/-- info: 'Stage3.rvM_of_stirling_and_pieces' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.rvM_of_stirling_and_pieces

end Stage3
