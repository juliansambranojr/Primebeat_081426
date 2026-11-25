---
id: 0546
date: 2026-11-25
type: formalization
title: "window-near-diff"
refs: [lean_stage3/Stage3/LevinsonWindowNear.lean::sum_order_le_lineCount_sub, lean_stage3/Stage3/LevinsonWindowNear.lean::lineCount_nonneg, lean_stage3/Stage3/LevinsonWindowNear.lean::levinson_count_sub, lean_stage3/Stage3/LevinsonWindowNear.lean::levinson_window_diff, lean_stage3/Stage3/LevinsonWindowNear.lean::levinson_window_near]
supersedes: []
follows: 0545
context: unit 0529's Levinson window asked for the mean on every subwindow and bounded the whole line count; this restates it for the assembly of the floor, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the window restated. Does Levinson's window hold with the mean asked only on the near-full windows its proof uses, and with the zeros on the line between the window's two heights on the left?

**What was proved.** `lean_stage3/Stage3/LevinsonWindowNear.lean`: `module_lines` 737 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8940 jobs, the module at `jobs_module` 8813. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`sum_order_le_lineCount_sub`: zeros on the line with heights in a half-open interval, counted with order, at most the difference of the line counts at its ends. `lineCount_nonneg`: the line count is not negative. `levinson_count_sub`: Levinson's count with the line count's difference on the right, the bottom height chosen where zeta itself is not zero on the line, so no crossing sits on the cut. `levinson_window_diff`: the window with its mean hypothesis only on windows whose ends lie within one of the window's ends, and the difference of the line counts on the right; the constant is unchanged. `levinson_window_near`: the same with the whole line count, from the line count's nonnegativity. The difference form lets the windows over successive halvings of the height be summed to a proportion of all zeros up to the height.

**Who wrote it.** One worker, from copies of the proofs of unit 0529. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, the module and the package were rebuilt here, and each pin reads the standard axioms. No new trap.

What remains. The unsmoothing, and the assembly: continuity of the mean in the abscissa, the polynomial's value one at one, the closed form of the main term and the sum over halvings.
