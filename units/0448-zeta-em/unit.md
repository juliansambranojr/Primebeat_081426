---
id: 0448
date: 2026-11-23
type: formalization
title: "ZetaEM.lean: zeta as a finite sum to any order, with the remainder bounded; stage three of the zero-density bound"
refs: [lean_stage3/Stage3/ZetaEM.lean::zeta_eq_em, lean_stage3/Stage3/ZetaEM.lean::norm_remainder_le, lean_stage3/Stage3/ZetaEM.lean::norm_zeta_sub_partial_le]
supersedes: []
follows: 0447
context: the third of the seven blocks of `lean_stage3/design/carlson.md`, the zero-density bound Julian asked on 2026-11-23 to have proved here; the tree had this step at order two, which forces a finite sum too long to keep the saving near one half
sealed: false
---

**Question.** Block C3 of `lean_stage3/design/carlson.md`. How well does a finite sum approximate zeta right of zero, at any order of the Euler–Maclaurin formula?

**What was proved.** `lean_stage3/Stage3/ZetaEM.lean`: `module_lines` 515 lines, `theorems_proved` 20 theorems, `defs` 7 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8840 jobs, the module at `jobs_module` 8675. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`zeta_eq_em`: for every order from one on, every positive length and every exponent with positive real part other than one, zeta equals its finite sum, less the smooth term, less half the last term, plus a finite sum of boundary terms, plus a remainder. The remainder is a product of the exponent's shifts over a factorial, times an integral of a periodic Bernoulli function against a power. The proof is an induction on the order; each step is one integration by parts, `emInt_step`.

`norm_remainder_le`: the remainder is at most that product's size over the factorial, times the largest value of the Bernoulli function, times the length to one minus the real part minus the order, over the real part plus the order minus one.

`norm_zeta_sub_partial_le`: for order at least `order_min` 2, when the size of the exponent plus the order is at most the length, zeta less its finite sum, with the smooth term put back, is at most a constant depending on the order, times the length to minus the real part, times one plus the size of the exponent plus the order to the order times the length to one minus the order.

**Who wrote it.** An Opus worker, from a brief with the statements and the route, generalising the order-two module of the tree. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it is for.** At a high order the last factor is bounded once the length is a small power above the height. So zeta is its finite sum of that length, up to the length to minus the real part, and the finite sum is what unit 0446 and unit 0447 can measure.

What remains. The constant is finite and has no computed value: the largest value of each Bernoulli function is taken as a supremum. Blocks C4 to C7 of the design.
