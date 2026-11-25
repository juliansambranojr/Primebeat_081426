---
id: 0517
date: 2026-11-24
type: formalization
title: "The line count: RH is the zeros on the line matching all zeros at every height, and sign changes bound the line from below"
refs: [lean_stage3/Stage3/LineCount.lean::lineCount_le_allCount, lean_stage3/Stage3/LineCount.lean::rh_iff_line_count, lean_stage3/Stage3/LineCount.lean::signChanges_le_line_count]
supersedes: []
follows: 0516
context: unit 0516 made every sign change of the completed zeta on the line a zero on the line; this is step three of block S10 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Step three of block S10 of `lean_stage3/design/stencil.md`. Is the Riemann hypothesis the statement that, at every height, the zeros on the line match all the nontrivial zeros, and do sign changes on the line bound the zeros there from below?

**What was proved.** `lean_stage3/Stage3/LineCount.lean`: `module_lines` 223 lines, `theorems_proved` 6 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 8 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8894 jobs, the module at `jobs_module` 8800. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`lineCount_le_allCount`: the zeros on the line up to a height, with multiplicity, are never more than all the nontrivial zeros up to it. `rh_iff_line_count`: the hypothesis holds exactly when the two counts agree at every height. A zero off the line, or its conjugate, sits at a positive height and makes the full count larger. `signChanges_le_line_count`: strict sign changes of the completed zeta along a rising list of heights give at least as many zeros on the line, one in each open interval, so no two coincide.

The counts are sums of the order of zeta over the zeros between height zero and the height, in the integers. The sign changes are strict so that a zero at a shared endpoint is never counted twice.

**Who wrote it.** One worker, whose first build stopped on an untyped binder and an implicit argument. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. Enough sign changes to match the full count: step four, the floor.
