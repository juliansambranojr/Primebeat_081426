/-
Target — the one open statement of the chain, fixed. 2026-11-24.

Julian, 2026-11-24: the target is not to move. It is the window bound on `G`
(`LandauWindow.WindowBound`, the ramp sum of the von Mangoldt function less
its main terms) at every `θ` in `(1/2, 1)`: upper side only, on windows
`[Y, Y^(1+δ)]` for arbitrarily large `Y`. Proved, it gives Mathlib's
`RiemannHypothesis` by `LandauCriterion.rh_of_windows`.

  Target          the statement
  rh_of_target    Target → RiemannHypothesis

`Target` is a definition and is proved nowhere.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauCriterion

namespace Stage3

/-- **The target.** For every `θ` in `(1/2, 1)` there are `δ > 0` and `C` with
`G y ≤ C·y^θ` on windows `[Y, Y^(1+δ)]` for arbitrarily large `Y`. -/
def Target : Prop :=
  ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ LandauWindow.WindowBound θ δ C

/-- The target gives the Riemann hypothesis. -/
theorem rh_of_target (h : Target) : RiemannHypothesis :=
  LandauCriterion.rh_of_windows h

/-- info: 'Stage3.rh_of_target' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_of_target

end Stage3
