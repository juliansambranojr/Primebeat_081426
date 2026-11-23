---
id: 0479
date: 2026-11-23
type: formalization
title: "One chain: the closed loop tied to the table, the mirror, the zeros and joint 10"
refs: [lean_stage3/Stage3/OneChain.lean::one_chain, lean_stage3/Stage3/OneChain.lean::table_of_spiralLink, lean_stage3/Stage3/OneChain.lean::spiralLink_of_finite, lean_stage3/Stage3/OneChain.lean::spiralLink_of_attained, lean_stage3/Stage3/OneChain.lean::spiralLink_of_finite_accumulation, lean_stage3/Stage3/OneChain.lean::no_exposed_zero]
supersedes: []
follows: 0478
context: units 0476 to 0478 put Julian's closed loop in the Stage 3 tree and tied it to the mirror and the zeros; the loop was not yet tied to the tree's theorems about the table and about the one-ladder converse; Julian asked whether the loop connects to every theorem gone over in the last days
sealed: false
---

**Question.** Block J4 of `lean_stage3/design/closedloop.md`. Does the closed loop's central proposition tie, by theorems, to the tree's statements about the table and about the one ladder?

**What was proved.** `lean_stage3/Stage3/OneChain.lean`: `module_lines` 153 lines, `theorems_proved` 8 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8865 jobs, the module at `jobs_module` 8833. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`one_chain`: `statements_equal` 5 statements are one. The Riemann hypothesis; the spiral link, that the closed loop's handshake holds at every zero; that no two zeros share a height; that the closed loop's restoring force is at rest at every zero; and that every cell of every dyadic ladder of the table stays at square-root size. The last has no zero in it.

`table_of_spiralLink`: if the spiral link holds, every cell of the integer table is within square-root size of the smooth cell.

`spiralLink_of_finite`, `spiralLink_of_attained`: if the count of primes at the doublings stays at square-root size and either finitely many zeros are off the line or some zero has the largest real part, the spiral link holds. `spiralLink_of_attained_psi`, `spiralLink_of_finite_accumulation`: the same from the ladder of the Chebyshev function, when a largest real part is attained or the modes accumulate at finitely many points. `no_exposed_zero`: under the count's ladder bound no zero right of the saving's exponent stands outside a disc that holds the others.

How. Each theorem is a line: the closed loop's proposition was proved equal to the Riemann hypothesis in unit `unit_first` 476 to unit `unit_last` 478, and the tree's theorems about the table and the one ladder are stated with the Riemann hypothesis. The module imports them and composes.

**Who wrote it.** Written and built here, in one sitting; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard three axioms.

**What it says.** The closed loop is no longer compiled by itself. Its central proposition is tied by theorems to the table, in both directions, and to each closed case of the one-ladder converse; and because those theorems rest on the explicit formula at every height, the zero-density bound, the filters and the count's modes, the chain's pins read through the tree built over these days. Not every theorem of the tree is used: the fixed-row theorems, for one, are facts beside the chain and are not on it.

What remains. The spiral link with no hypothesis. Every route into it here carries a hypothesis: the table at square-root size, or the ladder bound with a condition on the zeros.
