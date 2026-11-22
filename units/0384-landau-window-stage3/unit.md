---
id: 0384
date: 2026-11-22
type: formalization
title: "LandauWindow.lean: the window criterion as a named statement, and RiemannHypothesis from it and a one-sided bound on primes; slice 1 of 7, the criterion itself still a leaf"
refs: [lean_stage3/Stage3/LandauWindow.lean::zeta_neg_nat_ne_zero, lean_stage3/Stage3/LandauWindow.lean::rh_of_zeroFree_half, lean_stage3/Stage3/LandauWindow.lean::zeroFree_half_of_window, lean_stage3/Stage3/LandauWindow.lean::rh_of_window]
supersedes: []
follows: 0383
context: the archive Alpöge released on 2026-11-20 ends its analytic argument with a criterion turning a one-sided bound on a smoothed von Mangoldt sum, on long windows, into a zero-free half-plane; Julian asked on 2026-11-22 for that criterion to be formalized in Stage 3 from scratch; the archive has no licence, so nothing is copied and the proof is planned independently
sealed: false
---

**Question.** Block `1` of the Landau worksheet (`landau.md#1`). Stated for `ζ` alone and in Stage 3's own terms, what is the criterion, and what does it give once it is granted?

**What was proved.** `module_lines` 175 lines, `theorems_proved` 4 theorems, `defs` 4 definitions, `pins` 4 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

The definitions are the statement. `rampSum y` is `Σ_{n ≤ y} Λ(n)(y/n − 1)`, `G y` removes its main terms `y log y − (1+γ)y`, and `WindowBound θ δ C` says `G(y) ≤ C·y^θ` on all of `[Y, Y^(1+δ)]` for arbitrarily large `Y`: a statement about primes and nothing else. `StmtLandauWindow` is the criterion: a window bound at `θ` gives no zero of `ζ` with real part above `θ`.

`zeta_neg_nat_ne_zero`: `ζ` does not vanish at a nonpositive integer other than a trivial zero. `rh_of_zeroFree_half`: no zero with real part above one half implies Mathlib's `RiemannHypothesis`, by the functional equation. `zeroFree_half_of_window` and `rh_of_window`: the criterion, together with a window bound at every `θ` between one half and one, implies `RiemannHypothesis`.

**What is and is not here.** The criterion itself is a leaf. This module proves what surrounds it, so the chain reads: a one-sided bound on `G` on long windows, then the leaf, then `RiemannHypothesis`. The leaf's proof is planned in the worksheet in `slices_total` 7 slices, of which `slices_proved` 1 is this one and `slices_open` 6 are SKETCH: the Mellin transform of the ramp sum, the poles of the transform and its Taylor coefficients, the kernel on and off the window, a crude bound on `G`, a lemma on trigonometric polynomials, and the assembly. The plan is this worksheet's own; of the archive only the statement, its definitions and the short proof that calls its own window lemma were read, `archive_steps` 5 steps down from its main theorem.

The hypothesis `WindowBound` at every `θ` above one half is the whole arithmetic content. Nothing in this tree proves it or approaches it. Unit `unit_measure` 0383 measured `G` and found it where the zeros put it.

**The build.** `errors_first` 4 error lines on the first build from `roots` 1 root cause, a cosine lemma that exists for real arguments and not complex ones, and `cascade` 3 downstream pins; `warnings_first` 2 warnings, both removed. `builds` 2 builds, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8655 jobs, package at `jobs_package` 8774. `steps_skipped` 2 steps of the loop, as in unit 0380. Loop version `loop_version` 22.

What remains. Slices two to seven of `lean_stage3/design/landau.md`, which discharge the leaf. The third, the pole structure of the transform, is the largest; the sixth is elementary and stands alone.
