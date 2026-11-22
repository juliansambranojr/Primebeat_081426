---
id: 0423
date: 2026-11-22
type: formalization
title: "TableRoute.lean: the join between the two trees closed for the explicit-formula route, one theorem from RH to a cell of the table"
refs: [lean_stage3/Stage3/TableRoute.lean::cell_ne_zero_of_RH]
supersedes: []
follows: 0422
context: units 0421 and 0422 proved the two halves of block E9 in two trees and recorded that the join between them was text no kernel checked; Julian said the caveats on the join were problems left unaddressed, 2026-11-22; this unit addresses them
sealed: false
---

**Question.** Can the conditional statement about depth six be one theorem, checked by the kernel, with the text join out of it?

**What was done.** Two things.

The checker. `utilities/check_weld.py` compared definitions only. It now also compares a theorem's conclusion in one tree with a named hypothesis of a theorem in the other, whitespace collapsed, after the substitutions the entry declares. The pair of unit 0422 is entered: `gate_hyp_of_RH`'s conclusion against `cell_ne_zero_of_route`'s hypothesis, with the welded definition's namespace and the rows of the prime count for the free row function. It reports `welds` 11 welds, `broken_welds` 0 broken, and a changed exponent in one side was tried in memory and caught.

The port. The `port_modules` 10 modules of the table's tree that its gate depends on, `port_lines` 2579 lines, were copied into `lean_stage3/Stage3/TablePort/` and built on Stage 3's toolchain. `port_unchanged` 8 of them build with only their import lines changed. The newer Mathlib broke three proof steps in the other two: `MainTerm` differs from its original by `diff_mainterm` 2 diff lines and `Expansion` by `diff_expansion` 19, each a proof step rewritten with the statement untouched. Every copied module keeps its axiom pins and they pass.

**What was proved.** `lean_stage3/Stage3/TableRoute.lean`: `module_lines` 48 lines, `theorems_proved` 1 theorem, `defs` 1 definition, `sorries` 0 sorries, `pins` 1 axiom pin at `axioms` 3 axioms, clean on build `builds` 1 with `errors_first` 0 errors. The package builds at `jobs_package` 8817 jobs, the module at `jobs_module` 8777. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`rowN` is the table's row, the number of primes in each dyadic block. `cell_ne_zero_of_RH`: under RH, for every row of at least `row_min` 80, the cell of the table of `rowN` at that row and depth `depth` 6 is not zero.

**What it settles.** The three statements unit 0422 made about the join. The composition is checked by a kernel. The definition that was welded is, on this route, the same definition unfolded on both sides inside one tree. The rest of the hypothesis is no longer text compared by eye: the checker compares it between the trees, and in Stage 3 it is not a hypothesis at all.

The table's own tree is untouched, and its copy of the gate still meets Stage 3 by the weld; that weld now has a checker for the statement as well as the definition.

What remains. The same theorem at other depths. The copies in `TablePort` drift from `lean/` if either is edited; nothing compares them yet.
