---
id: 0400
date: 2026-11-22
type: formalization
title: "JointWindowDial.lean: a window bound on G at θ gives the dial's zero-free statement and its bounds on ψ and π; joint 1 of SECTIONS.md"
refs: [lean_stage3/Stage3/JointWindowDial.lean::zeroFreeRight_of_window, lean_stage3/Stage3/JointWindowDial.lean::psiWeakTheta_of_window, lean_stage3/Stage3/JointWindowDial.lean::schoenfeldWeakTheta_of_window]
supersedes: []
follows: 0399
context: unit 0399 proved the Landau window criterion as a section by itself; SECTIONS.md then laid the three Lean trees out as sections and joints, and found the criterion's outlet unconnected to the dial that carries a zero-free half-plane to the prime count; Julian said go on joint 1 on 2026-11-22
sealed: false
---

**Question.** Block `1` of the joints worksheet (`joints.md#1`), joint `joint` 1 of `joints_total` 10 in `SECTIONS.md`. Does the outlet of the Landau window section fit the inlet of the dial?

**What was proved.** `module_lines` 65 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`zeroFreeRight_of_window`: for `0 < θ < 1` and `δ > 0`, `WindowBound θ δ C` gives `Stage3.StmtZeroFreeRight θ`. `psiWeakTheta_of_window`: for `θ` in `[1/2, 1)` it gives `C'` and `x₀` with `|ψ(t) − t| ≤ C'·t^θ·log³t` for `t ≥ x₀`. `schoenfeldWeakTheta_of_window`: it gives `C'` and `x₀` with `|π(x) − Li(x)| ≤ C'·x^θ·log²x` for `x ≥ x₀`.

It fits with no adapter. The dial's inlet is the weaker statement, the criterion's conclusion with one more hypothesis, so each theorem is one application of unit `unit_criterion` 0399 followed by a theorem the dial already had.

**What is and is not here.** No mathematics is added. What changes is that the Landau section is no longer free-standing: a window bound on `G` now reaches a bound on the prime count's residual inside one tree, checked by the kernel.

The window bound is a hypothesis and is proved nowhere. `C'` and `x₀` are the dial's own and are existential, so the bound carries no number yet.

The table is three joints further on: the residual bound read at the dyadic points, the logarithm absorbed, and the statement carried across the two toolchains.

**The build.** `errors_first` 0 error lines on the first build, `builds` 1 build, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8743 jobs, package at `jobs_package` 8791. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The bound on `π − Li` at exponent `θ` carried to the dyadic rows, as `weakWindow_of_global` does for the square-root family.
