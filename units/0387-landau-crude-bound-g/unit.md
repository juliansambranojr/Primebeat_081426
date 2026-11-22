---
id: 0387
date: 2026-11-22
type: formalization
title: "LandauCrude.lean: |G(y)| ≤ 2y(1 + log y)² for y ≥ 1; block 5 of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauCrude.lean::rampSum_nonneg, lean_stage3/Stage3/LandauCrude.lean::rampSum_le, lean_stage3/Stage3/LandauCrude.lean::abs_G_le]
supersedes: []
follows: 0386
context: the Landau worksheet's plan bounds the Mellin integral of G off the window and exchanges a power series with it, and both need a bound on G that holds everywhere; Julian asked for block 5 on 2026-11-22
sealed: false
---

**Question.** Block `5` of the Landau worksheet (`landau.md#5`). What bound on `G` holds for every `y ≥ 1`, proved from what the tree already has?

**What was proved.** `module_lines` 113 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `private_lemmas` 1 private lemma, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`rampSum_nonneg`: the ramp sum is nonnegative. `rampSum_le`: for `y ≥ 1` it is at most `y·log y·(1 + log y)`. Each `Λ(n)` is at most `log n`, hence at most `log y`; each ramp is at most `y/n`; the reciprocals up to `y` sum to at most `1 + log y`. `abs_G_le`: for `y ≥ 1`, `|G(y)|` is at most `bound_constant` 2 times `y` times `(1 + log y)` to the power `bound_power` 2.

**What is and is not here.** The sketch asked for `A·y·(1 + log y)`, which is what Chebyshev's bound on `ψ` gives. This bound has one more factor `(1 + log y)`. The block's Sizes line names the factor and where it lands: in the tail integral it is one more power of the variable, a factor polynomial in the Taylor index, against a gap between two exponential rates that the plan keeps strict. The size comparison of the plan does not move. The sharper bound would cost a summation by parts and is not used anywhere the worksheet reaches.

This is an upper bound on `|G|` of the trivial order. It says nothing about the window bound, which asks for `G(y) ≤ C·y^θ` with `θ` below one.

**The build.** `errors_first` 2 error lines on the first build from `roots` 1 root cause, a name for the positivity of `γ` that does not exist, and `cascade` 1 downstream pin. `builds` 2 builds, `traps_added` 0 rows, `assumed_pins` 1: the block named that constant's lemma wrongly and was corrected. Module at `jobs_module` 8656 jobs, package at `jobs_package` 8777. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass; the scratch pass would have caught the name. Loop version `loop_version` 22.

What the next slice needs. Block 2c, the Taylor coefficients of the transform as integrals against powers of `log y`, now has its bound. The poles of `Phi` and the trigonometric lemma do not depend on it.
