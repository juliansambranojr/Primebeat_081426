---
id: 0446
date: 2026-11-23
type: formalization
title: "DirichletMean.lean: the mean value of a finite Dirichlet sum, stage one of the zero-density bound"
refs: [lean_stage3/Stage3/DirichletMean.lean::dirichlet_mean_value_window, lean_stage3/Stage3/DirichletMean.lean::dirichlet_mean_value, lean_stage3/Stage3/DirichletMean.lean::dirichlet_mean_value_sigma]
supersedes: []
follows: 0445
context: joint 10 with infinitely many zeros off the line needs a zero-density bound with a power saving, which the tree and its upstream package do not prove; Julian said on 2026-11-23 to prove it here; `lean_stage3/design/carlson.md` splits it into seven blocks, this being the first
sealed: false
---

**Question.** Block C1 of `lean_stage3/design/carlson.md`. How large is the mean square of a finite Dirichlet sum over a stretch of heights?

**What was proved.** `lean_stage3/Stage3/DirichletMean.lean`: `module_lines` 349 lines, `theorems_proved` 13 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8838 jobs, the module at `jobs_module` 8655. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`dirichlet_mean_value`: take any finite list of complex coefficients, one for each integer up to a bound, and form the sum of each coefficient times its integer to an imaginary power. The integral of the squared size of that sum over a stretch of heights is at most the length of the stretch, plus `constant` 8 times the bound times one plus its logarithm, all times the sum of the squared sizes of the coefficients. `dirichlet_mean_value_window` is the same on any window. `dirichlet_mean_value_sigma` is the same with a real part in the exponent, where each coefficient carries its integer to minus twice the real part.

How. The square is expanded into a double sum. The diagonal gives the length. Off the diagonal each integral is at most twice the reciprocal of the gap between two logarithms, the gap is at least the difference of the integers over the bound, and the harmonic sum closes the row sums.

**Who wrote it.** An Opus worker, from a brief with the statement and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it is for.** It turns a bound on coefficients into a bound on a mean square along a vertical line. Block C4 applies it to the product of zeta's finite sum with a short sum of the Möbius function.

What remains. Blocks C2 to C7 of the design.
