# Prereg — the induction bump as a difference table across doublings (v1)

STATUS: **LOCKED**

## Background

Olsson et al. 2022 report one bump in an otherwise smooth loss curve,
the only place the loss is not convex, and tie it to induction heads
forming. Julian's posit (session 2026-09-07, after unit 0354): the
smooth curve is an analytic overlay; underneath it the training
dynamics are discrete blocks of arithmetic, and the dyadic difference
table of the loss, `cell(r, 0) = L(2^r)`, `cell(r, d+1) = cell(r, d) −
cell(r−1, d)`, the bench's own construction, is where that arithmetic
is read. A curve that is only an overlay, a slowly varying function
plus SGD noise, has a table whose fine structure is noise: it differs
from seed to seed. Dynamics that are the same in every run put the
same fine structure in every seed's table.

This prereg tests reproducibility of the table's fine structure
across seeds, on the plateau between the two transitions of a small
attention-only model, with the one-layer model (which never forms
induction heads) as the control. It does not fit a curve. It does
not test what the structure means.

## Primary hypothesis

H0 (overlay only): on the plateau, the sign of a depth-`d` cell that
departs from the completely-monotone sign `(−1)^d` is seed noise. The
number of cells where all `S` seeds depart together is what
independent seeds give, and it is no larger for two layers than for
one.

H1 (the posit): the fine structure is shared across seeds. The
two-layer runs show unanimous departures on the plateau in excess of
the one-layer runs.

Predicted direction under H1: excess positive, at depths 3 and 4 as
well as 1 and 2.

## Provenance disclosure

Seed 0 has been run and inspected: two layers at 2048, 16384 and
32768 steps (the last two with the locked width and learning rate),
one layer at 32768 steps. Those runs set the step count, the width,
the learning rate and the plateau rows, and they set the power's
noise scale. Their files live outside the tree
(the session scratchpad) and are not inputs to the rule.

Seeds 1 to 6 have never been run, for either layer count. They are
the blind arm; the rule meets them out of sample.

## Locked parameters

| parameter | locked value | why this value |
|---|---|---|
| script | `analysis/2026-09-07/induction_bump_train.py` | writes every step's loss |
| analyzer | `analysis/2026-09-07/induction_bump_table.py` | the table and the rule |
| `layers` | **2** (test) and **1** (control) | Olsson et al.: two layers form induction heads, one cannot |
| `seeds` | **1, 2, 3, 4, 5, 6** | never run; `S = 6` |
| `steps` | **32768** | seed 0 formed induction near step 9700, bump row 14; `2^15` leaves a row after it and a five-row plateau before it |
| `R` | **15** | rows 0..15 of the table |
| `d`, `heads` | **64**, **4** | seed 0 at `d = 128`, `lr = 3e-3` never formed induction in 16384 steps |
| `V`, `T`, `K`, `zipf_s` | **256**, **128**, **32**, **1.0** | script defaults, unchanged |
| `batch`, `eval_n` | **64**, **128** | script defaults; the eval batch is fixed per seed |
| `lr`, `warmup`, `weight_decay` | **1e-3**, **100**, **0** | script defaults, unchanged |
| device, threads | **cpu**, **8** | deterministic algorithms on; no MPS |
| `plateau_lo` | **8** | seed 0's unigram transition ends by row 7 |
| `plateau_gap` | **2** | rows up to `r* − 2`, `r*` the median two-layer bump row |
| `dmax_rule` | **4** | depths 1..4 enter the count |
| `excess_fire` | **2** | two-layer minus one-layer unanimous anomalies |
| `excess_null` | **0** | |
| bump row `r*` | first row with copied-position loss under half its step-1 value | the analyzer's `bump_row` |

## Primary statistic

For each layer count, over the plateau rows `P = {8, …, r* − 2}` and
depths `d = 1..4`, `N` = the number of cells where every one of the
`S` seeds has `sign(cell(r, d)) = −(−1)^d`. The statistic is
`excess = N(two layers) − N(one layer)`.

## Null and power

Independent seeds and a symmetric departure make a unanimous
anomaly a `2^(−S)` event per cell, `1/64` at `S = 6`. Power was
computed before the lock on synthetic curves
(`induction_bump_table.py --power`, 200 trials per amplitude): the
overlay is two smooth steps in `log2(step)` at seed 0's fitted shape,
the noise is iid at `0.003` nats (seed 0's plateau residual scale),
and the alternative adds one fixed dyadic pattern shared by every
two-layer seed at `k` times that scale.

| shared pattern amplitude | `structure_beyond_overlay` | `overlay_only` | `ambiguous` |
|---|---|---|---|
| 0 (null) | 0 / 200 | 192 / 200 | 8 / 200 |
| 0.5 × noise | 31 / 200 | 145 / 200 | 24 / 200 |
| 1 × noise | 129 / 200 | 34 / 200 | 37 / 200 |
| 2 × noise | 200 / 200 | 0 | 0 |

The rule fires in both directions: never under the null in 200
trials, in two of three trials at a shared pattern the size of the
noise, always at twice it.

## Decision rule (locked before data)

Verdict labels verbatim.

- `compromised` — any of the twelve runs missing, non-finite, or
  ending before step 32768; the copied-position loss fails to fall
  under half its step-1 value by step 32768 in any two-layer seed
  (the phenomenon did not occur, which says nothing about the
  posit); the plateau `P` has fewer than two rows; or the analyzer
  rerun on the committed JSONs disagrees with the frozen output.
- `structure_beyond_overlay` — `excess ≥ 2`.
- `overlay_only` — `excess ≤ 0`.
- `ambiguous` — `excess = 1`.

Precedence: `compromised` > `structure_beyond_overlay` >
`overlay_only` > `ambiguous`.

## Pre-specified secondary analyses

Reported always; cannot change the verdict.

1. `N_d` per depth for both layer counts, with the cells.
2. The same count at depths 5 and 6.
3. The unanimous-anomaly count over all rows, transitions included
   (`A_d` in the analyzer), both layer counts.
4. The fit-based residual unanimity `U_d` against the two-step
   overlay, both layer counts: what a smooth family leaves.
5. The bump row per seed, and the twelve raw tables to depth 6.

## Falsification and reading

H0 is falsified by `structure_beyond_overlay`. `overlay_only` does
not confirm H0 beyond this resolution, six seeds and rows 8 to
`r* − 2`. A firing at depths 1 and 2 only is consistent with a
smooth shared precursor of the bump and is reported as such; the
posit's distinctive prediction is the count at depths 3 and 4, listed
in secondary 1.

## Vacuousness check

Seed 0 at 32768 steps: the two-layer run has bump row 14, so `P` is
rows 8 to 12, twenty cells at depths 1 to 4, of which 8 are anomalies;
the one-layer run has no bump, its copied-position loss creeping from
4.30 to 4.15 with no transition, and 8 anomalies on the same cells,
six of them the same cells as the two-layer run. One seed cannot show
unanimity, and the two runs share their data order, which is what the
same-seed control is for. The rule can fire either way.

## What is varied / held fixed

Varied: the seed and the layer count. Held fixed: everything in the
table. Neither script is modified after the lock.

## Compute

Twelve runs on the CPU, two at a time: seed 0 took 997 s for two
layers and 639 s for one with both running, so about 1.5 hours. Artifacts about 1 MB each under
`analysis/2026-09-07/results/`, through the results guard.

## Reproducibility

`torch 2.14.0`, `torch.use_deterministic_algorithms(True)`, CPU,
`torch.manual_seed(seed)` and `numpy.random.default_rng(seed)`, the
eval batch from `default_rng(10000 + seed)`. A rerun at the locked
parameters reproduces the losses to the last digit on the same
machine; across machines the trailing digits may move, which is why
the compromised branch reads the analyzer's rerun on the committed
JSONs and never a retraining.

## Lock chain

- `lock_written_at`: 2026-09-07T17:50:40Z
- `pre_compute_sha256`: PENDING (the sidecar holds it)
- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `post_compute_sha256`: (fill after run; must equal pre-compute)
- `locked_by`: claude-on-julian-authorization ("Lock", 2026-09-07)

## Run record

Appended after the run. The no-drift check is that `post_compute_sha256`
below equals the sidecar, both taken of the text before this section
existed.

- `run_start_at`: 2026-09-07T17:51:46Z
- `run_end_at`: 2026-09-07T19:31:50Z
- `verdict`: `overlay_only` (Julian, 2026-09-07)
- mechanical output of the decision rule: `overlay_only`, `excess = −1`
  (`N(two layers) = 2`, `N(one layer) = 3`, plateau rows 8–12, bump row
  14 in all six two-layer seeds, no bump in any one-layer seed)
- `post_compute_sha256`: `d00b103f539908deff2db2a5060c867d325a96f36af6da6302be7beae3adb19a`
- sidecar match: **yes**, identical to the sidecar written at the lock, so
  no parameter, hypothesis or rule text moved between lock and compute.
- `compromised` checks: twelve runs complete to step 32768, all finite;
  copied-position loss under half its step-1 value in every two-layer
  seed; plateau of five rows; the analyzer rerun on the committed JSONs
  reproduces the mechanical output and every table.
- analyzer: `analysis/2026-09-07/induction_bump_table.py`, one run at
  locked defaults; power rerun into `induction_bump_power.json`
- results: unit `units/0355-induction-bump-difference-table/`, its
  `run/induction_bump_table.json`, `run/induction_bump_power.json`,
  `run/summary.json` and the twelve raw curves
  `run/raw/induction_bump_L{1,2}_seed{1..6}.json.gz` (the results trees
  are frozen since the `lab` units; the pre-commit refused the path the
  Compute section names, so the artifacts live in the unit, gzipped
  because `lab values` flattens every list element of a `*.json`)
- secondary 1, the unanimous anomalies per depth on the plateau:
  two layers `{1: 0, 2: 1, 3: 0, 4: 1}` at cells (12, 2) and (8, 4);
  one layer `{1: 0, 2: 0, 3: 1, 4: 2}` at (8, 3), (8, 4), (9, 4).
  The cell (12, 2) is a negative second difference at row 12 in every
  two-layer seed and in no one-layer seed: the loss is concave at the
  doubling before the bump, in all six runs. Depths 3 and 4 show no
  two-layer excess.
- secondary 4, fit-based residual unanimity `U_d`, depths 1–6: two
  layers `10, 9, 7, 6, 6, 6`; one layer `9, 8, 7, 6, 6, 6`. The smooth
  family's misfit is shared across seeds in both, as expected of a fit.
