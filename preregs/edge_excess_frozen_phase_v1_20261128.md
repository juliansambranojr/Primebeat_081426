# Prereg — is unit 0642's edge excess real? A frozen-phase null (v1)

STATUS: LOCKED on Julian's word, 2026-11-28 ("Ok can we do the other two tests while we wait?", to the options
"run O102 as it stands" and "add a correction to unit 0642"). Drafted on his answer to corner question 8 ("A and
b", relayed by the Mac session; (a) for question 8). The text is committed before
`O102_edge_excess_frozen_phase.py` runs.

## Background

Unit 0642 (corner-edge-excess) found about a third more cells near zero on the corner's edges than benchmark 1,
which gives each cell its own independent phases. The power study of `preregs/edge_excess_correlation_v1_20261128.md`
showed that one table's count spreads far more than that benchmark allows: in a real table one zero's phase is
shared by every cell it touches. This test asks whether 0642's excess stands against the right spread.

## Primary hypothesis

- H1 (`excess_real`): the observed count over the twelve edges is above what the same zeros give when each zero is
  turned by one random phase shared by all its cells.
- H0 (`consistent_with_chance`): the observed count lies inside that spread.

Predicted direction under H1: above.

## Provenance disclosure (required reading)

- The observed count is known: unit 0642 reports it at 100000 zeros, edge by edge (the sum over the twelve edges at
  a twentieth is this test's integrity reference). The observed arm is **not blind**.
- The null, the frozen-phase draws of the true zeros, has never been computed before this lock; the power study
  uses synthetic heights only. The null arm is blind.
- The rule and the parameters were written before the power study ran.

## Locked parameters

| parameter | value |
|---|---|
| zeros | `imported/odlyzko/zeros6`, sha256 `2ef7b752c2f17405222e670a61098250c8e4e09047f823f41e2b41a7b378e7c6`; first `K = 100000` |
| cells | unit 0642's (`O101_edge_correlation.geometry`): twelve edges `row = depth + q`, `q ∈ {1,2,3,4,6,8,12,16,24,32,48,64}`, depths 17–600; two rays `row = 2d, 3d`, depths 17–420; all inside `Capstone.OpenCorner`; 7080 cells |
| cell value | each zero's complex explicit-formula term in each cell, as in 0642's engine; the cell is the real part of their sum |
| null | 1000 draws; in each, every zero's term in every cell is multiplied by `e^{iθ_k}`, one `θ_k` per zero, independent and uniform on `[0, 2π)`; `numpy.default_rng(20261131)`; terms held in complex64 |
| statistic | count over the twelve edges of cells below `t = 0.05` of their root-square size (the size is unchanged by the phases) |
| script | `O102_edge_excess_frozen_phase.py`, no flags, sha256 `533b82a75c523ab53dae176d6399d414d8c17234ef82847c1e5e40dd9a22a7e9` (imports `O101_edge_correlation.py`, sha256 `2562599814819bb253bf88a76fb6f1138ac481ef204b80ea3896a5ed44d75a42`, for the cells and the engine) |

## Null and p-value

`p = (1 + #{null counts ≥ observed}) / (1 + 1000)`, one-sided.

## Decision rule (locked before data)

- `compromised` — the zeros file's sha256 is not the locked value; or the observed count over the twelve edges
  at `t = 0.05`, summed in float64 as the terms are made, differs from the sum of unit 0642's `observed_K100000`
  counts on those edges; or the draw with every `θ_k = 0`, through the complex64 terms, differs from the observed
  count by more than two cells. The run executed and the data is corrupt for reasons unrelated to the hypothesis;
  no verdict.
- `excess_real` — `p ≤ 0.01`.
- `consistent_with_chance` — `p ≥ 0.10`.
- `ambiguous` — anything else.

Precedence: `compromised` > `excess_real` > `consistent_with_chance` > `ambiguous`.

## Power (computed before the lock, synthetic data only)

`O102_edge_excess_frozen_phase_power.py`, output `results/O102_edge_excess_frozen_phase_power.json` (sha256
`651a779e3af2f90a05737b54c5d6b4163b1fd3a04ca450db8fec490a5f98b35e`). It reads no zero: 20 GUE sets of 10000
heights (O101's generator, seed 7101), each against 200 frozen-phase draws of its own terms (seed 7102).

| synthetic truth | `excess_real` | `consistent_with_chance` | `ambiguous` |
|---|---|---|---|
| a GUE set, its own phases | 0.0 | 0.9 | 0.1 |
| the same, count raised a third | 0.0 | 0.65 | 0.35 |
| the same, count raised two thirds | 0.2 | 0.55 | 0.25 |

One table's count under shared random phases spreads with sd 0.382 of its mean (median over the sets). The rule
does not fire `excess_real` without cause, and it cannot see an excess of a third: 0642's observed excess is
about that size. So `consistent_with_chance` here would say the excess lies inside what one table's phases give,
which is the question; it would not say there is no excess. `excess_real` can fire only if the true zeros' spread
is much narrower than the synthetic sets' or the observed count lies far above it. Julian locks it knowing this.

**Designs tried to narrow the spread** (Julian, 2026-11-28: "Try your idea"; synthetic GUE heights only, 20 sets,
200 draws each, `analysis/2026-11-28/o102_designs/`): the median sd over mean of the null and the rule's rate of
`excess_real` with the count raised a third were 0.435 and 0.05 for this design; 0.379 and 0.1 pooling the three
thresholds and all fourteen diagonals; 0.429 and 0.05 keeping the first 10 zeros' phases fixed; 0.416 and 0.1
keeping the first 50 fixed. None narrows the spread enough to see an excess of a third: one table's near-zero
count spreads by about four tenths of itself whichever way it is pooled or conditioned.

## Pre-specified secondary analyses

The same comparison at `t = 0.02` and `t = 0.1`, and edge by edge and ray by ray at `t = 0.05`. Reported, no
verdict.

## Falsification

`consistent_with_chance` says the edge excess of unit 0642 is what one table of these zeros gives by the luck of
its phases: the benchmark 0642 used was too narrow, and the excess needs no explanation. `excess_real` says the
true zeros' phases put more edge cells near zero than shared random phases do, so something in their arrangement
(their correlations, or their arithmetic) is at work, which a later test would have to name. Neither tests zeros
above 100000, other cells, or other thresholds as primary.

## Compute

Minutes: the terms of 100000 zeros in 7080 cells (about 6 GB in complex64), then 1000 matrix-vector draws.

## Reproducibility

Deterministic, no flags, seed as locked. Output `results/O102_edge_excess_frozen_phase.json` by `guarded_write`.

## Lock chain

- `lock_written_at`: 2026-11-28T18:01:47Z
- `pre_compute_sha256`: in the sidecar `preregs/edge_excess_frozen_phase_v1_20261128.sha256` (written at lock)
- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `post_compute_sha256`: (fill after run; must equal pre-compute)
- `locked_by`: claude-on-julian-authorization ("Ok can we do the other two tests while we wait?", 2026-11-28)

## Run record

Appended after the run. This append changes the file's hash; the no-drift check is that `post_compute_sha256`
below, taken before this section existed, equals the sidecar.

- `run_start_at`: 2026-11-28T18:02:07Z
- `run_end_at`: 2026-11-28T18:06:42Z
- `post_compute_sha256`: 657c17acb055a008dea782b1a74788f9027b8dc3d523f6aeaf4a2f4da8fa9ec4
- sidecar `edge_excess_frozen_phase_v1_20261128.sha256`: 657c17acb055a008dea782b1a74788f9027b8dc3d523f6aeaf4a2f4da8fa9ec4 — match
- integrity: `zeros_sha_ok` true; observed count 313 equals the sum of unit 0642's `observed_K100000` counts, 313; the zero-phase draw through the complex64 terms gives 313; `integrity_ok` true
- primary (twelve edges, `t = 0.05`): observed 313; null mean 239.87, sd 97.35, 5th–95th percentile 117–429; `p` = 0.1878121878121878
- secondary: `t = 0.02` observed 123, null mean 94.85, `p` = 0.18681318681318682; `t = 0.1` observed 616, null mean 481.51, `p` = 0.19480519480519481; per diagonal at `t = 0.05` every `p` between 0.118 and 0.627
- mechanical output of the decision rule: `consistent_with_chance`
- output: `results/O102_edge_excess_frozen_phase.json`
- `verdict`: (Julian's to write)
