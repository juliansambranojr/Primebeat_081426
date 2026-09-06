---
id: 0321
date: 2026-09-06
type: formalization
title: WeilBands.lean: the multiplicity bridge, on-line zeros counted by band, and the band sum bound
refs: [lean_stage3/Stage3/WeilBands.lean::order_eq_analyticOrderNatAt, lean_stage3/Stage3/WeilBands.lean::band_count, lean_stage3/Stage3/WeilBands.lean::band_sum_le]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Rung 4b, second half, slice A of the detection ladder
(`units/0316` to `units/0320`). The on-line background is a sum over zeros
of nonnegative terms. To bound it the zeros must be counted by height band
with Stage 3's crude local count. Three things stand in the way: the count
sums the analytic order while the zero side is weighted by upstream's
multiplicity; the count's window is a disk, and the band is an interval on
the line; and a bound on the full sum has to come from bounds on finite
pieces. Can all three be settled?

**What ran.** `lean_stage3/Stage3/WeilBands.lean`, new, `module_lines` 146 lines,
imported from `Stage3.lean`. Two build cycles: `errors_first` 2 errors on the
first (one more unfolding in the multiplicity case split, and the current
name of the power-comparison lemma), then clean. Full package built,
`jobs_package` 8742 jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 4 theorems and `defs` 1 definition
(`weightedTerm`), each pinned by `#guard_msgs` to `axioms` 3 axioms, `sorries` 0
sorries.

`order_eq_analyticOrderNatAt`: at every nontrivial zero, upstream's
`riemannZeta.order` equals Mathlib's `analyticOrderNatAt`. Both are the
analytic order; `order` reads it through the meromorphic order, which for
an analytic function is the same number, and both send the junk case to 0.
So the count and the zero side weigh a zero the same way.

`mem_zetaWindow_of_online` and `band_count`: an on-line zero within
`band_half` 9/10 of a height `T ≥ 2` lies in the count's disk of radius
`window_radius` 7/4 about `2 + iT`, because on the line
`‖ρ − (2 + iT)‖² = 9/4 + (γ_ρ − T)² ≤ 9/4 + 81/100 ≤ 49/16`. So any finite set
of such zeros has total multiplicity at most `15·log T + 73`
(`JensenCount.zeta_local_zero_count`), with the count's constants
`count_slope` 15 and `count_const` 73.

`band_sum_le`: over such a finite set, if every on-line term is at most
`M ≥ 0`, the multiplicity-weighted sum is at most `M·(15·log T + 73)`.

What the next slice does with it: tile the heights by windows stepped by
`band_step` 9/5, apply `band_sum_le` per tile with unit 0320's near and far
bounds as `M`, and pass to the full sum through `Real.tsum_le_of_sum_le`,
which asks only nonnegativity and a bound on every finite partial sum, so
no summability of the zero side is needed.
