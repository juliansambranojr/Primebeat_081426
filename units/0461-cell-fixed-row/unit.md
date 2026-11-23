---
id: 0461
date: 2026-11-23
type: formalization
title: "T3 at a fixed row: the cell and its zero sum with the height taken to infinity"
refs: [lean_stage3/Stage3/CellFixedRow.lean::cell_eq_zero_sum_all, lean_stage3/Stage3/CellFixedRow.lean::cell_zero_sum_finset_all, lean_stage3/Stage3/CellFixedRow.lean::cell_fixed_row]
supersedes: []
follows: 0460
context: unit 0441 took the height of the cell's zero sum to infinity along the rows and left the fixed row open; units 0457 to 0460 removed the cap on the height from the tree's explicit formula; this is block F3 of `lean_stage3/design/leftedge.md`
sealed: false
---

**Question.** Block F3 of `lean_stage3/design/leftedge.md`. At a fixed row, with the height of the zero sum taken to infinity, how far is the cell from its main term less the sum over the zeros?

**What was proved.** `lean_stage3/Stage3/CellFixedRow.lean`: `module_lines` 206 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8851 jobs, the module at `jobs_module` 8752. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`cell_fixed_row`: fix a depth and a row at least `row_margin` 4 above it. For every tolerance, at every height from some height on, the cell of the Chebyshev function at that row and depth, less its main term, plus the sum over the zeros below the height, is at most the depth's power of the base times a constant times the row plus the constant `Bleft`, plus the tolerance. The bound has no height in it.

`cell_eq_zero_sum_all`, `cell_zero_sum_finset_all`: the cell and its zero sum at any height at least `floor_T` 2, with the stencil of the bound of unit 0460 on the right. They are `CellZeros.cell_eq_zero_sum` and `FiniteOffLine.cell_zero_sum_finset` with the cap on the height removed.

How. The stencil reads finitely many rows. At each the formula of unit 0460 holds at every height. Its first term, the doubling times the square of a logarithm over the height, tends to zero as the height grows with the row held still. The logarithm of each doubling is at most the row times the logarithm of the base, and the fourth-root term is at most `Bleft`. The binomial weights add to the depth's power of the base.

**Who wrote it.** An Opus worker, from a brief with the statements and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** Unit `unit_rows` 0441 sealed T3 along the rows, the height rising with the row. This is T3 at a fixed row: the row stays, the height goes to infinity, and the cell sits within a constant times the row of its main term less the whole sum over the zeros taken in order of height. Against the square root of the doubling that distance is nothing. The tail of the zero sum is inside the error at every row.

What remains. The statement is for the cell of the Chebyshev function. The same passage for the integer count goes through `PiZeros.pi_eq_zero_sum`, whose remainder term reads the formula at heights up to the doubling.
