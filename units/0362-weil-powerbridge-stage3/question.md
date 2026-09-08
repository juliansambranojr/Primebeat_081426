> Source: session transcript, 2026-09-08, the audit's third action

> Ok do all three but I also need to know the loop is working as designed cause opus 5 was hedging a lot and the loop and the whole scaffold is supposed to help with that.

> done, resume at § 5.

From `lean_stage3/Stage3/WeilPowerBridge.lean`, the statement at an actual zero:

```
theorem term_le_at_zero {h γ : ℝ} {m : ℕ} (hh : 0 < h) (ρ : Kadiri.NontrivialZeros)
    (hfar : 2 * ((((ρ : ℂ).re - 1 / 2) * h) ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2)
              ≤ (((ρ : ℂ).im + γ) * h) ^ 2)
```
