---
id: 0540
date: 2026-11-25
type: decision
title: "The diagonal's main term from the Moebius sum alone loses a factor of the mollifier's logarithm; the smoothed Moebius sum carries it"
refs: [lean_stage3/Stage3/DiagMain.lean::stmtDiagMainO_of_lead, lean_stage3/Stage3/DiagMain.lean::zeta_taylor, lean_stage3/Stage3/DiagMain.lean::IY_bound, lean_stage3/Stage3/DiagMain.lean::logM_ge, lean_stage3/Stage3/DiagMainMu.lean::psiMu_tendsto, lean_stage3/Stage3/DiagMainMu.lean::mobius_harmonic, lean_stage3/Stage3/DiagMainMu.lean::abel_ineq, lean_stage3/Stage3/DiagMainMu.lean::D_small]
supersedes: []
follows: 0539
context: unit 0538 decided to carry the diagonal's main term with a little o error from the PNT+ Moebius theorem; the worker on that term checked the size before the uniformity step, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Does the PNT+ Moebius theorem alone give the mollifier sum at zero to the precision the diagonal's main term needs?

**What ran.** The worker's derivation of the sizes, and two Lean files, `lean_stage3/Stage3/DiagMain.lean` and `lean_stage3/Stage3/DiagMainMu.lean`, built here with the package. EXPLORATORY: no prereg, no verdict.

**The lost factor.** The mollifier sum at zero has the size of one over the logarithm of the height, and zeta beside it the size of that logarithm, so the sum is needed to little o of one over the logarithm. Written through the greatest common divisor, it is a sum over divisors d of a weight near one over d times two sums over n. Each inner sum's main term is of the size one over the mollifier's logarithm. The Moebius mean value tending to zero gives each inner sum only up to little o of one. Summed over d with weight one over d, that error is little o of one times one over the mollifier's logarithm times that logarithm, which is little o of one. That misses the precision by a factor of the mollifier's logarithm, which grows with the height. The steps are right, and the size they add up to fails: the design is wrong.

**The decision.** Use the smoothed Moebius sum, the sum of mu of n over n times the logarithm of N over n, which tends to one, as the Moebius input. The polynomial vanishes at zero, so every term of the mollifier carries a factor one over the mollifier's logarithm, and partial summation against the smoothed sum gives each inner sum to little o of one over that logarithm, uniformly once M over d is large; the remaining divisors contribute a bounded amount. The coprimality condition is bounded on average over d against the squarefree weight over Euler's phi, because its tail is small only on average.

**What was proved.** `stmtDiagMainO_of_lead`: the main term in little o form from one statement, `StmtSdiagLead`, the mollifier sum at zero equal to Young's integral over the mollifier's logarithm up to little o of one over the logarithm of the height; with `zeta_taylor` and the bounds on the integral and the mollifier's logarithm. `psiMu_tendsto`: the smoothed Moebius sum tends to one, from `mu_pnt` and `mu_pnt_alt` by the Moebius inversion of the harmonic numbers and Abel's inequality. Open: `StmtSdiagLead`, and `StmtMuSmooth`, the inner sum's asymptotic at d equal to one. Both files have no `sorry`, added axiom or `native_decide`; each pin reads the standard axioms.

**Traps.** TRAPS.md rows `trap_first` 57 and `trap_second` 58: `omega` after `set` on a natural quotient, and a rewrite by `abs_of_nonneg` landing on the first absolute value.
