> Source: session transcript, 2026-11-24

> Do you want a decision unit recording that 0509 is weaker than 0467, and that the open arrangement is creeping alone?

> Yes

From `lean_stage3/Stage3/FilterAttained.lean`, the statement that already covers the attained case:

```
theorem attained_psi {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (ρ₀ : Kadiri.NontrivialZeros)
    (hmax : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) : RiemannHypothesis := by
```
