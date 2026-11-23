---
id: 0447
date: 2026-11-23
type: formalization
title: "Mollified.lean: the product of zeta's finite sum with a short Möbius sum, and the size of its coefficients; stage two of the zero-density bound"
refs: [lean_stage3/Stage3/Mollified.lean::prod_eq_sum, lean_stage3/Stage3/Mollified.lean::sum_coef_sq_le, lean_stage3/Stage3/Mollified.lean::sum_coef_sq_weighted_le]
supersedes: []
follows: 0446
context: the second of the seven blocks of `lean_stage3/design/carlson.md`, the zero-density bound Julian asked on 2026-11-23 to have proved here; block C1 is unit 0446
sealed: false
---

**Question.** Block C2 of `lean_stage3/design/carlson.md`. Multiply zeta's finite sum by a short sum of the Möbius function. What are the coefficients of the product, and how large are they in mean square?

**What was proved.** `lean_stage3/Stage3/Mollified.lean`: `module_lines` 311 lines, `theorems_proved` 12 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8839 jobs, the module at `jobs_module` 8655. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`prod_eq_sum`: the finite sum of zeta up to a bound, times the sum of the Möbius function over the integers below a second bound, each term with its integer to minus the exponent, is one finite sum with coefficient `coef` at each integer. `coef_one`: the coefficient at one is one. `coef_eq_zero`: it is zero at every integer above one that is below both bounds. So the product is one plus a tail that starts at the second bound.

`abs_coef_le`: a coefficient is at most the number of divisors below the second bound. `sum_tauBelow_sq_le`, `sum_coef_sq_le`: the squares of those, summed over the integers up to any point, are at most that point times the cube, power `log_power` 3, of one plus the logarithm of the second bound. The proof sends a pair of divisors to its greatest common divisor and the two quotients, and never uses that the divisor function is multiplicative.

`sum_coef_sq_weighted_le`: for a real part above one half, the squared coefficients weighted by the integer to minus twice the real part, summed from the second bound on to any point, are at most a constant depending on the real part, times the second bound to one minus twice the real part, times the same cube. The constant is `weight_num` 2 over one minus two to that same exponent. The sum is cut into dyadic blocks and is a geometric series.

**Who wrote it.** An Opus worker, from a brief with the statements and the routes. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it is for.** With unit 0446 it bounds the mean square, along a vertical line right of one half, of the product less one, by the weighted sum here. That is block C4, once block C3 has replaced zeta by its finite sum.

What remains. Blocks C3 to C7 of the design.
