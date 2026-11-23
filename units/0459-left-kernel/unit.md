---
id: 0459
date: 2026-11-23
type: formalization
title: "The turning factor integrated by parts, and the series half of the left edge"
refs: [lean_stage3/Stage3/LeftKernel.lean::osc_by_parts, lean_stage3/Stage3/LeftKernel.lean::kernel_bound, lean_stage3/Stage3/LeftKernel.lean::series_side]
supersedes: []
follows: 0458
context: unit 0457 named the square of the logarithm of the height as the factor the left edge loses under an absolute value; unit 0458 kept the edge as a term; this is blocks F2a and F2b of `lean_stage3/design/leftedge.md`
sealed: false
---

**Question.** Blocks F2a and F2b of `lean_stage3/design/leftedge.md`. Integrated against the turning power of the doubling, is the Dirichlet-series half of the left edge bounded free of the height?

**What was proved.** `lean_stage3/Stage3/LeftKernel.lean`: `module_lines` 365 lines, `theorems_proved` 8 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 15 error lines; clean on build `builds` 9. The package builds at `jobs_package` 8849 jobs, the module at `jobs_module` 8737. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`osc_by_parts`: for a base above the unit and a function with an integrable derivative on a stretch, the integral of the base to the imaginary power times the function is at most the sizes of the function at the ends plus the integral of the size of its derivative, all over the logarithm of the base. The turning factor is integrated and the function differentiated.

`kernel_bound`: for the reciprocal of a real offset plus the imaginary variable, over a symmetric stretch, that bound is a multiple of the reciprocal of the half-length plus pi over the size of the offset, over the logarithm of the base. It does not grow with the stretch.

`series_side`: for a doubling at least `floor_x` 16 and a height at least `floor_T` 2, the integral up the left edge of the logarithmic derivative of zeta at the reflected point, times the power of the doubling over the variable, is at most the constant `Bser` over the fourth root of the doubling. `Bser` is free of the doubling and of the height; it and the summand `vmTerm` are the `noncomputable_defs` 2 noncomputable definitions of the module.

How. At the reflected point the real part is above the unit, so the logarithmic derivative is the Dirichlet series in the von Mangoldt function, absolutely convergent. Sum and integral are exchanged by dominated convergence. Each term is the von Mangoldt weight times the kernel of `kernel_bound` with base the doubling times the index. The weights are summable.

**Who wrote it.** An Opus worker, from a brief with the statements and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** Half of the left edge is now bounded with no logarithm of the height. The absolute value that unit 0457 found at fault is replaced, on this half, by the turning of the power.

What remains. The smooth half, from the gamma factor of the functional equation, and the join: block F2c and block F2. Then block F3.
