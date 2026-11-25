---
id: 0534
date: 2026-11-25
type: formalization
title: "The twisted second moment: Lemma 3 split into a diagonal, an off-diagonal and a swapped term"
refs: [lean_stage3/Stage3/TwistedMoment.lean::ibp_twice, lean_stage3/Stage3/TwistedMoment.lean::offdiag_term, lean_stage3/Stage3/TwistedMoment.lean::inv_log_sq_le, lean_stage3/Stage3/TwistedMoment.lean::offdiag_term_young, lean_stage3/Stage3/TwistedMoment.lean::msq_expand, lean_stage3/Stage3/TwistedMoment.lean::I_split, lean_stage3/Stage3/TwistedMoment.lean::Ires_small, lean_stage3/Stage3/TwistedMoment.lean::I1_expand, lean_stage3/Stage3/TwistedMoment.lean::I1_diag_off, lean_stage3/Stage3/TwistedMoment.lean::Jint_diag, lean_stage3/Stage3/TwistedMoment.lean::offSum_bound, lean_stage3/Stage3/TwistedMoment.lean::lemma3_res_of_parts]
supersedes: []
follows: 0533
context: units 0530 to 0533 gave the approximate functional equation and the sizes and derivatives of its weight; this is piece 2b-ii of block S12 of `lean_stage3/design/stencil.md`, Young's Lemma 3
sealed: false
---

**Question.** Piece 2b-ii of block S12 of `lean_stage3/design/stencil.md`. Does the twisted second moment split into a diagonal, an off-diagonal bounded by integration by parts, a swapped term and a negligible residue, so that Lemma 3 follows from three named pieces?

**What was proved.** `lean_stage3/Stage3/TwistedMoment.lean`: `module_lines` 1810 lines, `theorems_proved` 82 theorems, `defs` 32 definitions, `sorries` 0 sorries, `pins` 12 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8911 jobs, the module at `jobs_module` 8811. Two rows added to TRAPS, `traps_added` 2; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`I_split`: the twisted moment is the first sum, plus the swapped term, less the residue term, and `Ires_small` bounds the residue by a Gaussian of the height. `msq_expand` expands the square of the mollifier as a double sum, and `I1_expand` makes the first sum a sum over four indices by swapping the sum and the integral; `I1_diag_off` and `Jint_diag` split it into the diagonal and the off-diagonal. `ibp_twice` and `offdiag_term`: two integrations by parts bound each off-diagonal term, and `inv_log_sq_le` with `offdiag_term_young` put it in Young's variables. `offSum_bound` sums them, up to a convergent series. `lemma3_res_of_parts`: Lemma 3 follows from the named statements `StmtDiag`, `StmtOffDiag` and `StmtX`.

**Who wrote it.** One worker, whose later rounds stopped on a cast position, a definition a rewrite could not see through, a missing name, an integral rewrite, implicit endpoints and an unreduced application. Two of those classes are new rows of `lean_stage3/TRAPS.md`. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. Two integrations by parts close the off-diagonal only for short mollifiers; the general number of integrations is the decision of the next unit. The diagonal, the swapped term, the operator and the unsmoothing.
