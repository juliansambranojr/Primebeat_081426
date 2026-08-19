# Prereg — sub-integer bases: is base 2 the finest sampling, or is it special in itself? (v1)

STATUS: **LOCKED**

Filename carries no status and never changes, per `CLAUDE.md`
§ "Prereg file naming and status". There is no sidecar
`sub_integer_base_scan_v1_20260818.sha256` yet; the sidecar is the
authority on lock, and its absence means this prereg is not locked.

## Background

`results/O44_cross_base_zero_scan_run1.log` § 1 "EXTENT AND EXACT ZEROS"
records, over the eight imported b-adic tables:

```text
   b name      file                               maxr maxd  cells    d>=1 zeros
   2 dyadic    dyadic_difference_table_32.csv       32   31    528     496     4
   3 triadic   triadic_difference_table_32.csv      32   31    528     496     0
   4 tetradic  tetradic_difference_table_32.csv     32   31    528     496     0
   5 pentadic  pentadic_difference_table_27.csv     27   26    378     351     0
```

Base 2 is the only base with exact zeros: **4 in 496 cells**, against
base 3's **0 in the same 496**. Bases 5–9 stop at regime ceilings 27,
24, 22, 21, 20 and are extent-censored; base 4 reaches r = 32 and is
empty. The same counts are in `results/cross_base_zero_scan.json` at
`summary.per_base[*].n_exact_zeros` and
`summary.per_base[*].n_cells_at_or_above_d_min`.

**Two accounts of why base 2, and they predict opposite things.**

*Fineness.* Base 2 is the finest **integer** sampling of the scaling
flow. Bases 4 and 8 are literal sub-samplings of it, `4^r = 2^(2r)` and
`8^r = 2^(3r)`. `lean/Zeros.lean`,
`window_exclusive_of_prime_exponent`, proves that the (20,6) window is
`2^7` with 7 prime, so `b^k = 2^7` with `b ≥ 2`, `k ≥ 2` forces
`b = 2, k = 7`: no coarser integer base reaches that window at integer
depth. If a cancellation needs fine resolution and coarser samplings
average over it, then bases **below** 2 — finer still — should produce
zeros at comparable or higher density.

*Intrinsic.* Base 2 is special in itself. Then sub-integer bases stay
empty.

**Nothing in the formal chain restricts the base.**
`lean/PairIdentity.lean`, `pair_identity`, takes no hypothesis on `b` at
all — the statement is over `b : ℤ` but the proof uses only that the
seed rows partition each rung (`tableFrom_add_window`) and that the rung
sequence steps by `b` (`tableFrom_of_geometric`); no primality, no
positivity, no integrality is invoked. `lean/Chain.lean`, `C1`, needs
only `0 < b`. And `π(b^r) − π(b^(r−1))` is well defined for real
`b > 1`, with cells staying integers because π is integer-valued. So
the sub-integer arm is a computation the theory permits and nobody in
this project has ever run.

**What this prereg does not do.** It does not test the Nyquist claim.
`papers/Euler-Factor-Chain.md` H4, line 214: "Resolving `γ₁` requires
`b < exp(π/γ₁) = 1.2489` — which is D4 at `k = 0`." Six of the ten
sub-2 bases locked below sit at or under that threshold, so a reader
will be tempted to read a zero there as γ₁ resolution. This test
measures exact zeros of the prime difference table and nothing else;
`REFERENCES.md` and the D-series are cited to fix the base list, not to
license that reading. See § Vacuousness check.

## Primary hypothesis

**H0 — fineness.** Exact zeros arise at a per-resolved-cell rate that
does not fall as the sampling is refined. The ten sub-integer bases
locked below, taken together, produce resolved exact zeros at at least
base 2's per-resolved-cell rate over the same value range.

**H1 — intrinsic.** Base 2 is special in itself. The sub-integer bases
produce no resolved exact zeros at all.

**Predicted direction under H1: a deficit.** The point prediction under
H1 is `Z = 0`, against an H0 expectation of 299.822580645161 (see
§ H0 expected count).

The measured quantity is `Z`, the number of exact zeros at `d ≥ 1` in
the **resolved** stratum, pooled over the ten sub-integer bases.
Everything else in the run is either an integrity check or a diagnostic
that cannot move the verdict except through the `thin_rung_forced`
branch.

## The three complications, and how they are handled

These are stated before the parameter table because three locked
parameters exist only to answer them.

### (a) The pair identity is only approximate for non-integer b

`lean/PairIdentity.lean` proves
`prime(r,d) + composite(r,d) = (b−1)^(d+1)·b^(r−1−d)` in two halves.
`tableFrom_add_window` — linearity plus locality — is exact for **any**
seed rows and any `b`. `tableFrom_of_geometric` — the collapse to
`(b−1)^d` times the bottom entry — needs the rung sequence to step by
exactly `b`, i.e. needs the rung `(b^(r−1), b^r]` to hold exactly
`(b−1)·b^(r−1)` integers. For real `b` it holds `⌊b^r⌋ − ⌊b^(r−1)⌋`
instead, and the collapse fails.

So O44's `nu(b,r,d) = |cell| / [(b−1)^(d+1)·b^(r−1−d)]` is **not** the
right normalisation here and is not reused as such. This prereg locks
two totals and reports both:

```text
  total_geo(b,r,d)  = (b-1)^(d+1) * b^(r-1-d)          O44's denominator
  total_true(b,r,d) = sum_k (-1)^k C(d,k) W(r-k),
                      W(r) = floor(b^r) - floor(b^(r-1))
```

`total_true` is exact for every base, integer or not, because it is
`tableFrom_add_window` applied to the true rung populations; and for
integer `b` it equals `total_geo` identically. `total_geo` is reported
only so the drift is on the record.

The drift is not small. Computed at draft time from the rung
populations alone — no prime counting — at `b = exp(π/(2γ₁))`,
`V = 2^32`:

```text
    (r, d)          total_geo             total_true        ratio
   (199,  1)      4.44878e+07               44487817            1
   (199,  6)          572.615                    575        1.004
   (199, 12)      0.000775191                   -344   -4.438e+05
   (199, 20)      1.16092e-11                 -86804   -7.477e+15
   (199, 40)      3.18632e-31            17914188814    5.622e+40
```

9601 of that base's 19701 cells at `d ≥ 1` have `total_true ≤ 0`, which
`total_geo` — positive everywhere by construction — can never be. Past
about depth 10 the two quantities are not approximations of each other
in any sense.

### (b) Fair comparison is by value range, not by r

Base 2 at `r ≤ 32` reaches `2^32`. `b = 1.2489` needs `r = 99` to reach
the same value. So the bases are matched on a **value ceiling**
`V = 2^32`, and `r_max(b)` is the largest `r` with `b^r ≤ V` — locked
per base in the parameter table, not recomputed at run time.

A finer base has far more cells over the same range: 19701 at
`b = 1.11754` against 496 at `b = 2`. That is the fineness prediction
and it is also why raw zero counts are not comparable. **The comparable
quantity is zeros per cell**, and every count below is reported with
its denominator.

Matching on the value ceiling has a second consequence that the test
depends on: `ln(b^r) ≤ ln V = 22.180710` for every base at every rung,
so the prime density `1/ln x` entering any cell is bounded identically
across the whole base list. The comparison is density-matched by
construction rather than by correction.

### (c) `(b−1)^(d+1)` behaves differently below 2

`PairIdentity.coeff_eq_one_iff_base_two` proves `(b−1)^(d+1) = 1` iff
`b = 2`, for integer `b ≥ 2`. That theorem does not cover `1 < b < 2`,
and the arithmetic there is elementary and goes the other way: `b−1 < 1`,
so `(b−1)^(d+1)` **shrinks** with depth instead of staying 1 (b = 2) or
growing (b > 2). Writing `ρ = (b−1)/b`, the geometric total at the
ceiling is `V·ρ^(d+1)`, and it falls below 1 at:

```text
  b = 1.11754051933  rho = 0.105178   total_geo < 1 from d = 9
  b = 1.24889681235  rho = 0.199293   total_geo < 1 from d = 13
  b = 1.39569279226  rho = 0.283510   total_geo < 1 from d = 17
  b = 1.55974324789  rho = 0.358869   total_geo < 1 from d = 21
```

against supports that run to `d = 198, 98, 65, 48`. Read naively that
is O43's magnitude floor in reverse: cells so small that a zero is
arithmetically forced rather than a cancellation, over most of the
support.

**Read naively it is also wrong, and (a) is why.** `total_geo` is not
the size of anything at a non-integer base. The true total carries the
floor jaggedness of `⌊b^r⌋`, which is `O(1)` per rung and is amplified
by the stencil's L1 weight `2^d`; the table above shows `total_true`
at `(199,20)` is `−86804` where `total_geo` is `1.2e−11`. Deep cells at
sub-integer bases are **not** small. The reverse magnitude floor, in
the form O43 met it, does not apply.

What *does* apply, and is the real confound, is coarseness at low `r`.
For `b = 1.11754`, `⌊b^r⌋ = 1` for `r = 0…6` — the first six rungs hold
no integers at all — so `N(r) = 0` there and `cell(2,1) = N(2) − N(1) =
0` exactly, a zero that is about the rung being empty and nothing else.
Every sub-2 base has such a region. Two locked parameters answer it:

1. **The resolved stratum.** A cell counts only if every rung its
   stencil reads is expected to hold at least one prime:
   `W(r')/ln(b^(r')) ≥ 1` for all `r' ∈ [r−d, r]`. Because thickness is
   monotone in `r`, this is `r − d ≥ r_thick(b)` with `r_thick` locked
   per base. It is pure geometry — no prime is counted to evaluate it —
   so the resolved-cell counts are locked before the run.
   At `b = 2` the criterion is satisfied over the **entire** support:
   `min_r W(r)/ln(2^r) = 2^(r−1)/(r ln 2) = 1.4426950408889634`, so
   `r_thick(2) = 1`, all 496 cells resolved, all four zeros kept. That
   is one more sense in which base 2 is the boundary case.

2. **The mass floor.** `S(r,d) = Σ_k C(d,k)·N(r−k)`, the unsigned prime
   mass the alternating sum cancels. `|cell(r,d)| ≤ S(r,d)` exactly, so
   a cell with `S < 1` has a zero **forced**; this is a hard bound, not
   a model, exactly as `near_miss_bound` was in
   `preregs/extended_zero_census_v1_locked_20260818.md`. `S` is
   reported at every zero found and the `thin_rung_forced` branch below
   is keyed on it.

### (d) A third outcome exists

Sub-2 bases might produce zeros only at the optimal-base family and not
at arbitrary sub-2 bases. That is neither fineness nor intrinsic, so
the base list carries **non-family controls in the same range** and the
decision rule carries the labels `family_only` and `refinement_only`.
See the parameter table for which bases are controls and why.

## H0 expected count (stated as a number, before the run)

Support rule: `d ≥ 1`, `1 ≤ d ≤ r−1`, `2 ≤ r ≤ r_max(b)`. Resolved
sub-stratum: additionally `r − d ≥ r_thick(b)`. Both counts are pure
geometry and were computed at draft time from `⌊b^r⌋` alone.

| arm | base | r_max | cells (d ≥ 1) | r_thick | resolved cells |
| --- | --- | --- | --- | --- | --- |
| reference | 2 | 32 | 496 | 1 | **496** |
| family k=1 | exp(π·1/(2γ₁)) | 199 | 19701 | 32 | 14028 |
| family k=2 | exp(π·2/(2γ₁)) | 99 | 4851 | 12 | 3828 |
| family k=3 | exp(π·3/(2γ₁)) | 66 | 2145 | 7 | 1770 |
| family k=4 | exp(π·4/(2γ₁)) | 49 | 1176 | 4 | 1035 |
| antiphase k=1 | exp(π·3/(4γ₁)) | 133 | 8778 | 20 | 6441 |
| antiphase k=2 | exp(π·5/(4γ₁)) | 79 | 3081 | 8 | 2556 |
| antiphase k=3 | exp(π·7/(4γ₁)) | 57 | 1596 | 5 | 1378 |
| antiphase k=4 | exp(π·9/(4γ₁)) | 44 | 946 | 3 | 861 |
| refinement | 2^(1/2) | 64 | 2016 | 6 | 1711 |
| refinement | 2^(1/3) | 96 | 4560 | 12 | 3570 |

```text
  C_2    = 496            resolved cells, base 2
  C_sub  = 37178          resolved cells, ten sub-2 bases pooled
           = 20661 family
           + 11236 antiphase   (6441 + 2556 + 1378 + 861)
           +  5281 refinement  (1711 + 3570)
           = 20661 family + 16517 non-family
  Z_2    = 4              base 2's exact zeros, all four resolved
```

The non-family arm holds **16517** resolved cells against the family
arm's 20661. Both arms are populated, which is what the `family_only`
branch needs in order not to be an artefact of the controls having had
no chance.

**H0 expected count:**

```text
  E[Z]  =  Z_2 * C_sub / C_2  =  4 * 37178 / 496  =  299.822580645161
```

## Locked parameters

No parameter may be added, removed, or re-valued after lock. No
`--seed` flag is added; this test uses no randomness at all (see
`randomness` below), so there is no seed to hide.

| parameter | locked value | why this value |
| --- | --- | --- |
| `value_ceiling` (V) | **2^32 = 4294967296** | Base 2's extent in the measurement this follows from: `results/cross_base_zero_scan.json` → `summary.per_base[0].max_regime` = 32. Bases are matched on the value they reach, not on r — complication (b). |
| `gamma_1` (γ₁) | **14.134725141734693** | `REFERENCES.md` § Constants, "γ₁ 14.134725141734693". The base list is defined by this decimal, not by the true zero, so the bases are exactly reproducible. |
| `reference_base` | **2** | Run through the identical code path at the same value ceiling. It is the reference point, and its failure to reproduce is a `compromised` trip, not a result. |
| `family_bases` | **exp(π·k/(2γ₁)) for k = 1,2,3,4** = 1.11754051933074841023, 1.248896812346038861164, 1.395692792259708511724, 1.559743247888097005191 | The optimal-base family: `γ₁·ln b = πk/2`, i.e. k quarter-turns of winding per rung. Member k = 2 is D4 at k = 0, `papers/Euler-Factor-Chain.md` line 87 ("1.2489") and line 214. Complication (d) is about this family and no other. |
| `family_bases_excluded` | **k = 5 (1.74329…) and k = 6 (1.94836…)** | Sub-2 family members deliberately left out. `papers/Euler-Factor-Chain.md` D5, line 96: "b = 2 lies 2.7% from 1.948". A zero at k = 6 could not be attributed to family membership rather than to proximity to base 2, and the controls are chosen to interleave in [1.1175, 1.6489], which k = 5,6 sit above. |
| `antiphase_control_bases` | **exp(π(2k+1)/(4γ₁)) for k = 1,2,3,4** = 1.181394427047846079234, 1.32025614153750187382, 1.475439734063429921943, 1.64886368664646680032 | Non-family controls, interleaved one between each pair of consecutive family members. They sit at `γ₁·ln b = π(2k+1)/4`, i.e. exactly half a quarter-turn off the family — maximally far from it in the coordinate the family is defined in. They are controls because they are the same kind of object (sub-2, transcendental, in the same range) differing only in winding angle. |
| `refinement_control_bases` | **2^(1/2) = 1.414213562373095048802 and 2^(1/3) = 1.259921049894873164767** | Non-family controls of a second kind, and the sharpest available test of the fineness account: `(2^(1/m))^(mr) = 2^r`, so base 2 is a literal sub-sampling of each, in the same sense that bases 4 and 8 are sub-samplings of base 2. If fineness is what selects base 2, these two should do at least as well. Their winding angles, 280.676° and 187.117°, are off the quarter-turn lattice, so they are non-family. |
| `refinement_proximity_disclosure` | **2^(1/3) = 1.25992 sits 0.88% from family k = 2 = 1.24890; 187.117° against 180°** | Disclosed rather than avoided. Two distinct bases with distinct tables; if k = 2 gives resolved zeros and 2^(1/3) does not, that is an extremely sharp fact, and if both do, family membership is not the driver. |
| `bases_total` | **11** (1 reference + 4 family + 4 antiphase + 2 refinement) | Full list; no base is added or dropped after lock. |
| `convention` | **This project's: 2 and 3 counted as primes, π(1) = 0, `N(r) = π(⌊b^r⌋) − π(⌊b^(r−1)⌋)` on the half-open rung `(b^(r−1), b^r]`, `⌊b^0⌋ = 1`** | `CONTEXT.md` § Core quantities: "N(r) = π(2ʳ) − π(2ʳ⁻¹) — primes in the dyadic interval (2ʳ⁻¹, 2ʳ]". **Explicitly not** the imported lattice_mapper convention (2 and 3 excluded as lattice), which `CONTEXT.md` § `imported/lattice_mapper/` records as not comparable at low r. Stated in the console output and in the results JSON at `constants.convention`. |
| `pi_backend` | **`primecountpy.prime_pi`, primecountpy 0.2.1** | `REFERENCES.md` § Packages, "primecountpy 0.2.1 — π(2ⁿ) cache, primary". Confirmed installed and exact at draft time: `prime_pi(4294967296) = 203280221`, equal to `pi2n_cache.json["32"]`. π must be exact; no approximation is admissible anywhere in this test. |
| `pi_backend_fallback` | **`sympy.primepi`, sympy 1.14.0**, used only if the primary import fails; the backend actually used is recorded in the results JSON | `REFERENCES.md` § Packages, "sympy 1.14.0 — π(2ⁿ) cache, fallback". Same fallback order as the caches in `CONTEXT.md` § Caches. |
| `pi_audit_set` | **π at 2^n for n = 0…32, compared against every corresponding entry of `pi2n_cache.json`, exact integer equality — 33 comparisons** | The backend is checked against this project's own cache before any table is built. Any mismatch trips `compromised`. |
| `dps` | **60** (mpmath) | Precision for `⌊b^r⌋` at the eight transcendental bases. The smallest observed relative distance of any `b^r` to an integer over the whole locked support is 1.665e−12 (antiphase k = 1 and k = 2), which is 48 orders of magnitude above the dps-60 floor. |
| `floor_method_transcendental` | **`int(mpmath.floor(b**r))` at dps 60** | Applies to the four family and four antiphase bases. |
| `floor_method_refinement` | **exact integer `m`-th root of `2^r`**, no floating point | `⌊(2^(1/m))^r⌋ = ⌊2^(r/m)⌋` is computed by integer Newton iteration on `2^r`. Required, not cosmetic: at `r ≡ 0 mod m` the value is an exact integer and a floating-point floor lands on the wrong side. It is also why `r_max(2^(1/2)) = 64` and not 63. |
| `floor_determinacy_threshold` | **1e−30 relative**; a transcendental base whose `b^r` lies within that of an integer trips `compromised` | dps 60 determines the floor to ~1e−60 relative, and the γ₁ decimal's own truncation moves `b^r` by at most ~2e−16 relative at `r = 199`. The threshold sits between the two. Refinement bases are exempt: their exact integers are the point. |
| `d_min` | **1** | `results/O44_cross_base_zero_scan_run1.log` counts zeros at `d >= 1`; depth-0 cells are the seed row, not a difference. |
| `resolved_criterion` | **`W(r')/ln(b^(r')) ≥ 1` for every `r' ∈ [r−d, r]`, with `W(r) = ⌊b^r⌋ − ⌊b^(r−1)⌋`; equivalently `r − d ≥ r_thick(b)`** | Every rung the stencil reads is expected to hold at least one prime. Pure geometry, so it is locked before the run rather than estimated from the data. Complication (c). |
| `r_thick` | **2 → 1; family k=1..4 → 32, 12, 7, 4; antiphase k=1..4 → 20, 8, 5, 3; 2^(1/2) → 6; 2^(1/3) → 12** | Computed at draft time from `⌊b^r⌋`; recomputed at run time and any disagreement trips `compromised`. |
| `r_max` | **2 → 32; family → 199, 99, 66, 49; antiphase → 133, 79, 57, 44; 2^(1/2) → 64; 2^(1/3) → 96** | Largest `r` with `b^r ≤ V`. Locked so precision cannot move the support. Recomputed at run time; disagreement trips `compromised`. |
| `cells_at_d_ge_1` | **496; 19701, 4851, 2145, 1176; 8778, 3081, 1596, 946; 2016, 4560** | `Σ_{r=2}^{r_max}(r−1)`. Reported explicitly per base, per complication (b). |
| `resolved_cells` | **496; 14028, 3828, 1770, 1035; 6441, 2556, 1378, 861; 1711, 3570** | Table in § H0 expected count. |
| `C_2` | **496** | Base 2's resolved cells — its entire support. |
| `C_sub` | **37178** | Pooled sub-2 resolved cells, = 20661 family + 16517 non-family. |
| `Z_2` | **4** | Base 2's exact zeros at `d ≥ 1`, `r ≤ 32`, all four resolved. Rebuilt at draft time from `pi2n_cache.json`: `[(2,1), (4,1), (8,3), (20,6)]` and no others in 496 cells. Same set as `lean/Zeros.lean` `measured_zeros`, `lean/PairIdentity.lean` `zero_cells`, and `results/O16_run2.log` § EXACT ZEROS. |
| `E_Z_H0` | **299.822580645161** | `4 × 37178 / 496`. |
| `normalisation_primary` | **`nu_pair = \|cell\| / \|total_true\|`**, exact `Fraction`; undefined where `total_true = 0` and recorded as `null` with a per-base count | The exact analogue of O44's `nu` under the half of the pair identity that survives a non-integer base — complication (a). Every ranking is on the exact value. |
| `normalisation_reported` | **`nu_geo = \|cell\| / total_geo`** (O44's formula) **and `nu_mass = \|cell\| / S`** (bounded in [0,1], zero exactly at a zero) | `nu_geo` is reported **only** so the drift documented in (a) is on the record; nothing keys on it. `nu_mass` is reported because it is the only one of the three bounded across bases and depths. |
| `mass_floor` | **88** | `S(8,3) = Σ_k C(3,k)·N(8−k) = 23 + 3·13 + 3·7 + 5 = 88`, the prime stencil mass at base 2's shallowest zero below depth 1, computed at draft time from `pi2n_cache.json`. Base 2's four zeros carry `S = 2, 4, 88, 492384`. A sub-2 zero clearing 88 cancels at least as much prime mass as base 2's (8,3) does. |
| `mass_bound` | **`\|cell(r,d)\| ≤ S(r,d)` exactly, for every base and cell** | Not a model and not an approximation: the alternating sum cannot exceed the unsigned sum. This is what makes the mass floor a hard bound, in the same sense as `near_miss_bound` in `preregs/extended_zero_census_v1_locked_20260818.md`. |
| `null_primary` | **constant per-resolved-cell rate**: each resolved `d ≥ 1` cell, at base 2 or at any sub-2 base, is an independent Bernoulli zero with one unknown probability q | H0 stated as a probability model. It is the literal content of "the rate does not fall as the sampling is refined". |
| `test_primary` | **exact conditional binomial.** Conditional on `T = 4 + Z` over the combined 37674 resolved cells, `Z \| T ~ Binomial(T, C_sub/(C_2+C_sub))`. One-sided p for a sub-2 deficit: `p = P(K ≤ Z \| T)` | Exact, and q drops out — no nuisance parameter is estimated and reused. `C_2/(C_2+C_sub) = 0.013165578382969688`. |
| `test_secondary_poisson` | **`p_pois = P(K ≤ Z)`, `K ~ Poisson(299.822580645161)`** | Reported always; **cannot** change the verdict. It treats base 2's rate as known without error, which it is not — the whole rate estimate rests on four events. |
| `alpha_level` | **0.05**, one-sided (a sub-2 deficit is the alternative) | House level, matching `preregs/alpha_depth_trend_v1_locked_20260814.md`, `preregs/zero_winding_phase_v1_locked_20260818.md` and `preregs/extended_zero_census_v1_locked_20260818.md`. |
| `top_k` | **10** | Ten smallest `nu_pair` per base, matching O44's `--top-k 10`. Diagnostic only. |
| `randomness` | **none.** No Monte Carlo, no permutation, no resampling anywhere | Both p-values are closed-form. There is no `--seed` flag because there is nothing to seed; `REFERENCES.md` § Constants records seed 2026 for tests that need one. |
| `arithmetic` | **exact Python `int` for every cell, every `W`, every `total_true` and every `S`; exact `fractions.Fraction` for every `nu` used in a ranking; mpmath at dps 60 only to obtain `⌊b^r⌋`; float only for the two p-values, `ln`, and printed values** | Same discipline as O44 ("numpy is not imported ... floats appear only in s and in the printed value of nu, never in a ranking"). At `(199,198)` the stencil coefficients alone exceed anything a float64 can hold. |
| `writes` | **`results/sub_integer_base_scan.json` and `results/O45_sub_integer_base_scan_run1.log`** | Nothing else. `pi2n_cache.json` is read and not written. Nothing under `imported/`, `files (2)/`, `lean/` or `preregs/` is opened for writing. No existing script is modified. |

## Primary statistic

```text
  Z  =  #{ (b,r,d) : b in the ten sub-2 bases,
                     1 <= d <= r-1,  2 <= r <= r_max(b),
                     r - d >= r_thick(b),
                     cell(b,r,d) = 0 }
```

with `cell(r,0) = N(r) = π(⌊b^r⌋) − π(⌊b^(r−1)⌋)` and
`cell(r,d) = cell(r,d−1) − cell(r−1,d−1)`, exact integers throughout.

Reported with it: the full zero list per base as `(r,d)` with `S`,
`total_true`, `total_geo`, `nu_pair`, `nu_mass`; zeros per cell and
zeros per resolved cell per base; `E[Z]`; the conditional-binomial p;
the Poisson p; and the split `Z_family` / `Z_antiphase` /
`Z_refinement`.

## The checks, in the order they are reported

**Check 1 — π backend integrity. Reported first.** π at `2^n` for
`n = 0…32` against all 33 corresponding entries of `pi2n_cache.json`,
exact integer equality, including `π(2^32) = 203280221`. Any mismatch
trips `compromised` and the run stops before any table is built. This
is cheap and it is the only thing standing between a backend
misconfiguration and 49346 wrong cells.

**Check 2 — geometry integrity.** For every base, the run recomputes
`r_max`, `cells_at_d_ge_1`, `r_thick` and `resolved_cells` and compares
them to the locked table, and records the minimum relative distance of
`b^r` to an integer over `r = 1…r_max`. Any disagreement, or a
determinacy failure at a transcendental base, trips `compromised`.
The support is a locked parameter; it does not get to move.

**Check 3 — base-2 reproduction.** Base 2 is built by the identical
code path at the same value ceiling. The exact zeros at `d ≥ 1`,
`r ≤ 32` must be exactly `{(2,1), (4,1), (8,3), (20,6)}`, no more and
no fewer, and 496 cells must be counted. Failure trips `compromised`.
This is a **reproduction check, not evidence** — see § Provenance
disclosure item 1 — and must never be reported as a confirmation.

**Check 4 — the sub-integer scan.** Per base: value ceiling, `r_max`,
cell count at `d ≥ 1`, resolved cell count, the full exact-zero list
with coordinates, zeros per cell and per resolved cell, the minimum
`nu_pair` and where, and the ten smallest `nu_pair`. Reported per base
and never merged with base 2's four.

**Check 5 — the rate test.** `Z`, `E[Z]`, the conditional-binomial p,
the Poisson p, and the family / antiphase / refinement split.

**Check 6 — the mass profile (diagnostic; cannot change the verdict
except through the `thin_rung_forced` branch).** `S` at every zero
found, at every base including base 2, and the count of resolved sub-2
zeros with `S ≥ 88`. Base 2's profile is already known and is stated in
§ Provenance disclosure; the sub-2 half is blind.

## Decision rule (locked before data)

Verdict labels are used verbatim in the writeup and in the Run record.
`Z` is the primary statistic; `p` the conditional-binomial p from
`test_primary`; and `Z*` the sub-set of resolved sub-2 zeros with
`S ≥ mass_floor` (88), split as `Z*_family`, `Z*_antiphase`,
`Z*_refinement`.

- `compromised` — any of: the π backend unavailable, or any of the 33
  audit comparisons unequal; π non-integer, negative, or not
  non-decreasing on the audit set; any recomputed `r_max`,
  `cells_at_d_ge_1`, `r_thick` or `resolved_cells` differing from the
  locked table; a floor-determinacy failure at a transcendental base;
  a refinement base whose floors disagree with the exact integer roots;
  or the base-2 zero set at `d ≥ 1`, `r ≤ 32` differing from
  `{(2,1), (4,1), (8,3), (20,6)}`.
  → The test ran but the instrument is corrupt for reasons unrelated to
    the hypothesis. No verdict, and no count is reported as a number.

- `thin_rung_forced` — `Z ≥ 1` **AND** `Z* = 0`.
  → The sub-integer bases do produce resolved exact zeros, but not one
    of them cancels as much prime mass as base 2's (8,3) does. By
    `mass_bound` these are cancellations of small quantities. The
    surplus is arithmetic coarseness at the thin end of the resolved
    stratum, not resolution, and this test **cannot** separate that
    reading from a weak fineness effect. That non-separation is a
    stated limitation, not a hedge.

- `family_only` — `Z* ≥ 1` **AND** `Z*_family ≥ 1` **AND**
  `Z*_antiphase = 0` **AND** `Z*_refinement = 0`.
  → Mass-clearing zeros appear only at `exp(πk/(2γ₁))`. Neither
    fineness nor intrinsic: the winding angle is what selects a base,
    not how fine it is and not base 2 itself. The controls had
    16517 resolved cells against the family's 20661, so this is not the
    controls having had no chance.

- `refinement_only` — `Z* ≥ 1` **AND** `Z*_refinement ≥ 1` **AND**
  `Z*_family = 0` **AND** `Z*_antiphase = 0`.
  → Mass-clearing zeros appear only at `2^(1/2)` and `2^(1/3)`, the two
    bases of which base 2 is a literal sub-sampling. That is the
    fineness account in its narrow form — it is base 2's grid that
    matters, refined — and not fineness in general.

- `fineness` — `Z* ≥ 1`, not `family_only`, not `refinement_only`,
  **AND** `p > alpha_level`.
  → H0 is not falsified. Sub-integer bases produce mass-clearing
    resolved zeros at a rate base 2's rate can account for, across both
    the family and the controls. "Base 2 is the only base with zeros"
    was a statement about where the integer lattice stops.

- `rate_below_base_two` — `Z* ≥ 1`, not `family_only`, not
  `refinement_only`, **AND** `p ≤ alpha_level`.
  → Both accounts are falsified. The sub-integer bases are not empty,
    so base 2 is not special in itself; but their per-cell rate is
    significantly below base 2's, so finer is not better either. A real
    outcome and the one this design would find hardest to have
    predicted.

- `intrinsic_base_two` — `Z = 0`.
  → Not one exact zero at `d ≥ 1` in 37178 resolved cells across ten
    sub-integer bases — family and control, from 1.1175 to 1.6489,
    including the two bases of which base 2 is a literal sub-sampling —
    against 4 in base 2's 496 over the same value range. `p` is
    3.004414e−08 by construction at `Z = 0`, well inside
    `alpha_level`. H0 is falsified in the deficit direction. Base 2 is
    special in itself, at least as far as exact zeros go, and fineness
    does not explain it.

- `ambiguous` — any combination not matched above. Under the
  definitions the branches are exhaustive (`Z = 0`, or `Z ≥ 1` with
  `Z* = 0`, or `Z* ≥ 1` split three ways by arm and then by `p`), so
  this branch exists to make the rule total rather than because it is
  expected.
  → The data does not discriminate. Design a sharper test. A real
    outcome, not a deferral.

Precedence: `compromised` > `thin_rung_forced` > `family_only` >
`refinement_only` > `fineness` > `rate_below_base_two` >
`intrinsic_base_two` > `ambiguous`.

`thin_rung_forced` precedes every substantive branch deliberately: it
is the conservative reading of any sub-2 zero, and no partition of
zeros into arms, and no rate comparison, is worth making until the
zeros being partitioned have cleared the mass floor.

## Falsification

H0 (fineness) is falsified by `intrinsic_base_two` and by
`rate_below_base_two`.

H1 (intrinsic) is falsified by `fineness`, by `refinement_only`, by
`rate_below_base_two`, and by `family_only`.

`thin_rung_forced` falsifies neither. It is consistent with a weak
fineness effect and with sub-2 tables that are simply coarse at the
bottom of the resolved stratum, and the writeup must say so rather than
reading it either way.

`intrinsic_base_two` does not explain base 2. It removes fineness as
the explanation over the range 1.1175 ≤ b < 2 at V = 2^32 and nothing
more. `lean/Zeros.lean` is explicit that "Nothing below predicts r = 20
or d = 6, and nothing below could"; that hole does not close here.

## Vacuousness check

**Both directions are reachable, and the pre-computed p-table says so.**
`q = C_2/(C_2+C_sub) = 0.013165578382969688`, `T = 4 + Z`:

```text
   Z      T      conditional-binomial p      Poisson p (lam = 299.8226)
   0      4            3.004414e-08              6.147629e-131
   1      5            1.486385e-07              1.849346e-128
   2      6            4.412210e-07              2.781656e-126
   5      9            3.590530e-06              1.262196e-120
  10     14            2.705840e-05              1.028653e-112
  25     29            5.484112e-04               3.608608e-94
  50     54            5.629546e-03               1.689421e-71
  75     79            2.068719e-02               1.920035e-54
 100    104            4.913813e-02               4.789467e-41
 101    105            5.057280e-02               1.428853e-40
 110    114            6.450157e-02               1.738126e-36
 150    154            1.466872e-01               7.243237e-22
 200    204            2.823114e-01               6.352793e-10
```

The smallest `Z` at which `p > 0.05` is **101**. So `fineness` needs
101 mass-clearing resolved zeros out of 37178 resolved cells — a third
of H0's own point prediction of 299.8 — and `intrinsic_base_two` needs
none at all. Every value of `Z` from 0 to 37178 selects some branch and
the rule is total.

**Firing toward H0 is not a formality.** Base 2 carries 4 zeros in 496
cells, a rate of 8.06e−3. At that rate the ten sub-2 bases would carry
about 300. Only 101 are needed. If fineness is right by even a third,
the run says so.

**Firing toward H1 is reachable and is not obviously the sober
expectation either.** The one clean prior data point is base 3: 0 zeros
in 496 cells at the same regime ceiling as base 2, `results/O44_cross_base_zero_scan_run1.log`
§ 1. Bases 4–9 are extent-censored and add nothing. Base 3 is
consistent with both accounts — it is coarser than base 2, so fineness
predicts it empty too — so it does not tilt the prior.

**The Nyquist objection, head-on.** Six of the ten sub-2 bases sit at
or below `exp(π/γ₁) = 1.2489`, the threshold `papers/Euler-Factor-Chain.md`
H4 (line 214) gives for resolving γ₁, and the family is defined by γ₁.
A reader will want to say that a zero at those bases *is* γ₁ being
resolved. This prereg does not license that. H4 is a statement about
Nyquist sampling of `log x` at step `log b`; the statistic here is the
exact vanishing of an integer alternating sum. `papers/Euler-Factor-Chain.md`
J2 records that "The non-integer bases of D4 — 1.2489, 1.948, 3.039 —
are constructible and have never been built", and calls its own
prediction for them `untested`. The `family_only` branch exists so that
a family-selective result gets a label instead of a story, and even
`family_only` is written as "the winding angle selects a base", not as
"γ₁ was resolved".

**The confound of complication (c), with numbers, and what it does and
does not force.** For `b < 2` the geometric total collapses: at
`b = 1.11754`, `total_geo` at the value ceiling drops below 1 from
`d = 9` of a support running to `d = 198`. If that were the size of the
cells, essentially the whole sub-2 support would be zeros forced by
arithmetic and the run would be worthless. It is not the size of the
cells: at `(199,20)` that base's `total_geo` is 1.16e−11 while its
exact `total_true` is −86804, and 9601 of its 19701 cells have
`total_true ≤ 0`, which a positive geometric quantity cannot do. Floor
jaggedness is `O(1)` per rung and the stencil's L1 weight is `2^d`, so
deep cells at a sub-integer base are large, not small. **The reverse
magnitude floor, in the form O43 met it, does not apply**, and the
resolved stratum is not thin: 37178 cells against base 2's 496.

The confound that *is* real is coarseness at low `r`. For
`b = 1.11754` the first six rungs hold no integers at all
(`⌊b^r⌋ = 1` for `r = 0…6`), so `N(r) = 0` there and `cell(2,1) = 0`
exactly — a zero about an empty rung and nothing else. Every sub-2 base
has such a region, so **`Z_full ≥ 1` is essentially guaranteed** and
"sub-integer bases stay empty" is false on the full support before the
run starts. That is precisely why the primary statistic is the resolved
count and not the full count, why `resolved_criterion` demands at least
one expected prime in every rung the stencil reads, and why
`thin_rung_forced` is a locked verdict label with its own criterion
rather than a paragraph of hedging appended to a `fineness` result.

**Where the design is weakest, stated before the run.**

1. **Resolved cells are not independent.** Cells at neighbouring `r`
   share most of their stencil window, and a finer base's cells overlap
   more than base 2's. `null_primary` assumes independence, so the
   conditional-binomial p is anti-conservative **against** H0 — it will
   reject fineness more readily than an honest correlation-aware test
   would. There is no correction for this and none is invented after
   the fact; it is why `rate_below_base_two` is written as a real
   outcome rather than as evidence for H1.
2. **`Z_2 = 4` is the whole rate estimate.** Same weakness the census
   prereg named. The Poisson secondary, which pretends the rate is
   known exactly, is reported and cannot move the verdict.
3. **The value ceiling is a cache boundary, not a structural one.**
   `V = 2^32` is where O44's imported base-2 table stops, not where
   anything ends. `primecountpy` would go further at a cost; nothing in
   the fork under test says the answer cannot change at `2^40`.

## Provenance disclosure (required reading)

1. **Base 2's four zeros are not blind, exhaustively so.** `(2,1)`,
   `(4,1)`, `(8,3)`, `(20,6)` have been inspected by Julian and by
   assistants across many sessions. They appear in `CONTEXT.md`, in
   `results/O16_run2.log`, in
   `results/O16_centered_difference_table_run2.json`, in
   `results/cross_base_zero_scan.json`, in `lean/Zeros.lean`
   (`measured_zeros`), in `lean/PairIdentity.lean` (`zero_cells`), and
   in `O42_zero_winding_phase.py` as `LOCKED_ZEROS`. Check 3 is a
   reproduction check, not evidence.

2. **Base 2's mass profile is not blind either, and the mass floor is
   calibrated on it.** While drafting, the assistant rebuilt base 2's
   table from `pi2n_cache.json` and computed `S` at the four zeros:
   `S(2,1) = 2`, `S(4,1) = 4`, `S(8,3) = 88`, `S(20,6) = 492384`.
   `mass_floor = 88` was chosen with those four numbers in view. The
   threshold is therefore **calibrated on inspected data** and only its
   application to the sub-2 bases is blind. The same rebuild confirmed
   the zero set over `r ≤ 32`, `d ≥ 1` is exactly the four and that the
   support holds 496 cells.

3. **O44's results have been read in full.** `results/cross_base_zero_scan.json`
   and `results/O44_cross_base_zero_scan_run1.log` were read while
   drafting, including every per-base `nu` table. The 4-in-496 /
   0-in-496 contrast that motivates this test is inspected data.

4. **No sub-integer base has ever been computed in this project, by
   anyone.** Not by Julian, not by any assistant, not by any prior
   agent. Nothing in `results/`, in `papers/`, in `imported/`, in
   `files (2)/` or in any cache contains `π` at a non-integer power.
   `papers/Euler-Factor-Chain.md` J2 says so in its own words: the
   non-integer bases "are constructible and have never been built".
   **This is the genuinely blind arm.**

   To keep it that way the drafting agent computed **no sub-integer
   prime table and evaluated π at no sub-integer argument**. What was
   computed is disclosed in full in item 5.

5. **What the drafting agent did compute at sub-integer bases, and why
   it does not touch the blind arm.** Every locked geometric quantity —
   `r_max`, `cells_at_d_ge_1`, `W(r) = ⌊b^r⌋ − ⌊b^(r−1)⌋`, `r_thick`,
   `resolved_cells`, `total_true`, `total_geo`, the near-integer
   distances, and the (a) and (c) tables above — was computed from
   `⌊b^r⌋` alone. That is integer geometry: it involves no prime
   counting, no π evaluation, and cannot reveal where a zero of the
   prime table is. A prereg that did not state `C_sub` could not state
   its own p-table, which is the same reason
   `preregs/extended_zero_census_v1_locked_20260818.md` derived 1891 /
   4186 / 2295 in its own text.

   One further fact was worked out by hand and is disclosed because it
   shapes the design: for `b = exp(π/(2γ₁))`, `⌊b^r⌋ = 1` for
   `r = 0…6`, so under this project's convention (`π(1) = 0`)
   `N(r) = 0` for `r ≤ 6` and `cell(2,1) = 0`. This uses only
   `π(1) = 0`, which is the convention itself. It is why the primary
   statistic is the resolved count.

6. **The π backend was exercised once, at base 2 only.**
   `primecountpy.prime_pi(4294967296) = 203280221` was run while
   drafting to confirm the package is installed and exact against
   `pi2n_cache.json["32"]`. That argument is `2^32`; no sub-integer
   argument was passed.

7. **The base list was fixed before any of the geometry was computed**,
   from `papers/Euler-Factor-Chain.md` D4/D5 and the quarter-turn
   family, and was not adjusted afterwards. The two exclusions
   (family k = 5, 6) are stated in the parameter table with their
   reason. `mass_floor` and `resolved_criterion` were fixed after the
   base-2 rebuild — see items 2 and 5 — and their calibration data is
   disclosed there.

## What is varied / held fixed

Varied: the base, from 2 down to ten sub-integer values in
[1.1175, 1.6489] — that is the whole intervention.

Held fixed: the value ceiling `V = 2^32`, the convention (2 and 3
counted, `π(1) = 0`), the backward-difference construction, the support
rule, the `d ≥ 1` restriction, the zero criterion (exact integer
equality with 0), the resolved criterion, the mass floor, alpha, and
both null models. No existing script is modified. `pi2n_cache.json` is
read and not written. `results/cross_base_zero_scan.json` is read and
not written. Nothing under `imported/`, `files (2)/`, `lean/` or
`preregs/` is written.

## Compute

Minutes at most. About 929 evaluations of π at arguments `≤ 2^32` via
`primecountpy` (each milliseconds at that size); 49346 cells at
`d ≥ 1` across eleven bases, all exact Python integers; two closed-form
p-values; mpmath at dps 60 only for `⌊b^r⌋`. No Monte Carlo, no
network, no fetched input. Artifact well under 10 MB.

## Reproducibility

Deterministic, with no external dependency at all — no network fetch,
no b-file, nothing but the locked parameters and the π backend.
Re-running at identical parameters must reproduce byte-identical
results apart from `generated_utc` and the two run timestamps. The
backend actually used, and its version, go into the results JSON; a run
that falls back to `sympy.primepi` must still produce identical numbers
because both are exact. There is no seed because there is no
randomness.

## Analyzer

`O45_sub_integer_base_scan.py`, at the project root. Written
2026-08-18, before this prereg was locked and before any run. Cited
here by path per the naming convention in `CLAUDE.md` — do not rename
it.

Results: `results/sub_integer_base_scan.json`.
Log: `results/O45_sub_integer_base_scan_run1.log`.

## Lock chain

- `lock_written_at`: 2026-08-19T07:16:07Z
- `pre_compute_sha256`: PENDING
- `locked_by`: julian

## Run record

Appended after the run.

- `run_start_at`: 2026-08-19T07:16:38Z
- `run_end_at`: 2026-08-19T07:16:38Z
- `verdict`:
- `post_compute_sha256`: `7985c94015bab8d8f2e606b69aaeac79150ccec1d4ec9d04bca7db177c02aaf5`
- sidecar match: **yes** — identical to the sidecar
  `sub_integer_base_scan_v1_20260818.sha256`, so no parameter,
  hypothesis, or decision-rule text drifted between lock and compute.
- analyzer: `O45_sub_integer_base_scan.py`, one run at the locked flags
- results: `results/sub_integer_base_scan.json`
- log: `results/O45_sub_integer_base_scan_run1.log`
