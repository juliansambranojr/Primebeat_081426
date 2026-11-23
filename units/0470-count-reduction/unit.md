---
id: 0470
date: 2026-11-23
type: formalization
title: "Under the ladder bound on the count the segments of modes right of a line are small with a power saving"
refs: [lean_stage3/Stage3/CountReduction.lean::tail_rate, lean_stage3/Stage3/CountReduction.lean::summable_J, lean_stage3/Stage3/CountReduction.lean::count_modes_small]
supersedes: []
follows: 0469
context: unit 0469 wrote a zero's part of the count at a doubling as a radial segment of modes; this is block N2 of `lean_stage3/design/countmodes.md` as corrected by an independent review
sealed: false
---

**Question.** Block N2 of `lean_stage3/design/countmodes.md`. If the count of primes at the doublings stays at square-root size, how small is the sum of the segments of modes over the zeros right of a line?

**What was proved.** `lean_stage3/Stage3/CountReduction.lean`: `module_lines` 600 lines, `theorems_proved` 12 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 8 error lines; clean on build `builds` 14. The package builds at `jobs_package` 8860 jobs, the module at `jobs_module` 8822. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`count_modes_small`: suppose the count of primes at each doubling is within a constant times the square of the row times the square root of the doubling of its smooth part. Take a line right of the critical line, and a number above it, at most the unit, that bounds the real part of every zero. Then there is an exponent, at least the line and strictly below that bound, and a constant, such that for every row from `first_row` 2 on the sum over the zeros on or right of the line of each zero's order times its segment integral `J` at the row is at most the constant times the row to the power `row_power` 2 times the doubling to that exponent.

`tail_rate`: for a line right of the critical line there is an exponent below the unit such that the orders over the sizes of the zeros on or right of the line and above the height of a row's doubling sum to at most a constant times the row times the doubling to that exponent less the unit. The tree had this sum bounded by a constant; the rate is new.

`summable_J`: for each row the segment integrals of the zeros right of a line, with their orders, are absolutely summable.

How. The identity for the count at the row's doubling, at the height of the same doubling. The zeros left of the line are bounded one by one against the line's power. The zeros right of the line below the height are written by unit `unit_segments` 469 as segment integrals plus constants, and the constants sum to a constant. The zeros right of the line above the height are the tail, and `tail_rate` with the bound on each segment integral makes them smaller than the largest power by a fixed factor per row. The exponent is the larger of the line and the bound on the real parts less that saving.

**Who wrote it.** An Opus worker, from the design as corrected by an independent reviewer, with the instruction to stop at any step that failed. None failed. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** On the count's own ladder the square-root bound forces the whole sum of segments right of any line to grow strictly slower than the fastest mode could. The attained case needed only that it grow slower; here the gap is a fixed power, which is what an argument on a single mode away from the top needs.

What remains. Block N3-E: with this bound, no mode above the exponent lies strictly outside a disc that holds every other mode.
