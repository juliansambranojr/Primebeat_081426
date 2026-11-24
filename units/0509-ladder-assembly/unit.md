---
id: 0509
date: 2026-11-24
type: formalization
title: "The ladder assembly: H and a tame top real part give the Riemann hypothesis"
refs: [lean_stage3/Stage3/LadderAssembly.lean::top_mode_on_frontier, lean_stage3/Stage3/LadderAssembly.lean::rh_of_ladder_tame]
supersedes: []
follows: 0508
context: the residue route of unit 0508 needed its edge condition and the assembly into the Riemann hypothesis; this is block S5 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S5 of `lean_stage3/design/stencil.md`. Does an attained top real part put its mode on the edge, and do H and a tame top together give the Riemann hypothesis?

**What was proved.** `lean_stage3/Stage3/LadderAssembly.lean`: `module_lines` 132 lines, `theorems_proved` 2 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8891 jobs, the module at `jobs_module` 8831. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`top_mode_on_frontier`: when one zero's real part bounds every real part, every point of the closure of the modes is at least the top mode's size, so the disc inside it is in the component of zero, and the top mode is on the component's frontier at every σ below the top.

`rh_of_ladder_tame`: H, and off the line a top zero that attains the largest real part with its mode isolated among the modes right of some σ above one half, give `RiemannHypothesis`, through the residue route of unit `unit_residue` 508.

**Who wrote it.** One worker, whose first build stopped on one unknown identifier. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. A top real part that is never attained, an attained top mode that other modes accumulate on, and H itself; the theorem takes them as hypotheses and proves none of them.
