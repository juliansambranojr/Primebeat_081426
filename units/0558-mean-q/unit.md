---
id: 0558
date: 2026-11-25
type: formalization
title: "mean-q"
refs: [lean_stage3/Stage3/MeanQ.lean::unsmooth_V, lean_stage3/Stage3/MeanQ.lean::window_V_long, lean_stage3/Stage3/MeanQ.lean::window_V_lt_half]
supersedes: []
follows: 0557
context: units 0556 and 0557 gave Conrey's count for a general polynomial; this gives the mean value it needs, step three of the general-polynomial round of block S13 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S13 of `lean_stage3/design/stencil.md`, the general polynomial, step three. Is the plain mean of Conrey's function times the mollifier over the near-full windows of the top half of the height at most the real part of the general operator applied to the main term, plus any fixed amount?

**What was proved.** `lean_stage3/Stage3/MeanQ.lean`: `module_lines` 234 lines, `theorems_proved` 4 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 16. The package builds at `jobs_package` 8972 jobs, the module at `jobs_module` 8859. Traps added, `traps_added` 6; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`MeanQRed.lean`: Conrey's function written exactly as a combination of zeta's derivatives with the gamma factor's derivative ratios as coefficients, and its distance from the polynomial's operator on zeta at most a constant over the logarithm times the derivatives' sizes, from one named statement of those ratios, `StmtGrRatio`. `MeanQCauchy.lean`: the general operator, its linearity, and Cauchy's bound to every order on circles of a fixed fraction of one over the logarithm, with no factor left over. `MeanQInt.lean`: the general operator on the twisted moment equal to the smoothed mean of the polynomial's operator on zeta times the mollifier. `MeanQMean.lean` and `MeanQBound.lean`: that mean equal to the operator on the main term times the weight's mean, up to little o of the height, from the level of Young's lemma at any length and with no hypothesis below one half; the main term bounded for every length. `MeanQV.lean`: the same for Conrey's function, its difference from the operator's paid by a pointwise inequality at a cost of the height over its logarithm. `unsmooth_V`, `window_V_long` and `window_V_lt_half`: the plain mean over the near-full windows at most the real part of the operator on the main term plus any fixed amount, in the integrand of Conrey's count.

**Sizes.** The reduction was checked numerically by the worker; no factor grows with the height.

**Who wrote it.** One worker, `files` 7 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 102 to `trap_last` 107.

What remains. `StmtGrRatio`, the closed form for a general polynomial, and the assembly.
