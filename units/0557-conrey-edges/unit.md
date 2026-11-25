---
id: 0557
date: 2026-11-25
type: formalization
title: "conrey-edges"
refs: [lean_stage3/Stage3/DigammaBound.lean::right_edge_ge, lean_stage3/Stage3/DigammaBound.lean::disc_le, lean_stage3/Stage3/DigammaBound.lean::stmtVEdges_holds]
supersedes: []
follows: 0556
context: unit 0556 left Conrey's count on one named statement of the size of Conrey's function; this proves it, step two of the general-polynomial round of block S13 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S13 of `lean_stage3/design/stencil.md`, the general polynomial, step two. Is Conrey's function near zeta on the right edge, and of size at most a constant times the height on the small discs, for every polynomial with value one at zero, from some height on?

**What was proved.** `lean_stage3/Stage3/DigammaBound.lean`: `module_lines` 219 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 2 error lines; clean on build `builds` 7. The package builds at `jobs_package` 8965 jobs, the module at `jobs_module` 8825. Traps added, `traps_added` 4; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`DigammaBoundIdentity.lean`: `V_eq_sum_H`, Conrey's function at a point equal to a sum of derivatives, at that point, of zeta times the ratio of gamma factors to that point times an exponential that carries the shift of half the logarithm, by Leibniz's rule and the polynomial identity `poly_shift`; the shift leaves the function exactly. `DigammaBoundSize.lean`: the ratio of gamma factors bounded on small circles from the crude Stirling bound in the tree, and Cauchy's estimate for the derivatives. `right_edge_ge`: the real part of Conrey's function on the right edge at least a third from some height on. `disc_le`: its size on the small discs at most a constant times the height. `stmtVEdges_holds`: the named statement of unit 0556, for every polynomial with value one at zero. `conrey_count_window'` (pinned in the file, not listed here): Conrey's count on the windows of the top of the height, with no open hypothesis.

**A hypothesis added.** The polynomial's value at zero is one; the symmetry alone allows a constant polynomial too small for the right edge.

**Sizes.** No digamma bound was needed. The worker checked the ratio of gamma factors on the circles numerically: it stays flat in the height over six decades, so no factor grows.

**Who wrote it.** One worker, `files` 3 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 98 to `trap_last` 101.

What remains. The mean value with a general polynomial and the closed form.
