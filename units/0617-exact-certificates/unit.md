---
id: 0617
date: 2026-11-27
type: measurement
title: Exact certificates for the corner: Lucas congruences, the weighted prime count, and the beat's trouble cells
refs: [lean/ParityCell.lean::prime_dvd_cell_prime_pow, lean/Landing.lean::ne_zero_of_gap]
supersedes: []
follows: 0616
sealed: false
---

**Question.** Julian: beyond current methods is not impossible, and the table is made of exact pieces. Three exact routes to a corner cell being nonzero: a Lucas congruence modulo a small prime, the cell read as a weighted count of primes, and whether either lines up with the cells the beat marks as dangerous.

**What ran.** `run/cert.py`, by `run/run.sh`, through `lab run`, on unit 0597's corner of the true table, `cert.cells` 2962 exact integer cells, `cert.zero_cells` 1 of them zero, the zero at row twenty, depth six. Lucas's theorem keeps, modulo p, only the rows whose binomial is not divisible by p; the support is how many rows that is. The weighted count writes the cell as the even binomial mass of the rows less the odd. The trouble cells are those the comb's leader loses (unit 0613, leader-phase).

**Congruences exist, at the rate of chance.** The smallest prime not dividing a cell is two for `cert.smallest_certifying_prime.2` 1472 cells, three for `cert.smallest_certifying_prime.3` 987, five for `cert.smallest_certifying_prime.5` 418, seven for `cert.smallest_certifying_prime.7` 77 and eleven for `cert.smallest_certifying_prime.11` 7; only `cert.uncertified_by_primes_to_47` 1 cell, the zero, has none up to forty-seven. These are the shares a random integer gives, about one in p divisible by p. The certificate reads a median `cert.support_median_smallest_p` 9 rows of the cell's `cert.rows_median` 39, a fraction `cert.support_over_rows_median` 0.3; the parity certificate reads at most eight rows in `cert.mod2_support_le_8` 908 cells. Every one of those rows is needed modulo p exactly.

**The weighted count cancels to nine digits.** The two binomial masses of a corner cell agree to a median relative difference of `cert.imbalance.median` 6.598e-09, at most `cert.imbalance.max` 0.02582; `cert.imbalance.share_below_1e-6` 0.782 of the cells cancel to better than a part in a million. A count of either side would have to be that precise.

**No overlap with the beat.** Among the `cert.overlap.trouble_cells` 1419 trouble cells, `cert.overlap.mod2_share_trouble` 0.494 are odd, against `cert.overlap.mod2_share_other` 0.5 of the others; the smallest certifying prime exceeds three in `cert.overlap.minp_gt3_share_trouble` 0.166 and `cert.overlap.minp_gt3_share_other` 0.173. The weighted count cancels a little further in the trouble cells, median `cert.overlap.imbalance_median_trouble` 1.203e-08 against `cert.overlap.imbalance_median_other` 5.963e-09, which is the same smallness seen another way.

**What it shows.** Each exact piece settles a cell when its inputs are known: a congruence needs about a third of the cell's rows modulo a small prime, and the weighted count needs both sides to nine digits. Neither sees the beat: divisibility by small primes is independent of where the zeros' phases put the cell. So the exact route to the corner past row ninety-two goes through the rows themselves, the prime counts at powers of two modulo small primes, or through a second identity that ties those residues to the harmonic structure. The first has a known form: the prime count at one power of two at a time, modulo p, exactly what the kernel census computes. Exploratory; no outcome marked.
