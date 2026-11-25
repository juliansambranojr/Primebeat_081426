---
id: 0522
date: 2026-11-24
type: formalization
title: "The sizes in Levinson's count: the right edge is at most pi, and the gamma part is pi times the zero count up to a logarithm"
refs: [lean_stage3/Stage3/LevinsonSize.lean::norm_G_sub_one_le, lean_stage3/Stage3/LevinsonSize.lean::re_G_pos, lean_stage3/Stage3/LevinsonSize.lean::right_edge_le, lean_stage3/Stage3/LevinsonSize.lean::gamma_part_eq, lean_stage3/Stage3/LevinsonSize.lean::gamma_part_eq_count, lean_stage3/Stage3/LevinsonSize.lean::gamma_part_count_le, lean_stage3/Stage3/LevinsonSize.lean::gamma_part_count_le_gt_two]
supersedes: []
follows: 0521
context: unit 0521 left the turning along the line as the gamma part, the zeros of the perturbed function and three edge integrals; this is step 1d (i) and (iii) of block S11 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Step 1d of block S11 of `lean_stage3/design/stencil.md`, parts (i) and (iii). Is the right edge term at most pi, and is the gamma part pi times the zero count up to a logarithm?

**What was proved.** `lean_stage3/Stage3/LevinsonSize.lean`: `module_lines` 309 lines, `theorems_proved` 11 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 7 axiom pins. The first build had `errors_first` 12 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8899 jobs, the module at `jobs_module` 8805. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`norm_G_sub_one_le` and `re_G_pos`: on the line of real part three, zeta plus a multiple of its derivative between zero and one is within pi squared over six less one of one, written as one series whose terms are at most the inverse squares, so its real part is positive. `right_edge_le`: the right edge term of the turning is at most pi in size. `gamma_part_eq`: the gamma part of the turning is exactly the difference of the tree's phase `Stage3.phaseTheta`. `gamma_part_eq_count`: it is pi times the difference of the zero count less pi times the difference of the argument of zeta. `gamma_part_count_le` and `gamma_part_count_le_gt_two` bound that error by pi times a multiple of the logarithm of the upper height plus a constant, from the argument bounds of `ArgCount`.

**Who wrote it.** One worker, whose first two builds stopped on an instance goal from a convert, a cast and an unqualified name. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The horizontal edge terms, part (ii), and the mean value left of the line; nothing here proves the hypothesis.
