---
id: 0421
date: 2026-11-22
type: formalization
title: "GateEval.lean: the table gate's own inequality evaluated on the explicit-formula route, at depth six from row eighty"
refs: [lean_stage3/Stage3/GateEval.lean::gate_hyp_of_RH, lean_stage3/Stage3/GateEval.lean::gate_ineq, lean_stage3/Stage3/GateEval.lean::routeConst_le]
supersedes: []
follows: 0420
context: unit 0420 priced the route with a script's gate; block E9 read the Lean gate's hypotheses against the route's theorem and chose a floor and a depth; Julian said to build it, 2026-11-22; this is the Stage 3 half
sealed: false
---

**Question.** Block E9 of `lean_stage3/design/joints.md`, Stage 3's half. Under RH, does the route supply both of the gate's analytic hypotheses, the window statement and the gap, at some depth and row inside the computed table?

**What was proved.** `lean_stage3/Stage3/GateEval.lean`: `module_lines` 194 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins each at `axioms` 3 axioms, with `errors_first` 0 errors on the first build (`builds` 1). The package builds at `jobs_package` 8806 jobs, the module at `jobs_module` 8766. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`routeConst_le`: at the floor two to the `floor_exp` 36, the route's constant is at most `route_const` 414. The floor was chosen so its square root and fourth root are exact powers of two; the bound comes from the ceilings of unit 0419.

`gate_ineq`: for every real row of at least `row_min` 80, that numeral times the logarithm of the row times the route's decay is strictly under the gate's threshold at depth `depth` 6. The rows beyond eighty follow from the square of the row growing slower than the decay shrinks.

`gate_hyp_of_RH`: under RH, for every integer row of at least `row_min` 80, there is a relative error for which the gate's window statement holds on the rows of the prime count against the main term, and which is under the gate's threshold at depth `depth` 6.

**What it is for.** Its conclusion is written to be the hypothesis of the table tree's `RouteCell.cell_ne_zero_of_route` (unit 0422), character for character, with the welded definition on each side.

**What it is not.** Unconditional. A statement about the table by itself: the cell's nonvanishing is the other tree's theorem. Sharp: block E9's script had the inequality failing at row seventy-nine at this floor, and nothing here proves that.

What remains. Unit 0422, the table tree's half. Other depths, by the same two lemmas with their own rows.
