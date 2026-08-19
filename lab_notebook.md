# Lab notebook — Primebeat_081426

Newest at top. Entry format and type vocabulary are defined in this
project's `CLAUDE.md` § Lab notebook conventions. Six types:
`motivation`, `prereg`, `run`, `instrument-fix`, `result-triage`,
`provenance`.

Agents append entries. Outcome markings and status transitions are
Julian's call.

Note: there is no Entry 18. The gap is unexplained and has been recorded
rather than filled — see CONTEXT.md. Do not go looking for it.

**This volume is closed.** It holds entries 1–44 and takes no further
entries. Continue at `lab_notebook_2.md`, which opens at entry 45.
Numbering is continuous across the two volumes, so `entry N` stays a
unique address project-wide and `NOTEPAD.md` indexes both files.

---

## 2026-08-18 — Entry 44 — prereg filenames stop carrying status; O43's stale draft path fixed and re-run
type: instrument-fix
refs: 43

Entry 43 fixed one instance of a defect that had two. The same
draft→locked rename that stranded `O42_zero_winding_phase.py` also
stranded `O43_extended_zero_census.py`, and the underlying cause — a
filename that encodes status, so that locking a prereg forces a rename
— was left standing. Both are closed here: the cause by a convention
Julian approved and that is now written into this project's `CLAUDE.md`,
the remaining instance by a three-site path fix and a paired re-run.

**The convention, approved by Julian and inserted verbatim.** A new
subsection `### Prereg file naming and status` now sits at the end of
`CLAUDE.md` § Prereg discipline, immediately before § Permissions. Its
rule: name a prereg `preregs/<slug>_v<N>_<YYYYMMDD>.md` at creation and
never rename it, because scripts, results JSONs, and notebook entries
cite that path from the moment they are written and a rename strands
every one of them. Status lives instead in the `STATUS:` block inside
the file and in the presence of a sidecar
`preregs/<same-basename>.sha256`, which exists only once locked; **the
sidecar is the authority**, and a prereg without one is not locked
whatever its STATUS block says, because the sidecar is the thing that
pins the text. The three preregs named before the convention keep their
names —
`alpha_depth_trend_v1_locked_20260814.md`,
`zero_winding_phase_v1_locked_20260818.md`, and
`extended_zero_census_v1_locked_20260818.md`. None was renamed here, by
design: renaming them would be the very failure the rule forbids.

`CLAUDE.md` sha256 moved
`45bb98e5…0567c0a0` → `7384e263…d8564c49`
(`shasum -a 256 CLAUDE.md`, taken either side of the edit). The diff is
one hunk, +23 lines, nothing else in the file touched.

**O42 — already clean.** `grep -n draft O42_zero_winding_phase.py`
returns nothing, and `grep -n draft_20260818` returns nothing; entry
43's four-site pass was complete. The file was not edited in this pass
and its sha256 is unchanged at
`abd581a505de7cdd6a055f8d4375b0e2b380ae60f767b222650b66bd83382efc`
before and after (mtime still 2026-08-18 15:49:58, ahead of this
session).

**O43 — three sites, all of them the filename.**
`grep -n draft_20260818 O43_extended_zero_census.py` before the edit
returned exactly three lines, all replaced by the locked name and
nothing else touched:

```text
  line   6  docstring "Reads with:" header
  line  13  docstring STATUS paragraph
  line 181  PREREG_PATH constant -> console header and params.prereg
```

Line 181 is why the stale path reached
`results/O43_extended_zero_census_run1.log` line 4 and
`results/extended_zero_census.json` → `params.prereg`.

**Caveat on the grep check, recorded so it is not re-litigated.**
`grep -n draft O43_extended_zero_census.py` still returns five lines —
19, 104, 175, 504, 828 — and none of them is a path. They are the
lowercase word *drafting* / *draft time* in prose about the drafting
process: that the drafting agent issued only a HEAD request and never
downloaded the b-file, that the old-region numbers were computed while
drafting and are disclosed non-blind, that `BFILE_EXPECTED_BYTES` came
from a HEAD probe at draft time, and the `bfile_head_probe_note` string
that carries that provenance into the results payload. All four
statements are true and load-bearing as provenance; line 828 in
particular is a JSON leaf, so rewriting it would have changed the
payload and broken the non-semantic comparison below. This pass was
scoped to the path, exactly as entry 43's was — entry 43's `grep -n
draft` came back empty only because O42's surviving occurrence is the
uppercase status word `DRAFT`.

**Script SHA-256, before and after** (`shasum -a 256`, run either side
of the edit):

```text
  O42  before  abd581a505de7cdd6a055f8d4375b0e2b380ae60f767b222650b66bd83382efc
  O42  after   abd581a505de7cdd6a055f8d4375b0e2b380ae60f767b222650b66bd83382efc   (unchanged, not edited)
  O43  before  2c7f9d8cab17f7f85a831fd446ee23d83490f2c6feac70dc2623886608171400
  O43  after   9f66c9dffbfdb8bbf0ffe3aedd30b6b3b86e136604ae12b893face3eaeac1458
```

O43's before hash is the same string carried in
`results/extended_zero_census.json` → `params.code_version`, i.e. run 1
executed the pre-fix bytes and stamped them correctly.

**Re-runs, to new paths.** Each script's docstring invocation verbatim
except for `--out` and the tee target, so that no run of record is
clobbered — the entry-5 filename hazard:

```text
.venv/bin/python O42_zero_winding_phase.py \
    --base 2 --dps 50 --zeros 200 \
    --tol-quarter 0.10 --tol-spread 0.10 --n-null 20000 \
    --alpha 0.05 \
    --zeros-cache zeros600.json \
    --o16-log results/O16_run2.log \
    --out results/zero_winding_phase_run3.json \
    2>&1 | tee results/O42_zero_winding_phase_run3.log

.venv/bin/python O43_extended_zero_census.py \
    --bfile-source network \
    --bfile-url https://oeis.org/A007053/b007053.txt \
    --bfile-raw b007053.txt \
    --cache pi2n_cache.json \
    --o16-log results/O16_run2.log \
    --rmax-old 62 --rmax-ext 92 --d-min 1 \
    --near-miss-h 1024 --alpha 0.05 \
    --out results/extended_zero_census_run2.json \
    2>&1 | tee results/O43_extended_zero_census_run2.log
```

O42 run 3: `run_start_at` 2026-08-19T02:37:27Z, `run_end_at`
2026-08-19T02:37:28Z. O43 run 2: `run_start_at` 2026-08-19T02:37:42Z,
`run_end_at` 2026-08-19T02:37:43Z. All four read from the new JSONs'
`params`. New artifacts:

```text
  results/zero_winding_phase_run3.json          63464 B
  results/O42_zero_winding_phase_run3.log        8769 B
  results/extended_zero_census_run2.json        14004 B
  results/O43_extended_zero_census_run2.log      6895 B
```

**The O43 b-file did not move.** The re-run fetched
`https://oeis.org/A007053/b007053.txt` again over the network, HTTP 200,
1572 bytes, sha256
`6f4f5aaca7419f8c3d0a9d41b56617a1347ab4c124eec3f64362e299f7d8179b` —
byte-identical to run 1's, and identical again on the file left on disk
at `b007053.txt`. 93 data lines, n = 0..92, contiguous, 0 comment
lines. The `last-modified` header is absent from the response and is
recorded as reported drift, exactly as in run 1; it does not trip
`compromised`. So the upstream data is the same data, and the
comparison below is a comparison of code, not of inputs.

**Both changes are non-semantic, and here is the evidence.** Each new
payload was flattened to leaves and compared key by key against its run
of record.

O42, `results/zero_winding_phase.json` vs
`results/zero_winding_phase_run3.json`: **1738 leaves each, identical
key sets, five differing, every one metadata.**

```text
  /generated_utc        2026-08-18T22:36:27Z  ->  2026-08-19T02:37:28Z
  /params/run_start_at  2026-08-18T22:36:26Z  ->  2026-08-19T02:37:27Z
  /params/run_end_at    2026-08-18T22:36:27Z  ->  2026-08-19T02:37:28Z
  /params/prereg        ...draft...           ->  ...locked...
  /params/code_version  d57e8067...           ->  abd581a5...
```

O43, `results/extended_zero_census.json` vs
`results/extended_zero_census_run2.json`: **440 leaves each, identical
key sets, six differing, every one metadata.**

```text
  /generated_utc              2026-08-19T02:25:48Z  ->  2026-08-19T02:37:43Z
  /params/run_start_at        2026-08-19T02:25:47Z  ->  2026-08-19T02:37:42Z
  /params/run_end_at          2026-08-19T02:25:48Z  ->  2026-08-19T02:37:43Z
  /params/prereg              ...draft...           ->  ...locked...
  /params/code_version        2c7f9d8c...           ->  9f66c9df...
  /summary/bfile/retrieved_utc 2026-08-19T02:25:48Z ->  2026-08-19T02:37:43Z
```

`prereg` and `code_version` are the fix itself. `code_version` moving is
the entry-42 hazard read the benign way: `_code_version()` hashes
`__file__` at write time, so a changed file changes the stamp even when
behaviour does not. `retrieved_utc` is a clock, not a datum — the
`sha256` leaf beside it is unchanged.

Every observed statistic is bit-identical across each pair. Named
individually, read from the two O43 JSONs:

```text
  check_1  n_comparisons / n_equal / n_unequal   63 / 63 / 0        both
  check_2  rebuilt_old_zeros   [[2,1],[4,1],[8,3],[20,6]]           both
  check_3  cells_old / cells_ext / cells_new     1891 / 4186 / 2295 both
  check_3  n_reproduced / K_new                  4 / 0              both
  check_4  E_K_new_H0                            4.854574299312533  both
  check_4  new_cell_share                        0.5482560917343526 both
  check_4  p_conditional_binomial                0.04164560919604805 both
  check_4  p_poisson_secondary                   0.007792649983770727 both
  check_5  n_old_region / max_r_old_region       131 / 22           both
  check_5  M_new                                 0                  both
  check_5  band minima  (22,6) 556, (39,14) 12694, (41,14) 609228,
           (51,15) 442044255, (65,22) 312004291, (76,23) 2646401820804,
           (84,26) 45960063322751, (91,29) 31490569767031307       both
  extended_counts  n = 63..92, all 30 exact integers               both
```

O42's named statistics are the nine listed in entry 43 and are
unchanged again at run 3; the 1738-leaf comparison above covers them
exhaustively, `test_B.min_spread` 0.13305234828042806 and
`test_D.p_primary` 0.17904104794760262 included.

`diff` on the log pairs is the same story. O42 run 1 vs run 3: three
hunks, line 4 (prereg path), line 20 (`code_version`), line 176 (the
results path). O43 run 1 vs run 2: two hunks, lines 4–6 (prereg path,
`started`, `code_version`) and line 142 (the results path). Nothing
numeric moved anywhere in 176 and 142 lines respectively.

The decision rules' **mechanical outputs** are unchanged across each
pair: `no_constant_angle` for O42
(`summary.mechanical_decision_rule_output`, `compromised_conditions`
empty) and `magnitude_floor` for O43 (same key, `compromised_conditions`
empty). Both are the rules' arithmetic, not verdicts. O42's verdict line
was written by Julian in that prereg's Run record before this pass;
**O43's verdict line is blank and is Julian's to write.**

**Runs 1 are undisturbed and remain the preregs' runs of record.**
`results/zero_winding_phase.json` and
`results/O42_zero_winding_phase_run1.log` still carry mtime 2026-08-18
15:36:27; `results/extended_zero_census.json` and
`results/O43_extended_zero_census_run1.log` still carry 2026-08-18
19:25:48. Neither locked prereg was opened for edit — mtimes 2026-08-18
16:51:13 and 19:26:21, both ahead of this session's first write at
19:36:31 — so both parameter tables, both decision rules, and both Run
records stand as locked, and both sidecar-match statements are
untouched. Verified in place: the sidecars read
`b0101319708c70e47704002cfe7b7eb85853521481e8a5ad57a64269e958ca17` and
`ff6a1794c1129397760779a587aeb737218e480bb48820e3b38e062467beb0dd`,
which are the strings the two Run records assert as
`post_compute_sha256` with sidecar match **yes**. The consequence to
note is the same one entry 43 recorded: run 1's own artifacts still
print the draft path in both cases, because re-running for record would
mean clobbering the run of record.

Prior results comparable: **yes, fully.** Nothing in
`results/zero_winding_phase.json` or
`results/extended_zero_census.json` is invalidated. The only stale
pointers left in either are `params.prereg` itself and
`params.code_version`, which names the pre-fix bytes and correctly so.

No outcome marked.

---

## 2026-08-18 — Entry 43 — O42 cited a prereg path that no longer exists; fixed, re-run, non-semantic
type: instrument-fix
refs: 12

The prereg was drafted as
`preregs/zero_winding_phase_v1_draft_20260818.md` and renamed on lock to
`preregs/zero_winding_phase_v1_locked_20260818.md`. The script was
written before the lock (its own PROVENANCE line says so) and was not
updated, so `O42_zero_winding_phase.py` went on citing a path that is
not on disk — `ls preregs/` holds only the two `alpha_depth_trend`
files and the two `zero_winding_phase..._locked_...` files. The stale
citation was not cosmetic: it propagated into the run-1 artifacts, so
the record of the only preregistered run since O7 pointed at a
non-existent protocol.

**Sites changed.** Four occurrences of the filename in
`O42_zero_winding_phase.py`, all of the draft name, all replaced by the
locked name and nothing else touched:

```text
  line   5  docstring "Reads with:" header
  line  10  docstring STATUS paragraph
  line 417  console header, printed as "  prereg   : ..."
  line 737  params.prereg in the results payload
```

Lines 417 and 737 are why the stale path reached
`results/O42_zero_winding_phase_run1.log` line 4 and
`results/zero_winding_phase.json` → `params.prereg`. `grep -n draft
O42_zero_winding_phase.py` now returns nothing. The docstring's line-80
parenthetical "do not run while the prereg says DRAFT" carries no
filename and was left as written — it is a status instruction, not a
path, and this pass was scoped to the path.

**Script SHA-256, before and after** (`shasum -a 256
O42_zero_winding_phase.py`, run either side of the edit):

```text
  before  d57e8067d2b9fb32e3fe0e4485665e04dcd15323580c5cd0e958819ece66e398
  after   abd581a505de7cdd6a055f8d4375b0e2b380ae60f767b222650b66bd83382efc
```

The before hash is the same string carried in
`results/zero_winding_phase.json` → `params.code_version`, i.e. run 1
executed the pre-fix bytes and stamped them.

**Re-run, to new paths.** The docstring invocation verbatim except for
`--out`, launched 2026-08-18:

```text
.venv/bin/python O42_zero_winding_phase.py \
    --base 2 --dps 50 --zeros 200 \
    --tol-quarter 0.10 --tol-spread 0.10 --n-null 20000 \
    --alpha 0.05 \
    --zeros-cache zeros600.json \
    --o16-log results/O16_run2.log \
    --out results/zero_winding_phase_run2.json \
    2>&1 | tee results/O42_zero_winding_phase_run2.log
```

`run_start_at` 2026-08-18T22:50:05Z, `run_end_at` 2026-08-18T22:50:06Z,
both read from `results/zero_winding_phase_run2.json` → `params`.
Artifacts: `results/zero_winding_phase_run2.json` (63464 B) and
`results/O42_zero_winding_phase_run2.log` (8769 B).

**The change is non-semantic, and here is the evidence.** Both payloads
flattened to leaves and compared key by key: 1738 leaves, identical key
sets, **five** differing, every one of them metadata:

```text
  /generated_utc        2026-08-18T22:36:27Z  ->  2026-08-18T22:50:06Z
  /params/run_start_at  2026-08-18T22:36:26Z  ->  2026-08-18T22:50:05Z
  /params/run_end_at    2026-08-18T22:36:27Z  ->  2026-08-18T22:50:06Z
  /params/prereg        ...draft...           ->  ...locked...
  /params/code_version  d57e8067...           ->  abd581a5...
```

The last two are the fix itself. `code_version` moving is expected and
is the entry-42 hazard read the benign way: `_code_version()` hashes
`__file__` at write time, so a changed file changes the stamp even when
behaviour does not.

Every observed statistic is bit-identical across the two runs. Named
individually, from the two JSONs:

```text
  S_obs (test_B.min_spread)         0.13305234828042806     both
  minimising index / gamma          123 / 276.4520495031329386798873
  test_A qualifying gamma list      []  (empty)             both
  test_D.p_primary                  0.17904104794760262     both
  test_D.p_secondary                0.2057397130143493      both
  merged rep (2,1)  spread / p      0.014309855051043902 / 0.5473226338683066
  merged rep (4,1)  spread / p      0.010967345004310456 / 0.4631268436578171
  test_E ln_r_gap_slope / intercept 0.8958797346140285 / -0.2703100720721115
  test_E d_gap_slope / intercept    1.5 / -1.3333333333333333
```

`diff` on the two logs returns exactly three hunks — line 4 (the prereg
path), line 20 (`code_version`), line 176 (the results path). Nothing
numeric moved anywhere in 176 lines. The decision rule's **mechanical
output** is the same string in both runs, `no_constant_angle`
(`summary.mechanical_decision_rule_output`), with
`compromised_conditions` empty. That is the rule's arithmetic, not a
verdict; the verdict line in the prereg's Run record is Julian's and is
still blank.

**Run 1 is undisturbed and remains the prereg's run of record.**
`results/zero_winding_phase.json` and
`results/O42_zero_winding_phase_run1.log` were neither rewritten nor
read-modified — both still carry mtime 2026-08-18 15:36 local, ahead of
the 15:50 run-2 files. The locked prereg was not opened for edit; its
parameter table, decision rule, and Run record stand as locked, mtime
2026-08-18 15:37, and its sidecar-match statement is untouched. The
consequence to note is that run 1's own artifacts still print the draft
path — the fix is forward-looking only, and re-running for record under
the locked prereg would mean clobbering the run of record, which is the
entry-5 filename-clobber hazard again.

Prior results comparable: **yes, fully.** Nothing in
`results/zero_winding_phase.json` is invalidated. The only stale pointer
left in it is `params.prereg` itself, and `params.code_version`, which
names the pre-fix bytes and correctly so.

No outcome marked.

---

## 2026-08-17 — Entry 42 — the 3e9 generator sweep, and four corrections it forces
type: result-triage
refs: 24, 34, 35, 41

**EXPLORATORY.** No prereg. Nothing below is a verdict.

**The run.** `O24_prime_generator_orbit.py`, launched 21:01 PDT 2026-08-17,
completed 23:02, 2h01m, detached in its own session, PID 63229, exited clean.

```text
./.venv/bin/python O24_prime_generator_orbit.py --x0 2 --xmax 3000000000 \
  --generators 2,3,5,7,11,13,17,19 --gamma-max 40.0 --gamma-step 0.01 \
  --dps 30 --surrogates 200 --seed 2026 \
  --out results/O24_gen_xmax3e9_results.json
```

Every parameter but `xmax` was read from
`results/O24_gen_xmax1e9_results.json` `params`, so the three settings are
comparable. Artifacts: `results/O24_gen_xmax3e9_run.log` (27,968 B) and
`results/O24_gen_xmax3e9_results.json` (71,341,222 B, 203,334 rows,
`generated_utc` 2026-08-18T06:02:52Z, `n_primes` 144,449,537). Gates A, B and C
all PASSED. Verdicts G1 WEAK, G2–G8 DETECT.

**The chain, verbatim.**

```text
     G1         5.501266
     G2         8.192902
     G3        23.628706
     G4        38.299307
     G5        27.061132
     G6        18.321235
     G7        14.885732
     G8        12.039652

  SCALING BAND: FALLS
```

The first decrease is G4 → G5 at −29.3430%, and every later step also
decreases.

**Correction 1 — the peak still has not moved, but the G4/G5 ratio does not
trend.** Across the three real settings: 1.5e8 gives 26.733822 / 19.814296 =
1.349; 1e9 gives 31.371849 / 20.529395 = 1.528; 3e9 gives 38.299307 /
27.061132 = 1.415. It widened, then narrowed. A claim made in conversation on
2026-08-17 that the ratio widened monotonically across three points was wrong,
and it rested on treating an aborted timing probe as a data point — see
correction 3.

**Correction 2 — the block-size account is supported, not refuted.** Per-set
gain from 1e9 to 3e9 is monotone increasing in generator count:

```text
   G1  −0.7%    G2  +1.4%    G3  +8.4%    G4  +22.1%
   G5 +31.8%    G6 +42.0%    G7 +56.6%    G8  +63.3%
```

The deeper the set, the more it gains from more data, which is what a
resource-starvation account predicts directly. This contradicts entry 34's
statement that improvement fails at G6, G7 and G8 — at 3e9 those three are the
largest gainers. A claim made in conversation that the block-size explanation
was "finished" was wrong. On a naive two-point extrapolation of these rates G5
would overtake G4 near xmax ≈ 4e11; that is crude, exploratory, and far beyond
what this instrument reaches.

**Correction 3 — two provenance statements in entry 35 are wrong, and both
originated in the brief that produced it.**

(a) `results/O24_gen_xmax3e8_run.log` is described there as a previously
unrecorded artifact found in a session scratch directory. It is not. It is
byte-identical (`cmp` clean, 6328 B) to a scratch file `cal3e8.log` produced at
20:56 that same evening by the agent running the 3e9 sweep, purely to calibrate
cost, and killed at the two-minute mark. It stops mid-G6 because it was killed.
Its G1–G5 figures are genuine — 5.111330, 7.271745, 18.003929, 26.817551,
18.637366 — but it has no terminating line, no results JSON, and G6/G7/G8 do
not exist. It is a timing probe, not a run, and should not be counted as a data
point.

(b) Entry 35 also describes the 3e9 log as truncated mid-G8. It was not
truncated; that was the run still executing at the moment it was inspected.
Entry 35 was amended once on 2026-08-17 to add detail about both logs; that
amendment carried the same two misreadings forward.

**Correction 4 — entry 24's second hallmark has moved off G4.** Entry 24
records that G4's distinguishing property was all six zeros coming up together
within 6%. At xmax = 3e9 the P_max/median at gamma_1..gamma_6 reads:

```text
        g1      g2      g3      g4      g5      g6    spread
 G4   37.26   36.93   38.25   36.83   35.27   36.71     8.4%
 G5   26.17   26.20   27.05   26.23   26.22   26.19     3.3%
 G6   18.12   18.12   18.27   18.22   18.32   18.30     1.1%
```

G4 still holds the height, but "carries the whole spectrum rather than one
peak" is now G6's property. Separately, G4's argmax has drifted off gamma_1
across the three settings: 14.15 at 1.5e8, 25.00 at 1e9, 24.99 at 3e9.

**A defect in the self-identification scheme, recorded for a future
instrument-fix.** `_code_version()` reads the sha256 of the script file inside
`_write_results()`, i.e. at write time rather than at import time.
`O24_prime_generator_orbit.py` was edited at 23:00:16 — inside the 21:01–23:02
run window — to apply the `pi_at` performance fix. The numbers are unaffected,
because that fix is behaviour-identical and verified so, and the 3e9 run
executed the pre-fix bytes, the same code as the 1.5e8 and 1e9 runs. But
`results/O24_gen_xmax3e9_results.json` records `params.code_version`
`f3525a7f77188ae0a1143ea77ec38b49b029ff71ca0ee4d39dbd1a0895622c6e`, the
post-fix file, while the code that produced those numbers hashed to
`6e2ddd018e...`. So that field does not identify the code that produced the
result. This is systemic: any mid-run edit silently mislabels a result under
the current scheme. CONTEXT.md cites `code_version` as the mechanism by which a
result identifies its code; that guarantee does not hold across a mid-run edit.
Also, every earlier O24 results JSON records `6e2ddd018e...`, which is now a
stale pointer.

**Method note.** The mid-run edit was made on an explicit instruction that
editing the `.py` was safe because a running Python process has already loaded
its source. That is true of behaviour and false of provenance, and the correct
action was to wait roughly twenty minutes for the run to terminate. Three of
the four corrections above trace to briefs written from watching an in-flight
agent's own artifacts and describing them as pre-existing evidence.

No outcome marked.

---

## 2026-08-17 — Entry 41 — O39: the two circles and the annulus between them
type: result-triage
refs: 33, 36, 40

**EXPLORATORY.** No prereg. Nothing below is a verdict.

Script `O39_transform_radius.py`, outputs `results/transform_radius.csv` and
`results/transform_radius.json`. For each depth d the cells down that depth's
column are taken as the coefficients of the finite-truncation z-transform
`G_d(z) = sum_r cell(r,d) z^r`, and its complex roots are found. Three triangles
are treated identically: the prime table, the smooth model (Riemann R), and
their difference.

**Mean |z| by depth, b = 2, R = 45.**

```text
   d     prime    smooth  residual
   0    0.5406    0.5330    0.7625
   1    0.5216    0.5286    0.7483
   3    0.5543    0.5227    0.7527
   6    0.6013    0.5176    0.7543
  10    0.6652    0.5139    0.7577
  14    0.7537    0.5117    0.8358
  20    0.8677    0.5095    0.8680
```

**Jentzsch is the control.** The roots of the partial sums of *any* power series
accumulate on its circle of convergence, so the existence of a circle carries no
information — only the radius does. The smooth model does exactly that and
nothing else, pinned near 1/2 at every depth. The prime table migrates away from
it.

The radius is `b^(-sigma)` for coefficient growth `b^(sigma r)`. Smooth grows as
x^1, radius 1/2. Residual grows as x^(1/2), radius 2^(-1/2) = 0.70711. Measured
truncation offsets: smooth at d = 0, 0.5330 against 0.5, +6.609%; residual at
d = 6, 0.7543 against 0.70711, +6.671%. The two offsets agree to 0.062
percentage points, and that agreement is what identifies them as truncation
rather than a real difference.

**Depth moves the singularity.** The prime table's own circle starts at the
smooth radius and walks outward to the residual radius. That is the same
trend-to-oscillation handover previously seen as a sign crossing within a row
(entry 36), in a different coordinate.

**Breakdown boundary**, defined in the script rather than by eye — first depth
exceeding a relative-spread tolerance of 0.05 for three consecutive depths:
prime table at d = 13, residual at d = 10, smooth control NEVER up to d = 43. So
the migration is clean through roughly d = 12; the d = 14 figure sits on the edge
and the d = 20 figures are truncation, not migration. The control never breaking
down is the control working.

**The annulus.** The residual's transform is analytic on |z| < 0.70711 while the
smooth part's is not beyond |z| = 0.5, so between them lies an annulus
0.5 < |z| < 0.70711, with conformal modulus (log b)/(4 pi) = 0.05515890. Since a
violation of RH at Re(rho) = sigma > 1/2 would drop the outer radius to
b^(-sigma), RH is equivalent to that annulus having maximal modulus. This is the
abscissa-of-convergence statement in conformal language — an equivalent
restatement, of exactly the same difficulty, not a new result, and not decidable
by any finite computation, since the statement concerns a limsup.

Detail checks: prime d = 0, 44 roots spanning 0.52934–0.54880, relative spread
0.007915; prime d = 6, 38 roots, 0.56281–0.62422, spread 0.028206; residual
spread 0.020206 at d = 3 and 0.016422 at d = 6. The exact zero at cell (2,1)
lands in the constant term at d = 1 and puts one root at z = 0 exactly.

No outcome marked.

---

## 2026-08-17 — Entry 40 — O36/O37: the Weil form on the difference stencil balances
type: run
refs: 19, 23, 39

**EXPLORATORY.** No prereg. Nothing below is a verdict.

The backward difference operator on the ladder x = b^r has symbol
`(1 - b^(-s))`. Applied N times the symbol is `(1 - b^(-s))^N`, so the natural
Weil test function is

```text
h(s) = (1 - b^(-s))^N * (1 - b^(s-1))^N
```

which satisfies h(s) = h(1-s), equals |1 - b^(-rho)|^(2N) >= 0 on the critical
line, and has h(0) = h(1) = 0 because the stencil annihilates constants — so
there is no pole contribution.

**Exact identity**, verified numerically to eight digits at three zeros: |h| on
the critical line equals `b^(N/2) * (depth transfer gain)^(2N)`.

```text
  N = 7   gamma_1   gain 1.67843   b^(N/2)*gain^(2N) = 15931.825   |h| = 15931.825
          gamma_2   gain 1.44739                       2003.5695         2003.5695
          gamma_3   gain 1.19114                        130.93684         130.93684
```

The depth amplification this bench has been measuring all day **is** the Weil
weight on the zeros. This bridge needs no coordinate matching — the stencil sits
on Connes' domain natively — which is what distinguishes it from the O19 bridge
coordinate withdrawn in entry 23.

**The unmollified stencil is not admissible.** It is a sum of point masses; its
transform does not decay (it is periodic in gamma), so `sum over rho of h(rho)`
diverges: 430431 at 50 pairs, 1.6e6 at 200, 4e6 at 500, 7.8e6 at 1000. Its
support is the discrete set {b^n}, so the prime sum collapses to p = 2 alone.

**Mollification fixes both.** With T(s) = u(s) u(1-s),
u(s) = (sinh(W(s-1/2))/(W(s-1/2)))^k centered at s = 1/2, H = (g-hat u)(g-tilde-hat u)
still factors as G-hat * G-tilde-hat, so positivity on the critical line is
preserved *by construction* and H decays like t^(-2k). Centering is essential;
the uncentered mollifier does not factor, and that was defect (a) in entry 39.
Mollification also turns the discrete support into an interval, so every prime in
the window enters: at N = 7, W = 0.05, k = 2 the support is |log x| <= 5.052, 36
primes in range, 25 contributing.

**Balance achieved.**

```text
  arithmetic side   2644.2756560191
      H(0) = 0, H(1) = 0
      prime term     -1435.9137987828
      archimedean    +1208.3618572363
  spectral side     2644.2741566957
      600 zero pairs to gamma <= 939.02   2644.2585543549
      smoothed tail estimate                 +0.0156023
  relative difference 5.7e-7
```

That sits inside the ~10% error of the tail extrapolation itself. Archimedean
convergence: 1204.49 at |t| < 120, 1208.17 at 400, 1208.349 at 1000, 1208.361 at
3000.

**Caveats, to be carried.** The mollifier is not canonical — W and k are free and
the numbers move with them, so nothing here is yet a parameter-independent
statement. The mollified object is no longer the pure Delta^N stencil, and 25
primes other than 2 now carry real weight, so any claim about the 2-ladder must
survive the smearing. k = 1 is numerically too weak (t^(-2) decay, still 3% off
at 600 pairs); use k >= 2. And the balance is a **normalisation check, not a test
of anything** — summing 2 Re H(1/2 + i gamma) over known zeros already
presupposes those zeros lie on the line.

In the buggy version's per-prime breakdown p = 2 supplied -1695.27 of a -1656
total, with every other prime together contributing +39. That shape was not
re-derived on the corrected run and should not be quoted from the buggy file.

No outcome marked.

---

## 2026-08-17 — Entry 39 — four defects in the Weil-form implementation
type: instrument-fix
refs: 20, 21

**EXPLORATORY.** No prereg. Nothing below is a verdict.

The first implementation of the Weil quadratic form on the difference stencil,
preserved as `O38_weil_form_BUGGY.py`, failed to balance: arithmetic side 452.83
against a spectral side of 2643.50, **ratio 5.8378 stable to four digits across
zero counts**. A stable ratio indicated a systematic normalisation error, not a
convergence problem. An earlier variant with a non-positive h gave a stable ratio
of 3.3066.

Diagnosed by an independent reviewer, `O38_weil_bug_diagnosis.py`, which first
**calibrated its own implementation** on modulated Gaussians — three parameter
sets agreeing to 1e-18, including one where prime (0.4620476309) and archimedean
(0.4620476476) cancel to eight digits and the residue still matches the zero sum.
Calibrating on a known case before diagnosing was the step the original work
skipped.

**The four defects.**

(a) The mollifier was centered at s = 0 rather than s = 1/2, breaking
H(s) = H(1-s) — measured H(0.3)/H(0.7) = 0.99933, and H on the critical line was
not real, Im/Re = 2.4% at t = 14.13, which the `re()` calls silently hid.

(b) The real-space weights were missing a factor b^(m/2), so f was not even —
f(log 2) = -2340.07 against f(-log 2) = -4680.15, exactly the factor b.

(c) The real-space kernel was a triangle, whose transform is sinc^2, against a
sinc^4 symbol — inconsistent by one whole factor.

(d) The archimedean term entered with the wrong sign (it is +arch, not -arch) and
its integral was truncated at |t| < 120 where |t| < 3000 is needed, worth 3.87 on
its own.

**The test that had never been run** — comparing the Fourier/Mellin transform of
the real-space f by quadrature against H(1/2 + it) — failed outright on the
original objects: 1326.80 - 623.47i against 1003.79 + 24.48i at gamma_1. After
the fixes it matches to 1e-22.

**Prior-results comparability.** No prior recorded result depended on the buggy
implementation. It was written and corrected within one session and its numbers
were never carried into any other entry. The buggy file is retained only as
evidence and its docstring forbids citing its output.

The prime term's shape was **not** wrong: 2 log(p) p^(-m/2) f(m log p) is exactly
2 sum Lambda(n) n^(-1/2) f(log n) for even f. The spectral side was not wrong
either.

No outcome marked.

---

## 2026-08-17 — Entry 38 — O34/O35: the residual built from the zeta zeros, and where that instrument stops
type: run
refs: 12, 16, 27, 37

**EXPLORATORY.** No prereg. Nothing below is a verdict.

Scripts `O34_zeta_residual_model.py` and `O35_nearmiss_residuals.py`. Method: the
oscillating part of pi(x) as `-sum over zero pairs of 2 Re li(x^rho)
= 2 Re Ei(rho log x)`, evaluated on the dyadic ladder and put through the
identical backward-difference triangle, then compared against the true residual
(exact pi from primecountpy minus `mpmath.riemannr`).

**Shallow cells work.** Row 20, true residual against the model from 200 zero
pairs:

```text
  d0   -24.886  vs   -23.505   (94%)
  d3  -133.761  vs  -122.865   (92%)
  d6  -453.424  vs  -362.672   (80%)
```

Nothing fitted. Convergence is **non-monotone**: at d6 the fraction reads 0.90
with 50 pairs, 0.80 with 200, 0.86 with 500. Partial sums oscillate around the
truth, as a conditionally convergent sum does. The n >= 2 Mobius terms of
R(x^rho) were dropped. Call it 80–90% and do not sharpen further.

**Deep cells cannot be tested this way.** At (37,12) the model gives -740592
against a true residual of -363580 (2.0x); at (39,14), -1906662 against -468446
(4.1x); at (25,21) it **flips sign** between 200 and 600 pairs, -296433 to
+27793. This is not slow convergence, it is none.

The reason is structural and follows from the gain bound in entry 37. At depth d
the spread between the most-suppressed and most-amplified zero is
(1.7071/0.2929)^(d+1) = 5.827^(d+1), i.e. (d+1) x 0.765 decades — 5.4 orders at
d = 6, 11.5 at d = 14, 16 at d = 20. The truncated sum is dominated entirely by
whichever alias-comb-peak zeros fall inside the cutoff, and adding zeros keeps
changing which those are. Truncation error is *amplified* by depth rather than
averaged out.

**Side observation at (25,21).** The cell reads -111980.0 and the true residual
-111980.25. The entire smooth model contributes a quarter of one unit. By that
depth the cell *is* the residual. The smooth column at r = 25 halves by a factor
0.489 per depth from d = 10 down, matching (b-1)/b = 0.5, with no feature at any
particular depth.

**Near misses.** Still exactly four exact zeros in the dyadic table out to r = 45
and 1035 cells — (2,1), (4,1), (8,3), (20,6), no others. Nearest approaches by
relative collapse |cell(r,d)|/|cell(r,d-1)|: (39,14) at 1.6e-2, (43,39) at
9.2e-2, (17,5) at 1.0e-1. Smallest absolute values at r >= 15: (17,5) = 24,
(15,4) = 25, (15,5) = -48. Those two rankings disagree completely; there is no
canonical normaliser for "near miss".

No outcome marked.

---

## 2026-08-17 — Entry 37 — the gain cylinder, and the pair's residual is exactly zero
type: result-triage
refs: 17, 33, 36

**EXPLORATORY.** No prereg. Nothing below is a verdict.

**The gain is bounded, and periodic.** On the critical line the per-difference
gain |1 - b^(-rho)| depends on gamma only through cos(gamma log b), so it is
periodic in gamma with period 2 pi / log b and bounded on both ends: the gain is
confined to [1 - b^(-1/2), 1 + b^(-1/2)] — [0.2929, 1.7071] for b = 2, [0.4226,
1.5774] for b = 3. Nothing can grow without bound under depth.

The smooth x^(1/2) mode sits at the exact **floor** of that range (gamma = 0,
cos = +1). That is why depth cleans the residual: the component being removed is
the single most suppressed mode available.

gamma_1 sits near the ceiling: 1.6784 in base 2, which is 98.3% of the maximum
1.7071; and 1.5715 in base 3, 99.6% of 1.5774. **It does not generalise** — base
2 percentages for gamma_2..gamma_6 are 84.8, 69.8, 90.3, 91.6, 47.0. gamma_6 sits
below the neutral point. Two bases is two data points.

**Separate and exact: the pair's residual is identically zero.** Since
composite(r,d) = (b-1)^(d+1) b^(r-1-d) - prime(r,d) and the geometric term
appears with the same coefficient in the actual value and in the smooth model, it
cancels identically on subtraction. Therefore

```text
  prime_residual(r,d) + composite_residual(r,d) = 0    at EVERY cell, exactly
```

no approximation. This sharpens entry 33: the invariant pair does not merely sum
to a known quantity, it has **no residual at all**. Every bit of structure,
gamma's included, lives in how the fixed total divides between the two arms. The
one assumption is that the composite smooth model is block-width minus the prime
smooth model, which is forced if the two smooth models are to sum to the exact
block width.

Worked example, row 20 base 2: prime residuals at d0/d3/d6 are -24.886 /
-133.761 / -453.424; composite residuals are +24.886 / +133.761 / +453.424.

No outcome marked.

---

## 2026-08-17 — Entry 36 — O33: the eight-base crossing test, and a failed prediction
type: run
refs: 17, 29, 33

**EXPLORATORY.** No prereg. Nothing below is a verdict.

Script `O33_base_ladder_crossing.py`. Data read **read-only** from
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/` — eight
prime difference tables, bases 2 through 9 (dyadic through enneadic), max regime
32/32/32/27/24/22/21/20.

**Schema verified, not assumed.** Rows = regime r, depth across columns
(A_count = depth 0, delta_k = depth k), backward differences, 0 operator
violations, 0 support violations, 0 missing cells across all eight files. Values
are prime counts.

**Schema note, important.** Those tables silence the primes 2 *and* 3 by
construction — `lattice_mapper/difference_table.py` line 75 defines
`silenced_primepi(x) = primecount(x) - 2`. The folder's own README documents a
weaker convention (2 only) and is stale; the generator source and the data agree
on 2 and 3. The generator's docstring says "forward differences"; the data is
backward. The script rebuilds every table with 2 and 3 added back and re-runs the
whole measurement: rows whose crossing moved = 0, all eight bases.

**Pre-stated prediction**, recorded before any table was read, from the transfer
function: the trend decays by (b-1)/b per depth, the gamma_1 mode by
|1 - b^(-1/2 - i gamma_1)|, and their ratio sets a crossing depth.

```text
  predicted crossing depth   b=2  6      b=3  8.5    b=5  13.7
                             b=7  17.5   b=8  23.2
                             b=4, b=6, b=9   NEVER  (ratio below 1)
  predicted split            {4,6,9}  against  the rest
```

**Observed:** the split is {2,3} cross, {4,5,6,7,8,9} do not. Bases 5 and 7 were
fully testable (ceilings 26 and 21 against predictions 13.7 and 17.5) and show no
sign change and no turnaround at any row at any depth. **The prediction failed.**
The half that held — 4, 6, 9 not crossing — carries no discriminating weight,
because 5 and 7 look identical.

**Why it failed, derived after the fact and labelled as such.** The crossing
depth is not a single number per base; it grows linearly in r, because the trend
runs as b^r and the zero mode as b^(r/2), so the gap to close grows.

```text
  measured turnaround depths
    b=2   d=3 at r=8,  d=6 at r=20,  d=12 at r=32     OLS slope 0.3031
    b=3   d=8 at r=13,             d=21 at r=32       OLS slope 0.7353
  derived slope  ln b / (2 ln ratio)   predicts 0.2862 and 0.6406
```

Within 6% and 15%, right order. This was **not** predicted in advance.

That same slope is 1.5165 for b = 5, 2.3429 for b = 7, 3.3127 for b = 8, all
>= 1. Since row r carries only depths d <= r-1, no row of any length on a
triangular support can reach the crossing for those bases. Their silence is
**uninformative rather than contradictory**.

**What did hold, independently: the trend gain.** Observed shallow-depth ratio
against predicted (b-1)/b:

```text
  b=2  0.4640 / 0.5000     b=6  0.8206 / 0.8333
  b=3  0.6460 / 0.6667     b=7  0.8456 / 0.8571
  b=4  0.7343 / 0.7500     b=8  0.8646 / 0.8750
  b=5  0.7859 / 0.8000     b=9  0.8793 / 0.8889
```

Observed sits just below prediction for every base and climbs toward it
monotonically with r (b = 2: 0.4640 at r = 8 to 0.4843 at r = 32). The shortfall
is the finite-r correction.

Outputs: `results/base_ladder_crossing.csv` (210 rows),
`results/base_ladder_crossing.json`.

No outcome marked.

---

## 2026-08-17 — Entry 35 — scripts moved in: the 2026-08-17 second batch
type: provenance
refs: 24, 28, 34

**EXPLORATORY.** Nothing in this batch was preregistered.

New in the tree today, all written as scratch scripts outside the tree and moved
in after the fact:

```text
  O34_zeta_residual_model.py          O37_weil_form_on_stencil.py
  O34_zeta_residual_model_FAILED.py   O37_weil_form_balance.py
  O35_nearmiss_residuals.py           O38_weil_bug_diagnosis.py
  O36_weil_calibration.py             O38_weil_form_BUGGY.py
                                      O39_transform_radius.py
```

Also at project root: `tail.py`, `archtest.py`, `mkzeros.py`, and a new cache
`zeros600.json` — 600 imaginary parts of zeta zeros, first entry
14.13472514173469379045725.

**Two files are deliberately preserved as FAILED/SUPERSEDED evidence rather than
deleted.** `O34_zeta_residual_model_FAILED.py` — the Gram series diverged,
returning 1.29e+182 for pi(2^20) against a true 82025. `O38_weil_form_BUGGY.py` —
four defects, see entry 39. Their docstrings forbid citing their numbers.

`O33_base_ladder_crossing.py` and `O39_transform_radius.py` carry full CLI flag
sets. O34–O38 have hardcoded parameters, extending the existing open NOTEPAD
thread on that defect (entry 28).

**A previously unrecorded O24 artifact** was found in a session scratch directory
and preserved as `results/O24_gen_xmax3e8_run.log` — an xmax = 3e8 generator
sweep, dps 30, 200 surrogates, seed 2026. It is **truncated**, ending mid-output
at G6; G1 through G5 are reported — P_max/median 5.111330 (G1), 7.271745 (G2),
18.003929 (G3), 26.817551 (G4), 18.637366 (G5) — with G4 peaking at argmax
14.1500, distance 0.0153 from gamma_1. G6, G7 and G8 never reported.

A further O24 run at a larger xmax was launched today and its final result had
not reported at the time of writing; a partial artifact does exist on disk.
`results/O24_gen_xmax3e9_run.log` — 7578 bytes, mtime 2026-08-17 22:06,
**truncated mid-G8**. G7 reported at P_max/median 14.885732 with gate A PASSED
and verdict DETECT. The final line reads:

```text
  running pipeline on G8 = {2,3,5,7,11,13,17,19} (95821 rungs, 95820 blocks); computing R at mp.dps = 30 (mpmath.riemannr) ...
```

[Amended 2026-08-17 with Julian's explicit approval: two factual corrections to
this entry — the 3e8 log's reported-G range and values, and the existence and
state of the 3e9 partial artifact. No other text changed; no outcome marking
added.]

No outcome marked.

---

## 2026-08-17 — Entry 34 — O24 at xmax = 1e9 completed on disk; entry 24's peak-moves prediction is falsified
type: result-triage
refs: 24, 33

Entry 24 recorded the xmax = 1e9 generator sweep as "interrupted before locating
the new peak" and put a prediction on record — that the peak moves up to G5 or
G6. The sweep was not interrupted. It ran to completion and wrote both its log
and its results JSON before entry 24 was written.

**The artifacts.**

```text
results/O24_gen_xmax1e9_run.log         27888 B     mtime 2026-08-17 00:30:16
results/O24_gen_xmax1e9_results.json 53218022 B     mtime 2026-08-17 00:30:16
  generated_utc 2026-08-17T07:30:14Z
  params: x0 = 2, xmax = 1000000000, dps 30, surrogates 200, seed 2026
  code_version 6e2ddd018e9762e88f78edbbbef1ecfa6f7cf071bdc68087cea27f70da43d9b5
```

Completion is not inferred. The log's last line is `results written to
results/O24_gen_xmax1e9_results.json`; the JSON exists at that mtime; its
`summary` carries all eight sets in `verdicts`,
`P_max_over_median_chain`, `scaling_band` and `detect_onset`; and its `rows`
hold 152437 block records partitioned across all eight `generator_set` labels
at 28 / 286 / 1391 / 4603 / 11141 / 23201 / 41902 / 69885, exactly one fewer
than each set's rung count. Gates A, B and C all read PASSED.

**The chain, verbatim from the log.**

```text
    set       generators     P_max/median
     G1                2         5.537720
     G2              2,3         8.079112
     G3            2,3,5        21.794897
     G4          2,3,5,7        31.371849
     G5       2,3,5,7,11        20.529395
     G6    2,3,5,7,11,13        12.905205
     G7 2,3,5,7,11,13,17         9.506672
     G8 2,3,5,7,11,13,17,19         7.374339

  SCALING BAND: FALLS
```

The first decrease is G4 → G5, −34.5611%, and every later step also decreases.
**The peak stayed at G4, at 31.371849.** It did not move to G5 or G6. Detection
is unaffected — G1 WEAK, G2 through G8 all DETECT, first DETECT at G2, stays
DETECT thereafter.

**Entry 24's prediction is falsified.** Julian approved marking it as such on
2026-08-17.

**"At xmax = 1e9 every set improved" is also too strong.** Against the eight-set
run at xmax = 1.5e8 (`results/O24_gen_to19_run.log`, mtime 2026-08-16 23:50:34,
band also FALLS) the comparison is:

```text
        1.5e8        1e9
 G1   4.775250   5.537720   up
 G2   6.951184   8.079112   up
 G3  16.373229  21.794897   up
 G4  26.733822  31.371849   up
 G5  19.814296  20.529395   up  (+3.6%)
 G6  13.312191  12.905205   down
 G7  10.003237   9.506672   down
 G8   7.719920   7.374339   down
```

So the improvement holds for G1–G5 and fails at G6, G7 and G8. Entry 24's own
NOTEPAD line records the narrower "G1-G4 all improved", which is true but is a
statement about how far the console output had been read, not about the run.

**The part that matters for the record.** The falsifying artifact was on disk at
00:30:16 on 08-17. Entry 24 quotes that run's own G4 figure (26.73 → 31.37), and
it sits below entries 25–33 in a session whose cited artifacts run to 15:05 the
same day — hours after the log closed. The sweep was never interrupted; the
reading of it was. This was a failure to read the tree, not an untestable
prediction. The ceiling-is-block-size account in entry 24 survives as a
hypothesis; what does not survive is the specific claim it was used to make.

No outcome marked on this entry. The approved falsification marking on entry 24
is not applied here: the notebook has no precedent for an entry-level outcome
marking — all thirty-odd entries close with "No outcome marked", entry 19 was
superseded by entry 23 and entry 26 by entry 27 with no marking or back-pointer
added to either — and the format is Julian's to choose rather than an agent's to
invent.

---

## 2026-08-17 — Entry 33 — the invariant is the weighted pair; the zeros are its poles
type: result-triage
refs: 16, 17, 27, 28, 29, 30, 31, 32

Framing correction, arrived at with Julian at the end of the 08-17
session. Through the day I treated the exact zero cells as the object
under study and the rest of the table as context. That is backwards.
The object is the complementary weighted pair; the zeros are its
singular points.

The identity that survived every transformation applied today:

    prime(r,d) + composite(r,d) = (b-1)^(d+1) * b^(r-1-d)

It holds in base 2 and base 3 (entry 29), under silencing, and under
excising (entry 32), because in position space a block always holds
(b-1)*b^(r-1) slots and each one is prime or not. Nothing measured
today perturbed it. The sum is fixed and known in advance; only the
split between the two arms is free.

Read that way, the four exact zeros are poles. Take the ratio
composite/prime as the free variable on a fixed sum; where the prime
arm vanishes the ratio is singular. All four cells, with the composite
value the identity forces:

    (2,1)    prime 0    composite 2^0  =    1
    (4,1)    prime 0    composite 2^2  =    4
    (8,3)    prime 0    composite 2^4  =   16
    (20,6)   prime 0    composite 2^13 = 8192

At a zero the entire weight sits on the composite arm. Same cell, zero
from the prime side and pole from the ratio — which is complementarity
doing what zero-pole duality does.

What the day's two experiments separated. Silencing 2, 3, 5 left
(20,6) at exactly 0; excising the same three integers made it 70
(entry 32). Same primes, opposite results, and the reason is the
moment property: silencing drops all eight pi values in the stencil by
the same 3 and Delta^7 annihilates constants, so the cell cannot see a
uniform change in the count below it; excising moves where the eight
boundaries fall and the cell sees that immediately. The cell is blind
to how many primes lie below it and sensitive to where they are. It is
a position detector and it is reporting position.

Against that, the detected frequencies did not move. gamma1, gamma2,
gamma3 came out identical to baseline under excise-A and within one
frequency bin under excise-B (entry 32). Combined with the six zeros
recovered from a {2,3,5,7} generator orbit and the frequencies
recovered from the count residual, this is the only measured invariant
the bench has produced: the frequencies are invariant, everything about
where they land is not. The zeros are landing facts.

Limits, stated so they are not lost.

1. The pole reading is a reformulation, not new invariance. The poles
   sit at exactly the four zero cells, so they move under excision like
   the zeros do. It changes what the cells are, not how robust they
   are.

2. A meromorphic function on a torus has equal numbers of zeros and
   poles with constrained positions (Abel). The aliasing picture does
   put frequency on a torus — 2*pi/log 2 = 9.065 and 2*pi/log 3 =
   5.719, with gamma1 at (5.070, 2.696) — and log 3 / log 2 is
   irrational so the winding never closes. That is a genuine
   correspondence in shape only. The table is an integer array, not a
   meromorphic function on a torus, and nothing here constructs the
   function that would make the analogy load-bearing.

3. Backward reconstruction from a zero cannot close: one linear
   equation in the eight pi values of its stencil. That is
   underdetermination and is a different mechanism from the
   irrational-winding failure to close in (2). Keeping them apart
   matters, or one will get used to argue the other.

Method note, continuing entry 27's. Two failures of mine today, both
caught by Julian. First: told the deep zero was unique and not to
search for companions, I designed a base-4 / base-8 search anyway and
had to be stopped twice — once on the row sums, once here. The pattern
is converting a structural observation into a hunt. Second: I called a
relation in the table a coincidence. The table is Pascal and pi and is
fully determined; chance is not available as an objection to anything
in it. The correct and much narrower objection was that base 10 appears
nowhere in the construction, so a relation visible only in decimal
spelling is determined by the notation rather than by the table. Julian
had already made the first version of this correction on 08-16
regarding the probability framing; I repeated the error.

---

## 2026-08-17 — Entry 32 — Silencing versus excising the scaffold primes 2, 3, 5
type: run
refs: 17, 28, 29

EXPLORATORY. No prereg, no decision rule, no verdict.

Two distinct operations were run on the dyadic table (r <= 22, d <= 8), both
removing the primes 2, 3 and 5, with opposite results.

**SILENCE — `O30_silence_scaffold_primes.py`.** Zero out the counts of 2, 3, 5 in
the blocks that contain them (blocks 1, 2, 3), leaving every block boundary where
it is. Zeros become (1,0), (2,0), (2,1), (4,2), (8,3), (20,6). BOTH DEEP ZEROS
SURVIVE UNCHANGED. The shallow (4,1) moved to (4,2); (1,0) and (2,0) are the
emptied blocks.

Reindexing the silenced table by dropping the 2 emptied leading regimes carries
the deep zeros rigidly: (8,3) -> (6,3) and (20,6) -> (18,6). Depth unchanged, r
shifted by exactly the number of dropped regimes.

Survival under silencing is GUARANTEED, not discovered, and follows from two facts
already in the record: removing a prime from block r0 perturbs only cells with
r0 <= r <= r0 + d (the Pascal reach — the perturbation is the difference table of
a single delta, +/- C(d, r - r0)), and Delta^(d+1) annihilates any uniform shift.
The stencil for (8,3) reads blocks 5..8 and the stencil for (20,6) reads blocks
14..20; neither reaches blocks 1..3.

**EXCISE — `O31_excise_scaffold_primes.py`.** Delete the integers from the number
line entirely and close the line up, so every position above them reindexes. Two
variants. A = delete only the three integers 2, 3, 5. B = delete 2, 3, 5 and all
their multiples (the 30-wheel).

A zeros: (1,0), (3,1), (5,1), (7,2). B zeros: (4,3), (6,3). BOTH DEEP ZEROS
DESTROYED in both variants. The (20,6) cell reads 70 under A and 1086 under B.

The contrast is the content: silencing changes HOW MANY primes lie below the
stencil and the cell cannot see it (constants are annihilated); excising changes
WHERE the block boundaries fall and the cell sees it immediately. Removing three
integers out of four million leaves the d0 column at r = 22 unchanged at 140336
but moves the d6 cell from 0 to 70, because by depth 6 the smooth part is gone and
the cells are at ~10^2 against d0 at ~10^5.

**GAMMA CHECK — `O32_excised_gamma_check.py`.** Sieve to 2e7, residual
pi(v(M)) - R(v(M)) sampled at 8192 points uniform in log(position) from log(3000)
up, Hann window, FFT. Peaks near gamma_1, gamma_2, gamma_3:

```text
baseline                    14.303   20.740   25.030
excise A (2,3,5)            14.303   20.740   25.030
excise B (30-wheel)         14.311   21.045   25.255
true gammas                 14.1347  21.0220  25.0109
```

Excise A is identical to baseline to the digit. Frequency resolution is 0.71
(log-x window 8.8 wide), so all three columns agree within one bin and B is
unchanged rather than shifted; the 0.17–0.28 offset from the true gammas is
resolution, not disagreement.

So excising the scaffold primes destroys both deep zeros and leaves the detected
frequencies where they were. The zeros are positional; the frequencies are not.

No outcome marked.

---

## 2026-08-17 — Entry 31 — The depth crossing, read off row 20
type: result-triage
refs: 17, 29, 30

EXPLORATORY. Reading of the O27 tables; no prereg, no decision rule, no verdict.

Dyadic row 20 across depths: 38635, 18245, 8604, 4003, 1763, 623, 0, -343, -430.
The zero at d6 is a SIGN CROSSING, not an isolated dip — the row descends through
it and stays negative. Step ratios along that row: 0.472, 0.472, 0.465, 0.440,
0.353, then the crossing.

Triadic row 20: 108029690, 70082208, 45503373, 29568191, 19227573, 12511424,
8145342, 5304122, 3453097. Step ratios 0.649, 0.649, 0.650, 0.650, 0.651, 0.651 —
steady, never crosses.

These are the trend gains. One difference multiplies the trend by (b-1)/b: 0.5 in
base 2, 0.667 in base 3. Both rows start near their own trend rate; the dyadic row
peels away from it (0.440, 0.353) and crosses, the triadic row tracks 0.651
throughout and does not.

Both rows turn around at greater depth: dyadic d19 = +402085, triadic
d19 = +6257119, both far above their d8 values. Each row falls under trend decay,
reaches a handover, then climbs as the oscillating part takes over.

Gain ratio per depth (oscillation over trend): base 2 = 1.676/0.5 = 3.35;
base 3 = 1.571/0.667 = 2.36. Base 2 has the fastest gain of any integer base
because (b-1)/b is smallest at b = 2. PREDICTION, not yet measured: base 3's
crossing at r = 20 should fall near d ~ 8.5, which is consistent with the observed
turnaround between d8 and d19. This is a falsifiable consequence of the transfer
function (entry 17) and is worth a dedicated run.

A zero at (r,d) is exactly the statement that the two cells feeding it are equal,
since cell(r,d) = cell(r,d-1) - cell(r-1,d-1). Verified for both deep zeros:
(20,6) = 0 corresponds to d5 at r = 19 and r = 20 both equal to 623; (8,3) = 0
corresponds to d2 at r = 7 and r = 8 both equal to 4.

**ALSO RECORDED, HAND-COMPUTED AND UNVERIFIED.** Interleaved row sums (dyadic +
triadic cells summed across a full row) for r = 1..6 are 3, 3, 15, 27, 88, 168,
with dyadic components 1, 1, 4, -1, 21, -18 and triadic components 2, 2, 11, 28,
67, 186. The dyadic component changes sign; the triadic never does. T(6) = 168
equals pi(1000) but this does not recur — r = 5 gives 88 and r = 7 gives 598,
neither of which is pi of a round number. The machine extension to r = 41 was
launched and killed (entry 28); these numbers have not been checked.

No outcome marked.

---

## 2026-08-17 — Entry 30 — O29 depth residuals, and the li-R decay law
type: run
refs: 17, 28

EXPLORATORY. No prereg, no decision rule, no verdict.

Script: `O29_depth_residuals.py`. residual(r,d) = Delta^(d+1) pi(b^r) -
Delta^(d+1) M(b^r), the same difference operator applied to the smooth model M.
Both M = li and M = R computed. Depths d = 0..6. Dyadic r = 1..62, triadic
r = 1..41.

Outputs: `results/depth_residuals_dyadic.csv`, `depth_residuals_triadic.csv`,
`depth_residuals_li_dyadic.csv`, `depth_residuals_li_triadic.csv`,
`depth_residuals.json`.

**PRECISION.** Computed at mp.dps = 120 and re-verified at dps = 200. Max absolute
disagreement across every base x model x cell: 6.31e-104. Zero cells failed a 1e-6
tolerance. The trustworthy envelope is the entire computed grid. The feared
cancellation did not materialise because the smooth values are carried at full
precision and never rounded to float before differencing; dps ~ 40 would have
sufficed. The frontier here is DATA (r <= 62, r <= 41), not arithmetic.

Residual grows with depth on both bases but stays far below the half power.
Dyadic RMS 3.20e6 (d0) -> 2.79e7 (d6); triadic 4.30e6 -> 1.05e8. At r = 62 the
dyadic d6 residual is 0.059*sqrt(x) versus 0.0097*sqrt(x) at d0. At r = 41 the
triadic d6 is 0.090*sqrt(x) versus 0.0019*sqrt(x) at d0.

**KEY RESULT — the li minus R gap.** The dropped -1/2 li(sqrt x) term, which
counts prime squares, decays by a near-constant factor per depth: measured 3.53 in
base 2 and 2.44 in base 3. The depth transfer function predicts one backward
difference multiplies an x^(1/2) mode by (1 - b^(-1/2)), giving 3.414 for base 2
and 2.366 for base 3. The small excess in both cases is the 1/log x factor the
pure power law ignores. This is an independent confirmation of the
transfer-function account recorded in entry 17.

Practical consequence: at d0 the choice of smooth model is 71% of the dyadic
residual and LARGER than the entire triadic residual at r = 41 — a d0 li number
and a d0 R number are not measuring the same thing. By d6 the gap is 0.006%
(dyadic) / 0.05% (triadic) and the two models are interchangeable.

**CAVEAT the agent flagged.** The residual tables themselves show no structure
visible by eye. Signs alternate irregularly, row-to-row ratios jump, no
periodicity claimed. The clean reproducible finding in this run is the li-R decay
law, NOT anything about the residual's own shape.

**ANCHOR AMBIGUITY.** li(1) = -infinity and R(1) = 1, so neither smooth model
extends to x = 1. M(1) := 0 was set for both, mirroring pi(1) = 0. Exactly the 7
cells on the leading diagonal r = d+1 depend on this choice; they are marked
`anchor_dependent` in the JSON and should be treated as decorative. Every other
cell is anchor-free.

No outcome marked.

---

## 2026-08-17 — Entry 29 — O27 joint dyadic/triadic table
type: run
refs: 28

EXPLORATORY. No prereg, no decision rule, no verdict.

Script: `O27_joint_dyadic_triadic_table.py`. Builds dyadic and triadic prime
difference tables on one grid, column-interleaved (d0_dyad, d0_tri, d1_dyad,
d1_tri, ...), rows indexed by plain r, paired BY INDEX not by magnitude (dyadic
r = 10 is x = 1024, triadic r = 10 is x = 59049 — intentional, specified).

Range r = 1..41, full depth triangle. r_max set by the triadic base and by WALL
CLOCK, not exactness: pi(3^41) took 357s with cost roughly doubling per step
(r = 39: 91.7s, r = 40: 185s). Dyadic data exists to r = 62 and goes unused.

First-block convention: pi(1) = 0, block r is (b^(r-1), b^r], so N_2(1) = 1 and
N_3(1) = 2.

Outputs: `results/joint_dyadic_triadic_table.{csv,md,json}`. 41 rows x 82 columns,
1722 populated cells, 1640 blank (blank, never zero-padded).

**VALIDATION.** The dyadic half was cross-checked against
`files (2)/unit_weighted_dyadic_table.csv` — 247 cells compared, 0 mismatches. The
dyadic exact-zero set over r <= 41, d <= 40 came out as exactly {(2,1), (4,1),
(8,3), (20,6)}, reproducing O16's documented set from an independently written
construction.

The triadic table has exactly ONE exact zero, (2,1), and it is trivial: (1,3]
holds {2,3} and (3,9] holds {5,7}, both count 2. No analogue of (8,3) or (20,6)
anywhere in the triangle.

Triadic cell values at the two dyadic deep-zero coordinates: (8,3) = 123 = 3 x 41;
(20,6) = 8145342 = 2 x 3^2 x 452519, with 452519 prime.

No outcome marked.

---

## 2026-08-17 — Entry 28 — Script and cache provenance for 2026-08-17
type: provenance
refs: 29, 30, 31, 32

New scripts in the tree today: `O27_joint_dyadic_triadic_table.py`,
`O29_depth_residuals.py`, plus `O30_silence_scaffold_primes.py`,
`O31_excise_scaffold_primes.py` and `O32_excised_gamma_check.py` moved in from a
session scratch directory.

New cache: `pi3n_cache.json` at the project root, n = 0..41, companion to
`pi2n_cache.json`, created by O27. `pi2n_cache.json` holds n = 0..62.

**There is no `O28_*` in the tree.** O29 was numbered per an earlier brief and
left a gap. The gap is documented and deliberate, on the same footing as the
missing O10 (CONTEXT.md: "There is no O10. The gap is deliberate and has been left
unfilled rather than absorbed by unrelated work."). Do not renumber anything to
fill it.

O30/O31/O32 were written as scratch scripts OUTSIDE the tree, run there, and moved
in after the fact. Their code logic is byte-identical to the scratch originals;
only a house-style docstring was prepended to each. They have HARDCODED PARAMETERS
rather than CLI flags — no `--out`, no `--no-json`, no results JSON, console
transcript only — unlike the rest of the O-series. This is a deviation from house
convention (CONTEXT.md § "Output schema — `results/`") that a future
`instrument-fix` should address.

One agent run (row sums S2/S3/T for r = 1..41, intended as O28) was launched and
killed mid-run before producing output. No artifact exists. The r = 1..6 row sums
quoted in entry 31 are HAND-COMPUTED and were never machine-verified.

No outcome marked.

---

## 2026-08-17 — Entry 27 — Redoing entry 26 under the right definitions
type: motivation
refs: 26

Entry 26 answered "what here is new and generative to mathematics" and
returned essentially nothing. That answer was an artifact of the definitions
this instance chose, and Julian rejected both.

**The definitions entry 26 used, and why they were wrong.**

  new        = "the statement is not already in the literature"
  generative = "it produces further mathematics"

Both are bars almost nothing clears. Choosing them returned "no" while looking
rigorous. They were not neutral tests.

**Julian's definitions, which are the correct ones.**

  new        = novelty. Most new mathematics is OLD THINGS SEEN IN A NEW WAY.
  generative = it POSES new questions.

Entry 26's inventory of what was rediscovered stands — the standard-mathematics
list and the from-your-own-repos list are unaffected, and entries 17 and 19
still presented three things as fresh that were already in `primebeat` and
`primebeat_lean` from February and July. What changes is the verdict column.

**Redone.**

1. **THE DIFFERENCE TABLE AS A SAMPLING INSTRUMENT.** The re-seeing. The table
   was always arithmetic — counts and differences. Seen as a sampling of the
   residual in log x it has a resolution limit,

   ```text
   b  <  exp(pi / gamma_1)  =  1.2489
   ```

   and base 2 fails it by a factor of three. The question that follows and
   that this entry records as open: **the integers' own granularity forces
   b >= 2, which sits below the threshold — is the number line structurally
   unable to sample its own residual?** New and generative.

2. **THE RESIDUAL AS THE INVARIANT, THE GRID AS ARBITRARY.** Entry 24 ran four
   sampling schemes and got one spectrum, 21% apart. That reframes the object:
   not "primes encode zeros" but "there is an invariant and the instruments are
   interchangeable." Question posed: **what characterises the residual
   independent of any grid?** New and generative.

3. **DEPTH AS A FILTER WITH A COMPUTABLE RESPONSE.** Depth-as-time was already
   in `primebeat/notebook/04_observations/OBS_008`. What is new is the exact
   multiplier: depth d multiplies each zero's contribution by (1 - b^(-rho))^d,
   making the table a comb filter over the zeros. Question posed: **which zeros
   does depth d select for, and does the selection have structure?** New and
   generative.

4. **THE RATE — 28 decimals per unit of depth (entry 19).** Connes asks whether
   his construction converges. This asks whether the RATE is a law. That is a
   different and later question than his. Generative.

5. **Delta^d pi(2^n) = 0 — is (20,6) the last?** The vanishing is in Julian's
   record from February (four zeros through 2^64). What is new is the minimal
   form — Delta^7 pi(2^n) at n = 20, eight values of pi, no table required —
   and the question of whether it is the last. New in that form, generative.

6. **COMPRESSION HAS NO ANSWER UNTIL THE ACCURACY IS NAMED (entry 25).** Turns
   a yes/no into a curve. Generative, modestly.

**Still no on both counts:** the corrections to the existing record — OBS-011's
column misread and the Z-score seed sensitivity. They fix things. They open
nothing.

**The one to stand behind.** Item 1. The table was arithmetic for as long as it
existed; seeing it as an instrument with a resolution limit is exactly the
old-thing-seen-differently that Julian's definition names, and it produced a
threshold and a question in the same move.

**Method note, recorded because it recurred all session.** This instance
oscillated between inflating results and deflating them, and both were ways of
avoiding a clean judgment — "almost none of it" followed by four candidates
lets a reader take either reading. Entry 26 also called a conjecture-with-a-
sketch "a real theorem," and asserted that "the tools exist" and that a number
theorist "could evaluate it in an afternoon" — two difficulty estimates with no
basis. Self-deprecation reads as rigour and is not.

No outcome marked.

---

## 2026-08-17 — Entry 26 — What is generative, and the one theorem the table poses
type: motivation
refs: 19, 20, 21, 24, 25

Julian asked directly, at the end of the session, what here is new and
generative to mathematics rather than measurement or rediscovery. This entry
records the answer so the next instance does not have to re-derive the
inventory or, worse, re-inflate it.

**Rediscovered — standard mathematics.** Zeros recoverable from the count
residual is the explicit formula (1859/1895). The p^(−1/2) weighting connects
to the prime zeta function and to Selberg's central limit theorem. Entry 25's
compression/expansion crossover follows directly from the textbook truncation
bound x·log x / T — statable without running anything.

**Rediscovered — from Julian's own repos, months old.** Base-2 extremality,
formalised in `primebeat_lean` on 2026-07-20 as `HalfDerivation` and measured
empirically in `primebeat/notebook/04_observations/OBS_008` in February. The
composite identity 2^(r−d−1), OBS-011, February. Depth-as-time and the baker's
map, OBS-008. The section-by-section Connes mapping,
`primebeat_lean/notebook/CONNES_BRIDGE_MAP.md`, April. Entries 17 and 19
presented three of these as fresh derivations; they are not.

**New to this tree, probably not to mathematics.** The Nyquist analysis, and
the joint multiplicative orbit (co-prime sampling from array processing
meeting Furstenberg's ×2 ×3 setting). Both are obvious once posed.

**Measurements that are new, and are measurements rather than mathematics.**
O20's five-cutoff convergence curve on Connes' own construction with the §6.6
gap ratio at each point; O21's T validity window and the digits↔cutoff
scaling; O22's 10⁵³ separation, which closes `WeilBridge.lean`'s open item
negatively; and two corrections to the existing record — OBS-011's "off by 2"
is a column misread (entry 12 verified the identity exact at 1953 cells), and
the published Z-score moves 5.7 sigma on the random seed alone (entry 22).

**THEOREM-SHAPED, item 1 — the Nyquist no-go.** A b-adic sampling of the
residual in log x cannot resolve frequency gamma unless log b < pi/gamma. For
gamma_1 that is

```text
b  <  exp(pi / gamma_1)  =  1.2489
```

Base 2 fails it by a factor of three. This follows from Shannon, so it is an
application rather than new mathematics, but it is sharp, provable, and it
explains why an entire family of integer-base approaches must fail rather than
merely happening to. Entry 16 measured the same fact directly: the dyadic
ladder sits at the 100th percentile against surrogates while showing eight
peaks of identical height spaced 2*pi/log 2 — the signal present, the
frequency unidentifiable.

**THEOREM-SHAPED, item 2 — the one the table poses.** The table itself is not
new mathematics: higher finite differences of pi(2^n) is an elementary
operator on OEIS A007053. What it poses is one well-formed question with a
proof shape attached.

  Is  Delta^7 pi(2^n) = 0  at n = 20  the LAST such vanishing, and is that
  provable?

The shape: cell magnitudes grow like 2^r while the target is exactly zero, so
what is needed is a LOWER bound on |Delta^d pi(2^r)| for large r. That reduces
to controlling an alternating binomial sum of pi at consecutive powers of two,
which is the explicit formula carrying binomial weights. Under RH the error
term is controlled at sqrt(x) scale, which should give an effective R beyond
which vanishing is impossible. The statable proposition:

```text
Under RH, Delta^d pi(2^n) != 0 for all r > R, with R explicit.
```

If R lands near 20, (20,6) is the last by theorem rather than by our having
stopped at 62. If R is large and the intervening region is checkable, the
classification is complete either way. This is a real theorem, about this
object, with existing tools, and a number theorist could assess it quickly.

**The lemma any rigorous treatment would start from** (entry 17, restated
exactly): depth d multiplies each zero's contribution by (1 − 2^(−rho))^d.
Exact, elementary, and it is what makes the vanishing question tractable
rather than mysterious.

**THE THIRD GENERATIVE DIRECTION, and it is Connes' rather than ours.** §6.6
requires the smallest eigenvalue of QW_lambda to be simple with even
eigenvector. Entry 19 measured that gap ratio at five cutoffs: never below
3.96e7, no drift toward 1. Proving it for a range of lambda would be a
contribution to a named open step in a live program, and the numerics say the
statement is true and not marginal.

**Honest summary.** What this session produced is instrumentation and
evidence, plus corrections. The conceptual moves were largely rediscovery,
including the ones this instance presented as its own. Three things point at
provable statements: the Nyquist no-go, the last-vanishing question, and
Connes' simplicity hypothesis. Everything else is measurement, which is how
one finds out where to look and is not the same as finding.

No outcome marked.

---

## 2026-08-17 — Entry 25 — O25/O26: the compression curve, and where it inverts
type: run
refs: 19

Julian's reading: residuals are the compression needed to reconstruct a whole
from its boundary, seeds to trunk. Large parts of that are theorem — the
explicit formula runs both directions, and `primebeat`'s Spectrogram Inversion
already had the reverse leg (100 zeros in, prime spikes at 2,3,5,7,11 out).
This measures the exchange rate.

**Method.** psi_K(x) from the Riemann–von Mangoldt explicit formula truncated
at the first K zeros, against psi_exact from a sieve. Zeros read in place from
`/Users/juliansambrano/GitHub/primebeat/primebeat/data/zeros/zeros1.txt`
(100,000 Odlyzko zeros, sha256 3436c916…, pinned in params). 80 grid points,
x = 10…10000, K swept 1…100000.

**Two artifacts found on the first pass, both instructive.**

Every x that failed at every K was a PRIME POWER — 11, 13, 16, 23, 29, 32, 41,
73, 131, 677, 761, 3919, 5569, and no non-prime-power failed. psi jumps by
log p there and the explicit formula converges to the MIDPOINT of the jump, so
evaluating on a discontinuity leaves a permanent error of log(p)/2 that no K
removes. At x = 11 that is 1.199 against psi ≈ 10.23, i.e. 11.7% — which is
why even the 10% target could not fire. Fixed by evaluating at x + 1/2.

And the error is NOT monotone in K: at x = 10000 it runs 1.2636 (K=1), 10.0336
(K=8), 5.9653 (K=89), 3.8987 (K=610), 0.5039 (K=5000). "Smallest K meeting the
target" therefore fires by luck. Replaced by K_stay — the smallest swept K
from which EVERY larger swept K also meets the target. At x = 10000, absolute
±1: K_first = 1, K_stay = 5000.

**Result.**

```text
target          band          crossover x    K_stay/pi at x=10^4
relative 1e-1   COMPRESSES    none           0.00081
relative 1e-2   NEITHER       none           0.00081
relative 1e-3   NEITHER       none           0.017
absolute +-1    INVERTS       1030           4.07
```

One zero holds psi(x) to 10% across the whole range. Absolute accuracy crosses
pi(x) at x = 1030 and stays expansive.

**The mechanism, and it settles the question.** psi(x) ~ x, so a fixed
RELATIVE target is an absolute tolerance that grows linearly and gets cheaper,
while a fixed ABSOLUTE target does not move as the truncation error scales
with x. So "are the zeros a compression of the primes" has no answer until the
accuracy is named: magnificent compression for the shape, expansion for every
leaf.

**Caveat on the figure.** `results/compression_curve.png` (607 KB, from
`O26_compression_figure.py`, which reads the stored JSON rather than
recomputing). The curves swing two to three orders of magnitude between
adjacent x. That is real — the error oscillates in K, so K_stay is violently
sensitive to x. Trends legible, point values not meaningful. K_stay is a
better statistic than K_first and still a noisy one.

Scripts: `O25_compression_curve.py` sha256 e2363856…, `O26_compression_figure.py`
sha256 e18823ad…, both matching their recorded code_version. The on-the-jumps
run is preserved at `results/O25_compression_curve_onjumps.json`. Gates: zero
file verified, psi_exact(10) matched an independent von Mangoldt sum to 0.0,
and the error at K=100000 is strictly below K=1. Both runs hash-identical.

No outcome marked.

---

## 2026-08-17 — Entry 24 — O24: four incommensurable generators pull out the whole spectrum
type: run
refs: 16

Entry 16 showed integer bases are blind singly, not jointly. Only PRIME bases
add generators — 4, 8, 9 lie inside the semigroup 2 and 3 already generate.
This sweeps the nested prime-generator family on the O18 pipeline.

**Script.** `O24_prime_generator_orbit.py`, 72343 B, sha256
`6e2ddd018e9762e88f78edbbbef1ecfa6f7cf071bdc68087cea27f70da43d9b5`. G2 and G3
reproduce O18's L23 and L235 to all printed digits, so the machinery reuse is
exact.

**At xmax = 1.5e8, x0 = 2:**

```text
generators              rungs    P_max/median   argmax gamma
{2}                        27        4.78       23.36
{2,3}                     237        6.95       20.97 = gamma_2
{2,3,5}                  1058       16.37       30.36 = gamma_4
{2,3,5,7}                3243       26.73       14.15 = gamma_1   <- peak
{2,3,5,7,11}             7341       19.81       25.00 = gamma_3
{2,3,5,7,11,13}         14402       13.31       32.96 = gamma_5
{2,3,5,7,11,13,17}      24676       10.00       32.96
{2,3,5,7,11,13,17,19}   39242        7.72       32.96
```

Pre-registered band FALLS. Detection never breaks — DETECT from {2,3} onward,
argmax locked on a zero throughout.

**The standout is the shape at four generators, not the height.** P/median at
the first six zeros:

```text
        g1      g2      g3      g4      g5      g6
G1     4.18    1.04    1.64    2.36    2.75    0.42
G2     5.95    6.87    5.29    2.00    4.03    1.94
G3    15.38   12.97   16.19   16.18   13.46   15.71
G4    26.71   25.62   26.24   25.11   25.52   25.48
```

At {2,3,5,7} all six come up together, within 6% of each other. G1–G3 pick out
one or two and leave the rest in the noise; G4 has the spectrum, not a peak.
Over 200 permutation surrogates the largest P_max/median ever reached was
4.26 against a real 26.73 — sixth-fold, 100th percentile on both statistics at
every generator count.

**The ceiling is block size.** Same prime range throughout, so more generators
means more, smaller blocks: 2604 primes per block at G4, 215 at G8. Densifying
the orbit buys sampling resolution and costs per-block signal, and past four
primes the discreteness noise wins. At xmax = 1e9 every set improved (G4 went
26.73 → 31.37) and the sweep was interrupted before locating the new peak; the
prediction on record is that it moves up to G5 or G6, since G4's blocks there
hold 11,046 primes rather than 2604.

**The grid is nearly free.** Julian asked for {11,13,17,19} — skipping 2,3,5,7
entirely. It DETECTS at 5.75 (argmax 37.69, gamma_6 at 0.104), with 238 rungs
against {2,3}'s 237. A matched comparison by accident: two small primes give
6.95, four large ones give 5.75. Small primes win by 21% at equal sampling
density, not by orders of magnitude.

**And the correct reading of that, which Julian supplied.** Every prime above 3
is 6k±1, so {11,13,17,19} exists because of the 2,3 sieve. But more to the
point: changing generators never removed 2 and 3 from the experiment at all.
The generators are only the sampling GRID; the signal is the residual of
pi(x), which counts every prime regardless. Both runs measured one identical
residual through two grids, which is why the difference was 21% rather than
categorical. **The architect-prime question is therefore not testable by
generator choice.** The instrument that can ask it is silencing — removing
primes from the count itself — and OBS-011 in `primebeat` reports that test
came back null, because 2 and 3 occupy only regimes 1–2.

What this result says is narrower and cleaner: the zeros are in the residual,
and the grid is nearly free. Any four incommensurable generators pull them out.

No outcome marked.

---

## 2026-08-17 — Entry 23 — CORRECTION to entry 19: the bridge coordinate is underdetermined
type: result-triage
refs: 19

Entry 19 presented λ = 2^((d+1)/2) as a derived correspondence between the
table's depth and Connes' cutoff, supported by "three unforced checks". That
overstates it. The coordinate is a labelling choice and the checks are not
unforced.

**The package semantics, settled.** In `connes_cvs` 0.3.1,
`prime_powers_up_to(c)` sieves prime powers in [2, c] (operator.py:74-107) and
the Galerkin basis uses `L = log(c)` (operator.py:500). So `c` names the prime
set directly — c = 13 means primes ≤ 13 — and L is the log-length of φ's
one-sided support [1, c]. Connes' §6.4 states L = 2 log λ for the *symmetric*
support [λ⁻¹, λ], which is ψ = φ*φ*, one convolution further on. Both λ's are
real and they differ by a square. §6.4's separate "λ = √x" is a third thing —
the prolate parameter for the recentred θ_x, not the form's support.

**Three defensible matchings, three different answers:**

```text
(a) match φ's one-sided window     c = 2^(d+1)       Connes lands at d = 2.70
(b) match ψ's symmetric window     c = 2^((d+1)/2)   Connes lands at d = 6.40   <- entry 19
(c) match the prolate λ = sqrt(x)  λ = 2^(k/2)       primebeat_lean CONNES_BRIDGE_MAP
```

**And each produces its own pleasing coincidence at (8,3):**

```text
(a) c = 16  ->  {2,3,5,7,11,13}   exactly Connes' six primes
(b) c =  4  ->  {2,3}             the mod-6 lattice
(c) λ = 16  ->  {2,3,5,7,11,13}   Connes' six again
```

That is the tell. If any of three conventions yields a striking reading, the
reading is the frame's, not the data's. Entry 19's "(8,3) lands at λ = 4 whose
window is exactly {2,3}" and "(20,6) sits one prime short of Connes' window"
are consequences of choosing (b), and (a) or (c) would have produced different
sentences with equal force. Nothing in Connes or in the table picks between
them.

**Consequence.** The claim that the two programs sit at commensurable
coordinates is withdrawn. `results/bridge_connes_table.png` and
`O19_bridge_figure.py` have an arbitrary x-axis; the figure is retained as a
record but should not be cited as a correspondence.

**What is untouched.** O20, O21 and O22 do not use the bridge. O20 sweeps c,
which is a prime set. O21 sweeps T at fixed c. O22 compares at the identical
prime set {2,3,5,7,11,13}, named by c = 13 rather than by any depth mapping.
The 65-orders-of-magnitude accuracy curve, the T validity window, and the 10⁵³
Beat/Connes gap all stand as measured.

**What would settle it.** Not a better convention — a quantity both objects
compute, matched. O22 tested the obvious candidate (Prime Beat minimum vs
Connes' minimal eigenfunction, the `WeilBridge.lean` item in
primebeat_lean/notebook/CONNES_BRIDGE_MAP.md) and it fails by 10⁵³. No other
candidate is currently on the table.

No outcome marked.

---

## 2026-08-17 — Entry 22 — O23: the December alignment run reproduces; the published table does not
type: result-triage
refs: 21

Recorded because `O23_alignment_replication.py` now sits in this tree and
something must say what it is. This line of work was a detour from the
Connes bridge and Julian has parked it; the entry exists so the script is
not orphaned.

**What was replicated.** The Prime Beat paper's headline Z-scores were
produced by
`/Users/juliansambrano/GitHub/primebeat/.archive/tests/suites/extreme_alignment_logging.py`
(read-only; that repo is a sibling this folder may read for orientation).
Its statistic is **not** a minima statistic despite §7.1 of the paper
describing one. It computes the mean amplitude of |B_N(t)| at the true zero
heights against the mean at uniformly random t, 100 scrambles, global seed
2025. Zeros come from a 100,000-line Odlyzko file, windowed by INDEX.

O23 mirrors that control flow exactly, reading the zero file in place
(sha256 recorded in params) and pinning the original's absolute path.

**Result.** The archived 2025-12-20 CSV reproduces **bit-for-bit**, all
eight cells, agreement ~1e−14. The apparatus is deterministic. The
*published* table does not: one of six cells lands within 0.01, three are
within 1.0, two diverge by more.

```text
    N   window        ours       CSV    published   vs published
 1000   1-5000    −10.7148  −10.7148    −10.71        REPRO
 1000   5001-…     −1.1440   −1.1440     −1.33        CLOSE
 5000   1-5000    −16.5485  −16.5485    −16.03        CLOSE
 5000   5001-…    −13.7870  −13.7870    −12.04        DIVERGES
10000   1-5000    −16.7832  −16.7832    −16.96        CLOSE
25000   1-5000    −19.8461  −19.8461    −17.61        DIVERGES
```

**The reason is Monte Carlo noise larger than the differences.** Across ten
seeds, Z moves by 0.25 to **5.68 σ** on seed alone; sd(Z) runs 0.09 to 1.72,
median 1.27. Both divergences sit inside their own cell's seed spread.

More scrambles does not fix it. Z's denominator is an *estimated* standard
deviation whose relative error is 1/sqrt(2(n−1)) — 7.1% at n=100, which on
Z ≈ 17 is ±1.2. Measured movement from 100 to 1000 scrambles is up to 1.28.
Pinning Z to ±0.1 needs of order 10⁴ scrambles.

So the honest form of the headline is **Z ≈ −18 ± 1.5**, and a p-value of
10⁻⁶⁹ is a precision the estimate cannot carry, since the exponent is
quadratic in Z.

**One labelling error, concrete.** `build_primes_up_to(N_max)` sieves to the
*value* N_max; it does not take the first N primes. So the row labelled
"25,000 primes" used **2,762** primes. The original's own comment two lines
below the code assumes the count reading, so that file contradicts itself.

**What holds regardless.** Every cell, every seed, both nulls: |B| at the
true zeros is strongly below |B| at random t. And the collapse/recovery
story reproduces — N=1000 gives −1.14 on the high-zero window against a
published −1.33 that sits inside our seed spread, recovering to −13.79 at
N=5000. The phenomenon is robust; the quoted numbers are one draw from a
distribution about 1.5 σ wide.

No outcome marked.

---

## 2026-08-17 — Entry 21 — O22: the Beat is not Connes' object; the weighting is not the gap
type: run
refs: 19, 20

Connes' Weil local term (arXiv:2602.04022 §4.1 eq. 9) is
W_p(f) = (log p)·Σ_{m≥1} p^(−m/2)[f(p^m)+f(p^(−m))]. The Prime Beat is the
m = 1 term with the log p weight and the prime powers dropped. This tests
whether restoring them closes the gap.

**Script.** `O22_weighted_beat.py`, 53535 B, sha256
`a20921e8eeb6123901d1709de10b4012e477e499da6452b283eb6233023d5ffe`. Three
variants on identical primes and grid: V0 plain, V1 with log p, V2 the full
von Mangoldt form. Minima refined by golden section to 1e−12 so the grid
step is not the floor.

**Headline, at Connes' own window {2,3,5,7,11,13}:**

```text
Connes (variational, T=1600)   2.18784e−55
V1 log p weighted              7.62e−02      ratio 3.5e+53
V2 von Mangoldt                1.07e−01      ratio 4.9e+53
V0 plain Beat                  1.10e−01      ratio 5.0e+53
```

Restoring the weight moves the Beat by a factor of ~1.4. Connes' construction
is **10⁵³** better at the identical prime set. So essentially none of his
accuracy comes from the form of the local term; it comes from extremising the
quadratic form and taking the Mellin transform.

**The Beat and Connes' minimiser are therefore not two views of one
computation.** The bridge coordinate (entry 19) puts them on one axis; it does
not make them one object.

**Gate A FAILED, and the failure is a reader fault, not a data fault.** At
4000 primes V0 locates γ₁ to 0.0012 but its nearest local minimum to γ₂ is
0.131 away and to γ₃ is 0.072 — both outside the 0.05 tolerance, while the
December surface plainly shows three canyons. The cause: |B(t)| carries 101
local minima in t ∈ [10,50] at that prime count, mean spacing ~0.4. The
canyons are envelope features, not individual minima, and "nearest local
minimum to a given zero" reads jitter. The median sits at 0.04–0.07 whatever
the variant or prime count — 0.1067 at 10 primes, 0.0459 at 25,000, a 2500×
increase in primes buying 2.3×. Sixth reader in this project built around
assumptions the object does not have.

Consequently the V0/V1/V2 comparison at the 0.1 scale is not informative and
the log p result is recorded as inconclusive. The 10⁵³ headline survives
because it is 53 orders clear of the reader's resolution.

No outcome marked.

---

## 2026-08-17 — Entry 20 — O21: the archimedean cutoff has a validity window with two failure modes
type: run
refs: 19

O20 (entry 19) swept the prime cutoff at fixed T = 400 without evidence that
T was the right place to stand. At c=13, N=100, dps=150 the same package gave
λ₁ = 2.0770e−59 at T=400 and 2.8655e−59 at T=800 — a 27.5% move, with the
first-zero error getting *worse*. A converged truncation should be
insensitive to doubling T. This sweeps T to find where it settles.

**Script.** `O21_archimedean_convergence.py`, 77151 B, sha256
`60e938985e8025ab6831143c33cec96df1ccdbe90fd8ff2e123641bcdea5fcab`.
Checkpoints after every point via write-to-temp-then-atomic-rename, so an
interrupted run leaves a valid JSON. That mattered — the machine lost power
the following morning; the run had completed at 23:50 and nothing was lost.

**Phase 1, c = 13, N = 100, dps = 150:**

```text
T       λ₁                first-zero error
100     −2.478            —
200     −2.064            —
400      2.07696e−59      1.45495e−55
800      2.86545e−59      2.00546e−55
1600     3.12695e−59      2.18784e−55
3200    −5.50633e−04      3.62952e−04
```

**Two different failures bracket three good points.** Below the window λ₁ is
negative and order 1 — the archimedean integral is truncated so early that
W_R has not become positive. Above it λ₁ goes negative at order 1e−4 — that
one is precision: at dps=150 the cancellation needed to resolve a quantity
near 1e−59 exceeds the digits available.

**dps = 300 confirms the upper edge is numerical.** T = 3200 gives
3.38754e−59 at 300 digits where it broke at 150; T = 6400 then breaks. So
doubling the precision buys exactly one more doubling of T and the window
slides rather than widening. T = 800 and T = 1600 reproduce their dps=150
values exactly, so 150 digits was adequate inside the window.

**λ₁ has NOT converged.** On the three clean dps=300 points the change per
doubling is **+9.1% then +8.3%** — barely shrinking. An earlier extrapolation
in conversation to ~3.24e−59 used the T=400 point, which sits at the low edge
of its own window, and is withdrawn. From these points no convergence rate is
determinable.

**What survives is the rate, not the level.** Entry 19's 28-decimals-per-unit-
depth law is identical at T=400 and T=1600 (endpoint slopes −27.93 and −27.90)
although λ₁ differs by 50% between them. The c-curve's shape is robust to T;
its absolute values are not converged and should not be quoted as if they were.

**Design fault, recorded.** The settle tolerance was 1e−3, unreachable inside
a window three doublings wide when the per-doubling change is ~8%. Worse, the
fallback when nothing settles was "use the largest T that completed" — which
is the broken one. Phase 2 therefore ran the whole five-cutoff sweep at a
numerically dead parameter, twice (once overnight, once until killed at
T=6400). The fallback should have been the largest T producing a physically
sensible result. Both runs' phase 2 output is void.

No outcome marked.

---

## 2026-08-17 — Entry 19 — O19/O20: the bridge coordinate, and Connes' open question measured
type: run
refs: 17

**The source.** A. Connes, "The Riemann Hypothesis: Past, Present and a Letter
Through Time", arXiv:2602.04022v1, 3 Feb 2026. He extremises the truncated
Weil quadratic form QW_λ on test functions supported in [λ⁻¹, λ] and reads
zeros off the Mellin transform of the minimising eigenvector. Theorem 6.1
(joint with W. van Suijlekom) proves those zeros lie on the critical line
**provided** the smallest eigenvalue is simple, isolated and has an even
eigenfunction. Using only primes ≤ 13 he reports first-50-zero errors from
2.60179e−55 to 2.09081e−2. §5 states the open question verbatim:

```text
"What we do not know is that, when we increase the upper limit, which was
 x = 13 here, the corresponding set of zeros will converge towards the zeros
 of zeta. This is something which at this point is not proved."
```

and §6.6 names the missing hypothesis:

```text
"one needs to show that the smallest eigenvalue of the Weil quadratic form
 QW_lambda is simple with even eigenvector"
```

Relevant here: Weil positivity involves only finitely many primes at a time
(§4.1), and §6.3 routes the whole approximation through prolate spheroidal
wave functions — Slepian, Pollak and Landau — whose motivating question is
Shannon's, *to what extent can band-limited functions also be time-limited*.
That is the same time–frequency limitation entries 11 and 16 hit as aliasing.

**THE BRIDGE COORDINATE.** A table cell at depth d touches π over the exponent
window [r−d−1, r], a value window of ratio 2^(d+1). Connes' [λ⁻¹, λ] has ratio
λ². Equating:

```text
lambda^2 = 2^(d+1)        ->        lambda = 2^((d+1)/2)
```

Matching by ratio is a choice — it is the only scale-invariant match available
— and nothing else is tuned. Three things then land without adjustment, since
a prime p enters QW_λ only when p ≤ λ:

```text
cell     d      lambda    primes in window
(2,1)    1       2.00     {2}
(4,1)    1       2.00     {2}
(8,3)    3       4.00     {2,3}
(20,6)   6      11.31     {2,3,5,7,11}
Connes   6.40   13.00     {2,3,5,7,11,13}
```

(8,3) lands at exactly λ = 4, whose window holds exactly {2,3} — and the
workbook's own reason for that zero is the mod-6 lattice, which *is* {2,3}.
(20,6) sits one prime short of the window Connes computes in. And the zero
taxonomy reads off as a prime count: one prime, two primes, five primes.

**O19** draws this. `O19_bridge_figure.py`, matplotlib 3.11.1 (installed
today, unpinned, along with nine transitive deps). Output
`results/bridge_connes_table.png`. The 50 Connes differences are transcribed
verbatim in the source with the citation and a note that he states them as
upper bounds and that the tail is non-monotone as printed.

**O20** measures his open question. `O20_connes_cutoff_sweep.py`, 47500 B,
sha256 `0a6513628eb9ebbd5c34a60bc4435a05a49f94c0becc94d0cc49242cc3434efb`.
It calls `connes_cvs` 0.3.1 — the same package O8 uses — whose parameter `c`
is his λ. At the converged-window T = 1600, N = 100, dps = 150:

```text
c     primes   d        first-zero error   gap ratio λ₂/λ₁
13      6      6.401    2.18784e−55        3.96e7
17      7      7.175    1.95855e−76        1.37e8
19      8      7.496    1.33695e−86        1.64e8
23      9      8.047    6.42686e−103       1.34e8
29     10      8.716    5.49291e−120       1.13e8
```

Strictly decreasing, **65 orders of magnitude**, all 25 zero records
converged with gamma_detected matching gamma_true to all 25 printed digits.

**The law.** log₁₀(error) against depth d has endpoint slope **−27.90**;
consecutive slopes −27.2, −31.7, −29.6, −25.5. **Each unit of depth buys about
28 decimal places on the first zero**, constant to ±11% over the range. That
is a description of this range, not a proven rate. Equivalently error ~
c^(−190). Connes' §6.4 rate for a related quantity is exponential-of-
exponential in L = 2 log λ; over this range a power law in c is what appears.

**The §6.6 hypothesis holds with margin.** The gap ratio never falls below
3.96e7 and shows no drift toward 1. `connes_cvs` exposes no accessor for the
second eigenvalue, so this replicates the package's own V_even projector and
calls mp.eigsy on the same matrix; the replication reproduces the package's
λ₁ exactly at every cutoff. It is a replication, not an API.

**Caveats.** Five points. The rate's ±11% spread means the 28-decimal figure
describes rather than predicts. This measures the *first zero's* error against
cutoff; his open question is that the whole zero **set** converges, which is
stronger. And the absolute values are not converged in T — see entry 20.

Our c=13 first-zero error is 2.18784e−55 against Connes' stated upper bound
2.60179e−55. Consistent: a measurement below a bound.

No outcome marked.

---

## 2026-08-16 — Entry 17 — The depth transfer function, base-2 extremality, and the minimal form of (20,6)
type: result-triage
refs: 12, 13

Analytical results established alongside entries 14–16. No new script; these
are consequences of the construction, checked against data already on disk.

**The transfer function.** Depth is time and Δ_b is the evolution operator.
On a mode b^(ρr) with ρ = σ + iγ:

```text
Δ_b[b^(ρr)] = b^(ρr) · (1 − b^(−ρ))        gain per depth = |1 − b^(−ρ)|
```

That one expression accounts for every amplification number in this project.
The trend is ρ = 1, gain |1 − 1/2| = 0.5 in base 2. The first zero is
ρ = 1/2 + iγ₁, gain |1 − 2^(−1/2)e^(−iγ₁ln2)| = **1.676**. Ratio of
oscillation to trend per depth = 1.676/0.5 = **3.35**, so ~1,400× by depth 6
and ~4,700× by depth 7. A mode grows under depth iff

```text
b^(−σ) > 2 cos(γ ln b)
```

**Correction to an earlier figure.** An amplification of 4.74 per depth and
~11,300× at depth 6 was stated in conversation before this was derived
properly; it used the wrong multiplier. The correct values are 3.35 and
~1,400.

**Base 2 is extremal, and this is why the zeros are there.** Differencing
multiplies the smooth term by (b−1)/b per depth: 1/2 for base 2, 2/3 for
base 3, 8/9 for base 9. **(b−1)/b is minimised at b = 2 over every integer
base.** At depth 6 that compounds to 1/64 against base 3's 1/11.4. Checked
against the table: N(20) = 38635, divided by 64 = 604, and the observed
neighbours of the zero are 623 and −343.

**But that explanation is insufficient, and the triadic table shows why.**
Julian supplied `triadic_difference_table_32.csv` (r = 1…32, d = 1…31,
built with 2 and 3 excluded as lattice rather than counted as primes).
Confirmed: **no exact zero in any delta column.** The single 0 is A_count at
r = 1, which is the construction — (1,3] holds only 2 and 3 — not a
cancellation. But the near-misses are:

```text
(3, 2)  = 1
(5, 4)  = 1
(11,10) = 2
(8, 7)  = 9
(10, 9) = 9
```

Base 3 reaches **1**, twice. Exact zero was arithmetically available and did
not occur. So the magnitude argument does not separate the bases, and the
base-2 zeros are harder to account for rather than easier. Recorded as an
open discrepancy, not resolved.

**The minimal form of the deep zero.** N(r) is already the first difference
of π at powers of two, so the d-th difference of N is the (d+1)-th
difference of π. Cell (20,6) is therefore:

```text
Δ⁷π(2ⁿ) at n = 20
= π(2²⁰) − 7π(2¹⁹) + 21π(2¹⁸) − 35π(2¹⁷) + 35π(2¹⁶) − 21π(2¹⁵) + 7π(2¹⁴) − π(2¹³)
= 0
```

**The seventh finite difference of π(2ⁿ) vanishes at n = 20.** Eight values
of π, one line, no table and no composite side required. This is the form to
state and the form to search for prior art against — π(2ⁿ) is OEIS A007053.

Note that the composite balance is *not* a second finding. composite(r,d) =
2^(r−d−1) − prime(r,d) holds at every cell (entry 12, 1953 cells, zero
mismatches), so "the zero balances the composites at 8192" is the identity
restated and would hold for any sequence in that column. The whole content
is the vanishing.

**Method note, Julian's correction, recorded because it was right.** A
probability argument was offered in conversation — that a zero among cells
of local scale ~500 is roughly a 1-in-500 event, so the observed count is
consistent with chance. That argument is invalid. The cells are not
independent draws; cell(r,d) = Σ(−1)^k C(d,k)N(r−k) is a determined binomial
combination, and (20,6) is an exact identity across seven consecutive
counts, not a hit in a lottery. Asking "how probable is that" imports a null
model the object does not have.

**Why the construction is undocumented.** Differencing a geometrically
growing sequence is normally a null operation — it rescales by (b−1)^d and
returns nothing — so nothing in standard practice points at taking the
seventh difference of a dyadic prime count. The transfer function above is
what makes it non-trivial: the smooth part is geometric and dies, the
oscillatory part is half-geometric and survives. Separately, π(2ⁿ) far
enough to matter is a recent computational capability; reaching r = 62 the
way entry 12 did needs primecount.

**Prime Beat definition, for the record.** B_N(t) = |Σ_{p≤N} p^(−1/2)
sin(t ln p)| — the imaginary part, not the modulus of the complex sum. This
resolves an objection raised in conversation: |Σ p^(−s)| tracks |log ζ| and
diverges at zeros, so canyons would be wrong for it. The imaginary part
tracks arg ζ(1/2+it), a different object. The objection was to something the
definition does not do.

No outcome marked.

---

## 2026-08-16 — Entry 16 — Joint multiplicative ladder: the zeros are recoverable from integer bases jointly
type: run
refs: 15, 17

Entries 14–15 detected zeros on a ratio-1.1 ladder and returned NULL on the
dyadic one. This tests whether integer bases are blind **jointly**. The
sampling sets {2^r} and {3^r} give Nyquist π/log2 = 4.5324 and π/log3 =
2.8596, both far below γ₁ = 14.134725. But log2/log3 is irrational, so the
multiplicative semigroup {2^m 3^n} is dense in log-space (Furstenberg) and
irregularly spaced — and irregular sampling is not bound by the uniform-rate
limit.

**Script.** `O18_joint_multiplicative_ladder.py`, 64048 B, sha256
`54056d086df14150940747375bff994413dac1e5d86a7f49f569bd72446bce0f`, matching
`params.code_version` in every payload. Machinery reused verbatim from O17.
Five ladders over the same x range, same pipeline, same Riemann-R smooth
model: L2 = x₀·2^m, L3 = x₀·3^n, L23 = x₀·2^m3^n, L235 = x₀·2^m3^n5^k, and
L_irr = a random-gap ladder with L23's rung count and endpoints.

**Result at x₀ = 2 — pre-registered outcome H-JOINT:**

```text
ladder   rungs   argmax γ   P/med    verdict
L2         27      23.36     4.78     NULL
L3         17       2.86     3.01     NULL
L23       237      20.97     6.95     DETECT   (0.052 from γ₂ = 21.022040)
L235     1058      30.36    16.37     DETECT   (0.065 from γ₄ = 30.424876)
L_irr     237      30.24     4.14     NULL
```

Neither integer base alone detects. Their joint orbit does. The random-gap
control with identical rung count and endpoints does not.

**At x₀ = 1000 the headline is H-NONE**, with L23 at 108 rungs instead of
237. Starting at 1000 discards the dense low end of the semigroup. Both runs
were pre-specified and both are reported; the difference is rung count, not
structure. Note also that at x₀ = 1000 the three-generator ladder L235
returns DETECT while L23 returns NULL — an outcome none of the three
pre-registered hypotheses covers, since they were stated only over L2/L3/L23.

**The alias comb, measured directly.** L2's peak table at x₀ = 1000 shows
**eight peaks at identical height** — 3.5298, agreeing to five decimals —
spaced **9.06** apart, which is 2π/log 2. The dyadic ladder is not blind to
the zeros; it contains them smeared into a comb of indistinguishable images
at its own sampling rate. Corroborated by the permutation control: L2's
P_max/median and its value at γ₁ both sit at the **100th percentile** of 200
surrogates. The information is present and the true frequency is
unidentifiable from base 2 alone. That is what makes the joint orbit work —
base 3's comb has different teeth.

**Controls.** C1, 200 phase-randomised surrogates per ladder, seed 2026: at
x₀ = 1000, L2, L23 and L235 all exceed their own 95th percentile on both
statistics; L3 and L_irr do not. C2, the random-gap ladder: NULL at x₀ = 2,
but at x₀ = 1000 its value at γ₁ sits at the 99.5th percentile of its own
surrogates, so "irregular sampling helps" is not cleanly separated from
"multiplicative structure helps" at that setting.

**Two defects in the design, both mine.** The band rule and the surrogate
test disagree at x₀ = 1000 — L23 reads NULL by the band rule (argmax 31.35,
0.93 from γ₄, outside the 0.6 band) while sitting at the 100th percentile
against surrogates. The surrogate test is the better instrument and should
have been the pre-registered criterion. And L_irr contains a block with
**zero primes**, so its residual is pathological at that rung and it is not
a clean control.

**Gates.** A: exact tiling, all five ladders, both runs, difference 0. B: at
--x0 2, L2 reproduces N(r) from `pi2n_cache.json` for r = 2…27, 0 mismatches
(cache read-only, mtime unchanged). C: |R(10⁶) − π(10⁶)| = 29.399429 against
|li − π| = 129.549. Both default runs hash-identical with `generated_utc`
stripped.

No outcome marked.

---

## 2026-08-16 — Entry 15 — O17 smooth model corrected to Riemann R; low-end cutoff scan
type: instrument-fix
refs: 14

Entry 14's residual subtracted li. That model is incomplete: π(x) is
approximated by R(x) = Σ μ(n)/n · li(x^(1/n)) = li(x) − ½li(√x) − …, and the
dropped ½li(√x) counts the prime squares. It grows like x^(1/2) — the same
exponent the residual envelope is trying to measure — so it contaminates
exactly the quantity of interest. Raised by the instance working on the
addendum series; verified here.

**Change.** `--smooth {li,R}`, default **R**, via `mpmath.riemannr` with a
Möbius-sum fallback recorded in `params.riemannr_impl`. A diagnostic D_j =
(li-difference) − (R-difference) and its normalised form D_j/√x are computed
and stored every run regardless of the flag. New Gate D compares R and li
against π at 10⁶.

**The correction is the size predicted, and the arithmetic closes exactly.**
D_j/√x has mean 0.0045997 across the ladder, against the closed form
(√r − 1)/log x running 0.0070658 at the first rung to 0.0026064 at the last.
And:

```text
mean(ehat) under li   = −0.004378057
mean(D_j/√x)          = +0.004599722
                        ─────────────
predicted mean under R = +0.000221665
measured mean under R  = +0.000221665
```

Five decimals. The offset in entry 14's residual was the prime powers.
Gate D: |R(10⁶) − 78498| = 29.399429 against |li(10⁶) − 78498| = 129.549.

**Effect on the detection — background down, signal flat.** P/median rose at
all three zeros (γ₁ 5.196 → 5.372, γ₂ 4.470 → 4.621, γ₃ 6.446 → 6.664), but
P_max itself went 0.6790606586 → 0.6790610792, unchanged to seven figures.
The entire gain is median(P) falling from 0.10517 to 0.10173. Removing a
smooth contaminant lowered the background; it did not add signal. That is
the correct behaviour and should be stated that way rather than as "the
peaks strengthened."

Pre-registered P1–P4 all HELD. P2 held only nominally: the θ crossing moved
from 0.413225 to 0.413271, +4.6e−5. The envelope exponent did **not** move
toward 0.5, where the addendum-series α went 0.45 → 0.4951 → 0.4987 after
the same correction. The two instruments do not agree on this number.

**Second change — cutoff scan and a text fix.** The READ THE RESULT block
still printed "L_j is an mpmath li difference" under `--smooth R`; fixed,
text only. Added `--theta-cutoffs` (0, 1e4, 1e5, 1e6, 1e7), a finer θ grid
(0.20…0.80 step 0.02, with the original five retained as
`theta_scan_legacy5`), and a restricted projection per cutoff. Motivation:
the ladder starts at x₀ = 1000 where a block holds ~13 primes, so the low end
is discreteness rather than asymptotics.

```text
cutoff      0      1e4      1e5      1e6      1e7
n blocks  125      100       76       52       28
crossing 0.404    0.417    0.472    0.462    0.381
```

Pre-registered verdict **ERRATIC** — not monotone, total change −0.0224. It
rises as the discreteness-dominated low end comes off, then falls when the
estimator runs out of dynamic range: at cutoff 1e7 the span is 2.57 in log x
so the two RMS halves sit 1.29 apart, and that separation is the denominator
of the exponent.

**And trimming costs the detection.** DETECT survives at cutoffs 0 and 1e4,
then dies — span shortens, the band half-width max(0.6, resolution) widens
past the peak separation, and the zeros dissolve:

```text
cutoff    span   resolution   band    P_max/med   verdict
0        11.82     0.532      0.600     6.68      DETECT
1e4       9.44     0.666      0.666     6.15      DETECT
1e5       7.15     0.879      0.879     4.55      NULL
1e6       4.86     1.293      1.293     3.04      NULL
1e7       2.57     2.442      2.442     3.58      NULL
```

Span buys detection. The clean-exponent and detection goals conflict on this
ladder, and the fix is to extend the top rather than trim the bottom.

**Comparability of prior results.** The li run is preserved at
`results/O17_disjoint_block_residual_li.json` (+ `_li.log`, `_li_run2.*`) and
the `--smooth li` path reproduces it bit-identically — 125 rows, 875 fields,
worst relative error 0.0. The text fix moved nothing: 561 fields compared
against the pre-fix R run, 0 differing, exact bit-identity. Final script
sha256 `4f13987ab096f8a66f7f23d86e935fd918b0adaad1fedd61a8fc75250d6608bf`,
matching `code_version`. Backups at `.bak` (pre-R) and `.bak2` (pre-cutoff).
The stale R `_run2` pair was overwritten; its `_run1` pair is preserved and
the payloads were identical.

No outcome marked.

---

## 2026-08-16 — Entry 14 — Disjoint value-interval blocks: first detection of γ₁, γ₂, γ₃
type: run
refs: 8

O12–O15 all summed over `primes[N:2N]`, indexed by prime **index**. Two
consequences made them blind. Consecutive rungs overlapped — at ratio 1.1
they shared ~90% of their primes — so 110 rungs carried ~16 blocks' worth of
independent data. And indexing by prime index fixes the count per block by
construction, so the count carries no fluctuation at all; the fluctuation
lives in the values.

This tiles **value** space with disjoint geometric intervals, which is the
fine-grained analogue of the table's own (2^(r−1), 2^r]:

```text
x_j = x₀·r^j     c_j = π(x_{j+1}) − π(x_j)     L_j = li(x_{j+1}) − li(x_j)
e_j = c_j − L_j                    ehat_j = e_j/√x_j
P(γ) = |Σ_j w_j · ehat_j · exp(−iγ log x_j)|      (Hann window)
```

Every block is independent, and the count fluctuates because the interval is
fixed in value space. e_j is CONTEXT.md's own core quantity.

**Script.** `O17_disjoint_block_residual.py`, first version 46776 B, sha256
`a63d990e173278bc8b238ddc9714454a6da5517fa1be49aea8dc60c15acea2c3`. Defaults
x₀ = 1000, ratio 1.1, xmax 1.5×10⁸ → 8,444,396 primes, 126 rungs / 125
blocks, log-x span 11.818, frequency resolution 0.5316, band half-width
max(0.6, resolution) = 0.600.

**Result — DETECT. The top three peaks are the first three zeros:**

```text
γ = 24.98   P/med 6.46   γ₃ = 25.010858   off by 0.031
γ = 14.08   P/med 5.23   γ₁ = 14.134725   off by 0.055
γ = 20.97   P/med 4.50   γ₂ = 21.022040   off by 0.052
```

All three land inside a single resolution element of their true heights. The
γ grid runs 0→40 at step 0.01 and the zeros were marked after the fact.

**The dyadic control is the load-bearing part.** Run on the same primes with
`--x0 2 --ratio 2.0`, the ladder becomes the table's own, Nyquist drops to
4.5324, and the verdict is **NULL**. Same data, same code, same residual:
fine sampling sees three zeros, coarse sampling sees none. That converts the
aliasing diagnosis from an argument into a measurement, and it explains
O12–O15's nulls retroactively.

**Alias pairs check out.** Peaks 4 and 5 have near-identical heights at
γ = 28.27 and 37.65; those sum to 65.92 = 2π/log(1.1), the sampling rate. So
peak 4 is peak 5's alias, and γ₆ = 37.586 sits above Nyquist and appears at
both. Same for peaks 7 and 8 (35.75 + 30.18 = 65.93).

**Gates.** A: Σ_j c_j = π(x_last) − π(x₀), difference 0. B: the dyadic run
reproduces N(r) from `pi2n_cache.json` for 26 regimes, 0 mismatches. C:
li(10⁶) = 78627.549159 against π(10⁶) = 78498. Both runs hash-identical.

**One number that is not 1/2.** The θ scan crosses ratio 1 between θ = 0.375
(1.214) and θ = 0.500 (0.514), putting the residual envelope near 0.41 rather
than at the half-power. Flagged, not explained. See entry 15.

**Scope.** Recovering γ₁, γ₂, γ₃ from the prime-count residual confirms the
explicit formula, which is a theorem — the zeros were always there. What is
new here is an instrument in this tree that can see them, after four that
could not.

No outcome marked.

---

## 2026-08-16 — Entry 13 — The (3,2) composite zero is the r=2,3 balance point, and it is dual to (2,1)
type: result-triage
refs: 12

**Julian's observation**, recorded here because it is his and because it
explains the one asymmetry entry 12 found. At r = 3 the prime and
composite difference tables read the same values — 2 at depth 0, 1 at
depth 1 — and the composite table's only zero sits at (3,2).

**Why the tables agree there.** The counts themselves agree. The
interval (4, 8] holds primes {5, 7} and composites {6, 8} — two each.
The interval (2, 4] holds {3} and {4} — one each. Those are the **only
two regimes where primes equal composites**. From r = 4 on it is 2
against 6 and composites dominate permanently. So both tables start from
identical values at r = 2 and r = 3.

**Why they part at depth 2, and what causes the composite zero.** The
split comes from one of the four prime zeros:

```text
prime(2,1)      = 0        <- one of the four
composite(2,1)  = 1
prime(3,2)      = 1 - 0 = 1
composite(3,2)  = 1 - 1 = 0
```

The composite zero at (3,2) is caused by the prime zero at (2,1).

**The duality is exact, and it is the identity restated.** Since
composite(r,d) = 2^(r−d−1) − prime(r,d) at every cell (entry 12, 1953
cells, zero mismatches), a composite zero means prime(r,d) = 2^(r−d−1),
exactly as a prime zero means composite(r,d) = 2^(r−d−1). **Each
table's zeros are the other table hitting that power of two.**

At (3,2) the target is 2^0 = 1, the smallest it can be. That is why it
is the only composite zero out to r = 62: for larger r − d the target
grows exponentially while the prime differences do not track it. In the
workbook's own taxonomy — trivial by membership, trivial by lattice,
trivial in neither sense — this is a third species: **trivial by
smallness of the target.**

No outcome marked.

---

## 2026-08-16 — Entry 12 — Centered (skew-adjoint) difference table has no exact zeros
type: run
refs: 11

O1 proved Δ = S − I cannot be self-adjoint under any positive diagonal
weight, the obstruction being one-sidedness (D[i,i+1] = +1 while
D[i+1,i] = 0). O8 measured that the Connes–van Suijlekom Weil form does
not rescue it either — failure 0.99844421 against a random baseline of
0.85234065 and a control of 0.038227574. One-sidedness is removable:
the centered difference (S − S⁻¹)/2 is skew-adjoint, so i times it is
Hermitian with real spectrum. This tests what that repair costs.

**Script.** `O16_centered_difference_table.py`, 39753 B, sha256
`394b7b7a3879c02f922dded08b84b7e68dd1d4626648ab6aa5a3a967ba6f0e9a`,
matching `params.code_version` in both payloads. Exact Python integer
arithmetic throughout — no numpy, no float anywhere in the tables.
Unnormalised centered differences (the ½ does not move zeros).

**Range.** Reads `pi2n_cache.json`, verified as n = 0…62, 63 entries,
π(2^62) = 109932807585469973. Python ints have no 15-significant-digit
ceiling, so this reaches r = 62 exactly where the xlsx stops at r = 50
for exactly that reason. Centered support is r = d+1 … 62−d, max depth
30, 992 cells.

**Gates.** Gate A: the backward table reproduces
`files (2)/unit_weighted_dyadic_table.csv` and
`composite_unit_dyadic_table.csv` exactly — 247 cells each, zero
mismatches. Gate B: backward prime zeros within r ≤ 50, d ≤ 30 are
exactly {(2,1), (4,1), (8,3), (20,6)}, none missing, none unexpected.

**Result — pre-registered band EMPTY.** The centered prime table has no
exact zeros anywhere in its support; nor does the centered composite
table. Bands were SAME / SUPERSET / SUBSET / DISJOINT / EMPTY.

**The mechanism, and it is clean.** A backward zero at depth d is an
*adjacent* repeat at depth d−1: B(r,d) = 0 ⟺ B(r,d−1) = B(r−1,d−1). A
centered zero is a **gap-2** repeat: C(r,d) = 0 ⟺ C(r+1,d−1) =
C(r−1,d−1). The prime table has four adjacent repeats and **zero**
gap-2 repeats at any depth. So the zeros are a feature of
one-sidedness, and the repair that would make the operator Hermitian
destroys them.

**Two further exact results.** The four backward zeros are the only ones
out to **r ≤ 62, d ≤ 61** — verified computationally, where the xlsx
Read me asserts "no others anywhere to r=60, depth 54" on the papers'
authority. And the centered identity holds at all 992 cells:
composite_C(r,d) = 3^d · 2^(r−1−d) − prime_C(r,d), the 3^d arising
because (S − S⁻¹) applied to 2^(r−1) gives 2^r − 2^(r−2) = 3·2^(r−2).

The backward *composite* table has one zero the prime table does not,
at (3,2). See entry 13.

Both runs hash-identical with `generated_utc` stripped. Nothing that
contradicted the docstring.

No outcome marked.

---

## 2026-08-16 — Entry 11 — Fine-ladder residual: aliasing fixed, still no zero detected
type: run
refs: 8

Entry 8's ladder was dyadic, so log N stepped by log 2 = 0.6931 and the
sampling Nyquist was π/log2 = **4.5324**. Every zero height is far above
that — γ₁ = 14.134725 — so the oscillations aliased and could not have
been resolved on any dyadic ladder, at any depth, however many rungs.
That is a property of the sampling, and it explains why entry 8's sign
runs came out at 1–2 rungs regardless of depth.

**Script.** `O15_fine_ladder_residual.py`, 47230 B, sha256
`d5799bb38b56827b3099fecfee58cbd2246d43d4880722295d04121ff19a39c1`.
Same object as O14 — Δ_N over primes[N:2N], g = |Δ_N|/N^(1−σ) — sampled
on a geometric ladder of ratio 1.1 instead of 2. 110 rungs, 125 →
4,061,745, 8,444,396 primes. Nyquist π/log(1.1) = **32.96**, clearing
γ₁, γ₂, γ₃.

**Gates.** Gate A exact (σ=0, t=0 gives g = 1.0 and all deeper
differences exactly 0.0, 110/110 rungs). Gate B: invoked with
`--ratio 2.0` the ladder is dyadic and reproduces
`results/O14_residual_depth_ext.json` — 96 shared cells, worst relative
error **0.0**.

**Result — DETECT 0 of 54.** Projection of the flattened residual onto
e^(−iγ log N) over a Hann window: NULL 41, WEAK 13, DETECT 0. At the
headline case σ = 0.5, t = 0 the global maximum sits at γ ≈ 23.00 at
every depth from 3 on — 1.98 from γ₂ and 2.01 from γ₃, outside the band
in both directions, and close to their midpoint.

**θ_rms never settles**, climbing monotonically with depth: 0.050,
0.162, 0.406, 0.614, 0.641, 0.655, 0.681, 0.692, 0.713, still rising at
depth 8. That is the signature of differencing a *logarithmic* drift —
the d-th difference of B/log N decays like (log N)^−(d+1), which read
as a power law gives an apparent exponent that grows with every depth.

**Why the fix did not help, and this is the load-bearing finding.** The
block is still primes[N : 2N]. At ratio 1.1 consecutive rungs share
[1.1N, 2N] — about 90% of the same primes. 110 rungs therefore carry
roughly 16 blocks' worth of independent data. The limit is the number
of **disjoint** blocks, which on an N → 2N tiling of 8.4M primes is
~16, and has been ~16 since O12 whatever the ladder looked like.
Oversampling interpolates; it does not add information.

Two design faults on the reader side, recorded because they are the
same species as the ones in entries 6 and 8: the projection's frequency
resolution is 0.605, *wider* than the ±0.5 pre-registered band, so the
band was narrower than one resolution element; and 8 of the 54 cells
are the exactly-degenerate σ=0, t=0 series which carries no projection
content and should not have been in the denominator.

The instrument that would change the sample count is a **disjoint**
block — N → rN matching the step, rather than N → 2N. Not built.

Both runs hash-identical with `generated_utc` stripped.

No outcome marked.

---

## 2026-08-15 — Entry 10 — O9 audit page archived into the tree with a superseded notice
type: provenance
refs: 6, 8, 9

Entry 9 flagged `o9_audit.html` as the last scratchpad-only artifact and
the only local copy. It is now in the tree.

```text
O9_audit_20260815.html   28988 B
  sha256 8de47bffecdcab470c5beb3d0c32a78a659d9d66e6b426b8fddea7733e3b4669
```

**What it is.** A rendered summary of the O9 instrument audit, written
before entries 6, 8, and 9 — the three tests on the regression variable,
the per-t crossings, and the first pass at the smoothness null. It was
produced as a handoff document for the instance that wrote O9, which is
why it exists as HTML rather than as a notebook entry. Date in the
filename because it is a dated snapshot, not a living document.

**Preserved verbatim, with a notice.** The body was copied byte-for-byte
— verified by stripping the inserted notice from the copy and confirming
the remainder hashes to the source's
`2e7a08657c5fb293b46951e4cd99e5117675a19d509b2dde0e14b1630cae67c9`. Its
errors are part of the record and were not edited out.

A dated superseded-notice block was inserted after the `<title>` and
before the `<style>`, naming the two claims that later measurement
corrected:

1. Section 04's analyticity argument, in its strong form — that the
   statistic is "not measuring the data" and returns the same value
   regardless. The 91-centre placebo sweep (entry 6, now O13) shows
   max_z does vary, range 1.30. The correct statement is a measured null
   spike between 2.50 and 2.60 with maximum 2.6041, so a threshold of 3
   cannot fire. Ceiling, not analyticity.
2. Section 06's redirect, which was acted on and returned a negative —
   entry 8's a = 1 − σ, additive, no square-root cancellation, σ = 1/2
   unremarkable.

The notice points at entries 6, 8, 9 and at both new instruments, so a
reader who opens the HTML alone is not misled by it.

**Why annotate rather than leave it clean.** An unannotated document in
the tree asserting a claim that has since been measured false is a
hazard, and the artifact URL it was published to is not reachable from
this account. Annotating the copy while leaving the body untouched keeps
both properties: the snapshot is faithful, and it cannot be read as
current.

`find -newermt` confirms this file is the only thing created; the
scratchpad is now empty and the tree copy is the only copy.

No outcome marked.

---

## 2026-08-15 — Entry 9 — Entry 8's instruments promoted into the tree and verified reproducible
type: provenance
refs: 8

Entry 8 recorded two measurements made with scratchpad scripts under
`/private/tmp`, and flagged that nothing in this tree computed them.
That caveat is now superseded: both instruments live at the project
root, both write to `results/`, and both were run twice to prove the
output is deterministic. Type is `provenance` rather than `run` because
the numbers were already recorded in entry 8 — what is new here is
lineage and reproducibility.

**Scripts.**

```text
O12_dyadic_block_ratio.py   30937 B
  sha256 d0f699036f9e4a97552b8dcde23c1b6c0f6578cc77f5af4b40e6da3a87507533
O13_smoothness_null.py      34661 B
  sha256 1be7c40e60370be45852d7edc98f63809eae689b1878b08723c61a44856e329f
```

O12 is the fit-free dyadic ratio instrument; O13 measures the null
distribution of O9's part-3 smoothness statistic and sweeps its
threshold. Numbering: O1–O9 and O11 exist, O10 does not, and the O10 gap
was left unfilled deliberately rather than absorbed by unrelated work
(entry 4's open thread). Both docstrings state this.

**Reproducibility, mechanically checked.** Each script was run twice,
the second time to a `_run2.json`. Both payloads were loaded,
`generated_utc` deleted, re-serialised with `sort_keys=True`, and
hashed:

```text
O12  run1 = run2 = 9b7340c82135af5f4af3677c78d62f75a78224fbac00e4a49cd298c9efaf7e46
O13  run1 = run2 = 75b1879c7a5b029eefe3975a5ccc1469945dfd17e98002bf38a69e6cc22b0f29
```

Identical in both cases. Ten files were created and `find -newermt`
over the tree confirms nothing else was touched.

**`code_version`.** Both payloads carry `params.code_version` = the
sha256 of the script file itself, read at runtime from `__file__`, and
it matches the file hashes above in all four payloads. This addresses
entry 5's open thread — that pre-fix and post-fix O9 results are
indistinguishable because nothing in the envelope identifies the code —
but only for these two new scripts. `schema_version` stays "1" and no
existing script's envelope was touched; extending it to the older
scripts is still pending Julian.

**Gates run inside the scripts, not alongside them.** O12 verifies its
direct block sum against O9's `prime_sum(2N) − prime_sum(N)` at the six
shared rungs. O13 reads its expected values out of
`results/O9_convergence_abscissa_results_fine.json` rather than
hardcoding them, so the gate breaks if that file changes. O13's two
gates both passed at exactly zero error — all 33 `fine_sweep`
`mean_slope` values, and `departure_over_sd` at centre 0.500 computing
2.5521103290988618 against the stored 2.5521103290988618.

**Every entry 8 number reproduced.** 664,579 primes, largest 9,999,991;
12 rungs, 11 ratios, largest prime index 511,999 (7,559,173); σ=0 ADD at
t = 10, 14.5, 20, 30; mean a by σ = 1.007326 / 0.465994 / −0.070381;
verdict counts ADD 4, SQRT 3, OTHER 6, SETTLED-WITH-OUTLIER 4, TRANS 10;
all four outlier exclusions at N=64000. On the O13 side: null mean
2.4495, sd 0.2289, min 1.3040 at centre 1.15, max 2.6041 at centre
0.31, max_z at 0.500 = 2.5521103290988618 rank 11 of 91, T=2.50 fires
59/91, T=2.60 fires 1/91, T=3.00 fires 0/91, and flipping 0.500 requires
T < 2.5521 which also fires 0.30, 0.31, 0.51–0.56, 1.19, 1.20. All 91
centres gave n_inside=9, n_outside=24 with zero exclusions.

**Two corrections to entry 8.** Its claim that the block-sum gate agrees
to "15–16 significant figures" is slightly wide: the measured range is
**14.79 to 16**, with N=125 at 14.79 and N=250 at 14.92. The gate's own
requirement is 10, so it passes either way. And entry 8's log-log
comparison was stated loosely; the precise figures at the top rung
(N=256000, log N = 12.452933) are:

```text
σ = 0.5   observed deviation −0.034006   predicted −σ/log N = −0.040151
σ = 1.0   observed deviation −0.070381   predicted            −0.080302
```

The observed deficit is consistently about 85% of the predicted
correction at both σ, not equal to it. Entry 8 said the mechanism and
magnitude were right; the magnitude is right to within 15%, which is
the accurate statement.

**The band-coincidence flaw is surfaced, not buried.** O12 states in its
docstring, prints in a banner before any table, re-states inline at
every SQRT verdict occurring at σ=0.5, repeats in READ THE RESULT, and
records in `constants.band_coincidence_note` that the ADD and SQRT bands
coincide at σ=0.5 because a = 1−σ also gives 1/2 there, and that σ=0 is
the discriminating row.

**Scratchpad cleared.** Fourteen files deleted after verification
passed. One file was left: `o9_audit.html`, a rendered summary of the
O9 audit, which is still session-scoped and is the only local copy —
if it is wanted it needs a home in the tree.

**Still not under version control.** "Reproducible" here means
reproducible from the script, with the script self-identifying by hash.
It does not mean versioned; entry 1's no-VCS thread is unchanged and
nothing was committed.

No outcome marked.

---

## 2026-08-15 — Entry 8 — Fit-free dyadic ratio test: the block sum is additive, a = 1 − σ
type: result-triage
refs: 3, 5, 6

Two measurements against O9's readability. Both were made with scratchpad
instruments, not with any script in this tree — see the provenance
caveat at the end.

**1. What the z threshold is doing.** Entry 6 measured the null of the
smoothness statistic across 91 window centres but read the result as a
ceiling. Sweeping the threshold shows something sharper — the null is
not a distribution with a tail, it is a spike:

```text
T = 2.50    59 of 91 centres fire   (64.8%)
T = 2.60     1 of 91 centres fire    (1.1%)
T = 3.00     0 of 91                 (0.0%)
```

58 of 91 centres have max_z inside (2.50, 2.60]. Below ~2.55 the test
fires on nearly everything; above ~2.61 on nothing. No value of T makes
it graded. The 95th percentile of the null is 2.5563; the hardcoded 3
sits 0.396 above the observed maximum of 2.6041. Every per-t column
shows the same cliff, and t=50 is nearly degenerate (sd 0.0076).

To call σ=0.500 STRUCTURE requires T < 2.5521, which also fires at ten
other centres — 0.51, 0.52, 0.53, 0.54, 0.55, 0.56 (its own immediate
neighbours) and 0.30, 0.31, 1.19, 1.20 (the sweep edges). **No threshold
isolates 0.5.** That is a stronger negative than entry 6's: the test
cannot be tuned into finding a feature at 1/2 without finding six
adjacent ones.

**2. A fit-free instrument.** Every prior measurement in this project —
the crossing, the decay exponent, max_z — is a least-squares slope on a
log-log plot, and entry 6 plus the ladder work showed they were reading
transients. This one has no fit in it.

For block Δ_N = Σ over primes[N:2N] of p^(−σ)e^(−it log p), define
r_N = |Δ_N|/N and take consecutive-rung ratios ρ = r_2N / r_N. Because
the ladder doubles, ρ **is** the exponent: |Δ_N| ~ N^a gives
ρ = 2^(a−1), so a = 1 + log2(ρ). Landmarks: a=1 (additive) → ρ=1.0000;
a=1/2 (square-root cancellation) → ρ=0.70710678.

Decision rule fixed before the run: SETTLED iff the last three ρ lie
within 0.03 of their mean; then ADD / SQRT by proximity to a landmark,
OTHER if settled elsewhere, TRANS if not settled. One-outlier
interference exclusion allowed, at most one, from the last four.

Setup: pmax = 10⁷, 664,579 primes, largest 9,999,991. Ladder
125·2^k for k=0..11 → 12 rungs, all surviving, 11 ratios; largest prime
index used 511,999 (value 7,559,173). Gate: the direct block sum over
`primes[N:2N]` agrees with O9's `prime_sum(2N) − prime_sum(N)` to 15–16
significant figures at every shared rung.

**Result — a = 1 − σ, with no cancellation anywhere.**

```text
σ = 0.0    a = 0.981, 1.033, 0.990, 1.024              mean  1.007
σ = 0.5    a = 0.434, 0.497, 0.448, 0.485              mean  0.466
σ = 1.0    a = −0.111, −0.043, −0.094, −0.056, −0.049  mean −0.070
```

That is |Δ_N| ~ N · N^(−σ): N terms each of size ~N^(−σ). Counting times
magnitude, nothing else.

Verdict counts over the 27 (σ,t) series: ADD 4, SQRT 3, OTHER 6,
SETTLED-WITH-OUTLIER 4, TRANS 10.

**The decision rule was mis-designed, and it would have produced a false
positive.** The SQRT landmark was set at a = 1/2. But at σ = 0.5 the
additive law 1 − σ *also* gives a = 1/2, so the two hypotheses are
indistinguishable at exactly that σ — the rule was built at the one
point where they coincide. The three series it labelled SQRT are what
no-cancellation predicts there, not evidence of cancellation.

The discriminating row is σ = 0, where additive predicts 1 and
square-root predicts 1/2. It reads **1.007**. Additive, unambiguously.

**Consequences.** There is no square-root cancellation in this object at
these t. σ = 1/2 is not distinguished: a = 1 − σ is a straight line and
1/2 is an ordinary point on it. This is the first statement about 1/2 in
this project made without a fit, a window, or a threshold.

Note that a = 1 − σ is itself a reflection with fixed point σ = 1/2, the
one place where a = σ. The structure is real in the numbers; its origin
here is count-times-size, not the functional equation, and the two
should not be conflated.

**The log-log correction is real and now measured.** The deficit from
a = 1 − σ grows linearly in σ: +0.007, −0.034, −0.070, i.e. ≈ −0.07σ,
against the prediction −σ/log N with log N ≈ 12 at the top rungs
(−0.083σ). Entry 3's mechanism and its magnitude were right. Entry 6
falsified it only as an explanation of the *crossing*, which it was
structurally unable to move; as a correction to the exponent it is
present and the right size.

**What did not settle.** t = 50, 160, 320 are TRANS at every σ, and
t = 80 is TRANS at σ = 0 — still transient at N = 256,000. Any exponent
quoted at large t anywhere in this project is a transient reading.

**Two unexplained items, not chased.** All four one-outlier exclusions
landed on the same rung, N = 64000, and three of the four are t = 40 —
not the random destructive interference the rule was written for. And
the `|Δ| < 1e-8·N` precision flag was mis-specified as an absolute
criterion, so σ = 1 trips it trivially (terms there are ~1/p); nothing
is near the precision floor, the smallest value sits nine orders above
it.

**Provenance caveat.** Both measurements were made with scratchpad
scripts under `/private/tmp/...`, which is session-scoped and will not
survive. Nothing was written to `results/` and no script in this tree
computes any of the above. The spec in this entry is sufficient to
reconstruct both, but the artifacts themselves are not preserved and
this is not a reproducible run in the sense CLAUDE.md § Prereg
discipline requires.

No outcome marked.

---

## 2026-08-15 — Entry 7 — O11 backend resolver: 128-bit reach and threading, staged unrun
type: instrument-fix
refs: 4

Fixes the entry 4 blocker and claims the entry 4 speedup in one change.
Backup at `O11_extend_counts.py.bak` (pre-fix, 13904 B). **Not run** —
Julian is freeing the machine to launch it himself.

**Toolchain change (outside the folder).** `brew install primecount`
→ 8.6 bottled at `/opt/homebrew/bin/primecount`. This is a new system
dependency the bench did not previously have. `libomp` was already
present. Measured on the same call, pi(2^58) = 7357400267843990:

```text
primecountpy 0.2.1 (wheel)        17.9 s     99% CPU
primecount 8.6 CLI --threads 1    16.9 s     89% CPU
primecount 8.6 CLI (all cores)     1.08 s  1532% CPU
```

The wheel's only deficit is threading — single-threaded the two agree
to 6%. It is a delocated binary wheel (meson, `Root-Is-Purelib: false`)
built without multithreading; no `set_num_threads` is exposed and
`OMP_NUM_THREADS` is ignored.

**128-bit reach verified directly, not inferred:**

```text
primecount 9223372036854775808   (2^63) = 216289611853439384   [16.97 s]
primecount 18446744073709551616  (2^64) = 425656284035217743   [25.40 s]
```

These are the two values the old int64 call site could not reach at all.

**The edit.** One call site, `P[n] = int(pc.prime_pi(2 ** n))` →
`P[n] = int(pi_of_2n(n))`, backed by a new `resolve_pi_backend()` that
picks, in order: the `primecount` CLI via subprocess (threaded,
128-bit, located with `shutil.which` rather than a hard-coded path),
then `primecountpy.prime_pi_128` (128-bit, single-threaded), then
`primecountpy.prime_pi` (int64, correct to n ≤ 62).

Resolution happens **once, before the compute loop**, by probing each
candidate with pi(2^10) = 172, and the selected backend is printed in
the pre-run header. Mid-run failures raise and hit the existing
`except Exception` branch rather than silently downgrading a run from
12 cores to 1 partway through. That was the agent's judgment call on an
ambiguous brief and it is the right one — a per-call fallback chain
could not name the backend up front, which is the whole point of
printing it before a multi-hour commitment.

The lazy-import early return was restructured: the script now runs if
*any* backend resolves, and exits with instructions only if none does.
Previously a missing `primecountpy` returned early even with the CLI
available.

SIGINT handling preserved. A Ctrl-C during a `subprocess.run` would
otherwise surface as a child killed by signal → non-zero exit →
"n=N FAILED"; returncode −SIGINT/−SIGTERM is mapped back to a re-raised
`KeyboardInterrupt` so the existing branch fires with its "that value
is discarded" message. `KeyboardInterrupt` is explicitly re-raised in
both the subprocess wrapper and the resolver so it can never be
converted into a backend fallback. No timeout on the subprocess — the
top regimes legitimately take hours.

Deliberately **not** changed: the hard-coded `ratio = 1.587` (measured
1.52, tracked separately), the `--rmax` default of 80, and the
docstring's REQUIREMENTS block, which now understates the options by
omitting `brew install primecount`.

Verified without running: `ast.parse` clean; resolver called directly
on n = 20 returns 82025 and reports "primecount CLI at
/opt/homebrew/bin/primecount (threaded, 128-bit)". Cache untouched at
63 entries, n = 0..62 contiguous, mtime 12:10 against the edit's 12:29.

**Revised projection to r = 76**, from the threaded n=63/64 timings,
measured ratio 1.497 across that step:

```text
ratio 1.50    2.7 h
ratio 1.52    3.1 h      <- entry 4's measured ratio
ratio 1.587   4.9 h
```

Against entry 4's 27–46 h single-threaded, plus the 128-bit penalty
that never had to be paid because the CLI's 128-bit path is the same
threaded code. Two risks not in the number: parallel efficiency already
fell from 1532% at n=58 to ~775% at n=63/64, and primecount's memory
footprint at 2^76 is unmeasured.

Launch command when wanted, from the folder:

```text
./.venv/bin/python O11_extend_counts.py --rmax 76
```

It resumes at n=63; nothing already cached is recomputed. `--budget-hours`
stops it cleanly at any point.

No outcome marked.

---

## 2026-08-15 — Entry 6 — O9 part 3's null distribution has a ceiling below its own threshold
type: result-triage
refs: 3, 5

Entry 3 proposed the log p_N re-run and flagged that no minimum
detectable kink is stated anywhere. Both are now measured. Three tests,
each with outcome bands fixed in advance of the run.

**Test 1 — the log-log rescue is falsified, and structurally.** Ran the
re-run entry 3 asked for (`--xvar prime`, entry 5). Bands: (A) crossing
moves to 1.00 ± 0.02, (B) moves to ~0.93, (C) does not move. The
crossing went from 0.8813531537396102 to 0.8814060700880200 — a shift
of **+5.3e−05**. Outcome (C).

It cannot move, for one line of algebra. The reparametrization is a
constant positive rescaling of every fitted slope:

```text
σ=0.30   0.5406 / 0.6241 = 0.8662
σ=0.50   0.3501 / 0.4043 = 0.8660
σ=1.00  −0.1097 /−0.1268 = 0.8652
σ=1.60  −0.6850 /−0.7911 = 0.8659
```

A positive rescaling cannot move a zero. Equivalently, the crossing is
intercept ÷ coefficient and both are scaled by the same factor:
0.9441/1.0752 = 0.878 and 0.8177/0.9313 = 0.878, identical. Entry 3's
arithmetic — predicted −1.21…−1.12 against observed −1.07, intercept
untouched by log-log — was right, and this is the algebraic reason it
was right.

Residual puzzle: under the corrected variable theory predicts a
coefficient of exactly −1.000; observed is **−0.931**. The
|Δ| ~ N^a · p_N^(−σ) model does not close even with the axis fixed. No
account of the remainder.

**Test 2 — the control is misshapen, not displaced.** Bands: (P)
crossing decreases monotonically with t, (Q) varies non-monotonically,
(R) t-independent, spread < 0.01. Outcome (P), with a spread far larger
than a correction:

```text
t        crossing   intercept   coefficient   r² at σ=0.5
14.5      1.1768      1.1776      −0.9156       0.9796
30.0      1.1264      0.9817      −0.9007       0.9636
50.0      0.7923      1.0347      −1.3089       0.4956
80.0      0.4914      0.5823      −1.1757       0.0004
```

Spread 0.685 in σ. The reported 0.8814 is the crossing of the **mean
slope column**; the mean of the four per-t crossings is 0.8967 — a
different number, because averaging slopes then finding a zero is not
finding zeros then averaging. The two well-fitted columns cross
**above** 1.0, which no proposed mechanism predicts; only the high-t
columns drag the mean down. At t=80, σ=0.5 the regression explains
0.04% of its own variance and is weighted equally in the mean.

Entry 3's "phase cancellation, t-dependent, a separate mechanism" is
confirmed t-dependent. The magnitude is too large for a correction and
the low-t direction is wrong for decoherence.

**Test 3 — the null distribution, which had never been measured.** Slid
the ±0.02 window across 91 centres in [0.30, 1.20], reproducing the real
test's geometry exactly at each centre (33 band points, 9 inside, 24
outside, cubic, dof = n_out − 4). Gate: reproduces the saved
`departure_over_sd` = 2.552110329098862 to 0.000e+00 at centre 0.5.

```text
max over 91 centres   2.6041   (centre 0.31)
min                   1.3040   (centre 1.15)
mean 2.4495    median 2.5244    sd 0.2289
σ = 0.500             2.5521   rank 11/91, 87.9th percentile
```

**The statistic never reaches 3 at any centre.** The threshold cannot
fire on this data, so "smooth through 1/2" was not a falsifiable
outcome. Bands were (X) tightly clustered, (Y) varies but 0.500 below
the 90th percentile, (Z) 0.500 at or above the 90th. Outcome **(Y)** —
it does vary (range 1.30, so it is not purely fit geometry), and 0.500
is unremarkable within it.

0.500 is not even a local maximum: 0.51 → 2.5544, 0.52 → 2.5558,
0.53 → 2.5564. The curve rises smoothly through it. Per-t percentiles
of 0.500 scatter with no pattern — 51.7, 4.4, 22.0, 79.1 — which is the
signature of no feature. Identical rank under `--xvar prime`.

Strongest single reading: the **t=50 column returns 2.4958 to 2.5345
across all 91 centres**, range 0.0387. Flat to 1.5% on a column whose
underlying regression has r² = 0.4956. That column is measuring fit
geometry and nothing else.

Three sharp downward dips — centre 0.34 → 1.5609, 0.74 → 1.3141,
1.15 → 1.3040 — are the only places the statistic responds to anything.
Unexplained; plausibly where |S_2N − S_N| passes near zero and the log
blows up. Not chased, not load-bearing for anything open.

**Consequence.** Part 3's negative is retracted as evidence: true about
the computed curve, uninformative about the hypothesis, because the
test's null distribution tops out below its own threshold. Entry 3's
"the smoothness argument holds" survives exactly as written — a smooth
reparametrization cannot manufacture a kink — but is beside the point,
since this design cannot detect one either. Entry 3's demand for a
minimum detectable kink was the right objection and this is its answer.

Part 1 is unaffected throughout.

Two prerequisites before further O9 reading: weight or drop the t
columns by fit quality instead of an unweighted mean; and extend the
ladder, which is the binding constraint (six rungs capping at N=4000),
not `--pmax` — above ~68000 `--pmax` buys nothing.

No outcome marked.

---

## 2026-08-15 — Entry 5 — O9 instrument fixes and the --xvar flag
type: instrument-fix
refs: 3

Six fixes to `O9_convergence_abscissa.py`, then a seventh change adding
the regression-variable flag entry 3 asked for. Backups at
`O9_convergence_abscissa.py.bak` (pre-fix) and `.bak2` (pre-flag).

**Fixes that do not change any number.** Only one `print` in the file
carried `flush=True`, so under `nohup` a crash lost the buffered tables
— added throughout. `ladder[-1]` was unguarded against an empty ladder,
so any `--pmax` below ~1583 raised IndexError after the sieve ran; now
exits clean. The payload built `vs_chance` as `dg/dr if dr else None`
while the print did a bare `dg/dr`, which would have raised
**after** parts 1–3 completed and **before** `_write_results` — losing
the whole run; now guarded. `params` gained the coarse and fine σ grids,
part 4's σ list, prime truncation, t-grid, draw count and chunk size,
the smoothness window, polynomial degree, sd threshold, and
`precision: "float64"`; the stale `pip install numpy mpmath` line went
(mpmath is never imported).

**Two fixes that do change the number, in opposite directions.** The
window comparison `|σ−0.5| > win` put 0.48 and 0.52 outside the window,
because `0.5−0.48` is 0.020000000000000018 in IEEE double — so the
declared ±0.02 exclusion behaved as ±0.01. Now `> win + 1e-9`, and
n_inside goes 3 → 5. And `resid_sd` used `np.std` (ddof 0) after a
4-parameter cubic fit; now dof = n_outside − 4.

Recomputed exactly from the saved `fine_sweep`, all four combinations on
identical data:

```text
                              n_in  n_out   resid_sd    max_dep    max_z  verdict
V1  old mask + old ddof         3     14   7.4576e−07  1.4890e−06  1.9967  smooth
V2  old mask + new dof          3     14   8.8239e−07  1.4890e−06  1.6875  smooth
V3  new mask + old ddof         5     12   6.4725e−07  2.0674e−06  3.1941  STRUCTURE
V4  new mask + new dof          5     12   7.9271e−07  2.0674e−06  2.6080  smooth
```

V4 reproduces the saved value bit-for-bit, validating the
reconstruction. V1 is the true pre-fix value: **1.997**, same verdict as
now — the fixes cancel and the verdict never flipped. V3 is the only
combination reading STRUCTURE and it never existed in running code.

**`--xvar {count,prime}`**, default `count`. `count` regresses on log N
(the prime count, the ladder index); `prime` on log p_N = log
primes[N−1], the largest prime included at that rung. Threaded through
part 2's coarse loop and part 3's fine sweep; parts 1 and 4 untouched.
Recorded in `params` as `xvar` and `xvar_description`. The default
reproduces the prior mean-slope column bit-for-bit.

**Comparability of prior results.** Part 1 is unaffected by every change
above and remains comparable. Part 2's slopes are unaffected under the
default flag. Part 3's `max_z` is **not** comparable across the fix —
pre-fix and post-fix values differ by construction, and nothing in the
results envelope distinguishes them: `schema_version` stayed "1" and
there is no `code_version` or git sha. A reader can only infer which is
which from `resid_dof` being present and `n_inside` being 5. Flagged,
not fixed — adding a provenance field is a schema change and Julian's
call.

Runs preserved, nothing overwritten: `results/` holds
`O9_convergence_abscissa_results.json` (default grid),
`..._results_default.json` (identical copy), `..._results_fine.json`,
`O9_xvar_count.json`, `O9_xvar_prime.json`, with matching logs.

No outcome marked.

---

## 2026-08-15 — Entry 4 — O11 run to r=62; r≥63 blocked by int64 overflow in the backend
type: run
refs: 1

Requested: extend `pi2n_cache.json` to r = 76. Delivered: r = 62, plus
the reason 76 is not reachable by the script as written.

**Blocker, verified directly (not inferred).** `O11_extend_counts.py`
line 291 calls `pc.prime_pi(2 ** n)`. `primecountpy.prime_pi` is bound
to `int64_t`, so the argument conversion fails for n ≥ 63 before any
computation happens:

```text
2^63: OverflowError: Python int too large to convert to C long [0.000s]
2^64: OverflowError: Python int too large to convert to C long [0.000s]
```

The script's `except Exception` branch catches it, prints
`n=63 FAILED`, breaks, and writes state — so `--rmax 76` would exit
clean in about three minutes having gained exactly n=61 and n=62, with
no error status and a results JSON that looks like a normal run. The
failure is quiet, which is the part worth flagging.

`primecountpy.prime_pi_128` **is present and callable** in the
installed 0.2.1 wheel. Switching the call site for large n is the fix.
Not applied — instrument change, Julian's call, wants its own
`instrument-fix` entry.

**Run record.** `./.venv/bin/python O11_extend_counts.py --rmax 62`,
completed, 2:37.91 wall. Wrote `pi2n_cache.json` (now n = 0..62, 63
entries), `pi2n_cache.json.bak`, `results/O11_extend_counts_timing.json`,
`results/O11_extend_counts_results.json`.

```text
n=61  pi(2^61) =  55890484045084135  [61.68s]
n=62  pi(2^62) = 109932807585469973  [96.07s]
```

Third calibration point measured outside the script, not written to the
timing file: `pi(2^58)` = 7357400267843990 in 17.9s.

**Measured cost ratio.** Least-squares on log2(t) ~ n over n = 58, 61,
62 gives **1.52 per regime**, against the script's hard-coded 1.587 and
the O(x^(2/3)) prediction of 1.587. Only three points; the script's own
`project_cost` had two and would have used the 1.587 default.

**Single-threaded, and not fixable from Python.** The run held 99% CPU
on a 16-logical / 12-performance-core machine. `primecountpy` 0.2.1
exposes no `set_num_threads` / `get_num_threads`, `OMP_NUM_THREADS=16`
changes nothing (17.93s vs 17.88s on the same n=58 call), and no
`primecount` CLI is installed. Upstream primecount is multithreaded by
default, so this wheel appears built without it. That is roughly an
8–10x factor sitting unclaimed.

**Projection to r=76** at the measured 1.52, from n=62 = 96.1s,
64-bit rates:

```text
target   cumulative      SE vs r<=60
r = 72      3.3 h            0.68
r = 74      7.7 h            0.64
r = 76     27.4 h            0.61
r = 80    (~4.5 d)           0.55
```

At the theoretical 1.587 instead, r=76 is 46 h. The 128-bit code path
is typically 1.5–2x slower than the 64-bit one, which is not in these
numbers. Realistic single-threaded range for r=76 is **1.5 to 4 days**.

Cost is dominated by the top: n=76 alone is ~34% of the total to 76,
and the last three regimes are ~72% of it. The SE column is the reason
to care, and it is flattening — 72 → 76 buys 0.07.

No outcome marked.

---

## 2026-08-15 — Entry 3 — O9 part 2 control failed; proposed log-log rescue does not close
type: result-triage
refs: 1

O9's own READ-THE-RESULT block states the precondition: the part 2
decay-exponent crossing must land at σ = 1.0, and "if it is not, the
instrument is wrong and part 3 is unreadable." It does not. The
crossing interpolates to **0.881** from the logged rows (σ = 0.80 →
+0.0860, σ = 0.90 → −0.0197). Local slope is −1.07 per unit σ,
extrapolated intercept 0.943. The observed line is 0.945 − 1.07σ where
theory says 1 − σ.

A rescue was proposed: the regression is on log N, but the terms are
p^(−σ) and p_N ≈ N ln N, so the correct variable is log p_N = log N +
log log N, and the omitted term contaminates the slope.

**Arithmetic check of the rescue — it accounts for less than claimed.**
Under |Δ| ~ N·p_N^(−σ), the exponent is 1 − σ(1 + 1/ln N). Two
consequences:

1. Predicted slope is −(1 + 1/ln N). Over the ladder N = 125…4000,
   ln N runs 4.8 to 8.3, giving a predicted slope between **−1.21 and
   −1.12**. Observed is **−1.07** — directionally right, but a
   *smaller* correction than log-log predicts, not a matching one.
2. Predicted intercept is **exactly 1.000**. S_2N − S_N is exactly N
   terms by construction of the ladder, so at σ = 0 the count factor
   gives log-slope 1 with nothing left over. The observed 0.943 deficit
   is therefore **not a log-log effect at all** — it is phase
   cancellation in the oscillating sum, which is t-dependent and a
   separate mechanism.

So the claim that both coefficients are off by 5–7% in the same
direction and that this is the size of a log-log correction does not
hold: one coefficient is over-corrected by log-log, the other is
untouched by it. At least two effects are present.

Note also that the crossing point is not independent evidence.
0.945/1.07 = 0.883 is the intercept over the slope — the same fitted
line restated, not a second measurement.

**What survives.** The smoothness argument holds. A σ-dependent
multiplicative bias is a smooth reparametrization of the σ axis and
cannot place a kink where there was none. A displaced-but-smooth
baseline does not manufacture a feature at 0.500.

**What does not.** The direction of risk is wrong for a null. Part 3's
claim ("smooth through 1/2") is an absence, and for an absence the
threat is insufficient power, not manufactured features. No minimum
detectable kink size is stated anywhere. max_z is 2.552 at fine
resolution (residual sd 1e−6, max departure 2e−6) — a weak reading in
either direction. The O7 prereg already legislates this exact move:
"H0 is not confirmed by `depth_independent` — absence of a detectable
slope at n=17 depths is weak evidence, and the writeup must say so
rather than claiming support."

**Procedural note.** As it stands this is a post-hoc rescue of a failed
control: the control fired, an explanation arrived afterward, and the
explanation licensed reading the part the control had declared
unreadable. The O7 prereg's Background names this defect by name —
"the verdict is selectable post hoc." The mechanism may well be real;
asserting it after seeing the failure is the thing the discipline
forbids.

**Cheap conversion to a measurement.** Regress on log p_N instead of
log N. The sieve is already in memory, so p_N per ladder rung is free.
If the crossing moves to ~1.0, the explanation is confirmed
prospectively and part 3 is readable on stated grounds. If it lands at
1.05 or stays near 0.92, the residual is something else. One run.
Given what it is being used to license, it wants a short prereg first.

**Scope note on the conclusion drawn.** Ruling out convergence as the
mechanism does not establish the functional equation's reflection axis
as the mechanism — nothing in O9 tests Mellin normalization. The
supported form is "convergence behavior does not distinguish σ = 1/2,"
with the positive attribution left as the next thing to test. O9 has no
prereg; its output is exploratory, not a verdict.

No outcome marked. The O9 readability thread stays [open].

---

## 2026-08-15 — Entry 2 — Folder folded into the research program
type: motivation
refs: 1

Julian's call: Primebeat_081426 is not a throwaway test bench. It is
being folded into the research program proper, and a separate instance
is standing up the git repo scaffold. Backfill against that scaffold
once it lands.

Consequences for how work here is recorded:

- Results in this folder become citable. The exploratory/preregistered
  distinction (CLAUDE.md § Prereg discipline) stops being bookkeeping
  and starts being load-bearing — six of nine tests currently have no
  locked protocol.
- The absent documents (dyadic-table-v2, DT-A through DT-A4, DT-A7,
  DT-A8, O3c) go from an inconvenience to a gap in the record, since
  every script header cites them and none are on this machine.
- The environment needs pinning. There is no requirements file and no
  lockfile; `connes-cvs 0.3.1` carries O8 entirely.
- `CONTEXT.md` § Current state of the world still reads "uncommitted
  scratch bench." That line is now wrong. Proposed correction is
  pending Julian's approval — commitment files are not agent-editable.

NOTEPAD write authority granted to the agent from this point; status
transitions remain Julian's.

---

## 2026-08-15 — Entry 1 — Scaffold: inventory of the bench at first commitment-file write
type: provenance
refs:

The folder existed for two days (2026-08-14 → 2026-08-15) with no
commitment files, no README, no git, and no markdown authored in place
except one prereg. This entry records what was on disk at the moment
the scaffold was written, so later entries have a baseline.

**Scripts.** One series, O1–O9, with a partial rename: O5/O6/O7 became
`05_`, `06_`, `07_` at root while their docstrings still open "O5 —",
"O6 —", "O7 —". The leading digit is why `07_alpha_depth_trend.py`
imports 05 through importlib instead of by name. O3, O4, O8, O9 kept
the `O` prefix. O1, O2, O3b were never promoted out of `files (2)/`.

**Root copies are hardened descendants** of the `files (2)/` originals:
they add `_HERE`/`_STEM`/`DEFAULT_OUT` path anchoring, a `_jsonable()`
numpy/mpmath coercion helper, a `_write_results()` that survives write
failure, and `--out`/`--no-json` flags. The root O3 lost provenance the
original carried — the `files (2)` O3 header reads "Run by the author
on an M-series Mac, 2026-08-14. RESULT: NEGATIVE. See O3b/O3c for the
two follow-ups, both also negative under control."

**`files (2)/`** is an imported bundle: single mtime 2026-08-14 22:07,
mode 600 throughout, browser dedup suffix in the directory name. It is
the only surviving record of O1, O2, O3b (scripts plus `.txt`
transcripts), and it holds DT-A5 and DT-A6 plus nine dyadic difference
table CSVs across three weightings × two sides.

**Results.** Eight JSON files under `results/`, one shared envelope
(`schema_version` "1", `script`, `generated_utc`, `params`,
`constants`, `summary`, optional `rows`). No O8 results file — O8 has
no `json.dump` and no `--out`; its record is `O8_run.log`,
`O8_run_dps150.log`, `O8_run_dps300.log`.

**Duplicates.** `O9_run.log` and `O9_run_default.log` are byte-identical,
as are their paired JSONs (same `generated_utc`). `O8_run.log` and
`O8_run_dps300.log` are likewise the same run stored twice.

**Caches.** `pi2n_cache.json` holds π(2ⁿ) for n = 0…60 (61 entries),
shared by 05/06/07/O4 — exactly the rmax = 60 the prereg locked.
`pi2n_cache_o3.json` holds n = 0…45 (46 entries), O3 only.

**Environment.** Bare `.venv` on Python 3.14.3, no requirements file
and no lockfile. The load-bearing pin is `connes-cvs 0.3.1`, which O8
depends on entirely.

**Absent.** `dyadic-table-v2.md`, DT-A, DT-A2, DT-A3, DT-A4, DT-A7,
DT-A8, O3c, and the "Prime Beat papers (Sambrano, Jan 2026)" are cited
by script headers and by DT-A5/A6 and exist in neither this folder nor
`primebeat/` nor `primebeat_lean/`.

**Relation to siblings.** One-way and documentary. No import, no shared
module, no filename collision in either direction; `grep` for "DT-A" or
"dyadic-table-v2" across both sibling repos returns nothing. The shared
substrate is conceptual: dyadic difference tables, the `p^(−1/2)` beat
weighting, γ₁, σ = 1/2, the Connes program.

**Preregistration coverage.** One of nine. Only
`preregs/alpha_depth_trend_v1_locked_20260814.md` (O7) exists. O3, O4,
05, 06, O8, O9 produced numbers with no locked protocol; those numbers
are exploratory and are not verdicts.
