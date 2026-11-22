---
id: 0439
date: 2026-11-22
type: formalization
title: "FiniteOffLine.lean: with finitely many zeros off the line, square-root cells on the one ladder give the Riemann hypothesis"
refs: [lean_stage3/Stage3/FiniteOffLine.lean::finite_off_line, lean_stage3/Stage3/FiniteOffLine.lean::sum_order_onLineInv_le, lean_stage3/Stage3/FiniteOffLine.lean::err_le]
supersedes: []
follows: 0432
context: unit 0431 recorded that the finite case of joint 10 on the one ladder was closed in its pieces, with the assembled statement not yet written; Julian said on 2026-11-22 to go for all of the open items, this being the first
sealed: false
---

**Question.** Block J10d of `lean_stage3/design/joints.md`. If only finitely many zeros of zeta are off the line, do cells of square-root size on the table's own ladder force them all onto it?

**What was proved.** `lean_stage3/Stage3/FiniteOffLine.lean`: `module_lines` 568 lines, `theorems_proved` 12 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 3 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 4 error lines; clean on build `builds` 5. The package builds at `jobs_package` 8832 jobs, the module at `jobs_module` 8747. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`finite_off_line`: let a finite set hold every zero off the line. Suppose that at one depth, from some row on, the cell of the log-weighted prime count on the one ladder is within a constant times the square of the row times the square root of the doubling of its main term. Then the Riemann hypothesis holds.

How. The cell is its main term minus a sum over the zeros below a height, with a stated error (unit 0425). At each row the height is taken as the doubling of the cell's lowest row. `err_le`: the error is then at most a constant times the square of the row. `sum_order_onLineInv_le` with `dyadic_count_le`: the zeros on the line below that height, each weighted by its order over its size, add to at most `count_const` 6000 times the square of the number of dyadic levels plus two. So the zeros on the line contribute square-root size times a square of the row. The zeros off the line below the largest real part are finitely many and each is smaller than the top line by a fixed ratio per row. What is left is the top line, and it would have to fade against its own size. Unit 0430 says a finite line does not fade.

**What it says.** On the one ladder the table sees a finite set of zeros off the line: they cannot hide under square-root cells. The statement is on the cells of the log-weighted count.

What remains. Infinitely many zeros off the line, where unit 0431 holds the stopping point. The same statement for the cells of the prime count itself, which is joint T2.
