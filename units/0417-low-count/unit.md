---
id: 0417
date: 2026-11-22
type: formalization
title: "LowCount.lean: the zeros of zeta below height six counted by Jensen's formula on six discs with the pole cleared"
refs: [lean_stage3/Stage3/LowCount.lean::low_rect_count, lean_stage3/Stage3/LowCount.lean::low_ball_count, lean_stage3/Stage3/LowCount.lean::gz_c0_lower]
supersedes: []
follows: 0416
context: block E7 of the joints worksheet, sub-block E7c; unit 0416 gave the two numerals this count consumes; Julian chose to build E7, 2026-11-22
sealed: false
---

**Question.** Sub-block E7c of `lean_stage3/design/joints.md`. Is the number of zeros below height `height` 6, which the edge constant takes as a bare finite sum, bounded by a numeral?

**What was proved.** `lean_stage3/Stage3/LowCount.lean`: `module_lines` 311 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins each at `axioms` 3 axioms, clean on build `builds` 1 with `errors_first` 0 errors. The package builds at `jobs_package` 8801 jobs, the module at `jobs_module` 8723. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`gz_c0_lower`: the pole-cleared zeta at the point with real part three halves is at least one fourteenth in norm at every height, from unit 0416's ratio and the upstream lower bound on that line.

`low_ball_count`: for a height between zero and six, the zeros of the pole-cleared function within eight fifths of that point number at most `per_disc` 119 with multiplicity. Jensen's count from upstream on the function rescaled to the unit disc, with unit 0416's band bound above and the centre bound below.

`low_rect_count`: the zeros of zeta with real part between zero and one and height between zero and six number at most `m0_bound` 714 with multiplicity. The rectangle is covered by `discs` 6 of those discs, one for each unit of height; no reflection is needed because each disc reaches the whole width of the strip.

**A change from the block.** The block proposed seven discs at the integer heights. Six at the half-integers cover the same rectangle with the same argument.

**What it settles.** The count the edge constant called `M0` is at most a numeral. One of block E7's quantities is left unnamed, `unnamed_after` 1 against `unnamed_before` 2 before this unit: the supremum of the logarithmic derivative on the short segment. The numeral is not wired into `EdgeBound.ball_order_sum_le`, which still carries the bare sum.

What remains. E7d, and then the explicit formula's constants as definitions.
