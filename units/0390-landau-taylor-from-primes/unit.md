---
id: 0390
date: 2026-11-22
type: formalization
title: "LandauTaylor.lean: every derivative of Phi on Re s > 1 is an integral of G against a power of log y; block 2c of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauTaylor.lean::mellinLog_hasDerivAt, lean_stage3/Stage3/LandauTaylor.lean::iteratedDeriv_Phi, lean_stage3/Stage3/LandauTaylor.lean::mellinLog_real]
supersedes: []
follows: 0389
context: the Landau worksheet's plan reads the Taylor coefficients of the transform of G at a real point in two ways, from the primes and from the zeros; the worksheet check of 2026-11-22 found that no block proved the first reading; Julian asked for block 2c the same day
sealed: false
---

**Question.** Block `2c` of the Landau worksheet (`landau.md#2c`). On `Re s > 1`, is the `k`-th derivative of `Phi` the integral over `(1, ∞)` of `G(y)·(−log y)^k·y^(−s−1)`?

**What was proved.** `module_lines` 181 lines, `theorems_proved` 4 theorems, `defs` 1 definition, `private_lemmas` 2 private lemmas, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

The definition is `mellinLog k s`, that integral. `mellinLog_integrable`: its integrand is integrable for `Re s > 1`. `mellinLog_hasDerivAt`: for `Re s > 1` the derivative of `mellinLog k` at `s` is `mellinLog (k+1) s`. `iteratedDeriv_Phi`: for `Re s > 1` and every `k`, the `k`-th derivative of `Phi` at `s` is `mellinLog k s`. `mellinLog_real`: at a real `σ` the integral is `(−1)^k` times the real integral of `G(y)·(log y)^k·y^(−σ−1)`.

The derivative passes under the integral sign by domination on a disc around `s`: `|G(y)|` is at most `bound_constant` 8 times `y(1 + log y)`, so the integrand's derivative is at most a sum of the kernels whose integrability the previous unit proved. The induction on `k` uses that `Phi` and `mellinLog 0` agree on the open half-plane.

**What is and is not here.** The sketch planned a power series and uniqueness of coefficients. The route built is one differentiation under the integral and an induction, which needed nothing new from Mathlib and built with `errors_first` 0 errors.

This is the reading from the primes: at a real `σ₀ > 1` the Taylor coefficient of `Phi` is, up to sign and `k!`, a real integral of `G` against `(log y)^k y^(−σ₀−1)`. A one-sided bound on `G` on a window bounds part of that integral from one side. The reading from the zeros, and the smallness of the integral off the window, are other blocks and are open.

**The build.** `errors_first` 0 error lines and `warnings_first` 1 warning on the first build: the hypothesis `1 < σ` on `mellinLog_real` was unused, the two integrands agreeing pointwise. `hyps_dropped` 1 hypothesis was dropped from the statement and from the block. `builds` 2 builds, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8674 jobs, package at `jobs_package` 8781. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The tail of the kernel off the window, the trigonometric lemma, and the poles of `Phi`; none of the three depends on another.
