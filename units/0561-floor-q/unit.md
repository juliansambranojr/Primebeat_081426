---
id: 0561
date: 2026-11-25
type: formalization
title: "floor-q"
refs: [lean_stage3/Stage3/FloorQ.lean::logmaxQ_le, lean_stage3/Stage3/FloorQ.lean::stepQ, lean_stage3/Stage3/FloorQ.lean::levinson_floorQ]
supersedes: []
follows: 0560
context: units 0556 to 0560 gave Conrey's count, the edges, the mean, the gamma ratio and the closed form for a general polynomial; this assembles them, the last step of the general-polynomial round of block S13 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S13 of `lean_stage3/design/stencil.md`, the general polynomial, the assembly. Are more than `kappa_q` 224/625 of the zeros of zeta up to every large height, less any fixed fraction, on the critical line?

**What was proved.** `lean_stage3/Stage3/FloorQ.lean`: `module_lines` 165 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 6 error lines; clean on build `builds` 9. The package builds at `jobs_package` 8982 jobs, the module at `jobs_module` 8885. Traps added, `traps_added` 4; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`FloorQGamma.lean`: the ratio of gamma factors far to the right, at an abscissa of the size of the logarithm, from the shift by two of the gamma factor and the bound near the line, so that Conrey's function is zeta plus a constant over the logarithm on the right edge and at most a constant times the height on the discs. `FloorQEdge.lean`: the edge terms for a function analytic only in the upper half plane. `FloorQWindow.lean`: `conrey_window_diff`, the Levinson window in difference form for any such function, from a count, Littlewood's lemma on its product with the mollifier and the mean. `FloorQCont.lean`: the mean carried across the abscissa strip by continuity. `FloorQStep.lean`: `floor_stepQ`, the floor on the window from half the height to the height for a general symmetric polynomial. `stepQ` and `levinson_floorQ`: at the cubic polynomials of unit 0560, length exponent forty-nine hundredths and shift three halves, the zeros on the line up to every large height at least `kappa_q` 224/625 less any fixed amount times all the zeros.

**A lost factor, caught and fixed.** The right edge sits at an abscissa of the size of the logarithm, beyond the bounds on the gamma ratio in the tree; the crude Stirling bound there would have lost the exponential of the logarithm times its own logarithm. The shift by two of the gamma factor carries the bound out at a bounded cost, and no factor is lost.

**Who wrote it.** One worker, `files` 6 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and the statement and axioms of `levinson_floorQ` were printed here. Traps: TRAPS.md rows `trap_first` 115 to `trap_last` 118.

What remains for stage B. Young's lemma at lengths of one half and more.
