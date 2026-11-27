---
id: 0594
date: 2026-11-26
type: decision
title: "The main-term floor loses a factor that grows with depth: the derivative bound costs (1/log 2)^d against the exact difference"
refs: [lean/Nonvanishing.lean::Mlow, lean/Expansion.lean::iteratedDeriv_f2x, lean/RelativeGate.lean::relGate_iff, lean/ToInfinity.lean::only_four_zeros_band]
supersedes: []
follows: 0593
sealed: false
---

**Question.** The gate's price `ρ < (log 2)^d / (2·r·3^(d+1))` comes from the floor `Mlow` under the main term's stencil. Is that floor the size of the stencil, or does it lose a factor that grows with depth?

**What ran.** `run/floor.py`, by `run/run.sh`, through `lab run`. The smooth row `li(2^m) − li(2^(m−1))` at high precision; its exact d-th difference against `Mlow` at three rows; and, for Schoenfeld's relative error at the window bottom with the gate's ceiling, the deepest depth the gate closes at each of four rows, once with `Mlow` and once with the exact stencil. EXPLORATORY: no prereg, no verdict.

**What it shows.** `Mlow` reaches the stencil through the d-th derivative of `2^x/x` (`iteratedDeriv_f2x`), which carries `(log 2)^d`. The d-th backward difference of `2^x` is `2^(x−d)` exactly. In the smallest cell measured the stencil over `Mlow` is `floor.ratio.100.10.exact_over_mlow` 102.70001723390884, against the power of one over log two `floor.ratio.100.10.inv_log2_pow_d` 39.06118276908564; in the largest it is `floor.ratio.400.40.exact_over_mlow` 6110122.162920253 against `floor.ratio.400.40.inv_log2_pow_d` 2327992.4001006796. The loss grows like `(1/log 2)^d`.

**The reach.** Under Schoenfeld's bound the gate with `Mlow` closes to depth `floor.reach.100.d_mlow` 14 at the first row measured and `floor.reach.800.d_mlow` 146 at the last, rows over depth `floor.reach.800.r_over_d_mlow` 5.47945205479452. With the exact stencil it closes to `floor.reach.100.d_exact` 19 and `floor.reach.800.d_exact` 184, rows over depth `floor.reach.800.r_over_d_exact` 4.3478260869565215.

**The decision.** The proof of `Mlow` is right and the route is wrong: a mean-value floor under a d-th difference of an exponential loses the ratio of one half to log two at every step. The floor is to be rebuilt from the exact difference of `2^x·g(x)`, the shift acting on the exponential exactly and only g's variation bounded. The rest of the gap to the switch measured this session in the deep corner is the triangle inequality in the ceiling, `(3/2)^(d+1)` on the relative error.
