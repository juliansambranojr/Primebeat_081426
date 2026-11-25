---
id: 0545
date: 2026-11-25
type: formalization
title: "operator"
refs: [lean_stage3/Stage3/Operator.lean::Ires_o, lean_stage3/Stage3/Operator.lean::stmtMollMeanO_holds]
supersedes: []
follows: 0544
context: unit 0544 closed Young's Lemma 3 with a little o error; this applies Levinson's differential operator to it and gives the mollified mean, piece 3 of block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, piece 3. Does the smoothed mean of Levinson's function, zeta plus its derivative over the logarithm, times the mollifier, equal the operator applied to the main term times the weight's mean, up to little o of the height?

**What was proved.** `lean_stage3/Stage3/Operator.lean`: `module_lines` 310 lines, `theorems_proved` 3 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 3 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8939 jobs, the module at `jobs_module` 8839. Traps added, `traps_added` 4; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`OperatorInt.lean`: the twisted moment differentiated under the integral in each shift, and `Dop_Imom`, the operator applied to the twisted moment at the shifts of the mollifier's line equal to the smoothed mean of Levinson's function times the mollifier. `OperatorCY.lean`: the main term written as an analytic function off the diagonal where the shifts sum to zero, with its partial derivatives. `OperatorCauchy.lean`: the operator, its linearity, and Cauchy's bound on each partial derivative, one variable at a time, on circles of radius a fixed fraction of one over the logarithm. `Ires_o`: the remainder little o of the height. `stmtMollMeanO_holds`: the smoothed mollified mean of Levinson's function equal to the operator applied to the main term times the weight's mean, up to little o of the height, for a polynomial vanishing at zero, a length exponent between zero and one half and a positive shift, over the windows bounded to every order. The operator's factors of one over the logarithm cancel Cauchy's one over the radius, so no factor is lost.

**Who wrote it.** One worker, `files` 4 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, and the package was rebuilt here; each pin reads the standard axioms. The worker took the regime's constant as twice the shift plus one plus its inverse, because the brief's twice the shift plus one fails the regime's lower bound on the sum of the shifts for a small shift. Traps: TRAPS.md rows `trap_first` 76 to `trap_last` 79.

What remains. The unsmoothing, the window restated, and the assembly with the closed form of the main term.
