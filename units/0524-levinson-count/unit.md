---
id: 0524
date: 2026-11-24
type: formalization
title: "Levinson's counting lemma: zeros off the line are paid for by the zeros of zeta plus its derivative to the right"
refs: [lean_stage3/Stage3/LevinsonCount.lean::G_analyticOnNhd_rect, lean_stage3/Stage3/LevinsonCount.lean::levinson_count]
supersedes: []
follows: 0523
context: units 0519 to 0523 built the pieces of step 1 of block S11 of `lean_stage3/design/stencil.md`; this assembles them into Levinson's counting lemma
sealed: false
---

**Question.** Step 1 of block S11 of `lean_stage3/design/stencil.md`, assembled. Do the zeros of zeta between two heights lie on the line, except for at most two for each zero of zeta plus a multiple of its derivative to the right of the line, and a logarithmic error?

**What was proved.** `lean_stage3/Stage3/LevinsonCount.lean`: `module_lines` 185 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8901 jobs, the module at `jobs_module` 8807. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`levinson_count`: for a multiple between zero and one and heights from four, where zeta plus that multiple of its derivative has no zero on the border of the rectangle from one half to three, and the real factor of the line identity has no zero along the line, the zeros of zeta up to the upper height that lie on the line are at least the zeros between the two heights, less twice the zeros of the perturbed function in the rectangle, less seventy-two times the logarithm of the upper height plus a constant. It chains the continuous argument, the split, the argument principle, the three size bounds and the crossing count. `G_analyticOnNhd_rect` gives the analyticity the argument principle needs, since the rectangle stays away from the pole.

**Who wrote it.** One worker, whose first build was clean. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. Removing the two avoidance hypotheses, bounding the zeros of the perturbed function by a mean square, and the mean value itself; nothing here proves the hypothesis.
