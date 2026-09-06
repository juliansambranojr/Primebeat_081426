---
id: 0322
date: 2026-09-06
type: formalization
title: WeilTiles.lean: heights tiled by bands, the fiberwise reduction, and the upper on-line sum against a band series
refs: [lean_stage3/Stage3/WeilTiles.lean::idx_spec, lean_stage3/Stage3/WeilTiles.lean::sum_by_bands, lean_stage3/Stage3/WeilTiles.lean::tsum_upper_le]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Rung `rung` 4b, second half, slice B1. Unit 0321 bounds one band.
The on-line background runs over every zero. Can the heights be tiled by
bands so that a finite on-line sum reduces to a sum over band indices, and
can the full sum be bounded by a band series without proving the zero side
summable?

**What ran.** `lean_stage3/Stage3/WeilTiles.lean`, new, `module_lines` 169 lines,
imported from `Stage3.lean`. `errors_first` 0 errors on the first build. Full
package built, `jobs_package` 8720 jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 8 theorems, `defs` 3 definitions
(`centre`, `idx`, `Upper`), each theorem pinned by `#guard_msgs` to `axioms` 3
axioms, `sorries` 0 sorries.

`centre k = 2 + (9/5)·k` and `idx t = ⌊(t − 11/10)/(9/5)⌋₊`. `idx_spec`: every
height `t ≥ 11/10` lies within `band_half` 9/10 of `centre (idx t)`. So bands
of step `band_step` 9/5 abut, starting at `height_min` 11/10, and every band
centre is at least `window_height_min` 2, which is what the count asks.

`sum_by_bands`: split a finite set of on-line zeros of height at least
11/10 by band index (`Finset.sum_fiberwise_of_maps_to`), apply unit 0321's
`band_sum_le` to each fibre with `T = centre k` and `M = M k`. The weighted
sum is at most `Σ_k M k·(15·log (centre k) + 73)` over the indices that
occur.

`tsum_upper_le`: over the subtype `Upper` of on-line zeros of height at
least 11/10, the full weighted sum is at most the band series
`Σ'_k M k·(15·log (centre k) + 73)`, for any nonnegative summable `M` that
dominates each term at its band index. The pass from finite sums to the
tsum is `Real.tsum_le_of_sum_le`, which asks for nonnegative terms and one
bound on every finite partial sum. Summability of the zero side is never
assumed. Nonnegativity is `online_term_nonneg`: the on-line term is a real
square by unit 0320's `online_term_eq`.

Left for the next slices: an explicit summable `M` built from unit 0320's
near and far bounds (B2); the heights below 11/10 and the negative heights
(B3), which the count's window does not reach.
