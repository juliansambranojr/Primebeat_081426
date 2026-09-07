---
id: 0348
date: 2026-09-06
type: formalization
title: WeilPowerSigma.lean: the tail sum to order 1/h; sigma bracketed to order 1/m squared and u = (m+1)^2 sigma pinned to (m+1/2)/pi^2
refs: [lean_stage3/Stage3/WeilPowerSigma.lean::sigma_le_half, lean_stage3/Stage3/WeilPowerSigma.lean::sigma_ge_amgm, lean_stage3/Stage3/WeilPowerSigma.lean::r_le, lean_stage3/Stage3/WeilPowerSigma.lean::u_mono]
supersedes: []
follows: 0347
sealed: false
---

**Question.** Block 13c of worksheet section `thirteen` 13 (`rung5.md#13c`): the tail sum to order `1/h`. Unit `unit_phase` 0347 brackets `σ(m) = Σ_{j≥m+2} 1/(π²j²)` between `1/(π²(m+2))` and `1/(π²(m+1))`. That pins `u m = (m+1)²σ(m)` only to within an `O(1)` error of `(m+½)/π²`, and the averaging route splits a member's normalized term as `exp(z(m+½)/π²)·exp(z·r m)` with `r m = u m − (m+½)/π²`: an `O(1)` correction summed over the `h`-range costs a constant times that range, the same size as the target. The question is whether `r m` is `O(1/m)`.

**What was proved.** `module_lines` 255 lines, `theorems_proved` 10 theorems, `defs` 1 definition, `pins_module` 4 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries. Two telescoping comparisons carry the partial sums. `sum_upper_half` bounds `Σ_{j∈Ico(m+1)n} 1/(j+1)²` by `2/(2m+3)` through `1/(j+1)² ≤ 1/(j+½) − 1/(j+3/2)`, an inequality whose two sides differ by the `1/4` inside `(j+½)(j+3/2) = (j+1)² − 1/4`. `sum_lower_amgm` bounds the same sum below by `1/(m+2) + 1/(2(m+2)²) − 1/(n+1) − 1/(2(n+1)²)` through `1/(2(j+1)²) + 1/(2(j+2)²) ≥ 1/((j+1)(j+2))`, which is AM–GM; the per-term gap is exactly `1/(2(j+1)²(j+2)²)`. Passing both to the limit against `sigmaN_tendsto` of unit `unit_phase` 0347 gives `sigma_le_half`, `σ(m) ≤ 2/(π²(2m+3))`, and `sigma_ge_amgm`, `1/(π²(m+2)) + 1/(2π²(m+2)²) ≤ σ(m)`, each sharper than the bracket it replaces. The lower bound's `n`-dependent tail is majorized by `(3/2)·1/(n+1)` so one `tendsto_one_div_add_atTop_nhds_zero_nat` carries the limit, the same route unit `unit_sharp` 0346 used.

The correction follows by algebra with no further loss. With `t = m+2`, `(t−1)²/t + (t−1)²/(2t²) − (t−3/2) = 1/(2t²)` and `2(m+1)²/(2m+3) − (m+½) = 1/(2(2m+3))`, both equalities, so `r_pos` gives `1/(2π²(m+2)²) ≤ r m` and `r_le` gives `r m ≤ 1/(π²(4m+6))`: the correction is positive and `O(1/m)`, which is what the route needed. Summed over `m ∈ [a, b]` that is `O(log(b/a))` against the target's `b − a`, so the lost factor of the `O(1)` bracket is gone. `u_mono` closes the block: the step `1/π²` between consecutive `(m+½)/π²` beats the correction's whole range, since `1/(π²(4m+6)) ≤ 1/(6π²)`.

**The build.** `errors_first` 3 error lines, `roots` 1 root cause: a `ring` after a `field_simp` that had already closed the goal (`TRAPS.md` row `row_ring` 1); `cascade_lines` 2 lines were the pins' `sorryAx` cascade (row `row_cascade` 19). The class already had its row, so the retrospective adds none. Second build clean with no warnings, `jobs_module` 8664 jobs; the package builds at `jobs_package` 8758 jobs. Built under the loop at version `loop_version` 10; the retrospective bumps it to `loop_next` 11 for the `try ring` rule this run paid for and for the design row's sub-block form.

What the next slice needs. Block 13d of the worksheet: the geometric sum `|Σ_{m∈Ico a b} exp(z(m+½)/π²)| ≤ (|ρ|^a + |ρ|^b)/(e^{Re z/π²}|sin(Im z/π²)|)`, and the harmonic bound on `Σ_{m∈Ico a b} r m` that `r_le` now makes `O(log(b/a))`. Together they turn a member's contribution over the `h`-range into a bounded quantity against the target's linear growth, which is requirement (c) of worksheet section `thirteen` 13 read through the averaging route of rung `rung` 5, slice `slice` 13 of the switched-window ladder.
