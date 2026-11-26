---
id: 0587
date: 2026-11-26
type: run
title: "Julian's mirror fold on the sieve's steps: the paired errors at N/p and p share a sign, so the fold gives no cancellation; their total stays near the square root through 2^26"
refs: [lean_stage3/Stage3/PrimeStepTop.lean::rough_eq_one_add_primes]
supersedes: []
follows: 0586
context: above the cube root a prime's step is the prime count's error at two scales mirrored about the square root (PrimeStepTop); unit 0492 summed the scales one at a time and never paired them
sealed: false
---

**Question.** Above the cube root, does pairing each prime's two scales, N/p and p, mirrors about the square root, make the steps cancel as a whole?

**What ran.** `run/fold.py`, by `run/run.sh`, through `lab run`. The prime count exact by a sieve, the error against the logarithmic integral, at rows twenty to twenty-six of the dyadic ladder, over the primes between the cube root and the square root. EXPLORATORY: no prereg, no verdict.

**What it shows.** The paired sum against the sum of the pairs' sizes is `fold.r20.paired_ratio` 0.9632719922613836 at row twenty and `fold.r26.paired_ratio` 0.9882199920308978 at row twenty-six: the pairs share a sign and the fold cancels almost nothing. The total itself, over the square root, is `fold.r20.paired_sum_over_sqrt` 0.7099110698625986 at row twenty and `fold.r26.paired_sum_over_sqrt` 1.3755240284131198 at row twenty-six, against `fold.r26.primes` 949 primes, because each pair is small. Unpaired, the top scale alone sums to `fold.r26.top_scale_sum_over_sqrt` 2.800779248215381 and the low scale to `fold.r26.low_scale_sum_over_sqrt` 1.4252552198022612: pairing halves the total by subtraction of two same-signed pieces.

**What it says.** No cancellation comes from the fold; the size of the total comes from the smallness of each piece, and the sum of sizes grows with the row. The lost factor of unit 0492 is not reached on these rows.

What remains. Whether the growth of the paired total, row to row, stays under the square root times the logarithm.
