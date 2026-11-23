---
id: 0478
date: 2026-11-23
type: formalization
title: "The rest of the closed loop joined to the table: the Holy Family, the doubling's half, the Prime Beat"
refs: [lean_stage3/Stage3/ClosedLoopChain.lean::holyFamily_is_mirror_pair, lean_stage3/Stage3/ClosedLoopChain.lean::holyFamily_pair_area, lean_stage3/Stage3/ClosedLoopChain.lean::holyFamily_force, lean_stage3/Stage3/ClosedLoopChain.lean::row_at_midpoint, lean_stage3/Stage3/ClosedLoopChain.lean::primeBeatTerm_eq_im]
supersedes: []
follows: 0477
context: unit 0476 joined the closed loop's restoring force, handshake and structural contradiction to the tree, and unit 0477 stated the spiral link; the closed loop's Holy Family, its doubling midpoints and its Prime Beat had no statements in the Stage 3 tree
sealed: false
---

**Question.** Block J3 of `lean_stage3/design/closedloop.md`. Do the remaining parts of the closed loop, the Holy Family, the midpoints of the doublings and the Prime Beat, tie to the table, its mirror and its modes by theorems?

**What was proved.** `lean_stage3/Stage3/ClosedLoopChain.lean`: `module_lines` 212 lines, `theorems_proved` 16 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 4 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8864 jobs, the module at `jobs_module` 8762. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

The Holy Family. `derive_joseph`, `derive_mary`, `derive_critical_line`: two parts of one whole, the second twice the first, are a third and two thirds, and their midpoint is one half; these are the closed loop's own theorems. `holyFamily_is_mirror_pair`: the second is the unit less the first, so the two are a point and its mirror. `holyFamily_pair_area`: at any base the sizes at the two multiply to the base, the area of the tree's mirror. `holyFamily_force`: the restoring force is `force_num` 5 over `force_den` 6 at both.

The doubling. `structural_ignition`, `ignition_energy_is_half`: the midpoint of each doubling is the doubling less one half, at every doubling; the closed loop's own theorems. `row_at_midpoint`: from the doubling numbered `first_row` 2 on, the count of primes up to the midpoint is the count of primes up to the doubling, which is the table's row. The table can be read at the closed loop's midpoints and is the same table.

The base and the lattice. `boundary_is_two`, `midpoint_base_is_unique`, `sextic_lattice`, as in the closed loop.

The Prime Beat. The closed loop's definitions of the Beat over the primes above `prime_floor` 3 are restated. `primeBeatTerm_eq_im`: a prime's term of the Beat is minus the imaginary part of the prime's step, the prime raised to minus one half and minus the imaginary height. `generalized_weight`: the weight of a prime in the general Beat is the handshake's weight of unit `unit_join` 476.

How. Each statement of the closed loop is restated word for word, since the two packages are separate, and proved again. Each join is short: the mirror of a point is the unit less the point; the integer part of a doubling less one half is the doubling less the unit, and a doubling past the first is not prime; the imaginary part of an exponential is its size times a sine.

**Who wrote it.** Written and built here, in one sitting. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard three axioms.

**What it says.** With unit `unit_join` 476 and unit `unit_link` 477, every part of the closed loop now has its statements in the Stage 3 tree and a theorem tying it to the table, to the mirror of a mode, or to the zeros of zeta. The Holy Family is a mirror pair. The half of the doubling is where the table's rows are read. The Beat is the imaginary part of the walk whose closing is a zero.

What remains. The chain's theorems connect; the one proposition in it that is stated and not proved is the spiral link of unit `unit_link` 477.
