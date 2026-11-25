---
id: 0523
date: 2026-11-24
type: formalization
title: "The horizontal edges in Levinson's count: each turns by at most a multiple of the logarithm of the height"
refs: [lean_stage3/Stage3/LevinsonEdge.lean::horizontal_edge_le, lean_stage3/Stage3/LevinsonEdge.lean::edge_le_of_bound, lean_stage3/Stage3/LevinsonEdge.lean::real_zero_count, lean_stage3/Stage3/LevinsonEdge.lean::G_disc_le, lean_stage3/Stage3/LevinsonEdge.lean::deriv_zeta_disc_le, lean_stage3/Stage3/LevinsonEdge.lean::zeta_norm_le]
supersedes: []
follows: 0522
context: unit 0522 bounded the right edge and the gamma part of Levinson's count; this is step 1d (ii) of block S11 of `lean_stage3/design/stencil.md`, the horizontal edges
sealed: false
---

**Question.** Step 1d (ii) of block S11 of `lean_stage3/design/stencil.md`. Does the argument of zeta plus a multiple of its derivative turn by at most a multiple of the logarithm of the height along each horizontal edge from one half to three?

**What was proved.** `lean_stage3/Stage3/LevinsonEdge.lean`: `module_lines` 516 lines, `theorems_proved` 13 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 4 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8900 jobs, the module at `jobs_module` 8806. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`horizontal_edge_le`: for a multiple between zero and one, at heights from four, with no zero on the segment, the argument of zeta plus that multiple of its derivative turns along the segment from one half to three by at most twenty-one pi times the logarithm of the height plus a constant. `edge_le_of_bound` is the same for any function analytic off one, with a growth bound as hypothesis. `real_zero_count` counts the real points where a real-symmetrized function has zero real part, by Jensen through the dependency's `ZerosBound`. `zeta_norm_le`, `deriv_zeta_disc_le` and `G_disc_le` bound zeta, its derivative by Cauchy's estimate, and their combination on the disc, linearly in the height.

**Who wrote it.** One worker, whose first build stopped on one side goal. The step from the count to the argument is the tree's `ArgLegs.segment_im_integral_le`. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. Assembling step one, and the mean value left of the line; nothing here proves the hypothesis.
