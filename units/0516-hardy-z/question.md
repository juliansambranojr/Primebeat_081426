> Source: session transcript, 2026-11-24

> Yes and loop please



From `lean_stage3/Stage3/HardyZ.lean`, the pinned statements:

```
theorem xi_line_real (t : ℝ) : (completedRiemannZeta (1/2 + t * Complex.I)).im = 0 :=
```

```
theorem signChange_zero_on_line {t₁ t₂ : ℝ} (h : t₁ ≤ t₂)
    (hs : (completedRiemannZeta (1/2 + t₁ * I)).re *
      (completedRiemannZeta (1/2 + t₂ * I)).re ≤ 0) :
    ∃ γ ∈ Set.Icc t₁ t₂, riemannZeta (1/2 + γ * I) = 0 :=
```

