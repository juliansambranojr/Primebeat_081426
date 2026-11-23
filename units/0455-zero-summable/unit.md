---
id: 0455
date: 2026-11-23
type: formalization
title: "ZeroSummable.lean: the zeros right of any line beyond one half have summable order over size"
refs: [lean_stage3/Stage3/ZeroSummable.lean::summable_order_div, lean_stage3/Stage3/ZeroSummable.lean::summable_norm_coef, lean_stage3/Stage3/ZeroSummable.lean::sum_le_const]
supersedes: []
follows: 0454
context: the second half of block C6 of `lean_stage3/design/carlson.md`: unit 0454 counts distinct zeros right of a line up to a height; unit 0432 asks, as a hypothesis, that the order over the size be summable over a line of zeros
sealed: false
---

**Question.** Block C6b of `lean_stage3/design/carlson.md`. Do the zeros of zeta right of a line beyond one half, each weighted by its order over its size, add up to a finite number?

**What was proved.** `lean_stage3/Stage3/ZeroSummable.lean`: `module_lines` 401 lines, `theorems_proved` 14 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8846 jobs, the module at `jobs_module` 8765. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`summable_order_div`: for every real part above one half, the family of the order of a zero over its size, over all zeros of zeta with real part at least that, is summable. `summable_norm_coef`: so for any set of zeros whose real parts are all at least such a real part, the sizes of the coefficients of unit 0432 are summable over the set. That is the hypothesis of unit 0432, now a theorem.

How. Every finite partial sum is bounded by one constant (`sum_le_const`). The zeros are sorted into dyadic shells by height. In a shell the number of distinct zeros with positive height is bounded by unit 0454, and those with negative height are their conjugates. The order of one zero is at most the tree's local count, a logarithm. Each is at least the shell's lower height in size. So a shell contributes a geometric term times a linear one, and the zeros below the floor of unit 0454 are finitely many.

**Who wrote it.** An Opus worker, from a brief with the statement and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it says.** Right of any line beyond one half, the zeros carry finite total weight. Unit 0431 named this as what the general case of the one-ladder converse was missing; the summability in unit 0432 no longer has to be assumed.

What remains. Block C7: the converse when the largest real part is attained. The case where it is not attained.
