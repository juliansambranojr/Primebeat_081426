> Source: session transcript, 2026-11-23

> Ok do it



From `lean_stage3/Stage3/FixedRowTwo.lean`, the pinned statements:

```
theorem cell_eq_zero_sum_two (d : ℕ) (r : ℤ) {T : ℝ} (h2 : 2 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d
        + ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
            ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                  * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                  / ((ρ : Kadiri.NontrivialZeros) : ℂ))‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (ExplicitTwo.c1t * (2:ℝ) ^ (r - (j : ℤ))
              * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + ExplicitTwo.c3t * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + ExplicitTwo.Bleft2 * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4)) :=
```

```
theorem cell_fixed_row_two (d : ℕ) (r : ℕ) (hr : d + 1 ≤ r) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
          - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
          + ∑ ρ ∈ FiniteOffLine.ZF T, FiniteOffLine.term d (r : ℤ) ρ‖
        ≤ 2 ^ d * (ExplicitTwo.c3t * Real.log 2 * r + ExplicitTwo.Bleft2) + ε :=
```

```
theorem tr_efRem_fixed_two {x : ℝ} (hx : 2 ≤ x) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖PiZeros.tr (PiZeros.efRem T) x‖ ≤ Api2 * (1 + Real.log x) + ε :=
```

```
theorem pi_fixed_row_two {x : ℝ} (hx : 2 ≤ x) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
          + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
          + tr psiTheta x‖ ≤ Api2 * (1 + Real.log x) + ε :=
```

```
theorem table_cell_fixed_row_two (r : ℕ) (d : ℕ) (hr : d + 2 ≤ r) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖((((Construction.tableFrom TableRoute.rowN (r : ℤ) d : ℤ) : ℝ)
          - Nonvanishing.stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) (r : ℤ)
            : ℝ) : ℂ)
        + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
            * CellZeros.stencil (d + 1) (fun m : ℤ => piMode (ρ : ℂ) ((2:ℝ) ^ (m : ℝ))) (r : ℤ)
        + CellZeros.stencil (d + 1) (fun m : ℤ => tr psiTheta ((2:ℝ) ^ (m : ℝ))) (r : ℤ)‖
        ≤ 2 ^ (d + 1) * (Api2 * (1 + Real.log 2 * r)) + ε :=
```

