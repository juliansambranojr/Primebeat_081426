---
id: 0458
date: 2026-11-23
type: formalization
title: "The explicit formula at every height, the left edge kept as a term"
refs: [lean_stage3/Stage3/ExplicitLeft.lean::explicit_formula_left, lean_stage3/Stage3/ExplicitLeft.lean::edge_left_any, lean_stage3/Stage3/ExplicitLeft.lean::explicit_formula_any]
supersedes: []
follows: 0457
context: unit 0441 left the fixed row open because the tree's explicit formula caps the height at the square of the doubling; unit 0457 found the cap is used at the left edge alone; this is block F1 of `lean_stage3/design/leftedge.md`
sealed: false
---

**Question.** Block F1 of `lean_stage3/design/leftedge.md`. Does the tree's explicit formula hold at every height once the left edge of the contour is kept as a term?

**What was proved.** `lean_stage3/Stage3/ExplicitLeft.lean`: `module_lines` 669 lines, `theorems_proved` 4 theorems, `defs` 0 plain definitions beside the noncomputable constant `Aleft`, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8848 jobs, the module at `jobs_module` 8736. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`explicit_formula_left`: for a doubling at least `floor_x` 16 and a height at least `floor_T` 2 there is a good height within a step above it, such that the Chebyshev function less the doubling plus the sum over the zeros below the height is within the tree's two terms plus the size of the left edge at the good height. The height carries no cap.

`edge_left_any`: the left edge at any height at least `floor_T` 2 is at most `Aleft` times the square of the logarithm of the height over the fourth root of the doubling, with `Aleft` equal to `edge_const` 8 times the tree's constant `Glue.Dln`.

`explicit_formula_any`: the two joined. The formula at every height, with the square of the logarithm of the height in the last term.

How. `explicit_formula_left` is the proof of `Glue.explicit_formula_split_num` with the bound on the left edge taken out and the edge left standing. `edge_left_any` is the proof of `Glue.edge_left_sharp_num` with the step that needed the cap deleted, so the logarithm of the height stays where the logarithm of the doubling stood.

**Who wrote it.** An Opus worker, from a brief with the statements and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** The cap at the square is gone from the formula. At a fixed row the height can now be raised until the square of its logarithm reaches the fourth root of the doubling, with the error still bounded. Past that the last term grows. That growth is the lost factor of unit 0457, stated as a theorem.

What remains. Block F2: the left edge bounded free of the height. Block F3: the cell at a fixed row.
