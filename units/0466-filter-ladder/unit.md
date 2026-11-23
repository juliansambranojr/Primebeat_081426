---
id: 0466
date: 2026-11-23
type: formalization
title: "The filtered ladder: under any polynomial filter the modes right of a line stay small"
refs: [lean_stage3/Stage3/FilterLadder.lean::Wn_pow_le, lean_stage3/Stage3/FilterLadder.lean::filter_mode, lean_stage3/Stage3/FilterLadder.lean::filtered_modes_small_sq, lean_stage3/Stage3/FilterLadder.lean::filtered_modes_small]
supersedes: []
follows: 0465
context: unit 0431 left the one-ladder converse open when the real parts of the zeros climb to a value no zero reaches, because no circle of modes dominates; a derivation of 2026-11-23 reads the ladder through polynomial filters; this is block S1 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S1 of `lean_stage3/design/stencil.md`. If the ladder of the Chebyshev function stays at square-root size, does the sum of the modes right of a line stay small after any polynomial filter is applied to the ladder?

**What was proved.** `lean_stage3/Stage3/FilterLadder.lean`: `module_lines` 560 lines, `theorems_proved` 21 theorems, `defs` 7 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 9. The package builds at `jobs_package` 8856 jobs, the module at `jobs_module` 8802. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`filtered_modes_small_sq`: suppose the Chebyshev function at each doubling is within a constant times the square of the row times the square root of the doubling. Take any polynomial, any line at or right of the critical line, a row, and a number of applications of the polynomial whose total degree is below the row. Then the zeros on or right of the line and below the height of the row's doubling, each weighted by its order over itself and by the polynomial at the reciprocal of its mode to the number of applications, sum to at most a constant times the square of the row times the line's power of the doubling times the polynomial's weighted norm to the number of applications. The constant `Afl` depends on the hypothesis' constant alone.

`filter_mode`: applying a polynomial filter to a pure mode multiplies it by the polynomial at the reciprocal of the mode.

`Wn_pow_le`: the weighted norm of a power is at most the power of the weighted norm.

`filtered_modes_small`: the same bound in the shape the design wrote.

How. The filter is applied to the ladder itself, where the hypothesis bounds it. Each row it reads is also written as its zeros by the explicit formula, all at the height of the top row's doubling, so that every row uses the same finite set of zeros. That height is far above the square of the low rows, and the low rows start at the first doubling: the formulas of unit `unit_formula_all` 460 and unit `unit_formula_two` 464 are both needed. On a mode the filter is a multiplication, so the filtered ladder is the filtered sum of modes within the formula's error. The zeros left of the line are bounded term by term.

**Who wrote it.** An Opus worker, from the design's derivation, with the instruction to stop at any step that failed. None failed. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** The table's depth is a filter, the difference. Any polynomial may stand in its place, and the ladder's smallness passes through it to the modes. The bound that came out has the row to the power `row_power` 2 where the design wrote `design_power` 4.

What remains. Blocks S2 and S3 of the design: a rate attained under some filter contradicts the hypothesis, and so do modes that accumulate at finitely many points. The statement is for the ladder of the Chebyshev function; the count is not treated.
