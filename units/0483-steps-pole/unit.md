---
id: 0483
date: 2026-11-23
type: formalization
title: "The turned steps have a pole at every zero, with the zero's weight"
refs: [lean_stage3/Stage3/StepsPole.lean::steps_pole, lean_stage3/Stage3/StepsPole.lean::steps_pole_ne_zero, lean_stage3/Stage3/StepsPole.lean::steps_regular]
supersedes: []
follows: 0482
context: unit 0472 turned the steps of the staircase, added them, and saw the sum peak at the heights of the zeros on a stretch; Julian asked that the runs be theorems; this is block R4 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R4 of `lean_stage3/design/runs.md`. Where exactly does the sum of the turned steps become infinite, and with what weight?

**What was proved.** `lean_stage3/Stage3/StepsPole.lean`: `module_lines` 110 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8869 jobs, the module at `jobs_module` 8793. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`steps_sum`: to the right of the line of real part `abscissa` 1, the sum over the integers of each step, the von Mangoldt weight, turned and weighed by the integer to minus the point, is minus the logarithmic derivative of zeta. That is the sum unit `unit_run` 472 computed up to a cutoff, without the cutoff.

`steps_pole`: at every nontrivial zero, the logarithmic derivative over the point, times the distance to the zero, tends to minus the zero's order over the zero. `order_pos`, `steps_pole_ne_zero`: the order is at least one, so that limit is not zero. The sum of the turned steps has a pole at every zero.

`steps_regular`: at any point other than the unit where zeta does not vanish, the logarithmic derivative is analytic. There is no pole anywhere else.

How. Near a zero zeta is a power of the distance times a function that does not vanish there, so its logarithmic derivative is the order over the distance plus an analytic function; this is the tree's `ContourShift.zeta_local_data_zero`, read at the base one.

**Who wrote it.** Written and built here, in one sitting; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard three axioms.

**What it says.** The run saw the turned steps stand up at the heights of the zeros, higher as more steps were taken. The theorem says where the full sum is infinite: at the zeros, and nowhere else in the strip. The weight of the pole is the zero's order over the zero, which is the weight the same zero carries in the table's residual. The steps, turned, and the table's residual name the same points with the same weights.

What remains. The statement is for the full sum, by continuation. It does not say how tall the peak of a sum cut off at a finite cutoff stands, or where the size rate is read; those are the run's sizes.
