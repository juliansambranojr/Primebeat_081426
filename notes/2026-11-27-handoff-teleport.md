# Handoff for the teleported session, 2026-11-27

Written at the end of the cloud session on branch `claude/serene-knuth-jcsdkx`, after PR #25 merged into
`main` (13f04b5). Read this first; then `notes/2026-11-27-handoff.md` and `notes/2026-11-27-corner-writeup.md`
for the earlier part of the day.

## 1. The Riemann hypothesis is proved in Lean — where it is

This surprised the previous session too, and Julian had to correct it. The proof is on disk.

- **Repository:** `leanprover-community/riemann-hypothesis` on GitHub (in the cloud it was checked out at
  `~/leanprover-community/riemann-hypothesis`; clone it locally if it is not already there).
- **The theorem:** `src/Main.lean`:
  `theorem riemannHypothesis : RiemannHypothesis := New.zeta_zeros_on_line New.grh`
  — Mathlib's own `RiemannHypothesis`, nothing restated. The file's first line: "The proof is Levent Alpöge's,
  with Claude." The README: a community effort to maintain a Lean formalization of the 2026 proofs of RH and of
  GRH for Dirichlet L-functions; branches `alpoge` and `original` keep the earlier versions; `main` is based on
  the readable edition at `lsernau/grh-lean`.
- **Toolchain and pins:** `leanprover/lean4:v4.37.0-rc1`; Mathlib at `31ce06e` (see its `lake-manifest.json`).
  Our trees are on other toolchains: `lean/` v4.28.0, `lean_stage3/` v4.32.2.

### How this tree uses it

The toolchains differ, so the composition is **by statement identity**, checked by
`utilities/check_weld.py` (run it: it must print `0 broken weld(s)`):

1. `RiemannHypothesis` in stage 3's Mathlib is compared, text for text, with the copy stored at
   `utilities/weld_sources/RiemannHypothesis_mathlib_31ce06e.lean` (the definition at the RH repo's Mathlib pin).
2. `lean_stage3/` proves, from `RiemannHypothesis` alone, the route's error bound: `RouteSharp.weakWindow13_of_RH`
   in `lean_stage3/Stage3/RouteTight.lean` (route constant 13 at floor 2^38).
3. The bench `lean/` takes that conclusion as a named hypothesis, `WeakDepths.StmtRoute13`, whose text the weld
   checker compares with the stage-3 conclusion (the route welds: `StmtRoute414/263/91/127/40/13`).

So "under RH" in this tree means: under the theorem in `leanprover-community/riemann-hypothesis`, joined by a
checked textual weld across toolchains. It is not one kernel check end to end.

## 2. What is proved about the table (all pinned `propext, Classical.choice, Quot.sound`)

- **Rows 1–23, every depth, nothing assumed:** `lean/Census23.lean` `only_four_zeros_le23` (unit 0618).
  π(2^23) = 564163 by Legendre's formula in the kernel (`PiRow23.pi23`).
- **Depths 1–16, every row:** `lean/WeakDepths.lean` `only_four_zeros_rh_le16` (unit 0606).
- **Every depth past the line** r ≥ 4d + 30 (r ≥ 3.7d + 39 for d ≥ 30): `only_four_zeros_rh_line37` (unit 0607).
- **The capstone:** `lean/Capstone.lean` `only_four_zeros_outside_corner24` — every zero outside
  `Capstone.OpenCorner` (d ≥ 17, r ≥ 93, below both lines) is one of the four, given the π list on rows 24–92
  (`Census23.StmtPiData24`) and `StmtRoute13` (unit 0619).

The theorem the loop aimed at = the capstone with (a) the π list on rows 24–92 proved and (b) `OpenCorner` shown
to hold no zero.

## 3. Rows 24 and 25 — in progress

Generated and split to one term per file; **not yet built**. Row 24's blocks of six terms were killed for
memory (one block passed 13 GB), so every block from 114 on, and all of row 25, is one term per file.
Resume on the Mac with, from the repo root:

    utilities/pirows/build_rows.sh 24 25

It builds one module at a time, then `Census24`, `Census25`. See `utilities/pirows/README.md`. When both build:
narrow the capstone's π input to rows 26–92 (`Census25.piData25_of_26`) and log a unit.

Rows near 92 (π ≈ 10^26) are beyond any kernel computation: the π list to row 92 cannot be finished this way.

## 4. The deep corner — everything measured

Picture: the artifact "Deep Corner Map" (https://claude.ai/artifact/6nH4sUXthM69wFEVgJ7xWd, private to Julian):
Julian's layout, each cell coloured by what proves it; past row 92 about 4 cells in 5 are open (unit 0607).

Earlier in the day (see `notes/2026-11-27-corner-writeup.md`): edge diagonals read each zero as (2^ρ − 1)^d
(unit 0596); the corner rebuilt from 2000 zeros (0597); depth never amplifies an offline zero (0598); prime-power
congruences (0600).

Then, all exploratory, on the exact corner to row 92 with the first 2000 zeros:

| Unit | Finding |
|---|---|
| 0602 | Error bounds close the middle band only to about depth 20 at row 93, at any constant: the corner needs another argument. |
| 0609 | **Julian's harmonics posit holds:** the zeros near the odd harmonics (2k+1)π/log 2 alone rebuild 2920 of 2962 corner signs (all zeros: 2921; far zeros: 1806). Depth factor \|2^ρ − 1\| ranks a zero's share at 0.97–0.99. |
| 0610 | **One comb, zoomed:** the filter at depth d is the depth-1 filter to the d-th power. Width shrinks with slope −0.43 (predicted −0.5); leaders follow the record sequence (86 of 88 depths): 14.135 → 40.919 → 49.774 → 276.452. Base 3 has its own comb. |
| 0611 | The leader is ~1.5× the runner-up, but only 3–7% of the rest added by size; size alone cannot prove anything (the sum diverges). |
| 0612 | The rest cancels like independent phases; its root-square size has a finite limit; the leader is of the same size. |
| 0613 | Half the leader's losses are its own phase near zero; half are real. |
| 0614 | The real losses come from the runner-up and the other near-harmonic zeros lining up; far zeros and the tail play no part. |
| 0615 | **The near-harmonic zeros beat:** phase differences drift per row exactly at their offset differences (0.2859 vs predicted 0.2843, etc.), beats every 22.1, 43.2, 14.6 rows. A corner cell is an almost-periodic function of the row with known frequencies — Julian's beat one level up. |
| 0616 | Kronecker–Weyl / Rubinstein–Sarnak: under RH + LI, corner zeros are rare (expected count finite); it cannot forbid a zero at a single cell; no single zero takes over along the diagonal. |
| 0617 | Exact certificates: Lucas congruences exist at the rate of chance and need about a third of the cell's rows mod p; the weighted prime count cancels to ~1e-8; no link to the beat. |
| 0608 | Novelty check: the table and its facts, and Meissel–Lehmer in Lean, appear new; the explicit-formula route and explicit zero counts were done before (Zeta23, published constants far below ours). |

**Where it stands.** A corner cell = a leader the comb predicts + a remainder of the same size with bounded
square, made of the near-harmonic family, whose phases beat at known rates. What would close the corner is a
lower bound for these almost-periodic sums at every cell along a diagonal whose leaders change — or an exact
identity tying π(2^m) mod small primes to the harmonic structure. Julian's position: beyond current methods is not
impossible; keep looking with the exact pieces.

## 5. Practical

- Rules: `CLAUDE.md` (offer the log after every result; say what is; load, don't recall; Julian's alone:
  verdicts, status transitions, outcome markings).
- Every result has a unit, 0594–0619; `python3 -m lab check <id>` re-verifies a unit's numbers.
- Correction on record: commit a3b787c's message gave 7824862 for π(2^23); that is the Legendre term sum. The
  theorem says 564163 (unit 0618).
- Do not commit `TuringRun600*` without Julian's word.
