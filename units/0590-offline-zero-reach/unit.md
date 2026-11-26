---
id: 0590
date: 2026-11-26
type: run
title: "Where a zero off the line would first show in Julian's table: by row 86 only if it is nearly at the edge of the strip; most of the strip stays hidden past any computed row"
refs: [lean_stage3/Stage3/HalfClean.lean::wobbleSqrt_of_clean]
supersedes: []
follows: 0589
context: the zeros' arrows close by angle alone once their lengths are fixed by the line (a test that assumes the answer); the table can only decide by lengths, so this asks where an off-line zero's longer arrow would show in the cells
sealed: false
---

**Question.** If a zero of zeta sat off the line, above the height where zeros are checked to be on it, at which row of the dyadic table would its mode first outgrow the on-line background?

**What ran.** `run/reach.py`, by `run/run.sh`, through `lab run`. The zero's mode in a cell and the on-line background, both in the form of the tree's zeros-as-modes units, with order-of-magnitude constants, at a height of three trillion, near where the zeros are checked. EXPLORATORY: no prereg, no verdict.

**First rows.** A zero with real part ninety-nine hundredths shows first at row `reach.first_row.0.99.row` 86, depth `reach.first_row.0.99.depth` 0; ninety-five hundredths at row `reach.first_row.0.95.row` 93; nine tenths at row `reach.first_row.0.9.row` 105; three quarters at row `reach.first_row.0.75.row` 168; six tenths at row `reach.first_row.0.6.row` 422. At this height the zero's symbol per depth is smaller than the background's, so the shallowest cell sees it first.

**What the computed rows can see.** With the rows computed, to ninety-two, the table sees an off-line zero only with real part at least `reach.least_beta_by_row_92.3e+12` 0.954 at three trillion, and `reach.least_beta_by_row_92.1e+13` 0.96 at ten trillion; from a thousand trillion up, no real part below one shows in those rows.

**What it says.** The table can fail: a zero near the edge of the strip just above the checked height would show in the computed rows, and they show none. That check is narrow. Every zero a little off the line, and every zero high up, stays hidden past any row that can be computed. The constants are rough.

What remains. The exact form of this reach, and whether `Nonvanishing` can carry it into Lean as a finite statement.
