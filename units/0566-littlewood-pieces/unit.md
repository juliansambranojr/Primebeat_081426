---
id: 0566
date: 2026-11-25
type: formalization
title: "littlewood-pieces"
refs: [lean_stage3/Stage3/TuringLW.lean::littlewood_holds]
supersedes: []
follows: 0565
context: unit 0563 reduced Littlewood's bound on the integral of the argument's remainder to three named pieces; this proves them, in Turing's method of block S14 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S14 of `lean_stage3/design/stencil.md`, Turing's method. Does Littlewood's bound on the integral of the argument's remainder hold with explicit constants and no open hypothesis?

**What was proved.** `lean_stage3/Stage3/TuringLW.lean`: `module_lines` 31 lines, `theorems_proved` 1 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 1 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8992 jobs, the module at `jobs_module` 8874. Traps added, `traps_added` 11; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`TuringLWSplitOsc.lean`: `stmtOsc_holds`, the oscillation of the integrated logarithmic derivative on the line of real part two at most two, through primitives of the von Mangoldt series. `TuringLWSplit.lean`: `stmtSplit_holds`, the imaginary part of the integrated argument principle on the strip from one half to two, by Fubini, the fundamental theorem along verticals and the finiteness of zeros in a rectangle; and `littlewood_of_lower`, Littlewood's bound from the lower horizontal bound alone. `TuringLWHorizLog.lean`, `TuringLWHorizPoint.lean` and `TuringLWHoriz.lean`: `horizLower_holds`, the integral of the logarithm of zeta across the strip at a height at least minus `a2` 102 times the logarithm of the height less `b2` 500, by Borel and Caratheodory's inequality through the Blaschke quotient of the dependency and the local zero count. `littlewood_holds`: Littlewood's bound with explicit constants and no open hypothesis, written here. With it, Turing's certificate of unit 0563 rests on the sign data alone.

**Who wrote it.** Two workers and the assembly here, `files` 6 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms; the dependency's `sorry`s are in lemmas these proofs do not use, which the axiom pins confirm. Traps: TRAPS.md rows `trap_first` 121 to `trap_last` 131.

What remains. The sign data: a rigorous evaluation of the completed zeta on the line in Lean.
