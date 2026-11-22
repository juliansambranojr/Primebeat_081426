---
id: 0403
date: 2026-11-22
type: formalization
title: "RelativeLi.lean: the shape-free gate with its main term discharged, the last hop from the dial to a cell of the table; and a trace of where the dial's constants stop being numbers"
refs: [lean/RelativeLi.lean::tableFrom_ne_zero_of_relErr_li, lean/RelativeLi.lean::tableFrom_ne_zero_of_powerSaving]
supersedes: []
follows: 0402
context: unit 0402 carried a window bound on G to the gate's relative-error statement and left two things unchecked: the gate's side conditions for the logarithmic integral along the doublings, and the constants A and x₀, which were existential; Julian asked for both on 2026-11-22
sealed: false
---

**Question.** Two, both about joint `joint` 6 of `SECTIONS.md`. Does the table tree's shape-free gate close on the logarithmic integral along the doublings, or does it leave its main-term condition open? And where do the constants in the dial's bound stop being numbers?

**What was proved.** In the table's tree, on toolchain `toolchain` 4.28.0: `lean/RelativeLi.lean`, `module_lines` 106 lines, `theorems_proved` 3 theorems, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries, clean on the first build (`errors_first` 0 errors). The tree builds at `jobs_tree` 8054 jobs and its index now reads `theorems_lean` 336 theorems across `modules_lean` 28 modules.

The gate `RelativeGate.tableFrom_ne_zero_of_relErr` asked for a floor under the main term's stencil as a hypothesis. `Expansion.hD_of_window` with `MainTerm.stencilR_ge_of` already proved that floor for a smooth interpolant of `li` along the doublings, and the Schoenfeld-shaped gate had been composed with it. The shape-free gate had not. `tableFrom_ne_zero_of_relErr_li` is that composition. `tableFrom_ne_zero_of_relErr_li'` states the gap as a bound on the relative error alone. `tableFrom_ne_zero_of_powerSaving` takes a bound `A·(2^m)^θ` on the window's rows with `θ ≤ 1` and `A·2^((r−d−1)(θ−1))` under the gate's threshold, and concludes the cell at `(r, d)` is not zero. That last hypothesis is the statement unit 0402 reaches in the other tree.

**What the check found.** Three things stand between the two trees' statements.

- The interpolant. Every gate theorem in the table's tree, `interpolant_hyps` 4 before this unit, takes a function `G` that is smooth on the whole line with derivative `2^x/x` beyond one half, and agrees with the main term at the rows. No file constructs it.
- Which integral. Stage 3's `Li` is `x/log x` plus the integral of `1/log²` from two. It has the derivative the gate needs along the doublings and differs from the integral of `1/log` by a constant.
- The region. The floor holds where `2d ≤ log 2·(r − d − 1)`: depth small against the row.

**Where the constants stop.** `ThetaPsi.psi_weak_of_theta` builds its constant as a sum: `num_a` 66600 and `num_b` 900 times `e·B/π`, plus `constants_existential` 6 quantities obtained by `obtain` from existence statements. `constants_stage3` 3 of them come from Stage 3's own lemmas about the smoothing bump, proved by compactness or from a big-O; `constants_upstream` 3 come from the upstream package's theorems, which are stated with "there exists `C`". Underneath all of them the bump itself is existential. The floor `x₀` is explicit except for one of the six. The `π`-side constant is `pi_factor` 3 times that sum plus `pi_offset` 13, and unit 0402's `A` divides it by an explicit power.

So a number for `A` or `x₀` needs an explicit bump and those six bounds reproved with constants, three of them in the upstream package. Nothing in this unit does that.

**What is and is not here.** The chain from a window bound on `G` to a nonzero cell is now stated end to end, in two trees that meet at `StmtRelErrWindow` and at the hypothesis of `tableFrom_ne_zero_of_powerSaving`, held by text. It still rests on the window bound, proved nowhere; on the interpolant, constructed nowhere; and it names no row.

What remains. The interpolant as a theorem; the six constants; and, in the other direction, the converse from the cells to the zeros.
