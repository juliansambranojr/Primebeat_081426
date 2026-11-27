---
id: 0611
date: 2026-11-27
type: measurement
title: The gap between the corner's leaders: how far the leading harmonic zero stands above the next, and above all the rest
refs: [lean/EdgeDiagonal.lean::edge_eq_fwdDiff]
supersedes: []
follows: 0610
sealed: false
---

**Question.** The corner's leader at each depth is predicted by Julian's comb (unit 0610, corner-zoom). How far does it stand above the next zero, and above all the rest together? A proof that keeps a corner cell off zero by its leader needs that gap.

**What ran.** `run/gap.py`, by `run/run.sh`, through `lab run`. Predicted: each zero's weight at depth d is its depth factor to the d-th power over its height; at each depth the leader, the runner-up, the gap (the logarithm of their ratio), and the dominance (the leader's weight over the sum of all the others), over the first two thousand and the first hundred thousand zeros. Actual: on unit 0597's corner of the true table, `gap.actual_all.cells` 2962 cells, the predicted leader's part of each cell against everything else the zeros put there.

**The gap to the runner-up.** Up to depth two thousand the leader changes `gap.switches_to_2000.count` 2 times, at depths `gap.switches_to_2000.depths[0]` 67 and `gap.switches_to_2000.depths[1]` 354, from the zero at `gap.switches_to_2000.leaders[0]` 14.135 to `gap.switches_to_2000.leaders[1]` 40.919 to `gap.switches_to_2000.leaders[2]` 49.774. The median gap is `gap.switches_to_2000.median_gap` 0.3819, a leader about half again the runner-up; it closes to `gap.switches_to_2000.min_gap` 0.00024 at a switch, where two zeros tie. At depth ten the gap is `gap.pred_100000.d10.gap` 0.903, at depth sixty-seven `gap.pred_100000.d67.gap` 0.0085, at depth three hundred `gap.pred_100000.d300.gap` 0.0296 and at depth ten thousand `gap.pred_100000.d10000.gap` 0.8694.

**The gap to all the rest.** In weight the leader is far below the rest together. Over two thousand zeros its dominance is `gap.pred_2000.d10.dominance` 0.07582 at depth ten and `gap.pred_2000.d100.dominance` 0.08876 at a hundred; over a hundred thousand it falls to `gap.pred_100000.d10.dominance` 0.03139 and `gap.pred_100000.d100.dominance` 0.03639. More zeros make it smaller: the sum of the others' weights grows without bound, since the reciprocal heights of the zeros near the harmonics already sum to infinity.

**On the table.** The predicted leader outweighs everything else the zeros put in the cell in `gap.actual_all.lead_wins` 0.521 of the corner cells, median ratio `gap.actual_all.median_ratio` 1.059: `gap.actual.d10_19.lead_wins` 0.653 at depths ten to nineteen, `gap.actual.d20_35.lead_wins` 0.552 at twenty to thirty-five, `gap.actual.d36_66.lead_wins` 0.386 at thirty-six to sixty-six, where the gap is closing toward the switch, and `gap.actual.d67_91.lead_wins` 0.794 past it, median ratio `gap.actual.d67_91.median_ratio` 2.197.

**What it shows.** The leader stands out in the table because the other zeros' terms cancel among themselves. Added up by size they exceed it many times over, and more so the more zeros are counted. A proof that sets the leader against the sum of the others' sizes loses a factor that grows without bound; it is a design limit, and a route needs the others' cancellation, measured on average over the cells. Near a switch two leaders tie, and there the cell's sign rests on their phases. Exploratory; no outcome marked.
