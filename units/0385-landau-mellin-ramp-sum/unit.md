---
id: 0385
date: 2026-11-22
type: formalization
title: "LandauMellin.lean: the Mellin transform of the ramp sum on Re s > 1; block 2 of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauMellin.lean::rampK_integral, lean_stage3/Stage3/LandauMellin.lean::rampK_integral_norm, lean_stage3/Stage3/LandauMellin.lean::mellin_rampSum]
supersedes: []
follows: 0384
context: unit 0384 stated the Landau window criterion as a leaf and planned its proof in slices; Julian asked on 2026-11-22 for the second, the place where the ramp sum of primes meets the logarithmic derivative of zeta
sealed: false
---

**Question.** Block `2` of the Landau worksheet (`landau.md#2`). For `Re s > 1`, is the Mellin transform of the ramp sum `Σ_{n ≤ y} Λ(n)(y/n − 1)` equal to `−ζ'/ζ(s)/(s(s−1))`, as a theorem of Stage 3?

**What was proved.** `module_lines` 222 lines, `theorems_proved` 5 theorems, `defs` 1 definition, `private_lemmas` 2 private lemmas, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

The definition is `rampK s n y`, the ramp kernel of one `n`: `max(y/n − 1, 0)·y^(−s−1)`. `rampK_integrable` and `rampK_integral`: for `Re s > 1` and `n ≥ 1` the kernel is integrable on `(1, ∞)` and its integral is `n^(−s)/(s(s−1))`. On that half-line the kernel is the indicator of `(n, ∞)` times a difference of powers of `y`, and Mathlib has each power integral. `rampK_integral_norm`: the integral of the kernel's norm is `n^(−σ)/(σ(σ−1))` with `σ = Re s`, read off the previous theorem at the real point `σ`. `rampSum_eq_tsum`: the finite sum that defines `LandauWindow.rampSum` is the sum over every `n`, the terms with `n > y` being zero.

`mellin_rampSum` is the block's theorem: for `Re s > 1`, `∫₁^∞ rampSum(y)·y^(−s−1) dy = −ζ'(s)/ζ(s)/(s(s−1))`. The sum over `n` and the integral change places because the integrals of the norms are summable, which is the absolute convergence of the L-series of `Λ` at `σ`; Mathlib has that series as `−ζ'/ζ`.

**What is and is not here.** This is an identity on the half-plane of absolute convergence, where nothing about zeros is visible. It is the bridge the later blocks cross: the left side is made of primes, the right side has its poles at the zeros. The transform of `G` itself, which subtracts the main terms, is block 2b and is not in this module. `StmtLandauWindow` is still a leaf; `slices_proved` 2 blocks of its worksheet are PROVED, this one and the statement of unit `unit_statement` 0384.

**The build.** `errors_first` 3 error lines on the first build from `roots` 1 root cause, a rewrite with the `RCLike` form of a lemma against a `Complex.ofReal` cast, and `cascade` 2 downstream pins. The scratch pass before the build caught `scratch_misses` 1 name that does not exist. `builds` 2 builds, `traps_added` 1 row (row `trap_row` 39), `assumed_pins` 0. Module at `jobs_module` 8656 jobs, package at `jobs_package` 8775. `steps_skipped` 1 step of the loop, the orient hook, as in unit 0380. Loop version `loop_version` 22.

What the next slice needs. Block 2b: the transform of `G`, from `mellin_rampSum` and the elementary integrals of `y·log y` and `y` against `y^(−s−1)`, each with its integrability, `rampSum`'s included (it follows from the summability used here). Then block 3, the poles.
