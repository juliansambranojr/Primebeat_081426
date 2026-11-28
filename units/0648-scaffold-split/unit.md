---
id: 0648
date: 2026-11-28
type: measurement
title: The scaffold of 2 and 3: counted as halves, and the 6k+-1 slot table with its balance line
refs: [none]
supersedes: []
follows: 0647
sealed: false
---

**Question.** Julian: 2 and 3 are the scaffold of the lattice, half rather than whole, so that zero and one are visible at all; a coin starting on its side. Both readings, he said: the balance is part of the table, and the rest is from the primes themselves.

**What ran.** `run/scaffold.py`, by `run/run.sh`, through `lab run`, on the exact table to row ninety-two, in exact fractions.

**Counted as halves, 2 and 3 move only the edges.** With rows one and two at a half each, the table keeps its zeros at rows `scaffold.halves.zeros_half[0][0]` 2, `scaffold.halves.zeros_half[1][0]` 4, `scaffold.halves.zeros_half[2][0]` 8 and `scaffold.halves.zeros_half[3][0]` 20. The first cell becomes a half less a half: the coin on its side. `scaffold.halves.cells_changed` 182 cells change, all on the two edges where the row is the depth plus `scaffold.halves.changed_edges_row_minus_depth[0]` 1 or plus `scaffold.halves.changed_edges_row_minus_depth[1]` 2; along both the signs are the same as in the true table to depth ninety (`scaffold.halves.edge_signs_identical_to_depth_90` true). On the first edge the values go from `scaffold.halves.edge1_first_true[1]` 1 to `scaffold.halves.edge1_first_half[1]` "3/2", from `scaffold.halves.edge1_first_true[3]` 6 to `scaffold.halves.edge1_first_half[3]` "15/2".

**As the lattice, 2 and 3 have a table of their own.** After 2 and 3 only the numbers six times something plus or minus one can be prime; the slots per block run `scaffold.lattice.slots_rows_1_12[2]` 2, `scaffold.lattice.slots_rows_1_12[3]` 2, `scaffold.lattice.slots_rows_1_12[4]` 6, `scaffold.lattice.slots_rows_1_12[5]` 10, `scaffold.lattice.slots_rows_1_12[6]` 22, `scaffold.lattice.slots_rows_1_12[7]` 42 from row three. The count is a power of two and an alternating term over three on every row from two (`scaffold.lattice.formula_holds_rows_2_92` true), so every slot cell is known exactly (`scaffold.lattice.cell_formula_holds` true): a smooth part and an alternating part that doubles with each depth, the scaffold's own coin. The two parts cancel on the even rows with the row twice the depth plus two, where every slot cell is zero (`scaffold.lattice.balance_line_slot_cells_zero_d_1_45` true): the scaffold's balance line.

**The zeros split.** At rows four and eight the slot cell is `scaffold.lattice.zeros_split.4_1.slots` 0 and `scaffold.lattice.zeros_split.8_3.slots` 0, on the balance line, and the primes from five on balance there too: the primes balance on a scaffold that is balanced already. At row two the slot cell is `scaffold.lattice.zeros_split.2_1.slots` 0 because the first blocks hold no slot. At the deep zero the slot cell is `scaffold.lattice.zeros_split.20_6.slots` 2688 and the primes balance alone, `scaffold.lattice.zeros_split.20_6.primes_ge5` 0: its anchor is not the scaffold.

**The balance line pulls only at first.** Along it, the prime cell against the cells two rows either side at the same depth is a ratio of `scaffold.balance_line.ratio_d1_6[0]` 0.0, `scaffold.balance_line.ratio_d1_6[1]` 0.286, `scaffold.balance_line.ratio_d1_6[2]` 0.0, `scaffold.balance_line.ratio_d1_6[3]` 0.571, `scaffold.balance_line.ratio_d1_6[4]` 0.533 and `scaffold.balance_line.ratio_d1_6[5]` 0.9 at depths one to six; over all `scaffold.balance_line.depths` 44 depths its median is `scaffold.balance_line.ratio_median` 0.959, and `scaffold.balance_line.share_below_1` 0.59 of them fall below one.

**What it shows.** The scaffold of 2 and 3 carries an exact table with its own balance line, and the primes balance on it at the small zeros, while the numbers are small enough for the six-fold pattern to lead. The deep zero is a balance of the primes alone, off the scaffold's line; past the first rows the primes carry the table by themselves. Exploratory; no outcome marked.
