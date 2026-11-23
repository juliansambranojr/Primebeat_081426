/-
RateBelow — block R9 of `lean_stage3/design/runs.md`, the staircase. 2026-11-23.

The rain comes. A zero need not be shown uncancelled at a given point. If the
staircase stayed within `C·x^θ·log^k x` of `x` from some point on, no zero
would lie right of `θ` (`Stage3.no_zero_right_of_theta`). So at a zero `ρ₀`,
for every `θ` below its real part and every `C`, `k`, `x₀`, the staircase
leaves that bound at some `x` beyond `x₀`: again and again, without the proof
saying where.

  rain_psi   θ < Re ρ₀ ⊢ ∀ C k x₀, ∃ x ≥ x₀, C·x^θ·log^k x < |ψ(x) − x|

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ThetaConverse
import Stage3.StepsRate

namespace RateBelow

open Kadiri

/-- **The rain comes.** At a zero `ρ₀`, for every exponent `θ` below its real
part, the staircase exceeds `C·x^θ·log^k x` at points beyond any `x₀`. -/
theorem rain_psi (ρ₀ : NontrivialZeros) {θ : ℝ} (hθ : θ < (ρ₀ : ℂ).re)
    (C : ℝ) (k : ℕ) (x₀ : ℝ) :
    ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ θ * Real.log x ^ k < |Chebyshev.psi x - x| := by
  by_contra hcon
  have h : Stage3.StmtPsiWeakTheta θ C k x₀ := by
    intro t ht
    by_contra hlt
    exact hcon ⟨t, ht, lt_of_not_ge hlt⟩
  exact Stage3.no_zero_right_of_theta h hθ (nontrivialZero_ne_one ρ₀) ρ₀.2.2.2

/-- info: 'RateBelow.rain_psi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rain_psi

end RateBelow
