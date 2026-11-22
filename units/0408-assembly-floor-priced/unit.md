---
id: 0408
date: 2026-11-22
type: result-triage
title: "The gate priced from the theorem's own constant: the rungs of unit 0406 stand, and the room the route has when its contour constants are taken away"
refs: [lean_stage3/Stage3/AssemblyFloor.lean::schoenfeldWeak_floor_of_RH, lean_stage3/Stage3/AssemblyFloor.lean::floorConst]
supersedes: []
follows: 0407
context: unit 0407 proved the assembly with a constant whose zero-side coefficients are slightly larger than the model unit 0406 priced; Julian chose to re-price from the theorem before deciding whether to name the two explicit-formula constants, 2026-11-22
sealed: false
---

**Question.** Priced from `floorConst` as proved, does the route still cover depth six, and how much of the ceiling is left for the two constants that are not yet numerals?

**What ran.** `run/price_floorconst.py`, EXPLORATORY, no prereg. O68's `R_of` imported unchanged, on the shape with one logarithm, floor the square of the `ψ` floor. The two explicit-formula constants are existential in the theorem; the script takes them at the floors of unit 0405, and once at zero.

**What it shows.** Ceiling rung `price_floorconst.ceiling_rung` 93.

Radii as built: `floorConst` is `price_floorconst.as_built.floorConst` 20118.7, of which the band's part is `price_floorconst.as_built.band_part` 76.5 and the left edge `price_floorconst.as_built.c2_part` 20042.2. Depth covered `price_floorconst.as_built.depth_covered` 6, the sixth depth closing at rung `price_floorconst.as_built.R6` 90, `price_floorconst.as_built.margin_rungs` 3 rungs inside.

Radii freed: `floorConst` `price_floorconst.freed.floorConst` 2906.9, depth covered `price_floorconst.freed.depth_covered` 7, the sixth depth at rung `price_floorconst.freed.R6` 84, `price_floorconst.freed.margin_rungs` 9 rungs inside.

Contour constants at zero: `floorConst` `price_floorconst.c_zero.floorConst` 119.0 at a `ψ` floor of two to the `price_floorconst.c_zero.log2_psi_floor` 26.5, depth covered `price_floorconst.c_zero.depth_covered` 9, the sixth depth at rung `price_floorconst.c_zero.R6` 74, `price_floorconst.c_zero.margin_rungs` 19 rungs inside.

**Reading.** The rungs of unit 0406 are unchanged by the theorem's coefficients. The last row is the route's own cost, with everything the contour adds removed: nineteen rungs. The contour, through the left edge alone, spends sixteen of them as built and ten with the radii freed. Between the two cases the left-edge constant falls about fifteenfold and six rungs come back, a rung and a half for each halving. All three rows are floors on constants that are not numerals in the tree, and no row is a statement about the table.

What remains. Naming the two constants in Lean, with the left edge first since it carries the whole figure; the three compactness quantities under them; and the gate itself read on the shape with one logarithm.
