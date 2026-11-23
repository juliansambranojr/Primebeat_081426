---
id: 0433
date: 2026-11-22
type: formalization
title: "StencilWeil.lean: the table's stencil in Weil's form, and the restoring force as the mirror imbalance of a mode"
refs: [lean_stage3/Stage3/StencilWeil.lean::zeroForm_stencilTest, lean_stage3/Stage3/StencilWeil.lean::restoringForce_eq, lean_stage3/Stage3/StencilWeil.lean::handshake_iff]
supersedes: []
follows: 0432
context: the stencil as a test function for Weil's form is measured on this bench (papers/Connes-Measured.md section E, notebook entry 40) and its transform is in JointSymbol, but it was not inside the tree's Weil form; Julian pointed, 2026-11-22, to the sextic guardrail and the restoring force of his earlier repository lean_primebeat, read the same day
sealed: false
---

**Question.** Block T4 of `lean_stage3/design/joints.md`. Is the table's stencil, applied to a test function, a test function for the tree's Weil form, and with what weight does each zero of zeta then enter? And what is the restoring force of the earlier closed-loop file, read off a mode of the table?

**What was proved.** `lean_stage3/Stage3/StencilWeil.lean`: `module_lines` 299 lines, `theorems_proved` 13 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 7 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 2 error lines from one root; clean on build `builds_clean` 2, and a deprecated name replaced on build `builds` 3. The package builds at `jobs_package` 8829 jobs, the module at `jobs_module` 3667. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`laplace_stencilTest`: in the logarithmic variable a doubling is a shift, a shift multiplies the transform by an exponential, and so the stencil of depth `d` multiplies the transform of the test function by the symbol to the depth. `isTest_stencilTest`: the stencil of a test function is a test function on a window wider by the stencil's reach.

`zeroForm_stencilTest`: Weil's form on the stencil is the sum over the zeros in which each zero carries the symbol at the zero times the symbol at its mirror point, to the depth, times the test function's own pair. `mirror_symbol_on_line`: for a zero on the line that product of symbols is the square of the symbol's size.

`restoringForce`: the difference between the logarithm of a mode's size and the logarithm of its mirror's. `restoringForce_eq`: it is twice the distance of the real part from one half, times the logarithm of the base. `restoringForce_eq_zero_iff` and `handshake_iff`: it is zero, and the mode and its mirror have one size, exactly on the line. `restoringForce_mono`: at a larger base the same displacement gives a larger force.

`zeroForm_stencilTest_eq_primeSide`: given the bridge of unit 0379, the form on the stencil equals its prime side. `zeroForm_stencilTest_nonneg_of_RH`: under the Riemann hypothesis it is nonnegative.

**What the force is.** The earlier file has a handshake, a weight equal to its mirror weight, and a restoring force written as a multiple of the distance from one half. Both are the imbalance between a weight and its mirror. This unit states that imbalance for a mode of the table and proves its closed form. It measures the displacement. That an off-line zero is impossible is no part of it.

What remains. Positivity of the form on the stencil without the Riemann hypothesis, and the detection statement: a zero off the line making the form negative at some test function and depth. With those two the arrow of `WeilDetect` would run on the table's own stencil.
