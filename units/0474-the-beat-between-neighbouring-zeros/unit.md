---
id: 0474
date: 2026-11-23
type: run
title: From one zero's residual to the next: the residuals beat at the distance between neighbouring zeros; EXPLORATORY
refs: [lean_stage3/Stage3/CountModes.lean::piMode_doubling, lean_stage3/Stage3/LadderMean.lean::mean_extract]
supersedes: []
follows: 0473
context: unit 0472 found the steps of the staircase lining up at the zeros with small residuals in place; Julian asked on 2026-11-23 to measure the residual of a zero against the residual of the next, for each of the twelve
sealed: false
---

**Question.** Is the residual at a zero its own, or does it belong with the residual at the next zero?

**What ran.** `run/beat.py`, through `run/run.sh`. EXPLORATORY: no prereg, no decision rule, no verdict. The sum is that of unit 0472: the steps of the staircase up to a cutoff, each turned by a trial height and weighed, added. For each of the `beat.zeros_used` 12 zeros and each of `beat.cutoffs` 48 cutoffs from `beat.cutoff_lo` 1000 to `beat.cutoff_hi` 3000000, the residual is the place of the sum's peak near the zero less the zero's height, the heights taken from the bench's file. The residuals are followed as the logarithm of the cutoff grows, over a span of `beat.span_logN` 8.006, which resolves turning rates to about `beat.frequency_resolution` 0.785.

**Each residual turns at the distance to the closer neighbour.** For each zero the single turning rate that accounts for most of its residual's movement was found. The lowest zero's residual turns at `beat.zeros[0].turning_rate` 6.9; its neighbour is `beat.zeros[0].gap_above` 6.8873 away. The second: `beat.zeros[1].turning_rate` 3.99 against `beat.zeros[1].gap_above` 3.9888. The fourth: `beat.zeros[3].turning_rate` 2.54 against `beat.zeros[3].gap_above` 2.5102. The eighth: `beat.zeros[7].turning_rate` 2.4 against `beat.zeros[7].gap_below` 2.4084. The ninth, half of the closest pair: `beat.zeros[8].turning_rate` 1.66 against `beat.zeros[8].gap_above` 1.7687. Across the twelve, the rate and the distance to the closer neighbour correlate at `beat.corr_rate_with_closer_gap` 0.984; the median difference between them is `beat.median_abs_rate_minus_gap` 0.049, and `beat.rates_within_resolution` 11 of the twelve are within the resolution. In all `beat.matched_gap_is_closer_neighbour` 12 the distance nearest the rate was the distance to the closer of the two neighbours. The one outside the resolution is the last zero, at the edge of the range, with `beat.zeros[11].turning_rate` 2.65 against `beat.zeros[11].gap_below` 3.4759.

**Neighbouring residuals move against each other.** Over the cutoffs, the residuals of two neighbouring zeros were correlated negatively in `beat.pairs_negative` 11 of `beat.pairs_total` 11 pairs, with mean `beat.mean_pair_correlation` -0.466. The closest pairs most: `beat.pairs[3].correlation` -0.946 at a distance of `beat.pairs[3].gap` 2.5102, `beat.pairs[8].correlation` -0.872 at `beat.pairs[8].gap` 1.7687, `beat.pairs[1].correlation` -0.8 at `beat.pairs[1].gap` 3.9888. Zeros three or more places apart: mean `beat.mean_far_correlation` -0.0.

**They nearly cancel.** At a typical cutoff the twelve residuals add, with their signs, to `beat.median_abs_signed_sum` 0.00535, while their sizes add to `beat.median_sum_of_sizes` 0.08348; the median of the ratio is `beat.median_ratio_signed_to_sizes` 0.073.

**What it is.** The residual at a zero is one end of something shared with the next zero. As steps are added, a zero's peak sways about its height, and it sways at a rate equal to the distance to its closer neighbour; the neighbour sways the opposite way; taken together the sways cancel. It is a beat between the two. The closer the pair, the larger the sway: the closest pair, `beat.closest_pair_gap` 1.7687 apart, has the largest residuals, `beat.zeros[8].rms_residual` 0.02852 and `beat.zeros[9].rms_residual` 0.03055, against `beat.zeros[0].rms_residual` 0.00379 for the lowest zero, whose neighbour is far.

The mathematics expects it: near one zero the truncated sum is that zero's own term plus its neighbours' terms, and a neighbour's term turns, as the cutoff grows, by the difference of the two heights times the logarithm of the cutoff.

**What it is not.** The heights are read from the file; the run measures the peaks against them and does not find the zeros unaided. Twelve zeros, one weight, cutoffs to three million. The pair correlations are strong for close pairs and weak for some distant ones, down to `beat.pairs[5].correlation` -0.037. No test of the Riemann hypothesis is made.
