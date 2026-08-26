# CONTEXT — Primebeat_081426

## What this measures

A series of numerical tests (O1–O39, with gaps at O10 and O28) probing
whether structural features of the
dyadic prime difference table carry the spectral content the Prime Beat
work attributes to them. Each test isolates one claim and tries to
break it.

| Test | Script | Question |
|------|--------|----------|
| O1 | `files (2)/O1_operator_selfadjointness.py` | Is the difference operator D self-adjoint? |
| O2 | `files (2)/O2_prime_kernel_spectrum.py` | Does a self-adjoint kernel built from primes alone have γ in its spectrum? |
| O3 | `O3_collapse_radius_vs_rotation.py` | Is the past-boundary collapse radius decay or rotation at ω₁? |
| O3b | `files (2)/O3b_rebounds_and_oscillating_fit.py` | Rebound counts and oscillating fit — O3 follow-up |
| O4 | `O4_local_exponent.py` | What is the local exponent β(r,d) with no functional form assumed? |
| O5 | `05_cross_depth_alpha.py` | Does α agree across depths? (spread statistic) |
| O6 | `06_comb_corrected_radius.py` | β with the known comb gain divided out, no envelope fit |
| O7 | `07_alpha_depth_trend.py` | Is α depth-*dependent*? (OLS slope statistic) — **preregistered** |
| O8 | `O8_weil_inner_product.py` | Does the truncated Weil form supply the missing inner product for Δ? |
| O9 | `O9_convergence_abscissa.py` | Where is the empirical convergence abscissa of the truncated prime sum? |
| O11 | `O11_extend_counts.py` | Extend the π(2ⁿ) cache; how far can the ladder reach and at what cost? |
| O12 | `O12_dyadic_block_ratio.py` | Fit-free: what exponent governs the dyadic block sum? |
| O13 | `O13_smoothness_null.py` | What is the null distribution of O9's part-3 smoothness statistic? |
| O14 | `O14_residual_depth.py` | Normalise the envelope out and difference along the ladder — what survives? |
| O15 | `O15_fine_ladder_residual.py` | Same, sampled finely enough to clear Nyquist for γ — does any zero appear? |
| O16 | `O16_centered_difference_table.py` | Does the centered (skew-adjoint) difference table have exact zeros? |
| O17 | `O17_disjoint_block_residual.py` | Disjoint value-interval blocks — do the zeros appear in the count residual? |
| O18 | `O18_joint_multiplicative_ladder.py` | Are integer bases blind to the zeros *jointly*, or only singly? |
| O19 | `O19_bridge_figure.py` | Figure: Connes' accuracy and the table's zeros on one depth axis |
| O20 | `O20_connes_cutoff_sweep.py` | Connes' open question: does the accuracy converge as the cutoff grows? |
| O21 | `O21_archimedean_convergence.py` | Where does the archimedean cutoff T settle, and is dps enough? |
| O22 | `O22_weighted_beat.py` | Does restoring the Weil local term's log p weight improve the Beat? |
| O23 | `O23_alignment_replication.py` | Does the December alignment table reproduce? (parked side line) |
| O24 | `O24_prime_generator_orbit.py` | Can a small generator orbit reconstruct the zeros? |
| O25 | `O25_compression_curve.py` | Does the residual compress or expand with x? |
| O26 | `O26_compression_figure.py` | Figure for O25 |
| O27 | `O27_joint_dyadic_triadic_table.py` | Dyadic and triadic tables on one index-paired grid |
| O29 | `O29_depth_residuals.py` | How does the residual behave with depth, li vs R? |
| O30 | `O30_silence_scaffold_primes.py` | Zeroing 2,3,5's counts — do the deep zeros survive? |
| O31 | `O31_excise_scaffold_primes.py` | Deleting 2,3,5 from the line — do they survive? |
| O32 | `O32_excised_gamma_check.py` | Do the detected γ survive excision? |
| O33 | `O33_base_ladder_crossing.py` | Do bases 2–9 cross depth where the transfer function says? (reads the eight base tables in `imported/lattice_mapper/32bit/`) |
| O34 | `O34_zeta_residual_model.py` | Is the depth residual built from the zeta zeros? |
| O34 | `O34_zeta_residual_model_FAILED.py` | Superseded — Gram series diverged, kept as evidence |
| O35 | `O35_nearmiss_residuals.py` | Do the near-miss cells' residuals come from the zeros too? |
| O36 | `O36_weil_calibration.py` | Calibrate the explicit formula on a known test function |
| O37 | `O37_weil_form_on_stencil.py` | Weil's form on the difference stencil — does it balance? |
| O37 | `O37_weil_form_balance.py` | Companion: the balance line at high precision |
| O38 | `O38_weil_bug_diagnosis.py` | The four defects in the first Weil implementation |
| O38 | `O38_weil_form_BUGGY.py` | Superseded — incorrect, kept as evidence |
| O39 | `O39_transform_radius.py` | Where do the roots of the table's z-transform lie? |

The table above stops at O39. O40 onward are described in § Current state
of the world rather than tabulated.

There is no O10. The gap is deliberate and has been left unfilled
rather than absorbed by unrelated work.

There is no O28 either. The gap arose when O29 was numbered ahead of it
and has been left unfilled on the same principle.

The lab notebook skips Entry 18. Unlike the script-number gaps above
this one is unexplained — no entry carrying that number has been found
anywhere in the tree. Recorded here so it is not searched for again.

O1, O2, and O3b exist only in `files (2)/` and were never promoted to
root. Their only record is the captured `.txt` transcripts alongside
them.

O12–O16 and O24 carry `params.code_version`, the sha256 of the script
file. O1–O9 and O11 do not; extending that is an open thread.

**The guarantee is weaker than it looks.** The hash is read inside
`_write_results()`, i.e. at write time rather than at import time, so
any edit landing mid-run silently mislabels the result. This happened
on 2026-08-17: `O24_gen_xmax3e9_results.json` records the post-fix
hash while the run executed pre-fix bytes (entry 42). Reading the hash
at import would close it; until then, `code_version` identifies the
file at write time, not the code that ran.

## Core quantities

- `e(r)` — dyadic residual at regime r: `c_n − (li(2ⁿ) − li(2ⁿ⁻¹))`
- `D^d` — d-fold difference of the regime sequence (depth d)
- `α` / `β` — radius exponent fitted on `log2|D^d e(r)| ~ α·r`
- `γ₁ = 14.134725141734693…` — first Riemann zero
- `ω₁ = γ₁·ln2 = 3.514260 rad/regime` — aliases to 2.7689 (> π)
- Comb gain `G(γ,d) = (2 sin(ω/2))^d` — derived, not fitted
- Beat weighting `p^(−1/2)`; contrasted against unit and `ln p`
- `N(r) = π(2ʳ) − π(2ʳ⁻¹)` — primes in the dyadic interval (2ʳ⁻¹, 2ʳ];
  composites in the same interval are `M(r) = 2ʳ⁻¹ − N(r)`
- Prime/composite identity, **backward** differences, exact at every
  cell in any base b: `composite(r,d) = (b−1)^(d+1)·b^(r−1−d) −
  prime(r,d)`, because the block holds (b−1)·b^(r−1) slots and each
  d-th difference multiplies that by (b−1)/b. For b = 2 this is the
  familiar `2^(r−d−1) − prime(r,d)`. So a zero on either side means the
  other side hits that quantity exactly. Survives silencing and
  excising — see entry 33.
- Same identity, **centered** differences (unnormalised, factor ½
  omitted): `composite_C(r,d) = 3^d · 2^(r−1−d) − prime_C(r,d)`, since
  (S − S⁻¹) applied to 2ʳ⁻¹ gives 2ʳ − 2ʳ⁻² = 3·2ʳ⁻²
- Block sum `Δ_N = Σ over primes[N:2N] of p^(−σ−it)`, exactly N terms;
  `g(N) = |Δ_N| / N^(1−σ)`. Measured envelope: `|Δ_N| ~ N^(1−σ)`

## Output schema — `results/`

Every result JSON shares one envelope:

```text
{
  "schema_version": "1",
  "script":         "<filename>",
  "generated_utc":  "YYYY-MM-DDTHH:MM:SSZ",
  "params":         {...},   # the flags the run was invoked with
  "constants":      {...},   # γ₁, ω₁, locked β, etc.
  "summary":        {...},   # headline numbers
  "rows":           [...]    # per-depth or per-step detail (06, 07, O3)
}
```

Written by `_write_results()`, which is wrapped so a write failure
never kills a long run. Every script takes `--out` and `--no-json`.
Paths are anchored to `_HERE` so runs are cwd-independent.

**O8 is the exception** — no `DEFAULT_OUT`, no `json.dump`, no `--out`.
Its record is console output only, captured in `O8_run*.log`.

**`params.code_version` is not universal, and is deliberately being
left that way.** 55 root scripts write their own sha256 into
`params.code_version`; the genuinely old ones — `O11`, the `05_` /
`06_` / `07_` series, and a few others — do not. Entry 9 (2026-08-15)
opened extending it to the rest, and on 2026-08-26 that was **decided
against, for a reason that only became visible later**: editing a
script changes its `code_version`, which changes every results JSON it
writes, which changes those JSONs' sha256. Six preregs sit downstream
of scripts in that set, and
`preregs/dh_coalition_spectrum_v1_20260825.md` pins an artifact's hash
inside a Run record that is immutable by `preregs/FORMAT.md`. A
retroactive stamping pass would therefore invalidate pinned hashes in
locked documents to gain provenance on runs that already happened.
The absence is a known gap, not an oversight; `results/runs/` (entry
183) now records interpreter, argv, script sha256 and git HEAD for
every run made through `utilities/run.py`, which supplies the same
provenance from outside the artifact instead of inside it.
`lab_notebook.md` entry 9 · `lab_notebook_2.md` entries 183, 184

## Caches

- `pi2n_cache.json` — π(2ⁿ) for n = 0…62, **63 entries**. Shared by 05,
  06, 07, O4, and read by O16. O11's run of 2026-08-15 extended it from
  the rmax = 60 the prereg locked; 05/06/07/O4 have not been re-run
  against the extended cache.
- `pi2n_cache_o3.json` — π(2ⁿ) for n = 0…45, 46 entries. O3 only
  (default `--rmax 45`).
- `pi3n_cache.json` — π(3ⁿ) for n = 0…41, 42 entries. Created by O27
  2026-08-17. The ceiling is wall clock, not exactness: π(3⁴¹) took
  357 s and the cost roughly doubles per step.
- `zeros600.json` — imaginary parts of the first 600 nontrivial zeta
  zeros, 600 entries, first 14.13472514173469379045725. Written by
  `mkzeros.py` at the project root 2026-08-17. Used by O37/O38.

Both populate lazily via `primecountpy.prime_pi`, falling back to
`sympy.primepi`, and rewrite in place on miss.

## `files (2)/`

An imported bundle (single mtime 2026-08-14 22:07, mode 600 — an
unpacked download, browser dedup suffix in the name). Frozen evidence.
Holds:

- The O-series originals, including O1, O2, O3b which exist nowhere else
- Three console transcripts: `O1_output.txt`, `O2_output.txt`,
  `O3b_output.txt`
- Nine dyadic difference table CSVs across three weightings (unit,
  log, beat) × two sides (prime, composite), plus `all_weightings_long.csv`
  (tidy form, 775 rows) and `rowsums_to_d20.csv`
- `dyadic-table-addendum-5.md` (DT-A5) and `dyadic-table-addendum-6.md`
  (DT-A6) — the documents the later scripts are arguing with. DT-A6 §1(b)
  is the reading O7 was built to test.

## `imported/lattice_mapper/`

Twenty-seven files copied byte-for-byte (`cp -p`) on 2026-08-18 from
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/`, every
one SHA-256 verified source-vs-destination at copy time. The `32bit/`
and `64bit/` split is preserved: 22 files from `32bit/` — the
complete directory, 12 base-series tables for bases 2–9 plus 10 dyadic
prime/composite split files — 4 from `64bit/`, and the source README
under the name `source_README.md`.
`imported/lattice_mapper/README.md` is the import manifest and carries
the full SHA-256 and source-mtime table. See entry 46.

**Imported evidence, not outputs of this bench.** No script here
produced them and none should regenerate them. They are here because
entry 17 cites `triadic_difference_table_32.csv` by a path outside this
repo, and O33 read the same source directory; the import closes that
provenance gap.

**They use a different convention, and that is the load-bearing part.**
Power-regime **backward** differences, `A(n) = π(bⁿ) − π(bⁿ⁻¹)`, with
**2 and 3 excluded as lattice rather than counted as primes** —
`A(1) = π(b) − 2` for b ≥ 3, and at b = 2 the two lattice primes
straddle the regime boundary (2 in (1,2], 3 in (2,4]) so one is dropped
from each of `A(1)` and `A(2)`. **No in-repo artifact uses that
convention**: O27's block r is (b^(r−1), b^r] with 2 and 3 counted,
`N_2(1) = 1` and `N_3(1) = 2` (entry 29), and the dyadic tables built
here carry the same. So a number lifted from `imported/` and a number
lifted from `results/` are **not comparable at low r** without stating
which convention is in force. `silenceXYZ` suffixes silence the
additionally-named primes.

`archive_unsilenced/` was deliberately **not** imported: it is an
earlier generation using **forward** differences with **only 2**
dropped, its `*_64bit_*.csv` files carry a third schema (`pi_n`,
integer regime), and it holds ~25 MB of binaries inside a 59 MB
directory. Mixing conventions in one imported directory is the
confusion this import exists to end. It stays readable in place at the
source path above and was not moved or touched.

`source_README.md` is stale and was flagged rather than fixed — it
describes `64bit/` as an integer-regime π(n) table, but both imported
`64bit/` files are power-regime `A_count` tables on the same convention
as `32bit/`, verified identical to `32bit/` on all 496 overlapping
cells. That description fits the archive's files.

## `imported/twin_count/`

Seven files copied byte-for-byte (`cp -p`) on 2026-08-21 from
`~/GitHub/twin_count/`, every one SHA-256 verified source-vs-destination at copy
time, with the manifest at `imported/twin_count/README.md`. The compiled binary
was deliberately not imported — machine-specific and rebuildable from
`twincount.c`.

**Imported evidence, not outputs of this bench.** The source is **not a git
repository and has no commitment files**, so this import is the only versioned
copy that exists.

**Why it is here.** `twincount.c` streams primes to `10^11` in 16.8 s with
primesieve. That is what showed O17's ceiling was a sieve limit rather than a
mathematical one, which produced O50. And `twins_1e11_analysis.json` deprecates
its own α estimator — `alpha_peak`, `r² = 0.015` — for a linear-sampling defect
of the same class as O48's fixed depth window: a fixed step in one coordinate
becoming non-uniform in the coordinate that matters.

**Different convention, and it is load-bearing.** `twins_1e11.csv` is sampled on
a **linear** ladder, step `10^7`. Every in-repo artifact uses **geometric**
rungs. Numbers do not cross that boundary without naming which is in force.

Its own results are a clean null on the twin side: `zeta_power_ratio = 0.347`
where 1.0 is no signal, and `surrogate_p = 0.973`. π₂ has no proven explicit
formula, so nothing says it should carry zeta lines.

## Current state of the world

Status: **folded into the research program**, with the commitment files
at the root, notes under `notes/`, and papers under `papers/`. Results
here are citable, which makes the exploratory/preregistered distinction
load-bearing rather than bookkeeping. Content dates 2026-08-14 to
2026-08-25. This **is** a git repository, pushed to a **public** remote
since 2026-08-24 (entry 145). The environment is a `.venv` on Python
3.14.3, frozen to `requirements.txt`; Homebrew `primecount 8.6` is
linked by `primecountpy` and is not capturable by a freeze.

**Six preregistered tests are locked.** Five carry verdicts: O7
`depth_dependent` (2026-08-15), O42 `no_constant_angle` (08-18), O43
`magnitude_floor` and O45 `fineness` (08-20), and O48
`small_angle_cross_base` **`compromised`** (08-24, entry 110 — the
control floor read 0.754867 against a locked 0.80, and the design was
retired rather than revised). The sixth, O81
`dh_coalition_spectrum_v1_20260825`, has a filled Run record whose
mechanical decision-rule output is `null`; **its verdict line is
unwritten and is Julian's.** Each closed Run record carries a sidecar
match verified at compute time.

**Scale, as of entry 165 (2026-08-25):** 165 notebook entries across two
volumes, 34 open NOTEPAD threads, 82 O-scripts plus the `t`-series under
`analysis/`, 14 papers, six preregs, and two Lean packages totalling 327
axiom-pinned theorems (see § The Lean tree).

What has been run and recorded:

- **O7 — the first preregistered test.** Locked 2026-08-15T01:04:12Z,
  ran 01:06:47→01:06:54Z. `b_obs −0.0040675`, CI [−0.0048144,
  −0.0033207], `p_primary 0.04`, blind-arm sign matches. The prereg's
  Run record carries verdict `depth_dependent` and a sidecar SHA match.
- **O3** — `p_value 0.8525` against a 2000-trial random-phase null. The
  `files (2)` copy's header records "RESULT: NEGATIVE".
- **O8** — `Δ 0.99844` vs `random 0.85235` and `d/dt 0.03823` (PASS
  control). Δ sits above the random baseline. Carries its own CAVEAT ON
  THE BASIS: Δ differences the basis index k, not the dyadic shift on
  the underlying interval.
- **O9** — completed at both step 0.01 and 0.005; both report
  "smooth through 1/2" with departure/residual sd 2.61 and 2.55. That
  verdict is **retracted as evidence** — see defect 1.
- **O5, O6, O4** — exploratory numbers recorded in `results/`.
- **O12** — fit-free, no least squares anywhere: the dyadic block sum
  is additive, `a = 1 − σ`. Settled series give mean a = 1.007 / 0.466 /
  −0.070 at σ = 0 / 0.5 / 1.0. σ = 0 is the discriminating row (additive
  predicts 1, square-root cancellation predicts ½) and reads 1.007.
- **O13** — the null of O9's smoothness statistic across 91 window
  centres: mean 2.4495, sd 0.2289, max 2.6041. The hardcoded threshold
  of 3 sits above the entire null, and 58 of 91 centres fall inside
  (2.50, 2.60] — a spike, not a tail. No threshold isolates σ = 0.5.
- **O14 / O15** — normalising `N^(1−σ)` out and differencing leaves a
  1/log N drift, still dominant at depth 8. O15 raised the sampling
  Nyquist from 4.53 to 32.96, clearing γ₁/γ₂/γ₃; projection onto
  e^(−iγ log N) returned DETECT 0 of 54. The binding limit is that the
  block runs N → 2N, so over 8.4M primes there are only ~16 **disjoint**
  blocks however the ladder is sampled.
- **O16** — the centered (skew-adjoint) difference table has **no exact
  zeros anywhere** in its support, r ≤ 62, d ≤ 30. A backward zero needs
  an adjacent repeat at depth d−1; a centered zero needs a gap-2 repeat,
  and there are none at any depth. Backward zeros verified exactly to
  r ≤ 62, d ≤ 61 as {(2,1), (4,1), (8,3), (20,6)} and no others — beyond
  the xlsx's r ≤ 50 ceiling, which exists only because a spreadsheet
  holds ~15 significant digits.
- **O17** — first detection. Disjoint value-interval blocks on a ratio-1.1
  ladder recover γ₁, γ₂, γ₃ at 14.08, 20.97, 24.98, all inside one
  frequency-resolution element. The dyadic control on the same primes and
  the same code returns NULL, which turns the aliasing diagnosis into a
  measurement.
- **O18** — integer bases are blind singly but not jointly. At x₀ = 2,
  L2 and L3 both NULL while the joint orbit {2^m 3^n} detects γ₂ at
  P/median 6.95 and the three-generator orbit detects γ₄ at 16.37. The
  dyadic ladder shows **eight peaks of identical height spaced 2π/log 2** —
  the alias comb, measured. It is not blind, it is ambiguous.
- **O19 / O20** — the bridge to Connes. A cell at depth d spans a value
  window of ratio 2^(d+1); Connes' [λ⁻¹, λ] spans λ². Equating gives
  **λ = 2^((d+1)/2)**. Under it, (8,3) lands at λ = 4 whose window holds
  exactly {2,3} — the mod-6 lattice, which is the workbook's own reason
  for that zero — and (20,6) sits one prime short of Connes' λ = 13.
  Sweeping his own construction across cutoffs at T = 1600 gives
  first-zero error 2.18784e−55 at c = 13 falling to 5.49291e−120 at
  c = 29, **about 28 decimal places per unit of depth**, with the
  simplicity gap ratio never below 3.96e7. That is his §5 open question,
  measured.
- **O21** — the archimedean cutoff T has a validity window with two
  distinct failure modes: below it the form is genuinely not yet positive
  (λ₁ negative, order 1); above it precision fails (λ₁ negative, order
  1e−4). At dps = 150 the window is T ∈ {400, 800, 1600}; at dps = 300 it
  is {800, 1600, 3200}. Doubling the digits buys exactly one more doubling
  of T. **λ₁ is not converged** — 9.1% then 8.3% per doubling. The *rate*
  in O20 is robust to T (−27.93 at T = 400, −27.90 at T = 1600); the
  absolute values are not.
- **O22** — the Beat is not Connes' object. At the identical window
  {2,3,5,7,11,13} his construction gives 2.18784e−55 and the Beat gives
  1.1e−01, a factor of 10⁵³. Restoring the Weil local term's log p weight
  and prime powers moves the Beat by ~1.4×. The accuracy is in the
  variational construction, not the weighting.
- **O24** — a small generator orbit reconstructs the zeros, and the peak
  sits at G4 = {2,3,5,7} at every setting measured: P_max/median 26.73 at
  xmax 1.5e8, 31.37 at 1e9, 38.30 at 3e9, band FALLS each time. Entry 24's
  prediction that the peak moves to G5 or G6 is falsified (entry 34).
  But the deep sets are not exhausted — gain from 1e9 to 3e9 rises
  monotonically with generator count, G4 +22.1% through G8 +63.3%, which
  supports the block-size account rather than refuting it. G4's second
  hallmark has also moved: the six zeros come up together within 8.56% at
  G4 but 1.1% at G6 (entry 42). Three real settings are on disk; the
  `O24_gen_xmax3e8_run.log` file is an aborted timing probe, not a run.
- **O25 / O26** — the residual compresses at a relative 10⁻¹ target and
  inverts in absolute terms at x = 1030. The tighter relative targets
  10⁻² and 10⁻³ read NEITHER.
- **O27** — joint dyadic/triadic table to r = 41. *(Correction, entry 58:
  the 247-cell reproduction below is **O16's GATE A**, not O27 —
  `results/O16_run2.log` lines 229–244. Left in place rather than rewritten;
  O27's own result is the r = 41 joint table.)* The dyadic half
  reproduces `files (2)/unit_weighted_dyadic_table.csv` across 247
  cells with 0 mismatches and returns exactly {(2,1),(4,1),(8,3),(20,6)}
  from an independent construction. The triadic table has one exact
  zero, (2,1), and it is trivial. That reading is **convention-bound**:
  O27 counts 2 and 3 as primes. The excluded-as-lattice triadic table
  in `imported/lattice_mapper/32bit/` has no exact zero in any delta
  column at all, its single 0 being `A_count` at r = 1, which is the
  construction (entry 17). The two do not compare at low r.
- **O29** — the li−R gap decays 3.53× per depth in base 2 and 2.44× in
  base 3, against (1−b^(−1/2)) predicting 3.414 and 2.366. Independent
  confirmation of the transfer function. Verified at dps 120 and 200,
  max disagreement 6.31e−104; the frontier is data, not arithmetic.
- **O30 / O31 / O32** — silencing 2,3,5 leaves both deep zeros exactly
  intact; excising them from the line destroys both, (20,6) reading 70.
  The detected γ₁,γ₂,γ₃ are unchanged under both excisions. See entry 33.
- **O33** — the pre-stated crossing-depth prediction FAILED. Its input is
  the eight base tables that lived outside this repo at run time, at
  `/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/`
  (the path `params.data_dir` records) and now vendored byte-for-byte at
  `imported/lattice_mapper/32bit/`; they carry the lattice convention,
  2 and 3 excluded, which the script adds back before measuring — rows
  whose crossing moved = 0, all eight bases. Bases 5 and 7
  were fully testable and never cross, so the split is {2,3} against
  {4…9}. Crossing depth is not fixed per base — it grows linearly in r,
  slope 0.3031 (b=2) and 0.7353 (b=3) against a post-hoc ln b/(2 ln ratio)
  predicting 0.2862 and 0.6406. What held independently: the trend gain
  (b−1)/b, confirmed across all eight bases.
- **O34 / O35** — the residual is the zeta zeros: 94% of the row-20
  residual at d0, 92% at d3, 80% at d6, from the explicit formula alone,
  nothing fitted. Convergence non-monotone. Deep cells cannot be tested
  this way — at (25,21) the model flips sign between 200 and 600 zeros,
  because the depth operator spreads zero gains over (d+1)×0.765 decades.
- **O36 / O37 / O38** — Weil's form on the Δ^N stencil. Exact identity,
  eight digits at three zeros: |h| on the critical line is
  b^(N/2)·|1−b^(−ρ)|^(2N) — the depth gain IS the Weil weight, with no
  coordinate matching, unlike the O19 bridge withdrawn in entry 23. The
  unmollified stencil is inadmissible and sees only p=2; mollified and
  centered at s=1/2 it is a genuine positivity test function and 25 primes
  enter. Balance: 2644.27566 against 2644.27416, relative 5.7e−7. Four
  defects in the first implementation are recorded in entry 39. Not
  parameter-independent — W and k are free.
- **O39** — a circle of roots is generic (Jentzsch); only the radius
  informs. Against a smooth control pinned at 1/2 to depth 43, the prime
  table migrates 0.5406 → 0.7537, reaching the residual's radius 2^(−1/2).
  Depth moves the singularity. Truncation offsets +6.609% and +6.671%
  agree, identifying them as artifact. Breakdown at d=13 (prime), d=10
  (residual), never for the control. The annulus 0.5 < |z| < 0.70711 has
  conformal modulus (log b)/4π = 0.05515890.

- **O40** — the reciprocal local factor's zeros for an elliptic curve.
  43 curve-prime pairs across ranks 0, 1, 2; max `|Re(s) − 1/2|` is
  2.22e−16, one ulp of a float64. Hasse holds everywhere it was checked.
  EXPLORATORY.
- **O41** — the rank read off the symbol at `s = 0`. Fitted exponent
  against true rank: 11a1 0.0301 (rank 0), 37a1 1.2498 (rank 1), 389a1
  1.9933 (rank 2). Ranks 0 and 2 land inside 0.05; rank 1 is 0.25 high,
  which is the product's slow convergence at `X ≤ 30000`, not a
  disagreement about the rank. EXPLORATORY.
- **O42** — are the four zeros turn marks on a spiral? PREREGISTERED
  (`preregs/zero_winding_phase_v1_locked_20260818.md`). Mechanical
  decision-rule output `no_constant_angle`; no γ index has all gaps near
  π/2, gaps at γ₁ read 0.745 / 1.183 / 4.010, null firing rate 0.0044, no
  `compromised` condition fires. Verdict `no_constant_angle`, recorded
  2026-08-18: a failure to detect constant winding *in the (r,d)
  coordinate at M = 200*, not evidence the zeros are unstructured.
- **O43** — extended exact-zero census to `r = 92` on published π(2ⁿ);
  no primes counted. PREREGISTERED. 4186 cells against O16's 1891, so
  2295 new; all four known zeros reproduced and **K_new = 0** against
  `E[K_new] = 4.85` under H0. `p_conditional 0.0416`,
  `p_poisson 0.0078`. Mechanical output and verdict:
  `magnitude_floor` — the deficit is real but arithmetically forced, and
  corroborated by lattice_mapper reaching `A(64)` under a different
  convention, though not independently in the arithmetic.
- **O44** — cross-base zero scan over the eight imported b-adic tables,
  in the pair identity's scale coordinate; every number read from CSV.
  Of bases 2–9, **only base 2 has exact zeros**, and it has the same
  four. 1289 pair-identity cells checked. EXPLORATORY.
- **O45** — sub-integer base scan: is base 2 the finest sampling of the
  scaling flow, or special in itself? PREREGISTERED. Ten bases in (1,2)
  plus base 2, matched on one value ceiling: 37178 sub-2 cells against
  base 2's 496, Z = 121 resolved zeros, Z* = 35 clearing the mass floor,
  against `E[Z] = 299.8` under H0. `p_conditional 0.0839`. Mechanical output
  and verdict: `fineness` — H0 not falsified. Scope: the locked base set
  is commensurate by construction, eight of eleven bases exact multiples
  of `π/(4γ₁)` in log carrying 107 of the 125 zeros, which nothing in the
  prereg noticed (`papers/Commensurate-Ladders.md` § D4). That bounds
  cross-base geometry, not the per-base `Z*` counts.
- **O46** — does stencil mass alone account for O45's density trend?
  `density × mean S` spreads by a factor of 1.4e38 across the eleven
  bases; `density / mean(1/S)` spreads by 5.57. The `density ≈ 1/S`
  mechanism is refuted. EXPLORATORY.
- **O47** — which zeros are cancellations rather than bookkeeping. 125
  pooled resolved zeros at `d ≥ 1` across eleven bases, ranked by stencil
  mass. Base 2 is the density maximum and is **not** the mass maximum.
  EXPLORATORY.
- **O48** — does the residual table's normalized depth gain follow the symbol,
  and does it null at `b = exp(2π/γ₁) = 1.5597432`? PREREGISTERED
  (`preregs/small_angle_cross_base_v1_20260821.md`). Mechanical output
  **`compromised`**: the control floor read 0.7549 against a locked 0.80,
  because the control row `round(b^(r/2))` cannot survive the depth window —
  the mode decays to `4.3e−10` of itself by depth 8 while rounding noise
  amplifies by `2^8`. No verdict. See entry 73.
- **O49** — gain as a function of depth, per base. EXPLORATORY. The plateau is
  entered at `d = 1` or `2` in **every** base, and it is not noise: it is the
  **C2 ceiling `1 + b^(−1/2)`, attained at 97.68% ± 2.91% across twelve
  bases**. `StmtC2` proves containment; this is attainment. Depth is a power
  iteration and saturates immediately, so **no depth window exists in which a
  sub-ceiling mode is visible** — which is why O48 could not see the null. At
  `b = 1.5597432`, γ₁ sits at 0.0% of the band and γ₂ at 99.9%: the base that
  nulls one zero hands the ceiling to a neighbour. Entries 74, 75.
- **O50** — O17's statistic at 490× its prime count. EXPLORATORY. O17 was
  capped at `xmax = 1.5e8` by a numpy sieve; primecount evaluates `π(10^11)` in
  4 ms, so the limit recorded at § Core quantities — "only ~16 disjoint blocks
  however the ladder is sampled" — was a sieve limit, not a mathematical one.
  On a ratio-1.002 ladder, 6914 blocks over 4.11e9 primes, **38 zeta zeros
  separate completely**: amplitude at the zeros median 6.905 / min 6.478,
  between them median 0.189 / max 2.341, none of 38 below the largest
  midpoint. O17 found three. The dyadic control still fails (3 of 6 below the
  max midpoint) because its Nyquist is 4.5 and γ₁ is aliased at any prime
  count. Entry 79, `papers/The-Deep-Ladder.md`.



- **O51** — the four-way occupancy census of the `2·3` lattice, in dyadic
  blocks. EXPLORATORY. Sieve to `2^30`, `r = 3…30`; the twin/lo/hi/bare split
  partitions the sites exactly at every rung. The site count alternates ±1/3
  about `2^(r−1)/6` and is **not exactly geometric**, so
  `PairIdentity.pair_identity` does not transfer. `lo − hi` normalised by
  `√sites` stays inside ±0.25 and changes sign across rungs. The twin arm's
  difference table has four exact zeros over 377 cells at `d ≥ 1` —
  (4,1), (6,1), (9,1), (8,4) — all at `r ≤ 9`. Entry 82,
  `papers/The-Twin-Lattice.md`.
- **O52** — does the composite arm carry the prime arm's zeta spectrum?
  EXPLORATORY. On O50's fine ladder, 6914 blocks: `max |e_prime + e_comp|`
  1.490e−08 against `max |e_prime|` 3392.646, ratio 4.392e−12. Amplitudes at
  599 zeros agree to 5.006e−12. The algebra forces `e_comp = −e_prime`, so the
  run is a confirmation with an artifact behind it. **No lab_notebook entry
  records it** — the only trace is `results/composite_arm_spectrum.json`.
- **O53 / O54** — is the torus's modular parameter `τ = 2π/log b` the alias
  spacing? EXPLORATORY. O53 run 1 folded 60 zeros and read a base split
  `{2,4,6,8}` beating chance against `{3,9}`; run 2 swept the fold density and
  the split moves with the knob — base 9 reads 0.66 at `nz = 6`, base 8 reads
  0.26 at `nz = 40`. Run 1's split is **retracted** (entry 85). O54 held
  `b = 2` and moved only the ceiling: the ratio runs 0.27 to 1.94, the peak
  count runs 0, 1, 2, 3, 3, 5, and at 12 rungs the statistic is undefined. Run
  2's "base 2 holds at every setting" is withdrawn as well. Entries 85, 87.
- **O55 / O56** — the arm involution `prime ↔ composite`, and `σ = prime/S`.
  EXPLORATORY, base 2, `r ≤ 62`. Pair identity holds at all 1953 cells. The
  involution's fixed set is three cells — (2,0), (3,0), (3,1) — with empty
  overlap against the four exact zeros; smallest `|ρ|` is 0.221696 at (7,1).
  O56: `1/σ` against `ln x` runs 1.9236 → 1.0091, and the least-squares slope
  of `1/σ` in `r` is 0.6813 against `ln 2 = 0.6931`, ratio 0.9830.
  Entries 91, 92.
- **O57 / O58** — EXPLORATORY. O57 runs the measured `γ̂₁` forward in extent:
  13.9885 at `xmax 1e6` → 14.1470 at `1e11` on O17's ladder; on the fine
  ladder 14.1000 → 14.1345, error −0.0002 over 6914 blocks. A blind search
  over 0.5–40 returns the six zeta zeros in range as its top six peaks,
  5253.69× to 5397.79× the median, the seventh at 15.90×. O58 fits one
  exponent per zero: mean slope −0.00043, sd 0.00175, `Re ρ = 0.49957 ±
  0.00175`, against a midpoint noise floor 45× wider. Entries 93, 95.
- **O59 / O60** — the proved maps of `lean/Transform.lean`, run on numbers.
  EXPLORATORY. O59: O58's six measured radii land 0.706319 to 0.708777 against
  the critical `2^(−1/2) = 0.707107`; the fold saturates, 599 of 599 adjacent
  gaps below `dγ` at bases 2, 3, 10. O60: the prime triangle's mean root
  modulus walks 0.540556 at `d = 0` to 0.867729 at `d = 20`, crossing at
  `d = 10`, while the smooth control moves 0.541091 → 0.597455. Entry 100.
- **O61** — is the critical-radius crossing structural or a truncation
  artifact? EXPLORATORY. Base sweep at ceiling `1e12`: base 2 crosses at depth
  10.08, base 3 at 15.46, bases 4–9 never. Truncation control at fixed base 2:
  crossing depth 4.24 (20 rungs) to 11.93 (45 rungs), spread 7.70; as a
  fraction of rungs, spread 0.053. Entry 100 records two readings killed by
  later runs on a sub-integer sweep that is **in no artifact**.
- **O62** — OEIS submission package for the iterated difference table of
  A036378. Not a measurement. 992 array entries available, first 260 emitted
  as downward antidiagonals plus a b-file; the four zeros land at terms 4, 8,
  34, 176, and across the array to `r = 62` the zeros at `d ≥ 1` are exactly
  the four. Entry 100.
- **O63** — where a given density value appears, across bases and difference
  orders. EXPLORATORY. Entry 102's imported refraction claim does not
  reproduce; the control is the result. Fraction of cells with `|v| ≤ 20` per
  depth against 400 Poisson draws at base 2's own per-rung means: depth 5
  reads 0.235 real against null mean 0.077, `0/400` draws reaching it,
  `z = 3.3`; depth 4 `z = 2.4`; every other depth unremarkable. Entry 102
  carries three caveats — sixteen depths tested, `n = 1` where it counts, and
  sub-Poisson variance as the likely known cause.
- **O64** — does the spectrum read out of prime counts inherit the zeros' GUE
  repulsion? EXPLORATORY. Run 1's instrument manufactures repulsion: Poisson
  frequencies enter at `frac<0.5 = 0.372` and exit at 0.102, and its log line
  "the real arm sits nearer the model arm" is **withdrawn** in entry 103. Run
  2, band (10, 120): real `n = 37`, mean `s` 1.003, `frac<0.5` 0.027 — equal
  to the true zeros' direct values to three decimals. Entry 103.
- **O65** — variance-to-mean `F` of prime counts in blocks. EXPLORATORY. Run
  1's raw `Var/mean` is dominated by the falling density at large `H`
  (`F = 40796` at `x0 = 1e10`). Run 2 detrends by li per block and reads
  sub-Poisson at every scale: 0.536 → 0.222 for `x0 = 1e6`, 0.663 → 0.150 at
  `1e10`, and inside single dyadic blocks 0.376 / 0.257 / 0.198 at
  `r = 20 / 27 / 33`, with the Poisson control pinned at 0.92–1.07. Entry 105;
  this is the grounding O63's caveat asked for.
- **O66** — the twin process on the `6k` lattice: rigidity and pair
  correlations. EXPLORATORY. Run 1 mis-normalised the Hardy–Littlewood
  prediction; run 2's corrected `S₄/(6·S₂²)` reads `mean |R − HL|` 0.0209 /
  0.0391 / 0.0434 at `x ~ 6e6 / 6e8 / 6e10`. `F(256)` twin|Bernoulli reads
  0.929|0.932 at the top height — one window and one draw each, so the
  load-bearing endpoint is degenerate with its own control. **Rigidity reading
  superseded by O72** (entry 151). Entry 107.
- **O67** — under RH, `cell(r,d) ≠ 0` beyond an explicit `R(d)`. A derivation
  with numerically checked constants; no prereg governs it. `R(d)` runs 16 at
  `d = 1` to 91 at `d = 15`, `≈ 5d + 11`; O43's `r ≤ 92` census closes every
  strip to `d = 15`. Under RH, **(20,6) is the last exact zero at every depth
  `d ≤ 15`, for all `r`**. The deep region `d > 0.34(r−d−1)` is untouched, and
  `r ∈ (92, 96)` at `d = 16` is open. Entry 112.
- **O68** — how weak the RH-conditional bound can get before the theorem dies.
  EXPLORATORY, sanity-gated against O67 R-for-R. Under `|π − li| ≤
  C√x(log x)^k` for `x ≥ x0`: `depth_covered` 15 (Schoenfeld), 12, 10
  (`C = 1, k = 2`), 8 (`C = 100`), 6 (`C = 1000`), 0 (`C = 1e6, k = 3`).
  Entry 118, which also corrects entry 116.
- **O69** — how many windings until the angle count becomes the logarithm.
  EXPLORATORY. On 100000 zeros to `γ ≤ 74920.8`, `|N − mainterm|` never leaves
  Rosser's band, so the crossover is at winding zero; within 0.1% of the curve
  from winding 1049. The Γ-phase logarithm carries 99.9994% of the count and
  `max |S-part|` is 1.629 windings. Entry 120.
- **O70** — O67/O68's census at the constant the stage-3 kernel actually
  computed. EXPLORATORY. hNT at Rosser (0.137, 0.443, 6.1), `W = 0`, hEF's
  `(c₁, c₂, x₁)` swept over 16 cells: `C_π` 301.24 → 556.24, and
  **`depth_covered = 9` in every one of the 16 cells**. The chain's inflation
  is affordable at census width. Entry 129.
- **O71** — testing upstream's horizontal-vanishes statement before flagging
  it. EXPLORATORY. `J(δ)/2 ln(1/δ)` falls 1.195 → 1.031 as `δ: 1e−1 → 1e−6`,
  which is the pole mechanism; with a concrete admissible `φ`, the required
  `δ` exists at every height. Entry 142; the PNT+ #1538 note is drafted and
  **unposted**, and posting is Julian's call.
- **O72** — O66 v2, with stated uncertainty at every height. EXPLORATORY.
  Seven heights `1e6…1e12`, eight disjoint windows each, 32 Bernoulli
  replicates. Twin sits below its null at every height and block size:
  `F(256)` `z = −14.44` at `6e6` through `−12.66` at `6e12`; low-frequency
  `z = −24.59` to `−19.92`. `mean |R − HL|` 0.0258–0.0413 against a Bernoulli
  floor 0.0264–0.0443. Entry 151: O66's `6e10` endpoint was sampling noise,
  and the rigidity decays smoothly while staying many sigma from the null.
- **O73** — the Weil-form balance across the mollifier grid. EXPLORATORY. The
  sanity gate reproduces entry 40's three anchor numbers to 1e−14. Across
  `W ∈ {0.02, 0.05, 0.1, 0.2} × K ∈ {2, 3}` the two sides swing from 11909.13
  to 0.0433 while the relative difference stays between 1.635e−10 and 4.312e−6.
  Per-prime breakdown at the anchor: `p = 2` gives 0.9969 of the prime term,
  `p = 17` the largest counterweight; 25 primes contribute. Entry 152.
- **O74** — the interleaved dyadic + triadic row sums, machine-verified.
  EXPLORATORY. The gate reproduces entry 31's hand-computed `r = 1…6` exactly.
  Extended to `r = 41`, the `pi3n_cache.json` ceiling: the dyadic component
  changes sign throughout, the triadic never does. Entry 153.
- **O75** — entry 36's crossing-slope law, met with data it has never seen.
  EXPLORATORY. The gate reproduces entry 36's `b = 2, 3` slopes and
  predictions to four decimals. Seven fresh non-integer bases: five within
  ±10.4%, Pearson `r = 0.9602`, with the two large misses at the window edge
  where `ratio → 1`. Entry 154 maps the law's testable windows to roughly
  [2.05, 2.25] and [2.70, 3.30].
- **O76** — the exact-zero census on the joint `{2^m 3^n}` orbit, entry 62's
  unasked question. EXPLORATORY. Commensurability gate passes first. 564 rungs
  to 2.199e12, 158766 cells; 20 exact zeros at `d ≥ 1`, of which 15 sit at
  window top ≤ 100. Above the floor: five, pair values ≤ 129, deepest `d = 5`,
  highest window top 11664. Entry 155: asked jointly, the answer matches O44's
  answer asked singly.
- **O77** — instantiating a Lean leaf pair against its consumer, the same
  instrument O71 aimed upstream. EXPLORATORY. At disk radius `3/2` the count
  is 0 on the whole grid — CANNOT FEED; at `7/4` the half-width is 0.9014 and
  `|S(T)| ≤ 0.462·cnt(T) + 0.508` holds. Entry 158 makes consumer
  instantiation a standing per-leaf requirement.
- **O78** — the zero-surface statistic over bases pairwise incommensurate by
  construction. EXPLORATORY. Both gates pass: 0 exact cross-base edge
  coincidences against O45's 901 of 918, and no base within 0.021 of the
  `π/(4γ₁)` lattice. 54 zeros, cross-base `z = −7.20`, width-matched `−3.71`.
  **The reading is retired by entry 160**: the dropped within-base control
  fires harder, the coordinate map is injective so the two hypotheses are one
  statement, `√(54/125)` rescaling accounts for both numbers, and `--alpha`
  was never swept (width-matched `z` ranges −0.90 to −6.89). Entry 165 later
  corrects entry 160's own FATAL 2. `papers/The-Zero-Surface.md` § G1 stands
  unmeasured.
- **O79 / O80** — the same primes sorted mod 5, and where the
  Davenport–Heilbronn zeros are. EXPLORATORY; both gate on
  `τ = 0.28407904384` against `τ² + (1+√5)τ − 1 = 0` and on the completed
  function's functional equation before measuring. O79 to `r = 30`: the zeta
  arm returns the four zeros; the four class tables carry 5, 3, 5, 6 exact
  zeros, and **(8,3) and (20,6) appear in no class table**. The DH combination
  is an integer only where `c₂ = c₃`, so it carries no exact-zero object. O80:
  eight on-line DH zeros to `t = 25`, lowest 5.0941598 against zeta's
  14.134725; winding count right of the line is 0 below `t = 60` and 1 in each
  of `(60, 90)` and `(90, 120)`, located at `σ = 0.808517182457` and
  `σ = 0.650830080610`. Entries 161, 162.
- **O81** — does the DH-weighted prime residual carry `L(s,χ)`'s zeros or DH's
  own? **PREREGISTERED** (`preregs/dh_coalition_spectrum_v1_20260825.md`,
  locked `9f500ecd2eb81ce7…`). Gates pass; list A recomputed inside the run to
  the locked values. 119 blocks, surrogate `P_max/median` p95 3.468. Hits at
  `P/median > 5`: **0 of 15 on list A, 0 of 8 on list B**. Mechanical output
  `null`; **the verdict line is Julian's and is unwritten.** Entry 164 reads
  the length as the likely cause.
- **O82** — does exact vanishing do work that near vanishing does not?
  EXPLORATORY. 19016 resolved cells, exact-zero set `n = 54`. Panel 1
  reproduces entry 160's FATAL 2. Panel 2 subsamples every selection to
  `n = 54`: zeros `−3.56` width-matched, `|P| = 1` `−2.40`, `|P| = 2` `−3.86`,
  `1 ≤ |P| ≤ 3` `−3.30`, mass cut `S ≤ 200` `−6.03`, `d ≤ 3` `−0.13`. Entry
  165: FATAL 2's headline does not survive matched `n`, exact vanishing stays
  indistinguishable from near vanishing, and the mass cut is the strongest
  selection in the table.

Known defects in the current state:

1. **O9's part 2 control is ill-posed, and part 3's null is not
   evidence.** The crossing is not a single number: per-t crossings span
   0.685 in σ (1.177 / 1.126 / 0.792 / 0.491), two of the four columns
   are fitted at r² < 0.5, and the reported 0.8814 is the crossing of a
   mean rather than a mean of crossings. Part 3's "smooth through 1/2"
   is true of the computed curve and uninformative about the hypothesis,
   because O13 shows the statistic's null tops out below its own
   threshold. Both verdicts are retracted as evidence; part 1 is
   unaffected.
2. **Duplicate artifacts, now known deliberate.** `O9_run.log` ≡
   `O9_run_default.log` and `O8_run.log` ≡ `O8_run_dps300.log` are
   preservation copies made before re-runs, because the results filename
   is fixed with no timestamp or tag and every re-run clobbers unless
   `--out` is passed. The clobber hazard is the real defect.
3. **FIXED 2026-08-25 (entry 148).** The hardcoded-parameter thread of
   entries 28 and 35 is closed: O30, O31, O32, O34, O35, O36, both O37s
   and O38 now carry the house flag set and a results JSON, all nine
   re-run at defaults with zero drift. `papers/What-Didnt-Work.md`'s
   provenance warning for B3–B9 is superseded accordingly.

4. **The prereg's `pre_compute_sha256` is still `PENDING`** while its
   Run record asserts the post-compute SHA is identical to it.
5. **Six of the seven cited documents are absent** — `dyadic-table-v2.md`,
   DT-A, DT-A2, DT-A3, DT-A4, and O3c are referenced by script headers
   and by DT-A5/A6 but exist in no folder on this machine.
6. **No prereg for O3, O4, 05, 06, O8, O9** — their numbers are
   exploratory, not verdicts.
7. **`check_refs.py` verifies that a citation's target exists and never
   that the target says what the citing line claims.** Entry 88:
   `The-Deep-Ladder.md` § F4 cited `Euler-Factor-Chain.md § J5` for a
   claim about analytic continuation; J5 is about RH and says nothing of
   the kind. The gate passed it clean for as long as it stood. Run
   `python3 utilities/check_refs.py --audit` to pair every cross-document
   `§` citation with the text it points at; the reading is a person's.
   This is the same failure shape as the `§ B4` case in `CLAUDE.md`, with
   the target present and misread rather than absent and misreported.

### The Lean tree, as of entry 170

Two packages, welded by statement identity only.

**`lean/` — the bench, 20 modules, 250 theorems, 250 `#guard_msgs` pins,
toolchain v4.28.0.** `lake build` is the regression check; see
`lean/BUILD.md`, and **do not run `lake update`** — four dependencies
track `main`. The chain runs from the integer table to the pole lattice:
`Chain.tableFrom_eq_bdiff_iter` welds the table to `bdiff`,
`Superposition.tableFrom_eq_modeSum_reweighted` carries it onto a
reweighted sum over zeta modes, and `Zeros.measured_zeros_all_vanish`
computes all four zeros from `π(2ⁿ)` at zero axioms rather than
transcribing them. Later modules: `Transform.lean` (the torus, with
`periodLattice_discrete`; compactness open), `Isogeny.rowN_eq_blockSum`
(a degree-`k` isogeny sums the row in blocks of `k`, so bases inside an
isogeny class carry no count their generator lacks), `TwinLattice.lean`
(`twin_lower_mod_six` — every twin pair above 3 sits at `(6k−1, 6k+1)`),
`Nonvanishing.lean` / `MainTerm.lean` / `Expansion.lean` (O67's arrow
under the kernel, the MVT retired, the `2^x/x` expansion), and
`Schoenfeld.lean` (`StmtSchoenfeld` verbatim from Cor. 1, with
`tableFrom_ne_zero_of_schoenfeld` as the arrow). `GeneratorPeak.lean` is
the structural refutation: `no_interior_peak` proves no exponents
produce the measured four-generator shape.

**`lean_stage3/` — the sibling package, 8 modules, 77 theorems, 77 pins,
toolchain v4.32.2**, with PrimeNumberTheoremAnd pinned at `47fa486`
(entry 156 bumped it from `751a8c2`; `lake update` there is a deliberate,
logged act, not routine). It decomposes Schoenfeld: `Statement.lean`
names the weak family, `PsiToPi.lean` delivers `(3C+13, k−1)` into it,
`ZeroSum.lean` and `Assembly.lean` close
`psiWeak_of_RH_EF_NT` from `{hRH, hEF, hNT}` with a computed constant,
`RvMCrude.lean` splits hNT over an abstract phase, `Stirling.lean`
**discharges the Stirling half outright** (`backlundPhase_holds :
StmtBacklundPhase phaseTheta 97 98`, entry 140), and
`ArgCrude.lean` / `JensenCount.lean` decompose the argument half and
discharge its analytic core (`zeta_local_zero_count ≤ 15·log T + 73`,
entries 157–159, repaired at radius `7/4` after the tangency defect).

**The leaf ledger is `{hEF, StmtArgCrude}`.** Both are upstream-shaped:
`Kadiri.backlund_bound` states the full hNT and remains `sorry` at the
current pin, and `I2NewBound` / `I3NewBound` are the contour pieces
toward hEF. Composition across the two packages is **BY STATEMENT
IDENTITY ONLY**, gated by `utilities/check_weld.py`, and every published
claim carries that caveat until the toolchains converge.

The smallest test that would falsify the bench as a whole: re-run O7
from the locked prereg on a clean checkout and reproduce
`post_compute_sha256` byte-identically. The prereg claims determinism
via `default_rng(2026)`. Entry 101 ran it on the same machine — the SHA
reproduced and 170 of 171 JSON leaves matched, only `generated_utc`
differing — so determinism is shown and **portability is not**; a second
machine has never run it. If that SHA does not reproduce elsewhere, no
verdict in this folder is load-bearing.
