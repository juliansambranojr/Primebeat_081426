# Prereg — is unit 0642's edge excess real? A frozen-phase null (v1)

STATUS: DRAFT, written 2026-11-28 by the cloud session on Julian's answer to corner question 8 ("A and b",
relayed by the Mac session; (a) for question 8). Not locked: no sidecar exists. Julian locks it; the text is
committed before `O102_edge_excess_frozen_phase.py` runs.

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
| script | `O102_edge_excess_frozen_phase.py`, no flags, sha256 (fill at lock) |

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

(fill from `results/O102_edge_excess_frozen_phase_power.json` before the lock)

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

- `lock_written_at`: (fill at lock)
- `pre_compute_sha256`: in the sidecar `preregs/edge_excess_frozen_phase_v1_20261128.sha256` (written at lock)
- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `post_compute_sha256`: (fill after run; must equal pre-compute)
- `locked_by`: (Julian's word, when given)

## Run record

Appended after the run. This append changes the file's hash; the no-drift check is that `post_compute_sha256`
below, taken before this section existed, equals the sidecar.
