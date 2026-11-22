---
id: 0424
date: 2026-11-22
type: formalization
title: "TableDepths.lean: under RH, depths one to eight of the table have no zero from a named row on; and a checker that holds the ported modules to their originals"
refs: [lean_stage3/Stage3/TableDepths.lean::cell_ne_zero_gen, lean_stage3/Stage3/TableDepths.lean::depth_one, lean_stage3/Stage3/TableDepths.lean::depth_eight]
supersedes: []
follows: 0423
context: unit 0423 closed the join for depth six and left two things: the same theorem at other depths, and nothing comparing the ported modules with their originals; Julian said to do both, 2026-11-22
sealed: false
---

**Question.** Block E11 of `lean_stage3/design/joints.md`. At which depths does the route close the gate inside the computed table, and from which row?

**What was proved.** `lean_stage3/Stage3/TableDepths.lean`: `module_lines` 312 lines, `theorems_proved` 14 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 4 axiom pins each at `axioms` 3 axioms, clean on build `builds` 1 with `errors_first` 0 errors. The package builds at `jobs_package` 8818 jobs, the module at `jobs_module` 8778. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`cell_ne_zero_gen` is the route and the gate at any depth: under RH, given the floor and one numeric check of the gate's gap at a starting row, the cell is nonzero at every row from there on. The rows beyond the first follow because the square of the row grows slower than the route's decay shrinks.

The instances, `depths` 8 of them. Under RH, no cell of the table is zero:

- at depth one from row `row_d1` 74;
- at depth two from row `row_d2` 75;
- at depth three from row `row_d3` 76;
- at depth four from row `row_d4` 77;
- at depth five from row `row_d5` 78;
- at depth six from row `row_d6` 80;
- at depth seven from row `row_d7` 85;
- at depth eight from row `row_d8` 91.

For the first five the floor is what sets the row; from six on it is the gap. The census reaches row `table_extent` 92, so each of these rows is inside it. Depth nine would first hold at row `row_d9_script` 96 by the block's script, past the census, and is not proved here.

**The checker.** `utilities/check_port.py` rewrites each original's import lines, diffs it against its copy in `TablePort`, and compares that diff with a recorded one. It covers the `port_modules` 10 modules and reports `port_drift` 0 drifted. An edit to one copy was tried and caught, then undone.

**What the eight say with the census.** For each depth from one to eight, RH and the computed rows below the named row together determine every zero of the table at that depth: the route rules out the rows above, and the rows below are finite and computed.

What remains. Depths past eight need either a larger computed table or a smaller constant. On the map, the direction from the table to the zeros.
