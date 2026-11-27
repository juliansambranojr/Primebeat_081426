---
id: 0584
date: 2026-11-26
type: run
title: "The dyadic table to row 92 has the same four zeros; a published prime bound settles depths up to nine for every row, so (20,6) is the only depth-6 zero"
refs: [lean/Zeros.lean::measured_zeros_all_vanish]
supersedes: []
follows: 0583
context: Julian asked whether (20,6) is the only balance in the table to infinity; the assistant answered from the cache rows and estimated a reach far past the computed rows, both corrected here
sealed: false
---

**Question.** Is (20,6) the last zero of the dyadic prime difference table, at every depth, as far as exact counts go, and how far can a proved bound carry it?

**What ran.** `run/census.py` and `run/bound.py`, by `run/run.sh`, through `lab run`. The census builds every cell from the OEIS b-file of pi at powers of two at the repo root, `b007053.txt`, which agrees with the repo's cache on all `census.cache_rows_compared` 63 rows both hold. The bound script, written by the adversary review of the day and copied in as run, asks where a bound on the gap between pi and Li makes every cell of a depth provably positive. EXPLORATORY: no prereg, no verdict.

**The census.** Rows to `census.rows` 92, all `census.cells` 4278 cells: the zeros are (2,1), (4,1), (8,3) and (20,6), the same four as the repo's earlier census over the cache's rows. At depth six the cells are negative at rows `census.depth6_negative_rows[0]` 8, `census.depth6_negative_rows[1]` 10, `census.depth6_negative_rows[2]` 12, `census.depth6_negative_rows[3]` 15 and `census.depth6_negative_rows[4]` 17, zero at row `census.depth6_zero_rows[0]` 20, and positive from row `census.depth6_positive_from` 21 to the end.

**The bound.** Fiori, Kadiri and Swidinsky's Table 6 row 1, held in PNT+ `IEANTN/FKS2.lean` where it is stated with `sorry`, makes depth six positive from the row after `bound.FKS2_d6_last_failing` 40, with the main term `bound.FKS2_d6_margin63` 31.642619886771527 times the error at row 63; depth nine after row `bound.FKS2_d9_last_failing` 59. Together with the census, depths up to nine have no zero beyond the four for every row: (20,6) is the only zero at depth six, out to infinity. Depth twelve is not settled by that row: it fails to row `bound.FKS2_d12_last_failing` 314. Under the Riemann hypothesis, Schoenfeld's bound settles depth twelve after row `bound.RH_d12_last_failing` 58.

**Correction.** The assistant first answered from the cache's rows while the b-file to 92 sat at the repo root, and estimated that a bound would reach depth six only near row two hundred and thirty, a figure from no computation. The weaker bounds give that order, Corollary 22 at `bound.FKS2cor22_d6_last_failing` 750; Table 6 row 1 reaches it at 40.

**For Lean.** The census to row 40 and the FKS2 row are inputs Lean cannot check today: the first is an outside computation, the second is stated with `sorry` in PNT+.

What remains. The cells far down the depth, past about three tenths of the row, which no known bound controls even under the Riemann hypothesis.
