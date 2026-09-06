---
id: 0323
date: 2026-09-06
type: formalization
title: WeilSeries.lean: the explicit band series, its summability, and the upper on-line background in closed form
refs: [lean_stage3/Stage3/WeilSeries.lean::term_le_M, lean_stage3/Stage3/WeilSeries.lean::bandSeries_summable, lean_stage3/Stage3/WeilSeries.lean::tsum_upper_le_explicit]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Rung `rung` 4b, second half, slice B2. Unit 0322 bounds the
upper on-line sum by any nonnegative summable band series that dominates
the terms. Is there an explicit one, built from unit 0320's near and far
bounds, and does it sum in closed form?

**What ran.** `lean_stage3/Stage3/WeilSeries.lean`, new, `module_lines` 321
lines, imported from `Stage3.lean`. `errors_first` 3 errors on the first build
(two `ring` calls with nothing left after `field_simp`, one rewrite that hit
the hypothesis and missed the goal), then clean. Full package built,
`jobs_package` 8744 jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 17 theorems and `defs` 3 definitions
(`cFar`, `M`, `A`), each theorem pinned by `#guard_msgs` to `axioms` 3 axioms,
`sorries` 0 sorries.

The series. `M h γ k` is `4h²` when band `k` is within `near_bands` 1 step of
the band of `γ`, else `cFar/(h²·|k − idx γ|⁴)` with
`cFar = (2π+π²)²·(10/9)⁴`. `term_le_M`: every on-line term of height at
least `height_min` 11/10 is at most `M` at its own band index, for
`γ ≥ 11/10`. Near, that is unit 0320's near bound. Far, the distance from a
zero in band `k` to `γ` is read off the band gap, `dist_ge`:
`|t − γ| ≥ (9/5)|k − k₀| − 9/5`, which is at least `(9/10)|k − k₀|` once
`|k − k₀| ≥ 2` (`two_le_of_one_lt`, an integer gap above 1 is at least 2).
Unit 0320's far bound then gives `c²/(h²(t−γ)⁴)` after the `t+γ` term is
absorbed into the `t−γ` term, and the quartic in the distance becomes the
quartic in the gap.

The comparison. `weight_le`: `15·log(centre k) + 73 ≤ 88(k+1)`, from
`log x ≤ x − 1`. `bandTerm_le_A`: each band term is at most `A/(k+1)³`,
`A = 88·(idx γ + 3)⁴·(4h² + cFar/h²)`; near, `k + 1 ≤ idx γ + 3`; far,
`k + 1 ≤ |k − k₀|·(k₀ + 3)`. `bandSeries_summable` follows by comparison
with the shifted p-series at exponent `p_exp` 3. `bandSeries_le`: the band
series is at most `A·π²/6`, comparing with `Σ 1/(k+1)²` and reading its
value from `hasSum_zeta_two` (`tsum_shift2`).

The result. `tsum_upper_le_explicit'`: for `h > 0` and `γ ≥ 11/10`, the full
weighted sum over on-line zeros of height at least 11/10 is at most
`88·(γ+3)⁴·(4h² + cFar/h²)·π²/6`, using `idx γ ≤ γ` (`idx_le`).

Crude-explicit: the quartic in `γ` is the price of `log x ≤ x` and the
gap-to-index comparison; a literature-sharp version would carry `log γ`.
The census can re-tabulate. Against the main term of rung 5, which grows as
`ε²h⁴`, the `4h²` near part and the `cFar/h²` far part are both beaten by
taking `h` large; the `(γ+3)⁴` factor sets how large.

Left for B3: heights below 11/10, which no count window reaches, and the
negative heights, which the count handles only through conjugation.
