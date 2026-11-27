---
id: 0571
date: 2026-11-25
type: formalization
title: "turing-slope"
refs: [lean_stage3/Stage3/TuringSlope.lean::theta_sub_le_sharp, lean_stage3/Stage3/TuringSlope.lean::theta_sub_le_sharp80, lean_stage3/Stage3/TuringSlope.lean::turing_S_le_sharp]
supersedes: []
follows: 0570
context: unit 0569's size budget ranked the horizon's slope term, from the crude Stirling bound, as the largest left in Turing's closing; this sharpens it, in block S14 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S14 of `lean_stage3/design/stencil.md`, Turing's slope term. How much does a sharp bound on the horizon's slope lower the height at which Turing's certificate closes?

**What was proved.** `lean_stage3/Stage3/TuringSlope.lean`: `module_lines` 352 lines, `theorems_proved` 8 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 6 error lines; clean on build `builds` 4. The package builds at `jobs_package` 9025 jobs, the module at `jobs_module` 8881. Traps added, `traps_added` 3; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`TuringSlopePoint.lean`: the real part of the digamma function on the line through a quarter, bounded above by the logarithm plus pi over twice the height plus a constant over its square, by a one-sided step in the telescoping product and a comparison of the sum with an integral. `theta_sub_le_sharp` and `theta_sub_le_sharp80`: the horizon's turning over an interval at most its length times half the logarithm of the height over two pi plus one, or four fifths, over the height. `turing_S_le_sharp`: Turing's lemma with that slope and the sharp Littlewood constants of unit 0569. The file also restates the certificate with them, `defect_zero_of_closing'`, from one finite statement of signs.

**The closing height.** Computed, not proved: with ideal sign data Turing's inequality now first closes near `closing_ideal` 439, against `closing_ideal_before` 1462 before, with about `points_below` 228 sign points below and `points_above` 54 above.

**Who wrote it.** One worker, `files` 2 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 146 to `trap_last` 148.

What remains. The point run up to the closing height, which proves the defect zero there.
