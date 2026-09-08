> Source: session transcript, 2026-09-07, after unit 0359 and the question about what relies on the route staying open

> If we mark it as dead, what is an open route that we didn’t have before?

> Ok log it all in the notebook and then go

From `lean_stage3/Stage3/WeilPowerPhase.lean`, the factorization this unit prices:

```
theorem norm_S_sub_le {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
```

```
def P (m : ℕ) (w : ℂ) : ℂ := Complex.exp (w ^ 2 * ((sigma m : ℝ) : ℂ))
```
