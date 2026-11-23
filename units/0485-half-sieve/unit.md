---
id: 0485
date: 2026-11-23
type: formalization
title: "The half cancels in the sieve; the spiral link is the sieve's wobble at square-root size"
refs: [lean_stage3/Stage3/HalfSieve.lean::ignition_is_zeta_zero, lean_stage3/Stage3/HalfSieve.lean::netRounding_centered, lean_stage3/Stage3/HalfSieve.lean::resid_of_wobble, lean_stage3/Stage3/HalfSieve.lean::spiralLink_iff_wobble]
supersedes: []
follows: 0484
context: the spiral link of unit 0477 has no proof without a hypothesis; Julian's reason for it is the offset of a half at every doubling, proved in his closed loop and joined in unit 0478; units 0481 and 0482 made the sieve exact; this is block R6 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R6 of `lean_stage3/design/runs.md`. Where does the half of the closed loop sit in the sieve, and what does the spiral link become there?

**What was proved.** `lean_stage3/Stage3/HalfSieve.lean`: `module_lines` 349 lines, `theorems_proved` 12 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8871 jobs, the module at `jobs_module` 8837. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`ignition_is_zeta_zero`: the offset of the midpoint of every doubling above the power of two less a unit is minus the value of zeta at zero. Julian's half and that value are the same number at every doubling.

`half_cancels`, `netRounding_centered`: from `floor_n` 4 on, the signs over the terms of the sieve of unit `unit_sieve` 481 add to nothing, being the alternating sum of a Pascal row. So the half of every rounding cancels identically, and the net rounding is the sum of the roundings measured from the half.

`resid_step`: from `floor_r` 2 on, the residual of the count at a number is the residual at its square root less the wobble there, the wobble being the net rounding less its smooth part. This is unit `unit_wobble` 482 read as a step.

`resid_of_wobble`, `schoenfeld_of_wobble`: if the wobble is at square-root size at every number, so is the residual, with a constant that is the same at every number. Stepping down the square roots loses no factor.

`spiralLink_iff_wobble`: the spiral link of unit `unit_link` 477 holds exactly when the wobble stays at square-root size.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it says.** The half is in the sieve at every term and cancels exactly, at every row, by Pascal. What the sieve keeps is how far each rounding stands from the half. The open link of the chain is now one statement about those distances, with no zero in it: added with their signs and less their smooth part, they stay at square-root size.

What remains. The equivalence does not prove the link. The wobble's size is the statement left to prove.
