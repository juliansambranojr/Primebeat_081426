> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/DirichletMean.lean`, the pinned statements:

```
theorem dirichlet_mean_value_window (N : ℕ) (a : ℕ → ℂ) {T₁ T₂ : ℝ} (h : T₁ ≤ T₂) :
    ∫ t in T₁..T₂,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2
      ≤ (T₂ - T₁ + 8 * N * (1 + Real.log N)) * ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 :=
```

```
theorem dirichlet_mean_value (N : ℕ) (a : ℕ → ℂ) {T : ℝ} (hT : 0 ≤ T) :
    ∫ t in (0:ℝ)..T,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2
      ≤ (T + 8 * N * (1 + Real.log N)) * ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 :=
```

```
theorem dirichlet_mean_value_sigma (N : ℕ) (a : ℕ → ℂ) (σ : ℝ) {T : ℝ} (hT : 0 ≤ T) :
    ∫ t in (0:ℝ)..T,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-((σ : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2
      ≤ (T + 8 * N * (1 + Real.log N)) *
          ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * (n : ℝ) ^ (-2 * σ) :=
```

