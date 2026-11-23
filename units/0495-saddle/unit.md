---
id: 0495
date: 2026-11-23
type: formalization
title: "One row down is the baker's fold; a zero off the line is a saddle and makes the staircase run away"
refs: [lean_stage3/Stage3/Saddle.lean::fold_rounding, lean_stage3/Stage3/Saddle.lean::fold_mirror, lean_stage3/Stage3/Saddle.lean::saddle_area, lean_stage3/Stage3/Saddle.lean::saddle_of_off_line, lean_stage3/Stage3/Saddle.lean::saddle_runs_away, lean_stage3/Stage3/Saddle.lean::spiralLink_iff_noRunaway]
supersedes: []
follows: 0494
context: Julian named the baker's map and Lorenz's butterfly for the table and asked whether a zero off the line is a saddle point; his paper on the prime-composite butterfly holds the two wings and the seam; this is block J7 of `lean_stage3/design/closedloop.md`, his sequence of three steps and the saddle
sealed: false
---

**Question.** Block J7 of `lean_stage3/design/closedloop.md`. Is the table stretch and fold, is a zero off the line a saddle, and what does a saddle do to the staircase?

**What was proved.** `lean_stage3/Stage3/Saddle.lean`: `module_lines` 198 lines, `theorems_proved` 11 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8880 jobs, the module at `jobs_module` 8844. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`fold_fract`, `fold_rounding`: doubling a number doubles its fractional part and folds it back into the unit. Going down a row of the table doubles the bound, so every rounding of the sieve is doubled and folded: the baker's fold.

`fold_mirror`: away from the fold's own edge, the fold of the mirror image is the mirror image of the fold.

`stretch_eq`, `saddle_area`: against the square root of the total, a doubling multiplies the mode of a zero by two to the closed loop's deviation, and its mirror's by two to minus that. The product is a unit of area.

`saddle_of_off_line`, `centre_iff`: off the line a factor is above the unit and the other below it, a saddle. On the line both are the unit, a centre, and the doubling only turns the mode.

`saddle_runs_away`: if some zero is off the line, the staircase leaves every bound of square-root size, beyond every start.

`centre_of_noRunaway`, `spiralLink_iff_noRunaway`, `spiralLink_iff_centres`: if the staircase does not run away in the square-root frame, every zero is a centre. The spiral link is the staircase not running away, and it is every zero being a centre.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it says.** Julian's first and second steps are theorems. The table is stretch and fold. A zero off the line is a saddle, the table always has weight on its runaway direction, and the staircase then runs away. His third step, that the table is bounded by itself and so has no runaway, Lean takes as the same statement as the link.

What remains. A proof of the third step. Unit `unit_tie` 486 ties the scales exactly, and unit `unit_scales` 492 measured that a bound at a single scale does not follow from that tie by adding sizes.
