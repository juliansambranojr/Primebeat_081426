---
id: 0378
date: 2026-11-22
type: decision
title: "Rung 5 section 16, items (a) and (c): on proved-form inequalities the price moves by at most 2.2 percent; one new lemma is needed, and the far bound's monotonicities are no longer used"
refs: [lean_stage3/Stage3/WeilPowerSharp.lean::S_real_ge_sharp, lean_stage3/Stage3/WeilPowerSharp.lean::norm_S_le_c_neg, lean_stage3/Stage3/WeilPowerBounds.lean::norm_S_le_far, lean_stage3/Stage3/WeilPowerBackground.lean::online_term_le_near, lean_stage3/Stage3/WeilPowerGauss.lean::tendsto_S]
supersedes: []
follows: 0377
context: unit 0375 priced the annihilating multiplier on the exact S and left open which proved bounds reach its supports (item a) and two numerical monotonicities of the far bound (item c); Julian chose on 2026-11-22 to finish section 16 as mathematics, this pricing first
sealed: false
---

**Question.** Unit `record.unit_price` 0375's table is on the exact `S`. Priced only on inequalities in the shape of Lean statements, the tree's where they reach and new ones named where they do not, do the same cells close, and what is lost?

**What ran.** `run/proven.py`, through `lab run`. EXPLORATORY: no prereg, nothing below is a verdict. Every bound is first checked against the exact `S` on a random grid, inside its own hypotheses, and the price runs only if none is violated.

**What it shows.**

The tree's bounds leave a hole. For a zero off the line at real part offset `1/2`, the tree's Gaussian upper bound `norm_S_le_c_neg` has an exponent that turns positive at height distance `proven.cneg_positive_from_tau` 1.233 and a regime that ends at `proven.cneg_regime_end_tau` 2.164; the far bound `norm_S_le_far` starts at `proven.far_regime_from_tau` 4.499. Between them the bounds I read give nothing that closes. Section 16 cannot use section `record.six` 6 or the comparison lemmas there.

One new lemma fills it. N1, the tail bound: `‖S m w‖ ≤ cS m / D m · ‖w‖ · exp((w²).re · sigma m + ‖w‖⁴ / (6π⁴(m+1)³))`, for every `w`, with no regime. It follows from the tree's own product for `S` (`WeilPowerGauss.tendsto_S`), the inequality `|1 + z| ≤ exp(Re z + |z|²/2)`, and a tail sum of fourth powers. Its exponent per unit `h` at offset `1/2` is `proven.N1_rate_at_09` -0.1096 at height distance `0.9` and stays negative up to `proven.N1_negative_until_tau` 7.7, past where the far bound takes over. On the grid: `proven.check_points_N1` 20000 points, `proven.check_violations_N1` 0 violations. The tree's three bounds used here were checked the same way, `proven.check_violations_far` 0, `proven.check_violations_sharp` 0 and `proven.check_violations_c_neg` 0 violations.

The price. All `proven.cells` 9 cells close, `proven.cells_closed` 9, and all `proven.cells_stable_above` 9 stay closed at `2`, `10` and `100` times `h₀`. The proved-form `h₀` is the exact one times a factor between `proven.lost_min` 1.0008 and `proven.lost_max` 1.0217; the largest is `proven.h0_max` 1029690859. Unit `record.unit_tree_price` 0367 found a factor up to `36` for the old window, so the multiplied window loses less: its binding term is the on-line background at `4h²` times the multiplier, which is the same in both prices, and the target's lower bound `S_real_ge_sharp` is already sharp.

Item (c) dissolves. The exact price took a worst case over real parts and heights by two monotonicities of `S` that were only numerical. Here each bound is an explicit expression: its worst real part offset is `1/2` by inspection and its dependence on height is read off the formula cell by cell. No monotonicity of `S` is used.

**What a module needs.** `record.new_lemmas` 1 new analytic lemma, N1; the integration-by-parts identity for the multiplied window; the elementary bounds on the multiplier and the ladder's pigeonhole; the rotator; the sign of the kept members; and the assembly, which is the same shape as the one unit 0373 stopped at. `λ` stays at `record.lam` 1: the target's far sideband needs `norm_S_le_far`'s hypothesis at height `2γ₀`, which holds at `λ = 1` for every zero of `ζ`.

**Decision.** Items (a) and (c) of section `record.sixteen` 16 are rewritten: (a) is answered, with N1 added to the block's theorem lines, and (c) is closed by construction. The block stays SKETCH. Building the module needs Lean, which this environment does not have; that is the next thing asked for.
