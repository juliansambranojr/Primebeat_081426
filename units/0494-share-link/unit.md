---
id: 0494
date: 2026-11-23
type: formalization
title: "The real part of a zero is a share of the total; the pair meets at the square root exactly at one half"
refs: [lean_stage3/Stage3/ShareLink.lean::share_is_re, lean_stage3/Stage3/ShareLink.lean::pair_shares_add, lean_stage3/Stage3/ShareLink.lean::meet_sqrt_iff, lean_stage3/Stage3/ShareLink.lean::spiralLink_iff_meet]
supersedes: []
follows: 0493
context: unit 0488 joined the band of the deep zero to the chain and left a cell's share and a zero's real part as unrelated numbers; Julian gave the relation: the table flipped inside out is a line on which the prime and composite halves meet in the middle; this is block J6 of `lean_stage3/design/closedloop.md`
sealed: false
---

**Question.** Block J6 of `lean_stage3/design/closedloop.md`. What share of a cell's total is the real part of a zero?

**What was proved.** `lean_stage3/Stage3/ShareLink.lean`: `module_lines` 113 lines, `theorems_proved` 8 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 1. The package builds at `jobs_package` 8879 jobs, the module at `jobs_module` 8841. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`mode_size`, `share_is_re`: at a total, the mode of a zero has the size of the total to the zero's real part. Read on the multiplying scale, as the logarithm to the base of the total, the share of the total that the mode takes is the zero's real part.

`pair_shares_add`, `add_shares_add`: the share of a zero and the share of its mirror add to the whole. So do the shares of any parts that add to the total, the primes and the composites of a cell among them. The first split multiplies and the second adds.

`meet_iff`, `meet_sqrt_iff`: a zero's mode and its mirror's are the same size exactly when the real part is a half, and there each is the square root of the total.

`swap_flips_residual`: if the prime cell is a smooth part plus a residual, the composite cell is the rest of the total less the same residual. The swap changes a sign and moves no mode.

`spiralLink_iff_meet`: the spiral link holds exactly when every zero's mode is the size of its mirror's.

**Who wrote it.** Written and built here; it compiled on the first build. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it says.** Unit `unit_band` 488 left a cell's share and a zero's real part as different numbers. They are the same kind of number: a share of the total. Flipped from adding to multiplying, the table is a line of exponents, and a zero sits on it at its real part. The middle of the line is the square-root size.

What remains. That the zeros' mirror is the table's swap. The swap fixes every mode. Nothing here forces the multiplying split to be even.
