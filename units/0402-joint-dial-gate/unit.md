---
id: 0402
date: 2026-11-22
type: formalization
title: "JointDialGate.lean: the dial's bound on π − Li carried to the table's rows as the gate's relative-error statement; joints 3, 4, 5 of SECTIONS.md"
refs: [lean_stage3/Stage3/JointDialGate.lean::thetaWindow_of_global, lean_stage3/Stage3/JointDialGate.lean::powerSaving_relErr, lean_stage3/Stage3/JointDialGate.lean::relErrWindow_of_window]
supersedes: []
follows: 0401
context: SECTIONS.md listed three small open joints between the dial, which gives a bound on the prime count's residual from a zero-free half-plane, and the table tree's gate, which makes a cell nonzero from a relative error on a window of rows; Julian said to keep going on 2026-11-22
sealed: false
---

**Question.** Block `3` of the joints worksheet (`joints.md#3`). Does the dial's bound on `π − Li` at exponent `θ` reach the table's gate in the form the gate takes?

**What was proved.** `module_lines` 152 lines, `theorems_proved` 5 theorems, `defs` 1 definition, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries. `joints_sealed` 3 joints of the map are sealed by it.

The definition is `StmtRelErrWindow`, copied character for character from the table's tree and added to the weld gate, which now holds `welds` 10 welds with `broken_welds` 0 broken.

`thetaWindow_of_global`: a bound `|pi x − li x| ≤ C·x^θ·(log x)^k` for `x ≥ x₀`, read at the rows `x = 2^(r−j)` of a window whose bottom clears `x₀`. `log_absorbed`: for `x ≥ 1` and `θ' > θ`, `C·x^θ·(log x)^k` is at most a constant times `x^θ'`. `powerSaving_relErr`: the table tree's statement, reproved on this toolchain: a bound `A·(2^m)^θ'` with `θ' ≤ 1` is a relative error `A·2^((r−n)(θ'−1))` on the window. `relErrWindow_of_theta`: the three composed. `relErrWindow_of_window`: from a window bound on `G` at `θ` in `[1/2, 1)`, for any `θ'` in `(θ, 1]`, there are `A ≥ 0` and `x₀` such that on every window of rows above `x₀` the rows of `π` and `Li` satisfy the gate's statement with relative error `A·2^((r−n)(θ'−1))`.

**What is and is not here.** The chain from a window bound on `G` to the gate's inlet is now inside one tree: the criterion, the dial, and these three steps. The relative error falls geometrically in the row once `θ' < 1`.

The logarithm, to the power `log_power` 2 in the dial's bound, is traded for a slightly larger exponent `θ'`. The statement names `θ'`; nothing is lost that the gate uses.

The last step, from the gate's statement to a nonzero cell, is `tableFrom_ne_zero_of_relErr` in the table's tree on the other toolchain. It also asks a lower bound on the main term's stencil and the gap inequality; neither was checked here against `Li` at the doublings. `A` and `x₀` are existential, so no row is named past which the gate closes.

The window bound on `G` is a hypothesis, proved nowhere. And the table tree's own header says the prime number theorem already gives the gate at each depth for some row; what this chain adds is the route from `G`, with a geometric rate.

**The build.** `errors_first` 0 error lines on the first build, `builds` 1 build, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8744 jobs, package at `jobs_package` 8793. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What remains. The gate's side conditions for `Li` at the doublings; explicit `A` and `x₀`; and, in the other direction, the converse from the cells to the zeros, which is open.
