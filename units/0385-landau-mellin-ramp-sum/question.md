> Source: session transcript, 2026-11-22, after PR 2 was merged

> Start slice 2

From `lean_stage3/Stage3/LandauMellin.lean`, the pinned statements:

```
theorem rampK_integral {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 1 ≤ n) :
    ∫ y in Ioi (1 : ℝ), rampK s n y = (n : ℂ) ^ (-s) / (s * (s - 1)) := by
```

```
theorem rampK_integral_norm {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 1 ≤ n) :
    ∫ y in Ioi (1 : ℝ), ‖rampK s n y‖ = (n : ℝ) ^ (-s.re) / (s.re * (s.re - 1)) := by
```

```
theorem mellin_rampSum {s : ℂ} (hs : 1 < s.re) :
    ∫ y in Ioi (1 : ℝ), (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)
      = -deriv riemannZeta s / riemannZeta s / (s * (s - 1)) := by
```
