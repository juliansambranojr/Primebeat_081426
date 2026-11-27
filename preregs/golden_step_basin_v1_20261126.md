# Prereg — the golden step from the first zero (v1)

STATUS: LOCKED on Julian's word, 2026-11-26 ("Lock it"). The text is
committed before `O98_golden_step_basin.py` runs.

## Background

Julian, 2026-11-26: "You don't have to connect it to zeta because zeta is
imaginary. Start with a zeta zero and run that function and the numbers should
fall out". "That function" is the golden step, the sunflower's rule: each new
seed one golden turn on from the last. Units 0577 and 0578 and
`lean_stage3/design/heatflow.md` hold the picture it comes from.

## Primary hypothesis

Write `p(γ) = θ(γ)/π mod 1` for a zero's place in its basin, `θ` the
Riemann–Siegel theta function, so Gram points sit at `p = 0`.

- H1: starting from the first zero's place `p_1`, the golden step
  `pred_n = p_1 + (n − 1)/φ mod 1` gives the places `p_n` of zeros
  `n = 2..228`: the share of hits within `0.1` is far above what the same
  places in a random order give.
- H0: the share of hits is what random orders of the same places give.

Predicted direction under H1: the score above the null.

## Provenance disclosure (required reading)

- The heights `γ_1..γ_228` have been read this session: by the point run
  (`lean_stage3/checks/turingrun/zeros.txt`) and by unit 0578.
- The places `p_n = θ(γ_n)/π mod 1` have **never been computed** by any
  script or person in this repository before this lock. The whole primary
  statistic is blind.
- The rule was proposed by the assistant, from Julian's words, before any
  place was computed, and was not tuned on data.
- A first power study used a null of random starts. On synthetic data it never
  fired, even for a planted golden sequence, because a random start keeps the
  golden step. The null was changed to random orders before any zero was read.
  Both versions of the power output are in this file's history; the second is
  `results/O98_golden_step_power.json`.

## Locked parameters

| parameter | value |
|---|---|
| zeros | `n = 1..228`, `mpmath.zetazero`, all zeros with `γ ≤ 219313/500` |
| place | `θ(γ)/π mod 1`, `mpmath.siegeltheta`, `dps = 30` |
| step | `1/φ`, `φ = (1 + √5)/2` |
| tolerance | circular distance `≤ 0.1` |
| null | `100000` random orders of `p_2..p_228`, `numpy.default_rng(2026)` |
| script | `O98_golden_step_basin.py`, no flags |

## Primary statistic

`S`, the share of `n` in `2..228` with circular distance `|pred_n − p_n| ≤ 0.1`.

## Null and p-value

`p = (1 + #{null scores ≥ S}) / (1 + 100000)`, the null scores taken with the
predictions fixed and the places `p_2..p_228` in random order.

## Decision rule (locked before data)

- `compromised` — the count of zeros up to `219313/500` is not `228`, or
  `θ(g_k)/π` differs from `k` by `10⁻⁹` or more at a Gram point
  `k ∈ {0, 10, 100, 200}`, or a place is not finite. The run executed and the
  data is corrupt for reasons unrelated to the hypothesis; no verdict.
- `falls_out` — `S ≥ 0.5` and `p < 0.001`.
- `does_not_fall_out` — `p ≥ 0.05`.
- `ambiguous` — anything else.

Precedence: `compromised` > `falls_out` > `does_not_fall_out` > `ambiguous`.

## Power (computed before the lock, synthetic data only)

`O98_golden_step_power.py`, 400 replicates per row, 2000 null orders each.
Planted: golden places plus wrapped Gaussian noise of sd `σ`.

| synthetic | `falls_out` | `does_not_fall_out` | `ambiguous` |
|---|---|---|---|
| planted, σ = 0.03 | 1.0 | 0.0 | 0.0 |
| planted, σ = 0.05 | 0.9725 | 0.0075 | 0.02 |
| planted, σ = 0.10 | 0.6275 | 0.12 | 0.2525 |
| planted, σ = 0.15 | 0.125 | 0.2075 | 0.6675 |
| planted, σ = 0.20 | 0.0 | 0.325 | 0.675 |
| null, uniform | 0.0 | 0.9425 | 0.0575 |
| null, random walk | 0.0 | 0.985 | 0.015 |

The rule fires in both directions: `falls_out` on a golden sequence with noise
up to about `0.1`, `does_not_fall_out` on both nulls in most replicates.

## Pre-specified secondary analyses

The mirror step `1/φ² = 1 − 1/φ`, scored the same way. Reported, no verdict.

## Falsification

`does_not_fall_out` says the golden step from the first zero does not give the
next zeros' places in their basins at this tolerance. It does not test a
different step, a different place, or the flow of units 0577 and 0578.

## Compute

Minutes. `mpmath` for 228 zeros and their theta values; `numpy` for the null.

## Reproducibility

Deterministic: `default_rng(2026)`, no flags. Output
`results/O98_golden_step_basin.json`.

## Lock chain

- `lock_written_at`: 2026-11-26T02:31:13Z
- `pre_compute_sha256`: in the sidecar `preregs/golden_step_basin_v1_20261126.sha256`
- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `post_compute_sha256`: (fill after run; must equal pre-compute)
- `locked_by`: claude-on-julian-authorization ("Lock it", 2026-11-26)

## Run record

Appended after the run. This append changes the file's hash; the no-drift
check is that `post_compute_sha256` below, taken before this section existed,
equals the sidecar.

- `run_start_at`: 2026-11-26T02:31:44Z
- `run_end_at`: 2026-11-26T02:32:13Z
- `post_compute_sha256`: aa14d38e8ed842364cb2328186e05428e0395ebb45a14459f7359149d0cd688a
- sidecar `golden_step_basin_v1_20261126.sha256`: aa14d38e8ed842364cb2328186e05428e0395ebb45a14459f7359149d0cd688a — match
- integrity: `count_ok` true, Gram-point error 1.58e-30, `integrity_ok` true
- primary: `S` = 0.2026431718061674, `p` = 0.47733522664773353 (null mean 0.19937845814977975, sd 0.026075170680782574)
- secondary, mirror step `1/φ²`: `S` = 0.1894273127753304, `p` = 0.6835731642683573
- mechanical output of the decision rule: `does_not_fall_out`
- output: `results/O98_golden_step_basin.json`
- `verdict`: `does_not_fall_out` (Julian's word, 2026-11-26: "That's fine", to the recommendation of the label as the rule gave it)
