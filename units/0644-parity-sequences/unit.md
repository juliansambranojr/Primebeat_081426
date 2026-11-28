---
id: 0644
date: 2026-11-28
type: measurement
title: The parity of pi(2^m) and of the rows, rows 1 to 92: runs and lags against shuffles
refs: [none]
supersedes: []
follows: 0643
sealed: false
---

**Question.** Julian: is there a pattern in the rows the parity work touched? The parity of the prime count at each power of two, and of each row, read as a sequence.

**What ran.** `run/parity_seq.py`, by `run/run.sh`, through `lab run`, on the exact counts to row ninety-two, `parity_seq.rows` 92 values per sequence. Each statistic is set against twenty thousand random orders of the same values.

**The prime counts.** Odd `parity_seq.pi.odd` 41 times. They change parity `parity_seq.pi.runs` 42 times as runs, against `parity_seq.pi.runs_shuffled_mean` 46.48 for random orders, a share `parity_seq.pi.runs_p_le` 0.202 of which have as few. The longest run is `parity_seq.pi.longest_run` 9, the counts at rows twenty-one to twenty-nine all odd; random orders give a run that long in `parity_seq.pi.p_longest_ge_observed` 0.1611 of cases. The lag correlations stay small, the largest `parity_seq.pi.autocorr_lags_1_10[3]` 0.149 at lag four.

**The rows.** Odd `parity_seq.row.odd` 42 times, in `parity_seq.row.runs` 46 runs against `parity_seq.row.runs_shuffled_mean` 46.63. The longest run is `parity_seq.row.longest_run` 8, which random orders reach in `parity_seq.row.p_longest_ge_observed` 0.2764 of cases. Rows forty-one to fifty alternate, which makes the correlation at lag two `parity_seq.row.autocorr_lags_1_10[1]` 0.233, the largest of the first ten lags; a random order has a lag at least that strong in `parity_seq.row.p_max_abs_autocorr_ge_observed` 0.1936 of cases.

**What it shows.** Every feature the eye picks out of the two sequences appears in random orders of the same values at a rate between one in six and one in two: nothing in the known parities predicts the next one. This agrees with unit 0641 (corner-residues), where the residues showed no harmonic dependence; row ninety-three's parity has to be computed, which is the fast route handed to the Mac (`notes/2026-11-28-fast-parity-handoff.md`). Exploratory; no outcome marked.
