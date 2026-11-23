---
id: 0468
date: 2026-11-23
type: formalization
title: "Modes accumulating at finitely many points contradict the ladder bound"
refs: [lean_stage3/Stage3/FilterAccum.lean::finite_accumulation_false, lean_stage3/Stage3/FilterAccum.lean::rh_of_finite_accumulation]
supersedes: []
follows: 0467
context: unit 0431 left the one-ladder converse open when the real parts of the zeros climb to a value no zero reaches; unit 0467 proved that a rate attained under some polynomial filter contradicts the ladder bound; this is block S3 of `lean_stage3/design/stencil.md` in its corrected form
sealed: false
---

**Question.** Block S3 of `lean_stage3/design/stencil.md`. If the modes of the zeros right of a line accumulate at only finitely many points, can the ladder of the Chebyshev function stay at square-root size with a zero right of that line?

**What was proved.** `lean_stage3/Stage3/FilterAccum.lean`: `module_lines` 245 lines, `theorems_proved` 10 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 5. The package builds at `jobs_package` 8858 jobs, the module at `jobs_module` 8822. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`finite_accumulation_false`: suppose the Chebyshev function at each doubling is within a constant times the square of the row times the square root of the doubling. Take a line right of the critical line and a finite set of nonzero points. Suppose that away from those points, at any fixed distance, the zeros on or right of the line have only finitely many distinct modes. Suppose some zero strictly right of the line has a mode that is none of those points. That is impossible.

`rh_of_finite_accumulation`: if for every line right of the critical line such a finite set exists, and no zero strictly right of the line has its mode in the set, then the ladder bound gives the Riemann hypothesis.

How. The filter is the polynomial whose roots are the reciprocals of the points, applied `applications` 1 time against a large step. Its value at a mode is small in proportion to the mode's distance from the nearest point, so the modes near the points have small rates. The given zero has a positive rate, and with a large step that rate exceeds the threshold of unit `unit_filter_attained` 467. The zeros with a rate at least that large then have modes at a fixed distance from every point, so finitely many distinct modes, and among finitely many a largest rate is attained. Unit `unit_filter_attained` 467 applies.

**Who wrote it.** An Opus worker, from the design as corrected by an independent reviewer, with the instruction to stop at any step that failed. None failed. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** This reaches into the case unit `unit_cases` 431 left with no argument. The real parts of the zeros may climb to a value that no zero reaches, with no largest mode, and the one ladder still sees them, provided their modes accumulate at finitely many points. The hypothesis is about how the zeros' modes are arranged. Nothing is proved here about how the zeros of zeta are in fact arranged.

What remains. The modes accumulating on an infinite set. A residue argument written by the reviewer would cover every accumulation set that does not separate the modes from the origin; it is on paper and unchecked. An accumulation set that does separate them is open by both routes. The count in place of the Chebyshev function is not treated.
