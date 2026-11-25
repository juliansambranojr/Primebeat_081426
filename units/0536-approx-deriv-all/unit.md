---
id: 0536
date: 2026-11-25
type: formalization
title: "Every order: the weight is smooth in the height with Young's bounds on all its derivatives, and integration by parts any number of times"
refs: [lean_stage3/Stage3/ApproxDerivAll.lean::ibp_iter_chain, lean_stage3/Stage3/ApproxDerivAll.lean::ibp_iter, lean_stage3/Stage3/ApproxDerivAll.lean::hasDerivAt_tauK_line, lean_stage3/Stage3/ApproxDerivAll.lean::norm_tauK_le, lean_stage3/Stage3/ApproxDerivAll.lean::dYk_hasDerivAt, lean_stage3/Stage3/ApproxDerivAll.lean::dYk_contDiff, lean_stage3/Stage3/ApproxDerivAll.lean::iteratedDeriv_dY, lean_stage3/Stage3/ApproxDerivAll.lean::dY_contDiff, lean_stage3/Stage3/ApproxDerivAll.lean::dYk_bound, lean_stage3/Stage3/ApproxDerivAll.lean::dY_iter_bound, lean_stage3/Stage3/ApproxDerivAll.lean::leib_bound, lean_stage3/Stage3/ApproxDerivAll.lean::gY_contDiff, lean_stage3/Stage3/ApproxDerivAll.lean::gY_iter_succ, lean_stage3/Stage3/ApproxDerivAll.lean::gY_iter_bound, lean_stage3/Stage3/ApproxDerivAll.lean::VYk_hasDerivAt, lean_stage3/Stage3/ApproxDerivAll.lean::VYk_line_bound, lean_stage3/Stage3/ApproxDerivAll.lean::VYk_lines, lean_stage3/Stage3/ApproxDerivAll.lean::iteratedDeriv_VY_all, lean_stage3/Stage3/ApproxDerivAll.lean::VY_contDiff, lean_stage3/Stage3/ApproxDerivAll.lean::VY_iter_bound]
supersedes: []
follows: 0535
context: decision unit 0535 found that two integrations by parts close the off-diagonal of the twisted moment only for short mollifiers, and decided to integrate by parts as many times as the length requires; this is the bounds for every order, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, every order. Is the weight of the approximate functional equation smooth in the height, with every derivative bounded as Young states, and can one integrate by parts any number of times?

**What was proved.** `lean_stage3/Stage3/ApproxDerivAll.lean`: `module_lines` 1013 lines, `theorems_proved` 43 theorems, `defs` 7 definitions, `sorries` 0 sorries, `pins` 20 axiom pins. The first build had `errors_first` 2 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8912 jobs, the module at `jobs_module` 8812. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`ibp_iter` and `ibp_iter_chain`: integration by parts any number of times, against a function whose derivatives below that order vanish at the ends. `dY_contDiff` and `dY_iter_bound`: the digamma difference is smooth in the height, and each derivative times the height to one more than its order is at most an explicit constant times one plus the size of the real part, times a power of one plus the size of the imaginary part, from the termwise series. `VY_contDiff` and `VY_iter_bound`: the weight is smooth in the height, and every derivative, times the height to its order, decays like any negative power of one plus the argument over the height, from differentiation under the integral to every order and Leibniz's rule on the gamma ratio.

**Who wrote it.** One worker, whose builds stopped on a set name, a partially applied simp and a too-deep gcongr. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The smooth window's derivatives to every order, the off-diagonal summed for every length below the square root of the height, the diagonal, the swapped term, the operator and the unsmoothing.
