---
id: 0491
date: 2026-11-23
type: formalization
title: "The numbers up to N are the combinations of the primes up to its square root and the multiples of the new primes, nothing counted twice"
refs: [lean_stage3/Stage3/Compression.lean::unique_new_prime, lean_stage3/Stage3/Compression.lean::compression]
supersedes: []
follows: 0490
context: unit 0490 counted the composites without signs and left the open step as a tie across the scales; Julian answered that the primes are the compression of the composites, demanded when the combinations run out; this is block R11 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R11 of `lean_stage3/design/runs.md`. In what exact sense do the combinations of the primes so far run out and demand the new primes?

**What was proved.** `lean_stage3/Stage3/Compression.lean`: `module_lines` 84 lines, `theorems_proved` 3 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8877 jobs, the module at `jobs_module` 8807. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`unique_new_prime`: a number up to a bound has at most a single prime factor above the square root of the bound. Two would multiply to more than the bound.

`compression`: the numbers up to the bound are, exactly, the numbers all of whose primes are at most the square root, and for each prime above the square root its multiples up to the bound. Nothing is counted twice and there are no signs.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it says.** The combinations of the primes so far never repeat, and they do not fill the numbers up to the bound. What they leave is taken up by the new primes with their multiples, each number under exactly a single new prime. That is Julian's sentence at the step from the square root to the bound. For the open step it says where the residual sits: the residual of the new primes with their multiples is minus the residual of the count of combinations. With unit `unit_split` 490 the composite side is now written twice without signs.

What remains. No size is derived for the residual of the count of combinations.
