> Source: session transcript, 2026-11-25

> Yes log it and avoidance



From `lean_stage3/Stage3/LevinsonAvoid.lean`, the pinned statements:

```
theorem exists_good_height {f : ℂ → ℂ} {σ₀ X t₀ : ℝ}
    (hf : AnalyticOnNhd ℂ f (Rectangle ((σ₀ : ℂ) + t₀ * I) ((X : ℂ) + (t₀ + 1 : ℝ) * I)))
    (hne : ∃ p ∈ Rectangle ((σ₀ : ℂ) + t₀ * I) ((X : ℂ) + (t₀ + 1 : ℝ) * I), f p ≠ 0) :
    ∃ t ∈ Icc t₀ (t₀ + 1), ∀ x ∈ Icc σ₀ X, f ((x : ℂ) + t * I) ≠ 0 :=
```

```
theorem exists_good_abscissa {f : ℂ → ℂ} {σ₀ δ X a b : ℝ} (hδ : 0 < δ) (hX : σ₀ ≤ X)
    (hf : AnalyticOnNhd ℂ f (Rectangle (((σ₀ - δ : ℝ) : ℂ) + a * I) ((X : ℂ) + b * I)))
    (hne : ∃ p ∈ Rectangle (((σ₀ - δ : ℝ) : ℂ) + a * I) ((X : ℂ) + b * I), f p ≠ 0) :
    ∃ σ ∈ Icc (σ₀ - δ) σ₀, ∀ y ∈ Icc a b, f ((σ : ℂ) + y * I) ≠ 0 :=
```

```
theorem factor_pos {T t : ℝ} (hT : Real.exp 26 ≤ T) (ht : t ∈ Icc 4 T) :
    0 < 1 - (1 / Real.log T) *
      (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re :=
```

