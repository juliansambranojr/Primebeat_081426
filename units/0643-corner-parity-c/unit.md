---
id: 0643
date: 2026-11-28
type: measurement
title: The parity identity in C: pi(2^m) mod 2 exact on rows 2 to 66, and its cost toward row 93
refs: [lean/ParityCell.lean::prime_dvd_cell_prime_pow]
supersedes: []
follows: 0641
sealed: false
---

**Question.** Julian's answer to the second corner question (`notes/corner-questions.md`): write the parity identity of unit 0641 (corner-residues) in C and run it in the cloud, toward the rows past ninety-two. This unit records the C version, its check against the exact list, and its cost.

**What ran.** `run/parity.c`, compiled and driven by `run/check.py` through `run/run.sh` and `lab run`, on every row from two to sixty-six. It computes the sum of the squarefree-divisor count up to the power of two modulo four, in two parts: the Moebius-weighted divisor sums for the small square factors by their square-root loops, and for the large ones a table of the divisor sum modulo four with a segmented Moebius sieve; four threads, unsigned wraparound arithmetic, which is exact modulo four; past row sixty-three the power of two and the largest divisor-sum arguments are carried in double-width integers. The prime-power count's parity then loses the prime counts at the square and higher roots, by Lucy's method.

**It is exact on every row it reached.** The parity of the prime count agrees with the list on `parity.rows_agree` 65 of `parity.rows` 65 rows, from row `parity.rows_checked[0]` 2 to row `parity.rows_checked[1]` 66, past the earlier numpy check's forty-six and across the change to double-width arithmetic.

**Its cost grows a little faster than the square root.** The work past the fixed table, at row sixty-six, takes `meta.parity.work_seconds_row66` 118.3 seconds. Over rows fifty-six to sixty-six its time grows by `parity.log2_work_slope_rows56_66` 0.561 in the base-two logarithm per row, above the method's half, because the double-width divisions are slower. Carried to row ninety-three that is `parity.row93_days_at_fitted_slope` 49.9 days at the fitted rate and `parity.row93_days_at_half` 15.9 days at the half-power rate, for one row on four cores, each row after it costing more.

**What it shows.** The parity identity is exact in C as far as the list can check it here, and the plain method cannot reach row ninety-three in a session: weeks per row. Julian chose the faster route (`notes/corner-questions.md`, question six), a split that reaches the large square factors through a Mertens-type recursion instead of sieving to the square root; this unit is the reference that route is checked against. Exploratory; no outcome marked.
