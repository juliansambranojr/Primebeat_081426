> Source: session transcript, 2026-09-08, rung 5 after unit 0366

> What about this? price the whole term on term_le_at_zero, the tree's object, naming the quantifier

From `lean_stage3/Stage3/WeilPowerBridge.lean`, the object the script computes on:

```
theorem term_le_at_zero {h γ : ℝ} {m : ℕ} (hh : 0 < h) (ρ : Kadiri.NontrivialZeros)
    (hfar : 2 * ((((ρ : ℂ).re - 1 / 2) * h) ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2)
              ≤ (((ρ : ℂ).im + γ) * h) ^ 2)
    (hne : QS m (wm h γ (ρ : ℂ)) ≠ 0)
    (hsmall : ‖wm h γ (ρ : ℂ)‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    (hq : q m (wm h γ (ρ : ℂ)) ≤ 1) :
    WeilPowerBands.termW h γ m (ρ : ℂ) ≤ ...
```
