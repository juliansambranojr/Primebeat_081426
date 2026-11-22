---
id: 0442
date: 2026-11-22
type: formalization
title: "PiZeros.lean: the integer table's cell as a sum over the zeros, an exact identity"
refs: [lean_stage3/Stage3/PiZeros.lean::pi_eq_zero_sum, lean_stage3/Stage3/PiZeros.lean::table_cell_eq_zero_sum, lean_stage3/Stage3/PiZeros.lean::norm_tr_psiTheta_le]
supersedes: []
follows: 0441
context: joint T2 of the sections file asks for joint T1 in the integer table, the count of primes in place of the log-weighted count, zero by zero; the tree carried bounds across that passage and no sum; Julian said on 2026-11-22 to go for all of the open items, T2 and T3 being the fourth
sealed: false
---

**Question.** Block T2 of `lean_stage3/design/joints.md`. What is the cell of the integer table, the table of the prime count along the doublings, as a sum over the zeros?

**What was proved.** `lean_stage3/Stage3/PiZeros.lean`: `module_lines` 321 lines, `theorems_proved` 15 theorems, `defs` 5 definitions, `sorries` 0 sorries, `pins` 3 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 5 error lines; clean on build `builds` 5. The package builds at `jobs_package` 8835 jobs, the module at `jobs_module` 8790. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

The passage. Going from the log-weighted count to the count is linear: the value over the logarithm, plus an integral against a fixed weight. `tr_sub`, `tr_const_mul`, `tr_sum` say so. `pi_sub_Li_eq_tr`: the count minus its smooth part is that passage applied to the first Chebyshev function less the identity, which is the identity of the tree's older module.

`pi_eq_zero_sum`: for any height, the count minus its smooth part equals minus the sum over the zeros below the height of each zero's part, plus the passage of the explicit formula's remainder at that height, minus the passage of the higher prime powers. It is an equality, at every point from two on and at every height. A zero's part of the count is the passage applied to its power over itself.

`norm_tr_psiTheta_le`: the higher prime powers pass to at most `powers_const` 8 times the square root.

`table_cell_eq_zero_sum`: the same three terms under the stencil give the table's cell less the smooth cell, for rows at least two above the depth.

**What it says.** The integer table's cell is a sum over the zeros, one term for each, exactly, with two named remainders. One of them is of square-root size. Each zero enters the count through the same linear passage.

What remains. A bound on the passage of the explicit formula's remainder. The formula bounds that remainder only when the height is at most the square of the point, so the low end of the integral needs its own estimate. The closed form of a zero's part as a logarithmic integral.
