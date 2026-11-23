---
id: 0432
date: 2026-11-22
type: formalization
title: "LadderMean.lean: infinitely many zeros on one line do not fade from the cells"
refs: [lean_stage3/Stage3/LadderMean.lean::line_not_fading_summable, lean_stage3/Stage3/LadderMean.lean::mean_extract]
supersedes: []
follows: 0431
context: unit 0430 showed that finitely many modes of one size cannot fade, by induction on their number; the general case of joint 10 has infinitely many; Julian asked for the general case, 2026-11-22, and unit 0431 records where it stops
sealed: false
---

**Question.** Block J10c of `lean_stage3/design/joints.md`. Can infinitely many modes of one size, with absolutely summable weights, add up along the rows to something that fades?

**What was proved.** `lean_stage3/Stage3/LadderMean.lean`: `module_lines` 229 lines, `theorems_proved` 4 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 2 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8828 jobs, the module at `jobs_module` 8744. Traps unchanged, `traps_added` 0; `assumed_pins` 1, the summability named below; loop version `loop_version` 22, `steps_skipped` 1 step skipped.

`mean_extract`: for an absolutely summable sum of rotations that tends to zero along the rows, the weights of all the modes equal to any one mode add to zero. The proof averages along the rows: the mean of a rotation that is not the identity tends to zero, the mean of the identity is one, and dominated convergence carries the limit through the sum.

`line_not_fading_summable`: for any set of zeros of zeta on one vertical line over which the sum of multiplicity over modulus converges, and any one zero in it, the set's contribution to every cell of the table's own ladder does not tend to zero against two to the row times the line's real part. The folded class of the chosen zero has weight a sum of terms with positive real part, so it is not zero, and `mean_extract` forbids the fading.

**The hypothesis.** The summability over the zeros is assumed. Over all the zeros it fails. Over the zeros right of a line past one half it follows from a zero-density estimate, which is not in the tree.

What remains. Unit 0431 names it: the case where the largest real part off the line is not attained, and the two inputs the reduction needs.
