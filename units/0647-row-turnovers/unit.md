---
id: 0647
date: 2026-11-28
type: measurement
title: The four zeros as row turnovers, and the bands that switch which rows turn early
refs: [lean/CornerSign.lean::ne_zero_of_opposite]
supersedes: []
follows: 0646
sealed: false
---

**Question.** Julian: the zeros serve different functions for the table; the deep zero is a fulcrum and a pole. Where each zero sits in its own row, and how the rows' turnovers are arranged.

**What ran.** `run/turnover.py`, by `run/run.sh`, through `lab run`, on the exact table to row ninety-two. Along each row the cells start positive, where the smooth part leads; the row's turnover is the first depth where a cell is zero or negative.

**Each zero is the first turnover of its row.** The signs along the zero's row, from depth zero: `turnover.zeros.2_1.row_signs` "+0" for the zero at row two, depth one; `turnover.zeros.4_1.row_signs` "+0--" at row four; `turnover.zeros.8_3.row_signs` "+++0----" at row eight, depth three; `turnover.zeros.20_6.row_signs` "++++++0---++++++++++" at row twenty, depth six. In each the first turnover lands exactly on zero; row twenty turns back positive at depth ten, and that second turn jumps over. Of the ninety-one rows from two to ninety-two, `turnover.zero_turnovers` 4 have a turnover that lands on zero. Each zero's parents are equal, `turnover.zeros.20_6.parents[0]` 623 and `turnover.zeros.20_6.parents[1]` 623 at the deep one, and below it the table mirrors and copies: `turnover.zeros.20_6.below` -343 against `turnover.zeros.20_6.above_prev_row` 343 in the row above, `turnover.zeros.20_6.diag_below` 1713 equal to `turnover.zeros.20_6.diag_parent` 1713.

**The rows turn early in bands.** Which parity of row turns over by depth half the row alternates in bands: of the six rows two to seven, `turnover.bands.2_7.even` 3 even rows and `turnover.bands.2_7.odd` 0 odd ones; eight to thirteen `turnover.bands.8_13.even` 3 and `turnover.bands.8_13.odd` 0; fourteen to nineteen `turnover.bands.14_19.even` 0 and `turnover.bands.14_19.odd` 3; twenty to twenty-five `turnover.bands.20_25.even` 3 and `turnover.bands.20_25.odd` 0; thirty-eight to forty-three `turnover.bands.38_43.even` 0 and `turnover.bands.38_43.odd` 3. Past about row forty-four both parities turn early and the bands blur. The deep zero sits at the switch from the odd band back to the even band: the fulcrum of the swing; the three small zeros sit in the first band.

**The first zero's beat sets the swing.** Its offset from the nearest odd harmonic is `turnover.first_zero.offset_per_row` 0.3727 per row and its depth factor turns `turnover.first_zero.turn_per_depth` -0.154 per depth; along the turnover path, at depth about half the row, the drift is `turnover.first_zero.drift_along_path` 0.2957 per row, a half-beat every `turnover.first_zero.half_beat_rows_along_path` 10.6 rows, against the bands' six to twelve.

**What it shows.** The four zeros are the four rows whose first turnover from the smooth part to the zeros of zeta lands exactly on an integer zero; the deep one sits at the pole of the first zero's swing, where the parity of the rows that turn early changes. It locates the zeros; it does not forbid another, which needs two equal parents at some later turnover. Exploratory; no outcome marked.
