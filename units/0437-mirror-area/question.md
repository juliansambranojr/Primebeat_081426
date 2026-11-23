> Source: session transcript, 2026-11-22, after units 0435 and 0436

> Yes but look at the lean theroems I feel we chased a rectangle before. If not, let build

From `lean_stage3/Stage3/MirrorArea.lean`, the pinned statements:

```
theorem mirror_area {b : ℝ} (hb : 0 < b) (ρ : ℂ) :
    ‖(b : ℂ) ^ ρ‖ * ‖(b : ℂ) ^ (1 - ρ)‖ = b := by
```

```
theorem square_iff {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    (‖(b : ℂ) ^ ρ‖ = Real.sqrt b ∧ ‖(b : ℂ) ^ (1 - ρ)‖ = Real.sqrt b) ↔ ρ.re = 1 / 2 := by
```

```
theorem long_side_of_off_line {b : ℝ} (hb : 1 < b) {ρ : ℂ} (h : ρ.re ≠ 1 / 2) :
    Real.sqrt b < max ‖(b : ℂ) ^ ρ‖ ‖(b : ℂ) ^ (1 - ρ)‖ := by
```

