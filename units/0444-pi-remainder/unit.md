---
id: 0444
date: 2026-11-23
type: formalization
title: "PiRemainder.lean: the explicit formula's remainder, passed to the count, is of square-root size"
refs: [lean_stage3/Stage3/PiRemainder.lean::norm_tr_efRem_le, lean_stage3/Stage3/PiRemainder.lean::norm_tr_efRem_le_of, lean_stage3/Stage3/PiRemainder.lean::zinv_le_log]
supersedes: []
follows: 0442
context: unit 0442 wrote the prime count as a sum over the zeros with two remainders and bounded one; the other, the explicit formula's remainder passed to the count, was left open; Julian said on 2026-11-23 to work on the open items inside the units of the day before
sealed: false
---

**Question.** Block T2b of `lean_stage3/design/joints.md`. How large is the explicit formula's remainder once it is passed from the log-weighted count to the count?

**What was proved.** `lean_stage3/Stage3/PiRemainder.lean`: `module_lines` 521 lines, `theorems_proved` 15 theorems, `defs` 4 definitions, `sorries` 0 sorries, `pins` 3 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 5 error lines from one root; clean on build `builds` 2. The package builds at `jobs_package` 8836 jobs, the module at `jobs_module` 8791. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`norm_tr_efRem_le`: there are a constant and a floor such that, from the floor on, the remainder at the height equal to the point, passed to the count, is at most the constant times the square root times the square of the logarithm. No hypothesis on the zeros is made. `norm_tr_efRem_le_of` gives the floor as `floor` 256 and names the constant.

How. The integral is split at the square root of the point. Above it the explicit formula applies and the piece is a constant times the square root. Below it the formula does not apply; the count is bounded by a multiple of the variable and the zero sum by the variable times a sum over all the zeros below the height, each weighted by its order over its size. `zinv_le_log`: that sum is at most a constant times the square of the logarithm. The zeros of height below one are finitely many and enter the constant.

**Who wrote it.** An Opus worker, from a brief with the statement and a sketch of the route, as Julian asked for the usage limits. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it says.** With unit 0442, the prime count less its smooth part is minus the sum over the zeros below the point of each zero's part, to within a constant times the square root times the square of the logarithm. A zero off the line has a part larger than that; a zero on the line does not.

What remains. The same at a general height. The finite off-line theorem stated on the count.
