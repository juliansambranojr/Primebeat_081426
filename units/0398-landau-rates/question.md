> Source: session transcript, 2026-11-22, after unit 0397

> Keep going

From `lean_stage3/Stage3/LandauRates.lean`, the pinned statements:

```
theorem key_ineq {δ lam : ℝ} (hδ0 : 0 < δ) (hδ1 : δ ≤ 1) (hl0 : 0 ≤ lam)
    (hl : lam ≤ δ ^ 2 / 240) :
    4 * (lam - Real.log (1 - δ / 12)) < (1 + δ) * (Real.log (1 + δ / 3) - lam)
      ∧ 0 < Real.log (1 + δ / 3) - lam ∧ 0 < lam - Real.log (1 - δ / 12) := by
```

```
theorem exists_centre {ρ₀ : ℂ} {θ δ : ℝ} (hθ0 : 0 ≤ θ) (hθ : θ < ρ₀.re)
    (h1 : ρ₀.re < 1) (hδ : 0 < δ) :
    ∃ σ₀ : ℝ, 1 < σ₀ ∧ ‖(σ₀ : ℂ) - ρ₀‖ < σ₀ - θ
      ∧ ‖(σ₀ : ℂ) - ρ₀‖ ≤ (σ₀ - 1) * (1 + δ ^ 2 / 240) := by
```

```
theorem exists_pow_small {q c ε : ℝ} (hq0 : 0 ≤ q) (hq1 : q < 1) (hε : 0 < ε) :
    ∃ K : ℕ, ∀ k : ℕ, K ≤ k → c * q ^ k < ε := by
```
