---
id: 0542
date: 2026-11-25
type: formalization
title: "diagonal-main-term"
refs: [lean_stage3/Stage3/SdiagLead.lean::stmtSdiagLead_holds, lean_stage3/Stage3/SdiagLead.lean::stmtDiagMainO_holds]
supersedes: []
follows: 0541
context: decision unit 0540 found the main term loses a factor from the Moebius mean alone and chose the smoothed Moebius sum; this builds the main term on that route, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the main term. With the smoothed Moebius sum, does the mollifier sum at zero equal Young's integral over the mollifier's logarithm to the precision the diagonal needs?

**What was proved.** `lean_stage3/Stage3/SdiagLead.lean`: `module_lines` 80 lines, `theorems_proved` 2 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 5 error lines; clean on build `builds` 5. The package builds at `jobs_package` 8929 jobs, the module at `jobs_module` 8827. Traps added, `traps_added` 4; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`Sdiag_swap`: the greatest common divisor's power swapped for a divisor sum, the mollifier sum at zero a sum over d of two inner sums. `muSmoothR` and `muSmooth_crude`: each inner sum's Moebius step to little o of one over the logarithm, by Taylor's formula against the smoothed Moebius sum; `stmtMuSmooth_holds` closes unit 0540's open `StmtMuSmooth` with no hypothesis. `copAF_eq` and `Ad_eq`: the coprimality condition written as a convolution. `stmtAdApprox_of_arith` and `stmtDsum_of_arith`: the inner sums and the sum over d, from six elementary facts `StmtArith` about squarefree numbers and Euler's phi. `stmtSdiagLead_holds` and `stmtDiagMainO_holds`: the main term in little o form, for a polynomial vanishing at zero and a positive length exponent, from `StmtArith`.

**Who wrote it.** One worker, `files` 7 files: this module and `SdiagLeadCore`, `SdiagLeadSwap`, `SdiagLeadSmooth`, `SdiagLeadCop`, `SdiagLeadAd`, `SdiagLeadDsum`, whose pins are checked in each file. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. The worker checked the size before each layer and lost no factor. Traps: TRAPS.md rows `trap_first` 63 to `trap_last` 66.

What remains. The six arithmetic facts, Stirling's formula with its phase, the operator and the unsmoothing.
