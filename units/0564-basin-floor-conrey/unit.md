---
id: 0564
date: 2026-11-25
type: run
title: "The basin floor with Conrey's cubic: the floors draw together as before, and the zeros right of the line are more and stay put at every mollifier length"
refs: [lean_stage3/Stage3/FloorConstQ.lean::floor_constQ]
supersedes: []
follows: 0562
context: unit 0562 measured the basin floor for Levinson's linear polynomial and found two zeros right of the line at every mollifier length; this repeats it with the cubic polynomials of unit 0560
sealed: false
---

**Question.** With Conrey's cubic operator polynomial and the cubic mollifier polynomial of unit 0560, do the basin floors draw together as the mollifier lengthens, and do the zeros right of the line that Levinson's function kept now move?

**What ran.** `run/basin.py`, the script of unit 0562 with the cubic polynomials and the shift `results.R` 1.5: Conrey's function through the reduction of unit 0558, the operator polynomial applied to zeta through its third derivative, times Young's mollifier with the cubic polynomial, at height `results.T` 5000.0 over a stretch of `results.H` 40.0, cut at the Gram points into `results.basins` 43 basins. For each of three mollifier lengths: each basin's mean, the neighbour correlation, and the zeros right of the line by the winding number. EXPLORATORY: no prereg, no verdict, nothing proved. The winding grid is coarse.

**What it gave.**
- Mollifier length `results.theta_0.25_M` 8 terms: mean floor `results.theta_0.25_floor_mean` 3.334847135390683, lowest `results.theta_0.25_floor_min` 0.11805106327139299, highest `results.theta_0.25_floor_max` 21.661588429024377, neighbour correlation `results.theta_0.25_neighbour_corr` 0.13643427314233267, zeros right `results.theta_0.25_zeros_right` 5 in `results.theta_0.25_basins_with_zero` 4 basins.
- Length `results.theta_0.5_M` 70: mean `results.theta_0.5_floor_mean` 2.148768497453531, lowest `results.theta_0.5_floor_min` 0.26846463195540476, highest `results.theta_0.5_floor_max` 5.822777365025441, correlation `results.theta_0.5_neighbour_corr` -0.019547010486578243, zeros `results.theta_0.5_zeros_right` 5 in `results.theta_0.5_basins_with_zero` 4 basins.
- Length `results.theta_1.0_M` 5000: mean `results.theta_1.0_floor_mean` 1.6522686801930562, lowest `results.theta_1.0_floor_min` 0.43605561401831716, highest `results.theta_1.0_floor_max` 4.7523831863384824, correlation `results.theta_1.0_neighbour_corr` 0.2754640967880314, zeros `results.theta_1.0_zeros_right` 5 in `results.theta_1.0_basins_with_zero` 4 basins.

**What it says for Julian's picture.** The floors draw together as in unit 0562: the lowest basin rises and the highest falls as the mollifier lengthens. The zeros right of the line are more than with Levinson's function on the same stretch, and their count does not change with the mollifier's length: they are zeros of Conrey's function itself, near the line, the ones Feng's remark records. The cubic polynomial buys its higher floor on average by placing more of its own zeros near the line, and a longer mollifier does not move them. The force on every basin has to reach those zeros of the operator's function, which the mollifier alone does not. The short stretch does not resolve the neighbour transfer; unit 0565 does, for Levinson's function.
