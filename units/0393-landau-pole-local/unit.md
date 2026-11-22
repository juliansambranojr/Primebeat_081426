---
id: 0393
date: 2026-11-22
type: formalization
title: "LandauPoleLocal.lean: Phi has a simple pole with residue m/(ρ(1−ρ)) at each zero of ζ and is regular at 1; block 3a of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauPoleLocal.lean::differentiableAt_Phi, lean_stage3/Stage3/LandauPoleLocal.lean::Phi_principal_part, lean_stage3/Stage3/LandauPoleLocal.lean::Phi_regular_at_one]
supersedes: []
follows: 0392
context: the Landau worksheet's plan reads the Taylor coefficients of the transform of G from the zeros of ζ; that needs the transform continued past Re s = 1 with its singularities named; Julian asked for block 3 on 2026-11-22 and the block was split into a local half and a global half
sealed: false
---

**Question.** Block `3a` of the Landau worksheet (`landau.md#3a`). As a formula, `Phi` makes sense wherever `ζ` does. What are its singularities at a zero of `ζ` and at `s = 1`?

**What was proved.** `module_lines` 166 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`differentiableAt_Phi`: `Phi` is differentiable at every `s` other than `0` and `1` where `ζ(s) ≠ 0`. `Phi_principal_part`: at a zero `ρ` of `ζ` other than `0` and `1`, of order `m`, there is a function `h` analytic at `ρ` with `Phi s = h s + m/(ρ(1−ρ))/(s−ρ)` near `ρ` and off it. `Phi_regular_at_one`: there is a function analytic at `1` that equals `Phi` near `1` and off it.

At a zero, `ζ` is `(s−ρ)^m` times an analytic function `g` with `g(ρ) ≠ 0`, so its logarithmic derivative is `m/(s−ρ)` plus `g'/g`; dividing by `s(s−1)` and expanding that factor at `ρ` leaves the stated simple pole and an explicit analytic rest. At `1`, `ζ(s) = ζ₁(s)/(s−1)` with Mathlib's entire `ζ₁`, whose value at `1` is one and whose derivative there is `γ`; then `Phi s = N(s)/(s(s−1))` with `N` analytic and `N(1) = 0`, and the quotient `N(s)/(s−1)` is a divided difference.

**What is and is not here.** The residue `m/(ρ(1−ρ))` is the coefficient the worksheet's size comparison uses; for a real zero in the unit interval it is positive. The regularity at `1` is where the main terms `y·log y` and `(1+γ)·y` that `G` subtracts pay off: the constant `γ` in `G` is exactly the one that cancels the simple pole.

This is local. That `Phi` minus its finitely many principal parts in a disc is analytic on the disc, and what that gives for the Taylor coefficients at a real point, is the other half of the block and is open. The module holds the formula `Phi`; that the formula is the Mellin transform of `G` is proved for `Re s > 1` only.

**The build.** `errors_first` 3 error lines on the first build from `roots` 1 root cause, a derivative of a power times a function restated in a form the rewrite did not match, and `cascade` 2 downstream. `builds` 2 builds, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8723 jobs, package at `jobs_package` 8784. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The disc: finitely many zeros in a closed disc inside the right half-plane, `Phi` minus their principal parts analytic there, and the Taylor coefficient at the centre as the poles' sum plus a remainder bounded by Cauchy's estimate.
