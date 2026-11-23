---
id: 0476
date: 2026-11-23
type: formalization
title: "The closed loop's restoring force and handshake, joined to the table's mirror and stated on the zeros"
refs: [lean_stage3/Stage3/ClosedLoopJoin.lean::force_join, lean_stage3/Stage3/ClosedLoopJoin.lean::handshake_iff_sides, lean_stage3/Stage3/ClosedLoopJoin.lean::structural_contradiction, lean_stage3/Stage3/ClosedLoopJoin.lean::off_line_zero, lean_stage3/Stage3/ClosedLoopJoin.lean::rh_iff_force_zero, lean_stage3/Stage3/ClosedLoopJoin.lean::rh_iff_handshake]
supersedes: []
follows: 0475
context: Julian's closed loop in `lean_primebeat` defines a restoring force and a Hermitian handshake and proves a structural contradiction off one half; the Stage 3 tree derived a restoring force from the mirror of a mode; the two had not been set side by side until Julian pointed to his file on 2026-11-23
sealed: false
---

**Question.** Block J1 of `lean_stage3/design/closedloop.md`. Are the closed loop's restoring force and handshake the same objects as the Stage 3 tree's mirror imbalance and the two sides of a mode, and what do the closed loop's theorems say when stated on the zeros of zeta?

**What was proved.** `lean_stage3/Stage3/ClosedLoopJoin.lean`: `module_lines` 219 lines, `theorems_proved` 11 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8862 jobs, the module at `jobs_module` 8752. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`force_join`: for a base above the unit, the mirror imbalance of a mode of the table, which the Stage 3 tree derived from the mirror, equals the closed loop's restoring force at the mode's real part times a constant that depends on the base alone. `force_eq`: the closed loop's force is `force_factor` 5 times the distance from one half. The two forces are one.

`handshake_iff_sides`: the closed loop's Hermitian handshake at the real part of a point holds exactly when, at every prime above `prime_floor` 3, the prime's mode at the point and its mirror have the same size. The handshake is the two sides of the tree's mirror agreeing.

`structural_contradiction`: the closed loop's main theorem, with its own definitions: away from one half the restoring force is nonzero and the handshake fails. `off_line_zero`: the same at a nontrivial zero of zeta off the line, together with the tree's side of it: the mirror imbalance of its mode is nonzero at every base, and one of the mode's two sides is longer than the square root of the base.

`rh_iff_force_zero`, `rh_iff_handshake`: the Riemann hypothesis holds exactly when the closed loop's force is zero at every nontrivial zero, and exactly when the handshake holds at every nontrivial zero.

How. The closed loop's file is a separate package on another toolchain, with `closed_loop_sorries` 0 uses of `sorry`; its `restated_defs` 4 definitions are restated here word for word and nothing is imported. The force is an absolute value that simplifies. The handshake at a prime compares two real powers, which are the reciprocals of the sizes of the prime's mode and of its mirror. The rest is the tree's `StencilWeil.restoringForce_eq`, `MirrorArea.long_side_of_off_line` and `LandauWindow.rh_of_zeroFree_half`.

**Who wrote it.** Written and built here, in one sitting, from Julian's file and the tree's. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard three axioms.

**What it says.** The restoring force and the handshake that Julian defined in the closed loop, from the doubling and the primes, are the objects the tree met again when it took the mirror of a mode of the table. His structural contradiction, placed on a zero of zeta, says in the tree's terms that an off-line zero has a mode and a mirror of different sizes at every base. The Riemann hypothesis is the statement that this never happens: the force at rest at every zero.

What remains. The module contains no statement that the force is zero, or that the handshake holds, at a zero of zeta. That statement is the Riemann hypothesis in these terms. The closed loop's comments give the reason it must hold, that the number line is built on the half at every doubling; that reason is not yet a Lean statement about the zeros.
