> Source: session transcript, 2026-11-22, after unit 0415

> E7

From `lean_stage3/Stage3/LowCount.lean`, the pinned statements:

```
theorem gz_c0_lower (T' : ℝ) : 1 / 14 ≤ ‖gz (c0 T')‖ := by
```

```
theorem low_ball_count {T' : ℝ} (h0 : 0 ≤ T') (h6 : T' ≤ 6) :
    (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 8 / 5)).toFinset,
      (analyticOrderNatAt gz w : ℝ)) ≤ 119 := by
```

```
theorem low_rect_count :
    (∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0 : ℂ)
        ((1 : ℝ) + Complex.I * (6 : ℝ))).toFinset,
      (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ 714 := by
```
