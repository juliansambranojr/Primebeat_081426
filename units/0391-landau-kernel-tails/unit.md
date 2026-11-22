---
id: 0391
date: 2026-11-22
type: formalization
title: "LandauTail.lean: the kernel's integral below Y and above Z, each bounded by a shift of the exponent; block 4b of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauTail.lean::lower_tail_le, lean_stage3/Stage3/LandauTail.lean::upper_tail_le]
supersedes: []
follows: 0390
context: the Landau worksheet's plan uses the window bound on G only on a window and needs the rest of the Mellin integral small; the search of 2026-11-22 found a tail bound for the kernel in no tree; Julian asked for block 4b the same day
sealed: false
---

**Question.** Block `4b` of the Landau worksheet (`landau.md#4b`). How large is the integral of `(log y)^k·y^(−a−1)` over `(1, Y]` and over `(Z, ∞)`, against its total `k!/a^(k+1)`?

**What was proved.** `module_lines` 125 lines, `theorems_proved` 2 theorems, `defs` 0 definitions, `private_lemmas` 1 private lemma, `pins` 2 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`lower_tail_le`: for `a > 0`, `b > 0` and `Y ≥ 1`, the integral over `(1, Y]` is at most `Y^b·k!/(a+b)^(k+1)`. `upper_tail_le`: for `0 < b < a` and `Z ≥ 1`, the integral over `(Z, ∞)` is at most `Z^(−b)·k!/(a−b)^(k+1)`. Each is one pointwise comparison and the whole integral of unit `unit_total` 0389 at a shifted exponent: below `Y` a factor `y^b` is traded for `Y^b`, above `Z` a factor `y^(−b)` for `Z^(−b)`.

**What is and is not here.** The parameter `b` is free in both theorems. The sketch asked for an explicit `e^(−cδ²k)`; that comes from choosing `b` once the window and the index `k` are tied together, which is the assembly's business. The block's Sizes line does that choice by hand, for a window `[Y, Y^(1+δ)]` with `δ` at most one and `k + 1 = a(1+δ/2)·log Y`: the ratio of the lower tail to the total is at most `exp(−a·log Y·δ²/rate_below)` with `rate_below` 12, and of the upper tail `exp(−a·log Y·δ²/rate_above)` with `rate_above` 48. Those two rates are a hand computation in the worksheet, checked numerically on a grid in the session and proved nowhere in Lean yet.

Nothing in these bounds grows with `k` beyond the total itself.

**The build.** `errors_first` 0 error lines and `warnings_first` 2 warnings on the first build, one deprecated name used in both theorems, replaced. `builds` 2 builds, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8656 jobs, package at `jobs_package` 8782. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The trigonometric lemma and the poles of `Phi`, independent of each other; then the assembly, which chooses `b` and proves the two rates.
