---
id: 0504
date: 2026-11-24
type: run
title: "The integers' errors, Möbius-signed, stay inside the square root to 10^7 while their sizes reach 1.37 N; EXPLORATORY"
refs: [lean_stage3/Stage3/NoHoles.lean::holes_resid, lean_stage3/Stage3/NoHoles.lean::log_factorial_close, lean_stage3/Stage3/NoHoles.lean::holes_err_trivial]
supersedes: []
follows: 0503
context: unit 0503 wrote the staircase as the Möbius-signed sum of the integers' log-factorials and stopped where the signs have to cancel; this run measures the two sums that split it, 2026-11-24
sealed: false
---

**Question.** In the split of unit 0503, how large is the Möbius-signed sum of the integers' errors, against the sum of their sizes and against the square root?

**What ran.** `run/holes.py`, through `run/run.sh`. EXPLORATORY: no prereg, no decision rule, no verdict. At four sizes, from `e4.sqrtN` 100 squared to `e7.sqrtN` 3162.3 squared, it sums over the scales the Möbius sign times the integers' error at that scale, the same errors without signs, and the signed smooth parts less the number.

**What it shows.** The signed error sum is `e4.signed` -25.1 at the smallest size and `e7.signed` 776.6 at the largest, which is `e4.signed_over_sqrt` 0.251 and `e7.signed_over_sqrt` 0.246 of the square root. The sum of the sizes is `e4.sizes` 13655.3 and `e7.sizes` 13657458.3, that is `e7.sizes_over_N` 1.3657 times the number, and `e7.sizes_over_sqrt` 4318.9 times the square root at the largest size. The signed smooth parts less the number are `e4.smooth_minus_N` 38.5 and `e7.smooth_minus_N` -2237.2.

**What it is.** The signs cancel the integers' errors from a size proportional to the number down to inside the square root at every size measured. The sum of the sizes grows in proportion to the number; the bound of unit 0503 from a logarithm per scale is larger than what is measured.

**What it is not.** Four sizes, the largest ten million. Both sums are pieces of the staircase and cancel against each other in part. It is not a theorem: the cancellation of the signs is the step unit 0503 left open.
