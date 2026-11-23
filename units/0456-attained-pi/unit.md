---
id: 0456
date: 2026-11-23
type: formalization
title: "AttainedPi.lean: if the largest real part of the zeros is attained, the prime count at the doublings within square-root size of Li gives the Riemann hypothesis"
refs: [lean_stage3/Stage3/AttainedPi.lean::attained_off_line_pi, lean_stage3/Stage3/AttainedPi.lean::fin_bound, lean_stage3/Stage3/AttainedPi.lean::band_small]
supersedes: []
follows: 0455
context: unit 0431 split the one-ladder converse of joint 10 into three cases and found the second, the largest real part attained, to close given a zero-density estimate the tree did not have; units 0446 to 0455 built that estimate; this is block C7 of `lean_stage3/design/carlson.md`
sealed: false
---

**Question.** Block C7 of `lean_stage3/design/carlson.md`. If some zero of zeta has the largest real part of all, does the prime count at the doublings, held within square-root size of its smooth part, put every zero on the line?

**What was proved.** `lean_stage3/Stage3/AttainedPi.lean`: `module_lines` 886 lines, `theorems_proved` 17 theorems, `defs` 5 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 16 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8847 jobs, the module at `jobs_module` 8811. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`attained_off_line_pi`: suppose one zero of zeta has real part at least that of every other zero. Suppose that from some row on the prime count at the row's doubling is within a constant times the square of the row times the square root of the doubling of the smooth count. Then the Riemann hypothesis holds. No bound is put on how many zeros are off the line, and nothing else is assumed about them.

How. If the largest real part is at most one half there is nothing right of the line. Otherwise take the line of zeros at the largest real part. Their coefficients are summable (unit 0455), so by unit 0432 their sum of modes cannot fade against its own size. The proof shows it does fade. At each row the count less its smooth part is minus the sum over the zeros below the doubling, within square-root size (unit 0442, unit 0444). The zeros of the top line above the doubling are a tail of a summable family (`tendsto_tail`). The zeros left of the top line are split by a margin: those further left than the margin are smaller by a fixed ratio per row (`fin_bound`, `slack_isLittleO`); those within the margin carry total weight that tends to zero with the margin (`band_small`). So for every tolerance the top line's sum is eventually below the tolerance times its own size.

**Who wrote it.** An Opus worker, from a brief with the statement and the route. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; the main theorem's pin reads the standard three axioms; and it was built in the package.

**What it says.** Unit 0431 named `cases_of_0431` 3 cases of the one-ladder converse. `cases_closed` 2 are now theorems on the integer count: finitely many zeros off the line (unit 0445), and any number of them when the largest real part is attained. On the table's own ladder, the count at the doublings sees every configuration of zeros in which some zero is furthest right.

What remains. The third case: the real parts of the zeros approach a value that no zero reaches. No argument is known for it; unit 0431 holds why the method stops there.
