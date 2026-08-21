# Prereg — small angles and the cross-base transform: where does the residual table's normalized depth gain null? (v1)

STATUS: **DRAFT**

Sidecar: none yet. Not locked until
`preregs/small_angle_cross_base_v1_20260821.sha256` exists. Per
`preregs/FORMAT.md` the sidecar is the authority, not this block.

---

## Background

`notes/lab_notebook_2.md` entry 72 records the reasoning and the check.

One backward difference on the `b`-ladder multiplies a mode `b^(rρ)` by
`Sym b ρ = 1 − b^(−ρ)` — A1, proved in `lean/Chain.lean`. So the depth-`d` gain
of a mode is `(Sym b ρ)^d`, and the **normalized** gain `|Sym b ρ| / log b`
tends to `|ρ|` as `log b → 0`, base-independent in the limit. The deviation is
governed by `u = γ·log b` through `(1 − e^(−u))/u`, the Bernoulli generating
function, whose radius of convergence is `2π` because `u/(e^u − 1)` is singular
at `u = 2πi` — the pole lattice `Chain.sym_eq_zero_iff` proves.

**At `u = 2πk` the oscillatory part cancels exactly** and `Sym b ρ = 1 − b^(−1/2)`,
real. The mode is not aliased there; it is **nulled**. Verified symbolically at
`b = exp(2π/γ₁)`: `Sym = 0.199293 − 3.5e−7 i`.

**Every zeta zero predicts its own null base**, `b = exp(2π/γₙ)`, computed from
`γₙ` alone with no data:

```text
γ₁ = 14.134725  →  1.559743
γ₂ = 21.022040  →  1.348355
γ₃ = 25.010858  →  1.285591
γ₄ = 30.424876  →  1.229386
```

γ₁'s prediction is separated from γ₂'s by 0.211. The higher zeros bunch — 0.019
between γ₄ and γ₅ — so they resolve as a block, not individually. Stated here
rather than discovered at the run.

## Why this prereg contains no permutation null and no p-value

The object is deterministic. `Ĝ_b` is a number, not a draw, so there is no
sampling distribution and "significance" would need a fabricated reference
class. Worse, a permutation over bases assumes exchangeability, and the bases
are the same primes read at different rates — entry 54 and entry 56 record that
the O45 family is **commensurate by construction**, so permuting them shuffles
objects that share the structure under test. The curve would be baked into the
null.

So the rival is another **deterministic model**, and the tolerance is a
**measured noise floor**, not an assumed distribution. Julian raised this
objection against the v0 draft of this file; it is the reason for the design
below.

---

## The two models, and the predicted direction

**H0 — smooth only.** The residual table's depth gain carries no oscillatory
mode. Then `Ĝ_b` follows `ρ = 1/2` real, which has `u = 0.5·log b < 0.35` at
every base here and therefore **no null anywhere**. Predicted `Ĝ` under H0 is
monotone and nearly flat: `0.4829` at `b = 1.15` falling to `0.4226` at
`b = 2.0`, a total spread of 12%.

**H1 — γ₁ dominates.** `Ĝ_b` follows `|1 − b^(−ρ₁)| / log b` with
`ρ₁ = 1/2 + iγ₁`, which falls from `11.55` to `2.42` across the set and **nulls
at `b = 1.5597432`**, dropping to `0.4483` — 3.2% of `|ρ₁|`.

**Predicted direction under H1:** a dip at `1.5597432` and at no other locked
base. H1 is directional and positional; a dip elsewhere falsifies it as surely
as no dip does.

The rival models `H2ₙ` — that `γₙ` dominates for `n ≥ 2` — predict the dip at
`exp(2π/γₙ)` instead, and are given their own verdict labels below.

---

## Complications, and how they are handled

**(a) A cell is not one mode.** The transform is exact per mode; a real cell is
a smooth term plus a sum. Handled by removing the smooth term explicitly — the
statistic runs on `e_b(r) = A_b(r) − (li(b^r) − li(b^(r−1)))` — and by measuring
at depth, where `papers/Depth-as-Time.md` § B4 records γ₁ as the fastest-growing
mode. **This is the largest source of doubt and it is a claim, not a theorem.**
If sub-leading modes carry comparable weight their nulls fill γ₁'s, and H1 fails
for a reason that is not about the transform.

**(b) Non-integer bases.** `π(b^r)` is evaluated at `floor(b^r)`, O45's
convention — an order-1 lattice effect against counts of order `b^r/log b`,
negligible above `value_floor`.

**(c) Unequal depth reach.** Smaller `b` reaches more depth to the same value
ceiling. Comparison is by **value range, not by `r`** — O45's locked rule.

**(d) Locating a dip requires brackets.** The statistic is a **local** ratio
against each candidate's two neighbours in the base set, not against a global
median, because the predicted curve falls by a factor of 5 across the set and a
global denominator would manufacture a dip at the high-`b` end.

---

## Locked parameters

| Parameter | Value |
| --- | --- |
| `gamma` | `γ₁ 14.134725141734693`, `γ₂ 21.022039638771555`, `γ₃ 25.010857580145688`, `γ₄ 30.424876125859513` |
| `rho_n` | `0.5 + iγₙ` |
| `bases` | `1.1500, 1.2293859, 1.2560, 1.2855907, 1.3160, 1.3483554, 1.4200, 1.5000, 1.5597432, 1.6200, 1.7500, 2.0000` |
| `candidate_nulls` | `1.2293859 (γ₄), 1.2855907 (γ₃), 1.3483554 (γ₂), 1.5597432 (γ₁)` |
| `value_ceiling` | `2**32 = 4294967296` |
| `value_floor` | `10**4` |
| `smooth_model` | `li(b**r) - li(b**(r-1))`, `mpmath.li`, `mp.dps = 50` |
| `pi_backend` | `primecountpy.prime_pi`, fallback `sympy.primepi` |
| `depth_window` | `d ∈ [3, 8]` |
| `gain_per_depth` | `median over r of \|E(r,d)\| / \|E(r,d-1)\|`, over cells whose full window lies in `[value_floor, value_ceiling]` |
| `Ghat_b` | `median over d in depth_window of gain_per_depth`, divided by `log b` |
| `dip_ratio` | `D(b) = Ghat(b) / median(Ghat(b_left), Ghat(b_right))`, neighbours in the sorted base list |
| `min_cells_per_depth` | `8` |
| `min_depths` | `4` |
| `control` | the identical pipeline with the oscillatory part removed: `Ĝ_ctrl` from `\|1 − b^(−1/2)\|/log b` fitted the same way |
| `floor` | `min over interior bases of D_ctrl(b)` — the deepest excursion the pipeline produces with no oscillatory mode present |

No parameter above may change after the sidecar is written. There is no `--seed`
flag and none is to be added; nothing in this test is stochastic.

---

## Predicted values, stated before the run

Predicted `Ĝ` under each model, from the constants alone, nothing fitted:

```text
b            H0 (smooth)   H1 (γ₁)     note
1.1500          0.4829     11.5458
1.2293859       0.4751      9.1522     γ₄ candidate
1.2560          0.4726      8.2953
1.2855907       0.4699      7.3353     γ₃ candidate
1.3160          0.4672      6.3575
1.3483554       0.4644      5.3401     γ₂ candidate
1.4200          0.4586      3.2499
1.5000          0.4526      1.2963
1.5597432       0.4483      0.4483     γ₁ candidate
1.6200          0.4443      1.0693
1.7500          0.4361      2.2996
2.0000          0.4226      2.4215
```

Predicted **dip ratio at each candidate**, under H1:

```text
D(1.2293859) = 0.923      D(1.2855907) = 1.001
D(1.3483554) = 1.112      D(1.5597432) = 0.379   ← the only dip
```

Under H0 every `D` is `1.00` to three decimals, and the control's deepest
interior excursion is `D_ctrl = 0.9997`. **So the predicted separation is
0.379 against a floor of ≈ 1.00.**

---

## Checks, in the order reported

1. **Geometry** — per base `r_min`, `r_max`, cell count, value window used.
2. **Predicted curves** — H0 and H1 from constants only, no data touched.
3. **Measured `Ĝ_b`** for all twelve bases.
4. **Control** — `Ĝ_ctrl` and `D_ctrl`; `floor` computed from it.
5. **`D` at each of the four candidate nulls.**
6. **`argmin_b D(b)`** over all interior bases, candidate or not.
7. **Shape residual** — `RMS( log(Ĝ_meas / Ĝ_pred,H1) )`, descriptive only, no
   threshold attached.

---

## Decision rule (locked before data)

Labels verbatim. Precedence top to bottom; first branch that fires is the
verdict.

1. **`compromised`** — any base with fewer than `min_depths` surviving depths,
   or `floor < 0.80`, i.e. the pipeline manufactures dips with no oscillatory
   mode present and the positional test is meaningless.
2. **`gamma1_null`** — `argmin D` is at `1.5597432` **and** `D < floor`.
3. **`gamma2_null`** — `argmin D` at `1.3483554` and `D < floor`.
4. **`higher_block_null`** — `argmin D` at `1.2855907` or `1.2293859`, and
   `D < floor`. These two are 0.056 apart and are not claimed to separate.
5. **`unpredicted_null`** — `D < floor` at a base that is not a candidate.
6. **`no_null`** — no base has `D < floor`. H1 falsified; H0 not falsified.

---

## Falsification

H1 is falsified by `no_null`, by `gamma2_null`, by `higher_block_null`, or by
`unpredicted_null`. The prediction is a **named base**, fixed before any data is
read, against three named rivals and an open "somewhere else" branch. A dip that
is real but sits at 1.348 does not get counted as a success for γ₁.

---

## Vacuousness check

**It can fail.** Under H0 every `D` is 1.00 and the verdict is `no_null`.
Sub-leading modes filling the null is a live mechanism, not a formality — γ₂'s
null at 1.3484 sits inside this base set precisely so that outcome has a name.

**It can succeed.** The predicted dip is 0.379 against a floor near 1.00 — a
factor 2.6, well above the 12% total spread H0 predicts across the whole set.

**It is not circular.** Both predicted curves come from `γₙ` and `log b` alone.
`D` is a ratio of measured quantities. The floor is measured from the control,
which contains no oscillatory mode by construction. Nothing is fitted anywhere.

**It has no fabricated null.** There is no permutation, no p-value, and no
assumed distribution — see § *Why this prereg contains no permutation null*.

**Three outcomes beyond pass/fail** carry their own labels: `gamma2_null`,
`higher_block_null`, `unpredicted_null`. None collapses into either model.

---

## Provenance disclosure (required reading)

**Already inspected.** `1.5597432` is the O45 family's `k = 4` base and appears
in `results/sub_integer_base_scan.json`, `CHAIN.md`'s `t2_crossover` table
(`r_max` 49, `d*` 5), and notes entries 50–56. Base `2.0000` is the most
inspected object in this repository.

**Never measured anywhere in this tree — the blind arm.** `1.1500`, `1.2293859`,
`1.2560`, `1.2855907`, `1.3160`, `1.3483554`, `1.4200`, `1.5000`, `1.6200`,
`1.7500`. **Ten of twelve bases, including both brackets of the γ₁ candidate and
all three rival candidates.** So the denominator of `D(1.5597432)` and every
rival position are unseen.

**What is known about the γ₁ candidate.** Its zero count and crossing depth are
recorded; **its depth gain has never been measured**, and the null predicted
here was not known when the base was locked on 2026-08-18.

---

## What is varied / held fixed

**Varied:** `b`, and nothing else.
**Held fixed:** the `γₙ`, the value window, the smooth model, the depth window,
the gain estimator, the minimum counts, the π backend.

---

## Compute

Twelve bases, `r_max` from 32 (`b = 2`) to 160 (`b = 1.15`), one `π` call per
rung to `2^32`, `li` at 50 dps. Under 1200 `π` calls. Expected wall clock under
10 minutes on the `.venv` in `REFERENCES.md`.

---

## Reproducibility

Fully deterministic. No RNG is used. The script writes
`params.code_version`, the sha256 of its own file, under the caveat `CONTEXT.md`
records — the hash is read at write time, not import time.

---

## Analyzer

`O48_small_angle_cross_base.py`, to be written against this prereg and to cite
this path in its header. Output `results/small_angle_cross_base.json` on the
`CONTEXT.md` § Output schema envelope, tee'd to
`results/O48_small_angle_cross_base_run1.log`.

---

## Lock chain

- `pre_compute_sha256`: PENDING
- sidecar `preregs/small_angle_cross_base_v1_20260821.sha256`: not yet written

Locked when the sidecar exists and its single line matches this file's sha256 as
of locking.

---

## Run record

- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `floor` (from control): (fill at run)
- `D` at each of the four candidates: (fill at run)
- `argmin D` base and value: (fill at run)
- shape residual RMS: (fill at run)
- mechanical decision-rule output: (fill at run)
- **`verdict`: (Julian's to write — an agent may report the decision rule's
  mechanical output and compute the SHA; it does not stamp the verdict)**
- `post_compute_sha256`: (fill at run)
- sidecar match statement: (fill at run)
