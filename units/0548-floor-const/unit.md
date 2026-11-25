---
id: 0548
date: 2026-11-25
type: formalization
title: "floor-const"
refs: [lean_stage3/Stage3/FloorConst.lean::Kfl_levinson_lt, lean_stage3/Stage3/FloorConst.lean::kappa_levinson_ge, lean_stage3/Stage3/FloorConst.lean::floor_const]
supersedes: []
follows: 0547
context: unit 0547 bounded the plain mean by the real part of the operator applied to the main term; this computes that constant in closed form and its value for Levinson's polynomial, the closed-form step of block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the closed form. What is the limit of the operator applied to the main term, and at Levinson's polynomial and one rational choice of the length exponent and the shift, is the floor one minus the constant's logarithm over the shift positive?

**What was proved.** `lean_stage3/Stage3/FloorConst.lean`: `module_lines` 157 lines, `theorems_proved` 13 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 3 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8946 jobs, the module at `jobs_module` 8825. Traps added, `traps_added` 2; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`FloorConstDeriv.lean`: the partial derivatives of the main term off the line where the shifts sum to zero. `FloorConstLimit.lean`: `Kfl`, the constant in closed form in the three integrals of the polynomial's derivative squared, the polynomial times its derivative, and the polynomial squared; `dop_cY_eq`, the operator applied to the main term equal to it at the ratio of the mollifier's logarithm to the height's; `re_dop_tendsto`, the limit as the height grows; the three integrals for the identity polynomial. `Kfl_levinson_lt`: at Levinson's polynomial, length exponent `theta_choice` 49/100 and shift `R_choice` 13/10, the constant below the exponential of the shift. `kappa_levinson_ge`: the floor one minus the constant's logarithm over the shift is at least `kappa_proved` 1/3. `floor_const`: the limit, the bound and the floor together.

**The values.** Computed here from the closed form, not proved: the floor is `kappa_computed` 0.3354 at that choice and `kappa_half` 0.3427 at length exponent one half, Levinson's figure. The proved third has a small margin.

**Who wrote it.** One worker, `files` 3 files, after a symbolic check of the closed form against the operator. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 82 to `trap_last` 83.

What remains. One height of the window, and the sum over halvings.
