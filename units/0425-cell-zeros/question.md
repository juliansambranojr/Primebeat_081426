> Source: session transcript, 2026-11-22, after unit 0424

> And then start on this "The theorem that says what you have been saying already exists in your table tree, with one hypothesis left open."

From `lean_stage3/Stage3/CellZeros.lean`, the definition and the pinned statements:

```
/-- The `d`-fold backward difference of a row, read at `r`. -/
def stencil (d : ℕ) (a : ℤ → ℂ) (r : ℤ) : ℂ :=
  ∑ j ∈ range (d + 1), (-1 : ℂ) ^ j * (d.choose j : ℂ) * a (r - j)
```

```
theorem stencil_mode {w : ℂ} (hw : w ≠ 0) (d : ℕ) (r : ℤ) :
    stencil d (fun n : ℤ => w ^ n) r = w ^ r * (1 - w⁻¹) ^ d := by
```

```
theorem stencil_zeroPartialSum (d : ℕ) (r : ℤ) (T : ℝ) :
    stencil d (fun n : ℤ => Stage3.zeroPartialSum ((2:ℝ) ^ n) T) r
      = ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
          ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
            * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                / ((ρ : Kadiri.NontrivialZeros) : ℂ)) := by
```

```
theorem cell_eq_zero_sum (d : ℕ) (r : ℤ) {T : ℝ} (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) (hTx : T ≤ ((2:ℝ) ^ (r - (d : ℤ))) ^ 2) :
    ‖stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d
        + ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
            ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                  * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                  / ((ρ : Kadiri.NontrivialZeros) : ℂ))‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + Glue.c4n * ((Real.log ((2:ℝ) ^ (r - (j : ℤ)))) ^ 2
                  * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4))) := by
```

