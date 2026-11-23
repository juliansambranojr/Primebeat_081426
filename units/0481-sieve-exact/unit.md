---
id: 0481
date: 2026-11-23
type: formalization
title: "The half carries the row at every row: the sieve's sum, its Pascal levels, and its roundings"
refs: [lean_stage3/Stage3/SieveExact.lean::sieve_sum, lean_stage3/Stage3/SieveExact.lean::pi_by_sieve, lean_stage3/Stage3/SieveExact.lean::row_by_sieve, lean_stage3/Stage3/SieveExact.lean::level_card, lean_stage3/Stage3/SieveExact.lean::sieve_split, lean_stage3/Stage3/SieveExact.lean::smoothPart_eq_prod]
supersedes: []
follows: 0480
context: unit 0475 checked on fifteen rows that the count of primes at a doubling is given exactly by the sieve from the primes up to half the row, by levels shaped like a row of Pascal, and measured its roundings; Julian asked that the runs be theorems so that the table need not be computed
sealed: false
---

**Question.** Block R2 of `lean_stage3/design/runs.md`. Is the count of primes up to any number given exactly by the sieve from the primes up to its square root, level by level, and how does that sum split into exact fractions and roundings?

**What was proved.** `lean_stage3/Stage3/SieveExact.lean`: `module_lines` 286 lines, `theorems_proved` 13 theorems, `defs` 5 definitions, `sorries` 0 sorries, `pins` 7 axiom pins. The first build had `errors_first` 3 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8867 jobs, the module at `jobs_module` 8655. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`pi_by_sieve`: for every number at least `floor_N` 2, the count of primes up to it is the count of primes up to its square root, less the unit, plus an alternating sum over the sets of primes up to the square root: each set contributes, with the sign of its size, the number of times the product of its primes goes into the number. Only the primes up to the square root enter. `row_by_sieve`: the same at every doubling from row `first_row` 1: the table's row is built from the primes up to half the row.

`sieve_sum`, `survivors_eq`, `card_survivors`: the alternating sum counts the numbers that no prime up to the square root divides, and those are the unit and the primes above the square root.

`sieve_by_level`, `level_card`: the sum taken level by level, the level being the number of primes in the set, and the number of sets at a level is a binomial coefficient. The sieve's sum has the shape of a row of Pascal, with alternating signs.

`sieve_split`: the count is the exact-fraction part less the net of the roundings. `smoothPart_eq_prod`: the exact-fraction part is the number times the product, over the primes up to the square root, of the unit less the reciprocal of the prime. `abs_netRounding_le`: the net of the roundings is at most their mass. `netRounding_eq`: the net of the roundings is exactly that product less the count the sieve produces.

How. Inclusion and exclusion over the primes up to the square root, proved by expanding each number's indicator as a product and exchanging the sums. A number that no prime up to the square root divides has no proper factor. A whole-number quotient is the fraction less its fractional part.

**Who wrote it.** An Opus worker, from a brief with the statements. No statement had to change. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** What unit `unit_run` 475 computed on a stretch of rows holds at every row with nothing computed: the half carries the row, exactly, and the sum that does it is Pascal-shaped. The split is exact too. The count is a closed product, less one quantity: the net of the roundings. Everything about how the count deviates from that product is in that one quantity.

What remains. A statement about how small the net of the roundings is. The theorem here bounds it by its mass. The run saw it far smaller. That is the next thing to state and work on.
