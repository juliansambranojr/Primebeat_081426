---
id: 0596
date: 2026-11-27
type: formalization
title: "Along the table's edge each zeta zero enters with (2^rho - 1)^d and the main term with 1: the deep corner reads the zeros"
refs: [lean/EdgeDiagonal.lean::edge_eq_fwdDiff, lean/EdgeDiagonal.lean::fwdDiff_iter_geom, lean/EdgeDiagonal.lean::fwdDiff_iter_two, lean/EdgeDiagonal.lean::fwdDiff_iter_sum, lean/EdgeDiagonal.lean::normSq_sub_one_le, lean/CornerSign.lean::ne_zero_of_opposite]
supersedes: []
follows: 0595
sealed: false
---

**Question.** No error bound reaches the deep corner of the table, the cells with depth past about a third of the row, even under RH (unit 0594 and `ExactRH`). What sets those cells?

**What ran.** The structure is proved in `lean/EdgeDiagonal.lean` and `lean/CornerSign.lean`, each built by `lake build` with exit 0 and pinned by `#guard_msgs`. `run/edge.py`, by `run/run.sh`, through `lab run`, measures the corner to the last row of the data and ranks the first hundred thousand zeros by their weight there. EXPLORATORY: no prereg, no verdict.

**The edge is a forward difference.** The cell at row `g + d`, depth `d`, is the `d`-th forward difference of the row sequence starting at row `g` (`edge_eq_fwdDiff`). The `d`-th forward difference of `z^m` is `(z − 1)^d · z^m` (`fwdDiff_iter_geom`), and of a finite sum of such terms, the sum of each with its own factor (`fwdDiff_iter_sum`). For the main term, `z = 2`, the factor is exactly one per depth (`fwdDiff_iter_two`). For a zero `ρ = β + iγ`, `z = 2^ρ`, and `|2^ρ − 1|²` lies between `(2^β − 1)²` and `(2^β + 1)²`, reaching the top exactly when `γ·log 2` is an odd multiple of `π` (`normSq_sub_one_le`). On the critical line the top is `1 + √2`; a zero off the line would reach `2^β + 1`.

**The data.** Along the edge diagonals at `g` five and ten, the cells grow per unit of depth by `edge.growth.g5.mean` 0.8612899398452157 and `edge.growth.g10.mean` 0.8634772090485009 on average, between `edge.growth.g10.min` 0.7759292679341817 and `edge.growth.g5.max` 0.9641142024504259, against `edge.growth.log_1_plus_sqrt2` 0.8813735870195429. The main term would give none.

**No zero leads for long.** The zero with the largest weight `|2^ρ − 1|^d/|ρ|` is the first, `edge.ranking.d10.leader` 14.134725142, factor `edge.ranking.d10.factor` 2.3736644341525683, through depth forty; by depth eighty it is `edge.ranking.d80.leader` 40.918719012, factor `edge.ranking.d80.factor` 2.411927163312734. The leader's margin in log weight falls from `edge.ranking.d10.lead_log` 0.9024910265949675 to `edge.ranking.d40.lead_log` 0.4227566771960305, `edge.ranking.d80.lead_log` 0.15153439727036755 and `edge.ranking.d320.lead_log` 0.018504909023363325: zeros ever nearer the top factor take over, so a deep cell is a sum of many near-equal terms.

**The sign structure.** Of the `edge.corner.cells` 2878 corner cells in the data, `edge.corner.opposite_parents` 2577 have parents of opposite sign one depth up, and such a cell cannot vanish (`ne_zero_of_opposite`); `edge.corner.same_parents` 301 do not.

**What it shows.** The deep corner is the part of the table that reads the zeros directly: there the oscillation must outgrow the main term, and an offline zero would show there fastest. Whether a corner cell vanishes is a question about the zeros' sum, which no single-term argument settles.
