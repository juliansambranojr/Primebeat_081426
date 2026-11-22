---
id: 0441
date: 2026-11-22
type: formalization
title: "CellRows.lean: the height of the zero sum taken to infinity along the rows; the tail is inside the error"
refs: [lean_stage3/Stage3/CellRows.lean::cell_eq_zero_sum_rows, lean_stage3/Stage3/CellRows.lean::cell_tail_tendsto]
supersedes: []
follows: 0439
context: joint T3 of the sections file asks for the height of the zero sum taken to infinity, with the tail inside the error; unit 0439 bounded the error at a height tied to the row; Julian said on 2026-11-22 to go for all of the open items, T2 and T3 being the fourth
sealed: false
---

**Question.** Block T3a of `lean_stage3/design/joints.md`. Can the height of the zero sum in the cell be sent to infinity with the error staying under square-root size?

**What was proved.** `lean_stage3/Stage3/CellRows.lean`: `module_lines` 85 lines, `theorems_proved` 2 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8835 jobs, the module at `jobs_module` 8748. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`cell_eq_zero_sum_rows`: at each row take the height to be the doubling of the cell's lowest row. The cell of the log-weighted count, its main term, and the sum over the zeros below that height then differ by at most a constant, depending on the depth, times the square of the row.

`cell_tail_tendsto`: that difference, divided by the square root of the row's doubling, tends to zero as the rows go on. The height goes to infinity with the row, and the zeros above it are inside an error that vanishes at square-root scale.

**What it says.** Along the rows the cell is its zero sum, to within less than any fixed fraction of square-root size.

What remains. The height to infinity at one fixed row. The cell theorem of unit 0425 caps the height at the square of the row's doubling, and the explicit formula above that is not in the tree.
