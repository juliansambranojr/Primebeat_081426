> Source: session transcript, 2026-11-23

> T3 at a fixed row (the explicit formula above x²).



From `lean_stage3/Stage3/LeftKernel.lean`, the pinned statements:

```
theorem osc_by_parts {y a b : ℝ} (hy : 1 < y) (hab : a ≤ b) {h h' : ℝ → ℂ}
    (hd : ∀ t ∈ Set.uIcc a b, HasDerivAt h (h' t) t)
    (hi : IntervalIntegrable h' volume a b) :
    ‖∫ t in a..b, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * h t‖
      ≤ (‖h a‖ + ‖h b‖ + ∫ t in a..b, ‖h' t‖) / Real.log y :=
```

```
theorem kernel_bound {y T a : ℝ} (hy : 1 < y) (hT : 0 < T) (ha : a ≠ 0) :
    ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) / ((a:ℂ) + (t:ℂ) * Complex.I)‖
      ≤ (2 / T + Real.pi / |a|) / Real.log y :=
```

```
theorem series_side {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖∫ t in (-T)..T, (deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
        / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
      ≤ Bser * x ^ (-(1:ℝ)/4) :=
```

