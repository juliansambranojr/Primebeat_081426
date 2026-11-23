---
id: 0454
date: 2026-11-23
type: formalization
title: "ZeroDensity.lean: for every real part above one half, the zeros right of it up to a height number at most a power of the height below the first"
refs: [lean_stage3/Stage3/ZeroDensity.lean::zero_density, lean_stage3/Stage3/ZeroDensity.lean::inner_le, lean_stage3/Stage3/ZeroDensity.lean::term4_le]
supersedes: []
follows: 0453
context: block C6 of `lean_stage3/design/carlson.md`: the mean square of unit 0451 put into the count of unit 0453, with the two lengths and the order chosen; the bound Julian asked on 2026-11-23 to have proved here
sealed: false
---

**Question.** Block C6 of `lean_stage3/design/carlson.md`. For a real part above one half, is the number of zeros of zeta right of it and below a height at most a power of the height with exponent below one?

**What was proved.** `lean_stage3/Stage3/ZeroDensity.lean`: `module_lines` 489 lines, `theorems_proved` 10 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 3 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8845 jobs, the module at `jobs_module` 8721. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`zero_density`: for every real part above one half and at most one there are an exponent below one, a constant and a floor such that, for every height from the floor on, every finite set of zeros of zeta with real part at least the given one, below one, and imaginary part from `im_low` 2 to the height less two has at most the constant times the height to the exponent members. With the margin equal to the excess of the real part over one half divided by `margin_div` 4, the exponent is one minus `exp_num` 5 times the square of the margin.

How. The Möbius sum is given length the height to the margin, zeta's finite sum length the height to one plus the margin, and the order of unit 0448 is fixed above the reciprocal of the margin. `term1_le` to `term4_le` bound the four terms of unit 0451 on every line of the strip; `inner_le` collects them as the height to one minus six times the square of the margin, with logarithms. Unit 0453 turns that into the count, and the logarithms are absorbed into a small power.

**Who wrote it.** An Opus worker, from a brief with the statement, the choice of the lengths and the size of each term. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and built in the package.

**What it says.** Zeros off the line are sparse: right of any line beyond one half there are fewer of them, up to a height, than a power of the height below the first. It is the input unit 0431 named as missing, in the strength that unit needs. Carlson's exponent is smaller; this one is what the elementary route gives.

What remains. The zeros counted are distinct, with imaginary part at least two; the sum of order over size over all of them is the next step. Then block C7.
