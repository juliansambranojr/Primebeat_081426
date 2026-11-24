---
id: 0507
date: 2026-11-24
type: formalization
title: "RH gives the window bound: the window bound on G is a two-way face of the chain"
refs: [lean_stage3/Stage3/WindowsOfRH.lean::rampSum_eq_integral, lean_stage3/Stage3/WindowsOfRH.lean::const_eq_zero, lean_stage3/Stage3/WindowsOfRH.lean::noRunaway_of_rh, lean_stage3/Stage3/WindowsOfRH.lean::c0_eq_zero, lean_stage3/Stage3/WindowsOfRH.lean::windows_of_rh, lean_stage3/Stage3/WindowsOfRH.lean::spiralLink_iff_windows]
supersedes: []
follows: 0506
context: the window bound on G was the hypothesis of the Landau criterion with only one direction compiled; Julian asked for the reverse first; this is block R16 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R16 of `lean_stage3/design/runs.md`. Does the Riemann hypothesis give the window bound on G at every exponent above one half, so that the window bound is a face of the chain in both directions?

**What was proved.** `lean_stage3/Stage3/WindowsOfRH.lean`: `module_lines` 509 lines, `theorems_proved` 17 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 6 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8889 jobs, the module at `jobs_module` 8845. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`rampSum_eq_integral`: the ramp sum at a number is the number times the integral of the staircase over the square, by Abel summation. `const_eq_zero`: if the smoothed sum is a constant times its argument plus a remainder of smaller power, the constant is zero, because its Mellin transform is regular at one. `noRunaway_of_rh`: the hypothesis gives the staircase in the square-root frame. `c0_eq_zero`: under that frame the linear term of the smoothed sum is zero.

`windows_of_rh`: the hypothesis gives the window bound at every exponent above one half. `spiralLink_iff_windows`: the spiral link holds exactly when the window bound does; with the criterion of unit `unit_criterion` 399 the window bound is a face of the chain in both directions.

**Who wrote it.** The first three steps written and built here; the rest by one worker, whose first build stopped on a positivity goal, a default argument and the Chebyshev theta notation. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The window bound itself, without the hypothesis, is the open statement `Stage3.Target`; nothing here proves it.
