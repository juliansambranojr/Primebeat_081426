---
id: 0487
date: 2026-11-23
type: formalization
title: "The size rate of the turned steps is at most the largest real part of a zero less the weight tried"
refs: [lean_stage3/Stage3/StepsRate.lean::norm_K_le_pow, lean_stage3/Stage3/StepsRate.lean::rate_upper]
supersedes: []
follows: 0486
context: unit 0472 read a size rate near a half from the changes of the turned steps between cutoffs; unit 0484 wrote the turned steps to a cutoff through the zeros; this is block R8 of `lean_stage3/design/runs.md`, the second of the sizes left in the list Julian asked to have fixed
sealed: false
---

**Question.** Block R8 of `lean_stage3/design/runs.md`. How fast can the turned steps to a cutoff grow at a point that is not a zero?

**What was proved.** `lean_stage3/Stage3/StepsRate.lean`: `module_lines` 140 lines, `theorems_proved` 2 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8873 jobs, the module at `jobs_module` 8805. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`norm_K_le_pow`: the kernel of a zero, at a point that is neither the zero nor the zero less a unit, is at most a constant free of the cutoff times the cutoff to any power that is at least the real part of the zero less the real part of the point.

`rate_upper`: take a point in the strip that is not a zero, a height, and a number that bounds the real part of the point and of every zero below the height. The turned steps to the cutoff, less their smooth term, are at most a sum over the zeros below the height, free of the cutoff, times the cutoff to the power of that number less the real part of the point, plus the error of unit `unit_peak` 484.

**Who wrote it.** Written and built here, from the closed form of the kernel in unit `unit_peak` 484; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it says.** Unit `unit_run` 472 tried the weight at several exponents and read a rate from the changes between cutoffs. The theorem says that rate is at most the largest real part of a zero below the height less the exponent tried. Whatever exponent is tried, the answer points at the same number, which is what the run saw.

What remains. This is the upper half. That the rate is no less needs a zero of the largest real part to show in the sum without being cancelled by the others. That half is not stated here. The constant is a sum over the zeros below the height and grows with the height.
