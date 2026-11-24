---
id: 0505
date: 2026-11-24
type: formalization
title: "The perfect fit: the integers' counts, Möbius-signed, add to exactly one at every N"
refs: [lean_stage3/Stage3/PerfectFit.lean::perfect_fit]
supersedes: []
follows: 0504
context: Julian read the cancellation as the harmonic of the integers absorbing the primes' signs, a perfect fit because the harmonic already carries the signs' absence; for the counts it is exact; this is block R14 of `lean_stage3/design/runs.md`
sealed: false
---

**Question.** Block R14 of `lean_stage3/design/runs.md`. Do the integers' counts at every scale, signed by the Möbius function, absorb the signs exactly?

**What was proved.** `lean_stage3/Stage3/PerfectFit.lean`: `module_lines` 39 lines, `theorems_proved` 1 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 1 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8886 jobs, the module at `jobs_module` 8840. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`perfect_fit`: at every number from one up, the counts of the integers at the scales of that number, each signed by the Möbius function, add up to exactly one. It is the inversion of unit `unit_holes` 503 applied to the plainest harmonic, the count itself.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and the pin reads the standard axioms.

What remains. The same signs against the logarithms of the factorials at each scale give the staircase itself. That they absorb within the square root is the open step of the chain, measured to hold in unit `unit_signed` 504 and not proved.
