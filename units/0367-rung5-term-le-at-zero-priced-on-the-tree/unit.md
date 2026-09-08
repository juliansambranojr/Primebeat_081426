---
id: 0367
date: 2026-09-08
type: decision
title: "Rung 5: term_le_at_zero priced on the tree's own inequalities across the 45 cells of unit 0366; the gap-dependent L closes, with the proven bound's lost factor in h measured"
refs: [lean_stage3/Stage3/WeilPowerBridge.lean::term_le_at_zero, lean_stage3/Stage3/WeilPowerSharp.lean::S_real_ge_sharp, lean_stage3/Stage3/WeilPowerSharp.lean::norm_S_le_c_pos, lean_stage3/Stage3/WeilPowerSharp.lean::norm_S_le_c_neg, lean_stage3/Stage3/WeilPowerBounds.lean::norm_S_le_far, lean_stage3/Stage3/WeilPowerOnLine.lean::onLineBound_le]
supersedes: []
follows: 0366
context: unit 0366 priced the gap-dependent L on the term itself, with S in closed form (says what is true); this unit reprices the same 45 cells on the tree's own inequalities (says what the tree can prove) and reports the lost factor between the two, which is the CLAUDE.md rule's target
sealed: false
---

**Question.** Unit 0366 priced `L(ε, T, δ)` on the term with `S` in closed form and every cell closed. The pin left after unit `unit_bridge` 0362 asks to price the whole term on `term_le_at_zero`'s right-hand side, the tree's proven inequality, and name the quantifier the price changes. Does the price still exist on the proven bound, at what cost in the support `h`, and what does the tree lose against the truth?

**What ran.** `run/proven.py` evaluates the right-hand side of `WeilPowerBridge.term_le_at_zero` at the target and its analogues at the members and the far zeros, in log space so `h` reaches `record.hmax` 1000000000000: `WeilPowerSharp.S_real_ge_sharp` at the target's `w = εh` real (the sharp `cS/D · s · exp(s²/(π²(m+2)) − s⁴/(π⁴(m+1)³))`), `norm_S_le_c_pos` and `norm_S_le_c_neg` at each member `w = (ε' + iΔ)h` (the Gaussian upper bound, both signs of `Re w²`), `norm_S_le_far` at the far sideband and at the far zeros where the far condition holds. `WeilPowerOnLine.onLineBound_le` gives the background, `record.lowcount_used` 0 for `lowCount`. Every regime hypothesis is named and checked at each `(h, lam, ε, δ)`: `target_F4` (`|w|² ≤ π²(m+2)²/2`), `target_F5` (`q m w ≤ 1`), `target_F2_far` (`2(εh)² + 2π²(m+1)² ≤ (2γh)²`), `member_F4`, `far_zero` (the far condition at `|Δ| = 1/2`). Same `record.cells` 45 cells as unit 0366: `ε ∈ {0.5, 0.25, 0.1}`, `T ∈ {10³, 10⁶, 10¹²}`, `δ ∈ {1, 0.3, 0.1, 0.03, 0.01}`; menu of `record.lam_menu` 13 values of `λ` bounded above by the F2-far cap `γ√2/π`.

**What it shows.**

Every cell closes. `proven.cells_closed` 45 of `record.cells` 45, on the tree's own inequalities. So `L(ε, T, δ)` earned on `term_le_at_zero` exists at explicit `(h, λ)` at each cell, and the gap-dependent theorem is not a lost factor: it is a longer proof.

The lost factor. Ratio of the proven `h` to unit 0366's exact `h`, cell by cell (`proven.pairs_compared` 45 pairs). Minimum `proven.ratio_min` 1.0 (the background-binding cells, where the target's exp bound is already tight against the background). Median `proven.ratio_median` 1.02. Maximum `proven.ratio_max` 35.6, at every one of the three `δ = 0.01, ε = 0.5` cells; the worst is `T = 10³` with `h_proven` at `proven.worst_h_proven` 9324929 against exact `proven.worst_h_exact` 261814. So the tree pays a factor of about `worst_ratio_int` 36 in `h` in the tightest cluster corner and pays nothing where the background binds. The lost factor lives entirely in the `2m+3` prefactor of `WeilPowerCompare.compare_le` — the ratio of the member's upper bound to the target's lower bound — and in the shrinking exponent gap `(δ²·h/(π²λ²))` the Gaussian regime carries.

The λ menu is used. `record.max_lam_used` `proven.lam_max_used` 32 across cells. Where the cluster binds the search rises to `λ = 8`, `λ = 32` at the tightest δ; the F2-far cap `γ√2/π` was never reached (at `γ = T = 1000` it is `record.lam_cap` 450). Block 13e's decision to make `λ` free is what makes these cells close: at `λ = 1` the tightest δ cell has no `h` below the F5 cap that satisfies `L > R`.

The quantifier. The pricing does not change what unit `unit_exact` 0366 named: `L(ε, T, δ)` needs no other off-line zero at height distance in `(lo/b, δ)` from the target, `lo = λπ³/(8ε')`. The rung's `∀ configurations` still becomes `∀ configurations with no member in that window`; the death of the uniform `L` (unit `record.unit_audit` 0361) is untouched. What changed is the size of `L` at that condition: `record.L_worst` `18649858` for the worst cell against `record.L_worst_exact` 523628 of 0366.

The regime table. `record.f4_binds` 0 cells blocked by target_F4 (F4 is generous once λ scales), `record.f5_binds` 0 cells blocked by target_F5 (raising λ pushes it), `record.f2_binds` 0 cells blocked by target_F2_far (the F2-far cap on λ is above the λ any cell needs). Every cell that failed unit `unit_exact` 0366's exact bound would have to fail on `member_F4` or the arithmetic of the exp gap; none did.

**Decision.** The pin left after unit 0362, "price the whole term on term_le_at_zero, the tree's object, naming the quantifier," is DONE by this unit. Both the exact term (unit `unit_exact` 0366) and the tree proven bound (unit `unit_this` 0367 here) close every cell of the same 45-cell table. The lost factor is at most `record.worst_ratio_int` 36 in `h` and lives in the `2m+3` prefactor of the comparison; no size explodes, no regime hypothesis blocks a cell. Whether the conditional theorem on `L(ε, T, δ)` becomes a Lean module is still Julian's call, with the price now measured on the tree's own inequalities.
