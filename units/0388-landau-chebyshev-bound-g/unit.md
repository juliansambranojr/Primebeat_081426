---
id: 0388
date: 2026-11-22
type: formalization
title: "LandauChebyshev.lean: G(y) ≤ 8y and |G(y)| ≤ 8y(1 + log y) for y ≥ 1; block 5b of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauChebyshev.lean::rampSum_le_log, lean_stage3/Stage3/LandauChebyshev.lean::G_le, lean_stage3/Stage3/LandauChebyshev.lean::abs_G_le_log]
supersedes: []
follows: 0387
context: unit 0387 bounded G with one more logarithm than the sketch asked for and named the factor; Julian asked for the sharper bound on 2026-11-22
sealed: false
---

**Question.** Block `5b` of the Landau worksheet (`landau.md#5b`). Is `|G(y)|` at most a constant times `y(1 + log y)` for `y ≥ 1`, with the constant explicit?

**What was proved.** `module_lines` 117 lines, `theorems_proved` 4 theorems, `defs` 0 definitions, `private_lemmas` 1 private lemma, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`rampSum_le_log`: for `y ≥ 1` the ramp sum is at most `y·(log y + log 4 + 4)`. Each ramp is at most `y/n`, and the sum of `Λ(n)/n` up to `y` is `log y` plus an error that upstream's Mertens module bounds above by `log 4 + 4`. `G_le`: `G(y)` is at most `bound_constant` 8 times `y`. `neg_le_G`: `G(y) ≥ −y·log y`. `abs_G_le_log`: `|G(y)|` is at most the same constant times `y(1 + log y)`.

**What is and is not here.** The upper bound on `G` has no logarithm: the `y·log y` that `G` subtracts cancels the main term of the ramp sum. The logarithm in the two-sided bound comes from below only, where the ramp sum was bounded by zero. This removes the extra factor unit `unit_crude` 0387 carried; that unit's theorem stays in the tree and is implied by this one for large `y`.

The window criterion asks for `G(y) ≤ C·y^θ` with `θ` below one, on long windows. `G(y) ≤ 8y` is that inequality at `θ = 1`, where the criterion says nothing: `ζ` has no zero to the right of one already.

Stage 3 imports upstream's `IEANTN/Mertens.lean` here for the first time. The pins show the standard axioms only.

**The build.** `errors_first` 0 error lines on the first build, `builds` 1 build, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8670 jobs, package at `jobs_package` 8779. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The exchange of a power series with the Mellin integral of `G`, and the tail off the window, take `abs_G_le_log`. The poles of `Phi` and the trigonometric lemma do not depend on it.
