> Source: session transcript, 2026-11-22, after unit 0390

> 4b

From `lean_stage3/Stage3/LandauTail.lean`, the pinned statements:

```
theorem lower_tail_le {a b : ℝ} (ha : 0 < a) (hb : 0 < b) (k : ℕ) {Y : ℝ} (hY : 1 ≤ Y) :
    ∫ y in Ioc (1 : ℝ) Y, Real.log y ^ k * y ^ (-a - 1)
      ≤ Y ^ b * (k.factorial / (a + b) ^ (k + 1)) := by
```

```
theorem upper_tail_le {a b : ℝ} (hb : 0 < b) (hba : b < a) (k : ℕ) {Z : ℝ} (hZ : 1 ≤ Z) :
    ∫ y in Ioi Z, Real.log y ^ k * y ^ (-a - 1)
      ≤ Z ^ (-b) * (k.factorial / (a - b) ^ (k + 1)) := by
```
