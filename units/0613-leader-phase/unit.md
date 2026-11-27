---
id: 0613
date: 2026-11-27
type: measurement
title: The leader's phase at the cells it loses: whether the corner's leader loses near its own zero crossing
refs: [lean/EdgeDiagonal.lean::edge_eq_fwdDiff]
supersedes: []
follows: 0612
sealed: false
---

**Question.** The corner's leader and the rest of the zeros are of one size (unit 0612, rest-cancellation), and the leader loses about half the cells. Does it lose where its own phase is near a zero crossing?

**What ran.** `run/phase.py`, by `run/run.sh`, through `lab run`, on unit 0597's corner of the true table, `phase.cells` 2962 cells. The leader is the comb's prediction (unit 0610, corner-zoom). Its complex explicit-formula term, differenced like the table, gives its part of each cell as an envelope times the cosine of a phase. The leader loses a cell when its part is smaller than everything else the zeros put there.

**Where it loses.** It loses `phase.losing` 1419 cells and wins `phase.winning` 1543. The size of the cosine of its phase has median `phase.abscos_median_losing` 0.484 in the cells it loses and `phase.abscos_median_winning` 0.899 in the cells it wins, against `phase.abscos_median_uniform_phase` 0.707 for a phase spread evenly. By the size of the cosine, the share it loses falls steadily: `phase.lose_share_by_abscos.0.0_0.2` 0.935 below a fifth (`phase.cells_by_abscos.0.0_0.2` 339 cells), `phase.lose_share_by_abscos.0.2_0.4` 0.795 to two fifths, `phase.lose_share_by_abscos.0.4_0.6` 0.67 to three fifths, `phase.lose_share_by_abscos.0.6_0.8` 0.478 to four fifths and `phase.lose_share_by_abscos.0.8_1.0` 0.223 above (`phase.cells_by_abscos.0.8_1.0` 1337 cells).

**The leader at full swing.** Its envelope alone, the size it reaches at the top of its swing, is larger than the rest in `phase.envelope_beats_rest` 0.761 of the cells, a median `phase.envelope_over_rest_median` 1.92 times the rest. Among the cells it loses, the envelope would still have won `phase.losing_cells_envelope_beats_rest` 0.501 of them.

**What it shows.** Half the leader's losses come from its own phase passing near zero, at a size large enough to win at full swing; the other half are cells where the rest is larger than the leader's full swing. The first half are predictable from the leader's zero and the cell alone. The second are the cells where the rest's bounded size, measured on its own, decides. Exploratory; no outcome marked.
