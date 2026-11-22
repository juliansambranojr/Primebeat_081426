---
id: 0425
date: 2026-11-22
type: formalization
title: "CellZeros.lean: the cell as a sum over the zeros of zeta, each a mode multiplied by the symbol once per depth, with a stated error and no RH"
refs: [lean_stage3/Stage3/CellZeros.lean::cell_eq_zero_sum, lean_stage3/Stage3/CellZeros.lean::stencil_mode, lean_stage3/Stage3/CellZeros.lean::stencil_zeroPartialSum]
supersedes: []
follows: 0424
context: Julian's statement that the table and everything downstream are one object, written into SECTIONS.md on 2026-11-22 with four joints; this is the first, T1, the statement he has made since the beginning as a theorem
sealed: false
---

**Question.** Block T1 of `lean_stage3/design/joints.md`. Is each cell of the table of the log-weighted prime count a sum over the zeros of zeta, in the form the table tree's mode theorem has, and without assuming RH?

**What was proved.** `lean_stage3/Stage3/CellZeros.lean`: `module_lines` 186 lines, `theorems_proved` 10 theorems and `defs` 1 definition, `sorries` 0 sorries, `pins` 3 axiom pins each at `axioms` 3 axioms. The first build had `errors_first` 4 error lines, one rewrite in the binomial lemma and the pins above it; clean on build `builds` 2. The package builds at `jobs_package` 8823 jobs, the module at `jobs_module` 8736. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`stencil` is the repeated backward difference of a row, read at a row. `stencil_mode`: on a row that is the powers of a nonzero number, the stencil at depth `d` is that power times one minus the inverse of the number, to the `d`. For the number two to a zero, that factor is the table's symbol at the zero.

`stencil_zeroPartialSum`: the stencil of the explicit formula's sum over the zeros below a height is the same sum with each zero's term multiplied by its symbol to the `d`. The zeros below a height are finitely many, so the two sums exchange.

`cell_eq_zero_sum`: take the row of the log-weighted prime count at the doublings. For a depth, a row and a height, with the bottom row of the window at least `floor` 16 and the height between two and the square of that bottom row: the stencil of the row, minus the main term, plus the sum over the zeros below the height of each zero's multiplicity over the zero, times the mode at the row, times the symbol to the depth, is bounded in norm by the explicit formula's error summed over the window with binomial weights. RH is not a hypothesis.

**What it says.** The residual of the differences of the prime count along the doublings is a sum of modes, one for each zero of zeta, and passing one depth down multiplies each by one minus two to the minus that zero. This is the statement that the residuals of the deltas are the zeta zeros, as a theorem about the table's own differences.

What the next slice needs. The same with the table tree's `Sym`, `mode` and `modeSum` (unit 0426). Then the count of primes in place of the log-weighted count, the height taken to infinity, the stencil as a test function in Weil's form, and the zeros read back from the cells.
