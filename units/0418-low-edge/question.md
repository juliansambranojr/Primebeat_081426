> Source: session transcript, 2026-11-22, after unit 0415

> E7

From `lean_stage3/Stage3/LowEdge.lean`, the pinned statements:

```
theorem low_ball_count_wide {T' : ℝ} (h0 : 0 ≤ T') (h6 : T' ≤ 2) :
    (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 46 / 25)).toFinset,
      (analyticOrderNatAt gz w : ℝ)) ≤ 250 := by
```

```
theorem gz_partial_fraction_low {T' : ℝ} (h0T : 0 ≤ T') (h2T : T' ≤ 2) (u : ℂ)
    (him : u.im = T') (hre1 : -1/4 ≤ u.re) (hre2 : u.re ≤ 2) (hune : gz u ≠ 0) :
    ‖deriv gz u / gz u
        - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset,
            (analyticOrderNatAt gz w : ℂ) / (u - w)‖
      ≤ 1617537 := by
```

```
theorem logDerivZeta_short_segment {t : ℝ} (ht : |t| ≤ 2) :
    ‖deriv riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)
        / riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)‖ ≤ 1620000 := by
```

