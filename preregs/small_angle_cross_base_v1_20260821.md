# Prereg — small angles and the cross-base transform: does the residual table's normalized depth gain follow the symbol, and does it null at `b = e^(2π/γ₁)`? (v1)

STATUS: **DRAFT**

Sidecar: none yet. This prereg is not locked until
`preregs/small_angle_cross_base_v1_20260821.sha256` exists. Per
`preregs/FORMAT.md`, the sidecar is the authority, not this block.

---

## Background

`notes/lab_notebook_2.md` entry 72 records the reasoning. In short:

All b-adic tables are one object sampled at rate `h = log b`. One backward
difference on the `b`-ladder multiplies a mode `b^(rρ)` by the symbol
`Sym b ρ = 1 − b^(−ρ)` — that is A1, proved in `lean/Chain.lean`. So the
depth-`d` gain of a single mode is `(Sym b ρ)^d`, and the **normalized** gain

```text
|Sym b ρ| / log b   →   |ρ|    as log b → 0
```

is base-independent in the limit. The deviation from that limit is governed by
`u = |γ| · log b`, through the factor `(1 − e^(−u))/u`, whose expansion is the
Bernoulli generating function — i.e. the Euler–Maclaurin correction terms, the
steps lost when a sum is replaced by an integral.

That series has radius of convergence `2π`, because the nearest singularity of
`u/(e^u − 1)` is at `u = 2πi`. That is the pole lattice `Chain.sym_eq_zero_iff`
proves, and it is the same number as the sampling Nyquist O15 and O45 measure.

**The sharp consequence, and the reason for this prereg.** At `u = 2πk` exactly,
`e^(−iu) = 1`, so the oscillatory part of the symbol cancels and

```text
Sym b ρ  =  1 − b^(−1/2)      real, no imaginary part
```

The `γ₁` mode is not merely aliased there — it is **nulled**. Verified
symbolically at `b = e^(2π/γ₁)`: `Sym = 0.199293 + 0.000000i`, and
`1 − b^(−1/2) = 0.199293`.

Predicted null bases: `b = exp(2πk/γ₁)` = **1.559743**, 2.432799, 3.794542.

`1.5597` is the O45 locked family's `k = 4` base
(`preregs/sub_integer_base_scan_v1_20260818.md`), which was locked 2026-08-18
for an unrelated reason — the family is `log b_k = k·π/(2γ₁)`, so `k = 4` lands
on `2π/γ₁` by construction. Nobody looked at it as a null.

**What this test is not.** O18 measured the alias comb — peaks in `γ` at fixed
`b`, spaced `2π/log b`. This is the dual axis: a null in `b` at fixed `γ`. The
underlying phenomenon is the same lattice; whether the residual table exhibits
it on this axis has not been measured.

---

## Primary hypothesis

**H0 — the residual table's depth gain does not follow the symbol.** The
measured normalized gain `Ĝ_b` is uncorrelated with the predicted
`|1 − b^(−ρ₁)| / log b`, and in particular shows **no dip** at `b = 1.559743`
relative to its bracketing bases.

**H1 — it follows the symbol, including the null.** `Ĝ_b` tracks the predicted
curve across the locked base set, and `Ĝ` at `b = 1.559743` is **suppressed**
relative to the bases immediately on either side.

**Predicted direction under H1:** suppression, i.e. the dip ratio `R` below 1.
H1 is directional; a value of `R` above 1 falsifies H1 as surely as `R ≈ 1`
does.

`ρ₁ = 1/2 + iγ₁`, `γ₁ = 14.134725141734693`, `|ρ₁| = 14.143566`.

---

## The complications, and how they are handled

### (a) A cell is not one mode

The transform is exact for a single mode. A real cell is a smooth term plus a
sum over all modes, and the transform acts mode-by-mode. Handled by (i)
removing the smooth term explicitly — the statistic is computed on the
**residual** `e_b(r) = A_b(r) − (li(b^r) − li(b^(r−1)))`, not the raw row — and
(ii) measuring at depth, where `papers/Depth-as-Time.md` § B4 records γ₁ as the
fastest-growing mode, so the deepest cells are the most nearly single-mode.

This is the largest source of doubt in the test and it is stated here rather
than discovered later. If sub-leading modes dominate, the dip will be filled in
and H1 will fail for a reason that is not about the transform.

### (b) Non-integer bases and π

`π(b^r)` for irrational `b` is computed at `floor(b^r)`. This is O45's
convention and is a lattice effect of order 1 against counts of order `b^r/log`,
i.e. negligible above `r` where `b^r > 10^4`. Rungs below that are excluded by
`r_min`.

### (c) Different bases reach different depths

Smaller `b` gives more rungs to the same value ceiling, hence more depth. Fair
comparison is by **value range, not by `r`** — the same rule O45 locked. All
bases are cut at one common value ceiling, and the gain is measured over a
common **value window**, not a common `r` or `d` range.

### (d) The null is narrow

`|Sym|` at the null is 3.2% of `|ρ₁|`, but it recovers to 7.6% at `b = 1.62`
and 9.2% at `b = 1.50`. So the predicted dip is a factor ≈ 2.6 against its
bracketing bases — real but not enormous. The base set below places three
points inside the dip's width so that a null present but displaced is
distinguishable from a null absent.

---

## H0 expected value, stated as a number before the run

Under H0 the measured `Ĝ` at 1.559743 is drawn from the same distribution as its
neighbours, so

```text
E[R] = 1.00   under H0
```

Under H1, from the symbol alone, with `Ĝ_pred(1.50) = 1.2963`,
`Ĝ_pred(1.5597) = 0.4483`, `Ĝ_pred(1.62) = 1.0693`:

```text
R_pred = 0.4483 / median(1.2963, 1.0693) = 0.4483 / 1.1828 = 0.379
```

---

## Locked parameters

| Parameter | Value |
|---|---|
| `gamma_1` | `14.134725141734693` |
| `rho_1` | `0.5 + 14.134725141734693i` |
| `bases` | `1.1175, 1.2489, 1.3957, 1.4142135623730951, 1.5000, 1.5597432, 1.6200, 1.7500, 2.0, 3.0` |
| `null_base` | `1.5597432` (`= exp(2π/γ₁)`, to 7 dp) |
| `bracket_bases` | `1.5000` and `1.6200` |
| `value_ceiling` | `2**32 = 4294967296` |
| `value_floor` | `10**4` (sets `r_min` per base) |
| `smooth_model` | `li(b**r) - li(b**(r-1))`, `mpmath.li`, `mp.dps = 50` |
| `pi_backend` | `primecountpy.prime_pi`, fallback `sympy.primepi` |
| `depth_window` | `d ∈ [3, 8]` |
| `gain_per_depth` | `median over r of |E(r,d)| / |E(r,d-1)|`, over cells whose full window lies in `[value_floor, value_ceiling]` |
| `Ghat_b` | `median over d in depth_window of gain_per_depth`, divided by `log b` |
| `min_cells_per_depth` | `8` — a depth with fewer contributing `r` is dropped |
| `min_depths` | `4` — a base with fewer surviving depths is `compromised` |
| `seed` | `2026` (`default_rng(2026)`); **do not add a `--seed` flag** |
| `n_permutations` | `2000` for the null on the Spearman check |

No parameter above may be changed after the sidecar is written.

---

## Primary statistic

```text
R  =  Ghat(null_base) / median( Ghat(1.5000), Ghat(1.6200) )
```

One number. Reported to 4 decimal places.

---

## The checks, in the order they are reported

1. **Geometry.** Per base: `r_min`, `r_max`, cell count, and the common value
   window actually used. Reported before any statistic.
2. **Symbol prediction.** The predicted `|Sym b ρ₁| / log b` for all ten bases,
   computed from the locked `ρ₁` alone, with no data.
3. **Primary — `R`.**
4. **Shape — Spearman `r_s`** between measured `Ĝ` and predicted `Ĝ` across all
   ten bases, with a permutation null at `n_permutations`.
5. **Smooth control.** The same pipeline run with `ρ = 1/2` (real), whose `u`
   is `0.5·log b < 0.55` for every base and therefore has **no** null anywhere.
   The control's `R_ctrl` must not dip.
6. **Displacement.** `argmin` of measured `Ĝ` over the base set, reported
   against the predicted `argmin` at `1.5597432`.

---

## Decision rule (locked before data)

Verdict labels are used verbatim in the writeup and in the Run record.
Precedence is top to bottom; the first branch that fires is the verdict.

1. **`compromised`** — if any base yields fewer than `min_depths` surviving
   depths, or if the smooth control dips (`R_ctrl < 0.7`), which would indicate
   the pipeline manufactures dips independent of the symbol.
2. **`symbol_tracked`** — `R < 0.60` **and** `r_s > 0` at permutation
   `p < 0.05`. The null is present and the curve tracks the symbol.
3. **`null_only`** — `R < 0.60` but the Spearman check fails. The dip is there;
   the rest of the curve is not explained.
4. **`shape_only`** — `R ≥ 0.60` but `r_s > 0` at `p < 0.05`. The curve tracks
   the symbol without the null, which would falsify the sharp claim while
   leaving the transform intact.
5. **`no_structure`** — `R ≥ 0.60` and the Spearman check fails. H0 not
   falsified.

`R < 0.60` is set between the H0 expectation of `1.00` and the H1 prediction of
`0.379`, closer to H1 to keep the test conservative against a shallow dip.

---

## Falsification

H1 is falsified by `no_structure`, by `shape_only`, or by `R ≥ 1` (an
anti-dip). H1 makes a directional, numerical, pre-stated prediction — `R ≈ 0.38`
with a null at a base named before any data is read — and the base set contains
three points inside the predicted dip so that a real null cannot hide between
samples.

---

## Vacuousness check

The criterion has a realistic chance of firing in both directions.

**It can fail.** The residual at depths 3–8 is a superposition, not one mode.
If γ₂ and beyond carry comparable weight, their nulls sit at different bases
(`exp(2πk/γ₂)` with `γ₂ = 21.022`, i.e. `1.3477`) and would fill the γ₁ null.
`papers/Depth-as-Time.md` § B4's claim that γ₁ is the fastest-growing mode is
the reason to expect otherwise, and it is a claim, not a theorem.

**It can succeed.** The predicted dip is a factor 2.6 against its brackets, well
above the sampling scatter of a median over ≥ 8 cells.

**It is not circular.** The predicted curve is computed from `ρ₁` and `log b`
alone, with no reference to any measured cell. `R` is a ratio of measured
quantities. Nothing in the prediction was fitted.

**A third outcome exists** and is given its own label: `shape_only`, where the
transform holds but the null does not, which would be informative and is not
collapsed into either hypothesis.

---

## Provenance disclosure (required reading)

**Already inspected.** Bases `1.1175, 1.2489, 1.3957, 1.4142…, 1.5597…, 2.0`
are the O45 locked set and appear in `results/sub_integer_base_scan.json`,
`analysis/2026-08-19_table_structure/CHAIN.md` and notes entries 50, 51, 52, 54,
56. Base `3.0` is measured throughout (O27, O29, O33). Base 2 is the most
inspected object in the repository.

**Never measured, and this is the blind arm.** Bases `1.5000`, `1.6200`,
`1.7500` appear in no result, no log and no notebook entry in this tree. They
were chosen for this test to bracket and shoulder the predicted null. **The
primary statistic `R` depends on two of them**, so the denominator of `R` has
never been seen by Julian or by any assistant.

**What is known about the null base.** `1.5597` has an `r_max` of 49 and a `d*`
of 5 recorded in `CHAIN.md`'s `t2_crossover` table, and O45 counts its zeros.
Its **depth gain has not been measured**, and the null predicted here was not
known when it was locked.

---

## What is varied / held fixed

**Varied:** the base `b`, and nothing else.
**Held fixed:** `ρ₁`, the value ceiling and floor, the smooth model, the depth
window, the gain estimator, the minimum cell counts, the π backend.

---

## Compute

Ten bases, `r_max` from 20 (b = 3) to 200 (b = 1.1175), one `π` evaluation per
rung to `2^32`, plus `li` at 50 dps. Under 2000 `π` calls total. Expected wall
clock under 10 minutes on the `.venv` described in `REFERENCES.md`.

---

## Reproducibility

`default_rng(2026)`, used only for the permutation null. The rest is
deterministic. The script writes `params.code_version` — the sha256 of its own
file — under the caveat `CONTEXT.md` records: the hash is read at write time,
not import time.

---

## Analyzer

`O48_small_angle_cross_base.py`, to be written against this prereg and to cite
this path in its header. Output `results/small_angle_cross_base.json` on the
schema in `CONTEXT.md` § Output schema, tee'd to
`results/O48_small_angle_cross_base_run1.log`.

---

## Lock chain

- `pre_compute_sha256`: PENDING
- sidecar `preregs/small_angle_cross_base_v1_20260821.sha256`: not yet written

The prereg is locked when the sidecar exists and its single line matches the
sha256 of this file as of locking.

---

## Run record

- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `R`: (fill at run)
- `r_s` and permutation `p`: (fill at run)
- `R_ctrl` (smooth control): (fill at run)
- measured `argmin` base: (fill at run)
- mechanical decision-rule output: (fill at run)
- **`verdict`: (Julian's to write — an agent may report the decision rule's
  mechanical output and compute the SHA; it does not stamp the verdict)**
- `post_compute_sha256`: (fill at run)
- sidecar match statement: (fill at run)
