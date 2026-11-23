---
id: 0464
date: 2026-11-23
type: formalization
title: "The explicit formula at every height from x = 2"
refs: [lean_stage3/Stage3/ExplicitTwo.lean::residue_identity_two, lean_stage3/Stage3/ExplicitTwo.lean::edge_horizontal_bound_two, lean_stage3/Stage3/ExplicitTwo.lean::explicit_formula_left_two, lean_stage3/Stage3/ExplicitTwo.lean::left_edge_bound_two, lean_stage3/Stage3/ExplicitTwo.lean::explicit_formula_all_two]
supersedes: []
follows: 0463
context: unit 0460 proved the explicit formula at every height for a point at least sixteen; unit 0463 lowered the floor of Perron's formula under it; this is block G2 of `lean_stage3/design/floor.md`
sealed: false
---

**Question.** Block G2 of `lean_stage3/design/floor.md`. Does the explicit formula hold at every height for every point from the first doubling up?

**What was proved.** `lean_stage3/Stage3/ExplicitTwo.lean`: `module_lines` 1137 lines, `theorems_proved` 12 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 3 error lines; clean on build `builds` 6. The package builds at `jobs_package` 8854 jobs, the module at `jobs_module` 8741. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`explicit_formula_all_two`: for a point at least `floor_new` 2 and every height at least `floor_new` 2, the Chebyshev function less the point plus the sum over the zeros below the height is at most the constant `c1t` times the point times the square of the logarithm of point times height over the height, plus `c3t` times the logarithm of the point, plus `Bleft2` over the fourth root of the point. The height has no cap and the point's floor is the first doubling. The tree's theorem asked the point to be at least `floor_old` 16.

`residue_identity_two`, `edge_horizontal_bound_two`, `explicit_formula_left_two`, `left_edge_bound_two`: the residue identity, the horizontal edges, the formula with the left edge kept, and the left edge, each from the same floor. The module's `noncomputable_defs` 4 constants are explicit; `Bleft2` is `edge_factor` 4 times the `Bleft` of unit 0460.

How. Each lemma of the chain is copied with the point's floor lowered. The residue identity and the swap of heights used only that the point exceeds the unit. On the horizontal edges the abscissa can now pass two, where the tree's bound on the logarithmic derivative at a good height did not reach; there the logarithmic derivative is at most `logderiv_cap` 6 in size (`logDeriv_re_ge_two`), and that fits under the tree's bound because its constant is at least `cpn_floor` 360 (`Cpn_ge`). The absorption of the constant term uses the logarithm of the base in place of two. The left edge's constants were defined with the logarithm of the old floor, which is `edge_factor` 4 times the logarithm of the new.

**Who wrote it.** An Opus worker, from a brief with the inventory of every use of the floor. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package. No proved file was edited.

**What it says.** The explicit formula now holds at every doubling of the table from the first, and at every height. The old theorem stays beside it with its smaller constants for points from `floor_old` 16.

What remains. The cells at the lowest rows and the count's passage still read the old theorem and its floor; they can now be restated on this one. Numerals above `c1t` and `c3t` are not computed.
