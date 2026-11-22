---
id: 0406
date: 2026-11-22
type: result-triage
title: "The explicit-formula route priced over the height T: at T a power of x above one the contour term on the top edge vanishes from the constant, and depth six is covered with rungs to spare, as a floor"
refs: [lean_stage3/Stage3/Assembly.lean::norm_zeroPartialSum_le_logsq, lean_stage3/Stage3/Glue.lean::explicit_formula_poly, lean_stage3/Stage3/PsiToPi.lean::schoenfeldWeak_of_psiWeak, lean_stage3/Stage3/ArgCount.lean::rvM_crude]
supersedes: []
follows: 0405
context: unit 0405 named the square root of x that the assembly's last line gives away and left the height T unpriced; Julian chose to price T before anything is restated in Lean, 2026-11-22
sealed: false
---

**Question.** With the square root kept, which height `T` in the explicit formula gives the smallest constant, and does the route then cover depth six inside the computed table?

**What ran.** `run/price_height.py`, EXPLORATORY, no prereg, O68's `R_of` imported unchanged. The model is in its docstring: the two proved bounds before any arithmetic is applied to them, `T` the power of two just below `x^a`, each term divided by `√x·log²x` and taken at the floor. No Lean was written.

**A second thing the last lines give away.** The proved bound on the zero side is a polynomial in `log T`: a small multiple of its square, a large multiple of its first power, and a large constant. `zeroinner_arith` rounds all three up to multiples of `log²x`, valid from `log x ≥ 1`. At the floors the gate can afford the logarithm is near thirty, so the rounded figure of unit 0405 stands where the bound itself gives a few tens: `price_height.as_built.a1.zero_part` 38.0 at `a = 1`.

**What it shows.** Floors, as in unit 0405, with the ceiling rung `price_height.ceiling_rung` 93.

Radii as built. At `a = 1` the top-edge term dominates, the best floor leaves depth covered `price_height.as_built.a1.depth_covered` 5, with the sixth depth `price_height.as_built.a1.margin_rungs` -5 rungs from the ceiling. At `a = 2` the top-edge term is `price_height.as_built.a2.c1_part` 1.27e-06, the constant is `price_height.as_built.a2.C_psi` 20118.2, nearly all of it the left-edge term `price_height.as_built.a2.c2_part` 20042.2; depth covered `price_height.as_built.a2.depth_covered` 6, the sixth depth closing at rung `price_height.as_built.a2.R6` 90, `price_height.as_built.a2.margin_rungs` 3 rungs inside.

Radii freed. At `a = 2` the constant is `price_height.freed.a2.C_psi` 2906.4, depth covered `price_height.freed.a2.depth_covered` 7, the sixth depth closing at rung `price_height.freed.a2.R6` 84, `price_height.freed.a2.margin_rungs` 9 rungs inside.

The middle value of `a` gives the same rungs as `a = 2` in both cases.

**Reading.** Once `T` is a power of `x` above one, the top edge costs nothing and the zero side costs tens. What is left is one term, the left edge of the contour at real part `−1/4`, `c₂·log x`, and one structural cost, the floor squared in the passage from `ψ` to `π`. The figures are floors: the growth constant at its smallest admissible value (`price_height.A_floor` 16.55), and three quantities from compactness, with the count of real zeros, at zero. Those three are not large in truth, and they are not numerals in the tree.

What remains. The restatement in Lean: the assembly with the floor as a parameter, `T` the power of two below `x²`, and the two last lines replaced by ones that keep the shape. It yields `StmtPsiWeak` with a constant that is an explicit function of the floor, of `c₁`, `c₂`, and of the band's numerals. A numeral for the whole needs the three compactness quantities bounded, and `c₁`, `c₂` exposed as definitions.
