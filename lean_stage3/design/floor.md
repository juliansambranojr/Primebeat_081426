# The explicit formula from `x = 2` — the floor

Read first after any compaction. Blocks G1, G2. 2026-11-23.

## Where the floor of 16 enters

`LeftSmooth.explicit_formula_all` asks `16 ≤ x`. Its chain was read lemma by
lemma for every use of the floor (read-only inventory, 2026-11-23). No use
needs `x` large in substance. The floor bites in four places:

- `x ≥ 3`: `PerronKernel.near_diagonal_sum`, `h5 : 3*x ≤ x^2`, and
  `1 + log(3x) ≤ 3·log x` from `1 < log x`. For `x ≥ 2`:
  `1 + log(3x) ≤ 5·log x`; the stated bound still holds.
- `x ≥ e`: the abscissa `c = 1 + 1/log x ≤ 2`. Used in
  `PerronKernel.far_terms_sum` (`δ = 1/log x ≤ 1` for
  `one_sub_two_neg_rpow`), `kernel_sum_bound` (`(x/n)^c ≤ e`), and
  `Glue.edge_horizontal_bound_num` (the good bound on `ζ'/ζ` holds for
  `Re ≤ 2`; edge length `≤ 9/4`). For `x ≥ 2`: `c ≤ 5/2`.
- `x ≥ e²`: `ExplicitLeft.explicit_formula_left`, `he3 : K0 ≤ K0/2·log x`.
  For `x ≥ 2`: `K0 ≤ (K0/log 2)·log x`.
- `x ≥ 16` itself: `Bser`, `Bsm` are defined with `log 16`. For `x ≥ 2`:
  `log 2`, four times larger.

`far_terms_sum` also uses `e ≤ x·T`, which at `x = 2` needs `T ≥ 2`.
`delta_sum_close`, `kernel_diff_summable`, `perron_sum_eq_integral`,
`ContourShift.residue_identity`, `Glue.zeroPartialSum_swap_num` carry
`16 ≤ x` in their statements and use only `1 < x` or `1 ≤ x`.

## The route

A parallel chain in new files, for every `x ≥ 2`, with its own constants. No
proved file is edited; no existing constant changes (`RouteNum`, `GateEval`
pin `c1n`, `c3n`). The new constants are larger than the old, so the new
theorem stands beside the old one.

## G1 Perron's formula from 2 — PROVED (unit 0463: `PerronTwo.explicit_formula_perron_two`, constants 700 and 18 as below; the bound behind `c ≤ 5/2` is `1/log x ≤ 3/2`; `near_diagonal_sum` also uses the floor in `Λ(n) ≤ 2·log x`, which holds from 2)

    explicit_formula_perron_two (hx : 2 ≤ x) (hT : 2 ≤ T) :
      ‖ψ x − (2πi)⁻¹·∫_{-T}^{T} (−ζ'/ζ)(c+it)·x^(c+it)/(c+it)·i dt‖
        ≤ 700·x·log²(xT)/T + 18·log x,      c = 1 + 1/log x

- `one_sub_two_neg_rpow'`: `0 < δ ≤ 5/2 ⊢ δ/5 ≤ 1 − 2^(−δ)`.
- `far_terms_sum_two`: `≤ 300·x·log²(xT)/T`, as before.
- `near_diagonal_sum_two`: `≤ 100·x·log²(xT)/T + 4·log x`, as before.
- `kernel_sum_bound_two`: `c ≤ 5/2`, `(x/n)^c ≤ e^(5/4) < 4` near the
  diagonal: `≤ 700·x·log²(xT)/T + 17·log x`.
- copies at `1 < x` of `delta_sum_close`, `kernel_diff_summable`,
  `perron_sum_eq_integral`; then `perron_to_psi_two`.

## G2 The contour from 2 — PROVED (unit 0464: `ExplicitTwo.explicit_formula_all_two`, constants as below; `Cpn_ge : 360 ≤ Cpn` puts the bound 6 under `Cpn·log²T`, so the good bound keeps its constant)

    explicit_formula_all_two (hx : 2 ≤ x) (hT : 2 ≤ T) :
      ‖ψ x − x + zeroPartialSum x T‖
        ≤ c1t·x·log²(xT)/T + c3t·log x + Bleft2·x^(−1/4)

- copies at `1 < x` of `residue_identity`, `zeroPartialSum_swap_num`.
- `logDeriv_re_ge_two`: `Re u ≥ 2 ⊢ ‖ζ'/ζ(u)‖ ≤ 6`
  (`Slice5.norm_logDerivZeta_of_one_lt_re`); the good bound extended to
  `−1/4 ≤ Re u ≤ 5/2`.
- `edge_horizontal_bound_two`: `Cht = Cpn·3·(11/4)`.
- `explicit_formula_left_two`: `c1t = 2800 + 2·Cht + Csn`,
  `c3t = 18 + K0/log 2`; `1 ≤ log(xT)` from `4 ≤ x·T`.
- `series_side_two`, `smooth_side_two`, `left_edge_bound_two`:
  `Bleft2 = 4·Bleft`.

## G3 The fixed row at every row — PROVED (unit 0465: `FixedRowTwo.cell_fixed_row_two`, `pi_fixed_row_two`, `table_cell_fixed_row_two`; `Api2 = (3/2)·c3t + (9/4)·Bleft2`, the count's bound is `Api2·(1 + log x)`, the table cell's `2^(d+1)·Api2·(1 + log 2·r)`)

`CellFixedRow` and `PiFixedRow` read `LeftSmooth.explicit_formula_all` and
carry its floor: `r ≥ d + 4`, `r ≥ d + 6`, `x ≥ 16`. On
`ExplicitTwo.explicit_formula_all_two` the same proofs reach the lowest rows.

- `cell_eq_zero_sum_two`, `cell_fixed_row_two (hr : d + 1 ≤ r)`: the cell of
  `ψ`; the stencil reads rows `r − j ≥ 1`, `2^(r−j) ≥ 2`. What stays:
  `2^d·(c3t·log 2·r + Bleft2)`.
- `tr_efRem_fixed_two (hx : 2 ≤ x)`: the passage of the remainder. The whole
  integral `∫₂ˣ` is read from the formula; no stretch below the floor is
  left, so `PiFixedRow.norm_low_integral_le` is not used.
- `pi_fixed_row_two (hx : 2 ≤ x)`, `table_cell_fixed_row_two (hr : d + 2 ≤ r)`:
  the count and the table's cell. `d + 2 ≤ r` is the hypothesis of
  `PiZeros.table_cell_eq_zero_sum` itself.
