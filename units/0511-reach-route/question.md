> Source: session transcript, 2026-11-24

> Case ladder



From `lean_stage3/Stage3/ReachRoute.lean`, the pinned statements:

```
theorem reached_mode_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ₀ Θ : ℝ} (hσ₀ : 1 / 2 < σ₀) (hσ₀Θ : σ₀ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ Θ) :
    ∃ E : ℝ, σ₀ ≤ E ∧ E < Θ ∧ ∀ σ : ℝ, E ≤ σ →
      ∀ ρ₁ : Kadiri.NontrivialZeros, σ < (ρ₁ : ℂ).re →
      (∃ (u : ℕ → ℂ) (M : ℝ),
        (∀ j, u j ∈ connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0) ∧
        Tendsto u atTop (𝓝 (um ρ₁)) ∧
        (∀ j, u j ≠ um ρ₁) ∧
        (∀ j, ∀ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re → um ρ ≠ um ρ₁ →
          ‖u j - um ρ₁‖ ≤ M * ‖um ρ - u j‖)) →
      False :=
```

```
theorem reach_of_isolated {σ : ℝ} {ρ₁ : Kadiri.NontrivialZeros} (hρ₁ : σ ≤ (ρ₁ : ℂ).re)
    (hiso : ∃ ε : ℝ, 0 < ε ∧
      ∀ u ∈ K σ, ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ < ε → u = (2:ℂ) ^ (-(ρ₁ : ℂ)))
    (hfr : (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈
      frontier (connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0)) :
    ∃ (u : ℕ → ℂ) (M : ℝ),
      (∀ j, u j ∈ connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0) ∧
      Tendsto u atTop (𝓝 (um ρ₁)) ∧
      (∀ j, u j ≠ um ρ₁) ∧
      (∀ j, ∀ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re → um ρ ≠ um ρ₁ →
        ‖u j - um ρ₁‖ ≤ M * ‖um ρ - u j‖) :=
```

