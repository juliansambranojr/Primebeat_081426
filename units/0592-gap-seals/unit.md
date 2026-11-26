---
id: 0592
date: 2026-11-26
type: run
title: "Julian's seals: every prime gap in a row of the table is closed by primes up to the row's square root, twins by the scaffold alone"
refs: [lean_stage3/Stage3/TwinDoor.lean::twin_balances, lean/TwinLattice.lean::twin_pocket]
supersedes: []
follows: 0591
context: Julian asked why twin primes, if each prime carries the composites between primes as a deal, and why seal something small; a twin pair's one composite is the multiple of six, closed by the scaffold primes two and three
sealed: false
---

**Question.** Which primes seal the composites between consecutive primes, row by row of the dyadic table, and where do twins sit among those deals?

**What ran.** `run/seal.py`, by `run/run.sh`, through `lab run`. Every prime gap in the rows eight to twenty-seven; for each, its hardest seal, the largest of the smallest prime factors of its composites. EXPLORATORY: no prereg, no verdict.

**The hardest seal in a row.** Its maximum over the row against the row's square root is `seal.r8.max_hardest_over_sqrt` 0.8125 at row eight, `seal.r16.max_hardest_over_sqrt` 0.98046875 at row sixteen and `seal.r27.max_hardest_over_sqrt` 0.9994615990428507 at row twenty-seven: the square of the prime just below the row's top. That a composite has a prime factor at most its square root is classical.

**A typical gap.** Its hardest seal against the row's square root averages `seal.r8.mean_hardest_over_sqrt` 0.36079545454545453 at row eight, `seal.r16.mean_hardest_over_sqrt` 0.2017322136018488 at row sixteen and `seal.r27.mean_hardest_over_sqrt` 0.13654911029624878 at row twenty-seven.

**The twins.** They are `seal.r8.twin_share` 0.3181818181818182 of the gaps at row eight, `seal.r16.twin_share` 0.11720039617035326 at row sixteen and `seal.r27.twin_share` 0.07179661320065622 at row twenty-seven, out of `seal.r27.gaps` 3645743 gaps there. A twin pair's one composite is the multiple of six between them, closed by two and three: the scaffold alone signs that deal.

**What it says.** The deals in a row are signed by primes up to the row's square root and none above it: Julian's seals and the sieve's half (`SieveExact`, the primes up to the square root fix the row) are one object. Twins are the gaps the scaffold closes alone; every wider gap calls on primes further up, to the cut.

What remains. Whether the shape of the deals inside a row bears on where the table's cells balance.
