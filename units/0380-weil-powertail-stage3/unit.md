---
id: 0380
date: 2026-11-22
type: formalization
title: "WeilPowerTail.lean: the tail bound, an upper bound on S for every w with no regime; block 16a, the first module of section 16"
refs: [lean_stage3/Stage3/WeilPowerTail.lean::sum_inv_pow4_le_third, lean_stage3/Stage3/WeilPowerTail.lean::norm_one_add_le, lean_stage3/Stage3/WeilPowerTail.lean::norm_T_le_tail, lean_stage3/Stage3/WeilPowerTail.lean::norm_S_le_tail]
supersedes: []
follows: 0379
context: unit 0378 priced section 16 on proved-form inequalities and found the tree's upper bounds on S leave a hole for off-line zeros at real part offset one half; one new lemma was named to fill it and block 16a stated it in Lean; this is that module
sealed: false
---

**Question.** Block `16a` of worksheet section `section` 16 (`rung5.md#16a`). The tree bounds `‖S m w‖` above in two regimes that do not meet: at real part offset `1/2` the Gaussian bound stops closing at height distance `hole_from` 1.233 and its regime ends at `hole_regime_end` 2.164, and the far bound starts at `far_from` 4.499. Is there a bound with no regime that covers the gap, provable from what the tree already has?

**What was proved.** `module_lines` 211 lines, `theorems_proved` 6 theorems, `defs` 0 definitions, `pins` 4 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries. `norm_one_add_le` is the elementary step: for every complex `z`, `‖1 + z‖ ≤ exp(Re z + ‖z‖²/2)`, from `‖1 + z‖² = 1 + 2 Re z + ‖z‖²` and `x + 1 ≤ exp x`. `norm_g_le` applies it to one factor of the tail product. `sum_inv_pow4_le_third` telescopes the fourth powers, `1/(k+1)⁴ ≤ (1/3)(1/k³ − 1/(k+1)³)`, and `sum_hterm_sq_le` turns that into the quartic constant. `norm_T_le_tail` bounds the tail product with the partial tail sum, and `norm_S_le_tail` passes to the limit with both sides moving: for every `w` with `QS m w ≠ 0`, `‖S m w‖ ≤ (cS m/D m)·‖w‖·exp(Re(w²)·sigma m + ‖w‖⁴/(6π⁴(m+1)³))`.

The statements are block 16a's, unchanged: `assumed_pins` 0 hypotheses were added. The one hypothesis, `QS m w ≠ 0`, is what `WeilPowerGauss.tendsto_S` needs.

**What it changes.** Against `WeilPowerSharp.norm_S_le_c_neg` the factor on `Re(w²)` is the tail sum itself, the quartic coefficient is a sixth of that lemma's, and the regime hypothesis is gone. Unit `unit_price` 0378 checked this inequality against the exact `S` at `grid_points` 20000 points with `grid_violations` 0 violations before it was built; it is now a theorem. With it, every zero of section 16 that is neither annihilated nor kept has a proved bound.

**The build.** `errors_first` 0 errors from `roots` 0 root causes and `warnings_first` 0 warnings on the first build. `traps_added` 0 rows. Module at `jobs_module` 8664 jobs, package at `jobs_package` 8772. `header_edits` 1 edit after the first build: a line of the header comment began with the word theorem, so the count of theorem lines read one too many; the line was reflowed and the module rebuilt. `steps_skipped` 2 steps of the loop were skipped: the orient hook, which does not exist in a cloud session, and the scratch pass, replaced by grepping each name in the pinned source. `LOOP.md` records the first at version `loop_version` 22.

What remains. Section 16's other theorem lines: the multiplied window and its term (T1, T2), the multiplier's elementary bounds and the ladder (T5 to T8), the kept members' sign (T9), and the assembly (T11), which has the shape unit 0373 stopped at. Rung `rung` 5.
