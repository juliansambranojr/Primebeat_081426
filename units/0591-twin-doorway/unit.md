---
id: 0591
date: 2026-11-26
type: run
title: "Julian's doorway: the twins balance the two sides of every 6k exactly, and the lone primes' difference stays near a twentieth of the square root to a hundred million"
refs: [lean_stage3/Stage3/TwinDoor.lean::twin_balances, lean_stage3/Stage3/TwinDoor.lean::twins_sum_zero]
supersedes: []
follows: 0590
context: Julian, asked what closes the zeros' arrows, named the twins as doorways at each 6k, one twin to keep going and one back to the half; the two sides of 6k split the prime count into its sum (zeta) and its difference (the L-function mod 3)
sealed: false
---

**Question.** How do the twin pairs sit across the two sides of the doorway at a multiple of six, and how large is the difference of the two sides?

**What ran.** `run/door.py`, by `run/run.sh`, through `lab run`. The primes above three to a hundred million, split into the side below a multiple of six and the side above; the difference of the two counts, and the part of it carried by twin primes. `Stage3/TwinDoor.lean` proves that a twin pair puts one prime on each side and so carries none of the difference. EXPLORATORY: no prereg, no verdict.

**The twins.** The twins' share of the difference is `door.10000.twins_difference` 0 at ten thousand and `door.100000000.twins_difference` 0 at a hundred million, as the theorem says, while they are `door.10000.twin_share` 0.33251833740831294 of the primes at ten thousand and `door.100000000.twin_share` 0.15284720711945407 at a hundred million.

**The difference.** It is `door.10000.difference` 5 at ten thousand, `door.1000000.difference` 34 at a million and `door.100000000.difference` 419 at a hundred million; over the square root `door.10000.difference_over_sqrt` 0.05, `door.100000.difference_over_sqrt` 0.06957010852370434, `door.1000000.difference_over_sqrt` 0.034, `door.10000000.difference_over_sqrt` 0.059767047777182364 and `door.100000000.difference_over_sqrt` 0.0419. It is always positive, the side below a multiple of six ahead, and it is the lone primes' alone.

**What it says.** At every multiple of six with two primes beside it the doorway is balanced: one twin goes each way. Only the lone primes tip it, and the tip stays at the square root over the range. That side is the L-function of the character modulo three, not zeta; its bound is a statement about that function's zeros, of the same kind as the open line.

What remains. Whether the balance of the twins and the size of the lone primes' tip are tied, and a route from that side back to the wobble.
