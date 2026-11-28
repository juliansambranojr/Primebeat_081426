# Prereg — is the edge excess a property of the zeros? Edges pooled over 24 bases (v1)

STATUS: DRAFT, written 2026-11-28 by the cloud session at Julian's word ("Yes", to drafting a 24-base prereg with
its power measured first). Not locked: no sidecar exists. Julian locks it; the text is committed before
`O103_edge_excess_multibase.py` runs.

## Background

Unit 0650 (edge-excess-reassessed): against one random phase per zero shared by all its cells, one base-2 table's
near-zero edge count spreads by about four tenths of itself, so unit 0642's excess of a third is
`consistent_with_chance` (locked test `preregs/edge_excess_frozen_phase_v1_20261128.md`) and could not have been
confirmed. The design check `analysis/2026-11-28/o103_bases/` found that, under a phase null shared across bases, the
counts of different bases are uncorrelated (median between-base correlation 0.001 over six bases): each base reads
the same zeros through its own comb, and its near-zero cells fall elsewhere. Pooling bases narrows the spread.

## Primary hypothesis

- H1 (`excess_real`): pooled over 24 bases, the zeros' sums on the edges come near zero more often than the same
  zeros give with one random phase per zero shared by every cell of every base.
- H0 (`consistent_with_chance`): the pooled count lies inside that spread.

Predicted direction under H1: above.

## Provenance disclosure (required reading)

- Base 2: unit 0642 counted edges `q ≤ 64` to depth 600 with these zeros; four of this test's five base-2 edges are
  among them, to a smaller depth. Base 2 is a twenty-fourth of the pooled count and is **not blind**.
- The other 23 bases have never been computed on the true zeros: the design check and the power study use synthetic
  heights only. They are blind.
- This test asks a different question from 0642's: whether an excess is a property of the zeros seen through any
  comb. If 0642's excess, were it real, belonged to base 2 alone, pooling would dilute it; the base-2 count is
  reported on its own as a secondary.

## Locked parameters

| parameter | value |
|---|---|
| zeros | `imported/odlyzko/zeros6`, sha256 `2ef7b752c2f17405222e670a61098250c8e4e09047f823f41e2b41a7b378e7c6`; first `K = 100000` |
| bases | 2, 3, and `2^x` for the 22 values `x = 0.5 + 1.3·frac(i·φ⁻¹)`, `i = 1..22`, `φ⁻¹ = (√5 − 1)/2` (from 1.4588 to 3.4160) |
| cells, per base | edges `row = depth + q`, `q ∈ {1, 2, 4, 8, 16}`, depths 17–400: 1920 cells; 46080 in all |
| base b | row `r` counts the primes in `(b^(r−1), b^r]`; a zero's term in a cell is the explicit-formula term with `log b` in place of `log 2`; each cell over its scale `b^(r/2) (1 + b^(−1/2))^d` |
| quantity | each cell's zeros' sum (the smooth part left out, as in unit 0642), against `t = 0.05` of its root-square size |
| null | 1000 draws; every zero's term in every cell of every base multiplied by `e^{iθ_k}`, one `θ_k` per zero shared by all bases, uniform; `numpy.default_rng(20261201)`, drawn in blocks of 100 from one stream; terms in complex64 |
| statistic | the count, summed over all cells of all bases |
| script | `O103_edge_excess_multibase.py`, no flags, sha256 (fill at lock) |

## Null and p-value

`p = (1 + #{null totals ≥ observed}) / (1 + 1000)`, one-sided.

## Decision rule (locked before data)

- `compromised` — the zeros file's sha256 is not the locked value; the bases are not 24 distinct numbers; or the
  draw with every `θ_k = 0`, through the complex64 terms, differs from the observed total (summed in float64) by more
  than 10 cells. The run executed and the data is corrupt for reasons unrelated to the hypothesis; no verdict.
- `excess_real` — `p ≤ 0.01`.
- `consistent_with_chance` — `p ≥ 0.10`.
- `ambiguous` — anything else.

Precedence: `compromised` > `excess_real` > `consistent_with_chance` > `ambiguous`.

## Power (computed before the lock, synthetic data only)

`O103_edge_excess_multibase_power.py`, output `results/O103_edge_excess_multibase_power.json` (sha256
`8090ea4351d5b8d76b01af9a153a859b743439555c5189ed75fb47c5a514358e`). It reads no zero: 10 GUE sets of 10000 heights
(O101's generator, seed 7401), each through the same 24 bases, against 200 shared-phase draws (seeds 7402 + set).

| synthetic truth | `excess_real` | `consistent_with_chance` | `ambiguous` |
|---|---|---|---|
| a GUE set, its own phases | 0.0 | 0.9 | 0.1 |
| the same, pooled count raised a sixth | 0.3 | 0.2 | 0.5 |
| the same, raised a third | 0.8 | 0.0 | 0.2 |
| the same, raised a half | 1.0 | 0.0 | 0.0 |

Pooled over the 24 bases the null spreads with sd 0.099 of its mean (median over the sets), against about 0.4 for
one base; the bases' null counts are uncorrelated (median mean correlation 0.0013). The rule fires both ways: it
does not cry `excess_real` on a plain set, catches an excess of a third in eight sets of ten and of a half in all,
and returns `consistent_with_chance` on no set carrying an excess of a third. Unit 0642's excess, if it held in every
base, is the size this test sees.

## Pre-specified secondary analyses

The pooled count at `t = 0.02` and `t = 0.1`; each base's count and p; base 2 alone; the mean correlation between
bases' null counts. Reported, no verdict.

## Falsification

`excess_real` says the true zeros, read through two dozen combs, put the edges' sums near zero more often than shared
random phases: an arrangement of the zeros beyond their sizes. `consistent_with_chance` says no such excess is visible
at the size the power study names; it does not exclude an excess particular to base 2. Neither tests zeros above
100000 or cells off these edges.

## Compute

About an hour and a half on four cores: for each base, the terms of 100000 zeros in 1920 cells, then 1000 draws.

## Reproducibility

Deterministic, no flags, seed as locked. Output `results/O103_edge_excess_multibase.json` by `guarded_write`.

## Lock chain

- `lock_written_at`: (fill at lock)
- `pre_compute_sha256`: in the sidecar `preregs/edge_excess_multibase_v1_20261128.sha256` (written at lock)
- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `post_compute_sha256`: (fill after run; must equal pre-compute)
- `locked_by`: (Julian's word, when given)

## Run record

Appended after the run. This append changes the file's hash; the no-drift check is that `post_compute_sha256`
below, taken before this section existed, equals the sidecar.
