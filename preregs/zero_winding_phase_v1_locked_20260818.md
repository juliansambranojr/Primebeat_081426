# Prereg — zero winding phase, are the four exact zeros turn marks on a spiral? (v1)

STATUS: **LOCKED**

## Background

The dyadic prime difference table (backward, unit-weighted, prime side)
has exactly four exact zeros over its whole computed support. Read from
`results/O16_run2.log` § "EXACT ZEROS (depth >= 1), all four tables":

```text
  backward_prime:  4 zero(s)
    (r= 2, d= 1)  ...
    (r= 4, d= 1)  ...
    (r= 8, d= 3)  ...
    (r=20, d= 6)  ...
```

Same file, § "TABLE EXTENTS", records the backward-prime table as
**1953 cells**, max r **62**, max depth **61**. The same four cells and
the same cell count appear in
`results/O16_centered_difference_table_run2.json` at
`constants.documented_backward_zeros` and
`summary.extents.backward_prime.n_cells`.

`lean/Zeros.lean` states the standing hole in the chain: "Nothing below
predicts r = 20 or d = 6, and nothing below could." `lean/Construction.lean`
states the complement: the table has no free parameter, so the zeros were
not placed. Location is unexplained; existence involves no freedom.

Julian's posit is that the locations are not scattered — that each zero is
a point of balance on a spiral, after which the structure advances a fixed
angle and grows again, four turns closing a circuit.

The chain already carries the winding coordinate this posit needs.
`papers/Euler-Factor-Chain.md` **A1**: on the ladder `x = b^r` the backward
difference applied to the mode `x^ρ` returns `(1 − b^(−ρ))·x^ρ`. So one
step in `r` multiplies by `b^ρ` and one step in depth multiplies by
`(1 − b^(−ρ))`. Taking arguments on `Re(ρ) = 1/2` gives an accumulated
phase at cell `(r,d)`

```text
Φ(r,d) = r·γ·log b + d·arg(1 − b^(−ρ)),    ρ = 1/2 + iγ
```

`REFERENCES.md` § "Constants used across the bench" already locks the
`r`-step half of this for the first zero in base 2:
**ω₁ = 3.514260 rad/regime (γ₁·ln2; aliases to 2.7689)**.
`papers/Euler-Factor-Chain.md` **D5** states the same quantity unreduced:
b = 2 at γ₁ is "201.3°, 1.559 turns per rung".

This prereg tests whether the *differences* of Φ between consecutive
zeros are the constant angle the spiral posit requires.

## Primary hypothesis

H0: the four exact zeros are positional facts about π with no winding
structure. The phase increments ΔΦ between consecutive zeros, reduced mod
2π, are no more mutually consistent than those of an arbitrary set of four
cells drawn from the same table support, at any zeta zero γ.

H1: the zeros are turn marks. There exists a zeta zero γ at which the
three consecutive ΔΦ agree, i.e. the structure advances the same angle
between one zero and the next.

Predicted direction under H1, in Julian's stated version: that common
angle is **π/2** — a quarter turn, four of them closing a circuit. The
weaker and more important form of H1 drops the π/2 and asks only that the
angle be constant.

Test A is the strong (quarter) form. Test B is the weak (constant) form.
The verdict precedence below encodes that A implies B.

## Provenance disclosure (required reading)

This is the section that decides how much of this test is worth anything.

1. **The four zero locations are not blind.** `(2,1)`, `(4,1)`, `(8,3)`,
   `(20,6)` have been inspected by Julian and by the assistant repeatedly,
   across this session and prior ones. They appear in `CONTEXT.md`, in
   `lean/Zeros.lean`, in `lean/Construction.lean`, and in two results
   artifacts. No arm of this test uses unseen zero locations, because
   there are none — O16 reports these four and no others over the whole
   support.

2. **Test A at γ₁ specifically is not blind.** Before this prereg was
   written the assistant hand-estimated the phases at γ₁ = 14.134725 in
   base 2 and obtained, **approximately and by hand**:

   - per r-step: ≈ 9.7974 rad
   - per d-step: ≈ −0.1538 rad
   - the three gap phases mod 2π: ≈ 0.75, 1.18, 4.01 rad
   - against π/2 ≈ 1.5708

   i.e. **the quarter-turn reading at γ₁ appeared not to hold**. These
   five numbers are hand arithmetic, not machine output, and are recorded
   here as approximate and **unsourced** — they come from no file in
   `results/`. They are written down so that agreement with the script is
   a check on the hand arithmetic and disagreement is a caught error, not
   a surprise. Test A's result at γ₁ must not be reported as a blind
   confirmation or a blind refutation.

   (The per-r-step figure is consistent with the sourced ω₁ = 3.514260
   rad/regime in `REFERENCES.md`, since 9.7974 − 2π = 3.5142. The
   consistency is why the hand estimate is disclosed rather than
   discarded.)

3. **Tests B, C, D and E are blind.** No one — Julian, the assistant, or
   any prior agent — has computed a constant-angle fit at any γ, the
   merged same-depth reading, the null distribution over random cell
   sets, or the rate law on the r-gaps. No scan over more than one γ has
   been run at all. Nothing in `results/` contains a winding phase.

4. **The r-gaps 2, 4, 12 and the d-gaps 0, 2, 3 are arithmetic on lines
   169–172 of `results/O16_run2.log`**, not new measurement. They are
   stated in this prereg because Test E's fit is defined on them.

## Locked parameters

No parameter may be added, removed, or re-valued after lock. In
particular no `--seed` flag is added; the seed is hardcoded, following
`REFERENCES.md` § Constants and the house prereg
`preregs/alpha_depth_trend_v1_locked_20260814.md`.

| parameter | locked value | why this value |
| --- | --- | --- |
| `base` (b) | **2** | The table under test is dyadic. `results/O16_run2.log` computes N(r) on (2^(r−1), 2^r]. |
| `dps` | **50** | mpmath working precision for every observed statistic. Two orders more than the 25-digit zero cache carries, so the cache is the precision floor, not the arithmetic. |
| `zeros_source` | **`zeros600.json` at the project root** | 600 imaginary parts at dps 25, written by `mkzeros.py` from `mpmath.zetazero`; recorded in `CONTEXT.md` § Caches. Deterministic, already in the tree, no recompute. |
| `M` (zeros scanned) | **200** | First 200 entries of that cache. Wide enough that a constant angle at any low zero is reachable; small enough that the null at 20000 draws is seconds, not hours. |
| `zero_set` | **(2,1), (4,1), (8,3), (20,6)** | `results/O16_run2.log` § EXACT ZEROS, backward_prime. Also `results/O16_centered_difference_table_run2.json` → `constants.documented_backward_zeros`. |
| `phase_map` | **Φ(r,d) = r·γ·log b + d·arg(1 − b^(−ρ)), ρ = 1/2 + iγ** | `papers/Euler-Factor-Chain.md` A1. Not a new coordinate; the chain's own symbol. |
| `gap_reduction` | **ΔΦ reduced mod 2π into [0, 2π)** | Phase is only defined mod a full turn. |
| `spread_statistic` | **circular range: sort the three reduced gaps on the circle, take the largest wrap-around gap G, report 2π − G** | Rotation-invariant, so Test B does not smuggle in a preferred angle. Zero iff the three angles coincide. |
| `tol_quarter` | **0.10 rad** (≈ 5.73°) | Test A fires only if every gap is within this circular distance of π/2. |
| `tol_spread` | **0.10 rad** | Test B fires only if the circular range of the three gaps is at or below this. |
| `null_domain` | **the backward-prime support with d ≥ 1: {(r,d) : 1 ≤ d ≤ 61, d+1 ≤ r ≤ 62}, 1891 cells** | The rectangle r ≤ 62, d ≤ 61 is not the support — `results/O16_run2.log` § TABLE EXTENTS gives 1953 cells for depths 0..61, and the d = 0 row holds 62 of them, leaving 1891 at d ≥ 1. Zeros are only counted at d ≥ 1 in that log. Drawing from the rectangle would draw from cells that do not exist. |
| `null_draw_shape` | **4 distinct cells with 4 distinct r values, uniform without replacement on `null_domain`, ordered by r ascending** | Matches the observed configuration: the four zeros have distinct r. Rejection-sample repeated r. |
| `n_null` | **20000** | Resolves a p-value to 5e−5, well below `alpha_level`. |
| `seed` | **2026**, as `numpy.random.default_rng(2026)`, hardcoded | House constant, `REFERENCES.md` § Constants. **Do not add a `--seed` flag.** |
| `alpha_level` | **0.05**, one-sided (small spread is the alternative) | House level, matching `preregs/alpha_depth_trend_v1_locked_20260814.md`. |
| `p_definition` | **p = (1 + #{null draws with min-over-γ spread ≤ observed min-over-γ spread}) / (1 + n_null)** | Add-one convention; p is never exactly 0. |
| `merged_representatives` | **both `(2,1)` and `(4,1)`** | Test C's merge of the two d = 1 zeros has two defensible representatives. Both are computed and both are reported; **neither may be selected after the fact.** |
| `merged_agreement_rule` | **the merged reading counts toward a verdict only if both representatives fire the same way** | Removes the post-hoc choice. |
| `rate_law_r` | **OLS of ln(Δr_k) on turn index k = 1,2,3, Δr = (2, 4, 12)** | Δr from the locked `zero_set`. Logs are taken because the r-gaps grow multiplicatively; all three are positive so the log is defined. |
| `rate_law_d` | **OLS of Δd_k on turn index k = 1,2,3, Δd = (0, 2, 3)** | Linear, not log: Δd₁ = 0 and ln 0 is undefined. |
| `search_box` | **r ≤ 62, d ≤ 61** | The box O16 actually searched. Any predicted fifth zero outside it is unrefuted by O16, not refuted. |
| `null_arithmetic` | **float64 for the 20000-draw null loop; mpmath at dps 50 for every observed statistic** | Largest null phase argument is < 2e4 rad, so float64 mod-2π error is < 1e−11 rad, eleven orders below `tol_spread`. Recorded so the mixed precision is a locked choice and not a later discovery. |
| `secondary_null` | **a second null with the same draw shape plus non-decreasing d along the ordering** | The observed d sequence (1,1,3,6) is non-decreasing. Reported always; **cannot** change the primary verdict. |

## Primary statistic

For each γ in the scan, compute the three reduced gaps
ΔΦ₁, ΔΦ₂, ΔΦ₃ between consecutive locked zeros, and their circular
range. The primary statistic is

```text
S_obs = min over the M scanned γ of that circular range
```

on the four-zero / three-gap reading. Report the minimising γ, S_obs, and
the circular mean of the three gaps at that γ.

## The five tests

**Test A — quarter turn.** Is every one of the three reduced gaps within
`tol_quarter` of π/2, at any scanned γ? Report every γ that qualifies, or
that none do, together with the per-gap circular distances from π/2 at γ₁
and at the Test-B minimiser.

**Test B — constant angle.** The primary statistic above. Report the
minimising γ and S_obs.

**Test C — the same-depth collision.** `(2,1)` and `(4,1)` share d = 1.
Run both readings: (i) four zeros / three gaps, which is the primary;
(ii) the merged reading, three zeros / two gaps, computed once with
`(2,1)` as the merged representative and once with `(4,1)`. Report both
merged results. Circular range of two angles is their circular distance.

**Test D — the null.** For each of `n_null` draws from `null_domain`
under `null_draw_shape`, compute the same min-over-γ circular range, and
report the empirical p-value under `p_definition`. Report the same for
the merged (three-cell, two-gap) draw shape, and report the null firing
rate of Test A — the fraction of null draws for which some γ puts all
three gaps within `tol_quarter` of π/2. Also run `secondary_null`.

**Test E — rate law and forward prediction.** Fit `rate_law_r` and
`rate_law_d`, extrapolate to turn k = 4, and report the predicted fifth
zero position (r₅, d₅) = (20 + Δr₄, 6 + Δd₄). State plainly whether that
position is inside or outside `search_box`, and whether it is inside the
table support (r ≥ d+1). If it is outside the box, O16's "exactly four"
says nothing about it and the writeup must say so. Test E is reported
unconditionally but is **interpretable only if Test B fires** — a rate law
fitted through three points with no constant angle behind it is curve
fitting.

## Decision rule (locked before data)

Verdict labels are used verbatim in the writeup and in the Run record.

- `quarter_turn` — Test B fires (`S_obs ≤ tol_spread` **AND** Test D
  primary `p ≤ alpha_level`) **AND** Test A fires at the same γ that
  minimises the spread.
  → The zeros are turn marks and the turn is a quarter. Julian's stated
    version stands.

- `constant_angle` — Test B fires (`S_obs ≤ tol_spread` **AND** Test D
  primary `p ≤ alpha_level`) **AND** Test A does not fire at the
  minimising γ.
  → The zeros advance a fixed angle that is not π/2. The spiral survives;
    the quarter does not.

- `no_constant_angle` — `S_obs > tol_spread` **OR** Test D primary
  `p > alpha_level`.
  → H0 is not falsified. This is not the same as showing the zeros are
    unstructured; it is a failure to detect constant winding in this
    coordinate at these M zeros.

- `ambiguous` — `S_obs ≤ tol_spread` and `p ≤ alpha_level` on the
  four-zero reading, but the merged reading under
  `merged_agreement_rule` contradicts it (the two representatives
  disagree with each other, or both fire the opposite way).
  → The result depends on how the d = 1 collision is counted, which is a
    modelling choice this test cannot settle. Design a sharper test. A
    real outcome, not a deferral.

- `compromised` — any of: fewer than `M` finite γ read from
  `zeros_source`; any scanned γ giving `|1 − b^(−ρ)| < 1e−12`, where the
  d-step argument is numerically undefined; fewer than 19000 valid null
  draws returned; the zero set read from `results/O16_run2.log` at run
  time differing from the locked `zero_set`; or mpmath reporting a
  working precision below `dps`.
  → The test ran but the instrument is corrupt for reasons unrelated to
    the hypothesis. No verdict.

Precedence: `compromised` > `quarter_turn` > `constant_angle` >
`no_constant_angle` > `ambiguous`.

## Falsification

H0 is falsified by `quarter_turn` or by `constant_angle`.

H1 is **not** falsified by `no_constant_angle` in general — only in this
coordinate, at these M zeros, at this tolerance. Three gaps is a very
small sample and the writeup must say so rather than claiming the spiral
is dead.

## Vacuousness check

The criterion has a realistic chance of firing in both directions, and
Test D is what guarantees it rather than an assertion.

Firing toward H1 is reachable: if the posit is true the three gaps
coincide and `S_obs ≈ 0`, far inside `tol_spread`, at whichever γ drives
the structure. Nothing in the construction prevents that; the phase map
is fixed by A1 and the zero locations are fixed by π, so the three gaps
are free to agree or not.

Firing toward H0 is reachable and is in fact the default: three angles
drawn at random fall inside a 0.10 rad arc with probability of order
3·(0.10/2π)² ≈ 8e−4 per γ, so a scan of 200 γ gives an order-10⁻¹ chance
of some γ passing `tol_spread` by luck alone. **That is precisely why
`tol_spread` alone cannot be the criterion and why Test D is mandatory.**
The null measures that luck rate exactly, on the same M zeros, the same
phase map, and the same statistic, differing only in where the cells sit.
Without Test D the spread criterion would fire on roughly one arbitrary
cell-set in ten and the test would be worthless.

Test A's tolerance is deliberately stringent: a random configuration puts
all three gaps within 0.10 rad of π/2 with probability of order
(0.2/2π)³ ≈ 3e−5 per γ. Under a true quarter turn it fires by
construction. The null firing rate of Test A is reported by Test D so
that this claim is measured rather than argued.

## What is varied / held fixed

Varied: γ, over the first M zeta zeros; and the cell set, over the null
draws. Held fixed: base, dps, phase map, spread statistic, both
tolerances, the null domain and draw shape, n_null, seed, and the locked
zero set. No existing script is modified. The new script reads
`zeros600.json` and `results/O16_run2.log` read-only and writes only
`results/zero_winding_phase.json`.

## Compute

Seconds to a couple of minutes. mpmath is already in the venv at 1.3.0
and numpy at 2.5.2 (`REFERENCES.md` § Packages). The zero cache is on
disk; nothing is recomputed. Artifact < 1 MB.

## Reproducibility

Deterministic: `default_rng(2026)` throughout, no `--seed` flag added,
zeros read from a fixed on-disk cache rather than recomputed. Re-running
at identical parameters must reproduce byte-identical results apart from
`generated_utc`.

## Analyzer

`O42_zero_winding_phase.py`, at the project root. Written 2026-08-18,
before this prereg was locked and before any run. Cited here by path per
the naming convention in `CLAUDE.md` — do not rename it.

Results: `results/zero_winding_phase.json`.
Log: `results/O42_zero_winding_phase_run1.log`.

## Lock chain

- `lock_written_at`: 2026-08-18T22:36:05Z
- `pre_compute_sha256`: PENDING
- `run_start_at`: (fill at run)
- `run_end_at`: (fill at run)
- `post_compute_sha256`: (fill after run; must equal pre-compute)
- `locked_by`: julian

## Run record

Appended after the run. This append is expected to change the file's
hash; the no-drift check is that `post_compute_sha256` below equals the
sidecar `zero_winding_phase_v1_locked_20260818.sha256`, both taken
before this section existed.

- `run_start_at`: 2026-08-18T22:36:26Z
- `run_end_at`: 2026-08-18T22:36:27Z
- `verdict`: `no_constant_angle`
  The criterion did not fire in the (r,d) coordinate at M = 200. Per the
  locked decision rule this is a failure to detect constant winding *in
  that coordinate*, not evidence that the zeros are unstructured. The
  b-axis reading raised after the run places the turn across bases rather
  than within a single table; O42 did not examine that coordinate.
- `post_compute_sha256`: `b0101319708c70e47704002cfe7b7eb85853521481e8a5ad57a64269e958ca17`
- sidecar match: **yes** — identical to the sidecar
  `zero_winding_phase_v1_locked_20260818.sha256`, so no parameter,
  hypothesis, or decision-rule text drifted between lock and compute.
- analyzer: `O42_zero_winding_phase.py`, one run at the locked flags
- results: `results/zero_winding_phase.json`
- log: `results/O42_zero_winding_phase_run1.log`
