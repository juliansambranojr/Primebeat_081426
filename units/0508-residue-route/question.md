> Source: session transcript, 2026-11-24

> Start the loop



From `lean_stage3/Stage3/ResidueRoute.lean`, the pinned statements:

```
theorem isolated_boundary_mode_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ₀ Θ : ℝ} (hσ₀ : 1 / 2 < σ₀) (hσ₀Θ : σ₀ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ Θ) :
    ∃ E : ℝ, σ₀ ≤ E ∧ E < Θ ∧ ∀ σ : ℝ, E ≤ σ →
      ∀ ρ₁ : Kadiri.NontrivialZeros, σ < (ρ₁ : ℂ).re →
      (∃ ε : ℝ, 0 < ε ∧ ∀ u ∈ K σ, ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ < ε → u = (2:ℂ) ^ (-(ρ₁ : ℂ))) →
      (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈
        frontier (connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0) →
      False :=
```

