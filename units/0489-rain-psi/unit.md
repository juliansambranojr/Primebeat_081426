---
id: 0489
date: 2026-11-23
type: formalization
title: "At a zero the staircase leaves every bound below the zero's real part, again and again"
refs: [lean_stage3/Stage3/RateBelow.lean::rain_psi]
supersedes: []
follows: 0488
context: unit 0487 proved the size rate from above and left the rate from below as needing a zero to show uncancelled; Julian answered that the zero need not show at a given point, it is inferred from the trajectory; this is block R9 of `lean_stage3/design/runs.md`, for the staircase
sealed: false
---

**Question.** Block R9 of `lean_stage3/design/runs.md`. Does a zero force the staircase to rise to the zero's rate without the proof saying where?

**What was proved.** `lean_stage3/Stage3/RateBelow.lean`: `module_lines` 38 lines, `theorems_proved` 1 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 1 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8876 jobs, the module at `jobs_module` 8807. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`rain_psi`: take a nontrivial zero and any exponent below its real part. For every constant, every power of the logarithm and every starting point, there is a point beyond the start where the staircase stands further from the diagonal than the constant times the point to that exponent times that power of the logarithm.

How. The tree's `Stage3.no_zero_right_of_theta` says that if the staircase stayed inside such a bound from some point on, no zero would lie right of the exponent. The zero is there. So the staircase leaves the bound, beyond every start.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and the pin reads the standard axioms.

**What it says.** Julian's reading, as a theorem. The zero is not shown uncancelled at any given point. Its being there fixes what the staircase does again and again: it rises past every bound below the zero's rate. The proof gives no point where. With unit `unit_upper` 487 the rate is held from both sides for the staircase: at most the largest real part, and not less than any real part that occurs.

What remains. This is for the staircase. The same for the turned steps to a cutoff is being built.
