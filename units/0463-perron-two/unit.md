---
id: 0463
date: 2026-11-23
type: formalization
title: "Perron's truncated formula from x = 2"
refs: [lean_stage3/Stage3/PerronTwo.lean::far_terms_sum_two, lean_stage3/Stage3/PerronTwo.lean::near_diagonal_sum_two, lean_stage3/Stage3/PerronTwo.lean::kernel_sum_bound_two, lean_stage3/Stage3/PerronTwo.lean::explicit_formula_perron_two]
supersedes: []
follows: 0462
context: unit 0460 proved the explicit formula at every height for a doubling at least sixteen; the chain under it was read lemma by lemma for every use of that floor; this is block G1 of `lean_stage3/design/floor.md`
sealed: false
---

**Question.** Block G1 of `lean_stage3/design/floor.md`. Does Perron's truncated formula hold from the first doubling up, with explicit constants?

**What was proved.** `lean_stage3/Stage3/PerronTwo.lean`: `module_lines` 1157 lines, `theorems_proved` 10 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8853 jobs, the module at `jobs_module` 8670. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`explicit_formula_perron_two`: for a point at least `floor_new` 2 and a height at least `floor_new` 2, the Chebyshev function differs from the truncated integral of the logarithmic derivative of zeta on the line just right of the unit by at most `main_const` 700 times the point times the square of the logarithm of point times height over the height, plus `log_const` 18 times the logarithm of the point. The tree's theorem asked the point to be at least `floor_old` 16 and had `main_const_old` 600 and `log_const_old` 13.

`far_terms_sum_two`, `near_diagonal_sum_two`, `kernel_sum_bound_two`: the three sums the formula rests on, from the same floor.

How. The floor entered the tree's proof through the abscissa, which is the unit plus the reciprocal of the logarithm of the point. Above the old floor it is at most two; from the new floor it is at most `abscissa_cap_num` 5 over `abscissa_cap_den` 2. That changes a factor near the diagonal and a lower bound in the far terms, and each is met with a larger numeral. The remaining lemmas carried the old floor in their statements and used only that the point exceeds the unit; they are copied with that hypothesis.

**Who wrote it.** An Opus worker, from a brief with the inventory of every use of the floor. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package. `Stage3/PerronKernel.lean` is unchanged.

**What it says.** Nothing in Perron's formula needed the point to be large. The floor of `floor_old` 16 was a convenience of the constants.

What remains. Block G2: the contour from the same floor, ending in the explicit formula at every height for every point from `floor_new` 2.
