> Source: session transcript, 2026-11-25

> Yes



From `lean_stage3/Stage3/FloorConst.lean`, the pinned statements:

```
theorem Kfl_levinson_lt : Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) < Real.exp (13 / 10) :=
```

```
theorem kappa_levinson_ge : 1 / 3 ≤ kappaL (49 / 100) (13 / 10) :=
```

```
theorem floor_const :
    Tendsto (fun T => (Dop (Real.log T) (cY Polynomial.X (Mof T (49 / 100)) T)
      ((-((13 / 10) / Real.log T) : ℝ) : ℂ) ((-((13 / 10) / Real.log T) : ℝ) : ℂ)).re) atTop
      (𝓝 (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10))) ∧
    Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) < 13 / 10 ∧
    1 / 3 ≤ kappaL (49 / 100) (13 / 10) :=
```

