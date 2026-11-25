---
id: 0539
date: 2026-11-25
type: formalization
title: "diagonal-little-o"
refs: [lean_stage3/Stage3/DiagonalO.lean::small_of_log, lean_stage3/Stage3/DiagonalO.lean::errY_absorb, lean_stage3/Stage3/DiagonalO.lean::T_le_errO, lean_stage3/Stage3/DiagonalO.lean::what0_le, lean_stage3/Stage3/DiagonalO.lean::stmtDiagO_of_mainO, lean_stage3/Stage3/DiagonalO.lean::lemma3_resO_of_parts, lean_stage3/Stage3/DiagonalO.lean::lemma3_resO_of_mainO_X]
supersedes: []
follows: 0538
context: unit 0538 reduced the diagonal to its arithmetic main term and decided to carry that term with a little o error; this restates the diagonal and Young's Lemma 3 with a little o error of the height, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the little o layer. With the diagonal's main term known only to little o of one, does the diagonal hold up to little o of the height, and does Young's Lemma 3 then follow from the main term and the swapped term alone?

**What was proved.** `lean_stage3/Stage3/DiagonalO.lean`: `module_lines` 260 lines, `theorems_proved` 7 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 7 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8921 jobs, the module at `jobs_module` 8816. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`StmtDiagO`: the diagonal equal to the main term times the weight's mean, up to any fixed fraction of the height and the weight's constants, from some height on. `stmtDiagO_of_mainO`: it follows from the main term in little o form and the shift of unit 0538. `StmtLemma3resO` and `lemma3_resO_of_parts`: Young's Lemma 3 up to its remainder, with a little o error, from the diagonal, the off-diagonal and the swapped term. `lemma3_resO_of_mainO_X`: the same with the off-diagonal of unit 0537 discharged, so the twisted moment rests on the main term and the swapped term. The helpers absorb the height over its logarithm into any fraction of the height and bound the weight's mean by twice the height.

**Who wrote it.** One worker. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, the module and the package were rebuilt here, and each pin reads the standard axioms. The assembled lemma is stated over the windows bounded to every order, because the off-diagonal is proved over those.

What remains. The main term, the swapped term, the operator and the unsmoothing.
