---
id: 0529
date: 2026-11-25
type: formalization
title: "Levinson with multiple zeros: the zeros on the line divided out and counted back, so the window needs only the mean square"
refs: [lean_stage3/Stage3/LevinsonMultiple.lean::exists_prod_mul, lean_stage3/Stage3/LevinsonMultiple.lean::G_order_add_one, lean_stage3/Stage3/LevinsonMultiple.lean::zeta_order_ge, lean_stage3/Stage3/LevinsonMultiple.lean::sum_order_le_lineCount, lean_stage3/Stage3/LevinsonMultiple.lean::countRight_eq_of_mul, lean_stage3/Stage3/LevinsonMultiple.lean::factor_turn, lean_stage3/Stage3/LevinsonMultiple.lean::polyP_edges]
supersedes: []
follows: 0528
context: unit 0528 assembled one window of Levinson's method with the hypothesis that the zeros of zeta on the line are simple; Julian asked to remove it by counting; block S11 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S11 of `lean_stage3/design/stencil.md`, removing the simple-zero hypothesis. Can the zeros of the perturbed function on the line be divided out and counted back, so that Levinson's count holds with no condition on the line?

**What was proved.** `lean_stage3/Stage3/LevinsonMultiple.lean`: `module_lines` 1128 lines, `theorems_proved` 25 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 7 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8906 jobs, the module at `jobs_module` 8812. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`G_order_add_one`: where the perturbed function vanishes on the line, zeta vanishes to one order more. `exists_prod_mul` divides those zeros out of the perturbed function as a product `polyP` times a function analytic on the rectangle and nonzero on the line. `factor_turn` and `polyP_edges`: each factor turns by exactly pi around the bottom, right side and top, so the division costs pi times the total order in the edge terms. `sum_order_le_lineCount`: the line count weights each height by the order of zeta, which gives that total back. `countRight_eq_of_mul`: the zeros inside the rectangle do not change. `levinson_count'`: Levinson's count with no condition on the critical line, with the same constant. `levinson_window'`: one window of the method whose only named input is the mean square bound.

**Who wrote it.** One worker, whose first test stopped on one rewrite; the main theorem compiled at its first attempt. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The mean value for a mollifier, the mean value for long mollifiers, and the exact form of the count.
