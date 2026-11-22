---
id: 0386
date: 2026-11-22
type: formalization
title: "LandauMellinG.lean: the Mellin transform of G on Re s > 1 is Phi; block 2b of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauMellinG.lean::rampSum_mellin_integrable, lean_stage3/Stage3/LandauMellinG.lean::log_cpow_integral, lean_stage3/Stage3/LandauMellinG.lean::mellin_G]
supersedes: []
follows: 0385
context: unit 0385 proved the transform of the ramp sum and split the transform of G off as block 2b; Julian said go on 2026-11-22 after the worksheet check
sealed: false
---

**Question.** Block `2b` of the Landau worksheet (`landau.md#2b`). For `Re s > 1`, is the Mellin transform of `G`, the function the window criterion bounds, equal to `−ζ'/ζ(s)/(s(s−1)) − 1/(s−1)² + (1+γ)/(s−1)`?

**What was proved.** `module_lines` 264 lines, `theorems_proved` 6 theorems, `defs` 1 definition, `private_decls` 5 private declarations, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

The definition is `Phi`, the right-hand side above. `mellin_G`: for `Re s > 1`, `∫₁^∞ G(y)·y^(−s−1) dy = Phi s`. `G_mellin_integrable`: the integrand is integrable there.

The pieces. `log_cpow_integrable` and `log_cpow_integral`: `log y · y^(−s)` is integrable on `(1, ∞)` with integral `1/(s−1)²`, by an explicit primitive that tends to zero. `rampSum_mellin_integrable`: the ramp sum's integrand is integrable. Its proof uses unit `unit_ramp` 0385's value at the real point `σ = Re s`: that integral is `L(Λ,σ)/(σ(σ−1))`, which is not zero (`LSeries_vonMangoldt_real_ne_zero`: the real part is a sum of nonnegative terms and the term at two is positive), and a Bochner integral that is not zero is the integral of an integrable function. At `s` the norm of the integrand is the same as at `σ`.

**What is and is not here.** Still an identity on `Re s > 1`. It puts the function of the criterion on one side and a function whose poles in the strip are the zeros of `ζ` on the other; the double pole and the simple pole at `s = 1` that `Phi` subtracts are the main terms `y·log y` and `(1+γ)·y` that `G` subtracts. Nothing here continues `Phi` past the line or reads a pole. `StmtLandauWindow` is still a leaf.

**The build.** `errors_first` 6 error lines on the first build from `roots` 3 root causes and `cascade` 3 downstream pins. `builds` 2 builds, `traps_added` 3 rows (rows `trap_first` 40 to `trap_last` 42), `assumed_pins` 0. Module at `jobs_module` 8657 jobs, package at `jobs_package` 8776. `steps_skipped` 2 steps of the loop: the orient hook, and the scratch pass, whose absence is where the first root came from. Loop version `loop_version` 22.

What the next slice needs. Block 5, the crude bound `|G(y)| ≤ A·y·(log y + 1)`, which block 2c needs before it can exchange the power series with the integral; block 3, the poles of `Phi`, is independent of both and can be built in parallel.
