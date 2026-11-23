---
id: 0453
date: 2026-11-23
type: formalization
title: "ZeroSquares.lean: the number of zeros right of a line is at most a logarithm times the mean square over a strip; stage five, second half"
refs: [lean_stage3/Stage3/ZeroSquares.lean::card_zeros_le, lean_stage3/Stage3/ZeroSquares.lean::square_lower, lean_stage3/Stage3/ZeroSquares.lean::strips_le]
supersedes: []
follows: 0452
context: the second half of block C5 of `lean_stage3/design/carlson.md`: unit 0452 bounded below the mean square over a square about a point; here the points are the zeros of zeta right of a line and the squares are counted
sealed: false
---

**Question.** Block C5 of `lean_stage3/design/carlson.md`. How many zeros of zeta can lie right of a line and below a height, given the mean square over a strip of the function that equals minus one at every zero?

**What was proved.** `lean_stage3/Stage3/ZeroSquares.lean`: `module_lines` 401 lines, `theorems_proved` 17 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8844 jobs, the module at `jobs_module` 8720. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`card_zeros_le`: take a real part above one half by more than a margin, at most one, a margin of at most a quarter, a height of at least `height_min` 5, and any finite set of zeros of zeta with real part at least the first, below one, and imaginary part from `im_low` 2 up to the height less two. Then pi times the square of the margin times the number of zeros in the set is at most `overlap` 3 times the quantity `count_log` 15 times the logarithm of the height plus `count_const` 73, times the integral of the squared size of the function of unit 0451 over the strip from the real part less the margin to one plus the margin, and from height one to the height.

How. At a zero the function is minus one, and it is differentiable away from the point one. `square_lower`: unit 0452 on the square about a zero, enlarged to a box of the strip. The zeros are grouped by the integer part of their height; each group lies in one window of the tree's local count, which bounds its size. `strips_le`: the boxes cover the strip at most `overlap` 3 times.

One hypothesis was added by the worker: the real part at most one. Without it the statement fails for the empty set, where the outer integral runs backwards.

**Who wrote it.** An Opus worker, from a brief with the statement and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it says.** Zeros right of a line cost mean square, each a fixed amount, and they cannot share it beyond a logarithm. With unit 0451 the mean square is below the first power of the height, so the count is too.

What remains. Block C6: the parameters chosen and the exponent stated. Block C7.
