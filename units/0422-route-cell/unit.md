---
id: 0422
date: 2026-11-22
type: formalization
title: "RouteCell.lean: the table's gate at depth six on the statement the explicit-formula route proves under RH"
refs: [lean/RouteCell.lean::cell_ne_zero_of_route]
supersedes: []
follows: 0421
context: unit 0421 proved, in Stage 3 under RH, the two analytic hypotheses of the table's gate at depth six from row eighty; this is the table tree's half of block E9, the gate applied to that statement, 2026-11-22
sealed: false
---

**Question.** Block E9 of `lean_stage3/design/joints.md`, the table tree's half. From the statement unit 0421 proves, taken as a hypothesis in the same characters, is the cell at depth six nonzero?

**What was proved.** In the table's tree, toolchain `toolchain` 4.28.0: `lean/RouteCell.lean`, `module_lines` 61 lines, `theorems_proved` 1 theorem, `sorries` 0 sorries, `pins` 1 axiom pin at `axioms` 3 axioms, clean on build `builds` 1 with `errors_first` 0 errors. The module builds at `jobs_module` 8035 jobs, the tree at `jobs_tree` 8056; its index reads `theorems_lean` 345 theorems across `modules_lean` 30 modules. The welds are as they were: `welds` 10, `broken_welds` 0 broken.

`cell_ne_zero_of_route`: for a row of at least `row_min` 80, if the table's rows are the differences of `f` along the doublings on the window, and if there is a relative error for which the window statement holds against the main term and which is under the gate's threshold, then the cell at that row and depth `depth` 6 is not zero. The main term in the hypothesis is the integral formula; the proof turns it into the constructed interpolant at the rows and applies the gate of unit 0412. The gate's two side conditions follow from the row being at least eighty.

**What the two halves say together.** Unit 0421, in Stage 3: under RH, the hypothesis of this theorem holds for the rows of the prime count, for every row from eighty on. This unit, in the table's tree: that hypothesis makes the cell at depth six nonzero. Read across the join: under RH, no cell at depth six is zero from row eighty on.

**What holds the join.** The two trees are on different toolchains, and no kernel has checked the composition. The definition `StmtRelErrWindow` is welded, character for character, by `utilities/check_weld.py`. The rest of the hypothesis, the main term and the threshold, is the same text in both files and is compared by no checker. A reader can compare `gate_hyp_of_RH`'s conclusion with `hroute` here by eye.

**What it is not.** Unconditional: RH is the hypothesis on the other side. A statement about the rows below eighty: those are the census's, computed. A statement about other depths.

What remains. A checker for the join, or the two halves on one toolchain. Other depths. And the direction from the table to the zeros, which this stretch never touched.
