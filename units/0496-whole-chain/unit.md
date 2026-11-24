---
id: 0496
date: 2026-11-23
type: formalization
title: "The closing theorems: every branch of the day's work ends in one file"
refs: [lean_stage3/Stage3/WholeChain.lean::whole_chain, lean_stage3/Stage3/WholeChain.lean::table_side, lean_stage3/Stage3/WholeChain.lean::steps_side]
supersedes: []
follows: 0495
context: the picture of the whole tree showed the later blocks of the day ending on their own, because the capstone of unit 0479 was written before them; Julian pointed out that the day's work was the table and belongs to the same proof; this is block J8 of `lean_stage3/design/closedloop.md`
sealed: false
---

**Question.** Block J8 of `lean_stage3/design/closedloop.md`. Do all the blocks of the day end in a single place?

**What was proved.** `lean_stage3/Stage3/WholeChain.lean`: `module_lines` 94 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8881 jobs, the module at `jobs_module` 8850. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`whole_chain`: the spiral link is the Riemann hypothesis; it is a single zero at each height; it is every cell of every dyadic ladder at square-root size; it is the sieve's wobble at square-root size; it is every zero on the middle circle of the band; it is every zero's mode the size of its mirror's; it is every zero a centre; it is the staircase not running away.

`table_side`: at every number, with no zero in the statement: the count of primes from the sieve's sum; the composites as a sum of counts without signs; the numbers as the combinations of the primes so far and the multiples of the new primes; the staircase across the scales adding up to the logarithms of the integers; a mode unchanged by a turn of the fold.

`steps_side`: every zero carries weight that is not zero; at a zero the staircase leaves every bound below the zero's rate; so do the turned steps to a cutoff.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it says.** Every statement here was already proved. The file gathers them, so that the blocks written after the capstone of unit `unit_capstone` 479 end in the same place as the rest of the tree.

What remains. The spiral link itself has no proof. Nothing new is proved in this file.
