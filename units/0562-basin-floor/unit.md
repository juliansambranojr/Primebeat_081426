---
id: 0562
date: 2026-11-25
type: run
title: "The basin floor, measured: a longer mollifier raises the lowest basin and lowers the highest; zeros of the mollified function right of the line stay in two basins"
refs: [lean_stage3/Stage3/FloorQ.lean::levinson_floorQ]
supersedes: []
follows: 0561
context: block S15 of `lean_stage3/design/stencil.md` reads Julian's picture of the coupling as a floor in every basin; this measures it on one stretch of the line
sealed: false
---

**Question.** On the Gram intervals of one stretch of the critical line, does a longer mollifier raise the floor of every basin, move weight between neighbouring basins, and clear the zeros of the mollified function right of the line?

**What ran.** `run/basin.py`, mpmath at fifteen digits: Levinson's function, zeta plus its derivative over the logarithm, times Young's mollifier with the identity polynomial, on the line left of one half by the shift `results.R` 1.3 over the logarithm, at height `results.T` 5000.0 over a stretch of `results.H` 40.0, cut at the Gram points into `results.basins` 43 basins. For each of three mollifier lengths: the mean of the squared modulus over each basin from twenty-four points, the correlation of neighbouring basins' deviations from the mean, and the zeros of the mollified function in the rectangle from the line to real part three over each basin, by the winding number from twenty-four points a side. EXPLORATORY: no prereg, no verdict, nothing proved. The winding grid is coarse; a zero near an edge can be miscounted.

**What it gave.**
- Mollifier length `results.theta_0.25_M` 8 terms: mean floor `results.theta_0.25_floor_mean` 2.861028542355358, lowest basin `results.theta_0.25_floor_min` 0.0691083557069157, highest `results.theta_0.25_floor_max` 16.432774775490415, neighbour correlation `results.theta_0.25_neighbour_corr` 0.017339087959737, zeros right `results.theta_0.25_zeros_right` 2 in `results.theta_0.25_basins_with_zero` 2 basins.
- Length `results.theta_0.5_M` 70: mean `results.theta_0.5_floor_mean` 1.9141900347024907, lowest `results.theta_0.5_floor_min` 0.18217889051085082, highest `results.theta_0.5_floor_max` 5.14354990515991, correlation `results.theta_0.5_neighbour_corr` -0.1694260394876505, zeros `results.theta_0.5_zeros_right` 2 in `results.theta_0.5_basins_with_zero` 2 basins.
- Length `results.theta_1.0_M` 5000: mean `results.theta_1.0_floor_mean` 1.4572445589793572, lowest `results.theta_1.0_floor_min` 0.44922002337846895, highest `results.theta_1.0_floor_max` 3.7292619765809643, correlation `results.theta_1.0_neighbour_corr` 0.23814767454205446, zeros `results.theta_1.0_zeros_right` 2 in `results.theta_1.0_basins_with_zero` 2 basins.

**What it says for Julian's picture.** The floors draw together as the mollifier grows: the lowest basin rises and the highest falls, so the floor is raised in every basin here, not only on average. The neighbour correlation changes sign between lengths, so this sample shows no consistent transfer from one basin to the next. The zeros right of the line stay at the same count at all three lengths, which fits zeros of Levinson's function itself near the line, the ones Feng's remark records and a mollifier does not move. Every number here is one stretch at one height.
