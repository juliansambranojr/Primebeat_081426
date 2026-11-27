---
id: 0612
date: 2026-11-27
type: measurement
title: How much the zeros behind the corner's leader cancel among themselves, cell by cell and on average
refs: [lean/EdgeDiagonal.lean::edge_eq_fwdDiff]
supersedes: []
follows: 0611
sealed: false
---

**Question.** Unit 0611 (leader-gap) found the corner's leader far smaller than the other zeros added up by size, yet ahead of what they put in the cell about half the time. How much do the others cancel among themselves, and does it leave room for an argument on average?

**What ran.** `run/cancel.py`, by `run/run.sh`, through `lab run`, on unit 0597's corner of the true table, `cancel.cells` 2962 cells, with the comb's predicted leader removed from each cell (unit 0610, corner-zoom). For the rest: their sum's size over the sum of their sizes (one means no cancellation); their sum's size over the root of the sum of their squares (near one if their phases were independent; the median of the size of a standard normal is about two thirds); and over each depth band, the mean square of their sum over the sum of their mean squares (one means the cross terms average out). Each with the first hundred, five hundred and two thousand zeros.

**Within a cell, the rest cancels like independent phases.** Their sum is a median `cancel.K100.kappa_median` 0.1884 of their sizes with a hundred zeros, `cancel.K500.kappa_median` 0.1127 with five hundred and `cancel.K2000.kappa_median` 0.07 with two thousand: more zeros, more cancellation. Against the root of their squares it stays put: `cancel.K100.random_phase_median` 0.667, `cancel.K500.random_phase_median` 0.689 and `cancel.K2000.random_phase_median` 0.644, close to the two thirds independent phases give. The rest's sum grows like the root of its squares, and that root has a finite limit as zeros are added, since the squared reciprocal heights of the zeros sum to a finite number.

**The leader against the rest, three ways.** With two thousand zeros the leader is a median `cancel.leader_vs_rest_sizes_median` 0.1021 of the rest's sizes, `cancel.leader_vs_rest_rms_median` 0.878 of the root of their squares, and `cancel.leader_vs_rest_sum_median` 1.062 of their actual sum. Against the root of squares: `cancel.leader_vs_rest_rms_by_band.d10_19` 1.029 at depths ten to nineteen, `cancel.leader_vs_rest_rms_by_band.d20_35` 0.949 at twenty to thirty-five, `cancel.leader_vs_rest_rms_by_band.d36_66` 0.764 at thirty-six to sixty-six, and `cancel.leader_vs_rest_rms_by_band.d67_91` 1.017 past sixty-seven.

**On average over a depth band, the cross terms do not settle.** The mean-square ratio with two thousand zeros is `cancel.K2000.d10_19.mean_square_ratio` 2.113 at depths ten to nineteen, where the rest's terms reinforce, and `cancel.K2000.d20_35.mean_square_ratio` 0.291, `cancel.K2000.d36_66.mean_square_ratio` 0.281 and `cancel.K2000.d67_91.mean_square_ratio` 0.147 deeper, where they cancel more than independent terms would. It moves with the number of zeros (`cancel.K500.d67_91.mean_square_ratio` 0.008 at five hundred), so a few large cells drive it.

**What it shows.** Measured against the root of its squares, the rest cancels at the rate of independent phases, its size is set by the root of its squares, and that has a finite limit. On that yardstick the leader and the rest are of one size, the leader ahead in about half the cells. So each corner cell is a leader the comb predicts plus a remainder of the same size whose square is bounded. Any route must use that bound, and must also use the phases, since size alone leaves about half the cells undecided. Exploratory; no outcome marked.
