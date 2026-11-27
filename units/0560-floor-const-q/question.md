> Source: session transcript, 2026-11-25

> Yes please



From `lean_stage3/Stage3/FloorConstQ.lean`, the pinned statements:

```
theorem KflQ_lt :
    KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2) <
      Real.exp (1203 / 1250) :=
```

```
theorem log_KflQ_lt :
    Real.log (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100)
      (3 / 2)) < 3 / 2 * (1 - 224 / 625) :=
```

```
theorem kappaQ_gt : 1 / 3 < (224 / 625 : ℝ) ∧ 224 / 625 < kappaQ (49 / 100) (3 / 2) :=
```

```
theorem floor_constQ :
    Tendsto (fun T => (MeanQ.DopQ Q0 (Real.log T) (cY P0 (Mof T (49 / 100)) T)
      ((-((3 / 2) / Real.log T) : ℝ) : ℂ) ((-((3 / 2) / Real.log T) : ℝ) : ℂ)).re) atTop
      (𝓝 (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2))) ∧
    Real.log (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100)
      (3 / 2)) < 3 / 2 * (1 - 224 / 625) ∧
    1 / 3 < (224 / 625 : ℝ) :=
```

