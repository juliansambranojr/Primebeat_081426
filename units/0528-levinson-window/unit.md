---
id: 0528
date: 2026-11-25
type: formalization
title: "Levinson's method on one window, with the mean square as the named input"
refs: [lean_stage3/Stage3/LevinsonWindow.lean::countRight_right_le, lean_stage3/Stage3/LevinsonWindow.lean::lineCount_mono, lean_stage3/Stage3/LevinsonWindow.lean::N_step_le, lean_stage3/Stage3/LevinsonWindow.lean::G_line_ne, lean_stage3/Stage3/LevinsonWindow.lean::levinson_window]
supersedes: []
follows: 0527
context: units 0519 to 0527 built every unconditional piece of Levinson's method in block S11 of `lean_stage3/design/stencil.md`; this assembles one window, with the mean square as the named input
sealed: false
---

**Question.** Block S11 of `lean_stage3/design/stencil.md`, assembled. On one window of heights, does a bound on the mean square of the perturbed function times a mollifier just left of the line give a lower bound for the zeros of zeta on the line?

**What was proved.** `lean_stage3/Stage3/LevinsonWindow.lean`: `module_lines` 508 lines, `theorems_proved` 10 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 8 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8905 jobs, the module at `jobs_module` 8811. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`levinson_window`: for heights from e to the twenty-six, Levinson's constant one over the logarithm of the height, a mollifier with first coefficient one and bounded coefficients, an abscissa a little left of one half, and a window of heights: if the mean square of zeta plus that multiple of its derivative times the mollifier is at most K on every subwindow and every nearby abscissa, and every zero of zeta on the line in the window is simple, then the zeros on the line up to the top of the window are at least the zeros in the window, less the inverse of pi times the distance from one half times half the length times the logarithm of K plus the mollifier's edge terms `windowE`, less a multiple of the logarithm of the height plus a constant. It chooses good heights inside the window and a good abscissa, and absorbs the shifts with `N_step_le`. `G_line_ne` shows a zero of the perturbed function on the line is a common zero of zeta and its derivative; `countRight_right_le` and `lineCount_mono` are monotonicity lemmas.

**Who wrote it.** One worker, whose builds stopped on closed goals, a heartbeat timeout and an option's place. The proof of the main theorem raises the heartbeat limit, as other Stage3 modules do. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The hypothesis that the zeros on the line are simple, the mean value itself, and the limit over windows; nothing here proves the Riemann hypothesis, and Levinson's method reaches a positive proportion of the zeros.
