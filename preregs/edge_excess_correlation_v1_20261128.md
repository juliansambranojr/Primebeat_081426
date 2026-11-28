# Prereg — does the zeros' known correlation explain the edge excess? (v1)

STATUS: DRAFT (power study shows the rule vacuous; redesign pending), written 2026-11-28 by the cloud session on the box the Mac session relayed (Julian, 2026-11-28:
"Add a box", "Track and corner cloud to run"). Not locked: no sidecar exists. Julian locks it; the text is
committed before `O101_edge_correlation.py` runs.

## Background

Unit 0642 (corner-edge-excess) counted the cells near the corner's edge below a fraction `t` of their
root-square size and found about a third more than benchmark 1, which keeps each zero's true amplitude and gives
it an independent random phase. Benchmark 1 leaves out the known correlation of the zeros: their repulsion, which
the repo has already seen through the primes (O64 run 2, notebook entry 103; unit 0474). The question is whether
that correlation accounts for the excess.

## Primary hypothesis

- H1 (`explained`): heights with GUE statistics, put through the same engine, give near-zero counts that reach the
  observed ones, and heights with independent (Poisson) spacing do not.
- H0 (`unexplained`): GUE heights give counts close to benchmark 1, below the observed ones.

## Provenance disclosure (required reading)

- The observed counts on these cells are known: unit 0642 reports them at 100000, 500000 and 2001052 zeros, and an
  earlier cloud run (scratchpad, reported in chat on 2026-11-28) counted them at 10000 zeros, the count this test
  uses. The observed arm is **not blind**. While the engine was timed for this test, the observed total at 10000
  zeros and a twentieth was printed once: 366.
- No GUE or Poisson set has been put through the engine before this lock except in the power study below, which
  uses other seeds. The benchmark arms are blind to their locked seeds.
- The design (10000 heights, the thresholds, the edges) follows 0642 and the box; the rule was written before the
  power study ran.

## Locked parameters

| parameter | value |
|---|---|
| zeros | `imported/odlyzko/zeros6`, sha256 `2ef7b752c2f17405222e670a61098250c8e4e09047f823f41e2b41a7b378e7c6`; first `K = 10000` |
| cells | unit 0642's: twelve edges `row = depth + q`, `q ∈ {1,2,3,4,6,8,12,16,24,32,48,64}`, depths 17–600, and two rays `row = 2d, 3d`, depths 17–420, all inside `Capstone.OpenCorner`; 7080 cells |
| cell value | Riemann's explicit formula term by term, as in 0642 (`O101_edge_correlation.engine`), smooth part left out as there |
| thresholds | `t ∈ {0.02, 0.05, 0.1}` of the root-square size; primary `t = 0.05` |
| benchmark 1 | 0642's: the fifty largest terms of each cell at their own sizes and independent phases over a Gaussian rest, 4000 draws per cell, `default_rng(20261128)` |
| benchmark 2, GUE | 100 sets; each the central 10000 eigenvalues of a `β = 2` Hermite tridiagonal matrix of size 30000, unfolded by the semicircle law (radius `2√n`) to unit mean spacing, mapped to heights by `N(T) = u + 1/2`, `N(T) = (T/2π) log(T/2πe) + 7/8`; `default_rng(20261129)` |
| benchmark 3, Poisson | 100 sets; unit-mean exponential spacings, mapped the same way; `default_rng(20261130)` |
| script | `O101_edge_correlation.py`, no flags, sha256 (fill at lock) |

## Primary statistic

`O`, the count over the twelve edges of cells below a twentieth of their root-square size, with the first 10000
true zeros. `B1`, benchmark 1's expected count on the same cells. `G` and `P`, the same count for each GUE and each
Poisson set.

## Decision rule (locked before data)

With `exc = O − B1`, `Gm` and `G95` the median and 95th percentile of `G`, and `Pm` the median of `P`:

- `compromised` — the sha256 of the zeros file is not the locked value; or the count recomputed with the first
  100000 zeros (edges, `t = 0.05`) differs from the sum of unit 0642's `observed_K100000` counts on the twelve
  edges; or the GUE sets' unfolded spacing has pooled mean outside `[0.98, 1.02]` or variance outside
  `[0.15, 0.21]`; or the Poisson sets' pooled mean outside `[0.98, 1.02]` or variance outside `[0.9, 1.1]`. The run
  executed and the data is corrupt for reasons unrelated to the hypothesis; no verdict.
- `explained` — `exc > 0`, `O ≤ G95`, `Gm − B1 ≥ 0.5 exc` and `Pm − B1 < 0.5 exc`.
- `unexplained` — `exc > 0`, `O > G95` and `Gm − B1 ≤ 0.2 exc`.
- `ambiguous` — anything else, including `exc ≤ 0`.

Precedence: `compromised` > `explained` > `unexplained` > `ambiguous`.

## Power (computed before the lock, synthetic data only)

`O101_edge_correlation_power.py`, output `results/O101_edge_correlation_power.json` (sha256: fill at lock). It
reads no zero: 30 GUE and 30 Poisson sets on other seeds (7001, 7002), each with its own benchmark 1 (1000 draws
per cell, seed 7003). Each GUE set in turn is the truth against the other 29 and the 30 Poisson sets; so is each
Poisson set; and each GUE set again with its count raised by a third, an excess the correlation does not carry.

Output sha256 `a1779ae49b453fb8372929ba8fded3997dbf3dde97244398b1eeaed75a45a705`. Spacing check: GUE sets
pooled mean 1.0, variance 0.1796; Poisson 1.0024, 1.0022.

| synthetic truth | `explained` | `unexplained` | `ambiguous` |
|---|---|---|---|
| a GUE set | 0.0 | 0.1 | 0.9 |
| a Poisson set | 0.0 | 0.033 | 0.967 |
| a GUE set, count raised a third | 0.0 | 0.133 | 0.867 |

**The rule as drafted is vacuous: it does not fire `explained` on a GUE truth, and fires `unexplained` on a planted
excess only 0.133 of the time.** The cause is the spread from one set of heights to the next: the GUE sets' counts
run from 94.7 to 506.3 (5th to 95th percentile, median 209.0), the Poisson sets' from 94.9 to 463.0, because a set's
few lowest heights, its comb's leaders, fix most of the count. Even paired with its own benchmark 1, a set's ratio
of count to benchmark has median 0.902 and sd 0.482 for GUE (5th–95th percentile 0.444–2.064) and median 0.844, sd
0.551 for Poisson. Unit 0642's observed ratio, about 1.3, lies well inside both. **This draft is not to be locked;
a redesign is pending Julian's choice** (see `notes/corner-questions.md`, question 8).

## Pre-specified secondary analyses

The same comparison at `t = 0.02` and `t = 0.1`, edge by edge, and on the two rays; the observed counts at 100000
zeros beside them. Reported, no verdict.

## Falsification

`unexplained` says GUE-correlated heights at the zeros' density do not reproduce the edge excess, which is then
carried by something in the true zeros beyond pair repulsion, or by their arithmetic. `explained` says the
known repulsion is enough. Neither tests heights above 10000, higher correlations than GUE carries, or cells off
these diagonals.

## Compute

About an hour on four cores: 201 sets of 10000 heights through the engine, and the truth again at 100000.

## Reproducibility

Deterministic, no flags, seeds as locked. Output `results/O101_edge_correlation.json` by `guarded_write`.

## Lock chain

- `lock_written_at`: (fill at lock)
- `pre_compute_sha256`: in the sidecar `preregs/edge_excess_correlation_v1_20261128.sha256` (written at lock)
- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `post_compute_sha256`: (fill after run; must equal pre-compute)
- `locked_by`: (Julian's word, when given)

## Run record

Appended after the run. This append changes the file's hash; the no-drift check is that `post_compute_sha256`
below, taken before this section existed, equals the sidecar.
