---
id: 0415
date: 2026-11-22
type: formalization
title: "RouteGate.lean: the explicit-formula route at the gate's statement with the real-zero bucket at zero and the main term in the table tree's form"
refs: [lean_stage3/Stage3/RouteGate.lean::relErrWindow_route]
supersedes: []
follows: 0414
context: units 0413 and 0414 proved two leaves of the route, the main term at the rows and the emptiness of the real-zero bucket, without substituting them; Julian agreed to the substitution now and the remaining bounds as a draft, 2026-11-22
sealed: false
---

**Question.** Block E6 of `lean_stage3/design/joints.md`. With the two leaves put in, what does the route state at the gate?

**What was proved.** `lean_stage3/Stage3/RouteGate.lean`: `module_lines` 69 lines, `theorems_proved` 1 theorem, `defs` 0 definitions, `sorries` 0 sorries, `pins` 1 axiom pin at `axioms` 3 axioms, clean on build `builds` 1 with `errors_first` 0 errors. The package builds at `jobs_package` 8799 jobs, the module at `jobs_module` 8759. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`relErrWindow_route`: under RH there are three non-negative constants such that, for every floor of at least `floor_min` 16 and every window of rows whose bottom row is above the floor squared, the rows of the prime count satisfy the gate's relative-error statement against the main term written as two over the logarithm of two plus the integral from one to the row. The relative error is three times `floorConstSplit` plus thirteen, times the logarithm of the top row, times two to the power minus half the bottom row, and `floorConstSplit` is taken with the band's numerals `band_b1` 112 and `band_b3` 698 and with zero where the real-zero bucket stood.

**What it is for.** The main term in this statement is, from `Interpolant.liRow_eq`, the table tree's `liRow` at the rows. So this theorem's conclusion is the hypothesis of `Interpolant.tableFrom_ne_zero_of_relErr_liRow`, whose conclusion is that a cell of the table is not zero. Between the two stands the weld on `StmtRelErrWindow` and nothing else: no interpolant is assumed and no main term is named two ways.

**What it is not.** RH is a hypothesis. The three constants are existential. The value at zero of the logarithmic derivative, proved a number in unit 0413, is not substituted: it sits inside one of the three, and exposing it means a further copy of the explicit formula's proof for a term that unit 0410 priced at a hundred-thousandth.

What remains. The three bounds on zeta in a bounded region, as a design first.
