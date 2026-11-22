---
id: 0426
date: 2026-11-22
type: formalization
title: "CellModes.lean: the table tree's mode theorem with its open hypothesis met by the explicit formula; the zeros of zeta are the modes"
refs: [lean_stage3/Stage3/CellModes.lean::cell_eq_modeSum]
supersedes: []
follows: 0425
context: the table tree proves that a row which is a sum of modes gives cells that are the same sum reweighted by the symbol at each depth, under a hypothesis discharged nowhere; unit 0425 proved the cell as a sum over the zeros; Julian asked for the two to be joined, 2026-11-22
sealed: false
---

**Question.** Block T1 of `lean_stage3/design/joints.md`, second part. Stated with the table tree's own `Sym`, `mode` and `modeSum`, does the row of the prime count satisfy the conclusion of `Superposition.tableFrom_eq_modeSum_reweighted`?

**What was done.** The `ported_now` 3 mode modules of the table's tree were copied into `Stage3/TablePort/` and built on Stage 3's toolchain; `Chain` differs from its original by `diff_chain` 2 diff lines, one proof step, and the other two by none. The drift checker now covers `port_modules` 13 modules and reports `port_drift` 0 drifted.

**What was proved.** `lean_stage3/Stage3/CellModes.lean`: `module_lines` 99 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 1 axiom pin at `axioms` 3 axioms. The first build had `errors_first` 2 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8823 jobs, the module at `jobs_module` 8741. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`mode_two_int` and `sym_two` identify the table tree's mode and symbol at base two with the powers used in unit 0425.

`cell_eq_modeSum`: for the row of the log-weighted prime count at the doublings, the stencil at a depth and a row, minus the symbol at one to the depth times the mode at one, plus the table tree's `modeSum` over the zeros below a height, with coefficient the multiplicity over the zero times the symbol at that zero to the depth, is within the explicit formula's error. No RH.

**How it meets the table tree's theorem.** `tableFrom_eq_modeSum_reweighted` concludes that a cell is `modeSum` with each coefficient multiplied by the symbol to the depth, from the hypothesis that the row is exactly a sum of modes. That hypothesis asks more than any prime count can give: the explicit formula makes the row a sum of modes up to an error, and so the conclusion holds up to that error. This theorem is that conclusion, with the modes named: the main term is the mode at one, and the others are the zeros of zeta.

What remains. The four joints still open under "One object" in `SECTIONS.md`.
