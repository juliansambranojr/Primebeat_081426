> Source: session transcript, 2026-11-23

> So try, it's possible



From `lean_stage3/Stage3/FilterLadder.lean`, the pinned statements:

```
theorem Wn_pow_le (q : Polynomial ℂ) (m : ℕ) : Wn (q ^ m) ≤ Wn q ^ m :=
```

```
theorem filter_mode (q : Polynomial ℂ) {m N n : ℕ} (hN : (q ^ m).natDegree ≤ N)
    (hNn : N ≤ n) {z : ℂ} (hz : z ≠ 0) :
    ∑ j ∈ range (N + 1), (q ^ m).coeff j * z ^ (n - j) = z ^ n * (q.eval z⁻¹) ^ m :=
```

```
theorem filtered_modes_small_sq {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ : ℝ} (hσ : 1/2 ≤ σ) (q : Polynomial ℂ) {n m : ℕ} (hn : 2 ≤ n)
    (hmn : m * q.natDegree < n) :
    ‖∑ ρ ∈ (FiniteOffLine.ZF ((2:ℝ)^n)).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ)
            * (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ m * ((2:ℂ) ^ (ρ : ℂ)) ^ n‖
        ≤ Afl C * (n:ℝ)^2 * (2:ℝ)^(σ * n) * Wn q ^ m :=
```

```
theorem filtered_modes_small {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ : ℝ} (hσ : 1/2 < σ) :
    ∃ A : ℝ, ∀ (q : Polynomial ℂ) (n m : ℕ), 2 ≤ n → m * q.natDegree < n →
      ‖∑ ρ ∈ (FiniteOffLine.ZF ((2:ℝ)^n)).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ)
            * (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ m * ((2:ℂ) ^ (ρ : ℂ)) ^ n‖
        ≤ A * (n:ℝ)^4 * (2:ℝ)^(σ * n) * Wn q ^ m :=
```

