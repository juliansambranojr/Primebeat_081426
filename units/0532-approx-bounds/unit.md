---
id: 0532
date: 2026-11-25
type: formalization
title: "The sizes for the twisted moment: Stirling on vertical lines, the gamma ratio, the decay of the weight, the residues"
refs: [lean_stage3/Stage3/ApproxBounds.lean::gamma_shift, lean_stage3/Stage3/ApproxBounds.lean::log_norm_Gamma_approx, lean_stage3/Stage3/ApproxBounds.lean::log_norm_Gammaℝ_approx, lean_stage3/Stage3/ApproxBounds.lean::XY_log, lean_stage3/Stage3/ApproxBounds.lean::XY_size, lean_stage3/Stage3/ApproxBounds.lean::gY_bound, lean_stage3/Stage3/ApproxBounds.lean::integrand_bound, lean_stage3/Stage3/ApproxBounds.lean::VY_line_bound, lean_stage3/Stage3/ApproxBounds.lean::VY_line_eq, lean_stage3/Stage3/ApproxBounds.lean::VY_residue, lean_stage3/Stage3/ApproxBounds.lean::VY_decay, lean_stage3/Stage3/ApproxBounds.lean::VY_decay_young, lean_stage3/Stage3/ApproxBounds.lean::resY_small]
supersedes: []
follows: 0531
context: piece 2 of block S12 of `lean_stage3/design/stencil.md`, the twisted second moment, needs the sizes of the gamma ratio, the weight and the residues first; this is piece 2a
sealed: false
---

**Question.** Piece 2a of block S12 of `lean_stage3/design/stencil.md`. How large are the gamma ratio of the approximate functional equation, its weight and its residues, for small shifts?

**What was proved.** `lean_stage3/Stage3/ApproxBounds.lean`: `module_lines` 1721 lines, `theorems_proved` 63 theorems, `defs` 7 definitions, `sorries` 0 sorries, `pins` 13 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8909 jobs, the module at `jobs_module` 8809. Two rows added to TRAPS, `traps_added` 2; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`log_norm_Gamma_approx`: the logarithm of the size of the gamma function on any vertical line right of the imaginary axis is a Stirling model within an explicit error, from Euler's product, a mean value step along horizontal shifts (`gamma_shift`) and the value on the line of one half. `XY_size`: the gamma ratio lies between constant multiples of the height over two pi to the minus real part of the sum of the shifts. `VY_line_eq`, `VY_residue`, `VY_line_bound`, `VY_decay` and `VY_decay_young`: the weight is the same on every line right of zero, moving past zero adds one, and it decays like any power of one plus the argument over the height. `resY_small`: the residues are at most a constant times a Gaussian of the height.

**Who wrote it.** One worker, whose scratch passes stopped on a field name, converts into instances, heartbeat timeouts, a cast, a set name under gcongr and a tight constant. Two of those classes are new rows of `lean_stage3/TRAPS.md`. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The bounds on the derivatives of the weight in the height, the asymptotic forms, the twisted moment, the operator and the unsmoothing.
