> Source: session transcript, 2026-11-22, after unit 0387

> Sharper bound please

From `lean_stage3/Stage3/LandauChebyshev.lean`, the pinned statements:

```
theorem rampSum_le_log {y : ℝ} (hy : 1 ≤ y) :
    LandauWindow.rampSum y ≤ y * (Real.log y + (Real.log 4 + 4)) := by
```

```
theorem G_le {y : ℝ} (hy : 1 ≤ y) : LandauWindow.G y ≤ 8 * y := by
```

```
theorem abs_G_le_log {y : ℝ} (hy : 1 ≤ y) :
    |LandauWindow.G y| ≤ 8 * y * (1 + Real.log y) := by
```
