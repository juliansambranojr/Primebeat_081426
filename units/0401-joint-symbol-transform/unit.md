---
id: 0401
date: 2026-11-22
type: formalization
title: "JointSymbol.lean: differencing G along the doublings multiplies its transform by the symbol, and at each zero the pole is reweighted by the symbol to the power of the depth; joint 9a of SECTIONS.md"
refs: [lean_stage3/Stage3/JointSymbol.lean::mellin_dd_iter, lean_stage3/Stage3/JointSymbol.lean::dd_iter_rule, lean_stage3/Stage3/JointSymbol.lean::symPhi_principal_part]
supersedes: []
follows: 0400
context: the table's tree proves that one difference along the rows multiplies a single mode by the symbol, and that a finite sum of modes is reweighted mode by mode; no row of primes is a finite sum of modes; Julian asked on 2026-11-22 for the forward statement of joint 9, the table of G as the zeros reweighted by the symbol, after two corrections to the joint's draft
sealed: false
---

**Question.** Block `9a` of the joints worksheet (`joints.md#9a`). Does the symbol's action, proved in the table's tree for one mode and for finite sums of modes, hold for the actual row of `G` along the doublings, for every zero of `ζ` at once?

**What was proved.** `module_lines` 202 lines, `theorems_proved` 4 theorems, `defs` 2 definitions, `private_lemmas` 2 private lemmas, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

The definitions: `dd f y = f y − f (y/2)`, one difference along the ladder of base `base` 2, and `cutG`, which is `G` above one and zero below, the row starting at the first regime. `dd_iter_rule`: `dd` iterated `d + 1` times at `y` is `dd` iterated `d` times at `y` minus the same at `y/2`; at `y = 2^r` this is the table's rule for a cell. `mellin_shift`: for a function vanishing up to one, replacing `y` by `y/2` multiplies its Mellin transform over `(1, ∞)` by `2^(−s)`. `mellin_dd_iter`: for `Re s > 1` the transform of the depth-`d` difference of `cutG` is `(1 − 2^(−s))^d·Phi s`. `symPhi_principal_part`: at a zero `ρ` of `ζ` other than `0` and `1`, of order `m`, that function equals an analytic function plus `(1 − 2^(−ρ))^d·m/(ρ(1−ρ))/(s − ρ)` near `ρ`.

So yes, on the transform. `1 − 2^(−s)` is the symbol of the table's tree at base two. Differencing `d` times multiplies the whole transform by its `d`-th power, and each zero's pole comes out with its residue multiplied by the symbol at that zero to the power `d`. No sum over the zeros is taken and no convergence is asked: the statement is about all the zeros at once because it is about the function that has them as poles.

**What is and is not here.** The joint as first drafted wrote each cell as a sum over the zeros; that form needs the explicit formula for `G` as a theorem and is not here. This is the same content one level up, and it is exact.

It runs from the zeros to the table. The other direction, a bound on the cells forcing a zero-free region, was corrected `corrections` 2 times in the worksheet before this build and is open: along any ladder of fixed ratio the heights of the zeros fold together.

The identification with `Chain.Sym` is by reading: that definition lives on the other toolchain and is written out here.

**The build.** `errors_first` 2 error lines on the first build from `roots` 1 root cause and `cascade` 1 downstream pin. `builds` 3 builds, `traps_added` 1 row (row `trap_row` 46), `assumed_pins` 0. Module at `jobs_module` 8724 jobs, package at `jobs_package` 8792. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What remains. The cell as a pointwise sum over the zeros; and the joints from the dial to the table's gate, which are small and run the other way.
