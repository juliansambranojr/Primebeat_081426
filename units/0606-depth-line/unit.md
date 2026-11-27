---
id: 0606
date: 2026-11-27
type: formalization
title: Every depth past the line r = 4d + 30, and depths 1 to 16 in every row, under the two-floor RH route
refs: [lean_stage3/Stage3/PsiToPiSharp.lean::schoenfeldWeak_of_psiWeak_two, lean_stage3/Stage3/RouteTight.lean::weakWindow13_of_RH, lean/WeakDepths.lean::only_four_zeros_rh_le16, lean/WeakDepths.lean::sq_le_shift, lean/WeakDepths.lean::line_base, lean/WeakDepths.lean::weak13_lt_floor_far, lean/WeakDepths.lean::only_four_zeros_rh_line]
supersedes: []
follows: 0605
sealed: false
---

**Question.** Depth sixteen needs a smaller route constant than the sharp transfer gives (unit 0605, per-row-route). Once it is there, does one theorem cover every depth from some row on?

**What ran.** In `lean_stage3/`: `PsiToPiSharp` and `RouteTight` (52dc577); in `lean/`: `WeakDepths` (8238d36, 04858ee). Each built by `lake build` with exit 0. `run/line.py`, by `run/run.sh`, through `lab run`, evaluates the route's constant, the line's arithmetic at its start, and each depth's closing row; `run/pins.py` reads the pins and runs the weld check.

**Two floors.** The transfer reads the ψ bound in two places: inside an integral from the floor `x₀`, and at the point `x` itself, which is at least `x₀²`. `schoenfeldWeak_of_psiWeak_two` takes a ψ bound from each floor. At two to the thirty-eighth the floor constant is `line.F_2p38` 37.99, and at its square `line.F_2p76` 10.667. The route's constant becomes `line.routeU` 12.36, stated as `line.stated` 13 (`weakWindow13_of_RH`). Depth sixteen accepts up to `line.need_d16_r93` 15.09 at the first uncomputed row, and `only_four_zeros_rh_le16` carries every depth through sixteen, every row.

**The line.** `only_four_zeros_rh_line`: a zero at depth up to sixteen, or in a row at least four times the depth plus thirty at any depth, is one of the four, given the π list (`PiNarrow.StmtPiData23`) and the route. Two lemmas carry it to every depth. `sq_le_shift`: the square of the row against the square root of its size falls from six on, so the gate holds along each row once it holds at the line. `line_base`: at the line the gate holds for every depth from sixteen, by induction on the depth; at depth sixteen its two sides stand in the ratio `line.line_base_ratio_d16` 0.913. Its pin reads `pins.pins.only_four_zeros_rh_line.axioms` "propext, Classical.choice, Quot.sound"; the weld check passed with `pins.welds_ok` 20 welds and `pins.welds_broken` 0 broken.

**How close the line sits.** At constant thirteen the gate itself closes depth seventeen from row `line.closing13.d17` 97, depth thirty from `line.closing13.d30` 146 and depth one hundred from `line.closing13.d100` 400, against the line's `line.line.d17` 98, `line.line.d30` 150 and `line.line.d100` 430. At Schoenfeld's constant it would close them from `line.closing_true.d17` 94, `line.closing_true.d30` 129 and `line.closing_true.d100` 384. So the line can be pulled down to a slope near three and a half and no further by error bounds.

**What is left.** The cells at depth seventeen and up, from the first uncomputed row to the line: infinitely many, each a sum over the zeros that no bound in the tree holds away from zero.
