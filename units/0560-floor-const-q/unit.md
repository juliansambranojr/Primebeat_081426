---
id: 0560
date: 2026-11-25
type: formalization
title: "floor-const-q"
refs: [lean_stage3/Stage3/FloorConstQ.lean::KflQ_lt, lean_stage3/Stage3/FloorConstQ.lean::log_KflQ_lt, lean_stage3/Stage3/FloorConstQ.lean::kappaQ_gt, lean_stage3/Stage3/FloorConstQ.lean::floor_constQ]
supersedes: []
follows: 0559
context: unit 0548 computed Levinson's constant for the linear polynomial; this computes it for a general one and its value at a cubic, step four of the general-polynomial round of block S13 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S13 of `lean_stage3/design/stencil.md`, the general polynomial, step four. What is the limit of the general operator applied to the main term, and at a cubic mollifier polynomial and a cubic operator polynomial, is the floor above one third?

**What was proved.** `lean_stage3/Stage3/FloorConstQ.lean`: `module_lines` 268 lines, `theorems_proved` 34 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 6. The package builds at `jobs_package` 8976 jobs, the module at `jobs_module` 8828. Traps added, `traps_added` 6; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`FloorConstQDeriv.lean`: the iterated partial derivatives of the main term, written as a function of the two shifts' sum and product, through the recursion of the derivatives of one minus the exponential over its argument. `FloorConstQLimit.lean`: `KflQ`, the constant for a general polynomial as a finite double sum; `dopQ_cY_eq`, the general operator on the main term equal to it exactly; `re_dopQ_tendsto`, its limit as the height grows; `KflQ_one_sub`, Levinson's constant of unit 0548 again at one minus x. `KflQ_lt` and `log_KflQ_lt`: at a cubic mollifier polynomial, a cubic operator polynomial with the symmetry and value one at zero, length exponent forty-nine hundredths and shift three halves, the constant's logarithm below the shift times one minus `kappa_q_proved` 224/625. `kappaQ_gt` and `floor_constQ`: that floor above one third, with the limit.

**The values.** Computed, not proved: the floor at the choice is `kappa_q_computed` 0.35843; the constant agrees with Young's integral form numerically at three points, and no Lean statement equates the two.

**Who wrote it.** One worker, `files` 3 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 109 to `trap_last` 114.

What remains. The assembly: one window with Conrey's function, and the sum over halvings.
