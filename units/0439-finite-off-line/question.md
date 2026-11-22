> Source: session transcript, 2026-11-22, after unit 0438

> go for all of it, i feel like we are aligned

The first of the items offered in the assistant's message before it: "the finite-off-line conditional theorem for joint 10".

From `lean_stage3/Stage3/FiniteOffLine.lean`, the pinned statements:

```
theorem sum_order_onLineInv_le (K : ℕ) :
    ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ
      ≤ 2 * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹
          * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket) := by
```

```
theorem err_le (d K r : ℕ) (hr : r = d + K + 1) :
    ∑ j ∈ range (d + 1), (d.choose j : ℝ)
        * (Glue.c1n * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
              * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * (2:ℝ) ^ (K + 1)) ^ 2 / (2:ℝ) ^ (K + 1)
            + Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
            + Glue.c4n * ((Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))) ^ 2
                * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4)))
      ≤ 2 ^ d * ((4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n) * (r : ℝ) ^ 2) := by
```

```
theorem finite_off_line (F : Finset NontrivialZeros)
    (hF : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≠ 1 / 2 → ρ ∈ F) (d : ℕ) (C : ℝ)
    (hcells : ∀ᶠ r : ℕ in atTop,
      ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
          - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d‖ ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    RiemannHypothesis := by
```

