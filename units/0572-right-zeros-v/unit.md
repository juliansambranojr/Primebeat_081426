---
id: 0572
date: 2026-11-25
type: run
title: "Zeros of V_Q right of the line on two test stretches: none for Levinson, one for Conrey's Q0 near height five thousand"
refs: [none]
supersedes: []
follows: 0565
context: step 2 of the chain, no right zeros of V, is the open core of unit 0573; the basin units counted zeros right of a line left of the critical line, and this counts them right of it
sealed: false
---

**Question.** Does V_Q, the reduction of Conrey's V, have zeros with real part above one half on test stretches, and does the choice of Q change the count?

**What ran.** `run/rightzeros.py`, by `run/run.sh`, through `lab run`. It counts the zeros of V_Q right of the line by the winding number of V_Q around unit boxes from one half plus `results.eps` 1e-06 to real part three, with `results.side_points` 24 points per side, over two stretches of forty boxes starting at heights one thousand and five thousand, with the mollifier's logarithm set by the starting height. Five choices of Q: Levinson's one minus x, Conrey's Q0, and three symmetric cubics. EXPLORATORY: no prereg, no verdict.

**What it shows.** On the stretch at one thousand, every Q gives no zeros right of the line: `results.T1000_levinson_1_minus_x_zeros_right` 0, `results.T1000_conrey_Q0_zeros_right` 0, and 0 for each cubic. On the stretch at five thousand, Levinson's Q gives `results.T5000_levinson_1_minus_x_zeros_right` 0. Conrey's Q0 gives `results.T5000_conrey_Q0_zeros_right` 1, in `results.T5000_conrey_Q0_boxes_with_zero` 1 box, and the cubic with q0 one half and d3 minus a fifth gives `results.T5000_sym_q0_0.5_d3_m0.2_zeros_right` 1. The other two cubics give 0.

**Reading.** Levinson's Q keeps no zero right of the line on both stretches. Conrey's Q0, which gives the larger floor, and one cubic each put one there. The chain's open hypothesis, no right zeros, can fail for some Q at these heights, so the choice of Q is part of that hypothesis.

**What is unchecked.** The resolution of the winding count: two dozen points per side, and negative windings are clipped to zero, so a miscount by an under-resolved edge is not ruled out. The result keeps only the totals, so the height of the zero is not recorded.

What remains. Locate the zero at five thousand and confirm it with a finer contour, and count on longer stretches.
