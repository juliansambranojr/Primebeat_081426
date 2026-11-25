---
id: 0543
date: 2026-11-25
type: formalization
title: "stirling-phase"
refs: [lean_stage3/Stage3/StirlingX.lean::XY_eq_exp, lean_stage3/Stage3/StirlingX.lean::exponent_le, lean_stage3/Stage3/StirlingX.lean::stmtXStirlingRel_holds]
supersedes: []
follows: 0542
context: unit 0541 left the swapped term on one open input, Stirling's formula with its phase; this proves that input in relative form and finds the absolute form false, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, Stirling with its phase. Does the gamma-factor ratio equal the power of the height over two pi to within a constant over the height, and does Young's Lemma 3 then rest on the main term alone?

**What was proved.** `lean_stage3/Stage3/StirlingX.lean`: `module_lines` 543 lines, `theorems_proved` 17 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 4 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8935 jobs, the module at `jobs_module` 8824. Traps added, `traps_added` 4; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`XY_eq_exp`: the gamma-factor ratio as one exponential. `exponent_le`: its exponent within a constant over the height of the power's. `stmtXStirlingRel_holds`: the ratio equal to the power of the height over two pi up to a constant times that power's size over the height, for shifts below one tenth and every height from one. `stmtXAll_of'` and `lemma3_resO_of_mainO'`: the swapped term, and Young's Lemma 3 with a little o error, from the main term alone. The companion file `StirlingLog.lean` proves the gamma function as the exponential of a log-gamma limit on the right half plane and the shift of that log-gamma by a constant over the height, by finite sums and a limit, with no digamma and no integral.

**The finding.** The absolute form `SwapX.StmtXStirling`, a constant over the height with no factor, is false: the next Stirling term carries the size of the power, which grows with the height when the shifts' real parts sum below zero. The worker checked it numerically with mpmath; the negation is not in Lean. `SwapX.stmtXAll_of` and `SwapX.lemma3_resO_of_mainO` take that false hypothesis, and the status table of `SwapX.lean` now says so and names their replacements. On the support of the weight inside the regime, the power's size is bounded by a constant, so the swapped term closes unchanged.

**Who wrote it.** One worker, `files` 2 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 67 to `trap_last` 70.

What remains. The arithmetic facts of the main term (unit 0544), the operator and the unsmoothing.
