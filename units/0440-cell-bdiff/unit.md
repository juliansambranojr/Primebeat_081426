---
id: 0440
date: 2026-11-22
type: formalization
title: "CellBdiff.lean: the cell theorem on the table tree's own operator, bdiff iterated"
refs: [lean_stage3/Stage3/CellBdiff.lean::stencil_eq_bdiff_iter, lean_stage3/Stage3/CellBdiff.lean::cell_eq_modeSum_bdiff]
supersedes: []
follows: 0426
context: a NOTEPAD line of 2026-11-22 records that the cell module of unit 0425 writes the d-fold difference a second time, beside the table tree's operator; Julian said the same day to go for all of the open items, this being the third
sealed: false
---

**Question.** Block T1b of `lean_stage3/design/joints.md`. Is the stencil of unit 0425 the table tree's difference operator, and can the cell theorem be stated on that operator alone?

**What was proved.** `lean_stage3/Stage3/CellBdiff.lean`: `module_lines` 124 lines, `theorems_proved` 6 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 2 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8833 jobs, the module at `jobs_module` 8742. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`stencil_eq_bdiff_iter`: take a row on the integers and any function on the complex numbers that agrees with it there. The stencil of the row at a depth is the table tree's backward difference applied that many times to the function. The proof goes through one backward difference on the row, whose iterates are the stencil by Mathlib's formula for iterated differences.

`cell_eq_modeSum_bdiff`: the cell theorem of unit 0426 with the table tree's operator in the place of the stencil. All four objects in it, the operator, the symbol, the mode and the sum of modes, are now the table tree's.

**What it says.** Joint T1 is a statement about the table tree's own operator. The second writing of the difference in unit 0425 is the same thing.

What remains. The stencil is still what the modules after unit 0425 use. Retiring it is a rewrite of sealed modules and is not done.
