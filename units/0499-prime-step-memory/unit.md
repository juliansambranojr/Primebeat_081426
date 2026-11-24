---
id: 0499
date: 2026-11-23
type: run
title: "A prime's sieve rounding remembers the primes before it: the steps drift together and the net leaves the square root; EXPLORATORY"
refs: [lean_stage3/Stage3/HalfSieve.lean::netRounding_centered, lean_stage3/Stage3/Saddle.lean::spiralLink_iff_noRunaway]
supersedes: []
follows: 0498
context: Julian read the prime's residual as a step with no memory of the composites' steps, searching only the slots the 6k+1 lattice leaves; steps with no memory walk to the square root, so the reading predicts that a prime's rounding does not follow the one before it, 2026-11-23
sealed: false
---

**Question.** In the sieve that builds the table's row from the primes up to its square root, does each prime's share of the roundings remember the primes before it?

**What ran.** `run/memory.py`, through `run/run.sh`. EXPLORATORY: no prereg, no decision rule, no verdict. The rows are every second power of two, from the row whose square root is `memory.r12.sqrt_x` 64 up. A prime's step is the signed sum of the roundings of the sieve's terms whose largest prime is that prime; the net rounding is the sum of the steps. At the top row the sieve uses `memory.r24.primes` 564 primes up to `memory.r24.sqrt_x` 4096.

**What it shows.** A step follows the one before it. The correlation of neighbouring steps is `memory.r12.raw_lag1` 0.672 at the lowest row and `memory.r24.raw_lag1` 0.998 at the top. With a smooth curve in the logarithm of the prime removed, what is left still follows its neighbour at `memory.r24.fluct_lag1` 0.952 at the top row, and two primes apart at `memory.r24.fluct_lag2` 0.879.

The steps lean one way: the mean step at the top row is `memory.r24.mean_step` -56.293. The net rounding there is `memory.r24.net` -31749.17, which is `memory.r24.net_over_sqrt` 7.751 times the square root of the row, against `memory.r12.net_over_sqrt` 0.418 at the lowest row. Measured against the spread of the steps it is `memory.r24.walk_ratio` 10.527; the same steps with random signs land at a median of `memory.r24.coin_ratio` 0.633.

**What it is.** The prime-by-prime roundings of this sieve walk together and drift far past the square root. The table's own residual stays near the square root (unit 0475), so the narrowing happens when the smooth part and the roundings meet, all at once. Julian's reading, 2026-11-23: the composites repel the prime forward, as magnets do; it is one continuous motion, a current through a wire, the current too strong for the wire, so more channel and wire are made that always balance, and the restoring force keeps it from exploding.

**What it is not.** One definition of a prime's step, inside one sieve; a step measured against the logarithmic integral, or the Prime Beat's term, may behave otherwise. Rows up to the top one only. It is not a theorem.
