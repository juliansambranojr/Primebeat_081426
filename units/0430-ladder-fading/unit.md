---
id: 0430
date: 2026-11-22
type: formalization
title: "LadderFading.lean: a finite line of zeros does not fade from the cells"
refs: [lean_stage3/Stage3/LadderFading.lean::line_not_fading, lean_stage3/Stage3/LadderFading.lean::not_tendsto_powerSum]
supersedes: []
follows: 0429
context: unit 0429 showed that zeros the ladder folds together contribute one mode with nonzero weight; Julian asked, 2026-11-22, for the step from every zero present with nonzero weight to the cells being unable to stay small when a zero is off the line
sealed: false
---

**Question.** Block J10b of `lean_stage3/design/joints.md`. Can finitely many modes of one size, each present with a weight that is not zero, add up along the rows to something small against that size?

**What was proved.** `lean_stage3/Stage3/LadderFading.lean`: `module_lines` 161 lines, `theorems_proved` 4 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 4 error lines from two roots; clean on build `builds` 2. The package builds at `jobs_package` 8827 jobs, the module at `jobs_module` 8743. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`sum_sub_shift`: one difference with the symbol of a mode removes that mode from a sum of modes and multiplies every other weight by a factor that is not zero. This is the table's own operation.

`not_tendsto_powerSum`: finitely many distinct modes of one modulus, one of them with nonzero weight, do not fade: their sum over the common size does not tend to zero along the rows. The proof is induction on the number of modes by that difference.

`line_not_fading`: a nonempty finite set of zeros of zeta on one vertical line contributes to every cell of the table's own ladder, at every depth, a sum that does not tend to zero against two to the row times the line's real part. It joins unit 0429 to the theorem above: the zeros are grouped by their power of two, each group has nonzero weight, and all the groups have one modulus.

**What it says about joint `joint` 10.** A finite set of zeros off the line would force the cells past square-root size. This is the finite case of the step asked for.

What remains. The zeros off the line may be infinitely many, on infinitely many vertical lines, with no largest real part attained, and the sum over the zeros converges only conditionally. Two cases, in order: finitely many zeros off the line, where the rest of the explicit formula is bounded by the zero count and this unit closes the converse; and the general case, which needs the singularities of the row's generating function or power-sum theorems with a kernel along the rows. A literature search on 2026-11-22 found no statement of the one-ladder converse.
