---
id: 0469
date: 2026-11-23
type: formalization
title: "On the count's ladder a zero is a radial segment of modes"
refs: [lean_stage3/Stage3/CountModes.lean::im_ne_zero, lean_stage3/Stage3/CountModes.lean::J_sub, lean_stage3/Stage3/CountModes.lean::piMode_doubling, lean_stage3/Stage3/CountModes.lean::norm_cst_le]
supersedes: []
follows: 0468
context: units 0466 to 0468 read the ladder of the Chebyshev function through polynomial filters, where each zero is a single mode; the table is the count of primes; this is block N1 of `lean_stage3/design/countmodes.md` as corrected by an independent review
sealed: false
---

**Question.** Block N1 of `lean_stage3/design/countmodes.md`. What is one zero's part of the count of primes at a doubling, written in pure modes?

**What was proved.** `lean_stage3/Stage3/CountModes.lean`: `module_lines` 512 lines, `theorems_proved` 29 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 7 error lines; clean on build `builds` 9. The package builds at `jobs_package` 8859 jobs, the module at `jobs_module` 8793. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`piMode_doubling`: for a nontrivial zero and a row at least `first_row` 1, the zero's part of the count at the row's doubling is `J` of the row, at the zero times the logarithm of the base, plus a constant `cst` that depends on the zero alone.

`J` is an integral over the half-line: the exponential of the row times the zero's exponent less the variable, over that same difference. `J_eq_segment` writes its numerator as the row's power of the zero's mode shrunk by the exponential of minus the variable. So the zero's part of the count is the zero's mode, and every mode on the radius from it in to the origin, each raised to the row, with a density along the radius.

`J_sub`: `J` at a row less `J` at the first row is the integral from the first row to the row of the exponential over the variable. `norm_cst_le`: the constant is at most `cst_numeral` 4 over the size of the zero's imaginary part times the logarithm of the base.

`im_ne_zero`: no nontrivial zero of zeta is real. The tree had no such statement. It comes from zeta having no zero on the real numbers strictly between zero and the unit (`riemannZeta_ne_zero_of_Ioo`), proved from the dependency's formula for zeta with the first term split off.

How. The zero's part of the count, as a function of the exponent of the doubling, has derivative the exponential over the exponent; integrating from the first row gives `J_sub`'s right side. `J_sub` itself is an exchange of two integrals.

**Who wrote it.** An Opus worker, from the design as corrected by an independent reviewer, with the instruction to stop at any step that failed. None failed. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** On the ladder of the Chebyshev function a zero is a single mode, which is why the filters of unit `unit_filters_first` 466 to unit `unit_filters_last` 468 can press a mode down. On the count's ladder a zero is a radial segment of modes. A filter that vanishes at a point does not remove a segment; a filter whose size is convex along every radius keeps its largest value at the segment's outer end.

What remains. Block N2: under the ladder bound on the count, the sum of these segments over the zeros right of a line is small with a power saving. Block N3-E: no mode strictly outside a disc that holds every other mode.
