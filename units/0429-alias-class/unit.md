---
id: 0429
date: 2026-11-22
type: formalization
title: "AliasClass.lean: zeros the ladder folds together never cancel"
refs: [lean_stage3/Stage3/AliasClass.lean::alias_weight_ne_zero, lean_stage3/Stage3/AliasClass.lean::sum_order_div_ne_zero]
supersedes: []
follows: 0428
context: unit 0428 proved the Riemann hypothesis equivalent to the cells at square-root size over every dyadic ladder and left the converse on the table's own ladder as joint 10; this is the first piece of that joint
sealed: false
---

**Question.** Block J10a of `lean_stage3/design/joints.md`. On the one ladder the zeros of zeta enter the cell only through the power of two at the zero, so zeros whose heights differ by a multiple of the ladder's period are folded together. Can folded zeros cancel each other in a cell?

**What was proved.** `lean_stage3/Stage3/AliasClass.lean`: `module_lines` 133 lines, `theorems_proved` 8 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8826 jobs, the module at `jobs_module` 8742. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`sum_order_div_ne_zero`: the coefficients a nonempty finite set of zeros carries in the cell, multiplicity over the zero, never add to zero, because the reciprocal of every nontrivial zero has positive real part.

`alias_weight` and `alias_weight_ne_zero`: zeros sharing the same power of two have the same symbol and the same mode at every row, so together they contribute one mode, with weight the sum of their coefficients times the symbol to the depth; that weight is not zero at any depth or row.

**What it says about joint `joint` 10.** The ladder folds heights and keeps real parts: the modulus of the power of two at a zero is two to the zero's real part. So every zero is present in the table's own cells, as a mode whose size carries its real part, with a weight no other zero can cancel.

What remains. The step from every zero present with nonzero weight to the cells of the one ladder being unable to stay at square-root size when a zero lies off the line. The sum over the zeros does not converge absolutely, so that step is a statement about power sums at consecutive integers or about the singularities of a power series; it is open in block J10a.
