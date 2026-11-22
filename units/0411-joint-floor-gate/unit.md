---
id: 0411
date: 2026-11-22
type: formalization
title: "JointFloorGate.lean: the explicit-formula route carried to the statement the table's gate takes"
refs: [lean_stage3/Stage3/JointFloorGate.lean::weakWindow_relErr, lean_stage3/Stage3/JointFloorGate.lean::relErrWindow_floor_of_RH]
supersedes: []
follows: 0410
context: unit 0409 proved the route as a bound on the prime count for all x above a floor and unit 0410 priced it with a script's gate; the gate in the table's tree takes a relative error on a window of rows; Julian said to go on, 2026-11-22
sealed: false
---

**Question.** Block E3 of `lean_stage3/design/joints.md`. Does the route's theorem reach `StmtRelErrWindow`, the statement the table's gate takes, with an explicit relative error?

**What was proved.** `lean_stage3/Stage3/JointFloorGate.lean`: `module_lines` 92 lines, `theorems_proved` 2 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins each at `axioms` 3 axioms, clean on build `builds` 1 with `errors_first` 0 errors. The package builds at `jobs_package` 8796 jobs, the module at `jobs_module` 8756. The traps are unchanged, `traps_added` 0; no hypothesis beyond the block's, `assumed_pins` 0. Loop version `loop_version` 22, `steps_skipped` 2 steps skipped as in unit 0409. The welds are as they were: `welds` 10, `broken_welds` 0 broken.

`weakWindow_relErr`: a weak window with constant `C` and power `k` of the logarithm is the gate's relative-error window, with relative error `C` times the logarithm of the top row to the power `k` times two to the power minus half the bottom row.

`relErrWindow_floor_of_RH`: under RH there are three non-negative constants such that for every floor of at least `floor_min` 16 and every window of rows whose bottom row is above the floor squared, the rows of the prime count and of `Li` satisfy the gate's statement, with relative error three times `floorConstSplit` plus thirteen, times the logarithm of the top row, times two to the power minus half the bottom row.

**Where this leaves the route.** In Stage 3 it now runs in one line of theorems from RH to the hypothesis of the gate. The gate itself, `RelativeLi.tableFrom_ne_zero_of_relErr_li'`, is in the table's tree on another toolchain; the two meet at `StmtRelErrWindow`, held by the weld, as joint five of `SECTIONS.md` already was. The gate's own conditions stay as unit 0403 left them: the smooth interpolant of the main term, constructed in no file, and the region where the depth is small against the row.

**What it is not.** Unconditional, or a numeral. RH is a hypothesis and the three constants are existential.

What remains. The constants as numerals; the interpolant; and the direction from the table to the zeros, which this stretch does not touch.
