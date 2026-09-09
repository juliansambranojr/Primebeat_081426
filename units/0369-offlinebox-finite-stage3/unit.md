---
id: 0369
date: 2026-09-09
type: formalization
title: "BoxFinite.lean: OffLineBox is finite as a set of complex zeros; the first of two lemmas unit 0368 named as blocking block 15's placeholders"
refs: [lean_stage3/Stage3/BoxFinite.lean::offLineBox_finite]
supersedes: []
follows: 0368
context: unit `unit_partial` 0368 landed WeilPowerAssembly partial and named two lemmas as blocking its three placeholder theorems (near_nonneg, far_moderate_le, far_large_le); this unit is the first of the two, the box-in-strip finiteness lemma, done in our own tree; the second (the C¹ indicator lemma) is deferred to a follow-up unit
sealed: false
---

**Question.** Unit 0368 named a Kadiri-style finiteness lemma as blocking the three placeholder theorems of block 15. `Set.Finite.subset` on the strip inclusion, from `Kadiri.zeroes_on_Compact_finite'`, should close it in a few lines. Does it?

**What was proved.** `module_lines` 41 lines, `theorems_proved` 1 theorem, `defs` 0 definitions, `pins` 1 axiom pin at `axioms` 3 axioms, `sorries` 0 sorries, and `zeta_refs` 6 references to `riemannZeta`.

`offLineBox_finite (ε T : ℝ) : (WeilDetect.OffLineBox ε T).Finite`. The proof unfolds `OffLineBox` to `riemannZeta.zeroes_rect (Icc (1/2 + ε) 1) (Icc (-T) T)` and rewrites through `riemannZeta.zeroes_rect_eq` to `(re ⁻¹' Icc (1/2 + ε) 1 ∩ im ⁻¹' Icc (-T) T) ∩ zeroes`. The intersection of `re` and `im` preimages of two compact intervals is compact (`Complex.equivRealProdCLM.toHomeomorph.isClosedEmbedding.isCompact_preimage` on `isCompact_Icc.prod isCompact_Icc`), and `riemannZeta.zeroes_on_Compact_finite'` finishes it. `lines_written` 41.

`errors_first` 0 on the first build. `jobs_module` 3666 for the module alone, `jobs_package` 8770 for the full Stage3 after the import into Stage3.lean.

What remains. The second of the two lemmas unit `unit_partial` 0368 named — the C¹ indicator lemma. I opened a proof of it, `contDiff_one_indicator_Icc`, using `contDiff_one_iff_deriv` and the boundary-agreement of left and right derivatives via `HasDerivWithinAt.union`, but the boundary-case proof needs to shrink the local `HasDerivWithinAt` set to `Icc a b` (past which the indicator is 0 rather than `f`) and my first pass hit cascading unification errors on the `congr` steps. That work belongs in its own unit; when it lands, block 15's `isTest_phiWC` closes and the three placeholders in `WeilPowerAssembly` can be given real signatures using `offlineBox_finite`. Julian's call whether to attempt it next or leave the assembly partial.
