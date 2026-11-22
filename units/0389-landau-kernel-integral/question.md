> Source: session transcript, 2026-11-22, after the worksheet check of blocks 2c, 4, 6 and 7

> Build 4a

From `lean_stage3/Stage3/LandauKernel.lean`, the pinned statements:

```
theorem log_pow_le {a : ℝ} (ha : 0 < a) (n : ℕ) {y : ℝ} (hy : 1 ≤ y) :
    Real.log y ^ n ≤ y ^ (a / 2) / (a / (2 * (n + 1))) ^ n := by
```

```
theorem log_pow_integrable {a : ℝ} (ha : 0 < a) (n : ℕ) :
    IntegrableOn (fun y : ℝ => Real.log y ^ n * y ^ (-a - 1)) (Ioi 1) := by
```

```
theorem log_pow_integral {a : ℝ} (ha : 0 < a) (k : ℕ) :
    ∫ y in Ioi (1 : ℝ), Real.log y ^ k * y ^ (-a - 1) = k.factorial / a ^ (k + 1) := by
```
