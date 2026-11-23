---
id: 0497
date: 2026-11-23
type: run
title: "The table with regimes of one half: one cell where prime and composite are both zero, new deep zeros on both sides; EXPLORATORY"
refs: [lean/PairIdentity.lean::coeff_eq_one_iff_base_two, lean_stage3/Stage3/ShareLink.lean::share_is_re, lean_stage3/Stage3/BandJoin.lean::bandR_mirror]
supersedes: []
follows: 0496
context: the dyadic table cuts the number line at the powers of two; Julian asked what the cells come out to when the regimes are of one half, the cut taken at every half power, 2026-11-23
sealed: false
---

**Question.** With the regime boundaries at every half power of two, what do the cells of the prime table and of the composite table come out to?

**What ran.** `run/halfreg.py`, through `run/run.sh`. EXPLORATORY: no prereg, no decision rule, no verdict. The boundaries are the integer parts of two to the half-integers, up to index `halfreg.K` 53, which is `halfreg.top` 94906265. Each rung holds the primes, and the composites, between two boundaries; the unit is neither. Both seeds are differenced backward to depth `halfreg.depth` 12. Nothing is silenced.

**What it shows.** There is `halfreg.both_zero` 1 cell where the prime table and the composite table are both zero: half-regime `halfreg.both_k` 7, depth `halfreg.both_d` 1. The prime table has `halfreg.prime_zeros` 19 zero cells and the composite table `halfreg.composite_zeros` 10; most are at small half-regimes, where the counts are a handful.

Past the small ones, the prime table is zero at half-regime `halfreg.deep_prime[0].k` 21 depth `halfreg.deep_prime[0].d` 2, at half-regime `halfreg.deep_prime[1].k` 42 depth `halfreg.deep_prime[1].d` 5 and at half-regime `halfreg.deep_prime[2].k` 34 depth `halfreg.deep_prime[2].d` 11. The composite table is zero at half-regime `halfreg.deep_composite[0].k` 20 depth `halfreg.deep_composite[0].d` 3 and at half-regime `halfreg.deep_composite[1].k` 28 depth `halfreg.deep_composite[1].d` 6.

On the last row the total of a cell falls from one depth to the next by the factor `halfreg.total_ratio` 0.2929, against `halfreg.one_minus_inv_sqrt2` 0.2929 for a unit less the reciprocal of the square root of two. The prime share of the last rung is `halfreg.prime_share_depth0` 0.0549. The two halves of the last dyadic regime hold `halfreg.lower_half_share` 0.4142 and `halfreg.upper_half_share` 0.5858 of its numbers.

**What it is.** The cut at the half powers divides the exponent evenly and the numbers unevenly. The totals are no longer powers of the base, which the tree proves happens in every base but two (`coeff_eq_one_iff_base_two`). A single cell where both tables vanish is found here as in the dyadic table. Zeros appear deep on the composite side, where the dyadic table has none.

**What it is not.** A single run to one bound with nothing silenced, so the zero cells at small half-regimes are not comparable with the silenced dyadic tables. The boundaries are integer parts, so the rungs carry rounding. It is not a theorem.
