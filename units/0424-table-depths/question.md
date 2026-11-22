> Source: session transcript, 2026-11-22, after unit 0423

> Do both

From the assistant's message before it: "Shall I do both?"

From `lean_stage3/Stage3/TableDepths.lean`, the pinned statements:

```
theorem cell_ne_zero_gen (hRH : RiemannHypothesis) (d : ℕ) {r₀ a : ℝ} (hd : d ≤ 24)
    (hfloor : 72 + ((d:ℝ) + 1) ≤ r₀)
    (hA : 414 * (2 * 3 ^ (d + 1)) * (r₀ ^ 2 * (2:ℝ) ^ (-((r₀ - ((d:ℝ) + 1)) / 2))) ≤ a)
    (ha : a * Real.log 2 < Real.log 2 ^ d)
    {r : ℤ} (hr : r₀ ≤ (r:ℝ)) :
    Construction.tableFrom TableRoute.rowN r d ≠ 0 := by
```

```
theorem depth_one (hRH : RiemannHypothesis) {r : ℤ} (hr : 74 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 1 ≠ 0 := by
```

```
theorem depth_seven (hRH : RiemannHypothesis) {r : ℤ} (hr : 85 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 7 ≠ 0 := by
```

```
theorem depth_eight (hRH : RiemannHypothesis) {r : ℤ} (hr : 91 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 8 ≠ 0 := by
```

