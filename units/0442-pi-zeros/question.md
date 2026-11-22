> Source: session transcript, 2026-11-22, after unit 0440

> go for all of it, i feel like we are aligned

The fourth of the items offered in the assistant's message before it: "T2 and T3". This unit is T2.

From `lean_stage3/Stage3/PiZeros.lean`, the pinned statements:

```
theorem pi_eq_zero_sum {x : ℝ} (hx : 2 ≤ x) (T : ℝ) :
    (((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
      = -∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
        + tr (efRem T) x - tr psiTheta x := by
```

```
theorem norm_tr_psiTheta_le {x : ℝ} (hx : 2 ≤ x) : ‖tr psiTheta x‖ ≤ 8 * Real.sqrt x := by
```

```
theorem table_cell_eq_zero_sum (r : ℤ) (d : ℕ) (hr : (d : ℤ) + 2 ≤ r) (T : ℝ) :
    ((((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ)
        - Nonvanishing.stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r : ℝ) : ℂ)
      = -∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
            * CellZeros.stencil (d + 1) (fun m : ℤ => piMode (ρ : ℂ) ((2:ℝ) ^ (m : ℝ))) r
        + CellZeros.stencil (d + 1) (fun m : ℤ => tr (efRem T) ((2:ℝ) ^ (m : ℝ))) r
        - CellZeros.stencil (d + 1) (fun m : ℤ => tr psiTheta ((2:ℝ) ^ (m : ℝ))) r := by
```

