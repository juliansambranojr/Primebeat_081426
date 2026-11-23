# The explicit formula at every height — the left edge

Read first after any compaction. Blocks F1 to F3. 2026-11-23.

## Where the cap enters

`Glue.explicit_formula_split_num` (`Stage3/GlueNum.lean`) asks `T ≤ x²`. Its
proof uses the cap once: `hT'2x : T' ≤ 2*x^2`, passed to
`Glue.edge_left_sharp_num`, which uses it once, to write `log T' ≤ 3·log x`.
Perron (`PerronKernel.explicit_formula_perron`), the residue identity
(`ContourShift.residue_identity`), the two horizontal edges
(`edge_horizontal_bound_num`) and the swap of heights
(`zeroPartialSum_swap_num`) carry no cap. A scratch build with the hypothesis
deleted fails at `hT'2x` and nowhere else.

## The lost factor

The left edge is `VIntegral (Gf x) (-1/4) (-T') T'`, the integral of
`−ζ'/ζ(s)·x^s/s` up the line `Re s = −1/4`. The tree bounds it in absolute
value: `|ζ'/ζ| ≤ C·log T'` on the line, `|x^s| = x^(−1/4)`, `∫ dt/(1/4+|t|)`
of size `log T'`. The bound is `C·log²T'·x^(−1/4)`. It grows with the height.
The proof is right; an absolute value on that line loses `log²T'`. The
integral itself stays bounded: `x^(it)` turns.

## F1 The formula with the left edge kept — PROVED (unit 0458: `ExplicitLeft.explicit_formula_left`, `edge_left_any`, `explicit_formula_any`; `Aleft = 8·Dln`)

    explicit_formula_left (hx : 16 ≤ x) (hT : 2 ≤ T) :
      ∃ T', T ≤ T' ∧ T' ≤ T + 1 ∧
        ‖ψ x − x + zeroPartialSum x T‖
          ≤ c1n·x·log²(xT)/T + c3n·log x + ‖VIntegral (Gf x) (-1/4) (-T') T'‖

`explicit_formula_split_num`'s proof with `hEleft` left as the term.

    edge_left_any (hx : 16 ≤ x) (hT' : 2 ≤ T') :
      ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ A·log²T'·x^(−1/4)

`edge_left_sharp_num`'s proof with `hlogT'x` deleted and its last calc steps
ended at `8·D·log²T'·x^(−1/4)`. Together: the formula
at every height with `A·log²(T+1)·x^(−1/4)` in the error. The lost factor,
stated.

## F2 The left edge bounded at every height — PROVED (units 0459, 0460: `LeftSmooth.smooth_side`, `left_edge_bound`, `explicit_formula_all`)

Target: `‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ B·x^(−1/4)` for `16 ≤ x`,
`2 ≤ T'`, `B` free of both.

On `s = −1/4 + it` put `w = 1 − s = 5/4 − it`. Mathlib's
`riemannZeta_one_sub` at `w` gives `ζ(s) = 2·(2π)^(−w)·Γ(w)·cos(πw/2)·ζ(w)`.
Logarithmic derivative in `s`:

    ζ'/ζ(s) = G(s) − ζ'/ζ(w),   G(s) = log 2π − Γ'/Γ(w) + (π/2)·tan(πw/2).

F2a and F2b are PROVED (unit 0459: `LeftKernel.osc_by_parts`,
`kernel_bound`, `series_side`, `Bser`). The exchange of sum and integral is by
dominated convergence.

- **F2a, the kernel.** For `y > 1`, `a ≠ 0` real:
  `|∫_{-T}^{T} y^(it)/(a+it) dt| ≤ (2/T + π/|a|)/log y`. By parts once.
- **F2b, the series side.** `−ζ'/ζ(w) = Σ Λ(n)·n^(−w)`, absolutely
  convergent at `Re w = 5/4`. Its share of the edge is
  `x^(−1/4)·Σ Λ(n)·n^(−5/4)·∫ (xn)^(it)/(−1/4+it) dt`; each integral is
  `≤ (1 + 4π)/log 16` by F2a. Sum and integral exchange on a compact interval
  under uniform convergence.
- **F2c, the smooth side.** `h(t) = G(−1/4+it)/(−1/4+it)`. Needed:
  `|G| ≤ A·log(2+|t|)` and `|dG/dt| ≤ A/(1+|t|)`. From the series
  `(Γ'/Γ)'(w) = Σ 1/(n+w)²` and `|cos(a+ib)|² = cos²a + sinh²b ≥ cos²(5π/8)`.
  Then by parts: `|∫ x^(it)·h dt| ≤ (2·|h(T)| + ∫|h'|)/log x`, and
  `∫|h'| ≤ ∫ A/((1+t)·(1/4+t)) + A·log(2+t)/(1/16+t²) dt < ∞`.
- **F2, the edge.** F2b + F2c.

**As built (unit 0460).** The signs above are right (`LeftSmooth.logDeriv_sum`).
F2c took a different route from the one written above. With `w − 1 = −s`,
the digamma series gives `(−ψ(w) − γ)/s = Σ 1/((n+1)(n+w))`; sum and integral
exchange and each term is a kernel bounded by `(2+π)/(c·log y)`
(`kernel_conj`, endpoints bounded by `1/c` so the bounds sum). The tangent's
derivative is `≤ 1/(κ²+t²)` from `|cos(a+ib)|² ≥ cos²a + b²`. No derivative of
digamma and no growth bound on it is used.

## F3 T3 at a fixed row — PROVED (unit 0461: `CellFixedRow.cell_eq_zero_sum_all`, `cell_zero_sum_finset_all`, `cell_fixed_row`; what stays is `2^d·(c3n·log 2·r + Bleft)`)

F1 + F2: for `16 ≤ x`, every `T ≥ 2`,

    ‖ψ x − x + zeroPartialSum x T‖ ≤ c1n·x·log²(xT)/T + c3n·log x + B·x^(−1/4).

Through `CellZeros`: the cell at row `r`, depth `d`, and its zero sum to any
height `T ≥ 2` differ by the stencil of that bound; as `T → ∞` at the fixed
row the first term tends to zero and what stays is `≤ A_d·r`.
