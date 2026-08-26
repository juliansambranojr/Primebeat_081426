# Prereg — does each character's own L-zeros beat every rival, on moduli never swept? (v1)

STATUS: **LOCKED**

## Background

`O87_character_sweep.py` ran this design on q = 5 and 7 and every
diagonal fired (lab_notebook_2 entry 178). A second reader
(entry 179) then established three things that make a preregistered
version worth running, and changed its construction:

1. The `if k == 0` branch in O87 is **data-determined, not a knob** —
   a uniform per-row OLS fit of the main-term coefficient recovers
   `c = 1.000019` for principal rows against `c ~ 6e-6` for the rest,
   with no character knowledge supplied, and the whole matrix survives
   under it. **This prereg uses the uniform rule and has no branch**,
   removing the construction's only degree of freedom.
2. The sharpest control is a **residue-class shuffle** — permute, per
   rung, which class each block's von Mangoldt mass lands in. That
   preserves `psi(x)` exactly, the rung grid, the Hann window and the
   `|F|`-versus-`t` trend, and destroys only the arithmetic.
3. Per-cell p-values invite a multiple-comparison argument the cells
   cannot settle, since rows share a residual and columns share a
   target list. **The statistic here is per-row and ordinal instead.**

q = 11 and q = 13 have never been swept in this tree. The zero lists
below were computed before this prereg was locked and are frozen; the
matrix has never been computed for either modulus.

## The statistic

Build one residual per character, detrended by the uniform rule. Score
every residual against every character's zero list. Then, **per
non-principal row, ask one question: is the diagonal cell the maximum
of its row?** `R` = the count of rows where it is.

No per-cell p-values, no control calibration, no multiple-comparison
correction, no range-matching. Under any null in which a residual bears
no special relation to its own character's zeros, `R` is small.

## Primary hypothesis

**H0.** A residual bears no special relation to its own character's
zeros; `R` is consistent with the residue-class-shuffle null.

**H1.** Each character's residual scores highest against its own
L-function's zeros. **Predicted direction:** `R` exceeds every draw of
the in-run shuffle null, and `R >= 10` of 20.

## Locked parameters

| parameter | value |
|---|---|
| script | `O89_sweep_q11_q13.py` |
| moduli | 11 and 13 — never swept in this tree |
| characters | all of them: 10 for q = 11, 12 for q = 13; the 2 principal rows are reported as calibration and are **excluded from `R`** |
| rows in `R` | 20 non-principal |
| orbit | `{2^m 3^n <= 2^30}`, sorted, exact integers |
| counting | per-rung cumulative von Mangoldt mass by residue class, one sieve per modulus, prime powers cumulative (entry 176's fix) |
| detrend | uniform per-row OLS fit of the main term; **no branch, no character knowledge** |
| normalisation | `/ sqrt(x_j)`; Hann window |
| targets | the frozen lists below; the script recomputes them and must match to `1e-4` |
| null | residue-class shuffle, 200 draws, computed **in the run** on these same moduli |
| seed | 2026 |

### Frozen target lists

`results/frozen_targets_q11_q13.json`, sha256
`86bc11a9b637c97a85be3b8e5d9d91b7f1995eb731e4332bfc0365726a388e7f`

| character | zeros in (0, 40) | first | last |
|---|---|---|---|
| `q=11 k=0 (principal)` | 6 | 14.134725 | 37.586178 |
| `q=11 k=1` | 21 | 3.547041 | 39.918165 |
| `q=11 k=2` | 20 | 5.133700 | 39.089138 |
| `q=11 k=3` | 20 | 5.070316 | 38.405990 |
| `q=11 k=4` | 21 | 4.629354 | 39.764046 |
| `q=11 k=5` | 21 | 2.477244 | 38.954261 |
| `q=11 k=6` | 21 | 2.696004 | 39.443193 |
| `q=11 k=7` | 22 | 1.231188 | 39.955596 |
| `q=11 k=8` | 21 | 3.610040 | 39.478110 |
| `q=11 k=9` | 21 | 3.414922 | 39.227057 |
| `q=13 k=0 (principal)` | 6 | 14.134725 | 37.586178 |
| `q=13 k=1` | 22 | 4.244609 | 39.859675 |
| `q=13 k=2` | 21 | 4.454854 | 39.158077 |
| `q=13 k=3` | 22 | 3.743822 | 39.998845 |
| `q=13 k=4` | 21 | 4.938591 | 38.553145 |
| `q=13 k=5` | 22 | 0.883960 | 39.153411 |
| `q=13 k=6` | 22 | 3.119341 | 39.036785 |
| `q=13 k=7` | 22 | 3.329832 | 39.160850 |
| `q=13 k=8` | 22 | 2.273131 | 39.645513 |
| `q=13 k=9` | 22 | 2.195553 | 38.889624 |
| `q=13 k=10` | 22 | 3.660975 | 39.676958 |
| `q=13 k=11` | 22 | 2.345469 | 39.446147 |

Both principal lists are zeta's first six zeros, `14.134725 .. 37.586178`
— computed independently here for a third and fourth time, matching
q = 5 and q = 7.

## Power

Measured before this prereg was written, on q = 5 and 7 — data already
unblinded, so nothing about q = 11 or 13 was touched.
`O88_rowmax_null.py`, `results/rowmax_null.json`:

```text
observed on real residuals      R = 8 of 8 non-principal rows
shuffle null, 300 draws         mean 0.730   sd 0.827   max 3
analytic expectation            0.800   (the empirical null matches it,
                                which validates the control)
draws reaching R = 8            0 of 300      -> p <= 0.0033
per-row hit rate                1.000, one-sided 95% lower bound 0.688
```

At that conservative lower bound a 20-row sweep expects **13.8** hits
against a null mean near **1.8**. The `R >= 10` threshold sits far
above the null and well below the expected effect, so a `null` outcome
here would be informative rather than a non-measurement.

## Decision rule

Evaluate in precedence order. Labels verbatim.

1. `compromised` — a recomputed target list disagrees with the frozen
   values by more than `1e-4`, or fewer than 300 blocks are built, or
   any row's fitted main-term coefficient is non-finite.
2. `carries_own` — `R >= 10` **and** `R` exceeds every one of the 200
   shuffle draws. H1 supported.
3. `null` — anything else.

The mechanical output may be reported by an agent. **The verdict line
is Julian's to write.**

## Vacuousness check

Both outcomes are reachable and the power section says how often.
`carries_own` needs 10 of 20; the measured per-row rate on q = 5, 7 was
1.000 with a 95% lower bound of 0.688, which puts `P(R >= 10)`
essentially at 1 if the effect transfers. `null` fires whenever it does
not — and the shuffle null's mean of 0.730 on 8 rows, never exceeding
3, says `R >= 10` on 20 rows is not something the null produces.

The statistic is ordinal and self-normalising, so no cell magnitude,
window choice, grid resolution or trend can move it without changing
which cell in a row is largest.

## Provenance

- The zero lists were computed and inspected before locking, using
  `O87_character_sweep.py`'s own `zeros_of`, so the run recomputes them
  with the same code that froze them.
- The null and power were measured on q = 5 and 7 only, already
  unblinded (entries 178, 179).
- **The matrix for q = 11 and q = 13 has never been computed by
  anyone.** No residual for either modulus has been built.
- Blind arm: the entire measurement.

## Run record

- `run_start_at`: `2026-08-26T16:25:53.795940+00:00`
- `run_end_at`: `2026-08-26T16:28:31.376526+00:00`
- gates: 22 characters recomputed, all target lists matching the frozen
  values (pass); 307 blocks against a floor of 300 (pass); fitted
  main-term coefficients finite (pass).
- the uniform rule separated the rows by itself, with no character
  knowledge: principal `c = 1.000005, 1.000005`; every other row
  `|c| <= 6.24e-05`.
- **`R` = 20 of 20 non-principal rows.** Every diagonal is its row's
  maximum, and not narrowly: diagonals run `6.5834` to `7.8149`, best
  rivals `4.2889` to `6.2076`.
- null, residue-class shuffle, 200 draws computed in-run on these same
  moduli: mean `0.705`, sd `0.859`, **max 3**, and **0 of 200 draws
  reach `R`**.
- mechanical decision-rule output: **`carries_own`** (branch 2:
  `R >= 10` and `R` exceeds every shuffle draw). H1 supported.
- power quoted before locking: per-row rate 1.000 on q = 5, 7 with a
  95% lower bound of 0.688, predicting ~13.8 hits. Observed 20.
- results artifact: `results/sweep_q11_q13.json`
- `post_compute_sha256` of that artifact:
  `e888e7438dd5abb8277c55f1ca154f38bb0d7e085c22ef412c01c85c9a0e2ed9`
- sidecar match: `preregs/character_sweep_q11_q13_v1_20260826.sha256`
  pins this file **as of locking, before this Run record was filled**,
  at `8347ec9a88ea7356d68de848457b8ee665d5b0be5c05cbc262ec07ea7a663b60`.
  Per `preregs/FORMAT.md` a locked prereg is immutable except for its
  Run record, and this block is that record.
- **CORRECTION TO THE PROVENANCE SECTION, 2026-08-26, before any
  verdict was stamped.** The locked text is immutable, so the false
  statement stands above and is corrected here.

  § Provenance asserts "The matrix for q = 11 and q = 13 has never been
  computed by anyone. No residual for either modulus has been built"
  and "Blind arm: the entire measurement." **That is false for
  q = 11.** `notes/lab_notebook_2.md` entry 179 records that the second
  reader tested q = 11 and found all of its diagonals firing; that
  entry committed as `e690f65` at 09:21:28, and this prereg's sidecar
  was written at 09:24:25 — three minutes later. The assistant that
  wrote entry 179 wrote the contradicting provenance line immediately
  afterwards.

  **The honest statement of what was blind: q = 13's 11 non-principal
  rows.** q = 11's 9 rows were unblinded at lock. Since the decision
  threshold is `R >= 10`, a rule cleared with 9 rows already known to
  fire could have been satisfied by a single hit among the 11 blind
  rows, so the locked threshold is weaker than it appears.

  **The result on the genuinely blind arm is 11 of 11.** That alone
  clears `R >= 10` and exceeds every draw of the in-run null (max 3)
  and of the two shuffle variants an independent reproduction
  generated (max 4 each, 600 draws total). The `carries_own` branch
  fires on the blind arm by itself.

- **INDEPENDENT REPRODUCTION, same date.** An agent rebuilt the entire
  pipeline from scratch — its own segmented sieve (validated at
  2.2e-15 against a brute-force von Mangoldt sum), its own
  Euler-Maclaurin `L`-evaluator (8e-14 against mpmath), its own zeros
  with winding-number completeness proofs, its own shuffle — importing
  nothing from O87, O88 or O89. Every printed figure reproduced
  exactly: `R = 20`, diagonals `6.5834 .. 7.8149`, best rivals
  `4.2889 .. 6.2076`, null mean `0.705` sd `0.859` max `3`, `0/200`.
  Frozen target lists exact and complete, no zero missed or spurious.
  `detrend_uniform` confirmed to be the OLS coefficient it claims
  (three ways); the shuffle confirmed to permute per-rung increments
  with a valid monotone reconstruction preserving `psi(x)`; dropping
  O87's median normalisation confirmed statistic-neutral. The result
  held across ceilings `2^24 / 2^26 / 2^30`, orbits `{2,3}`,
  `{2,3,5}`, `{3,5,7}`, four windows, mean and median summaries, and
  with the detrend removed entirely. Longer target lists score LOWER
  (correlation `-0.450`), so the diagonal is not structurally
  favoured.

- **Two further qualifications from that reproduction.** The 20 rows
  are not 20 independent tests — conjugate character pairs share a
  residual, giving about 11 independent ones — so § Power's
  `0.05^(1/8) = 0.688` bound treats 8 correlated rows as 8 independent
  trials and is optimistic. The decision rule does not use it. And the
  shuffle as shipped permutes all `q` classes including class 0, not
  the `q-1` nonzero ones; entry 179's remark that it leaves principal
  rows invariant does not describe the code. Principal rows are
  excluded from `R`, and the corrected shuffle variant gives max 4
  against `R = 20`.

- **`verdict`:** *(Julian's to write)*
