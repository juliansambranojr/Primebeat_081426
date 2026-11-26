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

**What it shows.** The paired sum against the sum of the pairs' sizes is `fold.rows.r20.paired_ratio` 0.9632719922613836 at row twenty and `fold.rows.r26.paired_ratio` 0.9882199920308978 at row twenty-six: the pairs share a sign and the fold cancels almost nothing. The total itself, over the square root, is `fold.rows.r20.paired_sum_over_sqrt` 0.7099110698625986 at row twenty and `fold.rows.r26.paired_sum_over_sqrt` 1.3755240284131198 at row twenty-six, against `fold.rows.r26.primes` 949 primes, because each pair is small. Unpaired, the top scale alone sums to `fold.rows.r26.top_scale_sum_over_sqrt` 2.800779248215381 and the low scale to `fold.rows.r26.low_scale_sum_over_sqrt` 1.4252552198022612: pairing halves the total by subtraction of two same-signed pieces.

**What it says.** No cancellation comes from the fold; the size of the total comes from the smallness of each piece, and the sum of sizes grows with the row. The lost factor of unit 0492 is not reached on these rows.

**The growth.** Extended to every row from twenty to twenty-eight. The paired total over the square root reaches `fold.rows.r28.paired_sum_over_sqrt` 1.7323690021345726 at row twenty-eight, with the pairs still sharing a sign (`fold.rows.r28.paired_ratio` 0.9701768965480095). Fitted against the logarithm of N, it grows like N to the `fold.growth.exponent_over_sqrt` 0.15620133113087478 times the square root, and stands at `fold.growth.over_sqrt_log_at_top` 0.08926000601318965 of the square root times the logarithm at the top row. If that rate holds, the part above the cube root alone passes the square root times the logarithm far past the data, so it cannot be bounded on its own: the primes below the cube root must cancel it.

What remains. The primes below the cube root, measured against the part above: whether the two cancel.
