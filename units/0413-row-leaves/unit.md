---
id: 0413
date: 2026-11-22
type: formalization
title: "RowLeaves.lean: Stage 3's Li at the doublings is the table tree's interpolant, and the value of the logarithmic derivative of zeta at zero"
refs: [lean_stage3/Stage3/RowLeaves.lean::Li_two_rpow, lean_stage3/Stage3/RowLeaves.lean::hasDerivAt_Li, lean_stage3/Stage3/RowLeaves.lean::norm_logDerivZeta_zero]
supersedes: []
follows: 0412
context: unit 0412 constructed the interpolant in the table's tree and left unproved that it is Stage 3's Li at the rows; of the five unnamed quantities under the route's constants one was a short lemma from Mathlib; Julian chose these two, 2026-11-22
sealed: false
---

**Question.** Block E4 of `lean_stage3/design/joints.md`. Is Stage 3's `Li` at two to the `x` the antiderivative the table's tree uses, and is the value at zero a number?

**What was proved.** `lean_stage3/Stage3/RowLeaves.lean`: `module_lines` 160 lines, `theorems_proved` 7 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins each at `axioms` 3 axioms. The first build had `errors_first` 3 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8797 jobs, the module at `jobs_module` 8657. One line added to the traps, `traps_added` 1; no hypothesis beyond the block's, `assumed_pins` 0. Loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before; both first-build errors were of the kind the scratch pass exists for.

`hasDerivAt_Li`: beyond one, the derivative of `Li` is one over the logarithm.

`Li_two_rpow`: for positive `x`, `Li` at two to the `x` equals two over the logarithm of two, plus the integral from one to `x` of `e` to the logarithm of two times `t`, over `t`. Both sides have the same derivative on the positive axis and agree at one. The right side is what `lean/Interpolant.liRow_eq` states for the table tree's `liRow` from one half on, once `Expansion.f2x` is unfolded.

`norm_logDerivZeta_zero`: the norm of the logarithmic derivative of zeta at zero is the logarithm of two pi, from Mathlib's values of zeta and its derivative there. It is the quantity `K0` in the explicit formula's constants.

**What it settles.** The main term is one function in the two trees: at every row from the first on, the table tree's interpolant and Stage 3's `Li` are given by the same formula, each proved in its own tree. The join is by text, as every join between the trees is; no weld was added, because the checker compares definitions and this is a formula inside two theorems. Of the `unnamed_before` 5 quantities under the route's constants, `unnamed_after` 4 remain.

What remains. The four: the count of zeros on the real segment, the count below height six, the supremum on the short segment, and the compact patch. Each needs a bound on zeta in a bounded region. And `K0` is proved as a number but not yet used: `explicit_formula_split` still takes it as the norm.
