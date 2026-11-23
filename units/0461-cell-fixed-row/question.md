> Source: session transcript, 2026-11-23

> T3 at a fixed row (the explicit formula above x²).



From `lean_stage3/Stage3/CellFixedRow.lean`, the pinned statements:

```
theorem cell_eq_zero_sum_all (d : ℕ) (r : ℤ) {T : ℝ} (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d
        + ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
            ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                  * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                  / ((ρ : Kadiri.NontrivialZeros) : ℂ))‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + LeftSmooth.Bleft * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4)) :=
```

```
theorem cell_zero_sum_finset_all (d : ℕ) (r : ℤ) {T : ℝ} (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF T, term d r ρ‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + LeftSmooth.Bleft * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4)) :=
```

```
theorem cell_fixed_row (d : ℕ) (r : ℕ) (hr : d + 4 ≤ r) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
          - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
          + ∑ ρ ∈ ZF T, term d (r : ℤ) ρ‖
        ≤ 2 ^ d * (Glue.c3n * Real.log 2 * r + LeftSmooth.Bleft) + ε :=
```

