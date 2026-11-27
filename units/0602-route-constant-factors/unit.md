---
id: 0602
date: 2026-11-27
type: decision
title: The route constant: two lost factors found and removed, and where the rest of it sits
refs: [lean_stage3/Stage3/PsiToPiSharp.lean::schoenfeldWeak_of_psiWeak_sharp, lean_stage3/Stage3/RouteTight.lean::weakWindow40_of_RH, lean/WeakDepths.lean::H_w2_ge2, lean/WeakDepths.lean::only_four_zeros_rh_le15, lean_stage3/Stage3/GlueNum.lean::c4n, lean_stage3/Stage3/AssemblyFloor.lean::floorConst]
supersedes: []
follows: 0601
sealed: false
---

**Question.** The per-row route stopped at depth fourteen. What makes up its constant, which parts are lost factors, and how far does removing them carry the middle band?

**What ran.** `run/floor.py`, by `run/run.sh`, through `lab run`: the floor constant `floorConstSplit` at the floor two to the thirty-eighth, piece by piece, from the upper bounds the stage-three tree proves; the route constant through the old and the sharp transfer; and, for each depth and row, the largest constant the bench's gate (`WeakDepths.weak40_lt_floor`'s inequality) accepts.

**Two factors removed.** The ψ-to-π transfer (`PsiToPi.schoenfeldWeak_of_psiWeak`) charged its lower-order pieces against a logarithm of at least one, where the census reads logarithms past fifty. Through it the constant was `floor.old_route` 126.969; through `schoenfeldWeak_of_psiWeak_sharp` it is `floor.new_route` 39.679, a factor of `floor.old_transfer_factor` 3.2. The floor's integral was bounded below by one over twice the row; its exact lower bound has the logarithm of two in the denominator (`H_w2_ge2`). Together they carry `only_four_zeros_rh_le15`: every depth through fifteen, every row, given the π list and the route.

**Where the rest sits.** The floor constant is `floor.F` 37.9896: the leading term `floor.floor.lead` 4.0, the zero count's first-order piece `floor.floor.log1` 9.7192, its second-order piece `floor.floor.log2` 7.23, and the left edge of the contour `floor.floor.c4` 17.0403; the two explicit-formula remainders round to `floor.floor.c1` 0.0 and `floor.floor.c3` 0.0. Each of the four is far above the truth. The leading term counts the zeros in dyadic blocks, where partial summation gives a smaller multiple; the zero count's constants are those of `rvM_sharp`; and the left edge carries a bound on the logarithmic derivative of zeta along a vertical line with a constant near ten to the ninth.

**How far it can go.** The constant a depth needs falls by a factor of about three and a half per unit of depth at a fixed row: at the first uncomputed row, depth fifteen needs at most `floor.need.d15.r93` 53.25, depth sixteen `floor.need.d16.r93` 15.09, depth seventeen `floor.need.d17.r93` 4.26 and depth eighteen `floor.need.d18.r93` 1.2. Schoenfeld's constant in this normalization is one over eight pi, so even the true size of the error closes the middle band only through about depth twenty at that row. With the constant at forty, depth sixteen closes from row `floor.first_row_closed_at_40.d16` 96, seventeen from `floor.first_row_closed_at_40.d17` 100, eighteen from `floor.first_row_closed_at_40.d18` 104, twenty from `floor.first_row_closed_at_40.d20` 112 and twenty-five from `floor.first_row_closed_at_40.d25` 130.

**Decision.** Sharpening the constant buys a few depths and then stops, at any constant. The cells between the last computed row and each depth's closing row are the corner of a table whose top is the census edge: they need either more rows of the π list or an argument that is not an error bound. The next steps take the cheapest of the remaining factors, the left edge, to close depth sixteen, and turn the main effort to those cells.
