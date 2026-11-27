---
id: 0610
date: 2026-11-27
type: measurement
title: The corner as one comb, zoomed: the width law, the record sequence of leaders, and base 3
refs: [lean/EdgeDiagonal.lean::edge_eq_fwdDiff]
supersedes: []
follows: 0609
sealed: false
---

**Question.** Julian's posit, the step after unit 0609 (corner-harmonics): the deep corner is a wider spread of primes than the shallow cells, so it is more harmonic, and the steps that make the harmonics are fractals of them. Each depth step multiplies a zero by the same factor, so the filter at depth d is the depth-one filter to the d-th power: one comb, zoomed. The tests below check what that predicts.

**What ran.** `run/zoom.py`, by `run/run.sh`, through `lab run`. Base two: unit 0597's corner, rows twelve to ninety-two with twice the row below seven times the depth. Base three: rows to forty-one, the cells where the oscillation outweighs the smooth part, `zoom.base3.cells` 232 of them. Each row is Riemann's R less each zero's explicit-formula term over the first two thousand zeros. A first run measured the distance to even multiples of π by a sign slip; it was corrected before this record.

**Test one: the comb narrows with depth.** At each depth, the zeros carrying the corner sit, weighted by their share, at a root-mean-square distance from an odd harmonic of π over log two of `zoom.width.rms_at.d10` 0.5712 at depth ten, `zoom.width.rms_at.d20` 0.4331 at twenty, `zoom.width.rms_at.d40` 0.3115 at forty and `zoom.width.rms_at.d80` 0.2342 at eighty (in units of γ log two). Against the logarithm of the depth, over `zoom.width.depths` 88 depths, the slope is `zoom.width.slope_loglog` -0.428, against the `zoom.width.predicted_slope` -0.5 a comb raised to the d-th power gives.

**Test two: the leaders are a record sequence.** Predicting the leader at each depth as the zero that maximises d times the logarithm of its factor less the logarithm of its height matches the zero that actually carries the most of the corner at `zoom.record.agree` 86 of `zoom.record.depths` 88 depths. The prediction switches from the zero at `zoom.record.predicted_leaders[0][1]` 14.135 to the one at `zoom.record.predicted_leaders[1][1]` 40.919 at depth `zoom.record.predicted_leaders[1][0]` 67; the data switch at `zoom.record.actual_leaders[3][0]` 68, with one depth, `zoom.record.actual_leaders[1][0]` 36, taken by the zero at `zoom.record.actual_leaders[1][1]` 49.774. Over `zoom.record_wide.zeros` 100000 zeros the predicted sequence runs on: `zoom.record_wide.leader.d10.gamma` 14.135 at depth ten, `zoom.record_wide.leader.d100.gamma` 40.919 at a hundred, `zoom.record_wide.leader.d1000.gamma` 49.774 at a thousand and `zoom.record_wide.leader.d10000.gamma` 276.452 at ten thousand, each closer to its harmonic: `zoom.record_wide.leader.d10.harmonic` 3.1186, `zoom.record_wide.leader.d100.harmonic` 9.0281, `zoom.record_wide.leader.d1000.harmonic` 10.9819 and `zoom.record_wide.leader.d10000.harmonic` 60.9952 times π over log two.

**Test three: base three has its own comb.** A zero's share of the base-three corner ranks with its base-three factor at `zoom.base3.rho_vs_factor3` 0.977 and with its base-two factor at `zoom.base3.rho_vs_factor2` -0.021. The smooth part alone gets `zoom.base3.sign_smooth` 122 signs; all the zeros get `zoom.base3.sign_all` 226; the zeros near the odd harmonics of π over log three alone get `zoom.base3.sign_near3` 226 and the zeros far from them `zoom.base3.sign_far3` 122. The zeros near the base-two harmonics get `zoom.base3.sign_near2` 202. The leaders are the zeros at `zoom.base3.top5_gamma[0]` 14.135, `zoom.base3.top5_gamma[1]` 77.145, `zoom.base3.top5_gamma[2]` 37.586, `zoom.base3.top5_gamma[3]` 43.327 and `zoom.base3.top5_gamma[4]` 94.651, at `zoom.base3.top5_harmonic3[0]` 4.943, `zoom.base3.top5_harmonic3[1]` 26.977, `zoom.base3.top5_harmonic3[2]` 13.144, `zoom.base3.top5_harmonic3[3]` 15.151 and `zoom.base3.top5_harmonic3[4]` 33.099 times π over log three.

**What it shows.** The corner behaves as one comb taken to the power of the depth: its teeth stay at the odd harmonics of π over log b and narrow at close to the predicted rate, its leaders follow the record sequence the comb predicts, and a different base has a different comb. Exploratory; no outcome marked.
