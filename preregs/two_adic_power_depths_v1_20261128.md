# Prereg — trailing zero bits of the cells at power-of-two depths (v1)

STATUS: LOCKED on Julian's word, 2026-11-28 ("Lock, write, commit and run"). Drafted the same day at
his word ("yes draft it"). The text is committed before `O100_two_adic_depths.py` runs.

## Background

Julian, 2026-11-28: "What if the structure is not in the parity of the cell numbers but the zeros and
what's inside the cell as integers in binary". A cell is zero exactly when it is divisible by every
power of 2, so the number of trailing zero bits of a cell, its 2-adic valuation `v2`, measures how
close it comes to zero in binary. At a depth `2^k` the binomial weights are all even except at the two
ends (Lucas), which is where unit 0600 (prime-power-cells) and `lean/ParityCell.lean` find a cell
congruent to two rows mod 2. The question here is whether, at those depths, the true cells carry more
trailing zeros than the same cells built from rows with random low bits.

## Primary hypothesis

- H1: at depths `{1, 2, 4, 8, 16}`, the mean of `min(v2, 20)` over the cells is above the null: the
  true rows agree in their low bits, at power-of-two separations, more often than random low bits do.
- H0: the mean is what tables from rows with uniformly random low 20 bits give.

Predicted direction under H1: above the null.

## Provenance disclosure (required reading)

- On 2026-11-28 the cloud session ran an exploratory look (`analysis/2026-11-28/two_adic_look/bits.py`,
  its output beside it, reported in chat):
  all cells with rows `≤ 92` and lowest row `≥ 26`, 2211 cells, against 200 null tables of the same
  kind as here. It computed the mean `v2` per depth for all 66 depths and **printed only the three
  depths furthest below and the three furthest above the null**: below, depths 29, 38, 23; above,
  depths 32 (z 2.2), 52 (z 2.4) and 64 (z 2.6, three cells). The hypothesis came from 32 and 64.
- Depths 1, 2, 4, 8 and 16 were computed in that look but not shown one by one; what is known of
  them is only that none was among the six printed. So the primary arm has been touched in aggregate
  and is **not blind**. This prereg has **no blind arm**: the rows past 92 are unknown, and their
  parity, which the Mac is computing, shows at most one trailing zero.
- Depths 32 and 64, which produced the hypothesis, are kept out of the primary arm and reported as
  secondary, with no verdict.
- The look also reported the pooled `v2` histogram (close to the fair-coin halving), values mod 16
  uniform, middle bits 0.4982 ones, and the four zeros' neighbours mostly odd.

## Locked parameters

| parameter | value |
|---|---|
| data | `b007053.txt` (π(2^n), n = 0..92), sha256 `6f4f5aaca7419f8c3d0a9d41b56617a1347ab4c124eec3f64362e299f7d8179b` |
| rows | `a(m) = π(2^m) − π(2^(m−1))`, `m = 1..92` |
| cell | `(r, d)`, backward difference: `Σ_j (−1)^j C(d, j) a(r − j)` |
| cells | `r ≤ 92`, lowest row `r − d ≥ 26` (every row used has at least 21 bits) |
| primary depths | `{1, 2, 4, 8, 16}` — 304 cells |
| placebo depths | `{3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15}` — 632 cells |
| secondary depths | `{32, 64}` — 38 cells pooled, reported, no verdict |
| arithmetic | modulo `2^20`; `v2` capped at 20 (a residue 0 counts 20) |
| null | 10000 tables, rows 26..92 with their low 20 bits uniform random, `numpy.default_rng(20261128)` |
| script | `O100_two_adic_depths.py`, no flags, sha256 `41c2db70d63462bac40d7da30e9953351120d9d6311fb9f06f9ffa894db8a43f` |

## Primary statistic

`T` = the mean over the primary cells of `min(v2(cell), 20)`.

## Null and p-value

The same statistic on each null table; `p = (1 + #{T_null ≥ T}) / (1 + 10000)`, one-sided. The placebo
statistic and its `p` are computed the same way on the placebo cells.

## Decision rule (locked before data)

- `compromised` — the sha256 of `b007053.txt` is not the locked value; a row 0..92 is missing; a row
  26..92 has fewer than 21 bits; the mod-2^20 route disagrees with the exact integer cell on any of the
  first 40 primary cells; or the null mean of `T` lies outside `[0.85, 1.15]`. The run executed and the
  data is corrupt for reasons unrelated to the hypothesis; no verdict.
- `excess` — `p_primary ≤ 0.01` and `p_placebo > 0.01`.
- `no_excess` — `p_primary ≥ 0.10`.
- `ambiguous` — anything else (including an excess in both arms, which would not be specific to
  powers of two).

Precedence: `compromised` > `excess` > `no_excess` > `ambiguous`.

## Power (computed before the lock, synthetic data only)

`O100_two_adic_power.py`, output `results/O100_two_adic_power.json` (sha256
`8d7efc663d19122d564db5db00c0de18cc00dabbe656496d9d0217f7a6d1645d`). It reads no prime count: every
synthetic table draws rows 26..92's low 20 bits at random. The null is built as the run builds it.
1000 replicates per row; planted effect: each cell of the planted arm independently gains one trailing
zero with probability `q` (a mean shift of `q` trailing zeros per cell). Null mean of `T` 0.9990,
sd 0.0808 (primary); placebo 0.9994, sd 0.0560.

| synthetic | `excess` | `no_excess` | `ambiguous` |
|---|---|---|---|
| null | 0.014 | 0.898 | 0.088 |
| primary arm, q = 0.1 | 0.102 | 0.542 | 0.356 |
| primary arm, q = 0.2 | 0.456 | 0.118 | 0.426 |
| primary arm, q = 0.3 | 0.876 | 0.008 | 0.116 |
| primary arm, q = 0.5 | 0.991 | 0.0 | 0.009 |
| both arms, q = 0.3 | 0.002 | 0.006 | 0.992 |

The rule fires in both directions: `no_excess` on the null in about nine replicates in ten, `excess`
on a shift of 0.3 trailing zeros per cell in about nine in ten, and `ambiguous` when the shift is in
every depth. A shift of 0.1 or less is below what 304 cells can see. The planted effect is applied
cell by cell, independently; a real effect would come from the rows and be correlated across cells
that share rows, which the null (built from rows) accounts for in `T`'s spread but the planting does not.

## Pre-specified secondary analyses

The mean `v2` over the depth-32 and depth-64 cells pooled (38 cells) and its p-value on the same null;
the mean `v2` at each primary depth and at 32 and 64. Reported, no verdict.

## Falsification

`no_excess` says the true rows, at separations 1, 2, 4, 8 and 16, do not agree in their low bits more
often than random low bits, by as much as 0.3 trailing zeros per cell. It does not test depths 32 and
64 (too few cells: 35 and 3), cells whose rows are shorter than 21 bits (rows below 26, where the four
zeros are), other bases, or any bit other than the trailing ones.

## Compute

Seconds (numpy, all arithmetic modulo 2^20).

## Reproducibility

Deterministic: `default_rng(20261128)`, no flags. Output `results/O100_two_adic_depths.json`.

## Lock chain

- `lock_written_at`: 2026-11-28T08:20:46Z
- `pre_compute_sha256`: in the sidecar `preregs/two_adic_power_depths_v1_20261128.sha256` (written at lock)
- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `post_compute_sha256`: (fill after run; must equal pre-compute)
- `locked_by`: claude-on-julian-authorization ("Lock, write, commit and run", 2026-11-28)

## Run record

Appended after the run. This append changes the file's hash; the no-drift
check is that `post_compute_sha256` below, taken before this section existed,
equals the sidecar.
