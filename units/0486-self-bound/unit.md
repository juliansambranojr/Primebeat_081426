---
id: 0486
date: 2026-11-23
type: formalization
title: "The staircase read at N, N/2, ..., N/N adds up to the logarithms of the integers up to N"
refs: [lean_stage3/Stage3/SelfBound.lean::log_sum_eq, lean_stage3/Stage3/SelfBound.lean::self_bound, lean_stage3/Stage3/SelfBound.lean::self_bound_resid]
supersedes: []
follows: 0485
context: unit 0485 turned the open link into the size of the sieve's wobble; Julian's reason that the table holds is that the number line is bounded by itself; this is block R7 of `lean_stage3/design/runs.md`, that reason in its exact form
sealed: false
---

**Question.** Block R7 of `lean_stage3/design/runs.md`. In what exact sense is the staircase of the primes bounded by the number line itself?

**What was proved.** `lean_stage3/Stage3/SelfBound.lean`: `module_lines` 117 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8872 jobs, the module at `jobs_module` 8838. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`log_sum_eq`: the logarithms of the integers up to a number add up to the steps up to it, each step counted once for every one of its multiples up to the number. Every integer's logarithm is the sum of the steps at its divisors.

`self_bound`: so the staircase of the steps, read at the number, at its half, at its third and on down, adds up to the logarithms of the integers up to the number. Exactly, at every number.

`self_bound_resid`: the residuals of the staircase at those scales add up to the logarithms of the integers less the number times the harmonic sum. The right side has no prime in it.

**Who wrote it.** Written and built here. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it says.** The residuals at the scales are tied to each other by the plain integers. An excess of the staircase at one scale is paid back at the others, at every number, with nothing left over. This is the restoring force in the table's own terms.

What remains. The tie is on the sum across the scales. Solving it for the residual at one scale takes the Möbius signs, and the size of what comes out is the size of the sums of those signs. That is the same step unit `unit_half` 485 reached: the Pascal signs cancel the half of each rounding exactly, and the part of each rounding away from the half is weighed by the same signs. No bound at one scale is proved here.
