---
id: 0573
date: 2026-11-26
type: formalization
title: "basin-chain"
refs: [lean_stage3/Stage3/BasinChain.lean::rh_of_noRightZeros, lean_stage3/Stage3/BasinChain.lean::defect_eventually_const, lean_stage3/Stage3/BasinChainCount.lean::noRightZeros_one_of_rh, lean_stage3/Stage3/BasinChainCount.lean::count_exact, lean_stage3/Stage3/BasinChainCount.lean::right_edge_le_arcsin, lean_stage3/Stage3/BasinChainSplit.lean::split_V, lean_stage3/Stage3/BasinChainAvg.lean::increment_avg, lean_stage3/Stage3/BasinChainAvg.lean::c0_lt_two]
supersedes: []
follows: 0571
context: the chain to the goal set out in the session, steps 3 to 5 with no right zeros as their one hypothesis, in block S15 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S15 of `lean_stage3/design/stencil.md`, the chain from no right zeros. With no zeros of V right of the line as the one hypothesis, do the count with no losses, Littlewood for the argument of V and Turing averaging prove the Riemann hypothesis?

**What was proved.** `lean_stage3/Stage3/BasinChain*.lean`: `module_lines` 1471 lines, `theorems_proved` 24 theorems, `defs` 5 definitions, `sorries` 0 sorries, `pins` 8 axiom pins. The first build had `errors_first` 4 error lines; clean on build `builds` 7. The package builds at `jobs_package` 9029 jobs, the module at `jobs_module` 8892. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`count_exact`: Conrey's count over a window with every size kept, the line count's increase bounded below by the turning of the horizon, the edge terms and twice the count of right zeros. `right_edge_le_arcsin`: on the line through three, V stays near one and its argument is bounded by an arcsine, which gives the constant `c0` 1.4546, below two by `margin` 0.545 (`c0_lt_two`). `split_V`: Littlewood's lemma for the argument of V. `increment_avg`: Turing's averaging over a window a quarter of the height long. `defect_eventually_const`: with no right zeros and the lower side of J, the defect is constant from some height on, so the zeros off the line are finitely many. `rh_of_noRightZeros`: the Riemann hypothesis, from those and the base. `noRightZeros_one_of_rh`: for Q equal to one the hypothesis follows from the Riemann hypothesis, so it is not vacuous.

**Open, as named statements.** `open_leaves` 2. `StmtVHorizLower`, the lower side of J, by the route of `horizLower_sharp`, with the gamma ratio extended to real parts from minus a third. `StmtNoFiniteDefect`, the base: the defect, once constant, is zero.

**The design finding.** V with the mollifier's logarithm set by T is controlled only on the window from a quarter of T to twice T, so every count is a difference of the defect at two heights, and the averaging removes the increments without seeing the defect itself. Constancy starts at a height whose log log exceeds `loglog_floor` 166, far past any finite check. The base needs a count over a fixed range; unit 0574 records that decision.

**Who wrote it.** One worker, `files` 4 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 149 to `trap_last` 150.

What remains. The lower side of J, and the base by a count over a fixed range.
