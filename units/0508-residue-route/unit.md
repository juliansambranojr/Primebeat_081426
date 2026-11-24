---
id: 0508
date: 2026-11-24
type: formalization
title: "The residue route: an isolated mode on the edge of the small disc contradicts H"
refs: [lean_stage3/Stage3/ResidueRoute.lean::isolated_boundary_mode_false]
supersedes: []
follows: 0507
context: the ladder route was open at the input H and at the arrangement of the modes; Julian started the assembly loop; this is block S4 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S4 of `lean_stage3/design/stencil.md`. Under the dyadic bound H, can a zero right of σ have its mode isolated among the modes and on the edge of the region around zero that the modes leave open?

**What was proved.** `lean_stage3/Stage3/ResidueRoute.lean`: `module_lines` 558 lines, `theorems_proved` 15 theorems, `defs` 5 definitions, `sorries` 0 sorries, `pins` 1 axiom pins. The first build had `errors_first` 7 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8891 jobs, the module at `jobs_module` 8826. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`isolated_boundary_mode_false`: under H, for σ close enough to the top real part, a zero right of σ whose mode is isolated in the closure of the modes and lies on the frontier of the component of zero in the small disc less those modes gives False. The bound on the power sums comes from the attained part at the lowest level and the density tail; it makes G analytic in the small disc; G equals the pole sum near zero and on the whole component by the identity theorem; at the isolated mode the pole sum has a nonzero residue, the fibre weight of `AliasClass`, which the analytic G cannot have.

**Where it differs from the design.** The component is taken inside the small disc, where G is known analytic; the design named the component of the whole complement. The choice of σ is an existential threshold, as in `CountEuler`.

**Who wrote it.** One worker, whose first build stopped on two unknown identifiers, a timeout and two unsolved goals. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and the pin reads the standard axioms.

What remains. The modes that accumulate, and H itself; nothing here proves them.
