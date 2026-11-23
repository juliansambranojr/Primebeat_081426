---
id: 0467
date: 2026-11-23
type: formalization
title: "A rate attained under some filter contradicts the ladder bound"
refs: [lean_stage3/Stage3/FilterAttained.lean::filter_attained_false, lean_stage3/Stage3/FilterAttained.lean::attained_psi]
supersedes: []
follows: 0466
context: unit 0466 proved that under the ladder bound the modes right of a line stay small after any polynomial filter; an independent review of 2026-11-23 corrected the next step of the design; this is block S2 of `lean_stage3/design/stencil.md` in its corrected form
sealed: false
---

**Question.** Block S2 of `lean_stage3/design/stencil.md`. If under some polynomial filter the largest rate among the zeros right of a line is attained by a zero and exceeds the threshold, can the ladder of the Chebyshev function stay at square-root size?

**What was proved.** `lean_stage3/Stage3/FilterAttained.lean`: `module_lines` 383 lines, `theorems_proved` 9 theorems, `defs` 4 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 5. The package builds at `jobs_package` 8857 jobs, the module at `jobs_module` 8821. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`filter_attained_false`: suppose the Chebyshev function at each doubling is within a constant times the square of the row times the square root of the doubling. Take a polynomial, a number of applications and a step whose product with the polynomial's degree stays below the step, and a line right of the critical line. The rate of a zero is its mode to the step times the polynomial at the reciprocal of its mode to the number of applications. Suppose some zero on or right of the line has a rate at least as large in size as that of every other such zero, and larger than the line's power of the step's doubling times the polynomial's weighted norm to the number of applications. That is impossible.

`attained_psi`: with no filter. If some zero has the largest real part and the ladder of the Chebyshev function stays at square-root size, the Riemann hypothesis holds.

How. Divide the filtered sum of unit `unit_filter` 466 by the largest rate to the row. The zeros below the row's height are small by that unit, since the threshold over the largest rate is below one. The zeros above the height are a tail of a summable family. The zeros with a smaller rate fade term by term under a summable bound; no gap below the largest rate is needed. What stays is a summable family of unit rotations tending to zero, and averaging along the rows makes the weights of the zeros sharing a rotation add to zero (`LadderMean.mean_extract`). Every weight has positive real part, so they cannot.

**Who wrote it.** An Opus worker, from the design as corrected by an independent reviewer, with the instruction to stop at any step that failed. None failed. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** Unit `unit_attained_pi` 456 closed the case where a circle of modes dominates. Here the modes may be re-weighted by a filter first, and the case closes whenever some filter makes a largest rate that a zero attains. Which arrangements of zeros admit such a filter is block S3 and the design's last section.

What remains. Block S3: modes that accumulate at finitely many points. The arrangement in which the accumulation set separates the modes from the origin. The count in place of the Chebyshev function.
