> Source: session transcript, 2026-11-23

> T3 at a fixed row (the explicit formula above x²).



From `lean_stage3/Stage3/LeftSmooth.lean`, the pinned statements:

```
theorem smooth_side {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖∫ t in (-T)..T, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
          / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
        + deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
      ≤ Bsm * x ^ (-(1:ℝ)/4) :=
```

```
theorem left_edge_bound {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖VIntegral (Glue.Gf x) (-1/4) (-T) T‖ ≤ Bleft * x ^ (-(1:ℝ)/4) :=
```

```
theorem explicit_formula_all {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
      ≤ Glue.c1n * x * Real.log (x*T)^2 / T + Glue.c3n * Real.log x
        + Bleft * x ^ (-(1:ℝ)/4) :=
```

