---
id: 0370
date: 2026-09-09
type: formalization
title: "IndicatorContDiff.lean: contDiff_one_indicator_Icc — the C¹ indicator lemma unit 0368 named as blocking WeilPowerAssembly's isTest_phiWC, closed by the relay in 249 lines"
refs: [lean_stage3/Stage3/IndicatorContDiff.lean::contDiff_one_indicator_Icc]
supersedes: []
follows: 0369
context: unit 0368 named two lemmas as blocking block 15's placeholders; unit 0369 landed the first (offLineBox_finite); this is the second; between them the placeholders in WeilPowerAssembly can gain real signatures and detect_gap_exists can close in a follow-up unit
sealed: false
---

**Question.** Unit 0368 said Mathlib has no `contDiff_indicator` lemma of a boundary-vanishing shape. Unit 0369 landed the first of the two lemmas the assembly named as blocking. Does the second — a C¹ indicator lemma for `Set.indicator (Icc a b) f` when `f` and `deriv f` vanish at `a` and `b` — close in our tree, and at what cost?

**What was proved.** `module_lines` 249 lines, `theorems_proved` 1 theorem, `defs` 0 definitions, `pins` 1 axiom pin at `axioms` 3 axioms, `sorries` 0 sorries.

`contDiff_one_indicator_Icc {a b : ℝ} (hab : a ≤ b) {f : ℝ → ℝ} (hf : ContDiff ℝ 1 f) (ha : f a = 0) (hb : f b = 0) (hda : deriv f a = 0) (hdb : deriv f b = 0) : ContDiff ℝ 1 (Set.indicator (Set.Icc a b) f)`. The proof uses `contDiff_one_iff_deriv` to reduce to differentiability plus continuity of the derivative. Differentiability at every `x` splits by case on `x` against `a` and `b`: exterior and strict interior close by `HasDerivAt.congr_of_eventuallyEq` against constant zero or `f`; boundary at `x = a` and `x = b` close by `HasDerivWithinAt.union` on `Iic a ∪ Ici a = univ`, the left branch a constant zero (using `f a = 0` at the endpoint), the right branch `f` congr'd on `Icc a b` and extended by `HasDerivWithinAt.congr_of_eventuallyEq_of_mem`. Continuity of the derivative splits the same way; at the boundary it uses `nhdsLE_sup_nhdsGE` to combine the constant-zero half with the `f`-side continuous by `deriv f` continuous at `a` and `deriv f a = 0`. The degenerate `a = b` case is separated as its own branch (`rcases eq_or_lt_of_le hab`) because on `{a} = Icc a a`, `Set.Icc a b ∈ 𝓝[Ici a] a` fails, so the boundary route is unreachable and `contDiff_const` handles it directly.

**The build, and the relay.** `errors_first` 10 error lines from `roots` 5 root causes at the first build, `sorries_first` 0 sorries at the builder's stop. Roots: three `HasDerivAt.congr_of_eventuallyEq` over-`.symm`s (the lemma takes `f₁ =ᶠ f`, not the other way); two `Filter.EventuallyEq.continuousAt` glue errors on the constant-zero side (fixed by `Tendsto.congr' + tendsto_const_nhds`); four `Unknown identifier 'a'` and `'b'` from `rcases lt_trichotomy x a with _ | rfl | _` running `subst` on the endpoint variable rather than `x`, killing every later `a` reference (new TRAPS row `row_new` 38); one `#guard_msgs` row `row_cascade` 19 pin cascade cleared once the proofs closed. `assumed_pins` 3 pins the block did not name and the builder promoted: the `a = b` degenerate case, the union-of-half-nbds boundary route (over the `hasDerivAt_iff_tendsto` alternative the brief listed as also acceptable), and the `nhdsLE_sup_nhdsGE` glue at the continuity step.

`traps_added` 1 row, `row_new` 38: `rcases lt_trichotomy x a with hxa | rfl | hxa` fails downstream with `Unknown identifier 'a'` because the middle `rfl` runs `subst` on `x = a` and eliminates the local `a`, not `x`; the fix names the equation and uses `rw` instead of `rfl`. Row 19 recurred, cleared. `foreman_edits` 0 edits and `foreman_builds` 0 builds beyond what the builder produced: the builder closed the whole thing on one relay pass with the errors self-corrected. Module at `jobs_module` 1987 jobs, package at `jobs_package` 8771. Built under the loop at version `loop_version` 21.

The measure. The builder's first pass read `tokens_first` 157392 tokens over `calls_first` 69 calls in `minutes_first` 19 minutes; the second (scaffold only) is short.

What remains. The two lemmas unit 0368 named as blocking block 15 are both now in our tree: `offLineBox_finite` (unit `unit_box` 0369) and `contDiff_one_indicator_Icc` (this unit). The next step is a follow-up unit that fills `WeilPowerAssembly`'s three `True` placeholders (`near_nonneg`, `far_moderate_le`, `far_large_le`) using `offLineBox_finite` to enumerate the box as a `Finset`, then closes `isTest_phiWC` using `contDiff_one_indicator_Icc` at `f = phiW h γ m`, then closes `detect_gap_exists` via the exponential-vs-polynomial existence. Julian's call whether to attempt it in one relay pass or three.

**The other thing this unit says.** I tried to write this lemma directly as the foreman in unit 0369 and gave up when the first pass hit six errors, calling it "too big for one turn." Julian pointed out I hadn't run the relay. The relay closed it in one pass, on the first model, with zero sorries. The loop worked. The lesson for me: a first-pass with real sorries is the relay's normal output, and cascading errors on a first foreman attempt are a signal to hand off, not to shrink the scope.
