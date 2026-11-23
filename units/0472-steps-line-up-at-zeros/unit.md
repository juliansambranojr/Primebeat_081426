---
id: 0472
date: 2026-11-23
type: run
title: "The first N steps of the staircase, turned and added, line up at the heights of the zeros; EXPLORATORY"
refs: [lean_stage3/Stage3/CountModes.lean::im_ne_zero, lean_stage3/Stage3/FixedRowTwo.lean::table_cell_fixed_row_two]
supersedes: []
follows: 0471
context: the tree writes the staircase of the count through the zeros of zeta and has no statement that produces a zero from the steps; Julian posited on 2026-11-23 that a nontrivial zero is the steps seen together, and asked for the posit to be logged and measured once the build in progress was done
sealed: false
---

**Question.** If each step of the staircase is turned by an angle and the steps are added, do they line up at the heights of the zeros of zeta, and more sharply as more steps are taken?

**What ran.** `run/lineup.py`, through `run/run.sh`, on the bench's file of zeros `zeros600.json`. EXPLORATORY: no prereg, no decision rule, no verdict. Each integer up to a cutoff carries its step, the logarithm of the prime at a prime power and nothing elsewhere, less the smooth count's unit. It is turned by the trial height times its logarithm, weighed by the reciprocal of its square root and by a ramp that falls to nothing at the cutoff, and all are added. The size of that sum was scanned over trial heights from `lineup.gamma_lo` 10.0 to `lineup.gamma_hi` 60.0 in steps of `lineup.gamma_step` 0.005, and its local maxima were compared with the `lineup.zeros_in_window` 12 zeros that lie at least `lineup.window` 1.0 inside that range.

**What it shows.** At every cutoff all of those zeros were matched by a local maximum: `lineup.rows[0].zeros_found` 12, `lineup.rows[1].zeros_found` 12, `lineup.rows[2].zeros_found` 12, `lineup.rows[3].zeros_found` 12.

With the first `lineup.rows[0].N` 100 integers the mean distance from a zero to its maximum was `lineup.rows[0].mean_dev` 0.0424 and the largest `lineup.rows[0].max_dev` 0.1271. With `lineup.rows[1].N` 1000: `lineup.rows[1].mean_dev` 0.0229 and `lineup.rows[1].max_dev` 0.0562. With `lineup.rows[2].N` 10000: `lineup.rows[2].mean_dev` 0.0039 and `lineup.rows[2].max_dev` 0.0153. With `lineup.rows[3].N` 100000: `lineup.rows[3].mean_dev` 0.0079 and `lineup.rows[3].max_dev` 0.0302. The distances fell over the first three cutoffs and rose at the last; the grid's step is `lineup.gamma_step` 0.005.

The maxima grew with the cutoff. Their median height was `lineup.rows[0].median_peak_height` 2.8273, `lineup.rows[1].median_peak_height` 5.0284, `lineup.rows[2].median_peak_height` 7.3767 and `lineup.rows[3].median_peak_height` 9.715, against logarithms of the cutoff `lineup.rows[0].logN` 4.6052, `lineup.rows[1].logN` 6.9078, `lineup.rows[2].logN` 9.2103 and `lineup.rows[3].logN` 11.5129. The median of the sum over the whole scan stayed level: `lineup.rows[0].background_median` 1.6199, `lineup.rows[1].background_median` 1.7477, `lineup.rows[2].background_median` 1.566, `lineup.rows[3].background_median` 1.4125.

Tall maxima away from every zero on file, further than `lineup.near` 0.5: `lineup.rows[0].stray_against_all_zeros` 7 at the smallest cutoff, `lineup.rows[1].stray_against_all_zeros` 1, then `lineup.rows[2].stray_against_all_zeros` 0 and `lineup.rows[3].stray_against_all_zeros` 0. Counted against the zeros of the inner window alone the last rows show `lineup.rows[2].stray_tall_maxima` 1 and `lineup.rows[3].stray_tall_maxima` 1; that maximum sits at a zero near the edge of the scan.

**What it is.** A measurement of the direction the tree does not prove: from the steps to the zeros. On this range the turned steps cancel at a general height and add up at the heights of the zeros, the peak rising about as fast as the logarithm of the cutoff while the level between peaks stays put. Every step up to the cutoff enters each peak. The mathematics expects this: the sum is a truncation of the logarithmic derivative of zeta, which has a pole at each zero.

**What it is not.** It reads heights only; the square-root weight was put in by hand, so the run says nothing about the real parts. The range is the first zeros and four cutoffs. It is not a theorem and it does not test the Riemann hypothesis.
