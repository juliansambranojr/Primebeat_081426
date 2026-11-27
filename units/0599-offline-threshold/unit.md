---
id: 0599
date: 2026-11-27
type: run
title: "One zero moved off the line by a thousandth shows in the table to row 92, at about the same rate in every region; past row 92 the cells leave room for about 1e-17 accidental zeros"
refs: [lean/OfflineGain.lean::offline_gain_le, lean/EdgeDiagonal.lean::fwdDiff_iter_sum]
supersedes: []
follows: 0598
sealed: false
---

**Question.** How far off the line must one zero move before the true table, as far as its data go, sees it, and where in the table does it show? And how many further zeros do the cells' sizes leave room for?

**What ran.** `run/offline.py`, by `run/run.sh`, through `lab run`. The model of unit 0597 with two thousand zeros gives each cell a residual against the true table. One zero is then split into a pair at real parts one half plus and minus δ, each with half weight, and the cells in rows twelve to the end where the change exceeds the residual are counted. EXPLORATORY: no prereg, no verdict.

**The threshold.** For the first zero, ordinate `offline.threshold.z0_gamma` 14.134725142, the change beats the residual in `offline.threshold.z0_d1` 11 cells at δ a thousandth, `offline.threshold.z0_d10` 1396 at a hundredth and `offline.threshold.z0_d30` 3449 at three hundredths. Higher zeros show less: the zero at `offline.threshold.z1_gamma` 21.022039639 in `offline.threshold.z1_d30` 599 cells at three hundredths, the one at `offline.threshold.z5_gamma` 37.586178159 in `offline.threshold.z5_d30` 37, the one at `offline.threshold.z20_gamma` 79.33737502 in `offline.threshold.z20_d30` 63. These are sensitivities: the zeros themselves are verified on the line far higher.

**The regions.** For the first zero at a hundredth the detecting cells are `offline.regions.hits.shallow` 205 of the `offline.regions.cells.shallow` 655 shallow cells, `offline.regions.hits.middle` 191 of the `offline.regions.cells.middle` 514 in the middle band and `offline.regions.hits.corner` 1000 of the `offline.regions.cells.corner` 2962 in the corner: about a third in each. Depth gives the offline zero no extra visibility, as `OfflineGain` proves.

**Room for zeros.** Counting each nonzero cell as landing on zero with chance one over twice its size plus one, rows one to twenty give `offline.accidental.rows_1_20` 4.871145038866313 against `offline.accidental.actual_zeros_1_20` 4 zeros found, rows twenty-one to forty `offline.accidental.rows_21_40` 0.007887473590882007, the rest `offline.accidental.rows_41_92` 3.78913113197634e-06, and the last row alone `offline.accidental.row_92` 4.120918180117517e-17. The residues test the count's one assumption: even cells are `offline.residues.mod2.corner[0]` 0.5003474635163307 of the corner and `offline.residues.mod2.middle[0]` 0.4598393574297189 of the middle band, and the thirds mod three sit near a third in every region. A heuristic: the cells are set by the primes, not drawn.

**Correction.** The figures for this test reported in the session before this unit (eight cells, eight hundred ninety-one, a region split near a fifth) came from a script that shifted the offline rows by one index. This unit's script is the corrected one; its figures replace those.
