---
id: 0518
date: 2026-11-24
type: formalization
title: "Littlewood's lemma on a rectangle, with no branch of the argument"
refs: [lean_stage3/Stage3/Littlewood.lean::littlewood_rect, lean_stage3/Stage3/Littlewood.lean::littlewood_rect_zero_free, lean_stage3/Stage3/Littlewood.lean::integral_countRight, lean_stage3/Stage3/Littlewood.lean::two_pi_count_eq, lean_stage3/Stage3/Littlewood.lean::integrableOn_logDeriv, lean_stage3/Stage3/Littlewood.lean::integral_re_logDeriv_horizontal]
supersedes: []
follows: 0517
context: step four of block S10 of `lean_stage3/design/stencil.md` needs Littlewood's lemma as the first piece of Levinson's method; Julian said go
sealed: false
---

**Question.** Step 4a of block S10 of `lean_stage3/design/stencil.md`. Does the weighted count of the zeros of an analytic function in a rectangle equal the integrals of the logarithm of its size up the two vertical sides, plus edge terms, with no branch of the argument?

**What was proved.** `lean_stage3/Stage3/Littlewood.lean`: `module_lines` 627 lines, `theorems_proved` 28 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8895 jobs, the module at `jobs_module` 8671. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`littlewood_rect`: for a function analytic on a closed rectangle and nonzero on its border, two pi times the sum over its zeros of the order times the distance of the real part from the left side equals the integral of the logarithm of the size up the left side, less the same up the right side, plus three edge terms that are plain integrals of the logarithmic derivative. `integral_countRight` integrates the count of zeros right of each abscissa; `two_pi_count_eq` is the argument principle at one abscissa; `integrableOn_logDeriv` makes the logarithmic derivative integrable on the rectangle across its poles, which is what lets the order of integration be swapped; `integral_re_logDeriv_horizontal` turns the real part along a horizontal line into a difference of logarithms of sizes. `littlewood_rect_zero_free` is the case with no zeros.

**Who wrote it.** One worker. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. Levinson's lemma, bounds on the edge terms, and the mean square of the mollified function just left of the line; nothing here proves the hypothesis.
