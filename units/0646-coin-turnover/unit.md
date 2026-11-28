---
id: 0646
date: 2026-11-28
type: measurement
title: The coin turnover: signs keep their face along depth and flip along rows; parents of opposite sign certify most of the corner
refs: [lean/CornerSign.lean::ne_zero_of_opposite]
supersedes: []
follows: 0645
sealed: false
---

**Question.** Julian, after Diaconis's coin: what if every depth is a coin flip and every row a starting face? A parity has nothing to remember, being an exact sum of rows modulo two; the table's signs might. Each cell is its upper parent less its lower one, and when the two parents differ in sign the cell cannot be zero (`CornerSign.ne_zero_of_opposite`). A failed turnover is a cell whose parents share a sign.

**What ran.** `run/sign.py` on the exact table, rows twelve to ninety-two: unit 0597's corner, `sign.corner.cells` 2962 cells, and the rest, `sign.outside.cells` 1088 cells. Then `run/flip.py`, the explicit-formula model of unit 0640 (Riemann's R less each zero's term, Odlyzko's first hundred thousand zeros), on each cell of unit 0640's eight OpenCorner diagonals to depth four hundred and twenty and on both its parents. Both by `run/run.sh`, through `lab run`.

**The corner's signs behave like the coin.** A corner cell keeps the sign of the cell one depth up in its row `sign.corner.sign_keeps_depth_above` 0.9645 of the time, the starting face winning, and the sign of the row above at its depth only `sign.corner.sign_keeps_row_above` 0.0851 of the time: the coin turns over with each row. Its two parents differ in sign in `sign.corner.parents_opposite` 0.8905 of the corner's cells, so the sign alone keeps those cells off zero. Parity has no such memory: it keeps the depth above's parity `sign.corner.parity_keeps_depth_above` 0.5014 of the time and the row's own parity `sign.corner.parity_keeps_row_a_r` 0.5074. Outside the corner the smooth part leads and the coin never turns: the signs agree with the depth above `sign.outside.sign_keeps_depth_above` 1.0 and with the row above `sign.outside.sign_keeps_row_above` 0.9991 of the time, and the parents differ in sign `sign.outside.parents_opposite` 0.0 of the time.

**The model reads the turnovers right.** On the `flip.calibration.cells` 2962 corner cells to row ninety-two the model's share of failed turnovers is `flip.calibration.fail_share_model` 0.106 against the exact `flip.calibration.fail_share_exact` 0.1094, and it agrees with the exact table cell by cell `flip.calibration.agree` 0.9831 of the time.

**Deeper, the coin wobbles less.** Over the eight diagonals past row ninety-two the share of failed turnovers is `flip.all_diagonals_by_depth.d17-59[1]` 0.0947 at depths seventeen to fifty-nine (`flip.all_diagonals_by_depth.d17-59[0]` 95 cells), `flip.all_diagonals_by_depth.d60-119[1]` 0.0381 at sixty to a hundred and nineteen, `flip.all_diagonals_by_depth.d120-199[1]` 0.0375 at a hundred and twenty to a hundred and ninety-nine, `flip.all_diagonals_by_depth.d200-299[1]` 0.0387 at two hundred to two hundred and ninety-nine and `flip.all_diagonals_by_depth.d300-420[1]` 0.0269 from three hundred, `flip.all_diagonals_by_depth.d300-420[0]` 968 cells. On the ray at three times the depth it falls from `flip.diagonals.ray3.0.d17-59[1]` 0.1034 to `flip.diagonals.ray3.0.d300-420[1]` 0.0; on the edge at depth plus one it is `flip.diagonals.edge1.fail_share` 0.0334 overall. The steps follow the comb's leaders, which change at depths sixty-seven and three hundred and fifty-four (units 0610 and 0640): a single near-harmonic term turning by about a half-turn plus its offset each row fails to turn over about its offset over π of the time, and each new leader sits closer to its harmonic (unit 0615 has the offsets).

**What it shows.** In the corner the table is Diaconis's coin: it keeps its face along depth and turns over along the rows, and a zero can only sit where it fails to turn over, about one corner cell in nine to row ninety-two and fewer than one in twenty-five deep on the diagonals, with the share stepping down as the leaders change. The failed turnovers never run out: the corner holds more cells per depth than their share falls. Exploratory; no outcome marked.
