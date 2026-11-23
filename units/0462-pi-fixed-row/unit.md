---
id: 0462
date: 2026-11-23
type: formalization
title: "The integer count at a fixed row: the height of the zero sum taken to infinity"
refs: [lean_stage3/Stage3/PiFixedRow.lean::sum_order_inv_sq_le, lean_stage3/Stage3/PiFixedRow.lean::norm_low_integral_le, lean_stage3/Stage3/PiFixedRow.lean::tr_efRem_fixed, lean_stage3/Stage3/PiFixedRow.lean::pi_fixed_row, lean_stage3/Stage3/PiFixedRow.lean::table_cell_fixed_row]
supersedes: []
follows: 0461
context: unit 0461 sealed T3 at a fixed row for the cell of the Chebyshev function; unit 0442 holds the identity that carries the zeros to the integer count; this is block F4 of `lean_stage3/design/leftedge.md`
sealed: false
---

**Question.** Block F4 of `lean_stage3/design/leftedge.md`. At a fixed row, with the height of the zero sum taken to infinity, how far is the integer count from its smooth part less the sum over the zeros and the higher prime powers?

**What was proved.** `lean_stage3/Stage3/PiFixedRow.lean`: `module_lines` 716 lines, `theorems_proved` 23 theorems, `defs` 5 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 4 error lines; clean on build `builds` 12. The package builds at `jobs_package` 8852 jobs, the module at `jobs_module` 8797. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`pi_fixed_row`: fix a point at least `floor_x` 16. For every tolerance, at every height from some height on, the count of primes up to the point less its smooth part, plus the sum over the zeros below the height of each zero's part of the count, plus the passage of the higher prime powers, is at most the constant `Api` times the logarithm of the point, plus the tolerance. The bound has no height in it.

`table_cell_fixed_row`: the same for the integer table. Fix a depth and a row at least `row_margin` 6 above it. From some height on, the table's cell less the smooth cell, plus the zeros below the height under the stencil, plus the higher prime powers under the stencil, is at most the next depth's power of the base times `Api` times the logarithm of the base times the row, plus the tolerance.

`tr_efRem_fixed`, `norm_low_integral_le`, `sum_order_inv_sq_le`: the pieces. The passage of the explicit formula's remainder at a fixed point is bounded free of the height; its integral over the stretch from `low_end` 2 to `floor_x` 16 is at most `Clow` at every height; the orders of the zeros over the squares of their sizes sum to at most `Z2` at every height.

How. Unit 0442's identity holds at every height, so what has to be bounded is the passage of the remainder. From `floor_x` 16 up the formula of unit 0460 bounds the remainder; its height term falls away and the rest integrates to a multiple of the logarithm. Below `floor_x` 16 the formula is not in the tree, and the tree's bound there puts an absolute value on each zero, which grows with the height. There each zero's power is integrated by parts against the weight instead. That leaves the order over the square of the size, and by dyadic blocks that sum is bounded.

**Who wrote it.** An Opus worker, from a brief with the statements and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** T3 at a fixed row holds on the integer table. The count at a doubling is its smooth part, less the zeros taken in order of height all the way up, less the higher prime powers, within a constant times the row. The higher prime powers are of square-root size and belong to the count. It was the second of `lost_factors` 2 places where an absolute value on a turning term had been costing a power of the logarithm of the height.

What remains. The statements say the distance is eventually small; they do not name the limit of the zero sum as a number. The explicit formula below `floor_x` 16 is still not in the tree.
