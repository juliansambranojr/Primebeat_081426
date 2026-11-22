---
id: 0410
date: 2026-11-22
type: result-triage
title: "The gate priced from floorConstSplit: with the left edge at its own size the route covers depth six seventeen rungs inside the table, and its unnamed constants have four orders of slack"
refs: [lean_stage3/Stage3/GlueFloor.lean::schoenfeldWeak_floor_split_of_RH, lean_stage3/Stage3/GlueFloor.lean::floorConstSplit]
supersedes: []
follows: 0409
context: unit 0409 proved the route's theorem with the left edge of the contour at its own size and left it unpriced; block E2's estimate was made before the theorem; Julian asked for the pricing to be run and logged, 2026-11-22
sealed: false
---

**Question.** Priced from `floorConstSplit` as proved, where does depth six close, and how much room do the constants that are not yet numerals have?

**What ran.** `run/price_split.py`, EXPLORATORY, no prereg. O68's `R_of` imported unchanged, on the shape with one logarithm, floor the square of the `ψ` floor. The three explicit-formula constants are existential in the theorem; the script takes them at floors built as in unit 0405.

**What it shows.** Ceiling rung `price_split.ceiling_rung` 93.

Radii as built: at a `ψ` floor of two to the `price_split.as_built.log2_psi_floor` 33.5 the constant is `price_split.as_built.floorConstSplit` 216.6, of which the band's numerals are `price_split.as_built.band_part` 92.2 and the left edge `price_split.as_built.left_part` 124.4. Depth covered `price_split.as_built.depth_covered` 9; the sixth depth closes at rung `price_split.as_built.R6` 76, `price_split.as_built.margin_rungs` 17 rungs inside.

Radii freed: constant `price_split.freed.floorConstSplit` 118.4, the sixth depth at rung `price_split.freed.R6` 74, `price_split.freed.margin_rungs` 19 rungs inside.

Contour constants at zero: `price_split.c_zero.floorConstSplit` 119.0, rung `price_split.c_zero.R6` 74, `price_split.c_zero.margin_rungs` 19 inside.

With the value at zero and the supremum on the short segment put at their classical sizes, the as-built row does not move: rung `price_split.classical.R6` 76.

Slack: the three as-built constants can all be multiplied by `price_split.as_built_slack_factor` 49000.0 and some floor still covers depth six.

**Reading.** Against unit 0408, where the same route closed depth six three rungs inside, the restatement of unit 0409 moved it to seventeen. Freeing the radii is worth two more rungs and reaches the route's own limit; it is no longer needed for the census. The slack is the figure that bears on the unnamed constants: the floors used here leave out quantities obtained from compactness, and those would have to exceed their floors by four orders of magnitude to lose depth six.

This is a pricing of a conditional theorem. The theorem assumes RH; the constants are floors and are not numerals in the tree; the gate here is O68's function and not the Lean gate. It is no statement about the table.

What remains. The constants as numerals in Lean; the Lean gate read on the shape with one logarithm; and whether any of this is wanted on the dial at an exponent above one half, where the route does not assume RH.
