> Source: session transcript, 2026-11-23

> T3 at a fixed row (the explicit formula above x²).



From `lean_stage3/Stage3/ExplicitLeft.lean`, the pinned statements:

```
theorem explicit_formula_left {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ∃ T' : ℝ, T ≤ T' ∧ T' ≤ T + 1 ∧
      ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
        ≤ Glue.c1n * x * Real.log (x*T)^2 / T + Glue.c3n * Real.log x
          + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ :=
```

```
theorem edge_left_any {x T' : ℝ} (hx : 16 ≤ x) (hT'2 : 2 ≤ T') :
    ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖
      ≤ Aleft * (Real.log T')^2 * x ^ (-(1:ℝ)/4) :=
```

```
theorem explicit_formula_any {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
      ≤ Glue.c1n * x * Real.log (x*T)^2 / T + Glue.c3n * Real.log x
        + Aleft * (Real.log (T+1))^2 * x ^ (-(1:ℝ)/4) :=
```

