---
id: 0450
date: 2026-11-23
type: formalization
title: "DirichletMeanW.lean: the mean value of a finite Dirichlet sum with each term charged its own index; the repair of stage one"
refs: [lean_stage3/Stage3/DirichletMeanW.lean::dirichlet_mean_value_weighted, lean_stage3/Stage3/DirichletMeanW.lean::dirichlet_mean_value_weighted_sigma]
supersedes: []
follows: 0449
context: unit 0449 found that block C1 of `lean_stage3/design/carlson.md` charges the length of the sum to every term and that block C4 then loses the saving; block C1b is the repair
sealed: false
---

**Question.** Block C1b of `lean_stage3/design/carlson.md`. Can the mean square of a finite Dirichlet sum be bounded with each coefficient charged its own index in the place of the length of the sum?

**What was proved.** `lean_stage3/Stage3/DirichletMeanW.lean`: `module_lines` 258 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8841 jobs, the module at `jobs_module` 8656. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`dirichlet_mean_value_weighted`: the integral over a window of heights of the squared size of a finite Dirichlet sum is at most the sum, over the terms, of the squared coefficient times the length of the window plus `row_const` 6 times the term's own index times one plus the logarithm of the length of the sum. `dirichlet_mean_value_weighted_sigma` is the same with a real part in the exponent.

How. The double sum and the bound on each integral are those of unit 0446. The symmetrising step is weighted by the index: of each pair the cost is shared in the ratio of the two indices. The gap between two logarithms is bounded below with the larger index in the denominator.

**Who wrote it.** An Opus worker, from a brief with the statement and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package. `ring_lines` 2 lines were changed here to the tree's rule for `ring` after `field_simp`.

**What it repairs.** Unit 0449. A long sum with coefficients that fall off is now charged what its terms cost, and block C4 keeps the saving.

What remains. Blocks C4 to C7 of the design.
