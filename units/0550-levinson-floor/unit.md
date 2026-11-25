---
id: 0550
date: 2026-11-25
type: formalization
title: "levinson-floor"
refs: [lean_stage3/Stage3/FloorSum.lean::K_ge_one, lean_stage3/Stage3/FloorSum.lean::step_X, lean_stage3/Stage3/FloorSum.lean::N_ge, lean_stage3/Stage3/FloorSum.lean::levinson_floor]
supersedes: []
follows: 0549
context: unit 0549 gave Levinson's floor on one window and unit 0548 the constant; this sums the windows over the halvings of the height, the last step of block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the sum. Are at least a third of the zeros of zeta up to every large height, less any fixed fraction, on the critical line?

**What was proved.** `lean_stage3/Stage3/FloorSum.lean`: `module_lines` 194 lines, `theorems_proved` 6 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8951 jobs, the module at `jobs_module` 8857. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`FloorSumTele.lean`: the telescoping of a one-window inequality over the halvings of the height, the errors summing to at most twice one window's, and the floor from it for a nonnegative count against a monotone one. `K_ge_one`: Levinson's constant at the chosen parameters is at least one, so the larger of one and the constant plus a small amount is that amount above the constant. `step_X`: the one-window floor at Levinson's polynomial, length exponent and shift, with the constant's logarithm over the shift at most two thirds plus a small amount. `N_ge`: the zeros up to the height at least the height times its logarithm over `N_lower` 1/20, from the Riemann and von Mangoldt bound in the tree. `levinson_floor`: for every fixed amount, from some height on, the zeros on the critical line up to the height at least one third less that amount times all the zeros up to the height.

**What this is.** A positive proportion of the zeros of zeta on the critical line, `kappa_proved` 1/3, in Lean with the standard axioms. The line count and the zero count are the two sides of `rh_iff_line_count`.

**Sizes.** The window errors sum to twice the top window's, with no factor of the number of windows; the zero count's lower bound is half its true size and suffices.

**Who wrote it.** One worker, `files` 2 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and the statement and axioms of `levinson_floor` were printed here. No new trap.

What remains. Stage B, the proportion toward one, and stage C, no defect at any height.
