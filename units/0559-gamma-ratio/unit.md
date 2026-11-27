---
id: 0559
date: 2026-11-25
type: formalization
title: "gamma-ratio"
refs: [lean_stage3/Stage3/GrRatio.lean::gamma_ratio8, lean_stage3/Stage3/GrRatio.lean::grR_sub, lean_stage3/Stage3/GrRatio.lean::stmtGrRatio_holds]
supersedes: []
follows: 0558
context: unit 0558 left the general-polynomial mean on one named statement of the gamma factor's derivative ratios; this proves it, in the general-polynomial round of block S13 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S13 of `lean_stage3/design/stencil.md`, the gamma ratio. Are the gamma factor's derivative ratios, scaled by the powers of minus one over the logarithm, within a constant over the logarithm of the powers of minus one half, on the strip of the mollifier's line and the top of the height?

**What was proved.** `lean_stage3/Stage3/GrRatio.lean`: `module_lines` 364 lines, `theorems_proved` 13 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8973 jobs, the module at `jobs_module` 8869. Traps added, `traps_added` 1; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`gamma_ratio8`: the ratio of gamma factors on small circles bounded on the strip from an eighth to seven, from the crude Stirling bound in the tree, so that circles around the mollifier's line fit. `grR_sub`: the scaled derivative ratio less the power of minus one half written exactly as a sum of derivatives of the gamma ratio with the shift of half the logarithm taken out. `stmtGrRatio_holds`: the named statement of unit 0558 for every order, by Cauchy's estimate on circles of fixed radius. `window_V_lt_half'` and `mollMeanV_long'`: the general-polynomial window bound and mean with no hypothesis below one half, and from Young's lemma at any length.

**Sizes.** The radius is fixed, so each derivative costs a constant and each power of one over the logarithm saves one. The worker checked the ratios numerically over six decades of the height; they stay bounded.

**Who wrote it.** One worker. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, the package was rebuilt here, and each pin reads the standard axioms. Trap: TRAPS.md row `trap_row` 108.

What remains. The closed form for a general polynomial and the assembly.
