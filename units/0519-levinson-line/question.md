> Source: session transcript, 2026-11-24

> Go



From `lean_stage3/Stage3/LevinsonLine.lean`, the pinned statements:

```
theorem deriv_xi_line_im (t : ℝ) :
    (deriv completedRiemannZeta (1/2 + t * I)).re = 0 :=
```

```
theorem re_gammaR_G_line (c t : ℝ) :
    (Gammaℝ (1/2 + t * I) *
        (riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I))).re =
      (completedRiemannZeta (1/2 + t * I)).re *
        (1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re) :=
```

```
theorem zeta_line_zero_iff (c t : ℝ)
    (hc : 1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0) :
    riemannZeta (1/2 + t * I) = 0 ↔
      (Gammaℝ (1/2 + t * I) *
        (riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I))).re = 0 :=
```

