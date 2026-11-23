> Source: session transcript, 2026-11-23

> With explicit_formula_all that remainder can now be taken at any height.



From `lean_stage3/Stage3/PiFixedRow.lean`, the pinned statements:

```
theorem sum_order_inv_sq_le (T : ℝ) :
    ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (‖(ρ : ℂ)‖⁻¹) ^ 2 ≤ Z2 :=
```

```
theorem norm_low_integral_le (T : ℝ) :
    ‖∫ t in (2:ℝ)..16, efRem T t * wt t‖ ≤ Clow :=
```

```
theorem tr_efRem_fixed {x : ℝ} (hx : 16 ≤ x) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop, ‖tr (efRem T) x‖ ≤ Api * Real.log x + ε :=
```

```
theorem pi_fixed_row {x : ℝ} (hx : 16 ≤ x) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
          + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
          + tr psiTheta x‖ ≤ Api * Real.log x + ε :=
```

```
theorem table_cell_fixed_row (r : ℕ) (d : ℕ) (hr : d + 6 ≤ r) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖((((Construction.tableFrom TableRoute.rowN (r : ℤ) d : ℤ) : ℝ)
          - Nonvanishing.stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) (r : ℤ)
            : ℝ) : ℂ)
        + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
            * CellZeros.stencil (d + 1) (fun m : ℤ => piMode (ρ : ℂ) ((2:ℝ) ^ (m : ℝ))) (r : ℤ)
        + CellZeros.stencil (d + 1) (fun m : ℤ => tr psiTheta ((2:ℝ) ^ (m : ℝ))) (r : ℤ)‖
        ≤ 2 ^ (d + 1) * (Api * Real.log 2 * r) + ε :=
```

