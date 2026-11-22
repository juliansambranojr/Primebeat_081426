---
id: 0404
date: 2026-11-22
type: result-triage
title: "The explicit-formula route to the census, priced: one logarithm fewer lifts the ceiling, and the route's own contour constant sits far above it"
refs: [lean_stage3/Stage3/Assembly.lean::psiWeak_of_RH_EF_NT, lean_stage3/Stage3/Glue.lean::explicit_formula_poly, lean_stage3/Stage3/EdgeBound.lean::gz_partial_fraction, lean_stage3/Stage3/ArgCount.lean::rvM_crude]
supersedes: []
follows: 0403
context: unit 0403 traced the dial's constants and found the notes had already priced that route out (entry 283); entry 283 closed by asking whether the explicit-formula route carries the census alone; Julian asked for that route to be read and its three unnamed constants traced, 2026-11-22
sealed: false
---

**Question.** Does the explicit-formula route, as it is proved in Stage 3, deliver a constant small enough for the census gate to cover depth six inside the computed table?

**What ran.** `run/price_ef_route.py`, EXPLORATORY, no prereg. It imports `O68_weak_bound_tolerance.py` unchanged for `R_of`, and takes its numerals from the `refine` lines of the Lean files named in its docstring. Output `run/price_ef_route.json`, log beside it.

**What the route is.** Four proved theorems, never composed: `Assembly.psiWeak_of_RH_EF_NT` (RH, the truncated explicit formula and the zero-count band give `|ψ − x| ≤ C·√x·log²x`), `Glue.stmtEF_poly` (the explicit formula), `ArgCount.rvM_crude` (the band, with numerals), and `PsiToPi.schoenfeldWeak_of_psiWeak` (to `π`, at `3C + 13` and one logarithm fewer). The route lands on `√x·log x`. The route that entry 233 and entry 283 priced lands on `√x·log²x`.

**What it shows.** The ceiling moves. On the `√x·log x` shape, with the floor at `price_ef_route.x0` 256.0, depth six is covered by rung `price_ef_route.ceiling_rung` 93 up to a `π`-side constant of `price_ef_route.ceiling_pi_k1` 170212.5, which is `price_ef_route.ceiling_psi_k1` 56733.2 on the `ψ` side.

The numerals the route already fixes fit under it. They sum to `price_ef_route.known_numerals_psi` 29017 on the `ψ` side, `price_ef_route.known_numerals_pi` 87064 on the `π` side; at that value depth covered is `price_ef_route.known_depth_covered` 6, with the sixth depth closing at rung `price_ef_route.known_R6` 91. The room left for the unnamed constants is `price_ef_route.headroom_psi` 27716.2.

The unnamed constants do not fit. Traced to their `refine` lines: `Cs` is a numeral, `price_ef_route.Cs` 1135.7. `Ch` is built from the Borel–Carathéodory constant in `EdgeBound.gz_partial_fraction`, whose radii `23/25` and `22/25` make its factor at least `price_ef_route.G_floor` 212127.7; that gives the edge constant at least `price_ef_route.Ce_floor` 531457.4; `Glue.zeta_logderiv_good_bound` multiplies it by `price_ef_route.gap_factor` 3418.5, the price of stepping off the zeros; so `Ch` is at least `price_ef_route.Ch_floor` 12260000000.0.

Carried through, the route's constant on the `π` side is at least `price_ef_route.floor_pi` 662200000000.0, a factor `price_ef_route.floor_over_ceiling` 3890000.0 over the ceiling. At that value depth covered is `price_ef_route.floor_depth_covered` 0: the first depth closes at rung `price_ef_route.floor_R1` 116 and the sixth at `price_ef_route.floor_R6` 140.

**Reading.** Two factors carry the whole excess, and both are constants, fixed once: the cube of the gap between two radii, and the gap-eating factor. Neither grows with `x`. Entry 233 moved the same kind of radius in the other route and cut its constant by a little over a third; whether these radii have the same freedom was not looked at. Every figure here is a floor on what the Lean proof produces, with the non-negative terms `Cl`, `K0`, `W` dropped. None is a statement about the best constant.

What remains. The composition of the four theorems into one, which is short and changes no constant. A decision on the two factors: re-prove `gz_partial_fraction` and `zeta_logderiv_good_bound` with freed radii, as entry 233 did on the other route, or leave the route as an existence statement. `K0` and `W` as numerals.
