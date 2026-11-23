---
id: 0445
date: 2026-11-23
type: formalization
title: "FiniteOffLinePi.lean: with finitely many zeros off the line, the prime count at the doublings within square-root size of Li gives the Riemann hypothesis"
refs: [lean_stage3/Stage3/FiniteOffLinePi.lean::finite_off_line_pi, lean_stage3/Stage3/FiniteOffLinePi.lean::norm_ipart_le, lean_stage3/Stage3/FiniteOffLinePi.lean::row_bound]
supersedes: []
follows: 0444
context: unit 0439 proved the finite case of joint 10 on the cells of the log-weighted count and left the prime count to joint T2; units 0442 and 0444 closed T2 to within square-root size; Julian said on 2026-11-23 to work on the open items inside those units
sealed: false
---

**Question.** Block J10e of `lean_stage3/design/joints.md`. If only finitely many zeros of zeta are off the line, does the prime count at the doublings alone, held within square-root size of its smooth part, force them all onto it?

**What was proved.** `lean_stage3/Stage3/FiniteOffLinePi.lean`: `module_lines` 630 lines, `theorems_proved` 13 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 3 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8837 jobs, the module at `jobs_module` 8792. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`finite_off_line_pi`: let a finite set hold every zero off the line. Suppose that from some row on the prime count at the row's doubling is within a constant times the square of the row times the square root of the doubling of the smooth count. Then the Riemann hypothesis holds. The hypothesis reads the count at the doublings and nowhere else.

How. Unit 0442 and unit 0444 write the count less its smooth part as minus the sum over the zeros below the point of each zero's part, within square-root size. `norm_ipart_le` sizes the integral inside one zero's part; `norm_piMode_half` gives a zero on the line a part of square-root size over its own size, with constant `half_const` 12; the top line off the line keeps its full power. `row_bound` and `rowBound_isLittleO`: the top line's sum is then smaller than its own size, which unit 0430 forbids.

**Who wrote it.** An Opus worker, from a brief with the statement and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it says.** On the table's own ladder, the integer count sees a finite set of zeros off the line. It is the statement of unit 0439 carried from the log-weighted count to the count the table is made of.

What remains. Infinitely many zeros off the line. The cells at depth of the integer table, where the hypothesis would be on differences of the count.
