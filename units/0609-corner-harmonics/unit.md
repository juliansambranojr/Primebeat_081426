---
id: 0609
date: 2026-11-27
type: measurement
title: Julian's harmonics posit: does depth select the zeros near the odd harmonics of pi/log 2 in the deep corner
refs: [lean/EdgeDiagonal.lean::edge_eq_fwdDiff, lean/OfflineGain.lean::offline_gain_pow_le]
supersedes: []
follows: 0608
sealed: false
---

**Question.** Julian's posit: the prime beat starts from the first primes, and the deep corner is its harmonics. Depth multiplies each zero ρ = 1/2 + iγ by the size of 2^ρ − 1, which is largest where γ times the logarithm of two is an odd multiple of π. Does depth select those zeros in the corner of the true table?

**What ran.** `run/harm.py`, by `run/run.sh`, through `lab run`. The corner is unit 0597's (corner-from-zeros): rows twelve to ninety-two, cells with twice the row below seven times the depth, `harm.cells` 2962 cells. Each row is Riemann's R less the explicit formula's term from each of the first `harm.zeros` 2000 zeros; the table is linear, so each zero's share of each cell is computed on its own. A zero is near a harmonic when the cosine of γ log 2 is negative, closer to an odd multiple of π than to an even one: `harm.near_zeros` 1106 zeros near, `harm.far_zeros` 894 far.

**Check one: the near zeros alone.** The smooth part alone gets the sign of `harm.check1_smooth_only.sign_agree` 2071 cells. All the zeros get `harm.check1_all.sign_agree` 2921, median relative error `harm.check1_all.median_rel_err` 0.077. The near zeros alone get `harm.check1_near.sign_agree` 2920, median error `harm.check1_near.median_rel_err` 0.0769: the same as all of them. The far zeros alone get `harm.check1_far.sign_agree` 1806, fewer than the smooth part with no zeros at all.

**Check two: which zeros carry the corner.** Across all `harm.zeros` 2000 zeros, a zero's average share of the corner cells ranks with its depth factor at `harm.check2.d10_19.rho_vs_factor` 0.973 for depths ten to nineteen, `harm.check2.d30_49.rho_vs_factor` 0.99 for thirty to forty-nine and `harm.check2.d50_91.rho_vs_factor` 0.986 for fifty and up, against `harm.check2.d10_19.rho_vs_inv_height` 0.187, `harm.check2.d30_49.rho_vs_inv_height` 0.119 and `harm.check2.d50_91.rho_vs_inv_height` 0.109 with the zero's size. The factor raised to the depth, over the height, ranks at `harm.check2.d10_19.rho_vs_factor_pow_d_over_height` 0.997 and `harm.check2.d30_49.rho_vs_factor_pow_d_over_height` 0.998. The largest contributors are the zeros at `harm.check2.d30_49.top5_gamma[0]` 14.135, `harm.check2.d30_49.top5_gamma[1]` 40.919, `harm.check2.d30_49.top5_gamma[2]` 49.774, `harm.check2.d30_49.top5_gamma[3]` 77.145 and `harm.check2.d30_49.top5_gamma[4]` 59.347, with factors `harm.check2.d30_49.top5_factor[0]` 2.374, `harm.check2.d30_49.top5_factor[1]` 2.412, `harm.check2.d30_49.top5_factor[2]` 2.413, `harm.check2.d30_49.top5_factor[3]` 2.413 and `harm.check2.d30_49.top5_factor[4]` 2.389, against the largest possible `harm.factor_max` 2.4142. Each sits next to an odd multiple of π over log 2: the third, ninth, eleventh, seventeenth and thirteenth. The second zero, far from a harmonic, has factor `harm.factor_gamma2` 2.0469.

**Check three: does the first zero lead alone.** No. The first zero's share exceeds everything else in the cell in `harm.check3.lead_share_all` 0.454 of the corner cells: `harm.check3.lead_share_by_band.d10_19` 0.653 at depths ten to nineteen, `harm.check3.lead_share_by_band.d50_91` 0.257 at fifty and up. No depth in the corner is led by it in every cell. Deeper, the zero at `harm.largest_total_contributor.gamma` 40.919, factor `harm.largest_total_contributor.factor` 2.412, closer to its harmonic, overtakes it.

**What it shows.** The posit holds in the form of a family: the deep corner is carried by the zeros near the odd harmonics of π over log 2, and those zeros alone rebuild it as well as all of them do. It fails in the form of one leader: no single zero leads the corner, and the leaders change with depth in the order of their nearness to a harmonic. Exploratory; no outcome marked.
