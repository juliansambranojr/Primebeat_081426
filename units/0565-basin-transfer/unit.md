---
id: 0565
date: 2026-11-25
type: run
title: "The transfer between basins, measured: neighbouring basins' floors anti-correlate, and pairs of basins vary less than single ones"
refs: [lean_stage3/Stage3/FloorQ.lean::levinson_floorQ]
supersedes: []
follows: 0562
context: unit 0562 found no consistent sign for the neighbour correlation on a short stretch; block S15 of `lean_stage3/design/stencil.md` reads the off-diagonal as a transfer between basins; this measures it on a stretch long enough to see it
sealed: false
---

**Question.** On a long stretch of the critical line, does weight move from one basin to the next: do neighbouring basins' floors anti-correlate, and do pairs of neighbours vary less than single basins?

**What ran.** `run/basin.py`, the script of unit 0562 with a longer stretch and the winding count left out: Levinson's function times Young's mollifier with the identity polynomial, at height `results.T` 5000.0 over a stretch of `results.H` 470.0, the shift `results.R` 1.3, cut at the Gram points into `results.basins` 504 basins, at the mollifier length of `results.theta_0.5_M` 70 terms. For each basin the mean of the squared modulus from twenty-four points; then the correlations of the basins' deviations at lags one, two, three and five, and the relative spread of single basins and of sums of neighbouring pairs. EXPLORATORY: no prereg, no verdict, nothing proved.

**What it gave.** Mean floor `results.theta_0.5_floor_mean` 1.964294939391439, lowest `results.theta_0.5_floor_min` 0.18217889051085082, highest `results.theta_0.5_floor_max` 7.654705068935683. Correlation at lag one `results.theta_0.5_corr_lag1` -0.1413795463596876, at lag two `results.theta_0.5_corr_lag2` -0.03779909231794479, at lag three `results.theta_0.5_corr_lag3` -0.015560278685698587, at lag five `results.theta_0.5_corr_lag5` -0.017732035482031245. Relative spread of single basins `results.theta_0.5_single_rel_spread` 0.6508869956375655, of neighbouring pairs `results.theta_0.5_pair_rel_spread` 0.4262176142247174.

**What it says for Julian's picture.** The correlation at lag one is negative and several standard errors from zero for independent basins at this count; at the longer lags it is near zero. Pairs of neighbours vary less than independent basins would, whose pair spread would be the single spread over the square root of two. Both say the same thing: a high basin tends to sit beside a low one, weight moves between neighbours, and the motion stays local, within one basin of its source. This is one stretch at one height and one mollifier length.
