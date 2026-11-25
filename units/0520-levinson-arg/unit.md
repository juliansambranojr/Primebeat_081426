---
id: 0520
date: 2026-11-24
type: formalization
title: "The argument along the line: a continuous lift, and its turning counts zeros of zeta on the line"
refs: [lean_stage3/Stage3/LevinsonArg.lean::exists_arg_lift, lean_stage3/Stage3/LevinsonArg.lean::crossings_of_arg, lean_stage3/Stage3/LevinsonArg.lean::continuous_lineF, lean_stage3/Stage3/LevinsonArg.lean::lineCount_ge_arg]
supersedes: []
follows: 0519
context: unit 0519 made the zeros of zeta on the line the crossings of the imaginary axis by the gamma factor times zeta plus its derivative; this is step 1b of block S11 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Step 1b of block S11 of `lean_stage3/design/stencil.md`. Does a continuous argument exist along the line, and does its turning count zeros of zeta on the line?

**What was proved.** `lean_stage3/Stage3/LevinsonArg.lean`: `module_lines` 308 lines, `theorems_proved` 7 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 5 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8897 jobs, the module at `jobs_module` 8802. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`exists_arg_lift`: a continuous function that never vanishes on an interval has a continuous argument there, by lifting the path through the covering of the punctured plane by the exponential. `crossings_of_arg`: an argument that turns by at least k times pi passes an odd multiple of pi over two at k distinct points, in order. `continuous_lineF`: the gamma factor times zeta plus a real multiple of its derivative is continuous along the line. `lineCount_ge_arg`: where the real factor of unit `unit_line` 519 does not vanish, the turning of that product's argument by k times pi between two heights gives at least k zeros of zeta on the line up to the upper height.

**Who wrote it.** One worker, whose first build stopped on a simp step and two rewrites. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The split of the turning into the horizon and the zeros of the perturbed function right of the line, by the argument principle, and the mean value left of the line; nothing here proves the hypothesis.
