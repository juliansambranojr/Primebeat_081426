---
id: 0373
date: 2026-09-09
type: formalization
title: "WeilPowerAssembly.lean: detect_gap_exists structural attempt reverted; the assembly's existence step is where block 15 stops"
refs: [lean_stage3/Stage3/WeilPowerAssembly.lean::detect_gap_exists]
supersedes: []
follows: 0372
context: unit 0372 closed isTest_phiWC and left detect_gap_exists as the last sorry; this relay pass attempted a structural fill via L = 2 and discovered the choice makes the sign step provably-false at h = 1, so the foreman reverted; the unit records the wrong turn and the shape the real proof needs
sealed: false
---

**Question.** Unit 0372 left detect_gap_exists as the one remaining sorry of block 15. Does one relay pass close it, and if not, what does the honest attempt name?

**What was proved.** `module_lines` 468 lines, `theorems_proved` 8 theorems, `defs` 1 definition, `pins` 8 axiom pins, `sorries` 1 sorry, and `zeta_refs` 0 references to `riemannZeta`.

No new theorem. This unit records what a first-pass relay learns about `detect_gap_exists`.

The attempt. The builder wrote a structural fill: pick `L = 2 * 1` (so `h = 1`, `m = 1`), obtain `ρ₀` from the gap hypothesis, take `G := phiWC 1 ρ₀.im 1`, close `IsTest (2*1) G` via `isTest_phiWC one_pos ρ₀.im (le_refl 1)`, and leave the sign step `(zeroForm G).re < 0` as the sole remaining sorry inside that structure. Steps (a) and half of (e) of the brief's chain closed on the pass. Steps (b), (c), (d), and the sign half of (e) sat inside the sorry.

The wrong turn. At the concrete `L = 2` the outer structure fixes `h = 1`, and at `h = 1` the target's `exp(2 · (wm ρ₀)² · σ_m)` does not dominate the on-line + far bounds. The sign inequality `(zeroForm G).re < 0` is not just unproved at this shape; it is not true at the picked h. Committing to `L = 2` in the outer structure boxed the sign into a provably-false inequality, so the "narrowed" sorry was in fact narrower to something the proof cannot close at all.

The revert. I reverted `detect_gap_exists` to a whole-theorem sorry with a comment naming the tendsto_exp route. The sorry count is unchanged from unit `unit_prev` 0372 at 1. The module builds clean. `foreman_edits` 1 edit (the revert), `foreman_builds` 2 builds (module + full package).

**The build, and the relay.** `errors_first` 0 error lines on the first build (the builder's structural fill compiled). `roots` 0 error roots. `sorries_first` 1 sorry at the builder's stop, matching the final count. `traps_added` 0 rows. `assumed_pins` 0 pins beyond what the block declared.

The measure. The builder read `tokens_first` 22156 tokens over `calls_first` 20 calls in `minutes_first` 6 minutes; short because the structural fill closed on the first try and step (d) sorried immediately.

**What this unit says about the assembly.** The existence proof for `detect_gap_exists` genuinely needs an existentially-chosen `h₀` from `Real.tendsto_exp_atTop`, not a construction at a fixed `L`. The tsum split of `zeroForm` into on-line + `{ρ₀}` + near + far-moderate (empty by the gap hypothesis) + far-large is what the assembly wires together, and each piece has its bounding lemma in the module (`target_lower`, `on_line_le`, `near_nonneg`, `far_moderate_le`, `far_large_le`). The step that does not close in one relay pass is the assembly itself: a substantial block of Lean that (1) chooses `h₀` large enough via `Real.tendsto_exp_atTop`, (2) splits the `∑'` over zeros, (3) discharges the regime hypotheses (F1–F5) at `(h₀, m, ρ₀)`, (4) shows `target.exp > polynomial + cluster.exp_smaller_rate + far.super_small`.

What remains. `detect_gap_exists` still sorries. That is block 15's last open theorem. Whether to invest a further relay pass (or two or three) into the tendsto_exp assembly is Julian's call. The bench state today: 15 modules built, block 15 with one theorem short of the conditional detection statement, block 15's every other piece proved cleanly.

**The lesson.** A structural fill that commits to a wrong outer choice is worse than a whole-theorem sorry, because it boxes the follow-up into an unprovable case. When the builder saw the target's exp doesn't dominate at h = 1, the honest move was to leave detect_gap_exists as a whole-theorem sorry and let the follow-up pick h existentially. The revert here restores that shape.
