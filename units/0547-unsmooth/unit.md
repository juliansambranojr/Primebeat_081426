---
id: 0547
date: 2026-11-25
type: formalization
title: "unsmooth"
refs: [lean_stage3/Stage3/Unsmooth.lean::mollMean_re, lean_stage3/Stage3/Unsmooth.lean::unsmooth_near, lean_stage3/Stage3/Unsmooth.lean::unsmooth_near_levinson]
supersedes: []
follows: 0546
context: unit 0545 gave the smoothed mollified mean; this removes the weight for the windows Levinson's argument uses, the unsmoothing step of block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the unsmoothing. Is the plain mean of Levinson's function times the mollifier over the near-full windows of the top half of the height at most the real part of the operator applied to the main term, plus any fixed amount, from some height on?

**What was proved.** `lean_stage3/Stage3/Unsmooth.lean`: `module_lines` 238 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 2 error lines; clean on build `builds` 5. The package builds at `jobs_package` 8943 jobs, the module at `jobs_module` 8845. Traps added, `traps_added` 2; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`UnsmoothWin.lean`: a window bounded to every order with value one on the top half of the height and support inside the weights' range, its mean at most half the height plus three times the height over its logarithm, and the plain integral of a nonnegative function at most its weighted integral. `UnsmoothCY.lean`: `dop_cY_bdd`, the operator applied to the main term bounded independently of the height, by Cauchy's bound on circles of a fixed fraction of one over the logarithm. `mollMean_re`: the smoothed mean is real. `unsmooth_near`: the plain mean over windows whose ends lie within one of half the height and of the height at most the real part of the operator applied to the main term plus any fixed amount, from some height on. `unsmooth_near_levinson`: the same in the exact integrand of `levinson_window_diff`, zeta plus one over the logarithm times its derivative, times the mollifier.

**Sizes.** The window's excess over the plain window is of the height over its logarithm, and the main term is bounded, so the excess costs a constant over the logarithm; a main term growing like the logarithm would have used up that factor, which is why the bound on the operator is proved.

**Who wrote it.** One worker, `files` 3 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 80 to `trap_last` 81.

What remains. The assembly: the closed form of the main term and its value, one height of the window with the abscissa carried by continuity, and the sum over halvings.
