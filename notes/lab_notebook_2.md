# Lab notebook, volume 2 — Primebeat_081426

Volume 2. Volume 1 is `lab_notebook.md`; it is closed and holds entries
1–44. This volume opens at entry 45.

Numbering is continuous across volumes: `entry N` is a unique address
project-wide, and a `NOTEPAD.md` line citing a bare entry number resolves
to whichever volume holds it — 1–44 in `lab_notebook.md`, 45 onward here.

Newest at top, same as volume 1.

Entry format and type vocabulary: `notes/notes_format.md`.

Agents append entries. Outcome markings and status transitions are
Julian's call.

---

## 2026-08-21 — Entry 57 — two scripts quoted a rule that changed, and one artifact now disagrees with its script
type: provenance
refs: 53, 54, 55, 56

**What changed.** `O23_alignment_replication.py` line 1250 and
`O44_cross_base_zero_scan.py` line 10 both carried this verbatim in their
STATUS text: *"Currently only 07/O7 is preregistered."* That sentence was
copied out of `CLAUDE.md` § Prereg discipline when each script was written.

It is now wrong twice over. There are four locked preregs —
`alpha_depth_trend`, `zero_winding_phase`, `extended_zero_census`,
`sub_integer_base_scan` — and as of 2026-08-20 all four carry verdicts:
`depth_dependent`, `no_constant_angle`, `magnitude_floor`, `fineness`.
The CLAUDE.md line the scripts quoted no longer exists.

**Fix.** Both now cite `CONTEXT.md` § "Current state of the world" instead of
enumerating, and both say why: an enumeration goes stale, and this one did.
The same move that took the lab-notebook type vocabulary from four copies to
one and the prereg mechanics out of CLAUDE.md.

**Not an instrument-fix.** Nothing about what either script measures changed.
No re-run was performed and none is needed; prior results remain comparable.

**A divergence, recorded rather than repaired.** O23's sentence sits inside a
JSON output field, `exploratory_note`. So
`results/O23_alignment_replication_results.json` and
`results/O23_alignment_replication_results_run2.json` still contain the old
text. They are frozen records of what the script said when it ran and are
correct as they stand. The script and those two artifacts now differ by that
string, deliberately. A re-run would close the gap and is not worth the churn.

**The general shape.** A quoted rule is a copy, and copies go stale silently
because nothing checks prose against its source. `utilities/check_refs.py`
catches a citation that does not *resolve*; it cannot catch one that resolves
to text saying something different from what the quoter claims. That gap is
open and nothing in the tree closes it.

## 2026-08-21 — Entry 56 — t24: one fact that had been found five times
type: run
refs: 54, 55

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t24_commensurability.py`,
no flags, run 19:09:54. Output
`analysis/2026-08-19_table_structure/results/t24_commensurability.txt`.

**Question.** Whether `log b₁ / log b₂` is rational had decided at least five
results on this bench, each time under a different name. This computes the one
quantity behind all five.

**Headline.** Among integer bases 2…9 the commensurate pairs are exactly the
power chains 2-4-8 and 3-9; bases 5, 6, 7 meet nothing. The sub-integer scan's
family and antiphase arms are all `exp(π·m/(4γ₁))`, so all eight are integer
multiples `m = 2…9` of one unit, `π/(4γ₁) = 0.055565153` in natural log — the
scan is commensurate by construction. For `(20,6)`'s window ratio `2⁷ = 128`
no integer base but 2 reaches it at integer depth; for `(8,3)`'s `2⁴ = 16`,
base 4 reaches it at depth exactly 1.

**What it collects.** The same arithmetic appears as the mechanism in
`t6_multirate` (incommensurability breaks the alias comb), the kill in
CHAIN.md §10 (no inheritance between bases), the obstruction in t22 (the scan
cannot answer its own question), the censoring note in `The-Four-Zeros` § C5,
and a theorem — `Zeros.window_exclusive_of_prime_exponent`, which settles it
for one window and turns on 7 being prime.

**Written up as** `papers/Commensurate-Ladders.md`. Its § F3 records that the
general ladder-intersection statement is the one piece of arithmetic every
result above leans on and was not in the Lean tree; `Zeros.base_of_meets_two`,
`factorization_proportional` and `primeFactors_eq_of_meets` have since closed
the dyadic case and the proportionality, and the ancestor construction remains.

## 2026-08-21 — Entry 55 — t23: the deep zeros as two weighed halves, and one correction to the record
type: run
refs: 54

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t23_fold.py`, no
flags, run 06:02:02. Output
`analysis/2026-08-19_table_structure/results/t23_fold.txt`.

**Question.** Can the deep zeros be read as a balance rather than a vanishing?

**Headline.** The stencil weights `(−1)^k C(7,k)` are antisymmetric about the
window midpoint at `log₂ x = 16.5`, so `(20,6)` is a sum over four straddling
pairs with no leftover term. Split by sign, each arm carries total weight 64
and the two arms weigh **807295 each** on eight values of π sharing no term.
The same wing split reaches `(8,3)`: weights `1,−4,6,−4,1`, arms 8 and 8,
totals **168 and 168**.

**Control.** `(21,6)` folds to 1713, which is `cell(21,6)`. The fold is an
identity for odd stencil order, not a test — every cell equals its folded sum
whether or not it vanishes. `wing+ − wing− = cell` identically, so the wings
cannot be evidence for anything the cell value does not already say. Both are
recorded in the paper as § A4 and § B7 rather than presented as findings.

**Correction to the record.** `(25,11)` was placed on diagonal 13 in
conversation; it is on 14. Caught because the number did not resolve to the
result file. Script and paper both fixed in the same pass.

**Written up as** `papers/The-Fold.md`.

## 2026-08-20 — Entry 54 — t22: the zero surface is unanswerable with this scan, and the base set is why
type: run
refs: 50, 51, 52

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t22_zero_surface.py`,
no flags, run 05:05:24. Output
`analysis/2026-08-19_table_structure/results/t22_zero_surface.txt`.

**Question.** Do O45's 125 pooled zeros form a connected object across bases,
or an interval that merely happens to be occupied? Measured as cross-base
nearest-neighbour distance in the `(lo, hi)` window plane, against a null drawn
from each base's own resolved support, stratified so base composition matches.

**Headline.** Cross-base: observed 0.3745, null mean 1.0524 sd 0.0611,
z = −11.10. Within-base control: observed 1.2550, null mean 3.4454 sd 0.2250,
z = −9.73. The control moves too, so the compression is not about crossing
bases — it is present at every base separately. Width-matched null halves it
to z = −5.32 rather than collapsing it.

**Why it does not count.** The sorted window list carries exact `lo` repeats
across different bases, which is not an accident. Eight of the eleven bases
have `log₂ b` an exact integer multiple of `π/(4γ₁)`, and those eight carry
107 of the 125 zeros. There is no incommensurate pair anywhere in the scan, so
cross-base window alignment is forced by the base selection. The statistic
measures the prereg's choice of bases, not the arrangement of the zeros.

**Written up as** `papers/The-Zero-Surface.md`. The commensurability finding
is also the scope note now attached to O45's `fineness` verdict.

## 2026-08-21 — Entry 53 — t26: `d*` is not a per-base constant, its slope is — and a subcritical base crosses
type: run
refs: 41, 52

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

Written to settle the two CONTESTED banners placed on
`analysis/2026-08-19_table_structure/CHAIN.md` §3 and §4 on 2026-08-20.

**Script.** `analysis/2026-08-19_table_structure/scripts/t26_crossover_by_r.py`,
new, no flags. Output `analysis/2026-08-19_table_structure/results/t26_crossover_by_r.txt`. `t2_crossover.py` is unchanged and its result stands — t26 is a
different measurement, not a re-run, so prior numbers remain comparable.

**Method.** t2 computes `d*` once per base over the whole depth-0 row: the
first depth at which oscillation carries more than half the spectral power.
t26 computes the identical statistic on the row truncated to its first `r`
rungs, sweeping `r`. That makes `d*` a function of `r` rather than a scalar.
Same window, same DC/oscillation split, same `min_n = 10` floor.

**Result 1 — `d*` is not a per-base constant.** Every one of the eight bases
shows `d*` rising with `r`. Dyadic runs `d* = 3` at `r = 13` to `d* = 7` at
`r = 32`. So CHAIN.md §4's fit `d* ≈ 1.1 + 8.1·ln b` correlates eight numbers
that are not constants. `papers/Depth-as-Time.md` § D2 is upheld against it.

**Result 2 — the per-base quantity is the slope.** `d*(r)` is close to
proportional, `d* ≈ c(b)·r`:

```text
base          b        ln b     slope    slope/ln b
family k=1    1.1175   0.1111   0.0125   0.1125
family k=2    1.2489   0.2223   0.0324   0.1458
2^(1/3)       1.2599   0.2310   0.0339   0.1467
family k=3    1.3957   0.3334   0.0635   0.1905
2^(1/2)       1.4142   0.3466   0.0611   0.1763
family k=4    1.5597   0.4445   0.0814   0.1831
dyadic        2.0000   0.6931   0.2023   0.2919
```

`corr(ln b, slope) = +0.9735`, fit `slope ≈ 0.3246·ln b − 0.0409`. So §4 found
a real relationship and attached it to the wrong variable. The correlation
survives the correction; the quantity it correlates does not.

**Result 3 — a subcritical base crosses.** `papers/Depth-as-Time.md` § C4 says
bases with gain ratio below 1 have "no instability at any depth, at any `r`".
Family k=4 has ratio 0.5553 and crosses at `d* = 1` by `r = 11`, rising to 5.
CHAIN.md §3's observation was correct and the contradiction is real.

**Reading, and it is harsher than either section.** All eight bases cross,
including the subcritical one, each at a fixed fraction of `r`. A statistic
that fires on every table at `d* ≈ c(b)·r` is not measuring the § C3
instability — it is measuring something that happens to any table with depth,
plausibly the shrinking row length. So the resolution is not "§ C3 is wrong":
t2's `d*` and § C3's crossover are different quantities that were being
compared as if they were one.

**Against O33.** `Depth-as-Time` § D3 reports slope 0.3031 for b=2 from O33's
turnaround series. t26 gives 0.2023 on this statistic. Different quantity,
different turnaround; neither refutes the other, and they are not
interchangeable.

**Open.** What `d*` actually tracks. If it is row length, `d*` should scale
with the number of surviving points rather than with `b`, and the
`slope/ln b` column — which drifts 0.11 → 0.29 rather than staying flat — is
the place to look. Nothing here tests that.

## 2026-08-19 — Entry 52 — O46/O47: `density ≈ 1/S` refuted, the zeros live in the thin tail, and (20,6) does not survive refinement
type: result-triage
refs: 47, 50, 51

Two EXPLORATORY reads of entry 51's run of record — no prereg, no
p-value, nothing stamped. `O46_mass_density_check.py` →
`results/mass_density_check.json` (24,756 B) +
`results/mass_density_check_run1.log` (126 lines), 2026-08-19T07:43:07Z;
`O47_high_mass_zeros.py` → `results/high_mass_zeros.json` (180,549 B) +
`results/O47_high_mass_zeros_run1.log` (278 lines), 08:09:13Z. Both open
O45's script and JSON read-only and both re-derive its stratum:
geometry matches the locked table at all eleven bases, zero sets match
O45 exactly, and O46's mass recurrence agrees with O45's
`stencil_mass()` over 2297 cells, **0 mismatches**. No cell violates
`|cell| ≤ S` and no resolved cell has `S = 0`, so not one zero in the
run is arithmetically forced.

**The mechanism proposed, and its refutation.** `mass_bound` is exact:
a cell is a signed integer in `[−S, S]`, `S(r,d) = Σ_k C(d,k)·N(r−k)`.
If cell values were spread over that range, landing on 0 would go like
`1/S` — a parameter-free prediction with no free constant, testable in
two forms. Both fail:

```text
  density x mean(S)    min 3.07433e+09   max 4.25686e+47   spread 1.38465e+38
  density / mean(1/S)  min 0.617483      max 3.43727       spread 5.56658
```

A spread of 1 would be exactly constant. The parameter-free product
spreads by 38 orders of magnitude. The sharper form is far better
behaved — a factor of 5.6 — but it does not cluster at 1 either: eight
of the eleven bases sit between 2.30 and 3.44, base 2 at 1.72, and two
bases fall below 1 (`2^(1/3)` at 0.617, antiphase `k = 4` at 0.799).
Clustering at 2–3 is a real regularity and is not the prediction.

**And the premise itself is false.** `|cell|/S` over the resolved
stratum has median between **3.52e−4** (`2^(1/2)`) and **2.20e−3**
(`2^(1/3)`), so roughly `1e−3` at every base. Cells sit three orders of
magnitude inside their own bound. They are not spread over `[−S, S]`,
so the chance of hitting 0 was never `1/S`, and the two spread factors
above are measuring a model that was wrong at its first line.

**What replaced it: the zeros live in the extreme thin tail of the mass
distribution.** Per base, median `S` at a resolved zero against median
`S` over the whole resolved stratum:

```text
  median S at a zero        8  to  516     across the eleven bases
  median S over the stratum 2.40e+07 (base 2) to 3.55e+18 (finest base)
```

Base by base the ratio of the two runs from **5.4 orders** of magnitude
(antiphase `k = 4`) to **17.1** (the finest family base); base 2's own
is 5.7. The typical zero is a cell with almost nothing to cancel. Which
makes the high-`S` end the interesting end, and it is what O47 ranks.

**Checked and only half true: zero density does rise with `b`.** The
claim carried into this entry was that density rises roughly
monotonically across the eleven bases with base 2 the maximum at about
4× the finest. Recomputed from `zeros_per_resolved_cell` in
`results/sub_integer_base_scan.json`, identical to `density` in
`results/mass_density_check.json` at all eleven bases: base 2 **is** the
maximum at 8.065e−3, and the finest base is 2.067e−3, a ratio of
**3.90**, so "about 4×" holds. "Roughly monotonically" does not, as
written. Four of the ten adjacent steps in `b` decrease, and two bases
sit far off any trend — `2^(1/3)` at 8.40e−4, a quarter of its
neighbours, and antiphase `k = 4` at 2.32e−3. The rank trend is real but
moderate: Spearman ρ = 0.655, Kendall τ = 0.564 (43 concordant pairs
against 12 of 55), permutation p ≈ 0.017 one-sided. Direction yes;
monotone no.

**The pooled ranking, 125 resolved zeros across all eleven bases.**
Base 2's four carry `S = 2, 4, 88, 492384` and land at pooled ranks
**115, 102, 37 and 3** — three of the four in the bottom quarter, and
`(20,6)` third from the top. Above it sit two cells of `2^(1/2)`:

```text
   1  2^(1/2)  (34,11)  S = 1371038   log2 window [11.5, 17.0]
   2  2^(1/2)  (42, 5)  S =  651298   log2 window [18.5, 21.0]
   3  base 2   (20, 6)  S =  492384   log2 window [14.0, 20.0]
   4  antiphase k=2 (47,4)  S = 87160
```

and the largest ratio gap anywhere in the pooled list is exactly the one
after rank 3: **5.649** = 492384/87160 = 61548/10895 exactly. So the
high-mass end is a four-cell club — two at `2^(1/2)`, `(20,6)`, and one
antiphase cell — and then it falls off a cliff. `(20,6)` is no longer
the most massive cancellation on record.

**The (40,12) result, and it is the sharp one.** At `b = 2^(1/2)`, the
cell `(40,12)` is the exact image of base 2's `(20,6)` under factor-2
refinement: `r` doubles, `d` doubles, and the window bottom `b^(r−d)`
lands on `2^14` as `b^r` lands on `2^20`. O47 checks the identity
directly rather than assuming it — `identical integer bounds: True`,
window `(16384, 1048576]` on both sides, `80125` primes in the window
on both sides. The **same primes, the same value interval, the same
question asked at twice the resolution.** The cell reads

```text
  base 2      (20, 6)   cell =     0     S =   492384
  base 2^(1/2)(40,12)   cell = -6884     S = 15723924    |cell|/S = 4.378e-04
```

`(20,6)` **does not survive refinement.** And `4.378e−04` is not a near
miss on the scale of anything — it sits essentially at that base's
median `|cell|/S`, which is 3.52e−4.

**Set that against `SeedPerturbation`.** `lean/SeedPerturbation.lean`
proves that a change of seed convention replaces the depth-0 row `N` by
`N − e` and, by linearity plus locality, cannot touch a cell whose
window bottom clears the last rung `e` moves: `R < r − d` gives
`cell_eq_of_seed_perturbation`, and `boundary_can_move` shows the strict
inequality is sharp. Entry 47 measured the same thing from the data —
`(8,3)` and `(20,6)` are unmoved by three seed conventions, six
composite variants and two repos, while `(2,1)` and `(4,1)` sit close
enough to the seed to be reached. So `(20,6)` is **robust to seed
changes and fragile to resolution changes**, and those were never the
same invariance: one is about what the bottom of the window reads, the
other about how finely the window is sampled between its endpoints.
Nothing in `SeedPerturbation.lean` claimed the second, and nothing in
it is contradicted. (It is not yet recorded anywhere in this notebook;
`lean/lakefile.toml` now globs eleven modules against the ten entry 45
counted.)

Both scripts EXPLORATORY, `summary.verdict` null in both files. Nothing
above is a verdict and nothing here bears on O45's empty verdict line.

No outcome marked.

---

## 2026-08-19 — Entry 51 — O45 run: 121 resolved sub-2 zeros, 35 clearing the mass floor, p = 0.0839 — the verdict line is empty and is Julian's
type: run
refs: 44, 49, 50

`O45_sub_integer_base_scan.py`, one run at the locked flags,
**PREREGISTERED** against entry 50's protocol. Lock written
2026-08-19T07:16:07Z; `run_start_utc` = `run_end_utc` =
2026-08-19T07:16:38Z — thirty-one seconds after lock, and the run
completes inside one second. Python 3.14.3, `code_version`
`f06f6f3c…`. Artifacts `results/sub_integer_base_scan.json` (177,989 B)
and `results/O45_sub_integer_base_scan_run1.log` (50,589 B, 746 lines).
`pi2n_cache.json` read, not written; nothing under `imported/`,
`lean/` or `preregs/` opened for writing.

**Sidecar.** `preregs/sub_integer_base_scan_v1_20260818.sha256` reads
`7985c94015bab8d8f2e606b69aaeac79150ccec1d4ec9d04bca7db177c02aaf5`, and
the Run record's `post_compute_sha256` is the same string — so no
parameter, hypothesis or decision-rule text drifted between lock and
compute.

**Check 1, π backend.** `primecountpy.prime_pi` 0.2.1, **33 of 33**
audit comparisons equal against `pi2n_cache.json`, including
`π(2^32) = 203280221` backend and cache. PASS.

**Check 2, geometry.** All eleven bases recompute `r_max`,
`cells_at_d_ge_1`, `r_thick` and `resolved_cells` equal to the locked
table — `geometry_matches_locked` true for every base. Minimum relative
distance of any `b^r` to an integer over the whole support is
**1.665e−12** at antiphase `k = 1` and `k = 2`, the same number the
prereg pre-computed, forty-eight orders above the dps-60 floor and far
above the 1e−30 determinacy threshold. `root_selfcheck_failures` 0 at
both refinement bases. `summary.compromised_conditions` is `[]`.

**Check 3, base-2 reproduction.** Through the identical code path at the
same value ceiling, base 2 rebuilds `[[2,1],[4,1],[8,3],[20,6]]` over
496 cells — the known set, no more and no fewer. A reproduction check,
not evidence; the prereg says so and so does the log.

**Check 4/5, the scan and the rate test.** The primary statistic:

```text
  resolved cells   base 2   496     sub-2  37178
                                    family 20661  antiphase 11236  refinement 5281
  Z_2  (base 2, resolved)         : 4
  Z    (sub-2, resolved)          : 121
  Z*   (of those, S >= 88)        : 35     family 13  antiphase 18  refinement 4
  E[Z] under H0                   : 299.822580645161  (locked value, reproduced)
  conditional-binomial p (PRIMARY): 8.394656e-02   [exact]
  Poisson p (SECONDARY)           : 6.367145e-32
  alpha_level                     : 0.05, one-sided
```

Zeros on the **full** support total 240 across the ten sub-2 bases
against 121 resolved — the resolved criterion discards a little over
half of them, which is what entry 50 designed it to do. Per base,
resolved zeros: family 29 / 14 / 9 / 7, antiphase 21 / 15 / 10 / 2,
refinement 11 (`2^(1/2)`) and 3 (`2^(1/3)`). Every one of the eleven
bases has at least two resolved zeros.

**The mechanical output of the decision rule is `fineness`**, by
`Z* ≥ 1`, not `family_only`, not `refinement_only`, and
`p = 0.0839 > 0.05`. That is the rule's arithmetic and nothing more.
`summary.verdict` is `null` by design and `verdict_note` reads "the
verdict line is Julian's to write in the prereg's Run record"; the Run
record's `- verdict:` line is **empty**. This entry does not fill it and
does not read the branch as a result.

**What the run eliminates, stated in the prereg's own terms.**
`intrinsic_base_two` required `Z = 0`; `Z = 121`. So "sub-2 bases stay
empty" is off the table on the resolved stratum as well as on the full
one — and not marginally: mass-clearing zeros appear in **all three**
arms, family, antiphase and refinement alike, which is what closes
`family_only` (`Z*_antiphase = 18 ≠ 0`) and `refinement_only`
(`Z*_family = 13 ≠ 0`) as well. `thin_rung_forced` needed `Z* = 0` and
`Z* = 35`, so the surplus is not confined to the thin end of the
stratum. The one thing the run does **not** eliminate is a rate below
base 2's: `p = 0.0839` sits above alpha, but 121 against an H0
expectation of 299.8 is well under half, and the prereg's own stated
weakness 1 — resolved cells at neighbouring `r` share most of their
stencil, so the independence assumption makes `p` anti-conservative
*against* H0 — cuts in exactly that direction.

**A wrinkle in the new convention, undecided.** Lines 5–8 of the prereg,
immediately under `STATUS: **LOCKED**`, read: "There is no sidecar
`sub_integer_base_scan_v1_20260818.sha256` yet; the sidecar is the
authority on lock, and its absence means this prereg is not locked."
That text is now false — the sidecar exists — and it sits **inside the
hashed region**, which measurement confirms: the sidecar hash is the
SHA-256 of the file's first 680 lines, and lines 5–8 are among them. So
the sidecar pins a paragraph asserting the file is unlocked, three
lines below a STATUS block asserting it is. The file cannot be edited
to fix it without breaking the sidecar match that the Run record
depends on. This is a wrinkle in the naming convention entry 44
introduced — the drafting boilerplate assumes the pre-lock state and
nothing strips it at lock time — not a defect in this prereg's
protocol, every parameter of which reproduced. Julian's call.

No outcome marked.

---

## 2026-08-19 — Entry 50 — the O45 prereg: fineness against intrinsic, and the empty-rung discovery that forced the resolved stratum
type: prereg
refs: 44, 45, 49

`preregs/sub_integer_base_scan_v1_20260818.md`, 695 lines as it now
stands. It asks one question of entry 49's 4-in-496 / 0-in-496 result:

```text
  fineness   base 2 is the finest INTEGER sampling of the scaling flow,
             so bases BELOW 2 - finer still - should produce zeros at
             at least base 2's per-resolved-cell rate.       [H0]
  intrinsic  base 2 is special in itself, so sub-2 bases stay empty
             and the point prediction is Z = 0.              [H1]
```

The fork is licensed by entry 45's finding that `pair_identity` takes
**no hypothesis on `b`**, and by `lean/Chain.lean`'s `C1` needing only
`0 < b`: `π(b^r) − π(b^(r−1))` is well defined for real `b > 1` and the
cells stay integers. `E[Z] = Z_2·C_sub/C_2 = 4 × 37178 / 496 =
299.822580645161`, stated as a number before the run.

**Four drafting complications, all resolved inside the locked text.**
The section is headed "The three complications" and then lists four,
`(a)` through `(d)` — a wording slip inside the hashed region, recorded
not corrected.

*(a) The pair identity is only approximate at non-integer `b`.*
`tableFrom_add_window` (linearity plus locality) is exact for any seed
rows and any `b`; `tableFrom_of_geometric` needs the rung
`(b^(r−1), b^r]` to hold exactly `(b−1)·b^(r−1)` integers, and at real
`b` it holds `⌊b^r⌋ − ⌊b^(r−1)⌋`. So O44's `nu` denominator is not
reused as such. Two totals are locked and both reported:

```text
  total_geo (b,r,d) = (b-1)^(d+1) * b^(r-1-d)        O44's denominator
  total_true(b,r,d) = sum_k (-1)^k C(d,k) W(r-k),  W(r)=|b^r|-|b^(r-1)|
```

The drift is not small: at `b = exp(π/(2γ₁))`, `(199,20)` has
`total_geo = 1.16e−11` against `total_true = −86804`, and 9601 of that
base's 19701 cells have `total_true ≤ 0`, which a positive geometric
quantity cannot do. `nu_pair = |cell|/|total_true|` is primary.

*(b) Fair comparison is by value range, not by `r`.* Bases are matched
on a **value ceiling** `V = 2^32` — base 2's extent in entry 49 — with
`r_max(b)` the largest `r` with `b^r ≤ V`, locked per base rather than
recomputed. `b = 1.11754` needs `r = 199` to reach where base 2 needs
32, and carries 19701 cells against 496; that asymmetry *is* the
fineness prediction, so every count is reported with its denominator.
Second consequence, load-bearing: `ln(b^r) ≤ ln V` at every base and
rung, so the prime density `1/ln x` entering any cell is bounded
identically across the list — density-matched by construction, not by
correction.

*(c) `(b−1)^(d+1) < 1` below 2, and the naive reading of it is wrong.*
`PairIdentity.coeff_eq_one_iff_base_two` covers integer `b ≥ 2` only.
For `1 < b < 2` the coefficient **shrinks** with depth: `total_geo` at
the ceiling drops below 1 from `d = 9, 13, 17, 21` at the four family
bases, against supports running to `d = 198, 98, 65, 48`. Read naively
that is O43's magnitude floor in reverse, forcing zeros over nearly the
whole sub-2 support. It is wrong for exactly the reason in (a):
`total_geo` is not the size of anything at a non-integer base. Floor
jaggedness is `O(1)` per rung and the stencil's L1 weight is `2^d`, so
deep sub-integer cells are **large**. The prereg's own sentence: "The
reverse magnitude floor, in the form O43 met it, does not apply."

*(d) A third outcome exists.* Zeros might appear only at the optimal-base
family `exp(πk/(2γ₁))`, which is neither account. Hence **non-family
controls in the same range**: four antiphase bases `exp(π(2k+1)/(4γ₁))`,
interleaved between consecutive family members and exactly half a
quarter-turn off the family in its own coordinate; and two refinement
controls `2^(1/2)`, `2^(1/3)`, of which base 2 is a literal
sub-sampling — the sharpest available test of fineness. Eleven bases,
`C_2 = 496` against `C_sub = 37178`, split 20661 family / 16517
non-family, so `family_only` cannot be an artefact of the controls
having had no chance. Labels `family_only` and `refinement_only` exist
for it.

**The discovery that shaped the design, and it fired before the run.**
At the finest base `b = exp(π/(2γ₁)) = 1.11754…`, `⌊b^r⌋ = 1` for
`r = 0…6` — the first six rungs hold no integers at all. Under this
project's convention (`π(1) = 0`) that gives `N(r) = 0` there and
`cell(2,1) = N(2) − N(1) = 0` **exactly**, a zero about an empty rung
and nothing else. Every sub-2 base has such a region. So `Z_full ≥ 1`
was guaranteed before a single prime was counted and "sub-integer bases
stay empty" was already false on the full support — for reasons
unrelated to the hypothesis. That is why the primary statistic is the
**resolved** count: a cell counts only if every rung its stencil reads
is expected to hold at least one prime, `W(r')/ln(b^(r')) ≥ 1` for all
`r' ∈ [r−d, r]`, equivalently `r − d ≥ r_thick(b)`. Pure geometry, no
prime counted to evaluate it, so `r_thick` and `resolved_cells` are
locked per base. At `b = 2` the criterion holds over the entire support
(`r_thick = 1`, all 496 cells, all four zeros kept) — one more sense in
which base 2 is the boundary case.

**Decision rule and vacuousness.** Eight labels, precedence
`compromised > thin_rung_forced > family_only > refinement_only >
fineness > rate_below_base_two > intrinsic_base_two > ambiguous`, keyed
on `Z`, on `Z*` (resolved zeros with `S ≥ mass_floor`) and on an exact
conditional-binomial `p`. The pre-computed p-table gives the smallest
`Z` with `p > 0.05` as **101** — a third of H0's own point prediction —
so `fineness` needs 101 mass-clearing zeros in 37178 resolved cells and
`intrinsic_base_two` needs none. Both directions reachable.

**Provenance, and the non-blind half.** `mass_floor = 88` is
`S(8,3)` at base 2, chosen with base 2's four masses `S = 2, 4, 88,
492384` already in view; the resolved criterion was fixed after the same
base-2 rebuild. Both are **calibrated on already-inspected data** and
only their application to the sub-2 bases is blind. Entry 49's results
were read in full while drafting. The genuinely blind arm is that no
sub-integer base had ever been computed here by anyone — the drafting
agent evaluated π at no sub-integer argument, and every locked geometric
quantity came from `⌊b^r⌋` alone.

**First prereg locked under the no-status-in-filename convention** that
entry 44 recorded into `CLAUDE.md`. Named
`sub_integer_base_scan_v1_20260818.md` at creation, no `_locked_`
infix, with the sidecar as the authority on lock. `lock_written_at`
2026-08-19T07:16:07Z, `locked_by` julian, `pre_compute_sha256` PENDING.
Measured for this entry, the sidecar
`7985c94015bab8d8f2e606b69aaeac79150ccec1d4ec9d04bca7db177c02aaf5`
is the SHA-256 of the file's **first 680 lines** — everything through
`- locked_by: julian` — so the locked region is the whole protocol and
the `## Run record` section was appended afterward.

No outcome marked.

---

## 2026-08-18 — Entry 49 — O44: base 2 is the only integer base with exact zeros, and entry 17's conclusion survives by a route entry 17 did not take
type: run
refs: 17, 45, 46, 47

`O44_cross_base_zero_scan.py`, one execution, **EXPLORATORY** — no
prereg, no hypothesis, no decision rule, nothing here is a verdict.
Invocation read back from `params.argv`:

```text
python3 O44_cross_base_zero_scan.py --data-dir imported/lattice_mapper/32bit \
    --bases 2,3,4,5,6,7,8,9 --d-min 1 --top-k 10 --pair-check --variant-scan \
    --out results/cross_base_zero_scan.json
```

`run_start_utc` = `run_end_utc` = 2026-08-19T06:30:13Z, completed;
Python 3.14.3; `code_version` `3ae5a3f1…`. Sixteen of the twenty-two
imported CSVs read, all read-only. Artifacts
`results/cross_base_zero_scan.json` (99,469 B) and
`results/O44_cross_base_zero_scan_run1.log` (25,995 B). The convention
in force is the **imported** one — 2 and 3 excluded as lattice (entry
46) — stated in `constants.convention` and `constants.convention_adjusted_for
= false`, so low-`r` numbers here do not compare with anything in
`results/`.

**The coordinate.** Raw `|cell|` compares across neither bases nor
depths, so O44 divides the pair identity's total out:
`nu(b,r,d) = |cell| / [(b−1)^(d+1)·b^(r−1−d)]`, every ranking on an
exact `Fraction`. That denominator is `pair_identity` of
`lean/PairIdentity.lean`, which entry 45 recorded as carrying **no
hypothesis on `b`** — which is what licenses using it at eight bases
at once.

**Extent and exact zeros at `d ≥ 1`** (`summary.per_base`):

```text
   b  file                              maxr maxd  cells  d>=1  zeros
   2  dyadic_difference_table_32.csv      32   31    528   496      4
   3  triadic_difference_table_32.csv     32   31    528   496      0
   4  tetradic_difference_table_32.csv    32   31    528   496      0
   5  pentadic_difference_table_27.csv    27   26    378   351      0
   6  hexadic_difference_table_24.csv     24   23    300   276      0
   7  heptadic_difference_table_22.csv    22   21    253   231      0
   8  octadic_difference_table_21.csv     21   20    231   210      0
   9  enneadic_difference_table_20.csv    20   19    210   190      0
```

Base 2's four are `(2,1) (4,1) (8,3) (20,6)` — the same set entry 47
read out of this same file. Base 3 is empty over the **identical** 496
cells, same ceiling and same support, so 4-in-496 against 0-in-496 is
the one uncensored comparison the table contains.

**Bases 4–9 are uninformative, and the reason is visible in where their
minima sit.** Every one of them takes its minimum `nu` on the **corner
cell** `(max r, max d)`: `(32,31)`, `(27,26)`, `(24,23)`, `(22,21)`,
`(21,20)`, `(20,19)`, at `nu` 0.0134, 0.0186, 0.0196, 0.0203, 0.0203,
0.0205. A minimum on the boundary of the support is a statement about
where the table stops, not about a floor. Bases 5–9 are additionally
extent-censored in `r_max` (27, 24, 22, 21, 20); base 4 is **not** — it
reaches `r = 32` with the same 496 cells as bases 2 and 3, and is simply
empty. Recorded because the two facts are distinct and only base 4
carries both a full extent and a corner minimum.

**The correction to entry 17, and it does not damage entry 17's
conclusion.** Entry 17 records of `triadic_difference_table_32.csv`
that "Base 3 reaches **1**, twice". Both of those cells are here and
both read `|cell| = 1` exactly — `(3,2)` and `(5,4)`, re-read from the
imported copy for this entry. But their totals are `2^3·3^0 = 8` and
`2^5·3^0 = 32`, so normalised they are `0.125` and `0.03125`, and
**neither is in base 3's ten smallest `nu`** (`summary.per_base[1].smallest_nu`,
which runs 9.77e−4 to 7.87e−3). Base 3's actual closest approach is

```text
  base 3   (11,10)   cell 2   total 2048   nu = 2/2048 = 9.765625e-04
  base 2   (13, 5)   cell 1   total  128   nu = 1/128   = 7.8125e-03
```

so base 3 comes **eight times closer proportionally** than base 2's
smallest nonzero cell does — exactly `8`, both being dyadic rationals.
Entry 17 argued base-2 extremality from magnitude and then recorded
that the magnitude argument fails to separate the bases. It fails
harder than entry 17 said: on the normalised reading base 3 is the
*closer* of the two and still never lands. Entry 17's conclusion — base
2 is where the zeros are — survives, but by the route "base 3 gets
closer and still misses", not "base 2 gets closest".

**The pair identity holds on data this project did not generate.**
Three matched pairs, `summary.pair_identity_checks`:

```text
  plain prime + plain composite                  528 cells   0 mismatches
  prime_full_silenced + plain composite          410 cells   0 mismatches
  plain prime + (composite − prime)              351 cells   0 mismatches
                                       total    1289 cells   0 mismatches
```

The third runs in mode `diff_plus_2p`. The five unmatched variants in
§ 4b mismatch at 90, 91, 40, 59, 59 cells and are flagged
`expected_to_mismatch = true` in the JSON — entry 47's arithmetic, put
on the record rather than assumed.

**One anomaly, surfaced and not chased.**
`imported/lattice_mapper/32bit/dyadic_diff_full_silenced_32.csv` is one
of the six 32bit CSVs O44 did **not** read. Measured for this entry: it
is exactly `composite_full_silenced − prime_full_silenced`, 410 of 410
cells, so it is a `C − P` table like `composite_minus_prime_32.csv`.
But it satisfies the identity against **nothing on disk**. In mode
`sum` it mismatches all twenty of the directory's other regime-keyed
CSVs (the wide `prime_composite_sidebyside_32.csv` excluded); in mode
`diff_plus_2p` its best partner is either dyadic prime arm at **59**
mismatches of 410 — and 59 is precisely the number of cells at which
its own parent pair fails, `C_fs + P_fs ≠ 2^(r−1−d)` at 59 of 410. Entry
47 cites this file as agreeing at `(4,1) = 6`, `(8,3) = 16`,
`(20,6) = 8192`, which it does; what it does not do is belong to a pair.
Not chased here.

Still EXPLORATORY. Nothing above is a verdict and nothing is decided.

No outcome marked.

---

## 2026-08-18 — Entry 48 — O33 was still reading the external lattice_mapper directory; repointed at the vendored copy, re-run, non-semantic
type: instrument-fix
refs: 36, 46

Entry 46 imported the eight base-series difference tables into
`imported/lattice_mapper/32bit/`, byte-for-byte and SHA-256 verified, so
that the evidence would sit with the work that cites it.
`O33_base_ladder_crossing.py` was not repointed. Its `DEFAULT_DATA_DIR`
still named
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit`, a
path outside this repo, and `results/base_ladder_crossing.json` →
`params.data_dir` records exactly that string. The vendored copy did not
protect the instrument: had `lattice_mapper/` been moved, renamed or
regenerated, O33 would have failed or silently read something else, with
27 verified files sitting unused two directories away. The import closed
the provenance gap for the *reader*; it did not close it for the *script*.

**Sites changed.** Three, all path, none logic. Line numbers before → after:

```text
  15-19  →  15-28   docstring, "THE SOURCE TABLES" preamble — the source
                    directory paragraph now names imported/lattice_mapper/32bit/,
                    records the byte-for-byte copy and points at the import
                    manifest and entry 46, and states that the run of record
                    predates the repoint
 194-196 →  202-205  docstring EXAMPLE — the explicit
                    --data-dir /Users/.../difference_tables/32bit line dropped,
                    since the default is now correct; a note added that an
                    explicit --data-dir is used verbatim and should be absolute
 220-221 →  230-233  DEFAULT_DATA_DIR, the default constant
```

The new default is

```python
DEFAULT_DATA_DIR = os.path.join(_HERE, "imported", "lattice_mapper", "32bit")
```

anchored to `_HERE = os.path.dirname(os.path.abspath(__file__))`, which
the file already defined at what is now line 227 for `DEFAULT_RESULTS_DIR`.
That is the house pattern, not a new one: `O16_centered_difference_table.py`
lines 169-171 anchor `files (2)` the same way, and `05`, `06`, `07`, `O11`
through `O23`, `O42` and `O43` all anchor their caches and outputs to `_HERE`.
An absolute path was rejected in favour of it so the repo stays portable.
The `--data-dir` flag's help string interpolates `DEFAULT_DATA_DIR`, so it
followed with no separate edit. `grep -n difference_tables
O33_base_ladder_crossing.py` now returns one line, 23, inside the docstring
sentence that records where the vendored files came from.

**Left alone, deliberately.** `constants.source_project` at line 1012 still
reads `/Users/juliansambrano/GitHub/lattice_mapper (READ ONLY; nothing
written there)`. That field records where the data *originated*, not where
this script *reads*, and it remains true — the vendored copy came from
there and the source tree is still untouched. Changing it would have moved
a leaf in the `constants` block, and the whole point of the comparison
below is that `constants` did not move. Same reasoning for the docstring's
scaffold-silencing section (lines 104-109) and
`constants.source_silencing`, which cite
`lattice_mapper/difference_table.py:75` as the generator: that is a
statement about provenance of the convention, and the generator is not
vendored here.

**Script SHA-256, before and after** (`shasum -a 256
O33_base_ladder_crossing.py`, run either side of the edit):

```text
  before  ffa3d5b746fd7c66cc0c6161d6532dd0d76d77ee4f0a882bec3b22eb2bf227ac
  after   55e1593b0bd950679c37684ada7ab614c346ea89c003b6cf40e37f0a1d329a01
```

The before hash is the same string carried in
`results/base_ladder_crossing.json` → `params.code_version`, so run 1
executed the pre-fix bytes and stamped them, and nothing had touched the
file between that run and this edit. 1038 lines before, 1050 after;
`python3 -m py_compile` clean.

**Re-run, to new paths.** Run 1's own invocation, read from
`results/base_ladder_crossing.json` → `params.argv`, which is
`['O33_base_ladder_crossing.py', '--min-row', '8']`, with `--out` and
`--out-csv` redirected so that neither run-1 artifact could be touched.
`--min-row 8` is also the flag's default; every other parameter ran at
default in both runs.

```text
python3 O33_base_ladder_crossing.py --min-row 8 \
    --out    /Users/juliansambrano/GitHub/Primebeat_081426/results/base_ladder_crossing_run2.json \
    --out-csv /Users/juliansambrano/GitHub/Primebeat_081426/results/base_ladder_crossing_run2.csv \
    2>&1 | tee /Users/juliansambrano/GitHub/Primebeat_081426/results/O33_base_ladder_crossing_run2.log
```

`run_start_utc` and `run_end_utc` both 2026-08-19T05:49:55Z, read from
`results/base_ladder_crossing_run2.json` → `params`; the run completes
inside one second. Python 3.14.3, mpmath 1.3.0, the same interpreter
string run 1 recorded. There was no run-1 log — `results/` held only
`base_ladder_crossing.json` and `base_ladder_crossing.csv` for O33 — so
`results/O33_base_ladder_crossing_run2.log` is the first log this
instrument has, named to the house `<script>_run2.log` pattern rather than
back-dated to a run-1 name that never existed.

Artifacts: `results/base_ladder_crossing_run2.json` (215,742 B),
`results/base_ladder_crossing_run2.csv` (14,600 B),
`results/O33_base_ladder_crossing_run2.log` (19,014 B, 236 lines).

**The change is non-semantic, and here is the evidence.** Both payloads
flattened to leaves and compared key by key. Run 1 has 6432 leaves, run 2
has 6436; the four extra are the four extra `params.argv` elements
(`--out`, its path, `--out-csv`, its path — 3 elements against 7). Of the
6429 leaves that are not `params.argv`, **fifteen** differ, every one of
them metadata:

```text
  /generated_utc              2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/run_start_utc       2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/run_end_utc         2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/code_version        ffa3d5b7...           ->  55e1593b...
  /params/data_dir            .../lattice_mapper/difference_tables/32bit
                                                    ->  .../Primebeat_081426/imported/lattice_mapper/32bit
  /params/out                 base_ladder_crossing.json  ->  ..._run2.json
  /params/out_csv             base_ladder_crossing.csv   ->  ..._run2.csv
  /params/source_files[0..7]/path   eight file paths, external -> vendored
```

`data_dir` and the eight `source_files` paths are the fix itself.
`code_version` moving is expected: `_code_version()` hashes `__file__` at
write time, so a changed file changes the stamp even when behaviour does
not.

Nothing else moved. The `constants`, `summary` and `rows` blocks are
**byte-identical** under a sorted-key JSON dump — all 210 rows, all eight
per-base summaries, all eight schema verifications, all eight unsilence
checks. So are `schema_version`, `script` and `script_path`. And the
`results/base_ladder_crossing_run2.csv` is byte-identical to
`results/base_ladder_crossing.csv`, same SHA-256
`f71f74b52cf923aca01e0fff8a4e4a4dfbd795302f4e1c47fba38b937d70ba94` —
the CSV carries no timestamp, so it is the cleanest single statement of
the result: the fix altered nothing this instrument measures.

**The comparison also checks the import, and the import passes.** Within
`params.source_files`, only `path` moved. `sha256`, `bytes`, `mtime_utc`,
`regimes`, `n_columns`, `header_first_4`, `header_last`,
`filename_trailing_number` and
`filename_trailing_number_equals_regimes` are identical across the two
runs at all eight bases. That is the load-bearing check: run 1 hashed the
files it read at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/` and
run 2 hashed the files it read at `imported/lattice_mapper/32bit/`, and
the hashes agree — the vendored copies *are* what the run of record read,
demonstrated by the instrument itself rather than by the copy that made
them. Those same eight SHA-256s agree a third time with the manifest table
in `imported/lattice_mapper/README.md`, checked line by line for this
entry: 8 of 8, 0 mismatches. `cp -p` preserved the mtimes, so even the
mtime field survives the move.

**Run 1 remains the run of record.** `results/base_ladder_crossing.json`
was not opened for writing, and still reads 215,439 B at mtime
2026-08-17 20:25 with SHA-256
`a0a070622873f424f23cdf1ce33437c0fbc21a1027828ea501b1e820fd5a1927`;
`results/base_ladder_crossing.csv` likewise. Entry 36 stands unamended.
`CONTEXT.md`'s O33 bullet still says the input "lived outside this repo at
run time … (the path `params.data_dir` records)" and that remains exactly
true of the run it describes — the repoint changes what a *future* run
reads, not what the recorded one did, and the bullet was deliberately not
edited. `CONTEXT.md` and `REFERENCES.md` were not touched by this pass.

Still EXPLORATORY. O33 has no prereg and fires no decision rule; run 2
reproduces run 1's numbers and reproduces its failed pre-stated
prediction with them — `summary.qualitative_split_matches_prestated`
reads `false` in both files, `bases_observed_crossing` `[2, 3]` in both.
Nothing here is a verdict.

No outcome marked.

---

## 2026-08-18 — Entry 47 — Is `(2,1)` a cancellation or a seeding artifact? The check splits the four zeros deep-versus-shallow
type: result-triage
refs: 12, 17, 29, 33, 36, 45, 46

The question came out of entry 17. That entry dismisses the triadic
table's `(2,1)` — "The single 0 is A_count at r = 1, which is the
construction … not a cancellation" — while the dyadic `(2,1)` is counted
among the four zeros without the same scrutiny. Entry 29 sharpened it:
under O27's convention the triadic table's one exact zero *is* `(2,1)`,
"and it is trivial: (1,3] holds {2,3} and (3,9] holds {5,7}, both count
2." So the cell nearest the seed is the cell whose reading moves with the
seed. The import recorded in entry 46 makes it testable, because it puts
a **third convention** on disk beside the two already here.

Everything below is read from artifacts named at each number. Nothing is
preregistered; no verdict is claimed and nothing is decided.

**`(2,1)` is convention-mobile — it moves with the seed and never with
the arithmetic.** Three conventions, one cell, `cell(2,1) = A(2) − A(1)`:

```text
  b                        2    3    4    5    6    7    8    9
  plain count              0    0    2    3    5    7   10   14
    = pi(b^2) - 2 pi(b)
  imported (2,3 as         0    2    4    5    7    9   12   16
    lattice, backward)
  archive (only 2          1    1    3    4    6    8   11   15
    dropped, forward)
```

Row 1 is `primecountpy.prime_pi`, computed for this entry. Row 2 is
`delta_1` at `regime 2` read out of the eight base-series tables in
`imported/lattice_mapper/32bit/` — `dyadic_difference_table_32.csv`,
`triadic_difference_table_32.csv`,
`tetradic_difference_table_32.csv`, `pentadic_difference_table_27.csv`,
`hexadic_difference_table_24.csv`, `heptadic_difference_table_22.csv`,
`octadic_difference_table_21.csv`, `enneadic_difference_table_20.csv`.
Row 3 is `delta_1` at `regime 1` read out of the eight archive tables at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/archive_unsilenced/32bit/`,
and it reproduces exactly when recomputed from `prime_pi` under that
convention.

Row 2 minus row 1 is **+2 at every base from 3 to 9 and 0 at base 2**.
The reason is geometric: the two excluded lattice primes are both in
`(b, b²]` for `b ≥ 3`, so they both leave `A(2)`; at `b = 2` they
straddle the boundary — 2 is in `(1,2]` and 3 is in `(2,4]` — so one
leaves `A(1)` and one leaves `A(2)` and the difference is untouched.
That is the whole of the base-2 exception, and it is a statement about
where 2 and 3 sit, not about cancellation.

**No convention makes `(2,1)` vanish at every base**, which is what a
pure seeding artifact would do. Plain count vanishes at `b = 2` and
`b = 3` and nowhere else. The imported convention vanishes at `b = 2`
only. The archive convention vanishes at no base at all. The cell is
mobile, but it is not free.

**Silencing can manufacture it, and the arithmetic of that is exact.**
Each additionally silenced prime landing in `(b, b²]` decrements
`cell(2,1)` by exactly one. Measured, `delta_1 @ regime 2`:

```text
  32bit/triadic_difference_table_32.csv             2
  32bit/triadic_difference_table_32_silence235.csv  1     (5 silenced)
  32bit/triadic_difference_table_32_silence2357.csv 0     (5 and 7)

  32bit/tetradic_difference_table_32.csv            4
  32bit/tetradic_..._silence2357.csv                2     (5, 7)
  32bit/tetradic_..._silence235711.csv              1     (5, 7, 11)
```

`(3,9]` holds `{5,7}`; `(4,16]` holds `{5,7,11,13}` and only three of
those are named. The 64bit triadic pair reproduces it — 2, 1, 0 across
`triadic_difference_table_40.csv`, `_silence235.csv`, `_silence2357.csv`.
So a `(2,1)` zero is available on demand in base 3 by naming two more
primes, and that is the strongest statement against reading the dyadic
`(2,1)` as the same kind of object as the deep two. Note also that
`triadic_difference_table_32_silence235.csv` carries a zero at
`(10,9)` — one exact zero, at depth 9, produced purely by silencing.
That cell is unexamined and is not chased here.

**All four dyadic zeros survive the convention change.**
`imported/lattice_mapper/32bit/dyadic_difference_table_32.csv` holds 496
populated cells over `r ≤ 32, d ≤ 31` and returns exactly

```text
  {(2,1), (4,1), (8,3), (20,6)}    and no other zero
```

`imported/lattice_mapper/64bit/dyadic_difference_table_64.csv` extends
the same construction to `r ≤ 64, d ≤ 63`, **2016 cells**, and returns
the same four and no fifth. The two files agree on all 496 overlapping
cells, 0 mismatches. This is a February generator in another repo, on
the excluded-lattice convention, and it lands on the same set that
entry 12 verified to `r ≤ 62, d ≤ 61` and that O27 rebuilt independently
(entry 29).

The 64bit file's own arithmetic was checked rather than assumed: its
`A_count` column matches backward differences of OEIS A007053 read from
`b007053.txt` at **all 64 regimes**, 0 mismatches, once the two lattice
primes are removed at `r = 1` and `r = 2`. It reaches `A(64) =
209366672181778359`, two regimes past this repo's own `pi2n_cache.json`
ceiling of `n = 62`.

That makes this a second confirmation of the census alongside O43
(`results/extended_zero_census.json`: `rmax_ext 92`, `cells_ext 4186`,
`cells_new 2295`, `K_new 0`, `n_reproduced 4`) — from different code in a
different repo written months earlier, and under a different convention.
It is *not* independent in the arithmetic: π(2ⁿ) is π(2ⁿ), and O43 reads
further, to `r = 92` against this file's 64. What is independent is the
construction and the seed convention, which is exactly the axis under
test here.

**`dyadic_prime_full_silenced_32.csv` is not a third confirmation.** It
is value-identical to `dyadic_difference_table_32.csv` on all **380**
overlapping cells, `A_count` column included, 0 mismatches, and returns
the same four zeros. It is a duplicate under another name, and counting
it would double-count.

**The composite side confirms the pair identity on data this project did
not generate.** Six composite variants, five distinct SHA-256 (two share
one — see entry 46):

```text
  file                                        (2,1) (4,1) (8,3) (20,6)  cells
  dyadic_composite_difference_table_32          1     4     16   8192    496
  dyadic_composite_difference_table_32_s46      0     5     16   8192    496
  dyadic_composite_difference_table_32_s468     0     6     16   8192    496
  dyadic_composite_extended_emptied_32          0     4     16   8192    380
  dyadic_composite_extended_emptied_32_s46      0     6     16   8192    380
  dyadic_composite_full_silenced_32             0     6     16   8192    380
```

`(8,3)` reads **16** and `(20,6)` reads **8192** in every one of the six,
and never moves. Those are `2^(r−1−d)` at `2⁴` and `2¹³` — exactly the
values `lean/PairIdentity.lean` proves the composite arm must carry where
the prime arm vanishes, and exactly the values entry 45 recorded as
`measured_composite_at_zeros = [1, 4, 16, 8192]` checked `by decide`
against `papers/The-Four-Zeros.md` § E2. Entry 45's check ran against
this project's own numbers. This one runs against tables generated in
**February 2026 by other code in another repo**, under a convention that
disagrees with ours at the seed, and the identity still holds at the two
deep cells. `dyadic_diff_full_silenced_32.csv` agrees independently:
`(4,1) = 6`, `(8,3) = 16`, `(20,6) = 8192`, which is forced, since its
prime arm is 0 at all four.

**`(4,1)` moves on the composite side, and the reason is visible in the
seed rows.** The six variants differ **only** in `A_count` at
`r = 1, 2, 3`:

```text
  A_count, r = 1..8
  composite (plain)                 1  2  2  6  11  25  51  105
  composite silence46               1  1  1  6  11  25  51  105
  composite silence468              1  1  0  6  11  25  51  105
  composite extended_emptied        0  0  2  6  11  25  51  105
  composite extended_empt_s46       0  0  0  6  11  25  51  105
  composite full_silenced           0  0  0  6  11  25  51  105
```

From `r = 4` onward every variant is byte-for-byte the same sequence.
`(4,1)` reads rows 3 and 4, so it lands inside the perturbed region and
takes the values 4 / 5 / 6 above. `(8,3)` reads rows 5–8 and `(20,6)`
reads rows 14–20; both windows sit entirely outside it, which is why they
cannot move whatever is silenced at the seed. The dyadic prime `(2,1)`
reads rows 1 and 2 — the two most perturbed rows in the whole file.

**The finding worth recording: the useful cut is not four-versus-three,
it is deep versus shallow.** `(8,3)` and `(20,6)` are unmoved by every
convention, every silencing set and every generator tried here — three
seed conventions, six composite variants, two independent repos, and
O43's census to `r = 92`. `(2,1)` and `(4,1)` both sit close enough to
the seed that low-`r` choices reach them: `(2,1)` reads the two rows the
lattice convention edits, `(4,1)` reads the last row the silencing sets
edit. That is a property of window position, not of arithmetic depth,
and it is measurable — which four-versus-three is not, until someone
fixes a convention.

This echoes `lean/Zeros.lean` from an independent direction. Its
`window_exclusive_of_prime_exponent` proves that depth 6 spans a ratio of
`2^7`, 7 is prime, so `b^k = 2^7` with `b ≥ 2, k ≥ 2` forces
`b = 2, k = 7` — **(20,6) is base-2 exclusive**. Its
`window_shared_of_composite_exponent` is the one line `(4:ℕ)^2 = 2^4`:
depth 3 spans `2^4 = 4^2`, so base 4 reaches `(8,3)`'s window at depth 1,
and the file's own comment says "the two deep zeros are different kinds
of object". That splits the deep pair by *base reachability*. The
composite data above splits all four by *seed reachability*. The two cuts
are not the same cut, and they do not have to agree — but both say the
four zeros are not one homogeneous set, arrived at from proof and from
February data respectively.

**Entry 17's claim, re-examined and verified as written.** Entry 17 says
of `triadic_difference_table_32.csv`: "**Confirmed: no exact zero in any
delta column.** The single 0 is A_count at r = 1", with near-misses
`(3,2) = 1`, `(5,4) = 1`, `(11,10) = 2`, `(8,7) = 9`, `(10,9) = 9`. Every
one of those reads back exactly from the imported copy of that file — 496
cells, **zero** exact zeros in any delta column, `A_count` zero only at
`r = 1`. The claim is true of the file it cites.

It is also **convention-dependent, and that convention is not the one any
in-repo artifact uses.** The same file reads `cell(2,1) = 2`, tying
`(11,10)` for third-smallest and unlisted in entry 17's near-miss table.
Under O27's convention — `pi(1) = 0`, block `r` is `(b^(r−1), b^r]`, 2 and
3 counted as primes, so `N_3(1) = 2` (entry 29) — the same triadic table
reads differently: `results/joint_dyadic_triadic_table.json` over its 820
triadic cells at depth ≥ 1 has minimum `|cell| = 0` at `(2,1)`, next
smallest `2` at `(4,3)`, then `3` at `(3,1)`, `(3,2)`, `(5,4)`, and
**not one cell anywhere in the triangle takes the value ±1**. So "base 3
reaches 1, twice" and "no exact zero" are both true of entry 17's file and
both false of O27's. Entry 17's open discrepancy — that the magnitude
argument does not separate the bases — was argued from the reading where
base 3 gets closest without landing. On the in-repo reading base 3 lands
at `(2,1)` and never gets close anywhere else. The discrepancy is not
resolved here; it is relocated, and which reading it should be argued from
is not this entry's call.

**Disclosed prediction, and where it failed.** Before opening any file,
this assistant predicted `cell(2,1)` would vanish at `b = 2` and `b = 3`
and read 2, 3, 5, 7, 10, 14 at `b = 4…9`. That prediction reproduced the
plain-count computation **exactly** — row 1 of the table above is
identical to it, digit for digit. It also **contradicted every base-series
file on disk except base 2**, because the imported tables run on the
excluded-lattice convention and read 2, 4, 5, 7, 9, 12, 16 where the
prediction said 0, 2, 3, 5, 7, 10, 14. Both halves are recorded because
the failure is the informative one: a correct computation of the wrong
convention is exactly the error the import in entry 46 exists to prevent,
and it was made anyway, by the same pass that made the import.

Nothing here decides whether the count is four zeros or three. No outcome
marked.

---

## 2026-08-18 — Entry 46 — The lattice_mapper difference tables imported: 27 files, one convention, and the two generations left behind
type: provenance
refs: 17, 36

Entry 17's central piece of adversarial evidence was a file this repo did
not contain. That entry reads: "Julian supplied `triadic_difference_table_32.csv`
(r = 1…32, d = 1…31, built with 2 and 3 excluded as lattice rather than
counted as primes)", and everything it concludes about base 3 — "no exact
zero in any delta column", "Base 3 reaches **1**, twice" — is a reading of
that file. The file lived at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/`,
outside this repo, with **no pointer to it in `CONTEXT.md` or
`REFERENCES.md`**. Entry 36 later read the same source directory for O33
and recorded the convention and a stale README there, and that pointer was
never promoted into the commitment files either. This import closes that
gap: the evidence now sits with the work that cites it.

**What was imported.** `imported/lattice_mapper/`, copied 2026-08-18
byte-for-byte with `cp -p`, every file SHA-256 verified source-vs-
destination at copy time. **27 files**: 22 from `32bit/` — the complete
directory, 12 base-series tables for bases 2 through 9 plus 10 dyadic
prime/composite split files — 4 from `64bit/`, and the source README
under the name `source_README.md`. The `32bit/` and `64bit/` split is
preserved. `imported/lattice_mapper/README.md` is the import manifest,
written for this repo, and carries the full SHA-256 and source-mtime table.

Re-verified for this entry, not taken on the manifest's word: all 26 CSVs
plus `source_README.md` hash identically to their source counterparts
today, **0 mismatches**. Source mtimes are all 2026-02-11 except the
README's 2026-02-09, and `cp -p` preserved them.

**The convention these tables use.** Power-regime, **backward**
differences: `A(n) = π(bⁿ) − π(bⁿ⁻¹)`, with `delta_d` at regime `r` the
`d`-th backward difference ending at `r`. And — the part that matters —
**the primes 2 and 3 are excluded as lattice, not counted as primes.**
`A(1) = π(b) − 2` for `b ≥ 3`; at `b = 2` the two lattice primes straddle
the regime boundary, 2 in `(1,2]` and 3 in `(2,4]`, so one is dropped from
each of `A(1)` and `A(2)`. The generator is
`/Users/juliansambrano/GitHub/lattice_mapper/difference_table.py:75`,
`silenced_primepi(x)`, whose docstring reads "pi(x) with 2 and 3
silenced. … 2 and 3 are not primes in this framework — they are the
scaffold that generates the 6k±1 lattice." Entry 36 recorded this line
already, from the same source directory.

**This is not the convention any in-repo artifact uses.** O27's
first-block convention is `pi(1) = 0`, block `r` is `(b^(r−1), b^r]`, with
2 and 3 counted — `N_2(1) = 1`, `N_3(1) = 2` (entry 29). The dyadic
tables O16 and O43 build carry the same. So a number lifted from
`imported/` and a number lifted from `results/` are not comparable at low
`r` without stating which convention is in force. That is the reason the
import lives in its own directory with its own manifest rather than being
merged anywhere.

**Three generations, three conventions, two difference directions.** The
source directory holds more than was taken. `archive_unsilenced/` was
**deliberately excluded**, and it differs on every axis:

```text
  imported here     backward differences, 2 and 3 excluded as lattice
                    (difference_table.py:75)
  archive, power    FORWARD differences, ONLY 2 dropped
    regime          (archive_unsilenced/gen_difference_table.py:22-29 —
                    silenced_primepi subtracts 1)
  archive,          a THIRD schema: header column `pi_n`, integer regime
    *_64bit_*.csv   (triadic_difference_table_64bit_64.csv et al.)
```

The direction was checked from the data, not from docstrings — entry 36
warns that the generator's docstring and its output disagree. In the
archive dyadic table `A = 0, 1, 2, 2` and `delta_1 @ r3 = 0 = A(4) − A(3)`,
which is forward. In the imported dyadic table `A = 0, 0, 2, 2` and
`delta_1 @ r3 = 2 = A(3) − A(2)`, which is backward.

Mixing those in one imported directory is the confusion this import
exists to end. The archive remains readable in place and is not deleted,
moved or touched:

```text
  /Users/juliansambrano/GitHub/lattice_mapper/difference_tables/archive_unsilenced/
```

Its size, measured for this entry: **33 files, 59,069,876 bytes**, of
which 9 `.bin`/`.hex` binaries account for 25,339,552 bytes. The
manifest's "~58 MB of binaries" describes the directory total (56.3 MiB),
not the binary files alone; recorded, not corrected.

**`source_README.md` is stale on `64bit/`, and is flagged rather than
fixed.** It describes `64bit/` as an "Integer-regime table: pi(n) for
n = 1..64" — but both imported `64bit/` files are power-regime `A_count`
tables on the same convention as `32bit/`, verified identical to `32bit/`
on all 496 overlapping cells. The description fits the
`archive_unsilenced/*_64bit_*` files instead. The staleness runs further
than the manifest notes: the README's folder list names `128bit/`,
`1000/` and `2pow20/`, and those directories exist only *inside*
`archive_unsilenced/`, not at `difference_tables/` top level; and it
states the convention as "regime 2 is silent (pi(2) = 0). The prime 2 is
not counted" — the one-prime convention, which is the archive's, not the
imported files'. It was imported verbatim as the record of what the
source directory said about itself, and every claim in it that this pass
checked is noted here rather than edited.

Note the two same-named generators: `difference_table.py:75` defines
`silenced_primepi` removing **two** primes, and
`archive_unsilenced/gen_difference_table.py:22-29` defines
`silenced_primepi` removing **one**. Same function name, different
convention, different file. That is how the README came to describe the
wrong one.

**One byte-identical pair, preserved under both names.**
`32bit/dyadic_composite_extended_emptied_32_silence46.csv` and
`32bit/dyadic_composite_full_silenced_32.csv` share SHA-256
`a0030692739c7ddaada77f7b2cb81e8364ab3f9753970e1e8f6e63d058d53b6a` — they
are byte-identical in the source, under two names and two source mtimes
(12:13:27 and 12:20:04). Both were imported as-is rather than
deduplicated, because the pair is itself the provenance fact. Anyone
counting "six composite variants" is counting five distinct files.

**`lattice_mapper/` was verified unmodified.** No file anywhere under
`/Users/juliansambrano/GitHub/lattice_mapper/` carries an mtime later
than 2026-08-01; the newest under `difference_tables/` is 2026-02-11.
Every imported file's source counterpart hashes identically today. The
source tree was read-only throughout and remains so. Nothing in this repo
regenerates these files, and nothing should: they are imported evidence,
not outputs of this bench.

`CONTEXT.md` and `REFERENCES.md` still have no pointer to
`imported/lattice_mapper/`. The candidate lines are reported to Julian
separately; neither file was edited.

No outcome marked.

---

## 2026-08-18 — Entry 45 — the pair identity proved in Lean, and the row hypothesis that had to be window-local
type: formalization
refs: 12, 17, 26, 33

`papers/Formalization.md` § D5 reads, in full: "Blocks D through I of the
chain remain unencoded — the winding, the pair identity, the transform
results." The pair identity is now encoded and proved.
`lean/PairIdentity.lean` (15610 B, sha256
`0383a9e23ac642cf2a5135ad484cb43af7ff12180c7d7c070e90234c5552877f`,
12 theorems and 2 defs) carries statement **I1** of
`papers/Euler-Factor-Chain.md` § I outright, with no numerical input.
The winding and the transform results were not touched and D5 still
stands for them.

One wording note, recorded rather than fixed: the pair identity is the
**second** of the three items D5 names, not the first. Nothing in
`papers/` was edited in this pass.

**What the notebook already had, and at what strength.** Entry 33 wrote
the identity down — `prime(r,d) + composite(r,d) = (b-1)^(d+1) *
b^(r-1-d)` — and read the four exact zeros as its poles, with the
composite values 1, 4, 16, 8192 the identity forces. Entry 17 recorded
the geometric fact underneath it, that differencing a geometrically
growing sequence "rescales by (b−1)^d and returns nothing", and entry 26
filed the composite identity as rediscovery from Julian's own repos
(OBS-011, February). None of that was a derivation; it was a check.
Read again for this entry,
`results/O16_centered_difference_table_run2.json` →
`summary.identity_a_backward` carries `statement`
`composite_B(r,d) == 2^(r-d-1) - prime_B(r,d)`, `cells_checked` **1953**,
`mismatches` **0**, `passed` true — the same 1953 cells entries 17, 26
and 33 all cite back to entry 12.

**The theorem, verbatim from `lean/PairIdentity.lean:138`.**

```text
theorem pair_identity (b : ℤ) (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ)
    (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (b - 1) * b ^ (e + (d - k))) :
    tableFrom P r d + tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e
```

**The hypotheses it actually needed — two, and neither is about primes.**
`hr` pins the exponent. `hpair` says the two rows partition each rung of
the window the cell reads. There is **no hypothesis on `b` at all** — not
`2 ≤ b`, not `b ≠ 0` — so this is general integer `b`, not base 2
special-cased. And there is no hypothesis on `P` or `C` beyond the
partition: the seed rows are arbitrary functions `ℤ → ℤ`, and the proof
never knows that `P` counts primes. The file states the consequence in
its own words at line 133: "Nothing in the proof knows that `P` counts
primes — the identity is forced by the partition alone, and the whole
content of the prime/composite split is that it is a partition of a
geometric row." That is the sharpest form of what entry 33 called the
sum being fixed and known in advance while only the split is free.

**The index convention it settled on** (file lines 43–48).
`Construction.tableFrom` puts depth `d` at `d` backward differences of
the depth-0 row, and the depth-0 row is the per-rung count, itself
already one difference of the cumulative count. So `d` in Lean is the
paper's `d`, and the exponent `r−1−d` is carried as a **natural number
`e` with `r = d + 1 + e`**. That keeps every exponent in ℕ and every
rung inside the table's support, which is why `hr` appears as a
hypothesis rather than the exponent being written `r - 1 - d` and
truncating.

**The supporting arrows.** `symbol_at_one` names
`EulerFactorChain.symbol_of_backward_difference` (A1) at `ρ = 1`;
`backward_difference_pow` moves that step into ℤ where the table lives;
`tableFrom_of_geometric` iterates it to the collapse
`tableFrom G r d = (b - 1) ^ d * G (r - d)`; `tableFrom_add_window`
supplies linearity localised to the window, out of
`Construction.tableFrom_add` and `Construction.zero_determined_by_row`.
`composite_of_prime_zero` is I5, the pole: where the prime arm vanishes
the composite arm carries the whole total. `composite_at_zero_20_6`
instantiates it at (20,6) and returns 8192.

**THE FINDING WORTH RECORDING — a globally-stated row hypothesis would
have been vacuous.** The natural way to write "the row is geometric" is
`∀ r, G r = b * G (r-1)` over all of ℤ. For `|b| ≥ 2` that hypothesis
has exactly one solution, `G = 0`: iterating gives `G r = b^n * G (r-n)`
for every `n`, so `b^n` divides `G r` for every `n`, and only 0 is
divisible by arbitrarily high powers of `b`. A theorem assuming it would
be true and empty. The hypothesis had to be **window-local** — in
`tableFrom_of_geometric` it is `∀ k : ℕ, k < d → G (r - k) = b * G (r - k - 1)`,
asking only for the `d` steps inside the window `r, r−1, …, r−d` that
the cell at `(r,d)` actually reads. That is the same locality
`Construction.zero_determined_by_row` already carries (`∀ k : ℕ, k ≤ d →
N (r - k) = M (r - k)`), so the pattern was in the tree before this file
needed it.

**A discrepancy in the file's own comment on that point, not adjusted.**
`lean/PairIdentity.lean:80–82` states the vacuousness as "No total
function `ℤ → ℤ` satisfies `G r = b * G (r−1)` at every `r` except
`G = 0`", with no condition on `b`. As written that is false: at `b = 1`
every constant function satisfies it, and at `b = −1` every
sign-alternating function does. The claim needs `|b| ≥ 2`. The comment
is prose in a docstring, carries no proof obligation and does not enter
any theorem — nothing in the file is wrong — but the sentence is
overstated and is recorded here rather than edited, since `lean/` was
out of scope for this pass.

**The corollary, and its exact reach.**

```text
coeff_eq_one_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d : ℕ) :
    (b - 1) ^ (d + 1) = 1 ↔ b = 2

total_eq_pow_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d e : ℕ) :
    (b - 1) ^ (d + 1) * b ^ e = b ^ e ↔ b = 2
```

Here the hypothesis `2 ≤ b` does appear — the corollary needs it, the
identity does not. `base_three_carries_factor` and
`base_four_carries_factor` are the witnesses: base 3 carries
`2^(d+1)·3^e`, base 4 carries `3^(d+1)·4^e`, never a bare power.

What it **does** say: base two is the only integer base ≥ 2 whose cell
total is a bare power of the base, so it is the only grid on which a
vanished prime arm leaves the composite arm sitting exactly on a power
of the grid. What it **does not** say, in the file's own words at lines
35–38: "It is a statement about the FORM OF THE TOTAL, not about zeros.
Nothing here predicts, or could predict, where either arm vanishes." So
it does **not** close entry 17's open discrepancy. Entry 17 offered
`(b−1)/b` minimised at `b = 2` as the reason the zeros are there, then
recorded that the triadic table reaches 1 twice without ever hitting 0,
so the magnitude argument does not separate the bases. This corollary is
a different statement about a different quantity, and entry 17's
discrepancy stands exactly where it stood.

**The measured check, and it matched.** The file records the four zero
cells as `zero_cells = [(2,1), (4,1), (8,3), (20,6)]` — the same list as
`Zeros.measured_zeros` and `Construction.measured_zeros` — and the
composite arm at them as `measured_composite_at_zeros = [1, 4, 16, 8192]`,
read from `papers/The-Four-Zeros.md` § E2 ("At the four zeros the
composite arm therefore carries the whole term: `1, 4, 16, 8192`",
line 121–122). `measured_composite_matches_pair_identity` evaluates
`(b−1)^(d+1)·b^(r−1−d)` at `b = 2` and those four cells and proves the
result equals the measured list, `by decide`. It compiles, so they agree:

```text
  (2,1)   2^0  =     1   matched
  (4,1)   2^2  =     4   matched
  (8,3)   2^4  =    16   matched
  (20,6)  2^13 =  8192   matched
```

These are the same four numbers entry 33 tabulated. They are inputs to a
check, not to a proof — the formula is derived from the partition alone
above them — and had any of the four disagreed the file would not build.

**`#print axioms`, verified rather than quoted.** The file pins each
result with a `#guard_msgs` block, so a drift would fail `lake build`.
Independently re-run for this entry via `lake env lean` on a scratch
file importing `PairIdentity`; the twelve lines below are that output
verbatim, and they match the twelve docstrings in the file exactly.

```text
  symbol_at_one                          [propext, Classical.choice, Quot.sound]
  backward_difference_pow                [propext, Quot.sound]
  tableFrom_of_geometric                 [propext, Quot.sound]
  tableFrom_add_window                   [propext, Quot.sound]
  pair_identity                          [propext, Quot.sound]
  composite_of_prime_zero                [propext, Quot.sound]
  coeff_eq_one_iff_base_two              [propext, Classical.choice, Quot.sound]
  total_eq_pow_iff_base_two              [propext, Classical.choice, Quot.sound]
  base_three_carries_factor              [propext]
  base_four_carries_factor               [propext]
  measured_composite_matches_pair_identity  [propext]
  composite_at_zero_20_6                 [propext, Quot.sound]
```

**Nine of the twelve are `Classical.choice`-free**, including
`pair_identity` and `composite_of_prime_zero` — the identity and the
pole are constructive. The three that are not are `symbol_at_one`, which
inherits it from the ℂ-valued A1 statement it names, and the two
`iff_base_two` corollaries, which get it through the `omega` / `nlinarith`
route. Three results depend on `propext` alone.

**Build.** `lean/lakefile.toml` changed by one line: `PairIdentity`
appended to the `[[lean_lib]]` `globs` list, taking the library from nine
modules to ten. New sha256
`b144eb9926b3a3e12f976c5f9eaee15cf63a01abe46725ac39db25e1e1508d36`,
462 B. Job count either side:

```text
  before   8027 jobs   lean/build.log line 71, the 09:41 build of the
                       nine-module library
  after    8036 jobs   lake build, run for this entry, exit clean
  delta      +9
```

`Build completed successfully (8036 jobs).` The only warnings are the
pre-existing unused-variable and unused-simp-argument linter notes in
`Crossover.lean` and `EulerFactorChain.lean`; `PairIdentity.lean` emits
none.

**What this confirms, and what it leaves alone.** It confirms the
account in entries 12, 17, 26 and 33: the identity is exact, it is not
about primes, and the four composite values are forced by the grid. It
refutes nothing in the notebook. It does not locate a zero — the file
says so twice, at lines 274–278 — so entry 26's last-vanishing question
and entry 17's base-2 discrepancy are both untouched, and `Zeros.lean`'s
hole stays open.

No outcome marked.

---
