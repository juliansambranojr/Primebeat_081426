---
id: 0493
date: 2026-11-23
type: formalization
title: "At a zero the turned steps to a cutoff exceed every bound below the zero's rate, again and again"
refs: [lean_stage3/Stage3/StepsBelow.lean::zeta_ne_zero_of_steps_bound, lean_stage3/Stage3/StepsBelow.lean::rain_steps]
supersedes: []
follows: 0492
context: unit 0489 proved for the staircase that a zero forces a rise past every bound below its rate; unit 0487 held the turned steps' rate from above; this is block R9 of `lean_stage3/design/runs.md` for the turned steps to a cutoff, the quantity unit 0472 measured
sealed: false
---

**Question.** Block R9 of `lean_stage3/design/runs.md`. Does a zero force the turned steps to a cutoff to rise to the zero's rate, without the proof saying at which cutoff?

**What was proved.** `lean_stage3/Stage3/StepsBelow.lean`: `module_lines` 781 lines, `theorems_proved` 41 theorems, `defs` 10 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8878 jobs, the module at `jobs_module` 8807. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`zeta_ne_zero_of_steps_bound`: if the turned steps to a cutoff, less their smooth term, stay within a constant times the cutoff to a power from some cutoff on, then zeta has no zero whose real part exceeds the real part of the point plus that power.

`rain_steps`: take a nontrivial zero, a point right of the imaginary axis, and a power that is not negative and is below the real part of the zero less the real part of the point. For every constant and every starting cutoff there is a cutoff beyond the start where the turned steps, less their smooth term, exceed the constant times the cutoff to that power.

How. The turned steps with the ramp, times the cutoff, are a staircase that is straight between the integers, so a bound at the integers is a bound at every real point. Its transform is the logarithmic derivative of zeta at the point shifted, over a quadratic. Under the bound the transform is analytic further left than the zero allows. The pattern is the tree's `ThetaConverse`, restated for the shifted series.

**Who wrote it.** An Opus worker wrote the file from the design block. Here it was rebuilt, searched for `sorry`, added axioms and `native_decide`, of which it has none, and the statement of `rain_steps` was read against the block. The proofs were checked by the kernel and were not read line by line here. The worker reports that the hypothesis that the zero is not the point is never used, the other hypotheses already giving it.

**What it says.** Unit `unit_run` 472 read a size rate from the turned steps. Unit `unit_upper` 487 proved the rate is at most the largest real part of a zero less the weight tried. This proves it is not less than any real part that occurs, less the weight: the steps reach that rate at cutoffs beyond every start. The proof names no cutoff. It is unit `unit_psi` 489 for the quantity the run measured.

What remains. Where the rises fall is not said.
