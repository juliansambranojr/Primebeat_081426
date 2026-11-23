> Source: session transcript, 2026-11-23

> Yes and are you going to fix 1, 2, 3 and 4 on the list you just named too?



From `lean_stage3/Stage3/StepsPeak.lean`, the pinned statements:

```
theorem peak_formula {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs : 0 < s.re) {T : ℝ} (hT : 2 ≤ T) :
    ‖S N s - K N s 1
      + ∑ ρ ∈ FiniteOffLine.ZF T,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ)‖
      ≤ (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 s.re) :=
```

```
theorem K_self {N : ℕ} (hN : 2 ≤ N) (s : ℂ) :
    K N s s = s * ((Real.log N - Real.log 2 : ℝ) : ℂ) - (s - 1) * ((N:ℂ) - 2) / N :=
```

```
theorem peak_at_zero {N : ℕ} (hN : 2 ≤ N) (ρ₀ : NontrivialZeros) {T : ℝ} (hT : 2 ≤ T)
    (hρ₀ : |(ρ₀ : ℂ).im| < T) :
    ‖S N ρ₀ - K N ρ₀ 1
      - (-((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * (Real.log N : ℂ)
          + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * (Real.log 2 : ℂ)
          + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * ((ρ₀ : ℂ) - 1) * ((N : ℂ) - 2)
              / ((ρ₀ : ℂ) * N))
      + ∑ ρ ∈ (FiniteOffLine.ZF T).erase ρ₀,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N ρ₀ (ρ : ℂ)‖
      ≤ (‖(ρ₀ : ℂ)‖ + ‖(ρ₀ : ℂ) - 1‖)
          * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 (ρ₀ : ℂ).re) :=
```

```
theorem peak_height {N : ℕ} (hN : 2 ≤ N) (ρ₀ : NontrivialZeros) {T : ℝ} (hT : 2 ≤ T)
    (hρ₀ : |(ρ₀ : ℂ).im| < T)
    (hright : ∀ ρ ∈ FiniteOffLine.ZF T, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) :
    ‖S N ρ₀ - K N ρ₀ 1 + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * (Real.log N : ℂ)‖
      ≤ ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * Real.log 2
        + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * ‖(ρ₀ : ℂ) - 1‖ / ‖(ρ₀ : ℂ)‖
        + ∑ ρ ∈ (FiniteOffLine.ZF T).erase ρ₀,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖
              * ((‖(ρ₀ : ℂ)‖ / ‖(ρ : ℂ) - ρ₀‖ + ‖(ρ₀ : ℂ) - 1‖ / ‖(ρ : ℂ) - ρ₀ + 1‖) * 2)
        + (‖(ρ₀ : ℂ)‖ + ‖(ρ₀ : ℂ) - 1‖)
          * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 (ρ₀ : ℂ).re) :=
```

