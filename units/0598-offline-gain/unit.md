---
id: 0598
date: 2026-11-27
type: formalization
title: "Depth does not amplify an offline zero beyond what the row carries"
refs: [lean/OfflineGain.lean::offline_gain_le, lean/OfflineGain.lean::offline_gain_lt, lean/OfflineGain.lean::offline_gain_pow_le, lean/EdgeDiagonal.lean::normSq_sub_one_le]
supersedes: []
follows: 0597
sealed: false
---

**Question.** The deep corner reads the zeros (the two units before this one), and a zero off the line at real part β enters an edge cell with a factor up to `2^β + 1` per depth, above the on-line top `2^(1/2) + 1`. Does going deeper in the table make an offline zero easier to see than going higher in the row?

**What ran.** `lean/OfflineGain.lean`, built by `lake build` with exit 0 and pinned by `#guard_msgs` at `propext, Classical.choice, Quot.sound`. `run/gain.py`, by `run/run.sh`, through `lab run`, evaluates both gains at a few β.

**What is proved.** `offline_gain_le`: for β at least one half, `2^β + 1 ≤ 2^(β − 1/2)·(2^(1/2) + 1)`, strict off the line (`offline_gain_lt`), and over `d` depths `(2^β + 1)^d ≤ (2^(β − 1/2))^d·(2^(1/2) + 1)^d` (`offline_gain_pow_le`). The proof is one line of arithmetic: the right side is `2^β + 2^(β − 1/2)`, and `2^(β − 1/2)` is at least one.

**The sizes.** Per depth the offline zero gains on the on-line top by `gain.b55.depth_gain` 1.0206577141102247 just off the line, against the per-row gain `gain.b55.row_gain` 1.0352649238413776; at three quarters by `gain.b75.depth_gain` 1.110834961871108 against `gain.b75.row_gain` 1.189207115002721; at one by `gain.b100.depth_gain` 1.2426406871192852 against `gain.b100.row_gain` 1.4142135623730951. In logarithms the depth gain is about three fifths of the row gain near the line: `gain.b55.depth_gain_log` 0.020447237245659645 against `gain.b55.row_gain_log` 0.0346573590279973.

**What it shows.** The table's depth never magnifies an offline zero beyond what one more row gives it. The comparison is against the on-line zeros' largest factor; a typical on-line zero sits below it. An argument through the table that rules out an offline zero needs more than amplification: the cells' integrality, the exact repeats at the four zeros, or cancellation among the on-line zeros.
