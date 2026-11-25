---
id: 0553
date: 2026-11-25
type: formalization
title: "floor-long"
refs: [lean_stage3/Stage3/FloorLong.lean::logmax_long, lean_stage3/Stage3/FloorLong.lean::floor_of_long, lean_stage3/Stage3/FloorLong.lean::floor_lt_half, lean_stage3/Stage3/FloorLong.lean::levinson_floor_of_long]
supersedes: []
follows: 0552
context: block S13 of `lean_stage3/design/stencil.md`, step B1, makes stage B one named input; unit 0551 computed what that input would give
sealed: false
---

**Question.** Block S13 of `lean_stage3/design/stencil.md`, step B1. Does Levinson's floor hold for every mollifier length from one named statement of the three error terms at that length, and does that statement hold below one half?

**What was proved.** `lean_stage3/Stage3/FloorLong.lean`: `module_lines` 234 lines, `theorems_proved` 4 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 3 error lines; clean on build `builds` 5. The package builds at `jobs_package` 8956 jobs, the module at `jobs_module` 8861. Traps added, `traps_added` 3; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`FloorLongErr.lean`: `StmtLongErr`, the diagonal's shifted-line error, the off-diagonal and the swapped term at one length for every regime constant, and `longErr_of_lt_half`, the statement for every length below one half; the main term re-derived with no bound on the length. `FloorLongMean.lean` and `FloorLongStep.lean`: the operator, the unsmoothing and the one-height floor re-proved from the statement, with the bounds that used a length at most one re-proved for every length. `floor_of_long`: for every length, the statement gives the zeros on the line at least one minus the logarithm of the larger of one and the closed-form constant, over the shift, less any fixed amount, times all the zeros, from some height on. `floor_lt_half`: the same with no hypothesis below one half. `levinson_floor_of_long`: the floor of unit 0550 again through this path.

**Where the length enters.** Only at the three error statements: the diagonal's shifted line, the off-diagonal's integrations by parts and the swapped term's Stirling remainder. Elsewhere it was carried unused or used only as at most one. The constants that grow with the length raise the starting height only.

**Who wrote it.** One worker, `files` 4 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 91 to `trap_last` 93.

What remains for stage B. The operator with a general polynomial in place of one minus x, and the named statement for lengths of one half and more.
