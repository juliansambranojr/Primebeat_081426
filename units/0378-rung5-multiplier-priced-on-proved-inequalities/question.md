> Source: session transcript, 2026-11-22, after unit 0377

> Let's do A then C

A, from the assistant's message before it: "Finish section 16 as mathematics. Price the tree's bounds, then a module."

From `lean_stage3/Stage3/WeilPowerSharp.lean`, the tree's upper bound whose exponent this unit prices:

```
theorem norm_S_le_c_neg {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hre : (w ^ 2).re ≤ 0) :
```

and the lower bound at the target it uses as stated:

```
theorem S_real_ge_sharp {m : ℕ} {s : ℝ} (hs : 0 < s)
    (hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
```
