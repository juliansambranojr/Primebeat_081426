---
id: 0389
date: 2026-11-22
type: formalization
title: "LandauKernel.lean: the integral of (log y)^k y^(−a−1) over (1, ∞) is k!/a^(k+1); block 4a of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauKernel.lean::log_pow_le, lean_stage3/Stage3/LandauKernel.lean::log_pow_integrable, lean_stage3/Stage3/LandauKernel.lean::log_pow_integral]
supersedes: []
follows: 0388
context: the Landau worksheet reads the Taylor coefficients of the transform of G as integrals against powers of log y; the search of 2026-11-22 found the exact integral of that kernel in no tree; Julian asked for block 4a the same day
sealed: false
---

**Question.** Block `4a` of the Landau worksheet (`landau.md#4a`). For `a > 0` and every natural `k`, is `∫₁^∞ (log y)^k·y^(−a−1) dy` equal to `k!/a^(k+1)`, with the integrand integrable?

**What was proved.** `module_lines` 165 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `private_lemmas` 3 private lemmas, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`log_pow_integral`: for `a > 0`, the integral over `(1, ∞)` of `(log y)^k·y^(−a−1)` is `k!/a^(k+1)`. Induction on `k`. The function `−(log y)^(k+1)·y^(−a)/a` vanishes at one, tends to zero at infinity, and its derivative is the next kernel minus `(k+1)/a` times the present one; so each integral is `(k+1)/a` times the one before. `log_pow_integrable`: every one of these kernels is integrable. `log_pow_le`: for `y ≥ 1`, `(log y)^n` is at most `y^(a/2)` over a constant depending on `a` and `n`, which is what gives the integrability and the limit.

**What is and is not here.** This is the Gamma integral `∫₀^∞ u^k e^(−au) du` written in the variable `y = e^u`, proved without changing variables because no lemma in the trees does that substitution. It generalizes the first power of the logarithm, done with complex exponent in unit `unit_log` 0386, to every power at a real exponent.

It is the whole integral. The part of it away from `log y = k/a`, which the plan needs small, is the worksheet's next half of this block and is not here.

**The build.** `errors_first` 3 error lines on the first build from `roots` 2 root causes and `cascade` 1 downstream pin. `builds` 2 builds, `traps_added` 1 row (row `trap_row` 43), `assumed_pins` 0. Module at `jobs_module` 8655 jobs, package at `jobs_package` 8780. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The Taylor coefficients of the transform of `G` from the primes: with this integral and the bound `|G(y)| ≤ 8y(1 + log y)` the power series in `s − σ₀` converges absolutely under the integral sign. The tail of this integral off the window is separate and is new analysis.
