---
id: 0451
date: 2026-11-23
type: formalization
title: "MollifiedMean.lean: the mean square of zeta times the mollifier, less one, on a vertical line; stage four of the zero-density bound"
refs: [lean_stage3/Stage3/MollifiedMean.lean::sum_coef_sq_up_le, lean_stage3/Stage3/MollifiedMean.lean::mean_sq_main_le, lean_stage3/Stage3/MollifiedMean.lean::mean_sq_f_le]
supersedes: []
follows: 0450
context: the fourth of the blocks of `lean_stage3/design/carlson.md`; it assembles the repaired mean value of unit 0450, the mollified sum of unit 0447 and the finite sum for zeta of unit 0448
sealed: false
---

**Question.** Block C4 of `lean_stage3/design/carlson.md`, with block C2b inside it. How large is the mean square, along a vertical line right of one half, of zeta times a short sum of the Möbius function, less one?

**What was proved.** `lean_stage3/Stage3/MollifiedMean.lean`: `module_lines` 485 lines, `theorems_proved` 12 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 6 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8842 jobs, the module at `jobs_module` 8679. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`mean_sq_f_le`: for a real part above one half and at most two, an order of at least two, a Möbius sum of length at least two and at most the length of zeta's finite sum, and a height below that length by the order and three, the integral from height one to the height of the squared size of the function is at most `outer_const` 3 times a sum of `terms` 4 terms. The first is the height times the Möbius length to one minus twice the real part, with logarithms. The second is `second_const` 24 times logarithms times the product of the two lengths to two minus twice the real part, or one if that is larger. The third is the square of the Möbius length times zeta's length to two minus twice the real part. The fourth is the Euler–Maclaurin error: the height, the square of the Möbius length, a constant of the order squared, zeta's length to minus twice the real part, and a factor that is bounded once the order is high.

`sum_coef_sq_up_le` is block C2b: the squared coefficients of the mollified sum weighted by the index to one minus twice the real part, summed to a point, are at most `up_const` 4 times logarithms times the point to two minus twice the real part, or one. `mean_sq_main_le` is the first two terms, from unit 0450.

How. Zeta is its finite sum, less the smooth term, plus the error of unit 0448. Times the Möbius sum and less one, the first part is a Dirichlet sum starting at the Möbius length (unit 0447), and its mean square is charged term by term. The Möbius sum itself is bounded by its length.

**Who wrote it.** An Opus worker, from a brief with the decomposition and the shape of the four terms. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it says.** With the Möbius length a small power of the height and zeta's length a small power above the height, each of the four terms is below the first power of the height. That is the saving.

What remains. Blocks C5 to C7: zeros from this mean square, the bound, and the joint on the zeros read back from the cells.
