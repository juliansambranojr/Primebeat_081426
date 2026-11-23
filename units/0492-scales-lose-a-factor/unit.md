---
id: 0492
date: 2026-11-23
type: decision
title: "Bounding the residual at N from the scales N/m loses a factor that grows with N; the pieces are large and of one sign; EXPLORATORY"
refs: [lean_stage3/Stage3/Compression.lean::compression, lean_stage3/Stage3/CompositeSplit.lean::composites_no_signs, lean_stage3/Stage3/HalfSieve.lean::spiralLink_iff_wobble]
supersedes: []
follows: 0491
context: unit 0491 wrote the numbers up to a bound as the combinations of the primes up to its square root and the multiples of the new primes, and left the size of the residual of the combinations underived; Julian said to try, 2026-11-23
sealed: false
---

**Question.** Can the residual of the count of primes at a bound be held at square-root size from the residuals at the smaller scales, the bound over each number up to its square root, through the identity `Compression.compression`?

**What ran.** `run/scales.py`, through `run/run.sh`. EXPLORATORY: no prereg, no decision rule, no verdict. The multiples of the new primes in `Compression.compression` regroup by the cofactor: the count of primes at the bound, plus the counts at the bound over each number from two to the square root, less the square root times the count at the square root. Taking the smooth count from each gives the same sum in residuals. The script computes each piece at five bounds.

**What it shows.** At the bound `scales.rows[4].N` 100000000, with square root `scales.rows[4].sqrtN` 10000.0: the residual at the bound itself is `scales.rows[4].own` -756.22, which is `scales.rows[4].own_over_sqrt` -0.0756 of the square root. The residuals at the smaller scales add to `scales.rows[4].others` -311805.71, and their sizes add to `scales.rows[4].absothers` 311805.71: the same number, so every one of them has the same sign and nothing cancels among them. The square root times the residual at the square root is `scales.rows[4].root` -189774.42. The three together, which is minus the residual of the count of combinations, come to `scales.rows[4].comb` -122787.5.

Over the square root, the sum at the smaller scales is `scales.rows[0].others_over_sqrt` -8.0145 at `scales.rows[0].N` 10000, `scales.rows[1].others_over_sqrt` -11.1265 at `scales.rows[1].N` 100000, `scales.rows[2].others_over_sqrt` -15.1514 at `scales.rows[2].N` 1000000, `scales.rows[3].others_over_sqrt` -21.6875 at `scales.rows[3].N` 10000000 and `scales.rows[4].others_over_sqrt` -31.1806 at `scales.rows[4].N` 100000000. It grows with the bound. The residual of the combinations over the square root is `scales.rows[0].comb_over_sqrt` -1.2379, `scales.rows[1].comb_over_sqrt` -3.2914, `scales.rows[2].comb_over_sqrt` -3.833, `scales.rows[3].comb_over_sqrt` -3.0305 and `scales.rows[4].comb_over_sqrt` -12.2788: it is not at square-root size either. The residual at the bound itself over the square root stays small: `scales.rows[0].own_over_sqrt` -0.1898, `scales.rows[1].own_over_sqrt` -0.1254, `scales.rows[2].own_over_sqrt` -0.1314, `scales.rows[3].own_over_sqrt` -0.1079, `scales.rows[4].own_over_sqrt` -0.0756.

**The lost factor.** The identity is exact. A proof that bounds the residual at the bound by the sizes of the other pieces fails by size: the pieces at the smaller scales are each at square-root size of their own scale, there are as many as the square root, they share a sign on this range, and their sum over the square root of the bound grows without stopping on these five bounds. The residual at the bound is the small difference of large pieces. The step is right and the design is wrong: no induction down the scales that adds sizes can close.

**The decision.** The route from the composite side by adding sizes across the scales is closed. What the numbers show instead is the cancellation itself: at the largest bound three pieces of the order of a hundred thousand and more leave `scales.rows[4].own` -756.22. Julian named this the seal. A proof has to use the pieces together, as one object, and never one scale at a time. The tree has one such object already: the sum over the zeros, where each scale's residual is the same modes read at that scale.

**What it is not.** Five bounds. The residuals keep one sign on this range, which is known to change far beyond it. It is not a theorem and it does not test the Riemann hypothesis.
