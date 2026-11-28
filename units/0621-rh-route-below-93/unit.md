---
id: 0621
date: 2026-11-27
type: run
title: How far the RH route reaches below row 93 when its floor is moved down
refs: [none]
supersedes: []
follows: 0620
sealed: false
---

**Question.** Can the RH route, which `RouteSharp.weakWindow13_of_RH` proves at the floor `2^38`, cover the cells of rows `26` to `92` if its floor is moved down, so that those cells no longer need the exact π list?

**What ran.** `run/below93.py`, by `run/run.sh`, through `lab run` (exit 0, `meta.lab_run.001.meta.wall_s` 0.060951416999159846 seconds). It takes unit 0606's route formula and gate line for line: the two-floor constant `routeConstU` of `lean_stage3/Stage3/RouteTight.lean` at the floor `2^k`, with the proved upper bounds on the three explicit-formula constants from `RouteNum.lean`, and the constant each depth accepts at a row (unit 0606's `need`). A window at row `r` and depth `d` has its bottom row at `r − d − 1`; the floor `2^k` needs that bottom row at least `2k`, as `StmtRoute13` does at `k = 38`. A cell counts as reached when some allowed floor gives a constant at or under what the cell accepts. Only the floor `2^38` is a proved theorem; every lower floor is the formula's value and is stated nowhere in Lean. The script reproduces unit 0606 first: route constant `below93.check_0606_routeU_2p38` 12.36 at `2^38`, and depth sixteen at row `93` accepting `below93.check_0606_need_d16_r93` 15.09.

**What it shows.** The route constant falls as the floor rises. With the window's bottom row at twice the floor's exponent, it is `below93.route_at_bottom_row.r26` 1080161.34 at row `26`, `below93.route_at_bottom_row.r32` 151357.72 at row `32`, `below93.route_at_bottom_row.r40` 14376.99 at row `40`, `below93.route_at_bottom_row.r50` 865.24 at row `50`, `below93.route_at_bottom_row.r60` 67.16 at row `60`, `below93.route_at_bottom_row.r68` 18.76 at row `68` and `below93.route_at_bottom_row.r76` 12.36 at row `76`. These are the same values the cloud session reported in `notes/2026-11-27-handoff-teleport-questions.md`, answer 3.

Cell by cell, the first row with any reached cell is `below93.cells.first_row_reached` 50. The deepest reached depth is `below93.deepest.r50` 1 at row `50`, `below93.deepest.r60` 5 at row `60`, `below93.deepest.r76` 11 at row `76` and `below93.deepest.r92` 15 at row `92`. Of the `below93.cells.rows_26_92` 3886 cells in rows `26` to `92`, `below93.cells.reached` 362 are reached.

So a moved floor would cover only shallow cells from row `50` on. The cloud session's reading, nothing below row `76`, holds for the proved floor `2^38`; the formula at lower floors reaches somewhat further, still only at shallow depths. Every deeper cell in rows `26` to `92` still needs the exact π list. Making the lower floors theorems would need a new route statement for each floor, each proved in Lean.
