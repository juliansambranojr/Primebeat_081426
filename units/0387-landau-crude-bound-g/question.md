> Source: session transcript, 2026-11-22, after unit 0386

> Block 5 next

From `lean_stage3/Stage3/LandauCrude.lean`, the pinned statements:

```
theorem rampSum_nonneg (y : ℝ) : 0 ≤ LandauWindow.rampSum y := by
```

```
theorem rampSum_le {y : ℝ} (hy : 1 ≤ y) :
    LandauWindow.rampSum y ≤ y * Real.log y * (1 + Real.log y) := by
```

```
theorem abs_G_le {y : ℝ} (hy : 1 ≤ y) :
    |LandauWindow.G y| ≤ 2 * y * (1 + Real.log y) ^ 2 := by
```
