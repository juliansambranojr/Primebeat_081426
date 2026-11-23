---
id: 0484
date: 2026-11-23
type: formalization
title: "At a zero the turned steps to a cutoff stand at the order times the logarithm of the cutoff"
refs: [lean_stage3/Stage3/StepsPeak.lean::peak_formula, lean_stage3/Stage3/StepsPeak.lean::K_self, lean_stage3/Stage3/StepsPeak.lean::peak_at_zero, lean_stage3/Stage3/StepsPeak.lean::peak_height]
supersedes: []
follows: 0483
context: unit 0472 measured the peaks of the turned steps rising with the logarithm of the cutoff; unit 0483 proved the pole of the full sum; this is block R5 of `lean_stage3/design/runs.md`, the first of the sizes left in the list Julian asked to have fixed
sealed: false
---

**Question.** Block R5 of `lean_stage3/design/runs.md`. How tall does the sum of the turned steps stand at a zero when it is cut off at a finite cutoff?

**What was proved.** `lean_stage3/Stage3/StepsPeak.lean`: `module_lines` 634 lines, `theorems_proved` 17 theorems, `defs` 5 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8871 jobs, the module at `jobs_module` 8804. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`peak_formula`: for every cutoff and every height from `floor_x` 2 on, and every point right of the imaginary axis, the turned steps up to the cutoff, each weighed by the ramp that falls to nothing at the cutoff, equal the smooth term less a term for each zero below the height, up to an error that is written out. The term of a zero is its order over the zero times a kernel, the integral of a power against the slope of the ramp.

`K_self`, `peak_at_zero`: when the point is itself a zero, that zero's kernel is the zero times the logarithm of the cutoff, plus a bounded part. Its term in the sum is minus its order times the logarithm of the cutoff.

`peak_height`: if no zero below the height lies to the right of the zero in hand, every other zero's term is bounded free of the cutoff. The sum at the zero is then the smooth term, less the order times the logarithm of the cutoff, plus a part bounded by a finite sum over the zeros below the height and the error.

How. Partial summation writes the turned steps as an integral of the prime staircase against the slope of the ramp. The tree's explicit formula from `floor_x` 2 writes the staircase through the zeros at every height. Each power integrates in closed form. Another zero carries the cutoff to the power of the difference of the two zeros, whose size is the cutoff to the difference of their real parts.

**Who wrote it.** An Opus worker wrote the file from the design block. Here it was rebuilt, searched for `sorry`, added axioms and `native_decide`, of which it has none, and its statements were read against the block. The proofs were checked by the kernel and were not read line by line here.

**What it says.** Unit `unit_run` 472 saw the peaks rise by about the logarithm of ten for each tenfold cutoff while the level between them stayed put. The theorem gives that slope exactly: the order of the zero, for each unit of the logarithm of the cutoff. It also says what would break it. A zero to the right of the one in hand enters with a positive power of the cutoff. Unit `unit_pole` 483 placed the poles of the full sum; this gives the height of the cut-off sum at them.

What remains. The bound on the other zeros is a sum over the zeros below the height, which grows with the height. The size rate read from the changes between cutoffs is not stated here.
