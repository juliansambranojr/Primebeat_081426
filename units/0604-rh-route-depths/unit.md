---
id: 0604
date: 2026-11-27
type: formalization
title: Depths 1 to 12, every row, under the RH route: the zero count's constant from 112 to 15
refs: [lean_stage3/Stage3/GateAll.lean::window_414_of_RH, lean_stage3/Stage3/GateAll.lean::window_263_of_RH, lean_stage3/Stage3/Stirling2.lean::digamma_second, lean_stage3/Stage3/Stirling2.lean::backlundPhase_const, lean_stage3/Stage3/RvMSharp.lean::rvM_sharp, lean_stage3/Stage3/RouteSharp.lean::window_91_of_RH, lean/RHDepths.lean::only_four_zeros_rh_le12]
supersedes: []
follows: 0603
sealed: false
---

**Question.** The Riemann hypothesis is proved in Lean (leanprover-community/riemann-hypothesis), and stage three's explicit-formula route turns it into an error bound on the prime count. How many depths does that route close for every row, and what stops it?

**What ran.** In `lean_stage3/`: `GateAll`, `Stirling2`, `RvMSharp` and `RouteSharp`; in `lean/`: `RHDepths`. Each built by `lake build` with exit 0 (0fc903c, 2ad5c95, 3335fcc, 447fb99, the `Stirling2` commits through 28ae014, d0f233d, 80e78fa, 4dbeb4a). `run/consts.py`, by `run/run.sh`, through `lab run`, evaluates the route's constant at its floors and the constant each depth's gate accepts at the first uncomputed row; `run/pins.py` reads each theorem's pin and runs the weld check.

**The weld.** `utilities/check_weld.py` compares Mathlib's `RiemannHypothesis` in stage three's Mathlib with the Mathlib pin of the Lean proof (0fc903c), and each bench route statement with the stage-three theorem that concludes it. It passed with `pins.welds_ok` 19 welds and `pins.welds_broken` 0 broken.

**Depths one to eleven.** `window_414_of_RH` gives, from RH alone, the relative-error window with constant `consts.route_crude_2p36` 413.9 (stated as `consts.stated.crude_2p36` 414) at the floor two to the thirty-sixth; `window_263_of_RH` gives `consts.route_crude_2p40` 260.53 (stated as `consts.stated.crude_2p40` 263) at two to the fortieth. At the first uncomputed row the gate accepts up to `consts.need.d10` 1783.05 at depth ten and `consts.need.d11` 411.36 at depth eleven. `only_four_zeros_rh_le10` and `only_four_zeros_rh_le11` carry every depth through eleven, every row, given the π list (`PiNarrow.StmtPiData23`) and the route statements.

**Depth twelve: the zero count.** Depth twelve accepts only `consts.need.d12` 94.74. The route's largest piece was the Riemann–von Mangoldt constant of the `log T` term, set by a first-order comparison of the digamma function with the logarithm. `Stirling2.digamma_second` compares it to second order by the trapezoid rule, `backlundPhase_const` removes the phase's `log T` term, and `rvM_sharp` brings the zero count's constant down from one hundred and twelve to fifteen. On it the route's constant is `consts.route_sharp_2p40` 90.35 (stated as `consts.stated.sharp_2p40` 91), and `only_four_zeros_rh_le12` carries every depth through twelve, every row. Its pin reads `pins.pins.only_four_zeros_rh_le12.axioms` "propext, Classical.choice, Quot.sound".

**What stops it.** Depth thirteen accepts only `consts.need.d13` 21.77, and a relative-error window charges every row the bottom row's error. Unit 0605 (per-row-route) charges each row its own.
