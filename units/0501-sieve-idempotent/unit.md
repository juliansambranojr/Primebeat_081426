---
id: 0501
date: 2026-11-23
type: formalization
title: "The sieve's step is idempotent: one prime at a time, the same at every size, settling on a prime"
refs: [lean_stage3/Stage3/SieveIdem.lean::sieveStep_idem, lean_stage3/Stage3/SieveIdem.lean::sieveStep_comm, lean_stage3/Stage3/SieveIdem.lean::sieveBelow_succ, lean_stage3/Stage3/SieveIdem.lean::rough_eq_card, lean_stage3/Stage3/SieveIdem.lean::settles_on_prime]
supersedes: []
follows: 0500
context: Julian read the settling of each prime into its slot as idempotence: every step is the same function and it scales at any size; this is block R12 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R12 of `lean_stage3/design/runs.md`. Is a prime's step of the sieve idempotent and free of order and size, and does the sieve settle one prime at a time onto a prime?

**What was proved.** `lean_stage3/Stage3/SieveIdem.lean`: `module_lines` 140 lines, `theorems_proved` 8 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8884 jobs, the module at `jobs_module` 8807. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`sieveStep_idem`: a prime's step, removing its multiples, done twice is done once. `sieveStep_comm`: two primes' steps give the same set in either order. `mem_sieveStep`: a number survives a step exactly when it was there and the prime does not divide it; no size enters the rule.

`sieveBelow_idem`: the sieve by every prime below a bound is idempotent too. `sieveBelow_succ`: past a prime the sieve grows by exactly that prime's step; `sieveBelow_succ_of_not_prime`: past a number that is not prime it does not change. One slot at a time.

`rough_eq_card`: the counts of unit `unit_split` 490 are the sizes of this sieve on the numbers up to a scale. `settles_on_prime`: a number from two up that no prime below it divides is prime, the first open slot.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. Idempotence fixes which numbers are left at every size. It gives no size for the roundings of the counts, whose sum over the primes unit `unit_memory` 499 measured drifting.
