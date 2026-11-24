---
id: 0521
date: 2026-11-24
type: formalization
title: "The turning along the line: an integral, split into the gamma part and the perturbed part, the latter minus its zeros to the right plus edge terms"
refs: [lean_stage3/Stage3/LevinsonTurn.lean::lift_turn_eq_integral, lean_stage3/Stage3/LevinsonTurn.lean::line_turn_eq_integral, lean_stage3/Stage3/LevinsonTurn.lean::turn_split, lean_stage3/Stage3/LevinsonTurn.lean::lineF_turn_eq, lean_stage3/Stage3/LevinsonTurn.lean::countRight_left_eq, lean_stage3/Stage3/LevinsonTurn.lean::G_turn_eq]
supersedes: []
follows: 0520
context: unit 0520 counted zeros on the line by the turning of an argument; this is step 1c of block S11 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Step 1c of block S11 of `lean_stage3/design/stencil.md`. Is the turning of the argument along the line an integral of the logarithmic derivative, splitting into the gamma part and the perturbed part, with the perturbed part minus two pi times its zeros to the right plus edge terms?

**What was proved.** `lean_stage3/Stage3/LevinsonTurn.lean`: `module_lines` 361 lines, `theorems_proved` 11 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 5 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8898 jobs, the module at `jobs_module` 8804. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`lift_turn_eq_integral`: the change of a continuous argument of a function with a continuous derivative equals the imaginary part of the integral of its logarithmic derivative, and `line_turn_eq_integral` reads it along the line as the real part of the integral of the logarithmic derivative of an analytic function. The proof shows the argument and the integral differ by an integer multiple of two pi that cannot jump (`int_valued_const`). `turn_split` and `lineF_turn_eq` split the turning of the gamma factor times the perturbed function into the two parts. `G_turn_eq`: the perturbed part equals minus two pi times the zeros of the perturbed function in the rectangle right of the line, with order, plus the bottom, top and right edge integrals; `countRight_left_eq` makes the count at the left edge the sum of all orders.

**Who wrote it.** One worker, whose first build stopped on a cast rewrite and a field_simp. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The sizes of the gamma part against the zero count and of the three edge integrals, and the mean value left of the line; nothing here proves the hypothesis.
