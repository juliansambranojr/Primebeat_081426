> Source: session transcript, 2026-11-23

> So try, it's possible



From `lean_stage3/Stage3/FilterAccum.lean`, the pinned statements:

```
theorem finite_accumulation_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ : ℝ} (hσ : 1/2 < σ) (P : Finset ℂ) (hP0 : ∀ p ∈ P, p ≠ 0)
    (hacc : ∀ ε : ℝ, 0 < ε →
      {z : ℂ | ∃ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re ∧ (2:ℂ) ^ (ρ : ℂ) = z ∧
        ∀ p ∈ P, ε ≤ ‖z - p‖}.Finite)
    (ρ₁ : Kadiri.NontrivialZeros) (hρ₁ : σ < (ρ₁ : ℂ).re) (hρ₁P : (2:ℂ) ^ (ρ₁ : ℂ) ∉ P) :
    False :=
```

```
theorem rh_of_finite_accumulation {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (hfin : ∀ σ : ℝ, 1/2 < σ → ∃ P : Finset ℂ, (∀ p ∈ P, p ≠ 0) ∧
      (∀ ε : ℝ, 0 < ε → {z : ℂ | ∃ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re ∧
        (2:ℂ) ^ (ρ : ℂ) = z ∧ ∀ p ∈ P, ε ≤ ‖z - p‖}.Finite) ∧
      (∀ ρ : Kadiri.NontrivialZeros, σ < (ρ : ℂ).re → (2:ℂ) ^ (ρ : ℂ) ∉ P)) :
    RiemannHypothesis :=
```

