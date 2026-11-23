---
id: 0452
date: 2026-11-23
type: formalization
title: "SquareMean.lean: the mean square of an analytic function over a square is bounded below by its value at the centre; stage five, first half"
refs: [lean_stage3/Stage3/SquareMean.lean::sq_mean_lower]
supersedes: []
follows: 0451
context: block C5 of `lean_stage3/design/carlson.md` counts zeros from the mean square of a function that equals minus one at every zero; its first half is a statement of complex analysis with no zeta in it
sealed: false
---

**Question.** Block C5a of `lean_stage3/design/carlson.md`. If a function is analytic on a square, how small can its mean square over the square be, given its size at the centre?

**What was proved.** `lean_stage3/Stage3/SquareMean.lean`: `module_lines` 246 lines, `theorems_proved` 6 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 1 axiom pins. The first build had `errors_first` 4 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8843 jobs, the module at `jobs_module` 8655. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`sq_mean_lower`: let a function be differentiable on a set containing the closed square about a point with a given half-side. Then pi times the square of the half-side times the squared size of the function at the centre is at most the integral of the squared size over the square, written as an outer integral over the real part and an inner one over the imaginary part.

How. On each circle about the centre the square of the function has the mean value property, so its size at the centre is at most the mean of the squared size on the circle (`circle_sq_mean`). Integrating over the radii in polar coordinates gives the disc (`disc_sq_mean`). The disc lies in the square, and Fubini's theorem writes the square's integral in the iterated form (`sq_set_integral`).

**Who wrote it.** An Opus worker, from a brief offering two routes; it took the one through discs. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it is for.** At a zero of zeta the function of unit 0451 equals minus one. So each zero right of a line forces a fixed amount of mean square in a small square about it, and unit 0451 bounds the total. The iterated form is the one that meets a bound known on vertical lines.

What remains. The count: how many squares can overlap, from the local count of zeros already in the tree. Then blocks C6 and C7.
