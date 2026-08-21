# Prereg — extended exact-zero census to r = 92, is "exactly four" a property of the table or of the cache? (v1)

STATUS: **LOCKED**

## Background

The backward, unit-weighted, prime-side dyadic difference table has
exactly four exact zeros over its whole computed support. Read from
`results/O16_run2.log` § "EXACT ZEROS (depth >= 1), all four tables",
lines 165–171:

```text
  backward_prime:  4 zero(s)
    (r= 2, d= 1)  partner[backward_composite]=1  2^(r-d-1)=1  r-2d=0  r-d=1
    (r= 4, d= 1)  partner[backward_composite]=4  2^(r-d-1)=4  r-2d=2  r-d=3
    (r= 8, d= 3)  partner[backward_composite]=16  2^(r-d-1)=16  r-2d=2  r-d=5
    (r=20, d= 6)  partner[backward_composite]=8192  2^(r-d-1)=8192  r-2d=8  r-d=14
```

Same file, § "TABLE EXTENTS", lines 54–58, records the backward-prime
table as **1953 cells, max r 62, max depth 61**. The same four cells
appear in `results/O16_centered_difference_table_run2.json` at
`constants.documented_backward_zeros`, and `O27` reproduced exactly
`{(2,1),(4,1),(8,3),(20,6)}` from an independent construction
(`CONTEXT.md` § Current state of the world, O27 entry).

**r ≤ 62 is not a structural limit.** It is where the cache stops.
`CONTEXT.md` § Caches: "`pi2n_cache.json` — π(2ⁿ) for n = 0…62,
**63 entries**". `O16_centered_difference_table.py` takes `R` from the
cache's own maximum n (`main()`, `R_full = max(r_avail)`), so the census
ceiling and the cache ceiling are the same number by construction, not
by argument.

The ceiling can be lifted 30 rungs with published data and no local
prime counting. `papers/literature/litsearch_2_priority.md`, § "Verdict
on (i) — π(2^n): KNOWN", lines 42–44:

```text
b-file runs to n = 0..92 (David Baugh, using Kim Walisch's `primecount`; terms 0..86 from
Greathouse and Staple). The project's `pi2n_cache.json` (n = 0..62) is a strict prefix of
this and agrees at every term I spot-checked (π(2^62) = 109932807585469973 in both).
```

Extending R from 62 to 92 adds `Σ_{r=63}^{92} (r−1) = 2295` cells at
d ≥ 1 to a support that currently holds 1891. It more than doubles the
searched region without computing a single prime.

**What this prereg does not do.** It does not re-open the winding
question. `preregs/zero_winding_phase_v1_locked_20260818.md` closed with
verdict `no_constant_angle` and its Test E rate law is, by that prereg's
own text, "interpretable only if Test B fires". Test B did not fire. See
§ Vacuousness check, which addresses head-on why the four-quarter-turns
framing would make this test vacuous and why the rate framing does not.

## Primary hypothesis

**H0 — the rate does not depend on r.** Exact zeros arise in the
backward-prime table at a per-cell rate that is the same everywhere on
the d ≥ 1 support. "Exactly four" is unremarkable; it is what 1891 cells
happened to give. Extending the support by 2295 cells therefore yields
new zeros roughly in proportion.

**H1 — the four are special.** The extended region 62 < r ≤ 92 yields
none, or far fewer than proportion predicts.

**Predicted direction under H1: a deficit.** The point prediction under
H1 is `K_new = 0`, against an H0 expectation of 4.855 (see § H0 expected
count).

The measured quantity is `K_new`, the number of exact zeros at d ≥ 1 with
62 < r ≤ 92. Everything else in the run is either an integrity check or a
diagnostic that cannot move the verdict.

## H0 expected count (stated as a number, before the run)

Support rule, from `O16_centered_difference_table.py` `backward_table()`
docstring: "support r = d+1..R", depth 0..R−1. Zeros are counted at
d ≥ 1 only, per `results/O16_run2.log` § EXACT ZEROS ("depth >= 1").

| region | rule | cells at d ≥ 1 |
| --- | --- | --- |
| old (R = 62) | r = d+1..62, d = 1..61 | **1891** |
| extended (R = 92) | r = d+1..92, d = 1..91 | **4186** |
| new = extended − old | all have r ≥ 63 | **2295** |

The 1891 figure is the one already locked as `null_domain` in
`preregs/zero_winding_phase_v1_locked_20260818.md`, derived there from
`results/O16_run2.log`'s 1953 cells over depths 0..61 minus the 62 cells
of the d = 0 row. It was re-derived at draft time by rebuilding the table
from `pi2n_cache.json` and counting: 1891 cells, zeros
`[(2,1), (4,1), (8,3), (20,6)]` and no others. 4186 and 2295 are the same
arithmetic at R = 92; note `2295 = Σ_{r=63}^{92}(r−1)`, i.e. every new
cell has r ≥ 63, because a cell with r ≤ 62 already has d ≤ r−1 ≤ 61 and
so was already in the old support.

Backward differences at (r,d) depend only on `N(r−d) … N(r)`, so raising
R changes no existing cell. The old cells are literally the same cells,
which is what makes the reproduction check in § Decision rule meaningful
rather than circular.

**H0 expected count:**

```text
E[K_new]  =  4 × 2295 / 1891  =  4.854574299312533
```

## Locked parameters

No parameter may be added, removed, or re-valued after lock. No `--seed`
flag is added; this test uses no randomness at all (see `randomness`
below), so there is no seed to hide.

| parameter | locked value | why this value |
| --- | --- | --- |
| `base` (b) | **2** | The table under test is dyadic. `results/O16_run2.log` computes N(r) on (2^(r−1), 2^r]. |
| `R_ext` | **92** | The last term of the A007053 b-file per `papers/literature/litsearch_2_priority.md` line 42. Not chosen for the answer; chosen because it is where published data stops. |
| `R_old` | **62** | The old census ceiling. `results/O16_run2.log` § TABLE EXTENTS, "max r 62". |
| `d_min` | **1** | `results/O16_run2.log` § EXACT ZEROS counts zeros at "depth >= 1"; depth-0 zeros are "reported separately, not part of any band". |
| `bfile_url` | **`https://oeis.org/A007053/b007053.txt`** | OEIS b-file for A007053, "Number of primes <= 2^n", quoted in `papers/literature/litsearch_2_priority.md` lines 31–38. Confirmed live at draft time by a `curl -sI` HEAD request: `HTTP/2 200`. |
| `bfile_expected_bytes` | **1572** | `content-length` from that HEAD request, 2026-08-19T02:08:59Z. |
| `bfile_expected_last_modified` | **`Wed, 16 Dec 2020 06:02:57 GMT`** | `last-modified` from the same HEAD request. |
| `bfile_metadata_drift` | **reported, never a `compromised` trip** | OEIS may republish the file. A byte-count or mtime change is a fact to record, not a corruption. Only the term comparisons trip `compromised`. |
| `bfile_sha256` | **recorded at run time, not pre-locked** | Pre-locking the SHA would require downloading the blind terms n = 63..92 while writing this prereg, destroying the only blind arm this test has. See § Provenance disclosure. The SHA of the retrieved bytes goes into the results JSON and into the Run record. |
| `bfile_raw_path` | **`b007053.txt` at the project root** | Alongside `pi2n_cache.json`, `pi3n_cache.json`, `zeros600.json`, which is where this tree keeps fetched/derived data (`CONTEXT.md` § Caches). Not under `results/` — it is an input, not a result. |
| `bfile_user_agent` | **a browser User-Agent string** | `papers/literature/litsearch_2_priority.md` records that WebFetch gets 403 from OEIS and that curl with a browser UA at `oeis.org` works. Locked so the fetch method is not improvised at run time. |
| `integrity_range` | **n = 0..62, all 63 terms, exact integer equality** | Every term of `pi2n_cache.json`. `CONTEXT.md` § Caches: "π(2ⁿ) for n = 0…62, **63 entries**". |
| `cache_path` | **`pi2n_cache.json` at the project root** | The cache O16 read. Read-only in this run; it is **not** extended or rewritten. |
| `known_zeros` | **(2,1), (4,1), (8,3), (20,6)** | `results/O16_run2.log` § EXACT ZEROS, backward_prime; `results/O16_centered_difference_table_run2.json` → `constants.documented_backward_zeros`. |
| `o16_log` | **`results/O16_run2.log`** | Re-read at run time and the zero set re-parsed from it, so a drift between this prereg's text and the artifact trips `compromised` rather than passing silently. |
| `cells_old` | **1891** | Table above. |
| `cells_ext` | **4186** | Table above. |
| `cells_new` | **2295** | Table above. |
| `E_K_new_H0` | **4.854574299312533** | `4 × 2295 / 1891`. |
| `null_primary` | **constant per-cell rate**: each d ≥ 1 cell of the backward-prime support is an independent Bernoulli zero with one unknown probability q, the same in every cell | This is H0 stated as a probability model. It is the literal content of "the rate does not depend on r". |
| `test_primary` | **exact conditional binomial.** Conditional on the total `T = 4 + K_new` over the combined 4186 cells, `K_new \| T ~ Binomial(T, 2295/4186)`. One-sided p for a deficit: `p = P(K ≤ K_new \| T)` | Exact, and q drops out — no nuisance parameter is estimated and then reused. `2295/4186 = 0.5482560917343526`. |
| `test_secondary_poisson` | **`p_pois = P(K ≤ K_new)`, `K ~ Poisson(4.854574299312533)`** | Reported always; **cannot** change the verdict. It treats the old-region rate as known without error, which it is not — the whole rate estimate rests on four events. |
| `alpha_level` | **0.05**, one-sided (deficit is the alternative) | House level, matching `preregs/alpha_depth_trend_v1_locked_20260814.md` and `preregs/zero_winding_phase_v1_locked_20260818.md`. |
| `near_miss_H` | **1024** ( = 2^10 ) | The near-miss diagnostic threshold. Fixed at draft time from the old region's own profile: 131 cells have \|B\| ≤ 1024 and the largest r among them is 22 — small enough that the statistic is not saturated, large enough that 131 cells populate it. |
| `near_miss_bound` | **`#zeros in a region ≤ #{cells in that region with \|B\| ≤ H}`, exactly, for any H ≥ 0** | Not a model and not an approximation — a zero *is* a cell with \|B\| ≤ H. This is what makes the near-miss profile a hard bound rather than a heuristic. |
| `randomness` | **none.** No Monte Carlo, no permutation, no resampling anywhere in this test | Both p-values are closed-form. There is no `--seed` flag because there is nothing to seed; `REFERENCES.md` § Constants records seed 2026 for tests that need one. |
| `arithmetic` | **exact Python `int` throughout for the table; float only for the two p-values** | Follows `O16_centered_difference_table.py` § ARITHMETIC: "EXACT PYTHON INTEGERS THROUGHOUT. numpy is deliberately NOT imported" — at (92,91) the entries exceed anything a float64 can hold. |
| `writes` | **`results/extended_zero_census.json`, `results/O43_extended_zero_census_run1.log`, and `b007053.txt` at the project root** | Nothing else is written. `pi2n_cache.json` is not modified. No existing script is modified. |

## Primary statistic

```text
K_new  =  #{ (r,d) : 62 < r ≤ 92, 1 ≤ d ≤ r−1, B(r,d) = 0 }
```

with `B(r,0) = N(r)`, `B(r,d) = B(r,d−1) − B(r−1,d−1)`,
`N(r) = π(2^r) − π(2^(r−1))`, exact integers.

Reported with it: the full new-zero list as (r,d) pairs, `E[K_new]`, the
conditional-binomial p, the Poisson p, and the near-miss profile.

## The checks, in the order they are reported

**Check 1 — integrity. Reported first, and worth more than the census.**
The b-file's terms n = 0..62 must equal `pi2n_cache.json` exactly. That
is **63 independent comparisons** of this project's cache against a
published table compiled by other people, at minimum by different runs of
different software, and at the low end by hand-verified historical work.
No prior test in this tree has checked the cache against anything
external. If it passes, every number in this folder that descends from
`pi2n_cache.json` — 05, 06, 07, O4, O16, O27, O42 — gains an external
witness at one stroke. If it fails, that is the most important thing this
run could find and the census is not worth reading. Any mismatch trips
`compromised` and the run stops before building the table.

The b-file's own header comment lines are recorded verbatim into the
results JSON, so the attribution of terms 0..62 in the *current* file is
on the record rather than assumed from the litsearch summary.

**Check 2 — reproduction.** Build the table to R = 92 and enumerate every
exact zero at d ≥ 1. The zeros with r ≤ 62 must be exactly
`{(2,1), (4,1), (8,3), (20,6)}`, no more and no fewer, and must equal the
set re-parsed from `results/O16_run2.log` at run time. Failure trips
`compromised`. Raising R cannot move an old cell, so this is a real check
on the new construction and not a tautology.

**Check 3 — the census.** `K_new` and the new-zero list, reported
separately from the four reproduced ones and never merged with them.

**Check 4 — the rate test.** `E[K_new]`, the conditional-binomial p, the
Poisson p.

**Check 5 — the near-miss profile (diagnostic; cannot change the
verdict except through the `magnitude_floor` branch below).** For both
regions and per r-band: the count of cells with |B| ≤ `near_miss_H`, the
largest r attaining it, and min |B| over the band. The old-region profile
is already known and is stated in § Provenance disclosure; the extended
half is blind.

## Decision rule (locked before data)

Verdict labels are used verbatim in the writeup and in the Run record.
`K` abbreviates `K_new`, `p` the conditional-binomial p from
`test_primary`, `M_new` the new-region near-miss count at `near_miss_H`.

- `compromised` — any of: HTTP status other than 200 on `bfile_url`;
  fewer than 93 parsed data lines, or n = 0..92 not contiguous, in the
  retrieved b-file; `pi2n_cache.json` not holding exactly 63 entries over
  n = 0..62; **any** of the 63 integrity comparisons unequal; the zero set
  at r ≤ 62, d ≥ 1 in the newly built table differing from `known_zeros`;
  the zero set re-parsed from `results/O16_run2.log` differing from
  `known_zeros`; or any π(2^n) non-integer, negative, or not
  non-decreasing in n.
  → The test ran but the instrument is corrupt for reasons unrelated to
    the hypothesis. No verdict, and the census result is not reported as
    a number.

- `rate_constant` — `K ≥ 1` **AND** `p > alpha_level`.
  → H0 is not falsified. New zeros appear at a rate the old region's rate
    can account for, and "exactly four" was a statement about where the
    cache stopped. Any structural reading of the number four comes out.

- `magnitude_floor` — `K = 0` **AND** `p ≤ alpha_level` **AND**
  `M_new = 0`.
  → The deficit is real, but no cell in 62 < r ≤ 92 came within
    `near_miss_H` of zero, so by `near_miss_bound` the absence of new
    zeros was arithmetically forced by the size of the entries. The
    census removes r ≤ 62 as a confound — "exactly four" now holds to
    r = 92 — but this test **cannot** separate "the four are structurally
    special" from "the entries got too large for exact cancellation".
    That non-separation is a stated limitation, not a hedge.

- `rate_falls_with_r` — `K = 0` **AND** `p ≤ alpha_level` **AND**
  `M_new ≥ 1`.
  → The deficit is real and is not merely a magnitude floor: at least one
    extended cell came within `near_miss_H` of zero and still missed. H0
    is falsified in the deficit direction with the sober alternative
    explicitly excluded at that threshold.

- `ambiguous` — any combination not matched above, including `K ≥ 1` with
  `p ≤ alpha_level`. Under `test_primary` at `alpha_level` 0.05 that
  combination cannot arise (see the p-value table in § Vacuousness
  check), so this branch exists to make the rule total rather than
  because it is expected.
  → The data does not discriminate. Design a sharper test. A real
    outcome, not a deferral.

Precedence: `compromised` > `rate_constant` > `magnitude_floor` >
`rate_falls_with_r` > `ambiguous`.

`magnitude_floor` precedes `rate_falls_with_r` deliberately: among the
two deficit outcomes it is the weaker and more conservative reading, so
the stronger claim is only reached when the near-miss diagnostic
positively permits it.

## Falsification

H0 is falsified by `magnitude_floor` or by `rate_falls_with_r`.

H1 is falsified by `rate_constant`.

Neither `magnitude_floor` nor `rate_falls_with_r` confirms that the four
zeros are structurally special. Both are consistent with a table whose
entries simply outgrow the range in which exact cancellation is
available. Distinguishing those two accounts requires a test this prereg
does not contain, and the writeup must say so rather than reading a
deficit as a structural result.

## Vacuousness check

**The Test E objection, head-on.** The obvious framing of this run —
"does the four-quarter-turns picture survive the extension?" — is close
to vacuous, and the reason is on disk.
`results/zero_winding_phase.json` → `summary.test_E` records
`r_gap_growth_per_turn = 2.4494897427831805` fitted on the r-gaps
`[2, 4, 12]`, giving `predicted_fifth_zero = [47.473141821280016,
10.666666666666668]` with `inside_o16_search_box: true`. That predicted
fifth zero sits **inside** the old box and the old box is empty there.
One more turn at the same rate puts the sixth at
`47.473 + 27.473 × 2.4495 = 114.77`, i.e. **outside r = 92**. So under
that rate law nothing is expected in 62 < r ≤ 92 whether the spiral is
real or not, and the run could not distinguish. Worse, the rate law is
uninterpreted: `preregs/zero_winding_phase_v1_locked_20260818.md` states
Test E "is reported unconditionally but is **interpretable only if Test
B fires** — a rate law fitted through three points with no constant angle
behind it is curve fitting", and that prereg's Run record carries verdict
`no_constant_angle`. Test B did not fire. This prereg therefore does not
use the winding picture, does not use Test E's rate law, and its
statistic `K_new` does not reference either. A spiral is a claim about
*where* a fifth zero sits; H0 here is a claim about *how many* cells
carry zeros. They are different questions and only the second is
answerable at R = 92.

**Firing toward H0 (`rate_constant`) is reachable.** It needs one thing:
a single exact zero anywhere in 2295 blind cells. That is not a remote
possibility dressed up as one. `lean/Zeros.lean` records, per
`preregs/zero_winding_phase_v1_locked_20260818.md` § Background, that
"Nothing below predicts r = 20 or d = 6, and nothing below could" — the
existing deep zeros were not predicted by any account in this tree, and
an unexplained mechanism that produced (20,6) has no reason to stop at
r = 62. Under `test_primary`, `K = 1` already gives `p = 0.132975 > 0.05`
and the verdict is `rate_constant`. One cell out of 2295 flips it.

**Firing toward H1 is reachable and is the default.** `K = 0` gives
`p = 0.041646 ≤ 0.05`. The full pre-computed p-table, so the rule's
behaviour is fully transparent before any data:

```text
  K_new    T=4+K    conditional-binomial p    Poisson p (λ=4.8546)
    0        4            0.041646                 0.007793
    1        5            0.132975                 0.045623
    2        6            0.258156                 0.137447
    3        7            0.395418                 0.286036
    4        8            0.527113                 0.466371
```

Two things must be said plainly about that table.

First, **the test is weak, by construction and unavoidably.** At
`alpha_level` 0.05 only `K = 0` fires, and it fires at p = 0.0416, barely
inside. The entire rate estimate rests on four events. This is not a
tolerance that was tuned to make the answer come out; it is what an exact
conditional test on four events gives, and the alternative — a Poisson
test that pretends the old rate is known exactly — fires at k = 0 *and*
k = 1 and is therefore reported as secondary only.

Second, and more important, **the uniform null is already falsified by
the old region itself, and this prereg does not hide that.** Rebuilt from
`pi2n_cache.json` at draft time: 190 of the 1891 old cells have r ≤ 20,
and all four zeros are among them. Under a constant per-cell rate the
probability of that is `(190/1891)^4 = 1.019e−4`. The near-miss profile
says the same thing without any probability model: of the 131 old cells
with |B| ≤ 1024, the largest r is **22**; the smallest |B| anywhere at
r ≥ 60 is **1 088 117 707**; the largest r carrying any |B| ≤ 10^6 is
**41**. Zeros are not uniform over this table and no one should pretend
otherwise.

So `rate_constant` is not the sober expectation and `magnitude_floor` is.
That asymmetry is stated here, before the run, rather than discovered
afterward, and it is why `magnitude_floor` is a locked verdict label with
its own criterion instead of a paragraph of hedging appended to a
`rate_falls_with_r` result. The run is worth making anyway for three
reasons, in ascending order of weight:

1. `K ≥ 1` remains possible and would be a genuine discovery — the first
   new exact zero found in this table since (20,6), and a direct
   falsification of the magnitude account.
2. Either way it removes `r ≤ 62` as a confound. "Exactly four over the
   whole computed support" is currently a statement whose ceiling is a
   cache file; after this run it is a statement whose ceiling is the
   published limit of human knowledge of π(2^n).
3. The integrity check is worth more than the census and does not depend
   on how the census comes out.

## Provenance disclosure (required reading)

1. **The four zeros at r ≤ 62 are not blind, exhaustively so.**
   `(2,1)`, `(4,1)`, `(8,3)`, `(20,6)` have been inspected by Julian and
   by assistants across many sessions. They appear in `CONTEXT.md`, in
   `results/O16_run2.log`, in `results/O16_centered_difference_table_run2.json`,
   in `lean/Zeros.lean`, in `lean/Construction.lean`, in
   `O16_centered_difference_table.py` as the module constant
   `DOCUMENTED_BACKWARD_ZEROS`, and as `LOCKED_ZEROS` in
   `O42_zero_winding_phase.py`. Check 2 is a **reproduction check, not
   evidence**, and must never be reported as a confirmation.

2. **The old region's magnitude profile is not blind either.** While
   drafting this prereg the assistant rebuilt the R = 62 table from
   `pi2n_cache.json` and computed the near-miss statistics quoted in
   § Vacuousness check — 131 cells at |B| ≤ 1024 with max r 22, min |B|
   at r ≥ 60 of 1 088 117 707, max r at |B| ≤ 10^6 of 41, and the
   `(190/1891)^4` figure. Those are machine output from the cache, not
   hand arithmetic, and they are disclosed because `near_miss_H = 1024`
   was chosen with them in view. The threshold is therefore **calibrated
   on inspected data** and only its application to 62 < r ≤ 92 is blind.

3. **The b-file's terms n = 63..92 have not been seen by anyone in this
   project.** Not by Julian, not by any assistant, not by any prior
   agent. Nothing in `results/`, in `papers/`, or in any cache contains
   π(2^n) for n > 62. This is the genuinely blind arm, and unlike O42
   — whose provenance section had to disclose a hand-estimated Test A —
   there is no partial peek to disclose here.

   To keep it that way the drafting agent did **not** download the
   b-file. It issued a single `curl -sI` HEAD request, which returns
   headers and no body, obtaining `HTTP/2 200`, `content-length: 1572`,
   and `last-modified: Wed, 16 Dec 2020 06:02:57 GMT`. Those three
   values are locked above. No term of the sequence was retrieved, and
   `bfile_sha256` is deliberately left unlocked for exactly this reason.

4. **One term of the b-file has been seen, and it is inside the
   integrity range.** `papers/literature/litsearch_2_priority.md` line 43
   records "π(2^62) = 109932807585469973 in both", i.e. a prior agent
   spot-checked n = 62 against the cache and it matched. That is 1 of the
   63 integrity comparisons, already known to pass. The other 62 have not
   been checked by anyone.

5. **The b-file's authorship is quoted, not verified.** The
   Baugh / Greathouse / Staple / `primecount` attribution comes from
   `papers/literature/litsearch_2_priority.md` line 42, which is itself a
   summary of an OEIS page. Whether the *current* b-file's terms 0..62
   are Greathouse-and-Staple's or a later recomputation is not something
   this prereg asserts; the script records the file's own header comment
   lines verbatim so the answer is on the record after the run. The
   independence claim in Check 1 is therefore stated at its weakest
   defensible strength: different people, and at minimum different runs
   of different software, from `pi2n_cache.json` — which `CONTEXT.md`
   § Caches records as populated by `primecountpy.prime_pi` with a
   `sympy.primepi` fallback, and which `O11` extended locally on
   2026-08-15.

## What is varied / held fixed

Varied: `R`, from 62 to 92 — that is the whole intervention. Held fixed:
base, the difference convention, the support rule, the d ≥ 1 restriction,
the zero criterion (exact integer equality with 0), the near-miss
threshold, alpha, and both null models. No existing script is modified.
`pi2n_cache.json` is read and not written. `results/O16_run2.log` is read
and not written.

## Compute

Seconds. One HTTP GET of about 1.6 KB; a 4186-cell exact-integer table;
two closed-form p-values. No prime counting, no Monte Carlo, no mpmath.
Artifact well under 1 MB.

## Reproducibility

Deterministic with one external dependency: the b-file. Its SHA-256 and
byte count go into the results JSON and the raw bytes are written to
`b007053.txt` at the project root, so a later run can be pinned to the
same input by re-reading that file rather than re-fetching. Re-running at
identical parameters against the same b-file must reproduce
byte-identical results apart from `generated_utc` and the retrieval
timestamp. There is no seed because there is no randomness.

## Analyzer

`O43_extended_zero_census.py`, at the project root. Written 2026-08-18,
before this prereg was locked and before any run. Cited here by path per
the naming convention in `CLAUDE.md` — do not rename it.

Results: `results/extended_zero_census.json`.
Log: `results/O43_extended_zero_census_run1.log`.
Fetched input: `b007053.txt` at the project root.

## Lock chain

- `lock_written_at`: 2026-08-19T02:25:15Z
- `pre_compute_sha256`: PENDING
- `locked_by`: julian

## Run record

Appended after the run.

- `run_start_at`: 2026-08-19T02:25:47Z
- `run_end_at`: 2026-08-19T02:25:48Z
- `verdict`: `magnitude_floor`
  All three conditions of the branch held: `K_new = 0`,
  `p_conditional = 0.0416 ≤ alpha_level = 0.05`, and `M_new = 0`. No
  `compromised` condition tripped, and `rate_constant`, which precedes this
  branch in the locked precedence, did not fire.
  Per the locked decision rule the deficit is real but arithmetically
  forced: no cell in `62 < r ≤ 92` came within `near_miss_H` of zero, so
  the absence of new zeros is a statement about the magnitude of the
  entries in the extended region, not about where the primes are. It does
  not license "the four zeros are all there are"; it licenses "nothing in
  `62 < r ≤ 92` was close enough to have been one".
  Corroborated but not arithmetically independent: `notes/lab_notebook_2.md`
  entry 49 records the lattice_mapper tables reaching `A(64)` from
  different code, in a different repo, months earlier, under a different
  convention — but π(2ⁿ) is π(2ⁿ), and O43 reads further, to `r = 92`
  against that file's 64. What is independent is the convention, not the
  arithmetic.
- `post_compute_sha256`: `ff6a1794c1129397760779a587aeb737218e480bb48820e3b38e062467beb0dd`
- `bfile_sha256`: `6f4f5aaca7419f8c3d0a9d41b56617a1347ab4c124eec3f64362e299f7d8179b`
  (1572 bytes, HTTP 200, 93 data lines n = 0..92 contiguous, 0 comment lines;
  `content-length` matches the locked `bfile_expected_bytes`, `last-modified`
  absent from the response so `bfile_expected_last_modified` is recorded as
  drift under `bfile_metadata_drift` and does not trip `compromised`.)
- sidecar match: **yes** — identical to the sidecar
  `extended_zero_census_v1_locked_20260818.sha256`, so no parameter,
  hypothesis, or decision-rule text drifted between lock and compute.
- analyzer: `O43_extended_zero_census.py`, one run at the locked flags
- results: `results/extended_zero_census.json`
- log: `results/O43_extended_zero_census_run1.log`
- fetched input: `b007053.txt` at the project root
