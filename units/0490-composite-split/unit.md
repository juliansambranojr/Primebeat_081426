---
id: 0490
date: 2026-11-23
type: formalization
title: "The composite table has no signs: every composite once, under its least prime"
refs: [lean_stage3/Stage3/CompositeSplit.lean::card_least_prime, lean_stage3/Stage3/CompositeSplit.lean::composites_by_least_prime, lean_stage3/Stage3/CompositeSplit.lean::composites_no_signs]
supersedes: []
follows: 0489
context: unit 0485 left the open link at the Pascal signs weighed against the roundings of the sieve; Julian asked whether the composite table had been looked at; `lean/PairIdentity.lean` ties the composite cell to the prime cell; this is block R10 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R10 of `lean_stage3/design/runs.md`. What becomes of the sieve's signs when the composites are counted directly?

**What was proved.** `lean_stage3/Stage3/CompositeSplit.lean`: `module_lines` 151 lines, `theorems_proved` 6 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 7 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8876 jobs, the module at `jobs_module` 8806. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`card_least_prime`: for a prime, the numbers from `floor_n` 2 up to a bound whose least prime it is are that prime times the numbers up to the bound over the prime that no smaller prime divides. Their count is the table's count at that smaller scale, sieved by the smaller primes.

`composites_by_least_prime`: the composites up to the bound, counted once each under their least prime. The least prime of a composite is at most the square root of the bound. There are no signs.

`composite_part`, `composites_no_signs`: the composites up to the bound, with a unit for each prime up to its square root, are the sum over those primes of the table's count at the scale of the bound over the prime. Every term is a count.

**Who wrote it.** Written and built here. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it says.** The sieve of unit `unit_half` 485 counts a composite once for every set of small primes dividing it and corrects the repeats with the Pascal signs. The composite table needs no correction, because a composite has exactly one least prime. On this side the open step has no signs in it. It reads: the count at a bound is tied to the same kind of count at the smaller scales, all entering the same way.

What remains. No bound on the residual is derived from the tie. The parts at the smaller scales number as many as the primes up to the square root, and their residuals would have to be weighed against each other.
