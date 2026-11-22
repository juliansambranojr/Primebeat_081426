> Source: session transcript, 2026-11-22, after unit 0396

> Keep going

From `lean_stage3/Stage3/LandauZeroSide.lean`, the pinned statement:

```
theorem zero_side {ρ₀ : ℂ} (hz : riemannZeta ρ₀ = 0)
    {σ₀ : ℝ} (hσ : 1 < σ₀) (hS2 : ‖(σ₀ : ℂ) - ρ₀‖ < σ₀) :
    ∃ r R τ C₁ : ℝ, ∃ N₀ : ℕ, σ₀ - 1 < r ∧ r ≤ ‖(σ₀ : ℂ) - ρ₀‖ ∧ r < R ∧
      0 < τ ∧ 0 ≤ C₁ ∧ ∀ a N : ℕ, N₀ ≤ N → ∃ k ∈ Finset.Ico a (a + N),
        τ / r ^ (k + 1) - C₁ / R ^ k ≤ LandauPrimeSide.Ik σ₀ k / k.factorial := by
```
