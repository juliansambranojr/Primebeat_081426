---
id: 0471
date: 2026-11-23
type: formalization
title: "On the count's ladder no mode lies strictly outside a disc that holds every other mode"
refs: [lean_stage3/Stage3/CountEuler.lean::transform_eq, lean_stage3/Stage3/CountEuler.lean::class_main, lean_stage3/Stage3/CountEuler.lean::euler_exposed_false]
supersedes: []
follows: 0470
context: unit 0469 wrote a zero's part of the count as a radial segment of modes and unit 0470 bounded the sum of the segments right of a line with a power saving; an independent reviewer derived an elementary argument on the Euler transform of the ladder; this is block N3-E of `lean_stage3/design/countmodes.md`, and the build was the derivation's first check
sealed: false
---

**Question.** Block N3-E of `lean_stage3/design/countmodes.md`. If the count of primes at the doublings stays at square-root size, can a zero right of the saving's exponent have its mode strictly outside a disc that holds the mode of every other zero right of the line?

**What was proved.** `lean_stage3/Stage3/CountEuler.lean`: `module_lines` 912 lines, `theorems_proved` 46 theorems, `defs` 14 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 6 error lines; clean on build `builds` 12. The package builds at `jobs_package` 8861 jobs, the module at `jobs_module` 8823. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`euler_exposed_false`: suppose the count of primes at each doubling is within a constant times the square of the row times the square root of the doubling of its smooth part. Take a line right of the critical line and a number above it, at most the unit, that bounds the real part of every zero. Then there is an exponent, at least the line and strictly below that bound, such that the following is impossible: a zero with real part above the exponent, and a disc centred on the ray opposite to that zero's mode, such that the mode of every other zero on or right of the line lies in the disc and the zero's own mode lies strictly outside it.

`transform_eq`: the binomial combination of a zero's segment integrals over the rows up to a row, with a centre, is the integral along the segment of the mode times the mode less the centre to the row. `class_main`: for the zero's own class that integral is computed exactly, as a main term plus an integral with the square of the distance in the denominator.

How. The ladder is passed through its Euler transform with the disc's centre. By unit `unit_reduction` 470 and the binomial theorem the transform is small against the distance from the centre to the zero's mode. On each other zero's segment the distance to the centre is at most the disc's radius, because a disc is convex and holds both ends of the segment; so the other zeros fade. For the zeros sharing the mode, an integration by parts gives the transform over its normaliser as the reciprocal of the zero's exponent plus a term that tends to zero. Summed over the zeros by dominated convergence, the reciprocals of the class add to zero. Each has positive real part.

**Who wrote it.** An Opus worker, from the reviewer's derivation, with the instruction to stop at any step that failed. One justification in it was wrong: the class's error term was said to follow by dominated convergence with a fixed dominator, and after normalising the integrand piles up at the segment's outer end, so no fixed dominator exists. The claim was true. The worker integrated by parts first, which gives an exact identity to which dominated convergence applies. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** This is on the table's own ladder, the count of primes. Unit `unit_attained` 456 closed the case where a largest real part is attained. Here a zero need not be the furthest right: it is enough that its mode stands outside a disc that holds the others, with the centre at the origin or anywhere behind it on the opposite ray. With the centre far away that is a mode strictly beyond every other in its own direction. The real parts may climb to a value no zero reaches, the case unit `unit_cases` 431 left with no argument, and the count's ladder still excludes such a zero. No complex analysis is used.

What remains. Arrangements with no mode standing outside such a disc: every mode right of the exponent having others further out around it, as when the modes are stacked along a single ray. Unit `unit_psi` 468 reaches some of those on the ladder of the Chebyshev function; on the count they need the form with slits, which is on paper. Nothing here says how the zeros of zeta are in fact arranged.
