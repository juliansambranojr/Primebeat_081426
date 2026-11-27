---
id: 0615
date: 2026-11-27
type: measurement
title: When the near-harmonic zeros line up: their slow phases, and the beat between the leader and the runner-up
refs: [lean/EdgeDiagonal.lean::edge_eq_fwdDiff]
supersedes: []
follows: 0614
sealed: false
---

**Question.** The leader's real losses come from the near-harmonic zeros lining up (unit 0614, real-loss-remainder). How do they line up? A zero near an odd harmonic turns by about π per row plus a small drift, its offset from the harmonic; two such zeros should drift against each other at the difference of their offsets, a beat.

**What ran.** `run/align.py`, by `run/run.sh`, through `lab run`, on unit 0597's corner of the true table, `align.cells` 2962 cells with `align.real_losses` 708 real losses, first two thousand zeros, the comb's leader and runner-up (unit 0610, corner-zoom). The family's coherence is the size of the sum of the near-harmonic zeros' complex terms over the sum of their sizes, the leader left out. The drift is measured along the rows of the table at depth fifty.

**The family is more coherent in the real losses.** Its coherence has median `align.coherence_median.real` 0.145 in the real losses and `align.coherence_median.elsewhere` 0.073 elsewhere: twice as much in phase.

**The runner-up opposes the leader in the real losses.** The cosine of the difference of their phases has median `align.lead_second_cos_median.real` -0.154 in the real losses and `align.lead_second_cos_median.elsewhere` 0.091 elsewhere; the two point the same way in `align.lead_second_aligned_share.real` 0.442 of the real losses and `align.lead_second_aligned_share.elsewhere` 0.531 of the other cells.

**The phases beat exactly.** The offsets from the nearest odd harmonic are `align.delta_first_harmonic_zeros.14.135` 0.3727 for the zero at fourteen, `align.delta_first_harmonic_zeros.40.919` 0.0884 at forty, `align.delta_first_harmonic_zeros.49.774` -0.0569 at forty-nine, `align.delta_first_harmonic_zeros.59.347` 0.2955 at fifty-nine and `align.delta_first_harmonic_zeros.77.145` 0.0657 at seventy-seven. Along the rows at depth fifty, the phase difference of the zeros at fourteen and forty drifts `align.drift_depth50.14.135_vs_40.919.measured_per_row` 0.2859 per row against the predicted `align.drift_depth50.14.135_vs_40.919.predicted_per_row` 0.2843, a beat every `align.drift_depth50.14.135_vs_40.919.beat_period_rows` 22.1 rows, scatter `align.drift_depth50.14.135_vs_40.919.residual_sd` 0.0047; the zeros at forty and forty-nine `align.drift_depth50.40.919_vs_49.774.measured_per_row` 0.1461 against `align.drift_depth50.40.919_vs_49.774.predicted_per_row` 0.1453, a beat every `align.drift_depth50.40.919_vs_49.774.beat_period_rows` 43.2 rows; fourteen and forty-nine `align.drift_depth50.14.135_vs_49.774.measured_per_row` 0.4321 against `align.drift_depth50.14.135_vs_49.774.predicted_per_row` 0.4296, every `align.drift_depth50.14.135_vs_49.774.beat_period_rows` 14.6 rows.

**What it shows.** The near-harmonic zeros keep phases that drift at their offsets from the harmonics, so their alignment is a beat with known periods, and the leader's real losses fall where the beat brings the runner-up and the family against it. A corner cell is then the leader plus a sum of terms whose phases are known linear functions of the row and depth: an almost-periodic function of the row, with frequencies the offsets of the near-harmonic zeros. It is Julian's beat again, one level up, among the zeros. Exploratory; no outcome marked.
