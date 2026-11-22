> Source: session transcript, 2026-11-22, after unit 0440

> go for all of it, i feel like we are aligned

The fourth of the items offered in the assistant's message before it: "T2 and T3". This unit is T3.

From `lean_stage3/Stage3/CellRows.lean`, the pinned statements:

```
theorem cell_eq_zero_sum_rows (d K r : ℕ) (hr : r = d + K + 1) (hK : 3 ≤ K) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
        - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
        + ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)), term d (r : ℤ) ρ‖
      ≤ 2 ^ d * ((4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n) * (r : ℝ) ^ 2) := by
```

```
theorem cell_tail_tendsto (d : ℕ) :
    Tendsto (fun r : ℕ =>
      ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
          - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
          + ∑ ρ ∈ ZF ((2:ℝ) ^ (r - d)), term d (r : ℤ) ρ‖ / Real.sqrt 2 ^ r)
      atTop (𝓝 0) := by
```

