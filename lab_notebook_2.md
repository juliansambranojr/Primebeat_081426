# Lab notebook, volume 2 — Primebeat_081426

Volume 2. Volume 1 is `lab_notebook.md`; it is closed and holds entries
1–44. This volume opens at entry 45.

Numbering is continuous across volumes: `entry N` is a unique address
project-wide, and a `NOTEPAD.md` line citing a bare entry number resolves
to whichever volume holds it — 1–44 in `lab_notebook.md`, 45 onward here.

Newest at top, same as volume 1.

Entry format and type vocabulary are defined in this project's
`CLAUDE.md` § Lab notebook conventions, reproduced here.

Entry header format:

```text
## YYYY-MM-DD — Entry N — <title>
type: <one-of-seven>
refs: <entry numbers, comma-separated, or empty>

<body>
```

Type vocabulary (entry must use exactly one):

- `motivation` — why this test exists, what claim it is arguing with,
  scope shifts, what the next deliverable is for
- `prereg` — writing or locking a protocol before a run; records the
  hypothesis, decision rule, locked parameters, and pre-compute SHA
- `run` — one script execution: script, full flags, dps/N/pmax
  settings, headline numbers, output path, completed-or-errored
- `instrument-fix` — a change to a script that affects what it measures
  or whether it completes; always paired with a re-run and a note on
  whether prior results are still comparable
- `result-triage` — close reading of an existing result or log: what
  the number means, whether the instrument's own readability
  precondition was met, what would sharpen it
- `provenance` — where a file came from, script lineage and renames,
  which cited document is missing, cache coverage
- `formalization` — a statement encoded in Lean, an arrow checked, or a
  hypothesis discharged; records what was proved, the hypotheses it
  actually needed, its `#print axioms` result, and whether it confirmed
  or refuted an account already in the notebook

If a new entry doesn't fit any of the seven types, flag it and stop — do
not invent new types.

Agents append entries. Outcome markings and status transitions are
Julian's call.

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
