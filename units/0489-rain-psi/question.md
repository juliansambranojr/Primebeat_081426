> Source: session transcript, 2026-11-23

> You don't know when exactly but at some point  you can see the rain is coming



From `lean_stage3/Stage3/RateBelow.lean`, the pinned statements:

```
theorem rain_psi (ρ₀ : NontrivialZeros) {θ : ℝ} (hθ : θ < (ρ₀ : ℂ).re)
    (C : ℝ) (k : ℕ) (x₀ : ℝ) :
    ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ θ * Real.log x ^ k < |Chebyshev.psi x - x| :=
```

