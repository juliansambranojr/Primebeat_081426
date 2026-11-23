---
id: 0488
date: 2026-11-23
type: formalization
title: "The band of the deep zero and the strip of the zeros under one map; the spiral link is the middle circle"
refs: [lean_stage3/Stage3/BandJoin.lean::share_pair, lean_stage3/Stage3/BandJoin.lean::zero_in_band, lean_stage3/Stage3/BandJoin.lean::zero_pair, lean_stage3/Stage3/BandJoin.lean::spiralLink_iff_middle]
supersedes: []
follows: 0487
context: `lean/DeepZeroBand.lean` proves the band of the shares of a cell and says nothing there ties a share to a zero; the chain of unit 0479 did not contain the band; Julian asked that the band be joined; this is block J5 of `lean_stage3/design/closedloop.md`
sealed: false
---

**Question.** Block J5 of `lean_stage3/design/closedloop.md`. Where do the zeros of zeta land under the map that makes the band of the deep zero?

**What was proved.** `lean_stage3/Stage3/BandJoin.lean`: `module_lines` 133 lines, `theorems_proved` 12 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 4 axiom pins. The first build had `errors_first` 7 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8874 jobs, the module at `jobs_module` 8840. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

The band's map at base `base` 2 sends a number to two to the power of minus that number. `bandR_zero`, `bandR_one`: nothing goes to the outer circle and the whole goes to the inner. `bandR_mirror`, `share_pair`: a share and its mirror, the two parts of any total, have images that multiply to a half. `bandR_in_band`: a share between nothing and the whole lands between the circles. `bandR_middle_iff`: the middle circle is reached at a half and nowhere else. These are the statements of `lean/DeepZeroBand.lean`, restated here.

`zero_image`: the size of two to the power of minus a zero is the band's map at the zero's real part.

`zero_in_band`: every nontrivial zero lands strictly between the two circles.

`zero_pair`: a zero and its mirror have images that multiply to a half, as the prime share and the composite share of a cell do.

`zero_middle_iff`, `spiralLink_iff_middle`: a zero is on the middle circle exactly when its real part is a half, and the spiral link holds exactly when every zero is on the middle circle.

**Who wrote it.** Written and built here. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it says.** The band the deep zero and its inverse make is the band the zeros live in. Its edges are the deep zero and its inverse, and no zero touches either. Its mirror is the mirror of the zeros. Its middle is the line. The band is now a link of the chain of unit `unit_chain` 479.

What remains. The share of a cell and the real part of a zero are still two numbers. No theorem here makes one from the other.
