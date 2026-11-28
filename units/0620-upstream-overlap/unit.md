---
id: 0620
date: 2026-11-27
type: run
title: Which of the repo's topics Mathlib, PNT+ and IEANTN already hold
refs: [none]
supersedes: []
follows: 0619
sealed: false
---

**Question.** Which of this repo's topics are already in Mathlib, in PrimeNumberTheoremAnd (PNT+), or in IEANTN, the repository PNT+'s IEANTN material is moving to; and has any of this repo's work been sent to them?

**What ran.** `run/overlap.py`, by `run/run.sh`, through `lab run` (exit 0, `meta.lab_run.001.meta.wall_s` 397.78254658399965 seconds). It made three readings. First, a GitHub code search per topic per project, Lean files only, on each project's default branch. Second, the same words grepped in the local Mathlib and PNT+ copies `lean_stage3/` builds against, at the PNT+ pin of August. Third, a search for issues and pull requests by `juliansambranojr` in Mathlib and PNT+. The file paths each search returned are in `run/overlap_paths.txt`.

**Nothing has been sent.** The searches for issues and pull requests found `overlap.authored.mathlib` 0 in Mathlib and `overlap.authored.pnt` 0 in PNT+.

**Found nowhere.** No search, on GitHub or in the local copies, found the difference table: `overlap.search.difference_table.mathlib` 0, `overlap.search.difference_table.pnt` 0, `overlap.search.difference_table.ieantn` 0, `overlap.local.difference_table.mathlib` 0, `overlap.local.difference_table.pnt` 0. Conrey is absent the same way, `overlap.search.conrey.mathlib` 0, `overlap.search.conrey.pnt` 0, `overlap.search.conrey.ieantn` 0. Levinson's hits in Mathlib, `overlap.search.levinson.mathlib` 5, are in sheaves, Young tableaux, double factorials, Hermite polynomials and local cohomology; PNT+ and IEANTN have `overlap.search.levinson.pnt` 0 and `overlap.search.levinson.ieantn` 0. The one PNT+ file that applies `Nat.primeCounting` to a power of two, `overlap.search.primecounting_pow2.pnt` 1, uses it for the bound that the count at the power is at least the exponent, inside the proof of an Erdős problem. Mathlib's forward difference `fwdDiff` (`overlap.local.fwddiff.mathlib` 3 local files) is the general operator, used for Mahler bases; nothing builds on it at the doublings.

**Already there.** Hardy's Z function is in Mathlib, `overlap.search.hardyz.mathlib` 1 file, `Mathlib/NumberTheory/LSeries/HardyZ.lean`, and in IEANTN, `overlap.search.hardyz.ieantn` 4. The local Mathlib, older, has `overlap.local.hardyz.mathlib` 0. Stirling: `overlap.search.stirling.ieantn` 30 IEANTN files, `overlap.search.stirling.pnt` 7 in PNT+. Digamma: `overlap.search.digamma.ieantn` 24 and `overlap.search.digamma.pnt` 6. Backlund's zero count: `overlap.search.backlund.ieantn` 16 and `overlap.search.backlund.pnt` 5. Schoenfeld: `overlap.search.schoenfeld.pnt` 9 in PNT+. Weil: `overlap.search.weil.ieantn` 18 in IEANTN. The IEANTN hits sit under its Rosser–Schoenfeld solutions, which are built on Zeta23, the library `lean_bridge/` requires. IEANTN's Turing hits, `overlap.search.turing.ieantn` 2, are two copies of one file on Hardy's ten zeros, not opened here. Mathlib's, `overlap.search.turing.mathlib` 22, are Turing machines.

**What the search cannot settle.** GitHub's code search missed a file the local copy holds: `overlap.search.riemannhypothesis.mathlib` 0 on GitHub against `overlap.local.riemannhypothesis.mathlib` 1 locally, `NumberTheory/LSeries/RiemannZeta.lean`. A zero from the code search therefore reads as very likely absent; it is not a proof of absence. The local copies are from August and cannot see what Mathlib and PNT+ added since.
