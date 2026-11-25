---
id: 0549
date: 2026-11-25
type: formalization
title: "floor-step"
refs: [lean_stage3/Stage3/FloorStep.lean::combine, lean_stage3/Stage3/FloorStep.lean::floor_step]
supersedes: []
follows: 0548
context: units 0546 and 0547 gave the window in difference form and the sharp mean; this applies them on one window from half the height to the height, the one-height step of block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, one height. On the window from half the height to the height, are the zeros on the line at least one minus the logarithm of the main constant over the shift of all the zeros there, up to any fixed fraction of the height times its logarithm, from some height on?

**What was proved.** `lean_stage3/Stage3/FloorStep.lean`: `module_lines` 267 lines, `theorems_proved` 2 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 4 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8949 jobs, the module at `jobs_module` 8852. Traps added, `traps_added` 4; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`FloorStepCont.lean`: the window mean continuous in the abscissa and the two heights, and the bound carried from the mollifier's line to a strip to its left whose width depends on the height. `FloorStepSize.lean`: Young's coefficients cut to the mollifier's length, bounded by a constant and with first coefficient the polynomial's value at one; the abscissa of the right edge chosen so the tail distance is a fixed fraction of the error; the edge terms of the size of the fourth power of the logarithm; the count of zeros in the window at least the height times its logarithm over four pi less lower terms, by the Riemann and von Mangoldt bound in the tree. `combine`: the four error parts each at most a quarter of the allowed error. `floor_step`: for a polynomial vanishing at zero with value one at one, a length exponent between zero and one half and a positive shift, the difference of the line counts at the height and half of it at least one minus the logarithm of the larger of one and the main constant plus a fixed amount, over the shift, times the zeros in the window, less that amount times the height times its logarithm, from some height on.

**Sizes.** With only the smallest admissible abscissa the tail distance is near a quarter and the tail term is the size of the main term, a lost factor; the abscissa is chosen of the size of the logarithm, so the tail term is a fixed fraction of the error and the edge terms are of the fourth power of the logarithm.

**Who wrote it.** One worker, `files` 3 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 84 to `trap_last` 87.

What remains. The sum over halvings of the height, which gives the proportion.
