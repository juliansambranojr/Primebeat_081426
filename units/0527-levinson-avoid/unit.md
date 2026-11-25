---
id: 0527
date: 2026-11-25
type: formalization
title: "Avoidance in Levinson's method: good heights and abscissas exist, and the line factor is positive"
refs: [lean_stage3/Stage3/LevinsonAvoid.lean::exists_good_height, lean_stage3/Stage3/LevinsonAvoid.lean::exists_good_abscissa, lean_stage3/Stage3/LevinsonAvoid.lean::factor_pos]
supersedes: []
follows: 0526
context: the Levinson modules of block S11 of `lean_stage3/design/stencil.md` carried hypotheses that the borders miss the zeros and that the line factor is nonzero; Julian asked for the avoidance step
sealed: false
---

**Question.** Block S11 of `lean_stage3/design/stencil.md`, avoidance. Are there heights and abscissas whose segments miss every zero, and is the line factor positive for Levinson's constant?

**What was proved.** `lean_stage3/Stage3/LevinsonAvoid.lean`: `module_lines` 154 lines, `theorems_proved` 6 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 4 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8904 jobs, the module at `jobs_module` 8806. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`exists_good_height`: a function analytic and somewhere nonzero on a rectangle of height one has a height in it whose horizontal segment holds no zero, because its zeros in the compact rectangle are finite and an interval is not. `exists_good_abscissa`: the same for a vertical segment, at an abscissa a little left of a given one. `factor_pos`: for the constant one over the logarithm of a height from e to the twenty-six, the line factor one less that constant times the real part of the logarithmic derivative of the gamma factor is positive at every height from four to that height, from the tree's digamma bound in `Stirling`.

**Who wrote it.** One worker, whose first build stopped on the interval notation. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The assembled theorem with the mean value as a hypothesis, and the mean value itself; nothing here proves the hypothesis.
