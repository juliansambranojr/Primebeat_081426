---
id: 0503
date: 2026-11-24
type: formalization
title: "The integers have no holes: the staircase is the Möbius-signed sum of the integers' log-factorials"
refs: [lean_stage3/Stage3/NoHoles.lean::moebius_floor_inversion, lean_stage3/Stage3/NoHoles.lean::psi_floor, lean_stage3/Stage3/NoHoles.lean::psi_by_integers, lean_stage3/Stage3/NoHoles.lean::log_factorial_close, lean_stage3/Stage3/NoHoles.lean::holes_resid, lean_stage3/Stage3/NoHoles.lean::holes_err_trivial]
supersedes: []
follows: 0502
context: a made-up prime system can sieve idempotently and still have zeros off the line; what the real primes have is the integers with nothing missing; Julian asked for that to be used on the residual; this is block R13 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R13 of `lean_stage3/design/runs.md`. Written through the integers alone, what is the staircase, and how far does the bound on its residual reach?

**What was proved.** `lean_stage3/Stage3/NoHoles.lean`: `module_lines` 198 lines, `theorems_proved` 10 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8885 jobs, the module at `jobs_module` 8839. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`moebius_floor_inversion`: if a function of the scales is summed over the scales of a number, the Möbius signs undo the sum exactly. `psi_floor`: the staircase at a quotient is the staircase at its integer part.

`psi_by_integers`: the staircase at a number is the sum over the scales of the Möbius sign times the logarithm of the factorial at that scale. It is the self-bound of unit `unit_self` 486 turned around: the primes' steps come from the integers counted with nothing missing and the signs alone.

`log_factorial_close`: the logarithm of a factorial is its smooth part within one logarithm plus one, at every size; this is where the integers having no holes enters. `holes_resid`: the staircase is the signed sum of the smooth parts plus the signed sum of the integers' errors. `holes_err_trivial`: the second sum is at most the sum of the errors' sizes.

**Who wrote it.** Built by one worker; it compiled on its first build. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The bound from the sizes alone has one term of logarithm size for every scale, so it grows like the number times its logarithm, a factor past the square root that grows with the number. By the rule on a lost factor the route needs the signs to cancel: the Möbius string staying within the square root, which is Mertens' statement. Nothing here proves it.
