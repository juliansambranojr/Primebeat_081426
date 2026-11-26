---
id: 0586
date: 2026-11-26
type: run
title: "Adding the sediment in the sieve order cuts the time zeta zeros 725 and 726 spend off the line in the sections from 97 stages to 12"
refs: [lean_stage3/Stage3/HalfSieve.lean::resid_step]
supersedes: []
follows: 0585
context: Jerby's paper on collision and repulsion tracks the zeros of the sections of the approximate functional equation as terms are added and reorders them to avoid collisions; Julian's seal suggests the order of the sieve, one largest prime at a time
sealed: false
---

**Question.** Does adding the terms of the section in the sieve's order, grouped by largest prime factor, keep the pair of zeros near zeta's seven hundred and twenty-fifth and twenty-sixth on the line longer than the natural order?

**What ran.** `run/order.py`, by `run/run.sh`, through `lab run`. On the line each term is real, the cosine form of Jerby's paper on high-order sections. The terms one to `results.M` 546, Spira's length, are added one at a time in two orders; after each the sign changes of the partial sum are counted on a window holding exactly the two zeros. A count of two has the pair on the line; below two, the pair has collided and left it. EXPLORATORY: no prereg, no verdict.

**What it shows.** Natural order: the pair is off the line at `results.natural_prefixes_below_two` 97 stages, from stage `results.natural_first_below_two` 6 to `results.natural_last_below_two` 166. Sieve order: at `results.sieve_prefixes_below_two` 12 stages, from `results.sieve_first_below_two` 204 to `results.sieve_last_below_two` 332. Both end with the pair on the line, `results.natural_final_count` 2 and `results.sieve_final_count` 2.

**What it says.** One pair, one window. The sieve order shortens the pair's time off the line and moves it later; it does not remove the collision. Jerby's reversal order removes it for this pair in his figure. Whether a prime order has been tried before is not checked yet.

**More pairs.** `run/pairs.py` runs both orders on the five closest pairs below the point run's height from unit 0578 and on the pair above. Stages off the line, natural against sieve: `pairs.pair91.natural_stages_off_line` 25 against `pairs.pair91.sieve_stages_off_line` 9 near height `pairs.pair91.heights[0]` 220.714918839314; `pairs.pair135.natural_stages_off_line` 41 against `pairs.pair135.sieve_stages_off_line` 11; `pairs.pair159.natural_stages_off_line` 46 against `pairs.pair159.sieve_stages_off_line` 0; `pairs.pair186.natural_stages_off_line` 54 against `pairs.pair186.sieve_stages_off_line` 9; `pairs.pair212.natural_stages_off_line` 60 against `pairs.pair212.sieve_stages_off_line` 10. On every pair the sieve order spends fewer stages off the line, and on one it never leaves. A literature search found no earlier rearrangement of the sections by prime order; that is one search.

**Every pair from height one hundred to six hundred.** `run/allpairs.py`, `allpairs.pairs` 311 pairs. Natural order: `allpairs.natural_pairs_leave` 265 pairs leave the line at some stage, `allpairs.natural_stages_off` 8511 stages off in all. Sieve order: `allpairs.sieve_pairs_leave` 140 pairs leave, `allpairs.sieve_stages_off` 1510 stages off. Only `allpairs.leave_sieve_only` 1 pair leaves in the sieve order and not in the natural one. The sieve order roughly halves the pairs that leave and cuts the time off the line about five and a half times; it does not keep every pair on the line.

What remains. Why the sieve order holds the pairs; whether it ever loses one. `lean_stage3/Stage3/SieveOrder.lean` proves only that the full section is the same in both orders.
