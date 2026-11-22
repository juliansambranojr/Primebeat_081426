---
id: 0437
date: 2026-11-22
type: formalization
title: "MirrorArea.lean: a mode and its mirror are the sides of a rectangle of fixed area; the square is the line"
refs: [lean_stage3/Stage3/MirrorArea.lean::mirror_area, lean_stage3/Stage3/MirrorArea.lean::square_iff, lean_stage3/Stage3/MirrorArea.lean::long_side_of_off_line]
supersedes: []
follows: 0433
context: Julian asked, 2026-11-22, whether a ceiling is needed once the constraints are known, as a square is known at every scale from its proportion and one side; the answer in the session was that a mode and its mirror have a fixed product, and he asked for it built after a search of the Lean trees for an earlier rectangle
sealed: false
---

**Question.** Block S1 of `lean_stage3/design/joints.md`. If a mode of the table and its mirror are the two sides of a figure, what is fixed about the figure at every scale, and when is it a square?

**What was proved.** `lean_stage3/Stage3/MirrorArea.lean`: `module_lines` 115 lines, `theorems_proved` 6 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8831 jobs, the module at `jobs_module` 3668. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`mirror_area`: the size of a mode at a base times the size of its mirror is the base, for every exponent. `mirror_side`: so the mirror's size is the base over the mode's size. One side gives the other at every scale.

`side_eq_sqrt_iff`, `square_iff`: a side is the square root of the base exactly when the exponent is on the line, and then both are. `long_side_of_off_line`: off the line one of the two sides is above the square root of the base.

`restoringForce_eq_log_ratio`: the restoring force of unit 0433 is the logarithm of the ratio of the two sides, in absolute value. It measures how far the rectangle is from the square.

**The search before the build.** Julian asked whether a rectangle had been chased before. The Lean trees of this repo and of the two sibling repos were searched for it. The rectangles found are contour rectangles in the zero count. Unit 0433 has the ratio of the sides. The fixed product was in none of them.

**What it says.** Square-root size is the square. The floor and the ceiling are the two sides of one rectangle whose area the base fixes.

What remains. The area holds for every exponent, so it does not force equal sides.
