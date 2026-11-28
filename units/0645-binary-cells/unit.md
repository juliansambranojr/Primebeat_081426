---
id: 0645
date: 2026-11-28
type: measurement
title: The cells in binary: trailing zero bits against random low bits, and the locked test at power-of-two depths
refs: [lean/ParityCell.lean::prime_dvd_cell_prime_pow]
supersedes: []
follows: 0644
sealed: false
---

**Question.** Julian: what if the structure is in the zeros and in what is inside the cells as integers in binary? A cell is zero exactly when every power of two divides it, so its trailing zero bits measure how close it comes to zero in binary.

**What ran.** Two things. First the look, `run/bits.py`, by `run/run.sh` through `lab run` (the same code as `analysis/2026-11-28/two_adic_look/`): the `bits.cells` 2211 cells with rows to ninety-two whose rows all have at least twenty-one bits, against two hundred tables whose rows' low twenty bits are random. Then the locked test it led to, `preregs/two_adic_power_depths_v1_20261128.md`, run by `O100_two_adic_depths.py` with its power study `O100_two_adic_power.py`; their outputs are copied into `run/` as produced.

**The look.** Trailing zeros fall off like a fair coin: `bits.hist_real.0` 1123 cells with none against `bits.hist_null_mean.0` 1105.0 for the random tables, `bits.hist_real.1` 558 with one against `bits.hist_null_mean.1` 553.2, `bits.hist_real.2` 268 with two against `bits.hist_null_mean.2` 276.8; at ten or more, `bits.v2_ge_10.real` 4 against `bits.v2_ge_10.null_mean` 2.1. The low four bits are uniform, chi-square `bits.mod16_chi2` 13.3 on fifteen degrees, and the middle bits are ones `bits.middle_bits_ones` 0.4982 of the time. Over `bits.per_depth_z.depths` 66 depths the per-depth deviation has root-square `bits.per_depth_z.rms` 1.06, what chance gives. The three depths furthest above the random tables were depth `bits.per_depth_top3[2].d` 64 (`bits.per_depth_top3[2].z` 2.64, `bits.per_depth_top3[2].cells` 3 cells), `bits.per_depth_top3[1].d` 52 and `bits.per_depth_top3[0].d` 32 (`bits.per_depth_top3[0].z` 2.2): two powers of two, the depths where unit 0600 found a cell congruent to two rows modulo two. That suggested the test.

**The locked test.** Depths one, two, four, eight and sixteen, kept apart from the depths that suggested it. The true cells there carry `O100_two_adic_depths.summary.T.primary` 0.9342105263157895 trailing zeros on average against `O100_two_adic_depths.summary.null_mean.primary` 0.999014802631579 for ten thousand random tables, p `O100_two_adic_depths.summary.p.primary` 0.7922207779222078; the placebo depths `O100_two_adic_depths.summary.p.placebo` 0.39346065393460655. The decision rule's mechanical output is `no_excess`; the verdict line in the prereg is Julian's. The power study had shown the rule catches a shift of three tenths of a trailing zero per cell `O100_two_adic_power.summary.rule_rates.primary q=0.3.excess` 0.876 of the time. Depths thirty-two and sixty-four pooled, the hypothesis-generating cells, give p `O100_two_adic_depths.summary.p.secondary` 0.0122987701229877, which cannot count as evidence for the idea it produced.

**What it shows.** In binary the cells look like random integers at every scale measured, and at the power-of-two depths below thirty-two they carry no extra trailing zeros, by as much as three tenths per cell. The four zeros' neighbours are mostly odd. Exploratory, apart from the locked test, whose verdict is Julian's.
