---
id: 0396
date: 2026-11-22
type: formalization
title: "LandauPrimeSide.lean: the primes' reading of the Taylor coefficients of Phi, bounded above by a window bound on G; block 7a of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauPrimeSide.lean::Ik_integrable, lean_stage3/Stage3/LandauPrimeSide.lean::iteratedDeriv_Phi_eq_Ik, lean_stage3/Stage3/LandauPrimeSide.lean::Ik_le]
supersedes: []
follows: 0395
context: every block of the Landau worksheet but the assembly was proved; Julian asked for block 7 on 2026-11-22; its design was written into the worksheet first and split into parts, of which this is the first
sealed: false
---

**Question.** Block `7a` of the Landau worksheet (`landau.md#7a`). Given a bound `G(y) ≤ C·y^θ` on one window `[Y, Y^(1+δ)]`, how large can the `k`-th Taylor coefficient of `Phi` at a real `σ > 1` be, read from the primes?

**What was proved.** `module_lines` 183 lines, `theorems_proved` 3 theorems, `defs` 1 definition, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

The definition is `Ik σ k`, the real integral over `(1, ∞)` of `G(y)·(log y)^k·y^(−σ−1)`. `Ik_integrable`: its integrand is integrable for `σ > 1`. `iteratedDeriv_Phi_eq_Ik`: for real `σ > 1` the `k`-th derivative of `Phi` at `σ` is `(−1)^k·Ik σ k`. `Ik_le`: under the window bound, with `C ≥ 0`, `Y ≥ 1`, `θ < σ`, and any `b > 0` and `0 < b' < σ − 1`, `Ik σ k` is at most the sum of `terms` 3 terms: `C·k!/(σ−θ)^(k+1)` from the window, `bound_constant` 8 times `Y^b·k!/(σ−1+b)^(k+1)` from below it, and the same constant times `(Y^(1+δ))^(−b')·k!/(σ−1−b')^(k+1)` from above it.

**What is and is not here.** The kernel `(log y)^k·y^(−σ−1)` is nonnegative, so an upper bound on `Ik` needs only upper bounds on `G`: the window bound on the window, and `G(y) ≤ 8y` everywhere else. No absolute value of `G` and no logarithm enter, which is why the two tail terms carry the bare kernel.

The window bound is a hypothesis of `Ik_le` for one window. Nothing here says such a window exists.

The assembly's design is in the worksheet, in `subblocks` 4 parts. This is the first. The others are the zeros' reading from below, the scalar rate inequalities, and the proof of the criterion; `StmtLandauWindow` is a leaf until the last.

**The build.** `errors_first` 8 error lines on the first build from `roots` 3 root causes and `cascade` 5 downstream. `builds` 4 builds, `traps_added` 1 row (row `trap_row` 44), `assumed_pins` 0. Module at `jobs_module` 8676 jobs, package at `jobs_package` 8787. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The zeros' reading from below: the nearest zeros to a real centre, their sum made real by the symmetry under conjugation, and the lemma on exponential sums applied to it.
