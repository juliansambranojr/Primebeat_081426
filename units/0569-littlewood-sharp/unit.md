---
id: 0569
date: 2026-11-25
type: formalization
title: "littlewood-sharp"
refs: [lean_stage3/Stage3/LittlewoodSharp.lean::littlewood_sharp]
supersedes: []
follows: 0568
context: unit 0568 put Turing's closing height near fourteen thousand with the constants of unit 0566; this sharpens those constants, in Turing at scale of block S14 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S14 of `lean_stage3/design/stencil.md`, Turing at scale. How far do sharper constants in Littlewood's bound lower the height at which Turing's certificate closes?

**What was proved.** `lean_stage3/Stage3/LittlewoodSharp.lean`: `module_lines` 59 lines, `theorems_proved` 1 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 1 axiom pins. The first build had `errors_first` 2 error lines; clean on build `builds` 5. The package builds at `jobs_package` 9013 jobs, the module at `jobs_module` 8877. Traps added, `traps_added` 2; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`LittlewoodSharpLog.lean`: the sharp per-zero integral of the logarithm across the strip, at least minus two, the weight integral of Borel and Caratheodory's bound, and the numerals. `LittlewoodSharpPoint.lean`: the zeros removed in a smaller disc, their count, and Borel and Caratheodory's bound taken at each point instead of on a fixed disc. `LittlewoodSharpHoriz.lean`: `horizLower_sharp`, the lower horizontal bound with constants `a2_sharp` 113/4 and `b2_sharp` 128. `littlewood_sharp`: Littlewood's bound with them.

**The closing height.** Computed, not proved: with ideal sign data Turing's inequality now first closes near `closing_ideal` 1462, against `closing_ideal_before` 14063 before. A size budget saved in `lean_stage3/checks/littlewoodsharp/` ranks the remaining terms; the horizon's slope term from the crude Stirling bound is now the largest.

**Who wrote it.** One worker, `files` 4 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 139 to `trap_last` 140.

What remains. The horizon's slope term, and the sign points up to the closing height.
