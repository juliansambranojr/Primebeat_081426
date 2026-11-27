---
id: 0605
date: 2026-11-27
type: formalization
title: Depths 13 to 15, every row: each row's error at its own size, and the psi-to-pi transfer without its factor three
refs: [lean_stage3/Stage3/RouteSharp.lean::weakWindow127_of_RH, lean_stage3/Stage3/PsiToPiSharp.lean::schoenfeldWeak_of_psiWeak_sharp, lean_stage3/Stage3/RouteTight.lean::weakWindow40_of_RH, lean/WeakDepths.lean::error_boundC, lean/WeakDepths.lean::weak_lt_floor, lean/WeakDepths.lean::H_w2_ge2, lean/WeakDepths.lean::only_four_zeros_rh_le15]
supersedes: []
follows: 0604
sealed: false
---

**Question.** The relative-error route charges every row of a window the bottom row's error, and stops at depth twelve (unit 0604, rh-route-depths). If each row is charged its own error, how far does the same RH bound go?

**What ran.** In `lean_stage3/`: `RouteSharp` (1457ec7), `PsiToPiSharp` and `RouteTight` (740c083); in `lean/`: `WeakDepths` (b0c7f6e, 14c6d38). Each built by `lake build` with exit 0. `run/consts.py`, by `run/run.sh`, through `lab run`, evaluates the route's constant at the floor two to the thirty-eighth and the constant the per-row gate accepts at the first uncomputed row; `run/pins.py` reads each theorem's pin and runs the weld check.

**The per-row gate.** `WeakDepths.error_boundC`: if each row of the window is within its own `C·(log 2·m)·2^(m/2)`, the stencil's error is at most `C·(log 2·r)·2^(r/2)·(1 + 2^(−1/2))^n`, the binomial sum of the rows' sizes. `tableFrom_ne_zero_weak` sets that against the exact floor. Under RH the route gives every row its own bound with constant `consts.route_old_transfer` 126.97, stated as `consts.stated.old` 127 (`weakWindow127_of_RH`). The gate accepts up to `consts.need_half.d13` 455.79 at depth thirteen and `consts.need_half.d14` 129.88 at depth fourteen, so `only_four_zeros_rh_le14` carries every depth through fourteen, every row.

**Two lost factors.** Depth fifteen accepts only `consts.need_half.d15` 36.91. Stage three's ψ-to-π transfer charged its lower-order terms against a logarithm of at least one; `schoenfeldWeak_of_psiWeak_sharp` keeps the floor's logarithm, and the constant becomes `consts.route_sharp_transfer` 39.68, stated as `consts.stated.sharp` 40 (`weakWindow40_of_RH`). The bench bounded the floor's integral by one over twice the row; `H_w2_ge2` puts the logarithm of two in the denominator, its exact lower bound. With both, depth fifteen accepts `consts.need_log.d15` 53.25, and `only_four_zeros_rh_le15` carries every depth through fifteen, every row, given the π list and the route. Its pin reads `pins.pins.only_four_zeros_rh_le15.axioms` "propext, Classical.choice, Quot.sound".

**The weld.** `utilities/check_weld.py` now compares each bench route statement with the conclusion of the stage-three theorem that proves it; before b0c7f6e the route statements were matched only in their docstrings. It passed with `pins.welds_ok` 19 welds and `pins.welds_broken` 0 broken, and a changed constant turns it red.

**What is left.** Depth sixteen accepts `consts.need_log.d16` 15.09 at the first uncomputed row. Unit 0602 (route-constant-factors) breaks the remaining constant into its pieces and finds where the middle band stops.
