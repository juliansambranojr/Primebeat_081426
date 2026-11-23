> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/AttainedPi.lean`, the pinned statements:

```
theorem attained_off_line_pi (ρ₀ : Kadiri.NontrivialZeros)
    (hmax : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) (C : ℝ)
    (hrows : ∀ᶠ r : ℕ in Filter.atTop,
      |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
        ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    RiemannHypothesis :=
```

```
theorem fin_bound {Θ θ₁ C M ε : ℝ} (hΘ : 1 / 2 < Θ) (hθ₁ : 1 / 2 ≤ θ₁)
    (hmax : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≤ Θ)
    (hM : ∀ v : Finset NontrivialZeros, (∀ ρ ∈ v, Θ ≤ (ρ : ℂ).re) →
      ∑ ρ ∈ v, ZeroSummable.w ρ ≤ M)
    (hband : ∀ F : Finset NontrivialZeros, (∀ ρ ∈ F, θ₁ < (ρ : ℂ).re ∧ (ρ : ℂ).re < Θ) →
      ∑ ρ ∈ F, ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ ε)
    {r : ℕ} (hr : 12 ≤ r)
    (hrow : |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
      ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    ‖∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r‖
      ≤ slack Θ θ₁ C M ε r + 2 * ε * ((2:ℝ) ^ Θ) ^ r :=
```

```
theorem band_small {Θ : ℝ} (hΘ : 1 / 2 < Θ) {ε : ℝ} (hε : 0 < ε) :
    ∃ η : ℝ, 0 < η ∧ η ≤ (Θ - 1 / 2) / 2 ∧ ∀ F : Finset NontrivialZeros,
      (∀ ρ ∈ F, Θ - η < (ρ : ℂ).re ∧ (ρ : ℂ).re < Θ) →
        ∑ ρ ∈ F, ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ ε :=
```

