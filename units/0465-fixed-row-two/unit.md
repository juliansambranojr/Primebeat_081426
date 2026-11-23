---
id: 0465
date: 2026-11-23
type: formalization
title: "T3 at a fixed row at every row of the table"
refs: [lean_stage3/Stage3/FixedRowTwo.lean::cell_eq_zero_sum_two, lean_stage3/Stage3/FixedRowTwo.lean::cell_fixed_row_two, lean_stage3/Stage3/FixedRowTwo.lean::tr_efRem_fixed_two, lean_stage3/Stage3/FixedRowTwo.lean::pi_fixed_row_two, lean_stage3/Stage3/FixedRowTwo.lean::table_cell_fixed_row_two]
supersedes: []
follows: 0464
context: unit 0461 and unit 0462 sealed T3 at a fixed row on the explicit formula for points from sixteen, which left out the lowest rows; unit 0464 proved the formula from the first doubling; this is block G3 of `lean_stage3/design/floor.md`
sealed: false
---

**Question.** Block G3 of `lean_stage3/design/floor.md`. Restated on the explicit formula from the first doubling, do the fixed-row theorems hold at every row where the cell's identity holds?

**What was proved.** `lean_stage3/Stage3/FixedRowTwo.lean`: `module_lines` 494 lines, `theorems_proved` 13 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8855 jobs, the module at `jobs_module` 8800. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`table_cell_fixed_row_two`: fix a depth and a row at least `table_margin` 2 above it. For every tolerance, from some height on, the integer table's cell less the smooth cell, plus the zeros below the height under the stencil, plus the higher prime powers under the stencil, is at most the next depth's power of the base times `Api2` times a linear function of the row, plus the tolerance. The row condition is the hypothesis of the cell's identity `PiZeros.table_cell_eq_zero_sum` itself. Unit 0462 asked a margin of `table_margin_old` 6.

`pi_fixed_row_two`: the same for the count at any point at least `floor_new` 2, where unit 0462 asked `floor_old` 16.

`cell_fixed_row_two`: the same for the cell of the Chebyshev function at any row at least `cell_margin` 1 above the depth, where unit 0461 asked `cell_margin_old` 4.

`cell_eq_zero_sum_two`, `tr_efRem_fixed_two`: the cell formula at every height from the lowest rows, and the passage of the explicit formula's remainder at any point from `floor_new` 2, bounded free of the height.

How. The proofs of unit 0461 and unit 0462 with the formula of unit 0464 in place of the formula of unit 0460. For the count the whole integral from `floor_new` 2 to the point is read from the formula. The stretch below the old floor, where unit 0462 integrated each zero by parts, is no longer a separate case.

**Who wrote it.** An Opus worker, from a brief with the statements. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** T3 at a fixed row has no row left out. Wherever the table's cell is written as zeros plus remainder, the height of the zero sum can be taken to infinity and the cell stays within a constant times the row of its smooth part less the zeros less the higher prime powers. The row conditions of unit 0461 and unit 0462 came from the method and are gone.

What remains. The converse on the table's own ladder is about the rows from some row on and is untouched by this. The constants are not computed as numerals.
