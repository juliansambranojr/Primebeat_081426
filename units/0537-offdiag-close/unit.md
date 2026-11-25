---
id: 0537
date: 2026-11-25
type: formalization
title: "The off-diagonal closes: smooth windows to every order, and the off-diagonal of the twisted moment small for every mollifier below the square root"
refs: [lean_stage3/Stage3/OffDiagClose.lean::phi_iter_bdd, lean_stage3/Stage3/OffDiagClose.lean::winY_iter_le, lean_stage3/Stage3/OffDiagClose.lean::weightAll_exists, lean_stage3/Stage3/OffDiagClose.lean::VY_iter_bound0, lean_stage3/Stage3/OffDiagClose.lean::Fw_iter_bound, lean_stage3/Stage3/OffDiagClose.lean::offdiag_term_iter, lean_stage3/Stage3/OffDiagClose.lean::offdiag_term_iter_young, lean_stage3/Stage3/OffDiagClose.lean::decay_trade, lean_stage3/Stage3/OffDiagClose.lean::off_term_iter_le, lean_stage3/Stage3/OffDiagClose.lean::offSum_bound_iter, lean_stage3/Stage3/OffDiagClose.lean::aY_bound, lean_stage3/Stage3/OffDiagClose.lean::logpow_le, lean_stage3/Stage3/OffDiagClose.lean::Tpow_le, lean_stage3/Stage3/OffDiagClose.lean::final_size, lean_stage3/Stage3/OffDiagClose.lean::stmtOffDiag_holds]
supersedes: []
follows: 0536
context: decision unit 0535 asked for integration by parts as many times as the mollifier length requires; unit 0536 gave the weight's derivatives to every order; this builds the smooth windows to every order and closes the off-diagonal, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the window and the off-diagonal. Are there smooth windows with every derivative bounded, and does the off-diagonal of the twisted moment then have the size Levinson's method needs for every mollifier shorter than the square root of the height?

**What was proved.** `lean_stage3/Stage3/OffDiagClose.lean`: `module_lines` 1101 lines, `theorems_proved` 44 theorems, `defs` 9 definitions, `sorries` 0 sorries, `pins` 15 axiom pins. The first build had `errors_first` 7 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8913 jobs, the module at `jobs_module` 8813. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`WeightAll` and `weightAll_exists`: windows made of two rescaled smooth steps, with every derivative bounded by a constant over the window's slope to its order, the constants independent of the height and its logarithm. `offdiag_term_iter` and `offdiag_term_iter_young`: each off-diagonal term of the twisted moment, bounded with an even number of integrations by parts. `offSum_bound_iter`: their sum. `stmtOffDiag_holds`: for every length exponent below one half, the off-diagonal is at most a constant times the height over its logarithm, with the number of integrations chosen from the exponent, stated as `StmtOffDiagAll` over windows whose constants are fixed before the height, as Young's are.

**Who wrote it.** One worker, whose builds stopped on an unknown constant, rewrites on unreduced lambdas, a rewrite of the wrong term, a cast against a set name and a power rewritten inside. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The diagonal main term, the swapped term, the operator and the unsmoothing.
