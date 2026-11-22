---
id: 0375
date: 2026-11-22
type: decision
title: "Rung 5: an annihilating multiplier on the window, priced on the exact two-sideband term; a uniform L(eps, T) closes on paper at N^2 log N, four items open"
refs: [lean_stage3/Stage3/WeilPowerBackground.lean::term_eq_neg_sq, lean_stage3/Stage3/WeilPowerBridge.lean::term_eq_sidebands, lean_stage3/Stage3/WeilOddPower.lean::S_mul_QS, lean_stage3/Stage3/JensenCount.lean::zeta_local_zero_count]
supersedes: []
follows: 0366
context: Julian asked on 2026-11-22 whether the Alpöge–Furman two-thirds paper (arXiv 2608.13637) gives the rung a new route; sections 9 and 13 of the worksheet died on uniformity over configurations, about log T off-line members near the target with uncontrolled phase; this unit prices one replacement before any Lean, as section 16 of the worksheet
sealed: false
---

**Question.** Sections `record.nine` 9 and `record.thirteen` 13 of `lean_stage3/design/rung5.md` are dead of one cause: one window cannot control the phase of about `log T` off-line members near the target. If the transform is multiplied by a real even polynomial that vanishes at the hurting members, does the rung's own statement, `StmtDetect ε T L` with `L` explicit in `ε` and `T` alone, close on the tree's term, and at what support?

**What ran.** `record.scripts` 3 scripts under `run/`, through `lab run`. EXPLORATORY: no prereg governs this, and nothing below is a verdict.

`run/identity.py` checks the multiplier identity on the tree's own window `W h γ m` in `mpmath`: for an even real polynomial `p` and `D = d/du`, the test function `(p(D)W)(u)·e^{−u/2}` cut to `[−h, h]` has term `−p(s)²·what(s)²` at `ρ = s + 1/2`, where the unmultiplied term is `−what(s)²` (`WeilPowerBackground.term_eq_neg_sq`).

`run/planted.py` evaluates the form on the bench's `planted.zeros` 600 on-line zeros plus `planted.planted_orbits` 3 planted off-line orbits, a target, a member placed in the hurting lobe, and a member a short distance from the target, with and without the multiplier. The planted zeros are controls and say nothing about `ζ`.

`run/price.py` finds the least `h` at which the target's term beats the worst case of every other zero, with no hypothesis on the configuration, after `record.gates` 3 gates: its closed form for `|S|` against unit `record.unit_gap` 0366's product form, unit 0366's recorded `h₀` at `price.gate2_cells` 3 cells recomputed, and double precision against `mpmath` at `M = 10⁹`.

**What it shows.**

The identity holds. Over `identity.points` 4 points the relative error of `∫(p(D)W)e^{su}du = p(s)·what(s)` is at most `identity.rel_err_identity_max` 1.31e-39 and of the term identity `identity.rel_err_term_max` 2.64e-39, at `m = ` `identity.m_small` 6 with `deg p = ` `identity.deg_p` 6; `q m` vanishes to order `identity.zero_order_q` 13 at `±1`, which is what removes the boundary terms. On the line `p(it)` is real, imaginary part `identity.im_p_on_line_max` 0.0, so every on-line term keeps its sign. The support does not change: `p(D)` is a differential operator.

The planted cluster. At `h = ` `planted.h` 800, target at real part offset `planted.eps0` 0.4, the hurting member at offset `planted.eps1` 0.42 and height distance `planted.D1` 0.022 has a term `planted.plain_hurting_over_target` 14.35 times the target's with the other sign, and the form is positive: sign `planted.plain_form_sign` 1, no detection. With the multiplier the member's term is exactly zero, the form's sign is `planted.mult_form_sign` -1, the member kept at distance `planted.d_near` 2e-05 has the target's sign (`planted.mult_near_sign` -1), and the on-line part stays positive (`planted.mult_online_sign` 1). The bound the price uses for `|p(s)/p(s₀)|²` holds at all 600 on-line zeros: `planted.mult_bound_violations` 0 violations.

The price. `price.cells` 9 cells, `ε ∈ {1/2, 1/4, 1/10}` and `T ∈ {10³, 10⁶, 10¹²}`, and `price.cells_closed` 9 close with no gap hypothesis; all `price.cells_stable_above` 9 stay closed at `2`, `10` and `100` times `h₀`. The least supports: `h₀ = ` `price.h0_e05_T3` 4845375 at `ε = 1/2`, `T = 10³`; `price.h0_e025_T6` 51379335 at `ε = 1/4`, `T = 10⁶`; `price.h0_e01_T12` 1028820822 at `ε = 1/10`, `T = 10¹²`, the largest, support `L = 2h₀ = ` `price.L_max` 2057641644. The cluster count is `N = ⌊15 log T + 73⌋`: `price.N_T3` 176, `price.N_T6` 280, `price.N_T12` 487.

What the support is made of. The loss is `∏ 1/d_j²` over the annihilated members, `d_j` the distance from the target. It has no bound in the `d_j` alone; a ladder of `N + 1` annuli of ratio `12N` below `θ₀ = π³/(8h)` has an empty one by pigeonhole, members beyond it are annihilated and members inside it are kept, and the worst placement costs `N(N+1)·log(12N)` in the logarithm, `price.ladder_T6` 638860.0 at `T = 10⁶`. The gain is `2ε²/π²` per unit `h`. Their quotient predicts `h₀` to within a factor between `price.ratio_min` 1.011 and `price.ratio_max` 1.032 in every cell. So `h₀ ≈ π²·N²·log(12N)/(2ε²)`: polynomial in `log T` and `1/ε²`. Section 9 needed a range of `h` exponential in `N`; here `N` enters the amplitude, which the target's exponential pays.

The cluster radius. The first pass took the cluster as members within `1/2` in height. On the exact term a zero at real part offset `1/2` and height distance `1/2` grows with `h`: its exponent per unit `h` is `price.F2_far_half_half` 0.00085503, against `price.F2_target_e005` 0.00050658 for a target at `ε = 0.05`, so at that radius every target with `ε` below `price.eps_star_radius_half` 0.065 loses at every `h` (`price.radius_half_e005_closes` 0: the cell does not close). At radius `price.rc` 0.9 the same zero's exponent is `price.F2_far_half_09` -0.11161, and the count's disk already covers `price.rc_disk` 0.9014, so the radius is free. With it the small-`ε` cells close: `price.h0_small_e001_T6` 32346634889 at `ε = 0.01`, `T = 10⁶`.

**What it does not show.** `record.open_items` 4 items, in the worksheet block's order. The price is on the exact `S`. Unit `record.unit_tree_price` 0367 priced the tree's own inequalities at unit 0366's cells; the supports here are larger, the proved comparison carries a range condition in `h`, and the multiplied window's far and on-line bounds are new, so which proved bounds reach `h₀` is unpriced. The claim that kept members have the target's sign rests on block 13g, a hand phase budget and one planted instance. The far bound's two monotonicities are numerical. And whether an explicit support of this kind is already in the literature was not searched.

Nothing here bears on `StmtWeilPositive`. If all four items held, the result would be an explicit uniform Weil criterion through `box_empty_of_positive_of_detect`: positivity on support `L(ε, T)` empties the box. The positivity is the Riemann hypothesis's content and this route does not approach it.

**Decision.** Section `record.sixteen` 16 is added to the worksheet as SKETCH, priced. No mark of sections 9, 13 or `record.fourteen` 14 moves: their deaths are deaths of a single window, which this does not contradict. Whether a module follows, and which of the four open items goes first, is Julian's.
