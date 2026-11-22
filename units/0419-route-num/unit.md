---
id: 0419
date: 2026-11-22
type: formalization
title: "RouteNum.lean, with EdgeNum.lean and GlueNum.lean: the explicit-formula route at the gate with every constant a definition, and a numeral above each"
refs: [lean_stage3/Stage3/RouteNum.lean::relErrWindow_route_num, lean_stage3/Stage3/RouteNum.lean::c1n_le, lean_stage3/Stage3/RouteNum.lean::c4n_le]
supersedes: []
follows: 0418
context: block E7 proved a numeral for every quantity under the route's constants, and the theorems producing those constants still said there exists; Julian said to go on to the restatement, 2026-11-22
sealed: false
---

**Question.** Block E8 of `lean_stage3/design/joints.md`. With the existence steps replaced, does the route's theorem state a constant that is a definition, and is that constant under a numeral?

**What was proved.** Three modules, `sorries` 0 sorries among them, every pinned statement at `axioms` 3 axioms.

`lean_stage3/Stage3/EdgeNum.lean`, `edge_lines` 715 lines, `edge_theorems` 6 theorems, `edge_pins` 3 pins, clean on build `edge_builds` 2: the partial fraction, the ball count and the edge bound with constants `C1n`, `C2n`, `Cen`.

`lean_stage3/Stage3/GlueNum.lean`, `glue_lines` 1262 lines, `glue_theorems` 13 theorems, `glue_pins` 6 pins, clean on build `glue_builds` 1: the band count, the swap, the good-height bound, the horizontal edge, the left edge and the truncated explicit formula, with constants `Csn`, `Cpn`, `Chn`, `Dln` and the formula's three, `c1n`, `c3n`, `c4n`. The left edge calls the bound of unit 0418 where the original called compactness.

`lean_stage3/Stage3/RouteNum.lean`, `module_lines` 285 lines, `theorems_proved` 14 theorems, `defs` 1 definition, `pins` 4 pins, clean on build `builds` 1 with `errors_first` 0 errors: the route and the numerals.

In all, `copies` 9 proofs are existing ones with the existence step replaced by the named constant; no existing module was changed. The package builds at `jobs_package` 8805 jobs, the last module at `jobs_module` 8765. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`relErrWindow_route_num`: under RH, for every floor of at least `floor_min` 16 and every window of rows whose bottom row is above the floor squared, the rows of the prime count satisfy the gate's relative-error statement against the table tree's main term, with relative error `routeConst` at that floor times the logarithm of the top row times two to the power minus half the bottom row. `routeConst` is a definition: three times `floorConstSplit` at the three named constants, plus thirteen. The statement has no existential.

The numerals: the edge constant is at most `cen_le` 1911393; the explicit formula's three constants are at most `c1n_le` 88216610000, `c3n_le` 15 and `c4n_le` 6468930000.

**What it settles.** The constant of the route is a closed expression the kernel has bounded. Unit 0410 priced the route with floors on these three; the figures here are ceilings, proved, and of the same size.

**What it is not.** Unconditional: RH is the hypothesis. A statement about the table: the gate is in the other tree, joined by the weld. And the gate itself has not been run on these numerals in Lean; unit 0410's pricing used a script's gate.

What remains. The pricing rerun on the proved ceilings. On the map, the direction from the table to the zeros.
