> Source: session transcript, 2026-11-23

> Yes and are you going to fix 1, 2, 3 and 4 on the list you just named too?



From `lean_stage3/Stage3/StepsRate.lean`, the pinned statements:

```
theorem norm_K_le_pow {N : ℕ} (hN : 2 ≤ N) {s a : ℂ} (h1 : a ≠ s) (h2 : a ≠ s - 1)
    {δ : ℝ} (hδ : 0 ≤ δ) (hre : a.re - s.re ≤ δ) :
    ‖K N s a‖ ≤ (‖s‖ / ‖a - s‖ + ‖s - 1‖ / ‖a - s + 1‖) * 2 * (N : ℝ) ^ δ :=
```

```
theorem rate_upper {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs : 0 < s.re) (hs1 : s.re ≤ 1)
    {T : ℝ} (hT : 2 ≤ T) {Θ : ℝ} (hsΘ : s.re ≤ Θ)
    (hΘ : ∀ ρ ∈ FiniteOffLine.ZF T, (ρ : ℂ).re ≤ Θ)
    (hne : ∀ ρ ∈ FiniteOffLine.ZF T, (ρ : ℂ) ≠ s) :
    ‖S N s - K N s 1‖
      ≤ (∑ ρ ∈ FiniteOffLine.ZF T,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖
              * ((‖s‖ / ‖(ρ : ℂ) - s‖ + ‖s - 1‖ / ‖(ρ : ℂ) - s + 1‖) * 2))
          * (N : ℝ) ^ (Θ - s.re)
        + (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 s.re) :=
```

