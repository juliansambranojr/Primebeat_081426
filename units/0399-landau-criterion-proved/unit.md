---
id: 0399
date: 2026-11-22
type: formalization
title: "LandauCriterion.lean: the Landau window criterion is a theorem of Stage 3; a window bound on G at every θ above one half implies Mathlib's RiemannHypothesis; the window bound itself is not proved"
refs: [lean_stage3/Stage3/LandauCriterion.lean::contradiction, lean_stage3/Stage3/LandauCriterion.lean::stmtLandauWindow, lean_stage3/Stage3/LandauCriterion.lean::rh_of_windows]
supersedes: []
follows: 0398
context: unit 0384 stated the Landau window criterion as a named leaf, its shape read from the archive Alpöge released on 2026-11-20, and planned its proof in a worksheet; the units since proved the worksheet's blocks one at a time; this is the last block
sealed: false
---

**Question.** Block `7d` of the Landau worksheet (`landau.md#7d`). Is `StmtLandauWindow` true: if for arbitrarily large `Y` one has `G(y) ≤ C·y^θ` on all of `[Y, Y^(1+δ)]`, does `ζ` have no zero with real part above `θ`?

**What was proved.** `module_lines` 238 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`stmtLandauWindow : LandauWindow.StmtLandauWindow`. The criterion is a theorem. `rh_of_windows`: if for every `θ` strictly between one half and one there are `δ > 0` and `C` with `WindowBound θ δ C`, then Mathlib's `RiemannHypothesis` holds. `contradiction` is the core: the lower bound on the primes' integral that a zero forces and the upper bound that a window gives cannot both hold for `Y` large.

The proof of the leaf runs through `units_chain` 15 units and `modules_chain` 15 modules written for it, from the Mellin transform of the ramp sum to this one, each with no `sorry` and the standard axioms.

**What is and is not here.** THE HYPOTHESIS IS NOT PROVED. `rh_of_windows` is an implication. Its premise, a one-sided bound `G(y) ≤ C·y^θ` on windows `[Y, Y^(1+δ)]` for arbitrarily large `Y`, at every exponent above one half, is a statement about the primes that nothing in this repository proves or approaches. The Riemann hypothesis is not proved here. What is proved is that this particular statement about primes would imply it.

The premise is at least as hard as the conclusion: under the Riemann hypothesis `G(y)` is `O(√y)`, by the identity of unit 0383 (derived there and not formalized), which gives every such window; so the two are equivalent and the criterion is a reformulation. Unit 0383 measured `G` to `g_measured_to` 100000000 and found it where the known zeros put it; a finite range says nothing about arbitrarily large `Y`.

The criterion's shape was read from Alpöge's archive, which carries no licence; no code was taken from it, and of its proof only the statement, its definitions and a few lines calling its own window lemma were read. Whether the argument here is the archive's is not known. The archive states its criterion for families of Dirichlet characters; this one is for `ζ` alone.

`τ`, the block length and the constant of the remainder are obtained by compactness and are not explicit. The proof gives no quantitative zero-free region from a quantitative window.

**The build.** `errors_first` 6 error lines on the first build from `roots` 1 root cause, an arithmetic tactic that ran out of time on a linear goal, and `cascade` 5 downstream. `builds` 3 builds. `hyps_dropped` 1 hypothesis was dropped from `contradiction`. `traps_added` 1 row (row `trap_row` 45), `assumed_pins` 0. Module at `jobs_module` 8736 jobs, package at `jobs_package` 8790. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What remains. Nothing of the worksheet: every block is PROVED. Open by choice: making the constants explicit; the same criterion for Dirichlet `L`-functions; and the premise, which is the Riemann hypothesis in another form.
