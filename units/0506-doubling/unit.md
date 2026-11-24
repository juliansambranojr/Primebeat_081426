---
id: 0506
date: 2026-11-24
type: formalization
title: "The doubling, push and pull: the residuals at all scales, alternating, add to within 4 log N + 5"
refs: [lean_stage3/Stage3/Doubling.lean::alt_scales, lean_stage3/Stage3/Doubling.lean::alt_harmonic, lean_stage3/Stage3/Doubling.lean::alt_resid_small]
supersedes: []
follows: 0505
context: Julian asked for the attempt at the square-root bound at every number; the route takes the integers having no holes and the dyadic doubling; this is block R15 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R15 of `lean_stage3/design/runs.md`. What do the self-bound at a number and at its half give together, and how far does an induction on the scales reach toward the square-root bound?

**What was proved.** `lean_stage3/Stage3/Doubling.lean`: `module_lines` 260 lines, `theorems_proved` 9 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 2 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8887 jobs, the module at `jobs_module` 8840. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`alt_scales`: the staircase at the scales of a number, with signs alternating from the first scale, equals the logarithm of the number's factorial less twice the logarithm of its half's factorial. It is the self-bound at the number less twice the self-bound at its half; the even scales are the half's scales.

`alt_harmonic`: the alternating sum of the reciprocals up to a number is within one over the number of the logarithm of two.

`alt_resid_small`: the residuals of the staircase at the scales of a number, with alternating signs, add up to at most `c_log` 4 times the logarithm of the number plus `c_const` 5. The integers having no holes (unit `unit_holes` 503) and the doubling force the push and the pull of the residuals across all the scales to cancel to a logarithm, at every number.

**Who wrote it.** Built by one worker. Its first build stopped on one stuck instance, with the cascade on the pin; the rewrite was moved and the second build was clean. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The identity gives the residual at a number as the alternating sum of the residuals at its smaller scales plus a logarithm. An induction that assumes the square-root bound at the smaller scales and uses the sizes alone gets the square root times the sum of the reciprocal square roots of the scales, which grows like the number: the count of scales is a factor lost. Closing it needs the alternating residuals at the smaller scales to cancel among themselves, which is the open step. Nothing here proves it.
