---
id: 0556
date: 2026-11-25
type: formalization
title: "conrey-count"
refs: [lean_stage3/Stage3/ConreyCount.lean::conrey_count_sub, lean_stage3/Stage3/ConreyCount.lean::conrey_count_window]
supersedes: []
follows: 0555
context: unit 0555 gave the line identity for a general polynomial; this proves Conrey's identity and Levinson's count through it, step one of the general-polynomial round of block S13 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S13 of `lean_stage3/design/stencil.md`, the general polynomial, step one. Does Conrey's identity split the completed zeta into two conjugate halves for every symmetric polynomial, and does Levinson's count then hold with Conrey's function in place of zeta plus its derivative over the logarithm, multiple zeros included?

**What was proved.** `lean_stage3/Stage3/ConreyCount.lean`: `module_lines` 469 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 11. The package builds at `jobs_package` 8962 jobs, the module at `jobs_module` 8819. Traps added, `traps_added` 4; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`ConreyCountIdentity.lean`: `conrey_identity`, the polynomial's operator on the completed zeta at the point plus the same at one minus the point equal to twice the polynomial at one half times the completed zeta, at every point, from the parity of the completed zeta's derivatives under the reflection; Conrey's form for a polynomial whose values at a point and its reflection sum to a constant. `ConreyCountLine.lean`: the line count from the turning of that operator, and its turning split into the gamma part and the turning of `V`, the operator over the gamma factor. `ConreyCountOrder.lean`: at a zero of `V` on the line, the order of zeta at least the order of `V`, and one more at a crossing, which replaces Levinson's exact rule, false for a general polynomial. `ConreyCountEdge.lean`: the right edge and the horizontal edges for `V`, with its size as named statements. `conrey_count_sub`: the zeros on the line in a window at least all the zeros there, less twice the zeros of `V` right of the line, less a constant and logarithms. `conrey_count_window`: the same on the windows of the top of the height, from one named statement of `V`'s size, `StmtVEdges`.

**Sizes.** The worker checked `V`'s size numerically: on the right edge its real part stays well above a third, and on the discs it stays far below the height, for heights over four decades. No factor grows with the height on the windows of the top; on lower windows the gamma shift grows with the number of halvings.

**Who wrote it.** One worker, `files` 5 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 94 to `trap_last` 97.

What remains. `StmtVEdges`, from bounds on the digamma function off its line, the mean value with a general polynomial, and the closed form.
