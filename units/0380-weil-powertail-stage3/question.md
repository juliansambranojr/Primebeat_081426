> Source: session transcript, 2026-11-22, after unit 0379

> Go ahead with the cache fetch and start Cgo ahead

> Let's do A then C

From `lean_stage3/Stage3/WeilPowerTail.lean`, the pinned statement:

```
theorem norm_S_le_tail {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0) :
    ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re * sigma m
      + ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
```

and the elementary inequality under it:

```
theorem norm_one_add_le (z : ℂ) : ‖1 + z‖ ≤ Real.exp (z.re + ‖z‖ ^ 2 / 2) := by
```
