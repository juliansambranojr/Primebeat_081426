---
id: 0436
date: 2026-11-22
type: run
title: "The depth-6 cells as smooth cell plus wobble, rows 14 to 62; (20,6) is where they cancel; EXPLORATORY"
refs: [none]
supersedes: []
follows: 0435
context: the cell (20,6) of the table is zero; the question in the session of 2026-11-22 was what the depth-6 cells look like when the smooth part is taken out, and what the zero at row 20 is in those terms; Julian asked for it to be logged the same day
sealed: false
---

**Question.** Split each cell at depth `cells.depth` 6 into the same stencil applied to the logarithmic integral, the smooth cell, and what is left, the wobble. How large is the wobble, and what is the zero cell in these terms?

**What this is not.** EXPLORATORY. No prereg governs it and nothing below is a verdict. A finite range says nothing about every row.

**What ran.** `run/cells.py`, through `lab run`, on `pi2n_cache.json`. A cell at depth `cells.depth` 6 is the difference of order `cells.stencil_order` 7 of the prime count along the doublings. The script computes it for rows `cells.row_min` 14 to `cells.row_max` 62, `cells.rows` 49 rows, with the logarithmic integral at `cells.dps` 40 digits. The full table is `run/cells.log`.

**What it shows.**

The wobble is at square-root size. Divide the wobble by the square root of the row's doubling. From row `cells.q_from` 20, the zero cell's row, upward the quotient stays between `cells.q_lo_from20` -0.5521 and `cells.q_hi_from20` 0.5794, and it shrinks: at row `cells.row_max` 62 it is `cells.q_r62` 0.05909.

The zero cell is a crossing. At the zero cell the quotient is `cells.q_r20` -0.4428: the smooth cell is `cells.smooth_r20` 453.43192 and the wobble is `cells.wobble_r20` -453.432. They cancel to the integer `cells.cell_r20` 0. The rows on either side: the row before has cell `cells.cell_r19` 343, the row after `cells.cell_r21` 1713 with wobble `cells.wobble_r21` 839.001, the next `cells.cell_r22` 556 with wobble `cells.wobble_r22` -1130.78. The wobble changes sign at each of these rows.

The smooth cell takes over. The smooth cell roughly doubles each row and the wobble grows like the square root. In the range `cells.cells_zero` 1 cell is zero and `cells.cells_negative` 2 are negative, both below the zero cell's row. By the last row the cell is `cells.cell_r62` 767312587846013 and the wobble `cells.wobble_r62` 126888000.0.

**What it is for.** It states the zero cell of the table in the terms of unit 0434: the smooth part is what the integer count sees, the wobble is what it does not, and the zero cell is the row where the two are equal and opposite.
