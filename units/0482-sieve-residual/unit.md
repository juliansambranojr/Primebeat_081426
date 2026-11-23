---
id: 0482
date: 2026-11-23
type: formalization
title: "The sieve's roundings and the table's residual: the row and its half"
refs: [lean_stage3/Stage3/SieveResidual.lean::net_wobble, lean_stage3/Stage3/SieveResidual.lean::net_wobble_rows]
supersedes: []
follows: 0481
context: unit 0481 proved the sieve's sum exactly and split the count into a closed product less the net of the roundings; the correction to unit 0475 found that net to be of the order of the count; this is block R3 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R3 of `lean_stage3/design/runs.md`. With its smooth part taken away, what is the net of the sieve's roundings?

**What was proved.** `lean_stage3/Stage3/SieveResidual.lean`: `module_lines` 85 lines, `theorems_proved` 4 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8868 jobs, the module at `jobs_module` 8792. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`net_wobble`: for every number at least `floor_N` 2, the net of the sieve's roundings less its smooth part is, exactly, minus the residual of the count at the number less the residual of the count at its square root. The smooth part `smoothNet` is the closed product of unit `unit_sieve` 481, less the unit, less the smooth count at the number, plus the smooth count at the square root.

`net_wobble_rows`: on the ladder, for every half-row at least `first_m` 1: at the doubling of the even row the net rounding less its smooth part is minus the table's residual at that row less the table's residual at half the row.

How. The exact formula for the net rounding from unit `unit_sieve` 481, carried to the real numbers, and rearranged. The square root of an even power of the base is the power of half the exponent.

**Who wrote it.** Written and built here, in one sitting; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard three axioms.

**What it says.** The correction to unit `unit_run` 475 found that the sieve's roundings do not cancel to the size of the square root: their net is a part of the count. This says what the roundings' wobble is. Once the smooth part of the net is taken away, what moves is the table's residual, read at the row and at half the row, and nothing else. The sieve's sum and the table's residual are the same wobble, and the half enters as the second place the residual is read.

What remains. The size of that wobble is the size of the table's residual at two rows. The closed product inside the smooth part is exact and is not itself written through the smooth count.
