---
id: 0392
date: 2026-11-22
type: formalization
title: "LandauTrig.lean: a real sum of unimodular powers is at least a fixed positive amount somewhere in every long block; block 6 of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauTrig.lean::sum_block_ge, lean_stage3/Stage3/LandauTrig.lean::sum_sq_block_ge, lean_stage3/Stage3/LandauTrig.lean::exists_large_in_block]
supersedes: []
follows: 0391
context: the Landau worksheet's plan reads the Taylor coefficients of the transform from the zeros as a decaying factor times an oscillating real sum, and needs that sum positive and bounded away from zero for some index in every long range; the search of 2026-11-22 found the lemma in no tree; Julian asked for block 6 the same day
sealed: false
---

**Question.** Block `6` of the Landau worksheet (`landau.md#6`). Let `T(n) = Σ_j c_j·z_j^n` be real for every `n`, over finitely many distinct `z_j` of modulus one, with some `c_j ≠ 0` and nonnegative real part of the coefficient at `z_j = 1`. Is `T` at least a fixed positive amount somewhere in every long enough block of consecutive `n`?

**What was proved.** `module_lines` 228 lines, `theorems_proved` 5 theorems, `defs` 0 definitions, `private_lemmas` 1 private lemma, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`exists_large_in_block`: yes. There are `τ > 0` and `N₀` such that every block of at least `N₀` consecutive `n` holds an `n` with `T(n) ≥ τ`. With `B = Σ|c_j|` and `S = Σ|c_j|²` the witness is `τ = S/(tau_denominator·B)` with `tau_denominator` 4, and the blocks are those longer than `block_factor` 2 times `(E₂ + B·E₁)/S`, the `E`s being sums of reciprocal distances between frequencies.

It rests on three facts over a block. `sum_block_ge`: the sum of `T` is at least `−E₁`. `sum_sq_block_ge`: the sum of `T²` is at least the block's length times `S`, minus `E₂`. `abs_le_sum_norm`: `|T| ≤ B`. Each of the first two is a swap of sums and a geometric sum of a unimodular ratio (`norm_geom_Ico_le`). A `T` below `τ` on a whole block satisfies `T² ≤ B(2τ − T)` at each point, and summing contradicts the two bounds once the block is long.

**What is and is not here.** The worksheet had noted that the zeros nearest the expansion point come in conjugate pairs, whose frequencies `z` and `z̄` multiply to one and spoil a mean square computed as `T·T`. Computed as the squared modulus `T·T̄`, the cross term of two indices has ratio `z_j·z̄_l`, which is one only for equal frequencies. So the lemma asks for distinct frequencies and nothing about pairs.

`τ` and `N₀` depend on the coefficients and frequencies only; the block's position is free. The lemma is elementary and uses nothing about `ζ`.

**The build.** `errors_first` 3 error lines on the first build from `roots` 1 root cause and `cascade` 2 downstream pins. `builds` 2 builds, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8655 jobs, package at `jobs_package` 8783. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The poles of `Phi`: its meromorphic continuation to the right half-plane, the principal parts at the zeros, and the Taylor coefficient at a real point as the nearest poles' sum plus a remainder. Then the assembly.
