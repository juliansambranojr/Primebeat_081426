> Source: session transcript, 2026-11-24

> Start the loop



From `lean_stage3/Stage3/LadderAssembly.lean`, the pinned statements:

```
theorem top_mode_on_frontier (ρ₁ : Kadiri.NontrivialZeros)
    (htop : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ (ρ₁ : ℂ).re)
    {σ : ℝ} (hσ : σ ≤ (ρ₁ : ℂ).re) :
    (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈
      frontier (connectedComponentIn
        (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ ResidueRoute.K σ) 0) :=
```

```
theorem rh_of_ladder_tame {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (htame : ¬ RiemannHypothesis → ∃ ρ₁ : Kadiri.NontrivialZeros,
      1/2 < (ρ₁:ℂ).re ∧ (∀ ρ : Kadiri.NontrivialZeros, (ρ:ℂ).re ≤ (ρ₁:ℂ).re) ∧
      ∃ σ₀ ε : ℝ, 1/2 < σ₀ ∧ σ₀ < (ρ₁:ℂ).re ∧ 0 < ε ∧
        ∀ ρ : Kadiri.NontrivialZeros, σ₀ ≤ (ρ:ℂ).re →
          (2:ℂ)^(-(ρ:ℂ)) ≠ (2:ℂ)^(-(ρ₁:ℂ)) →
          ε ≤ ‖(2:ℂ)^(-(ρ:ℂ)) - (2:ℂ)^(-(ρ₁:ℂ))‖) :
    RiemannHypothesis :=
```

