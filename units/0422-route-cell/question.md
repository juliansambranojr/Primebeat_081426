> Source: session transcript, 2026-11-22, after unit 0420

> E9

From `lean/RouteCell.lean`, the pinned statement:

```
theorem cell_ne_zero_of_route {N : ℤ → ℤ} {f : ℤ → ℝ} {r : ℤ} (hr : 80 ≤ r)
    (hrow : ∀ k ∈ Finset.range (6 + 2),
      ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hroute : ∃ ρ : ℝ, RelativeGate.StmtRelErrWindow f
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r (6 + 1) ρ
      ∧ ρ < Real.log 2 ^ 6 / (2 * r * 3 ^ (6 + 1))) :
    Construction.tableFrom N r 6 ≠ 0 := by
```
