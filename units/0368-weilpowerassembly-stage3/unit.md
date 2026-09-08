---
id: 0368
date: 2026-09-08
type: formalization
title: "WeilPowerAssembly.lean: block 15 assembly, partial — StmtDetectGap defined, target_lower and on_line_le proved, IsTest for phiWC and detect_gap_exists left as sorries with a Mathlib absence named"
refs: [lean_stage3/Stage3/WeilPowerAssembly.lean::target_lower, lean_stage3/Stage3/WeilPowerAssembly.lean::on_line_le, lean_stage3/Stage3/WeilPowerAssembly.lean::isTest_phiWC, lean_stage3/Stage3/WeilPowerAssembly.lean::detect_gap_exists]
supersedes: []
follows: 0367
context: units 0366 and 0367 priced the gap-dependent L on the term and on the tree's proven inequalities; Julian asked to build the Lean assembly the pricings promised, knowing we would not know the outcome until we got there
sealed: false
---

**Question.** Units 0366 and 0367 said the gap-dependent conditional theorem exists numerically. Does its Lean assembly close under the tree as it stands today, and what does it name if it does not?

**What was proved.** `module_lines` 182 lines, `theorems_proved` 7 theorems, `defs` 1 definitions, `pins` 1 axiom pin at `axioms` 3 axioms, `sorries` 2 sorries, and `zeta_refs` 0 references to `riemannZeta`.

The def and two proved theorems. `StmtDetectGap ε T δ L` unfolds to: nonemptiness of `OffLineBox ε T` plus a gap-hypothesis around a max-Re element implies `∃ G, IsTest L G ∧ (zeroForm G).re < 0`. `target_lower` wraps `WeilPowerBridge.term_le_at_zero` (block 13j, unit `unit_bridge` 0362) at a zero of real part `1/2 + ε` and imaginary part `γ`, closing on one try. `on_line_le` wraps `WeilPowerOnLine.onLineBound_le` (unit `unit_online` 0334) at the module's variables, closing on one try. These are the two pieces of the assembly that carry from the tree without new work.

The three placeholders. `near_nonneg`, `far_moderate_le`, `far_large_le` are stated as `theorem _ : True := by trivial`, each with a comment naming the block's intended goal. The block wrote their statements `...`-elided because the near set has to be enumerated as a `Finset` and that needs the `OffLineBox` to be finite in height, which the block's own Open row named as out of scope. The unit's failure to fill these is not a coding failure; it is the block's own OPEN reporting itself.

The two sorries with goals in comments. `isTest_phiWC {h : ℝ} (hh : 0 < h) (γ : ℝ) {m : ℕ} (hm : 1 ≤ m) : IsTest (2 * h) (phiWC h γ m)` sorries at the ContDiff conjunct. `q(m, ±1)` and its first `2m` derivatives vanish (from `sin(π·±1) = 0` and `P(±1) = cos²(±π/2) = 0` to order two each), so `phiWC` is `C^{2m}` on `ℝ` when `m ≥ 1`. To turn that into `ContDiff ℝ 1 (indicator (Icc (-h) h) f)` Mathlib needs a lemma of the shape `contDiff_indicator_of_zero_boundary`, and grep on this pin (PNT+ 47fa486, Mathlib as of it) returns none. The block itself named this as the module's expected OPEN row, and it is. `detect_gap_exists` sorries at the whole existence proof: the exponential gap between the target's rate `ε²/(π²(m+2))` and the moderate-far rate `(ε² − δ²)/(same denominator)` closes by `Real.tendsto_exp_atTop` chained with polynomial-vs-exponential comparisons, but the proof reads all three placeholders and `isTest_phiWC`, so it cannot close before them.

**The build, and the relay.** `errors_first` 4 error lines from `roots` 2 root causes at the first build: `unknown identifier D` and `unknown identifier WeilPowerOnLine.lowCount`, both TRAPS row `row_ns` 31 (the block's Composes namespaces resolved when `open` was extended with `WeilPowerGauss` and `WeilOnLine`); and the `#guard_msgs` pin's row `row_cascade` 19 cascade from the sorried theorem, expected. `assumed_pins` 5 pins, all reported: the two `open`-line additions, the two disambiguations (`q` as `WeilPowerPhase.q`, `QS` as `WeilOddPower.QS`, both are ambiguous in the module's namespaces), and the three `True` placeholders being what the block signaled.

`traps_added` 0 rows: nothing new; row 31 (namespace-not-transitive on a copied statement) is the same trap H1 and H2 paid for at the count-to-argument step (rows `row_first_h2` 33 through `row_last_h2` 36 there, and row `row_ns2` 32 was the file-name-as-namespace variant). `foreman_edits` 0 edits and `foreman_builds` 0 builds beyond what the builder produced: nothing here for the foreman to close that would not expand scope past the block. Module at `jobs_module` 8740 jobs, package at `jobs_package` 8769. Built under the loop at version `loop_version` 20.

The measure. The builder's first pass read `tokens_first` 123104 tokens over `calls_first` 43 calls in `minutes_first` 7 minutes. The second (scaffold only) is short.

**What the honest partial says.** The assembly the pricings of units `unit_price_exact` 0366 and `unit_price_proven` 0367 promised does not close in Lean at this pin without three things this module names: (a) a Mathlib lemma for the C¹ regularity of `Set.indicator (Icc (-h) h) f` when `f` vanishes to boundary order one; (b) enumeration of the `OffLineBox` as a `Finset`, which needs a finiteness lemma the tree does not carry (Kadiri has `zeroes_rect_univ_positive_height_finite`, but its restriction to the strip `Icc (1/2 + ε) 1` is not stated); (c) the `Real.tendsto_exp_atTop`-plus-polynomial chain in the assembly itself, which is a real proof but not a Mathlib gap. Two of those are outside the block and one is a small Mathlib PR that would land the whole thing.

What remains. The conditional theorem stays a numeric result (units `unit_price_exact` 0366 and `unit_price_proven` 0367). The Lean form of it is one PR-sized Mathlib gap and one tree finiteness lemma away from closing; naming both is the value of this unit. Julian's call whether to file the Mathlib PR or restrict the theorem's statement so the box-finiteness is a hypothesis; either would land the module.
