---
id: 0405
date: 2026-11-22
type: result-triage
title: "The explicit-formula route loses a factor of the square root of x in its last line: named, priced with the radii as built and freed, and left as a decision"
refs: [lean_stage3/Stage3/Assembly.lean::assembly_arith, lean_stage3/Stage3/Assembly.lean::psiWeak_of_RH_EF_NT, lean_stage3/Stage3/EdgeBound.lean::gz_partial_fraction, lean_stage3/Stage3/Glue.lean::edge_left_bound]
supersedes: []
follows: 0404
context: unit 0404 found the route's contour constant far above the census ceiling and named two fixed factors; Julian asked for the radii to be freed, 2026-11-22; reading the proofs for which radii are forced showed where the constant is actually spent
sealed: false
---

**Question.** Can the radii in `EdgeBound.gz_partial_fraction` be freed far enough for the explicit-formula route to cover depth six inside the computed table?

**What ran.** `run/price_floor.py`, EXPLORATORY, no prereg, O68's `R_of` imported unchanged. No Lean was written.

**The radii.** One of the four is forced: the proof rescales by two about the point `3/2 + iT`, and must reach real part `−1/4`, so the inner radius cannot go below `7/8`. With that fixed and the other three optimised on a grid, the Borel–Carathéodory factor falls from `price_floor.as_built.G` 212127.7 to `price_floor.freed.G` 14080.1, a gain of `price_floor.G_gain` 15.07. Unit 0404 needed a factor in the millions. The radii alone do not do it.

**The lost factor.** Inside `Assembly.psiWeak_of_RH_EF_NT` the proof reaches

`|ψ x − x| ≤ (9c₁ + c₂)·L² + 2S·(2(7 + 4b₁ + 4b₂ + 2b₃)·L² + 2W)`, with `S = √x` and `L = log x`.

The contour constants `c₁`, `c₂` multiply `L²` with no `√x`. The last line, `assembly_arith`, then bounds `L²` by `S·L²` so the whole thing has one shape. That step is correct and gives away a factor `√x` on the term that holds every large constant. Kept, the bound for `x ≥ x₀` has constant `28 + 16b₁ + 16b₂ + 8b₃ + 4W + (9c₁ + c₂)/√x₀`: the part that stays is `price_floor.main_psi` 7404, and the contour part is divided by the square root of the floor. The price of a higher floor is on the gate's side, where the window has to sit above the floor squared.

**Priced, both ways, as floors.** Scanning the floor for the best outcome:

As built, the contour part is at least `price_floor.as_built.loose_floor` 1312000000000.0. The best floor found is two to the `price_floor.as_built.best_log2_psi_floor` 43.5 on the `ψ` side, depth covered `price_floor.as_built.depth_covered` 4, the sixth depth closing at rung `price_floor.as_built.R6` 99 against the ceiling rung `price_floor.ceiling_rung` 93.

With the radii freed, the contour part is at least `price_floor.freed.loose_floor` 87890000000.0, the best floor two to the `price_floor.freed.best_log2_psi_floor` 41.75, depth covered `price_floor.freed.depth_covered` 6, the sixth depth closing at rung `price_floor.freed.R6` 93: on the ceiling rung, with nothing to spare.

Both are floors on the constant. They take the growth constant at its smallest admissible value (`price_floor.A_floor` 16.55, with a value of ζ evaluated numerically) and set to zero four quantities the proofs get from compactness or leave unnamed. The true figures are higher, so the freed case as priced does not clear.

**Reading.** The size failed, the steps did not. With the square root kept the route goes from a factor of millions over to a few rungs over, and the radii bring it to the rung itself. What is left is of the same kind: the height `T` of the explicit formula is taken just above `x`, and the formula allows it up to `x²`. At a larger `T` the contour term falls by a further power of `x` while the part that stays grows by a bounded factor. That trade is not priced here.

What remains. A decision, Julian's: (a) restate the assembly with the floor as a parameter and the square root kept, a copy of the proof with a different last line; (b) with it, choose the height `T` as a power of `x` and price the trade first; (c) free the radii, worth `price_floor.G_gain` 15.07 on one factor; (d) leave the route as an existence statement. Unnamed constants that any numeral needs: the bound on ζ on the compact patch in `ZetaGrowth.sq_zeta_band_bound`, the bound on its logarithmic derivative on the segment in `Glue.edge_left_bound`, and the count of zeros in the low rectangle in `EdgeBound.ball_order_sum_le`.
