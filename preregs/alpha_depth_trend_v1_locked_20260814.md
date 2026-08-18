# Prereg — α(d) depth-trend test (v1)

STATUS: **LOCKED**

## Background

`05_cross_depth_alpha.py` tests whether per-depth α values are
consistent with a single underlying β by comparing their **spread**
(sd) against a synthetic null. Two problems surfaced in exploratory
runs:

1. **The verdict is selectable post hoc.** Sweeping `--rmax` over
   {40, 45, 50, 55, 60} gives p = 0.090, 0.020, 0.225, 0.070, 0.160.
   Non-monotone, straddling any conventional threshold. `rmax` was
   never fixed in advance.
2. **The statistic is blind to the departure that is actually
   present.** sd does not distinguish a monotone trend from random
   scatter. In exploratory runs the per-depth α values at depths
   2–12 declined with depth in the same order at all five rmax
   settings.

The decision rule in DT-A6 §1(b) has two arms — the α values agree,
or they scatter. Ordered drift is a third outcome neither arm
covers, and the spread test passes precisely *because* the
departure is orderly.

## Primary hypothesis

H0 (the DT-A6 §1(b) reading): β is a property of the zeros, so α
fitted independently per depth is **depth-independent**. Depth
changes only the comb gain, not the radius exponent. The slope of
α on d is zero up to fitting noise.

H1: α is systematically depth-dependent, and the "α measures Re(ρ)"
reading does not hold.

Predicted direction under H1, from exploratory inspection of depths
2–12: **negative** slope.

## Provenance disclosure (required reading)

Depths 2–12 at rmax 40–60 have **already been inspected** by the
operator and the assistant. Any test on that data alone is
confirmatory-on-inspected-data, not pre-registered, and must be
labelled as such in the writeup.

Depths **13–18 have never been fitted** at any rmax. No α value at
d > 12 has been computed or seen by anyone. Those depths are the
genuine held-out sample, and the pre-specified secondary below is
the only fully blind test in this prereg.

## Locked parameters

| parameter | locked value | why this value |
|---|---|---|
| `rmax` | **60** | Widest range the shared cache covers (n=0..60), so the most asymptotic α available without new compute. Fixed now precisely because the sweep showed the verdict is rmax-selectable. |
| `rmin` | **20** | Script default, unchanged. |
| `depths` (primary) | **2–18** | Extends the inspected 2–12 with the never-fitted 13–18. |
| `depths` (secondary, blind) | **13–18** | Never fitted. The only out-of-sample arm. |
| `trials` | **200** | Script default, unchanged. |
| `beta` (synthetic truth) | **0.4334** | Script default, unchanged. |
| `seed` | **2026** | Hardcoded in the existing scripts; not parameterised. Do not add a `--seed` flag. |
| `alpha_level` | **0.05** | Two-sided. |

## Primary statistic

OLS slope `b_obs` of per-depth α on depth d, over the primary depth
set, at the locked rmax.

## Null and p-value

The synthetic control already in `05_cross_depth_alpha.py`
constructs replicates with a **single true β by construction**.
Therefore any α-on-depth slope it produces is pure fitting/apparatus
artifact and is the correct null.

For each of the 200 synthetic trials, fit α per depth exactly as the
real data is fitted, regress those α on depth, and record the slope
`b_syn`. The primary p-value is

    p = fraction of trials with |b_syn| >= |b_obs|

This is distribution-free, uses the machinery already validated in
05, and requires no assumption about the α residual distribution.

## Decision rule (locked before data)

Applied to the **primary** depth set. Verdict labels are used
verbatim in the writeup.

- `depth_dependent` — p < 0.05 **AND** the sign of `b_obs` matches
  the sign of the slope fitted on the blind 13–18 set.
  → α is not measuring a property of the zeros. The DT-A6 §1(b)
    reading comes out.
- `depth_independent` — p >= 0.05 **AND** the 95% CI on `b_obs`
  contains 0.
  → This test does not falsify §1(b). Not the same as confirming it.
- `ambiguous` — anything else, including p < 0.05 with sign
  disagreement between the primary and blind sets, or p >= 0.05
  with a CI excluding 0.
  → The data does not discriminate. Design a sharper test. This is
    a real outcome, not a deferral.
- `compromised` — fewer than 8 depths return a finite α, or any
  retained depth has n_points < 20, or the synthetic null yields
  fewer than 150 valid trials.
  → The test ran but the data is corrupt for reasons unrelated to
    the hypothesis. No verdict.

Precedence: `compromised` > `depth_dependent` > `depth_independent`
> `ambiguous`.

## Pre-specified secondary analyses

Reported always; **cannot** change the primary verdict.

1. **Blind arm.** Same statistic on depths 13–18 alone. This is the
   only unseen data. Report slope, CI, p.
2. **Monotonicity.** Spearman ρ of α on d, primary depth set, with
   its own permutation p. Robust to a non-linear trend.
3. **rmax robustness.** Repeat the primary at rmax ∈ {40, 45, 50,
   55, 60}. Report the slope and p at each. This documents range
   dependence; it does not select the verdict.
4. **Fitting bias.** Mean synthetic recovered α minus 0.4334, to
   confirm the pipeline is unbiased on a known answer.

## Falsification

H0 is falsified by verdict `depth_dependent`.

H0 is **not** confirmed by `depth_independent` — absence of a
detectable slope at n=17 depths is weak evidence, and the writeup
must say so rather than claiming support.

Vacuousness check: under the exploratory magnitudes, a slope of the
size suggested by depths 2–12 should clear the synthetic null
comfortably at 200 trials. The criterion has a realistic chance of
firing in both directions.

## What is varied / held fixed

Varied: depth. Held fixed: rmax, rmin, trials, β, seed, the fitting
routine, and the cache. No script under test is modified — the
analyzer imports or reimplements the existing `fit_alpha` without
altering it.

## Compute

Seconds. Cache covers n=0..60; primecountpy present in the venv.
Artifacts < 100 KB. Path A (keep everything).

## Reproducibility

Deterministic: `default_rng(2026)` throughout, no `--seed` flag
added. Re-running at identical parameters must reproduce byte-identical
results.

## Lock chain

- `lock_written_at`: 2026-08-15T01:04:12Z
- `pre_compute_sha256`: PENDING
- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `post_compute_sha256`: (fill after run; must equal pre-compute)
- `locked_by`: claude-on-julian-authorization-mode-2

## Run record

Appended after the run. This append is expected to change the file's
hash; the no-drift check is that `post_compute_sha256` below equals the
sidecar `alpha_depth_trend_v1_locked_20260814.sha256`, both taken
before this section existed.

- `run_start_at`: 2026-08-15T01:06:47Z
- `run_end_at`: 2026-08-15T01:06:54Z
- `verdict`: `depth_dependent`
- `post_compute_sha256`: `e8dd8430d489fa7dee3135f6f0a7b73bf70100c5fb6aa1aeea9b9cfe433ed109`
- sidecar match: **yes** — identical to `pre_compute_sha256`, so no
  parameter, hypothesis, or decision-rule text drifted between lock and
  compute.
- analyzer: `07_alpha_depth_trend.py`, one run at locked defaults
- results: `results/07_alpha_depth_trend_results.json`
