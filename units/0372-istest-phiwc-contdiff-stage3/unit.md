---
id: 0372
date: 2026-09-09
type: formalization
title: "WeilPowerAssembly.lean: isTest_phiWC ContDiff conjunct closed via a phiW_contDiff_one helper; only detect_gap_exists remains"
refs: [lean_stage3/Stage3/WeilPowerAssembly.lean::phiW_contDiff_one, lean_stage3/Stage3/WeilPowerAssembly.lean::isTest_phiWC]
supersedes: []
follows: 0371
context: unit 0371 lifted three placeholders to real signatures and closed three of four IsTest conjuncts, leaving the ContDiff conjunct sorry; this relay pass closes it by proving phiW_contDiff_one as a helper and applying it
sealed: false
---

**Question.** Unit 0371 left `isTest_phiWC` with one open conjunct: `ContDiff ℝ 1 (phiWC h γ m)` for `m ≥ 1`. Route named: `phiWC = Complex.ofRealCLM ∘ phiW`, then `contDiff_one_indicator_Icc` at `f u = W h γ m u · exp(-u/2)` with the four boundary hypotheses `f(±h) = 0` and `deriv f (±h) = 0` from `P(±1) = cos²(±π/2) = 0` for `m ≥ 1`. Does the relay close it on one pass?

**What was proved.** `module_lines` 474 lines, `theorems_proved` 8 theorems, `defs` 1 definition, `pins` 8 axiom pins with `pins_clean` 7 clean and `pins_sorry` 1 still on `sorryAx`, `sorries` 1 sorry, and `zeta_refs` 0 references to `riemannZeta`.

New helper: `phiW_contDiff_one {h γ : ℝ} (hh : 0 < h) {m : ℕ} (hm : 1 ≤ m) : ContDiff ℝ 1 (phiW h γ m)`. Its proof unfolds `phiW`, applies `Stage3.contDiff_one_indicator_Icc` (unit `unit_indicator` 0370) at `f u = W h γ m u · exp(-u/2)` on `Icc (-h) h`. The four boundary hypotheses reduce as follows: `f(±h) = 0` from `q(m, ±1) = sin(π · ±1) · P(±1)^m = 0 · _ = 0` (uses `sin(π) = 0` and `sin(-π) = 0`); `deriv f (±h) = 0` from `q(m, ±1) = 0` killing the `W · exp` product-rule term, and from the product rule at `q = sin(π ·) · P^m` where `P(±1)^m = 0` for `m ≥ 1` kills the first term and `sin(π · ±1) = 0` kills the second, so `deriv q (m, ±1) = 0`, hence `deriv W (±h) = (1/h) · deriv q · cos(∓γh) − γ · q(m, ±1) · sin(∓γh) = 0`. The builder pushed the whole chain through `HasDerivAt.pow`, `HasDerivAt.mul`, `HasDerivAt.comp`, `Real.hasDerivAt_sin`, `Real.hasDerivAt_cos`, `Real.hasDerivAt_exp`, `WeilPower.hasDerivAt_c`. Pin sorry-free.

`isTest_phiWC`'s ContDiff conjunct now reads `Complex.ofRealCLM.contDiff.comp (phiW_contDiff_one hh hm)`. The three other conjuncts (real-valuedness, HasCompactSupport, tsupport) stay as unit 0371 left them. Pin's `#print axioms` docstring flipped from `[propext, sorryAx, Classical.choice, Quot.sound]` to `[propext, Classical.choice, Quot.sound]`.

**The build, and the relay.** `errors_first` 0 error lines on the first build; the module built clean with only the pre-existing `detect_gap_exists` sorry warning. `roots` 0 error roots. `sorries_first` 1 sorry at the builder's stop, matching the final count. `traps_added` 0 rows. Row `row_comp` 16 (`.comp` mis-unifies) was worked around by named implicit arguments at the boundary composition — the builder's report flags this as a specific instance of row 16 (the `+h` case let Lean pick `HDiv.hDiv h` for the inner function rather than `fun u => u/h`) but does not add a new row. `foreman_edits` 0 edits, `foreman_builds` 0 builds beyond scaffold. Module at `jobs_module` 8742 jobs, package at `jobs_package` 8771. Built under the loop at version `loop_version` 21.

The measure. The builder's first pass read `tokens_first` 72714 tokens over `calls_first` 43 calls in `minutes_first` 9 minutes.

What remains. One sorry, one goal, one route. `detect_gap_exists`'s step (d), the exponential-vs-polynomial existence via `Real.tendsto_exp_atTop` chained with polynomial-vs-exponential decay. That is the last sorry in block 15.
