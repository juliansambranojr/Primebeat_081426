> Source: session transcript, 2026-11-24

> I do but What if the room left is for the b-adic

The question it answers, from the transcript:

> Do you want the ranking logged as a unit?

From `lean_stage3/Stage3/ZeroDensity.lean`, the strongest return in the tree:

```
theorem zero_density {σ : ℝ} (hσ : 1 / 2 < σ) (hσ1 : σ ≤ 1) :
    ∃ θ C T₀ : ℝ, θ < 1 ∧ 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ Z : Finset ℂ,
      (∀ ρ ∈ Z, riemannZeta ρ = 0 ∧ σ ≤ ρ.re ∧ ρ.re < 1 ∧ 2 ≤ ρ.im ∧ ρ.im ≤ T - 2) →
      (Z.card : ℝ) ≤ C * T ^ θ := by
```
