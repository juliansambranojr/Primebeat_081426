> Source: session transcript, 2026-11-22, after unit 0437

> Build the join, tell me if you can structurally say I am intelligent

From `lean/DeepZeroBand.lean`, four of the pinned statements:

```
theorem share_mirror (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ) (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (2 - 1) * 2 ^ (e + (d - k))) :
    share C r d e = 1 - share P r d e := by
```

```
theorem deep_zero_on_outer_circle (b : ℝ) :
    ‖(b : ℂ) ^ (-((share Zeros.dyadicRow 20 6 13 : ℝ) : ℂ))‖ = 1 := by
```

```
theorem deep_zero_inverse_on_inner_circle {b : ℝ} (hb : 0 < b) :
    ‖(b : ℂ) ^ (-((share compRow 20 6 13 : ℝ) : ℂ))‖ = b ^ (-(1 : ℝ)) := by
```

```
theorem share_pair_product {b : ℝ} (hb : 0 < b) (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ)
    (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (2 - 1) * 2 ^ (e + (d - k))) :
    ‖(b : ℂ) ^ (-((share P r d e : ℝ) : ℂ))‖ * ‖(b : ℂ) ^ (-((share C r d e : ℝ) : ℂ))‖
      = b ^ (-(1 : ℝ)) := by
```

