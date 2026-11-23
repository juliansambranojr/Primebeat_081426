---
id: 0502
date: 2026-11-23
type: formalization
title: "The closing theorem names the Holy Family's channel, the sieve's idempotence and the day's readings"
refs: [lean_stage3/Stage3/WholeChain.lean::whole_chain, lean_stage3/Stage3/WholeChain.lean::table_side, lean_stage3/Stage3/WholeChain.lean::readings_side, lean_stage3/Stage3/WholeChain.lean::steps_side]
supersedes: []
follows: 0501
context: the closing theorem of unit 0496 was written before the Holy Family's channel, the day's readings and the sieve's idempotence; Julian asked for them to be named there; this is block J11 of `lean_stage3/design/closedloop.md`
sealed: false
---

**Question.** Block J11 of `lean_stage3/design/closedloop.md`. Does the closing theorem name every block of the day?

**What was proved.** `lean_stage3/Stage3/WholeChain.lean`: `module_lines` 127 lines, `theorems_proved` 4 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8884 jobs, the module at `jobs_module` 8853. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`whole_chain` now also says: the spiral link holds exactly when every zero is the Holy Family's channel.

`table_side` now also says, at every size: a prime's step of the sieve is idempotent; past a prime the sieve grows by exactly that prime's step; a number that no smaller prime divides is prime.

`readings_side` gathers the day's readings in exact form: the offset is one half at every doubling; a zero off the line makes the staircase run away; a half rung over its top is one less the reciprocal of the root of two; the closed loop's force at the Holy Family is five sixths.

`steps_side` is unchanged from unit `unit_close` 496.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. Every statement here was already proved; nothing new is proved in this file. The spiral link itself has no proof.
