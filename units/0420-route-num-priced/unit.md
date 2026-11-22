---
id: 0420
date: 2026-11-22
type: result-triage
title: "The gate priced from the kernel-checked ceilings: the explicit-formula route covers depth six at rung 76, the figure unit 0410 gave for floors"
refs: [lean_stage3/Stage3/RouteNum.lean::relErrWindow_route_num, lean_stage3/Stage3/RouteNum.lean::c1n_le, lean_stage3/Stage3/RouteNum.lean::c4n_le]
supersedes: []
follows: 0419
context: unit 0419 proved numerals above the three constants of the route; unit 0410 had priced the route with floors on them and said the true figures would sit above; this reruns the pricing on what is proved, 2026-11-22
sealed: false
---

**Question.** With the three constants at their proved ceilings, where does the route cover depth six?

**What ran.** `run/price_num.py`, EXPLORATORY, no prereg. O68's `R_of` imported unchanged, one logarithm, floor the square of the `ψ` floor. The constants are the ceilings of `RouteNum`: `price_num.c1` 88216610000.0, `price_num.c3` 15.0, `price_num.c4` 6468930000.0. The constant of the theorem increases with each, so the figures below are upper bounds on it.

**What it shows.** At a `ψ` floor of two to the `price_num.log2_psi_floor` 34.0, `floorConstSplit` is at most `price_num.floorConstSplit` 227.1, of which the band's numerals are `price_num.band_part` 90.8 and the left edge `price_num.left_part` 136.3; the constant on the `π` side is at most `price_num.routeConst` 694.3. Depth covered is `price_num.depth_covered` 9. The sixth depth closes at rung `price_num.R6` 76 against the ceiling rung `price_num.ceiling_rung` 93, `price_num.margin_rungs` 17 rungs inside.

**Reading.** Unit 0410 priced the same route with floors on the constants and found rung 76. With ceilings the kernel has checked, it is rung 76 again: the quantities that were unnamed then cost nothing at this resolution. The constant in this pricing is no longer an estimate of the theorem's constant; it is a bound on it.

Three things stay outside the kernel. The theorem assumes RH. The gate here is a script's function; the Lean gate in the table's tree has not been evaluated at these numbers. And the join between the route and that gate is the text weld. So this is a pricing of a conditional theorem, and no statement about the table.

What remains. Evaluating the Lean gate's inequality at a floor and a window, which would make one conditional statement about named cells; and, on the map, the direction from the table to the zeros.
