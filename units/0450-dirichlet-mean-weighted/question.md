> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/DirichletMeanW.lean`, the pinned statements:

```
theorem dirichlet_mean_value_weighted (N : ℕ) (a : ℕ → ℂ) {T₁ T₂ : ℝ} (h : T₁ ≤ T₂) :
    ∫ t in T₁..T₂,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * ((T₂ - T₁) + 6 * n * (1 + Real.log N)) :=
```

```
theorem dirichlet_mean_value_weighted_sigma (N : ℕ) (a : ℕ → ℂ) (σ : ℝ) {T₁ T₂ : ℝ}
    (h : T₁ ≤ T₂) :
    ∫ t in T₁..T₂,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-((σ : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2
      ≤ ∑ n ∈ Finset.Icc 1 N,
          ‖a n‖ ^ 2 * (n : ℝ) ^ (-2 * σ) * ((T₂ - T₁) + 6 * n * (1 + Real.log N)) :=
```

