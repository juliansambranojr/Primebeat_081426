---
id: 0541
date: 2026-11-25
type: formalization
title: "swapped-term"
refs: [lean_stage3/Stage3/SwapX.lean::norm_Dk_le, lean_stage3/Stage3/SwapX.lean::iter_phi, lean_stage3/Stage3/SwapX.lean::phi_iter_le, lean_stage3/Stage3/SwapX.lean::logratio_le, lean_stage3/Stage3/SwapX.lean::g_sub_one, lean_stage3/Stage3/SwapX.lean::hder_of, lean_stage3/Stage3/SwapX.lean::decomp, lean_stage3/Stage3/SwapX.lean::S1_sharp, lean_stage3/Stage3/SwapX.lean::msq_young, lean_stage3/Stage3/SwapX.lean::size_X, lean_stage3/Stage3/SwapX.lean::c1Y_bound, lean_stage3/Stage3/SwapX.lean::Tp_g, lean_stage3/Stage3/SwapX.lean::E_bound, lean_stage3/Stage3/SwapX.lean::J_alg, lean_stage3/Stage3/SwapX.lean::stmtXAll_of, lean_stage3/Stage3/SwapX.lean::lemma3_resO_of_partsAll, lean_stage3/Stage3/SwapX.lean::lemma3_resO_of_mainO]
supersedes: []
follows: 0540
context: unit 0539 assembled Young's Lemma 3 with a little o error from the main term and the swapped term; this builds the swapped term, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the swapped term. Does the swapped term of the twisted moment equal the height's power times the first term with its shifts swapped, up to the height over its logarithm, for every mollifier shorter than the square root of the height?

**What was proved.** `lean_stage3/Stage3/SwapX.lean`: `module_lines` 1274 lines, `theorems_proved` 36 theorems, `defs` 10 definitions, `sorries` 0 sorries, `pins` 17 axiom pins. The first build had `errors_first` 9 error lines; clean on build `builds` 9. The package builds at `jobs_package` 8929 jobs, the module at `jobs_module` 8822. Traps added, `traps_added` 4; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`twist`, `iter_phi` and `phi_iter_le`: the twist of the height's power into the weight, a window bounded to every order. `decomp` and `J_alg`: the swapped term split into three first terms with twisted weights and a remainder. `S1_sharp` and `msq_young`: the pointwise size of the shifted sum and the mollifier. `size_X`: the remainder small for every length exponent below one half. `stmtXAll_of`: the swapped term with error the height over its logarithm, over the windows bounded to every order, from Stirling's formula with its phase, `StmtXStirling`, and the main term of unit 0540's route. `lemma3_resO_of_partsAll` and `lemma3_resO_of_mainO`: Young's Lemma 3 with a little o error from those two.

**Who wrote it.** One worker. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, the module and the package were rebuilt here, and each pin reads the standard axioms. The docstring route of `StmtX`, with the absolute value on the shifted sum, loses a power of the height; the worker used Young's route, the twist in the weight, and the sharper bounds `aY_bound'` and `S1_sharp`. Traps: TRAPS.md rows `trap_first` 59 to `trap_last` 62.

What remains. Stirling's formula with its phase, the arithmetic facts of the main term, the operator and the unsmoothing.
