---
id: 0397
date: 2026-11-22
type: formalization
title: "LandauZeroSide.lean: a zero of ζ forces the primes' integral above τ/r^(k+1) − C/R^k for some k in every long block; block 7b of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauZeroSide.lean::zero_side]
supersedes: []
follows: 0396
context: the second part of the assembly of the Landau window criterion, whose design is in the worksheet; unit 0396 bounded the primes' integral from above under a window bound; this unit bounds it from below from the presence of a zero
sealed: false
---

**Question.** Block `7b` of the Landau worksheet (`landau.md#7b`). Given a zero `ρ₀` of `ζ` and a real `σ₀ > 1` with `|σ₀ − ρ₀| < σ₀`, how small can the primes' integral `Ik σ₀ k` be?

**What was proved.** `module_lines` 300 lines, `theorems_proved` 1 theorem, `defs` 0 definitions, `private_lemmas` 1 private lemma, `pins` 1 axiom pin at `axioms` 3 axioms, `sorries` 0 sorries.

`zero_side`: under those hypotheses there are real numbers `r`, `R`, `τ`, `C₁` and a natural number `N₀`, with `σ₀ − 1 < r ≤ |σ₀ − ρ₀|`, `r < R`, `τ > 0`, `C₁ ≥ 0`, such that every block of at least `N₀` consecutive `k` holds one with `τ/r^(k+1) − C₁/R^k ≤ Ik σ₀ k / k!`.

The proof takes the zeros in a closed disc about `σ₀` inside the right half-plane, finitely many; `r` is the distance to the nearest, `P` the set of zeros at that distance, and a gap past them gives `R`. Unit `unit_disc` 0395 writes the `k`-th derivative of `Phi` at `σ₀` as the sum over `P` up to `k!·C/R^k`. With `z ρ = r/(σ₀ − ρ)` that sum is `(−1)^k·k!/r^(k+1)` times `S k = Σ (A ρ·z ρ)·(z ρ)^k`. `S k` is real: `P`, the residues and the `z ρ` are carried to themselves by complex conjugation, `σ₀` being real. The `z ρ` are unimodular and distinct, and `z ρ = 1` only for a real zero in the unit interval, whose residue is positive. Unit `unit_trig` 0392 then gives `S k ≥ τ` in every long block, and unit `unit_primes` 0396 identifies the derivative with `(−1)^k·Ik`.

**What is and is not here.** `r` exceeds `σ₀ − 1`, the rate of the trivial bound on the primes' integral, because every zero has real part below one. It is at most `|σ₀ − ρ₀|`, so a zero far to the right makes `r` small against `σ₀ − θ`, the rate of the window term. Those two comparisons are what the last part of the assembly turns into a contradiction; nothing here makes them.

`τ`, `C₁`, `N₀` are not explicit. They depend on `σ₀` and the zeros near it, and on nothing else.

**The build.** `errors_first` 5 error lines on the first build from `roots` 4 root causes and `cascade` 1 downstream pin. `builds` 6 builds. `hyps_dropped` 1 hypothesis was dropped: the sketch asked for `0 < Re ρ₀`, which follows from `|σ₀ − ρ₀| < σ₀`. `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8734 jobs, package at `jobs_package` 8788. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The scalar rate inequalities of the design, and then the criterion itself from the two bounds on `Ik`.
