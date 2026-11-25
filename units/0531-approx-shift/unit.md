---
id: 0531
date: 2026-11-25
type: formalization
title: "The contour shift: Young's approximate functional equation holds outright"
refs: [lean_stage3/Stage3/ApproxShift.lean::FL_bound, lean_stage3/Stage3/ApproxShift.lean::FY_horiz_bound, lean_stage3/Stage3/ApproxShift.lean::Lambda_bound, lean_stage3/Stage3/ApproxShift.lean::FL_horiz_tendsto, lean_stage3/Stage3/ApproxShift.lean::stmtShift_holds, lean_stage3/Stage3/ApproxShift.lean::approxFE]
supersedes: []
follows: 0530
context: unit 0530 proved Young's approximate functional equation given a named contour shift; this proves the shift, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the contour shift. Do the two vertical integrals of the approximate functional equation differ by exactly the five residues, so that Young's Lemma 4 holds with no hypothesis on the shift?

**What was proved.** `lean_stage3/Stage3/ApproxShift.lean`: `module_lines` 813 lines, `theorems_proved` 29 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8908 jobs, the module at `jobs_module` 8808. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`Lambda_bound`: the completed zeta grows at most linearly in its size on every vertical strip, away from the real axis, from the bound on the gamma factor right of the imaginary axis, the tree's zeta bounds, and the functional equation for the left half. `FL_bound` and `FY_horiz_bound`: on the horizontal edges the integrand is at most a constant times the Gaussian of the height, so `FL_horiz_tendsto` sends those edges to zero. `stmtShift_holds`: the residue theorem on rectangles and the limit in the height give the contour shift, the residues matched term by term to `resY`. `approxFE`: Young's approximate functional equation as an exact identity, for real parts of the shifts strictly between minus one half and one half, their sum nonzero and the two shifted points distinct.

**Who wrote it.** One worker, whose builds stopped on a composition, an implicit constant, two bullets and a macro line break. The contour work runs on a form of the integrand with the completed zeta, equal to the original off two heights. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The size of the residues, the bounds on the weight, the twisted second moment, the operator and the unsmoothing.
