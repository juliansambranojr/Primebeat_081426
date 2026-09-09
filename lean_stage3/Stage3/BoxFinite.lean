/-
BoxFinite — the off-line box of `WeilDetect` is a finite set of zeros (block 15 of rung5.md).

`OffLineBox ε T := riemannZeta.zeroes_rect (Icc (1/2 + ε) 1) (Icc (-T) T)`
sits inside a compact rectangle `[1/2 + ε, 1] × [-T, T]` in `ℂ` under
`Complex.re × Complex.im`, and the zeros of `riemannZeta` on any compact
set are finite (`riemannZeta.zeroes_on_Compact_finite'`, upstream at
`PrimeNumberTheoremAnd/IEANTN/ZetaDefinitions.lean:90`). So the box is
finite. This is one of the two lemmas unit 0368 (WeilPowerAssembly)
named as blocking the three placeholder theorems (near_nonneg,
far_moderate_le, far_large_le) — the other is the C¹ indicator lemma.
-/
import PrimeNumberTheoremAnd.IEANTN.KadiriZeroCounting
import Stage3.WeilDetect

namespace Stage3

noncomputable section

open Set Complex

/-- **The off-line box is finite.** `OffLineBox ε T` sits inside a
compact rectangle in `ℂ` and the zeros of `riemannZeta` on any compact
set are finite. -/
theorem offLineBox_finite (ε T : ℝ) :
    (WeilDetect.OffLineBox ε T).Finite := by
  rw [WeilDetect.OffLineBox, riemannZeta.zeroes_rect_eq]
  let S : Set ℂ := (Complex.re ⁻¹' Set.Icc (1/2 + ε) 1)
    ∩ (Complex.im ⁻¹' Set.Icc (-T) T)
  have hS : IsCompact S := by
    exact Complex.equivRealProdCLM.toHomeomorph.isClosedEmbedding.isCompact_preimage
      (isCompact_Icc.prod isCompact_Icc)
  exact riemannZeta.zeroes_on_Compact_finite' hS

/-- info: 'Stage3.offLineBox_finite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offLineBox_finite

end

end Stage3
