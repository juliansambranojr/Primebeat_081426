> Source: session transcript, 2026-11-23

> So try, it's possible



From `lean_stage3/Stage3/FilterAttained.lean`, the pinned statements:

```
theorem filter_attained_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (q : Polynomial ℂ) {a b : ℕ} (hb : 1 ≤ b) (hab : a * q.natDegree < b)
    {σ : ℝ} (hσ : 1/2 < σ) (ρ₀ : Kadiri.NontrivialZeros) (hρ₀ : σ ≤ (ρ₀ : ℂ).re)
    (hmax : ∀ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re → ‖xi q a b ρ‖ ≤ ‖xi q a b ρ₀‖)
    (hthr : (2:ℝ) ^ (σ * b) * FilterLadder.Wn q ^ a < ‖xi q a b ρ₀‖) : False :=
```

```
theorem attained_psi {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (ρ₀ : Kadiri.NontrivialZeros)
    (hmax : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) : RiemannHypothesis :=
```

