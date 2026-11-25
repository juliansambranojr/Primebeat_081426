---
id: 0530
date: 2026-11-25
type: formalization
title: "The approximate functional equation: Young's Lemma 4 exactly, given the contour shift"
refs: [lean_stage3/Stage3/ApproxFE.lean::zeta_prod_fe, lean_stage3/Stage3/ApproxFE.lean::XY_eq_young, lean_stage3/Stage3/ApproxFE.lean::gY_eq_young, lean_stage3/Stage3/ApproxFE.lean::coef_eq_young, lean_stage3/Stage3/ApproxFE.lean::mellin_double_sum, lean_stage3/Stage3/ApproxFE.lean::FY_reflect, lean_stage3/Stage3/ApproxFE.lean::vertInt_reflect, lean_stage3/Stage3/ApproxFE.lean::residue_zero, lean_stage3/Stage3/ApproxFE.lean::approxFE_of_shift]
supersedes: []
follows: 0529
context: block S12 of `lean_stage3/design/stencil.md` designs the mollified mean value; this is its piece one, Young's Lemma 4, the approximate functional equation
sealed: false
---

**Question.** Piece one of block S12 of `lean_stage3/design/stencil.md`. Is the product of zeta at one half plus alpha plus i t and at one half plus beta minus i t equal to two smoothed double sums joined by the gamma ratio, less explicit residues, once the contour shift holds?

**What was proved.** `lean_stage3/Stage3/ApproxFE.lean`: `module_lines` 765 lines, `theorems_proved` 35 theorems, `defs` 10 definitions, `sorries` 0 sorries, `pins` 9 axiom pins. The first build had `errors_first` 11 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8907 jobs, the module at `jobs_module` 8669. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`zeta_prod_fe`: the product of the two zeta values is the gamma ratio `XY` times the product at the reflected points, from the functional equation of the completed zeta; `XY_eq_young` and `gY_eq_young` show the ratios are Young's. `mellin_double_sum`: each smoothed double sum is the vertical integral of the smoothing over s times the gamma ratio times the two zeta values, by absolute convergence under a Gaussian bound on the kernel. `FY_reflect` and `vertInt_reflect`: the integral on the left line is minus the gamma ratio times the swapped integral on the right line. `residue_zero`: the residue at zero is the product of the two zeta values. `approxFE_of_shift`: the approximate functional equation exactly, the product equal to the first sum plus the ratio times the swapped sum less the residues `resY`, given the named statement `StmtShift` that the two vertical integrals differ by those residues. The four residues other than zero sit near heights where the smoothing is tiny; the zero of the smoothing's polynomial serves a later step of Young's proof.

**Who wrote it.** One worker, whose first build stopped on argument names, a set, a composition, a norm rewrite and a nonzero fact. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The contour shift `StmtShift`, the size of the residues, the bounds on the weight, the twisted second moment, the operator and the unsmoothing.
