---
id: 0519
date: 2026-11-24
type: formalization
title: "Levinson on the line: the zeros of zeta on the critical line are where the gamma factor times zeta plus its derivative crosses the imaginary axis"
refs: [lean_stage3/Stage3/LevinsonLine.lean::deriv_xi_line_im, lean_stage3/Stage3/LevinsonLine.lean::re_gammaR_G_line, lean_stage3/Stage3/LevinsonLine.lean::zeta_line_zero_iff]
supersedes: []
follows: 0518
context: block S11 of `lean_stage3/design/stencil.md` was checked against Young and Feng, and its step 1, the counting lemma neither states, was derived here; this is step 1a
sealed: false
---

**Question.** Step 1a of block S11 of `lean_stage3/design/stencil.md`. On the critical line, is the real part of the gamma factor times zeta plus a real multiple of its derivative the completed zeta times a real factor, so that the zeros of zeta on the line are where that product crosses the imaginary axis?

**What was proved.** `lean_stage3/Stage3/LevinsonLine.lean`: `module_lines` 160 lines, `theorems_proved` 6 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8896 jobs, the module at `jobs_module` 3173. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`deriv_xi_line_im`: the derivative of the completed zeta is purely imaginary on the critical line, because the completed zeta is real there (unit `unit_hardy` 516) and the derivative along the line is its derivative times i. `re_gammaR_G_line`: for any real constant, the real part of the gamma factor times zeta plus that constant times the derivative of zeta equals the completed zeta times one less the constant times the real part of the logarithmic derivative of the gamma factor. `zeta_line_zero_iff`: where that factor is not zero, zeta vanishes at a point of the line exactly when that real part does.

This is the core of Levinson's counting lemma, derived in block S11. The sources read state the setup and the final bound and cite Conrey for the lemma.

**Who wrote it.** One worker, whose first build was clean. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The count through a continuous argument along the line, the argument principle for the perturbed function, and the mean value left of the line; nothing here proves the hypothesis.
