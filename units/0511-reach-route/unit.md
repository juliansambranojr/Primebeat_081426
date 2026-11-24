---
id: 0511
date: 2026-11-24
type: formalization
title: "Reached modes: a mode approached non-tangentially from zero contradicts H"
refs: [lean_stage3/Stage3/ReachRoute.lean::reached_mode_false, lean_stage3/Stage3/ReachRoute.lean::reach_of_isolated]
supersedes: []
follows: 0510
context: unit 0510 left two arrangements open on the ψ route, a wall and a crowded mode on the edge; Julian chose the crowded mode; this is block S6 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S6 of `lean_stage3/design/stencil.md`. Under the dyadic bound H, can a zero right of σ have its mode reached from zero inside the open region along points that stay non-tangential to every other mode?

**What was proved.** `lean_stage3/Stage3/ReachRoute.lean`: `module_lines` 269 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 5 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8892 jobs, the module at `jobs_module` 8827. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`reached_mode_false`: under H, a zero right of σ whose mode is approached inside the component of zero by points whose distance to the mode is bounded by a constant times their distance to every other mode gives False. Along those points the pole sum times the distance tends to the mode times the weight of its fibre, by dominated convergence with the summable weights; the analytic G sends the same product to zero; the fibre weight has positive real part. The other modes may accumulate at the mode.

`reach_of_isolated`: a mode isolated in the closure of the modes and on the frontier of the component has such an approach, with the constant one. `isolated_boundary_mode_false'`: the residue route of unit `unit_residue` 508 follows, so this unit holds it.

**Who wrote it.** One worker, whose first build stopped on an ambiguous name and a rewrite. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. A mode that every approach from zero meets tangentially to the other modes; a limit set that walls the modes off from zero; H itself. Nothing here proves them.
