---
id: 0525
date: 2026-11-24
type: formalization
title: "Levinson to the right: the zeros of the perturbed function are bounded by a log mean square just left of the line"
refs: [lean_stage3/Stage3/LevinsonRight.lean::zeros_right_le, lean_stage3/Stage3/LevinsonRight.lean::log_integral_le, lean_stage3/Stage3/LevinsonRight.lean::log_integral_norm_le, lean_stage3/Stage3/LevinsonRight.lean::countRight_mul_ge, lean_stage3/Stage3/LevinsonRight.lean::countRight_left_eq, lean_stage3/Stage3/LevinsonRight.lean::levinson_right]
supersedes: []
follows: 0524
context: unit 0524 paid for the zeros off the line with the zeros of zeta plus its derivative to the right; this is steps 2 to 4 of block S11 of `lean_stage3/design/stencil.md`, which bound those by a mean square
sealed: false
---

**Question.** Steps two to four of block S11 of `lean_stage3/design/stencil.md`. Are the zeros of zeta plus its derivative to the right of the line bounded by the logarithm of the mean square of that function times a mollifier on a line just left of the critical line, plus edge terms?

**What was proved.** `lean_stage3/Stage3/LevinsonRight.lean`: `module_lines` 330 lines, `theorems_proved` 7 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 6 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8902 jobs, the module at `jobs_module` 8808. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`zeros_right_le`: by Littlewood's lemma, two pi times the distance from the left side to an abscissa times the count of zeros right of it is at most the right side of `littlewood_rect`. `log_integral_le` and `log_integral_norm_le`: the integral of the logarithm of a positive function is at most the length times the logarithm of its mean, from the tangent line of the logarithm; for a norm it is half the length times the logarithm of the mean square. `countRight_mul_ge`: multiplying by an analytic function only adds zeros. `countRight_left_eq`: moving the left side of the rectangle does not change the count right of an abscissa. `levinson_right`: the zeros of the perturbed function right of the line are at most the inverse of two pi times the distance of the left line from one half, times half the length times the logarithm of the mean square of the perturbed function times the mollifier on the left line, plus the edge terms.

**Who wrote it.** One worker, whose first build stopped on a lemma name and a composition. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The edge terms for a concrete mollifier, the avoidance hypotheses, and the mean value left of the line; nothing here proves the hypothesis.
