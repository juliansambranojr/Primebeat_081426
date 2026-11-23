---
id: 0480
date: 2026-11-23
type: formalization
title: "The fold and the beat between two zeros, as theorems at every row"
refs: [lean_stage3/Stage3/RunTheorems.lean::mode_fold, lean_stage3/Stage3/RunTheorems.lean::mode_cross, lean_stage3/Stage3/RunTheorems.lean::two_mode_beat, lean_stage3/Stage3/RunTheorems.lean::zero_pair_beat]
supersedes: []
follows: 0479
context: units 0473 and 0474 measured, on a stretch of rows, that the table's residuals show the zeros folded onto the ladder and that the residuals of neighbouring zeros beat at the distance between them; Julian asked that the runs be theorems
sealed: false
---

**Question.** Block R1 of `lean_stage3/design/runs.md`. What in those runs is exact at every row, with nothing computed?

**What was proved.** `lean_stage3/Stage3/RunTheorems.lean`: `module_lines` 107 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 2 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8866 jobs, the module at `jobs_module` 8834. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`mode_fold`: on the ladder of base `base` 2, raising the height of a point by any whole number of periods, the period being twice pi over the logarithm of the base, leaves its mode unchanged. This is the fold that unit `unit_fold` 473 read in the table's residuals, for every point and every whole number.

`two_mode_beat`: at every row, the squared size of two modes taken together is the sum of their two squared sizes plus twice the real part of a term that carries the row's power of the first mode times the conjugate of the second. `mode_cross`: that product, for two points, is the exponential of the sum of their real parts and of the difference of their heights, each times the logarithm of the base. `zero_pair_beat`: so the term is the row's power of the base raised to the sum of the real parts, times a rotation by the row times the difference of the two heights times the logarithm of the base.

How. The fold is the exponential's period. The beat is the expansion of a squared size of a sum, and the conjugate of an exponential.

**Who wrote it.** Written and built here, in one sitting. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard three axioms.

**What it says.** What unit `unit_beat` 474 measured between neighbouring zeros on a stretch of cutoffs is exact for any two modes at every row: the two do not simply add in size; between them is a term that turns at the difference of their heights. Nothing is computed and no row is left out. For two zeros on the line the term keeps the size of the square root's row power and only turns.

What remains. The run's sizes, how large the sway is against the distance between the zeros, are not in the theorem. The sieve's exact sum of unit 0475 is the next core to state for every row.
