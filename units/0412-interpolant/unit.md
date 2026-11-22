---
id: 0412
date: 2026-11-22
type: formalization
title: "Interpolant.lean: the smooth interpolant of the main term constructed, and the table's gate stated with nothing assumed about the main term"
refs: [lean/Interpolant.lean::liRow_contDiff, lean/Interpolant.lean::liRow_hasDerivAt, lean/Interpolant.lean::tableFrom_ne_zero_of_relErr_liRow]
supersedes: []
follows: 0411
context: unit 0403 recorded that every gate theorem in the table's tree takes a smooth interpolant of the main term as a hypothesis and that no file constructs one; Julian named it, with the route's constants, as what is open on this stretch, 2026-11-22
sealed: false
---

**Question.** Block C1 of `lean_stage3/design/joints.md`. Is there a function, smooth on the whole line, whose derivative beyond one half is two to the `x` over `x`, as the gate theorems require?

**What was proved.** In the table's tree, toolchain `toolchain` 4.28.0: `lean/Interpolant.lean`, `module_lines` 149 lines, `theorems_proved` 8 theorems and `defs` 2 definitions, `sorries` 0 sorries, `pins` 8 axiom pins each at `axioms` 3 axioms. The first build had `errors_first` 4 error lines, one proof step and the pins above it; clean on build `builds` 2. The module builds at `jobs_module` 8034 jobs and the tree at `jobs_tree` 8055; its index reads `theorems_lean` 344 theorems across `modules_lean` 29 modules.

The construction. `F` is the antiderivative of two to the `x` over `x` taken from one, plus the constant two over the logarithm of two. It has the right derivative wherever `x` is positive and is smooth there. It has no reason to be smooth at zero, so `liRow` is `F` times Mathlib's smooth transition, arranged to be zero up to `cut_lo` 1/4 and one from `cut_hi` 1/2. `liRow_contDiff` is smoothness on the whole line, `liRow_hasDerivAt` the derivative beyond one half, `liRow_eq` that it is `F` itself from one half on.

`tableFrom_ne_zero_of_relErr_liRow` is the gate with the interpolant put in: a relative error on a window of rows against `liRow`, below the gate's threshold, in the region where the depth is small against the row, makes the cell nonzero. The two hypotheses about the main term that all `interpolant_hyps` 4 gate theorems carried before are gone from it.

**What it does not prove.** That `liRow` at a row is the other tree's `Li` at that power of two. The constant was chosen so that it is, at the first row and so at every row from there on, but the other tree defines `Li` by a different formula and the equality is a lemma that has not been written in either tree. Until it is, the route of unit 0411 and this gate meet at a statement whose main term is named two ways.

What remains. That lemma, in Stage 3 where `Li` lives: `Li (2^x)` equals two over the logarithm of two plus the integral, for `x` from one on. Then the weld for the main term. And the route's constants as numerals.
