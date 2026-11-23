> Source: session transcript, 2026-11-23

> The runs should be theorems.



From `lean_stage3/Stage3/RunTheorems.lean`, the pinned statements:

```
theorem mode_fold (ρ : ℂ) (k : ℤ) :
    (2:ℂ) ^ (ρ + 2 * Real.pi * Complex.I * (k : ℂ) / (Real.log 2 : ℂ)) = (2:ℂ) ^ ρ :=
```

```
theorem mode_cross (ρ₁ ρ₂ : ℂ) :
    (2:ℂ) ^ ρ₁ * (starRingEnd ℂ) ((2:ℂ) ^ ρ₂)
      = Complex.exp ((((ρ₁.re + ρ₂.re) * Real.log 2 : ℝ) : ℂ)
          + (((ρ₁.im - ρ₂.im) * Real.log 2 : ℝ) : ℂ) * Complex.I) :=
```

```
theorem two_mode_beat (c₁ c₂ z₁ z₂ : ℂ) (k : ℕ) :
    ‖c₁ * z₁ ^ k + c₂ * z₂ ^ k‖ ^ 2
      = ‖c₁ * z₁ ^ k‖ ^ 2 + ‖c₂ * z₂ ^ k‖ ^ 2
        + 2 * (c₁ * (starRingEnd ℂ) c₂ * (z₁ * (starRingEnd ℂ) z₂) ^ k).re :=
```

```
theorem zero_pair_beat (c₁ c₂ ρ₁ ρ₂ : ℂ) (k : ℕ) :
    (c₁ * (starRingEnd ℂ) c₂ * ((2:ℂ) ^ ρ₁ * (starRingEnd ℂ) ((2:ℂ) ^ ρ₂)) ^ k)
      = c₁ * (starRingEnd ℂ) c₂
          * ((((2:ℝ) ^ ((ρ₁.re + ρ₂.re) * (k:ℝ)) : ℝ) : ℂ)
            * Complex.exp ((((k:ℝ) * ((ρ₁.im - ρ₂.im) * Real.log 2) : ℝ) : ℂ) * Complex.I)) :=
```

