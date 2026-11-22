> Source: session transcript, 2026-11-22, after unit 0412

> 1 and 2

From the assistant's message before it: "1. The `Li(2^m) = liRow m` lemma in Stage 3, which closes the gap above. Short." and "2. `K0 = log 2π` as a lemma. Short."

From `lean_stage3/Stage3/RowLeaves.lean`, the pinned statements:

```
theorem hasDerivAt_Li {y : ℝ} (hy : 1 < y) : HasDerivAt Li (1 / Real.log y) y := by
```

```
theorem Li_two_rpow {x : ℝ} (hx : 0 < x) :
    Li ((2 : ℝ) ^ x)
      = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp (Real.log 2 * t) / t := by
```

```
theorem norm_logDerivZeta_zero :
    ‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2 * Real.pi) := by
```

