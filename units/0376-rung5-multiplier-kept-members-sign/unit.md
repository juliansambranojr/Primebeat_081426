---
id: 0376
date: 2026-11-22
type: run
title: "Rung 5 section 16, item (b): the kept members' sign under the annihilating multiplier holds with a factor 9.4 to spare; swept on the tree's term, not proved"
refs: [lean_stage3/Stage3/WeilPowerBackground.lean::term_eq_neg_sq, lean_stage3/Stage3/WeilOddPower.lean::S_mul_QS]
supersedes: []
follows: 0375
context: unit 0375 priced the annihilating multiplier and left four items open; item (b) was the claim that members kept by the ladder have the target's sign, resting on block 13g, a hand phase budget and one planted instance; Julian chose it first on 2026-11-22
sealed: false
---

**Question.** In section `record.sixteen` 16 of `lean_stage3/design/rung5.md`, a member the ladder keeps sits within `θ_{i*}/ξ` of the target while every annihilated member is beyond `θ_{i*}`. Does its term have the target's sign for every configuration, and by what margin?

**What ran.** `run/kept.py`, through `lab run`, in `record.parts` 5 parts. EXPLORATORY: no prereg, and nothing below is a verdict. The sign is decided by one phase, that of `p(a)²·what(a)²` against `p(s₀)²·what(s₀)²`, which the rotator makes positive real; the kept term has the target's sign exactly when that phase is inside `(−π/2, π/2)`. The script splits the phase into `record.pieces` 5 pieces (the annihilated zeros, their mirrors, the two far points of each orbit, the rotator, and the window's own transform), bounds each, computes the worst case exactly in `mpmath`, samples random ladders, and then plants ladders on the tree's term at `h = ` `record.planted_h` 800 with the actual multiplier, rotator included.

**What it shows.**

The budget. At the `kept.cells` 9 cells of unit `record.unit_price` 0375 the bound on the phase is at most `kept.bound_total_max` 0.16704 rad against `π/2 = ` `kept.half_pi` 1.5708, a factor `kept.bound_margin_min` 9.4. The annihilated zeros carry it: `2N·arcsin(1/ξ)`, at most `kept.bound_ann_max` 0.16667 at `ξ = 12N`. Everything else together is under `kept.bound_rest_max` 0.000369.

The worst case, exact. With every other member annihilated at the least allowed distance and all in the worst direction, the phase reaches `kept.exact_worst_max` 0.16646 rad and exceeds the bound in `kept.exact_over_bound` 0 cells. So the bound is tight and the margin is real: `kept.exact_margin_min` 9.44.

Random ladders. `kept.random_configs` 180000 configurations, `kept.random_flips` 0 flips, largest phase `kept.random_worst_max` 0.06163.

On the tree's term. `kept.planted_trials` 300 planted ladders of `record.planted_members_min` 2 to `record.planted_members_max` 8 members hold `kept.planted_kept` 487 kept members; `kept.planted_wrong_sign` 0 have the wrong sign, and the adversarial placements have `kept.planted_adv_wrong_sign` 0. At this small support the window's own piece is visible: the adversarial phase exceeds the annihilated piece alone by up to `kept.planted_adv_over_ann_max` 0.0152 rad, which is `2·|S'/S|·d·h` with `d·h = π³/(8ξ)`. That piece is why `θ₀` has to scale like `1/h`.

Where it flips. The worst-case phase reaches `π/2` at `ξ` between `kept.xi_flip_over_N_min` 1.2733 and `kept.xi_flip_over_N_max` 1.2735 times `N`; the block's `12N` is `kept.xi_over_flip` 9.42 times that. The check can fail: with `kept.flip_n` 8 planted members, where the threshold is `kept.flip_threshold_n8` 8.93, ratio `kept.flip_ratio` 6 gives a kept member of the wrong sign (`kept.flip_wrong_sign` 1) and ratio `kept.hold_ratio` 12 gives none (`kept.hold_wrong_sign` 0).

**What changes in the block.** Block `13g` is not needed for T9. The comparison is with the target's own transform at a nearby point, a continuity bound; 13g's sign condition never enters. A ladder ratio of `2N` would hold the sign too and shrink unit 0375's ladder term by `kept.ladder_saving_at_2N` 0.221 of itself; the table there is at `12N` and is not re-priced here.

**What it does not show.** This is a sweep. T9 has no Lean proof; what the proof needs is four bounds of the shape `|arg(1 + z)| ≤ arcsin|z|` and one bound on `S'/S` near the real axis. The other open items of section 16 are untouched: the tree's bounds at `h₀`, the far bound's monotonicities, and prior art. Nothing here bears on `StmtWeilPositive`.
