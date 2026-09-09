---
id: 0371
date: 2026-09-09
type: formalization
title: "WeilPowerAssembly.lean: block 15 close-out pass — three placeholders lifted to real signatures with clean pins, isTest_phiWC and detect_gap_exists sorries narrowed"
refs: [lean_stage3/Stage3/WeilPowerAssembly.lean::near_nonneg, lean_stage3/Stage3/WeilPowerAssembly.lean::far_moderate_le, lean_stage3/Stage3/WeilPowerAssembly.lean::far_large_le, lean_stage3/Stage3/WeilPowerAssembly.lean::isTest_phiWC, lean_stage3/Stage3/WeilPowerAssembly.lean::detect_gap_exists]
supersedes: []
follows: 0370
context: unit 0369 landed offLineBox_finite; unit 0370 landed contDiff_one_indicator_Icc; this unit's relay pass uses both to close as much of WeilPowerAssembly as one pass reaches — the three True placeholders lift to real signatures with clean pins, and the two remaining sorries narrow to specific goals
sealed: false
---

**Question.** Both of unit `unit_partial` 0368's blocking lemmas landed in units `unit_box` 0369 and `unit_indicator` 0370. Does one relay pass over `WeilPowerAssembly` lift the three True placeholders to real signatures, close `isTest_phiWC`, and close `detect_gap_exists`?

**What was proved.** `module_lines` 328 lines, `theorems_proved` 7 theorems, `defs` 1 definition, `pins` 7 axiom pins, `sorries` 2 sorries (down from `sorries_before` 2 with different content).

Three placeholders lifted to real signatures with clean pins. `near_nonneg` now says: for a `Finset ℂ` `near_set ⊆ OffLineBox ε T` with a per-member pointwise nonnegativity hypothesis, the sum of `termW h γ m ρ` over `near_set` is nonnegative. Closes by `Finset.sum_nonneg`, pin at `axioms` 3 axioms. `far_moderate_le` takes a `Finset ℂ` `fm_set ⊆ OffLineBox ε T` with a card bound `card_a1` 15 × log T + `card_a3` 73 and a per-member absolute bound `U_mem`, gives `|Σ termW| ≤ (15 log T + 73) · ((h/2)² · U_mem²)`. Closes by `Finset.abs_sum_le_sum_abs` chained with `Finset.sum_le_sum`, `Finset.sum_const`, `nsmul_eq_mul`, `mul_le_mul_of_nonneg_right`. `far_large_le` mirrors it at the count `far_a1` 15 × log T + `far_a3` 698. All three pin sorry-free.

`isTest_phiWC` narrowed. Three of the four `IsTest (2h) (phiWC h γ m)` conjuncts closed on the pass: real-valuedness by `phiWC_real`, `HasCompactSupport` by `HasCompactSupport.intro` on `isCompact_Icc` with the indicator vanishing outside `Icc (-h) h`, and `tsupport ⊆ Icc (-(2h)/2) ((2h)/2)` by rewriting the endpoints and appealing to `tsupport_indicator_subset`. The `ContDiff ℝ 1 (phiWC h γ m)` conjunct is the remaining sorry: `phiWC = Complex.ofRealCLM ∘ phiW`, then `contDiff_one_indicator_Icc` at `f u = W h γ m u · exp(-u/2)` on `Icc (-h) h`. The four boundary hypotheses (`f(±h) = 0`, `deriv f (±h) = 0`) need product/composition-derivative machinery tied to `P(±1) = cos²(±π/2) = 0` for `m ≥ 1`; that did not close on one try. The goal is in a comment naming the exact route.

`detect_gap_exists` unchanged in status but the chain is now written out in comments as steps (a)–(e): pick `ρ₀` from `offLineBox_finite` via `Finset.exists_max_image`; unfold `L = 2h`; split the assumed box into near/far-moderate/far-large; force the exponential-vs-polynomial existence via `Real.tendsto_exp_atTop` (target rate `ε²/(π²(m+2))` vs cluster rate `(ε² − δ²)/(π²(m+2))`); take `G := phiWC h γ m` and combine `target_lower`, `near_nonneg`, `far_*_le`, `on_line_le`. Step (d) is the hardest and did not close on one try.

**The build, and the relay.** `errors_first` 0 error lines on the first build. `roots` 0; the module built clean with two `declaration uses sorry` warnings only. `sorries_first` 2 sorries at the builder's stop, matching the final count. `traps_added` 0 rows, `row_cascade` 19 recurred and cleared at the two pin docstrings that now record `sorryAx` under their sorries. `assumed_pins` 3 pins the builder promoted into the header docstring for the foreman: `near_nonneg`'s per-member `h_pointwise` hypothesis in place of raw regime witnesses (F1–F5 of block 13g), `far_moderate_le` and `far_large_le` taking `U_mem`/`U_far` as `ℝ` parameters with supplied per-member bounds. Module at `jobs_module` 8742 jobs, package at `jobs_package` 8771. Built under the loop at version `loop_version` 21.

`foreman_edits` 0 edits and `foreman_builds` 0 builds. The builder closed everything on one relay pass and I did not attempt the two remaining sorries as the foreman: `isTest_phiWC`'s ContDiff conjunct needs the derivative-of-product-and-composition work at `phiW`'s boundary, and `detect_gap_exists`'s step (d) is the exponential-vs-polynomial existence proof that the block itself sized as the assembly's biggest piece. Each of those is its own follow-up unit.

The measure. The builder's first pass read `tokens_first` 133586 tokens over `calls_first` 56 calls in `minutes_first` 11 minutes.

What remains. Two sorries with named goals. One follow-up unit for `isTest_phiWC`'s ContDiff conjunct, which is entirely arithmetic on the phiW boundary computation. One follow-up unit for `detect_gap_exists`'s step (d), which is the assembly's existence proof. Neither is a lost factor; each is real Lean writing. Julian's call whether to run them next or leave block 15 at this shape.
