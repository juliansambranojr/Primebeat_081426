---
id: 0394
date: 2026-11-22
type: formalization
title: "LandauPoleSub.lean: finitely many simple poles subtracted on an open set, and the Taylor coefficients up to a Cauchy remainder; block 3b1 of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauPoleSub.lean::iteratedDeriv_inv_sub, lean_stage3/Stage3/LandauPoleSub.lean::exists_differentiableOn_sub_poles, lean_stage3/Stage3/LandauPoleSub.lean::taylor_coeff_sub_poles]
supersedes: []
follows: 0393
context: unit 0393 gave the local form of Phi at each zero; the global half of block 3 needs a general statement about a function with finitely many simple poles, which the search of 2026-11-22 found only inside a Stage 3 proof about rectangles; Julian asked for 3b the same day and it was split again
sealed: false
---

**Question.** Block `3b1` of the Landau worksheet (`landau.md#3b1`). For a function with finitely many simple poles on an open set, each with a known residue, are its Taylor coefficients at a regular point the poles' contributions up to a remainder controlled by Cauchy's estimate?

**What was proved.** `module_lines` 157 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries. Nothing in the module mentions `ζ`.

`iteratedDeriv_inv_sub`: the `k`-th derivative of `(s − q)^(−1)` at `c` is `(−1)^k·k!·(c − q)^(−1−k)`. `exists_differentiableOn_sub_poles`: if `f` is differentiable on a set `U` off a finite set `P` and has at each `p` in `P` a local form `h + A p/(s − p)` with `h` analytic at `p`, then some `g` differentiable on `U` equals `f` minus the sum of the `A q/(s − q)` off `P`. `taylor_coeff_sub_poles`: with `U` open containing the closed disc of centre `c` and radius `R`, and `c` outside `P`, there is a `C` such that for every `k` the `k`-th derivative of `f` at `c` differs from the poles' sum by at most `k!·C/R^k`.

**What is and is not here.** The gluing is the construction inside Stage 3's residue theorem for rectangles, copied with the rectangle replaced by a set; it is now a theorem of its own. `C` is a bound for `g` on the circle and does not depend on `k`, so the remainder has the exponential rate of the radius `R`, and the poles inside the disc are accounted for exactly.

**The build.** `errors_first` 4 error lines on the first build from `roots` 2 root causes and `cascade` 2 downstream pins; `warnings_first` 1 warning, an unused hypothesis: `hyps_dropped` 1 hypothesis, the openness of `U` in the gluing theorem, was dropped from the statement and the block. `builds` 2 builds, `traps_added` 0 rows, `assumed_pins` 1: the block named Cauchy's estimate without its namespace. Module at `jobs_module` 8655 jobs, package at `jobs_package` 8785. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. This with `f = Phi`, `P` the zeros of `ζ` in a disc together with the point one, and the residues of unit 0393.
