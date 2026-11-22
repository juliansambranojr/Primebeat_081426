---
id: 0427
date: 2026-11-22
type: formalization
title: "PiToPsi.lean: from the count back to psi; RH is the square-root bound on pi minus Li"
refs: [lean_stage3/Stage3/PiToPsi.lean::RH_iff_schoenfeldWeak, lean_stage3/Stage3/PiToPsi.lean::psiWeak_of_schoenfeldWeak]
supersedes: []
follows: 0426
context: Julian asked, 2026-11-22, for the sentence "RH holds if and only if the residual in every cell stays at square-root size as the table continues"; the tree carried a bound from psi to the count and nothing back
sealed: false
---

**Question.** Block T5 of `lean_stage3/design/joints.md`, first part. Does the square-root bound on the count against `Li` give back the bound on `ψ`, so that the Riemann hypothesis is equivalent to a statement about the count itself?

**What was proved.** `lean_stage3/Stage3/PiToPsi.lean`: `module_lines` 313 lines, `theorems_proved` 12 theorems, `defs` 1 definition, `sorries` 0 sorries, `pins` 5 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 26 error lines from two roots; clean on build `builds` 3. The package builds at `jobs_package` 8825 jobs, the module at `jobs_module` 8734. One trap added, `traps_added` 1, row `trap_row` 48; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`Li_mul_log_sub_integral`: `Li x · log x − ∫ Li t / t = x` from two on, by the fundamental theorem on `Li · log`. `theta_sub_id_eq`: upstream's Abel summation for `θ` in terms of the count, with that identity taken off, leaves `θ x − x` as the count's residual times `log x` minus the integral of the relative residual.

`psiWeak_of_schoenfeldWeak`: the bound on the count's residual at square-root size and one logarithm gives the bound on `ψ` at exponent `k_psi` 3, `logs_added` 2 logarithms more. `RH_of_schoenfeldWeak` and `RH_iff_schoenfeldWeak`: with `VonKoch.RH_iff_psiWeak` and the route that unit 0409 opened, the Riemann hypothesis holds exactly when some constant and some starting point make the square-root bound on the count true.

What the next slice needs: `RH_iff_schoenfeldWeak`, read in the cells of the table.
