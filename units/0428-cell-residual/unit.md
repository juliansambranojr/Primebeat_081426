---
id: 0428
date: 2026-11-22
type: formalization
title: "CellResidual.lean: RH is the cells at square-root size, over every dyadic ladder"
refs: [lean_stage3/Stage3/CellResidual.lean::RH_iff_cells, lean_stage3/Stage3/CellResidual.lean::table_cell_resid]
supersedes: []
follows: 0427
context: Julian asked, 2026-11-22, for the sentence "RH holds if and only if the residual in every cell stays at square-root size as the table continues"; unit 0427 put the Riemann hypothesis on the count
sealed: false
---

**Question.** Block T5 of `lean_stage3/design/joints.md`, second part. Is the Riemann hypothesis equivalent to every cell's residual staying at square-root size, and for which cells?

**What was proved.** `lean_stage3/Stage3/CellResidual.lean`: `module_lines` 492 lines, `theorems_proved` 15 theorems, `defs` 4 definitions, `sorries` 0 sorries, `pins` 5 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 3 error lines from one root; clean on build `builds` 2. The package builds at `jobs_package` 8825 jobs, the module at `jobs_module` 8780. Traps unchanged by this module, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

The residual of a cell is the cell of the count minus the same cell of the smooth row `Li`, on the dyadic ladder started at `a`. `CellsSqrt` says every such residual, for every starting point between one and two, every depth and every row past a first one, is at most a constant times `cellSize`.

`RH_iff_cells`: the Riemann hypothesis holds exactly when some constant and some first row make `CellsSqrt` true. Forward is `cells_of_schoenfeldWeak` under unit 0427. The converse, `schoenfeldWeak_of_cells`, reads the cells at depth `depth_used` 0 only: summed up one ladder they bound the count's residual on every rung, at the cost of the constant `telescope_const` 4, and the ladders together are every `x`.

`table_cell_eq` and `table_cell_resid`: on the table itself, `Construction.tableFrom` on the row of dyadic block counts, the cell minus the smooth cell is the residual on the ladder started at one, and under the Riemann hypothesis it stays at square-root size.

**Which cells.** The equivalence is over every ladder. On the table's own ladder alone the forward direction is proved and the converse is joint `joint_open` 10 of `SECTIONS.md`: between two rungs the count rises by far more than the square root, so a bound at the rungs bounds nothing between them.

What remains. The converse on the one ladder, which is joint `joint_open` 10; and joints T2, T3, T4.
