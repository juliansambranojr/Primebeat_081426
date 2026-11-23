> Source: session transcript, 2026-11-23

> Merge then the count



From `lean_stage3/Stage3/CountReduction.lean`, the pinned statements:

```
theorem tail_rate {σ : ℝ} (hσ : 1/2 < σ) (hσ1 : σ ≤ 1) :
    ∃ θ' Ct : ℝ, 0 ≤ θ' ∧ θ' < 1 ∧ 0 ≤ Ct ∧ ∀ (k : ℕ), 1 ≤ k → ∀ v : Finset Kadiri.NontrivialZeros,
      (∀ ρ ∈ v, σ ≤ (ρ:ℂ).re ∧ (2:ℝ)^k ≤ |(ρ:ℂ).im|) →
      ∑ ρ ∈ v, ((riemannZeta.order (ρ:ℂ) : ℤ) : ℝ) / ‖(ρ:ℂ)‖
        ≤ Ct * k * (2:ℝ)^(-(k:ℝ) * (1 - θ')) :=
```

```
theorem summable_J {σ : ℝ} (hσ : 1/2 < σ) {k : ℕ} (hk : 1 ≤ k) :
    Summable fun ρ : {ρ : Kadiri.NontrivialZeros // σ ≤ (ρ:ℂ).re} =>
      ‖((riemannZeta.order ((ρ:Kadiri.NontrivialZeros):ℂ) : ℤ) : ℂ)
        * CountModes.J k (((ρ:Kadiri.NontrivialZeros):ℂ) * Real.log 2)‖ :=
```

```
theorem count_modes_small {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → |(Nat.primeCounting ⌊(2:ℝ)^k⌋₊ : ℝ) - Stage3.Li ((2:ℝ)^k)|
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ Θ : ℝ} (hσ : 1/2 < σ) (hσΘ : σ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ:ℂ).re ≤ Θ) :
    ∃ E A : ℝ, σ ≤ E ∧ E < Θ ∧ ∀ k : ℕ, 2 ≤ k →
      ‖∑' ρ : {ρ : Kadiri.NontrivialZeros // σ ≤ (ρ:ℂ).re},
          ((riemannZeta.order ((ρ:Kadiri.NontrivialZeros):ℂ) : ℤ) : ℂ)
            * CountModes.J k (((ρ:Kadiri.NontrivialZeros):ℂ) * Real.log 2)‖
        ≤ A * (k:ℝ)^2 * (2:ℝ)^((k:ℝ) * E) :=
```

