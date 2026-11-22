---
id: 0435
date: 2026-11-22
type: run
title: "pi(2^r) - li(2^r) along the doublings to r = 62, against sqrt(x)/log x; EXPLORATORY"
refs: [none]
supersedes: []
follows: 0434
context: the table is the count of primes at the doublings; the question in the session of 2026-11-22 was how far that count sits from the smooth count at each doubling, and whether the distance stays at square-root size on the cached range; Julian asked for it to be logged the same day
sealed: false
---

**Question.** At each doubling, how far is the prime count from the logarithmic integral, and how does that distance compare with the square root of the doubling?

**What this is not.** EXPLORATORY. No prereg governs it and nothing below is a verdict. A finite range says nothing about every doubling.

**What ran.** `run/doubling.py`, through `lab run`, on `pi2n_cache.json`. It reads the cached prime count at each doubling from exponent `doubling.r_min` 4 to exponent `doubling.r_max` 62 and subtracts the logarithmic integral at `doubling.dps` 40 digits. The full table is `run/doubling.log`.

**What it shows.**

The sign. The prime count is below the smooth count at every doubling in the range: `doubling.positive_residuals` 0 residuals are positive.

The size. Divide the residual by the square root of the doubling over its logarithm. From exponent `doubling.ratio_from` 10 upward that ratio stays between `doubling.ratio_lo_from10` -2.0411 and `doubling.ratio_hi_from10` -0.60336. At exponent `doubling.r_max` 62 it is `doubling.ratio_r62` -0.78872, with residual `doubling.res_r62` -39412395.0. Against the square root times the logarithm, the bound the Riemann hypothesis is equivalent to, the largest ratio in the range is `doubling.worst_over_sqrt_log` 0.2272, and it falls as the exponent grows.

The growth. Over `doubling.steps` 58 steps from one doubling to the next, the size of the residual grew at `doubling.grew` 50 and shrank at `doubling.shrank` 8. So the distance grows, with a wobble, and stays at square-root size on this range.

**What it is for.** It is the row-zero view of what unit 0436 reads at depth: the cells are differences of these counts, and their wobble is the difference of these residuals.
