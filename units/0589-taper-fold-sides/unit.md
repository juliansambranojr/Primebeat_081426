---
id: 0589
date: 2026-11-26
type: run
title: "Julian's mirror fold of the sieve with a taper: both sides stay near two square roots from ten thousand to thirty million, and they sum to the wobble"
refs: [lean_stage3/Stage3/HalfTaper.lean::fold_eq, lean_stage3/Stage3/HalfTaper.lean::taper_eq]
supersedes: []
follows: 0588
context: unit 0588 found that every sharp cut of the sieve's Möbius sum loses a growing factor; the taper (1 − d/y) takes out exactly the signed count at the cut (taper_eq), and the fold about the square root is exact (fold_eq)
sealed: false
---

**Question.** With the taper, do the two sides of Julian's mirror fold, the small side below the square root and the mirrored side at the scales N/m, each stay at the square root?

**What ran.** `run/fold.py`, by `run/run.sh`, through `lab run`. The sieve's Möbius signs exact up to N; the tapered small side, the mirrored side less the smooth counts one plus Li N less Li of the square root, and their sum, which is the wobble. EXPLORATORY: no prereg, no verdict.

**The two sides.** At ten thousand the mirrored side less the smooth counts is `fold.fold.10000.mirrored_less_smooth_over_sqrt` -2.2301107431530864 square roots and the tapered small side `fold.fold.10000.tapered_small_over_sqrt` 2.1131533529083213; at a million `fold.fold.1000000.mirrored_less_smooth_over_sqrt` -2.526939501472036 and `fold.fold.1000000.tapered_small_over_sqrt` 2.411869771791567; at thirty million `fold.fold.30000000.mirrored_less_smooth_over_sqrt` -2.262480126678833 and `fold.fold.30000000.tapered_small_over_sqrt` 2.20474150380488. Their sum, the wobble, is `fold.fold.10000.sum_over_sqrt` -0.11695739024476523 at ten thousand and `fold.fold.30000000.sum_over_sqrt` -0.057738622873952906 at thirty million.

**The signed count grows; its mirrored sum does not.** The sieve's signed count itself reaches `fold.fold.30000000.max_signed_count_over_sqrt` 22.50829335230313 square roots at thirty million, against `fold.fold.10000.max_signed_count_over_sqrt` 1.27 at ten thousand. Summed over the mirrored scales it stays near two square roots: the fold averages its growth away.

**The small side to ten billion.** With the ordinary Möbius signs (below the square root they are the sieve's), the tapered small side is `fold.small_side.100000000.tapered_over_sqrt` 2.173002325175406 at a hundred million, `fold.small_side.1000000000.tapered_over_sqrt` 2.3819493901401536 at a billion and `fold.small_side.10000000000.tapered_over_sqrt` -0.7227617037123006 at ten billion, while the sharp one is `fold.small_side.1000000000.sharp_over_sqrt` 60.383373806591685 and `fold.small_side.10000000000.sharp_over_sqrt` -48.72276170376992.

**What it says.** This is the first split of the wobble whose parts show no growth over the measured range. The open line becomes the mirrored side less the smooth counts: the sieve's signed count summed at the scales N/m, against the logarithmic integral, at the square root.

**Correction, past the range (`run/reach.py`).** The tapered small side over the square root is x times the Möbius sum to x less the Möbius count at x, x the square root of N. It is `reach.1000` 2.411869771791756 at x a thousand, `reach.100000` -0.7227617037541876 at a hundred thousand, `reach.1000000` -11.395314612185587 at a million and `reach.10000000` -21.760460572399893 at ten million, and over x from a thousand to ten million it runs from `reach.range_min` -41.209905727369154 to `reach.range_max` 48.12351231338252. The claim above that neither side grows holds only on the measured range of the fold, x below about five and a half thousand. Past it the tapered side grows, and the mirrored side with it; their mirror cancellation keeps the wobble small. The fold loses a factor too, on both sides at once.

What remains. A bound on the two sides together, since apart each grows.
