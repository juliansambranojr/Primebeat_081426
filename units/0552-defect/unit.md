---
id: 0552
date: 2026-11-25
type: formalization
title: "defect"
refs: [lean_stage3/Stage3/Defect.lean::defect_nonneg, lean_stage3/Stage3/Defect.lean::rh_iff_defect_zero, lean_stage3/Stage3/Defect.lean::N_le_allCount, lean_stage3/Stage3/Defect.lean::N_eq_allCount_right, lean_stage3/Stage3/Defect.lean::offLine_pair, lean_stage3/Stage3/Defect.lean::defect_even, lean_stage3/Stage3/Defect.lean::defect_le_of_floor, lean_stage3/Stage3/Defect.lean::defect_le, lean_stage3/Stage3/Defect.lean::defectN_le]
supersedes: []
follows: 0551
context: block S14 of `lean_stage3/design/stencil.md` names the defect, the zeros off the line, as stage C's target; this is its first step, C1
sealed: false
---

**Question.** Block S14 of `lean_stage3/design/stencil.md`, step C1. Is the count of zeros off the critical line even, is the Riemann hypothesis its vanishing at every height, and how large can Levinson's floor leave it?

**What was proved.** `lean_stage3/Stage3/Defect.lean`: `module_lines` 369 lines, `theorems_proved` 20 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 9 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8952 jobs, the module at `jobs_module` 8867. Traps added, `traps_added` 3; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`defect`: the zeros up to the height, counted with order, less those on the line. `defect_nonneg` and `rh_iff_defect_zero`: the Riemann hypothesis is the defect zero at every height. `N_le_allCount` and `N_eq_allCount_right`: the zero count `riemannZeta.N` counts heights below the height and the line counts count heights up to it, and just above any height the two agree. `offLine_pair` and `defect_even`: every zero off the line pairs with its mirror, one minus its conjugate, at the same height and with the same order, so the defect is even. `defect_le_of_floor`: any floor with proportion c gives the defect at most one minus c, plus any fixed amount, of the count. `defect_le` and `defectN_le`: from Levinson's floor, the defect at most `defect_frac` 2/3, plus any fixed amount, of the count.

**A finding.** The difference of the zero count and the line count can be negative when a zero on the line sits at the height, so the defect is defined from the closed count, the form `rh_iff_line_count` takes.

**Who wrote it.** One worker. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, the package was rebuilt here, and each pin reads the standard axioms. The mirror and the symmetry of the order were already in the tree. Traps: TRAPS.md rows `trap_first` 88 to `trap_last` 90.

What remains. Stage C's local face: a count on a short window whose error is below the step of the defect.
