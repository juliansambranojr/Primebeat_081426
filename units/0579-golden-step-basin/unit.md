---
id: 0579
date: 2026-11-26
type: run
title: "The golden step from the first zero, under a locked prereg: the next zeros' places in their basins do not fall out (mechanical output does_not_fall_out)"
refs: [none]
supersedes: []
follows: 0578
context: Julian asked that the golden step, run from one zeta zero, give the next ones; the test was written as a prereg, locked on his word and committed before the run
sealed: false
---

**Question.** Started from the first zero's place in its basin, does the golden step give the places of the next zeros up to the point run's height?

**What ran.** `run/O98_golden_step_basin.py`, under the locked prereg `preregs/golden_step_basin_v1_20261126.md`, whose sidecar verifies with the run record stripped. The place of a zero is theta over pi taken mod one, so Gram points sit at zero. The score is the share of zeros two to two hundred and twenty-eight whose predicted place is within a tenth of the actual one, against `results.n_null` 100000 random orders of the same places. The power study, `run/O98_golden_step_power.py` on synthetic data only, ran before the lock. The scripts are the locked ones, rerun here through `lab run`; the outputs equal the locked run's files at the repo root in every field but the wall time.

**Power.** The rule fired on a planted golden sequence with noise of sd a twentieth in a share `power.planted_sigma_0.05.falls_out` 0.9725 of replicates, with noise of a tenth in `power.planted_sigma_0.1.falls_out` 0.6275, and on uniform places in `power.null_uniform.falls_out` 0.0.

**What it gave.** Integrity held, with the Gram-point error `results.gram_err` 1.5777218104420236e-30. The golden step scored `results.golden_S` 0.2026431718061674 at p `results.golden_p` 0.47733522664773353. The mirror step, scored as a secondary with no verdict, gave `results.mirror_S` 0.1894273127753304 at p `results.mirror_p` 0.6835731642683573. The decision rule's mechanical output is `does_not_fall_out`. The verdict line is Julian's, in the prereg.

**What it says.** One golden turn per zero, read as the place in the basin, lands on the next zeros no more often than chance. It does not test the packing under the flow of unit 0578, another place variable, or another step.

What remains. Julian's verdict line.
