---
id: 0608
date: 2026-11-27
type: literature
title: What is new: the table and its facts, Meissel-Lehmer in Lean; the explicit-formula route and the zero count were done before
refs: [lean/MeisselLehmer.lean::meissel_lehmer, lean/Legendre.lean::primeCounting_eq_phi, lean/PiRow23.lean::pi23, lean_stage3/Stage3/RvMSharp.lean::rvM_sharp, lean/Capstone.lean::only_four_zeros_outside_corner24]
supersedes: []
follows: 0607
sealed: false
---

**Question.** Has anything proved in this session been new mathematics, or new as a formalization?

**What ran.** `run/scan.py`, by `run/run.sh`, through `lab run`, searches the three Lean libraries the tree depends on for prior formalizations: Mathlib (`scan.mathlib.files` 8795 files), PNT+ at its pinned version (`scan.pnt_plus.files` 236) and Zeta23 under `lean_bridge/` (`scan.zeta23.files` 1812). Web searches on 2026-11-27 covered the literature: the OEIS, arXiv and the formal-proof libraries.

**Done before.** The explicit Riemann–von Mangoldt bound: Zeta23 has `scan.zeta23.rvm_bound` 91 files on it, `scan.zeta23.rvm_bound_sorry_free` 91 of them free of sorry, Backlund's bound among them (`github.com/anthropics/zeta-23-lean`). PNT+ at the pinned version states Backlund's bound with constants `scan.pnt_backlund.b1` 0.137, `scan.pnt_backlund.b2` 0.443 and `scan.pnt_backlund.b3` 6.1 and leaves its proof as sorry (`scan.pnt_backlund.proof_is_sorry` true). The published constants are far below this tree's: Backlund's `scan.published.backlund[0]` 0.137, `scan.published.backlund[1]` 0.443, `scan.published.backlund[2]` 5.225, and Trudgian's `scan.published.trudgian[0]` 0.112, `scan.published.trudgian[1]` 0.278, `scan.published.trudgian[2]` 3.385 (`arXiv:2412.15470`), against `rvM_sharp`'s first constant `scan.ours_rvM_sharp_b1` 15. The explicit formula and the Riemann–von Mangoldt formula from Mathlib are in a Lean library (`arXiv:2610.08965`). The route from RH to an error bound on the prime count is Schoenfeld's, with a constant far below this tree's. Legendre's and Meissel–Lehmer's formulas are classical (Lagarias, Miller and Odlyzko, `MathComp:1985-44-170`). The row sequence is OEIS `A036378`.

**Not found.** Legendre's φ formula and Meissel–Lehmer's as Lean theorems: `scan.mathlib.meissel_lehmer_formula` 0 files in Mathlib, `scan.pnt_plus.meissel_lehmer_formula` 0 in PNT+, `scan.zeta23.meissel_lehmer_formula` 0 in Zeta23, and `scan.mathlib.legendre_phi_formula` 0, `scan.pnt_plus.legendre_phi_formula` 0 and `scan.zeta23.legendre_phi_formula` 0 for Legendre's; a web search found none in Lean, Isabelle or Coq. The Archive of Formal Proofs was not searched directly. The higher differences of A036378 and where they vanish: a search found no study of them.

**What it means.** No technique here is new, and no theorem is new in the usual sense. New are the table and its facts: the four zeros, the census through the twenty-third row with nothing assumed, the depth and line theorems under RH, the edge diagonals and the prime-power congruences, each proved by standard methods. Probably new as formalizations are Legendre's and Meissel–Lehmer's formulas in Lean and a prime count at two to the twenty-third computed by the kernel. The deep corner, if settled, would be a new result about the zeros of zeta.
