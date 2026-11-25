---
id: 0533
date: 2026-11-25
type: formalization
title: "The derivatives of the weight: Young's (4.3) for the first and second derivative in the height"
refs: [lean_stage3/Stage3/ApproxDeriv.lean::hasDerivAt_Gammaℝ, lean_stage3/Stage3/ApproxDeriv.lean::gY_hasDerivAt, lean_stage3/Stage3/ApproxDeriv.lean::hasSum_tau, lean_stage3/Stage3/ApproxDeriv.lean::dY_hasSum, lean_stage3/Stage3/ApproxDeriv.lean::norm_dY_le, lean_stage3/Stage3/ApproxDeriv.lean::norm_d2Y_le, lean_stage3/Stage3/ApproxDeriv.lean::dY_hasDerivAt, lean_stage3/Stage3/ApproxDeriv.lean::dY_bound, lean_stage3/Stage3/ApproxDeriv.lean::d2Y_bound, lean_stage3/Stage3/ApproxDeriv.lean::VYj_line_bound, lean_stage3/Stage3/ApproxDeriv.lean::VYj_lines, lean_stage3/Stage3/ApproxDeriv.lean::VY_hasDerivAt, lean_stage3/Stage3/ApproxDeriv.lean::VY1_hasDerivAt, lean_stage3/Stage3/ApproxDeriv.lean::iteratedDeriv_VY, lean_stage3/Stage3/ApproxDeriv.lean::VY_deriv_bound]
supersedes: []
follows: 0532
context: unit 0532 gave the sizes of the weight of the approximate functional equation; the twisted moment of block S12 of `lean_stage3/design/stencil.md` integrates by parts and needs the derivatives of the weight in the height; this is piece 2b-i
sealed: false
---

**Question.** Piece 2b-i of block S12 of `lean_stage3/design/stencil.md`. Is the weight of the approximate functional equation differentiable in the height, with its first and second derivatives, times the matching power of the height, decaying like the weight itself?

**What was proved.** `lean_stage3/Stage3/ApproxDeriv.lean`: `module_lines` 1302 lines, `theorems_proved` 49 theorems, `defs` 8 definitions, `sorries` 0 sorries, `pins` 15 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8910 jobs, the module at `jobs_module` 8810. Three rows added to TRAPS, `traps_added` 3; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`VY_hasDerivAt`, `VY1_hasDerivAt` and `iteratedDeriv_VY`: the weight is twice differentiable in the height at every real height, its derivatives the vertical integrals `VY1` and `VY2` of the integrand times a digamma difference `dY`, and times its square plus the series `d2Y`. `dY_bound`, `d2Y_bound`, `norm_dY_le` and `norm_d2Y_le` bound those factors by powers of the size of s over the height, from the digamma series differentiated term by term (`hasSum_tau`, `dY_hasSum`, `dY_hasDerivAt`). `VY_deriv_bound`: the first and second derivatives, times the height to the matching power, are at most a constant times one plus the inverse square of the sum of the shifts, times any negative power of one plus the argument over the height. `VYj_line_bound` and `VYj_lines` read them on any line.

**Who wrote it.** One worker, whose scratch passes stopped on products of functions, a binder type, a stuck instance, one-sided normalization, a too-deep gcongr and an unreduced application. Three of those classes are new rows of `lean_stage3/TRAPS.md`. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. Higher derivatives by induction, the twisted moment, the operator and the unsmoothing.
