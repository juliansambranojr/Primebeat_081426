---
id: 0500
date: 2026-11-23
type: formalization
title: "The day's runs and readings in Lean: exact forms proved, the measured sizes named"
refs: [lean_stage3/Stage3/Readings.lean::half_rung_ratio, lean_stage3/Stage3/Readings.lean::half_regime_shares, lean_stage3/Stage3/Readings.lean::net_is_sum_of_steps, lean_stage3/Stage3/Readings.lean::paper_lemma_zero, lean_stage3/Stage3/Readings.lean::paper_mid_rec, lean_stage3/Stage3/Readings.lean::iv_exact, lean_stage3/Stage3/Readings.lean::wire_holds_iff]
supersedes: []
follows: 0499
context: Julian asked for the runs of the day (units 0492, 0497, 0499 and the table at regimes of three halves) and the readings (current and wire, five sixths, no memory, the paper's section 5.3 (iv)) proved; this is block J10 of `lean_stage3/design/closedloop.md`
sealed: false
---

**Question.** Block J10 of `lean_stage3/design/closedloop.md`. Which of the day's runs and readings have an exact form Lean accepts, and where does each of the others stop?

**What was proved.** `lean_stage3/Stage3/Readings.lean`: `module_lines` 168 lines, `theorems_proved` 14 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 7 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8883 jobs, the module at `jobs_module` 8845. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`half_rung_ratio`: between two half powers of two, a rung's length over its top is one less the reciprocal of the square root of two, at every index. `half_regime_shares`: cut at the half power, a doubling's lower half holds the square root of two less one and its upper half two less the square root of two. These are the ratios measured in unit `unit_half` 497, exact.

`net_is_sum_of_steps`: the sieve's net rounding is the sum over the primes of each prime's step, for any assignment of terms to primes. This is the bookkeeping of unit `unit_memory` 499.

`five_sixths_midpoint`, `five_sixths_step`: five sixths is the midpoint of two thirds and the whole, one sixth past two thirds, the mirror of one sixth. `force_at_family`: the closed loop's restoring force at the Holy Family's support and condition is five sixths. `paper_lemma_zero`: the paper's printed mismatch is zero exactly at a third past the half. `lattice_opens`: five and seven are the first primes of the two classes modulo six. `paper_mid_rec`, `paper_mid_values`: the paper's midpoints from the regime of two and three on obey the recurrence with offset one half. `paper_first_mid`: the paper's first regime does not.

`offset_fixed`: the offset is one half at every doubling, a statement with no zero in it. `iv_exact`: a zero off the line makes the staircase run away. Together they give the paper's step (iv) its exact form: an off-line zero leaves the offset as it is and shows as the runaway.

`wire_holds_iff`: the link holds exactly when the balance holds at every number from some point on.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The measured sizes of unit `unit_scales` 492, of unit `unit_memory` 499 and of the table at regimes of three halves are counts over numbers past a million; the kernel checks such counts only through `native_decide`, which the repo refuses. The residual with no memory has no proof: unit `unit_memory` 499 measured the sieve's steps remembering. The balance at every number is the link itself and has no proof.
