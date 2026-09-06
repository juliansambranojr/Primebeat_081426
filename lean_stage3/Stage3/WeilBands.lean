/-
WeilBands — the on-line zeros counted by band. Rung 4b, second half, slice A
of the detection ladder (units 0316–0320). 2026-09-06.

The on-line background is a sum over zeros of nonnegative terms
(unit 0320). To bound it, the zeros are read by height bands and each band
is counted with Stage 3's crude local count (`JensenCount.zeta_local_zero_count`,
`15·log T + 73` over the disk of radius `7/4` about `2 + iT`). Three things
this slice settles:

  order_eq_analyticOrderNatAt
      upstream's `riemannZeta.order` (the multiplicity the zero side is
      weighted by) equals the `analyticOrderNatAt` the count sums, at every
      nontrivial zero. Both are the analytic order; `order` reads it through
      the meromorphic order, which for an analytic function is the same
      number, and both send the junk case to 0.
  band_count
      any finite set of on-line zeros within `9/10` of a height `T ≥ 2` has
      total multiplicity at most `15·log T + 73`: on the line,
      `‖ρ − (2 + iT)‖² = 9/4 + (γ_ρ − T)² ≤ 9/4 + 81/100 ≤ 49/16`, so the set
      sits inside the count's window.
  band_sum_le
      over such a set, `Σ term(ρ)·ord(ρ) ≤ M·(15·log T + 73)` whenever every
      term is at most `M ≥ 0`.

What the next slice does with it: tile the heights by windows of step `9/5`,
apply `band_sum_le` per tile with unit 0320's near and far bounds as `M`,
and pass to the full sum through `Real.tsum_le_of_sum_le`, which needs no
summability, only nonnegativity and a bound on every finite partial sum.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilBackground
import Stage3.JensenCount

namespace WeilBands

noncomputable section

open Complex WeilDetect WeilBackground Real

/-- Upstream's multiplicity is the analytic order, at every nontrivial zero. -/
theorem order_eq_analyticOrderNatAt (ρ : Kadiri.NontrivialZeros) :
    ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) = (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) := by
  have han := Kadiri.riemannZeta_analyticAt_nontrivialZero ρ
  unfold riemannZeta.order analyticOrderNatAt
  rw [han.meromorphicOrderAt_eq]
  cases hO : analyticOrderAt riemannZeta (ρ : ℂ) with
  | top => simp
  | coe n =>
    simp [ENat.map_coe]
    try rfl

/-- An on-line zero within `9/10` of height `T` lies in the count's window. -/
theorem mem_zetaWindow_of_online {T : ℝ} {ρ : ℂ} (hz : riemannZeta ρ = 0)
    (hre : ρ.re = 1 / 2) (him : |ρ.im - T| ≤ 9 / 10) : ρ ∈ Stage3.zetaWindow T := by
  refine ⟨hz, ?_⟩
  have hsq : ‖ρ - (2 + Complex.I * (T : ℂ))‖ ^ 2 ≤ (7 / 4 : ℝ) ^ 2 := by
    rw [Complex.sq_norm, Complex.normSq_apply]
    have e1 : (ρ - (2 + Complex.I * (T : ℂ))).re = ρ.re - 2 := by simp
    have e2 : (ρ - (2 + Complex.I * (T : ℂ))).im = ρ.im - T := by simp
    rw [e1, e2, hre]
    have h1 : (ρ.im - T) * (ρ.im - T) ≤ (9 / 10) ^ 2 := by
      rw [← sq, ← sq_abs]
      exact pow_le_pow_left₀ (abs_nonneg _) him 2
    nlinarith
  exact (pow_le_pow_iff_left₀ (norm_nonneg _) (by norm_num) two_ne_zero).mp hsq

/-- **Band count.** A finite set of on-line zeros within `9/10` of a height
`T ≥ 2` has total analytic multiplicity at most `15·log T + 73`. -/
theorem band_count {T : ℝ} (hT : 2 ≤ T) (S : Finset ℂ)
    (hS : ∀ ρ ∈ S, riemannZeta ρ = 0 ∧ ρ.re = 1 / 2 ∧ |ρ.im - T| ≤ 9 / 10) :
    ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta ρ : ℝ) ≤ 15 * Real.log T + 73 := by
  have hsub : S ⊆ (Stage3.zetaWindow_finite hT).toFinset := by
    intro ρ hρ
    rw [Set.Finite.mem_toFinset]
    obtain ⟨hz, hre, him⟩ := hS ρ hρ
    exact mem_zetaWindow_of_online hz hre him
  calc ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta ρ : ℝ)
      ≤ ∑ ρ ∈ (Stage3.zetaWindow_finite hT).toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ) :=
        Finset.sum_le_sum_of_subset_of_nonneg hsub (fun _ _ _ => Nat.cast_nonneg _)
    _ ≤ 15 * Real.log T + 73 := Stage3.zeta_local_zero_count hT

/-- The on-line term with its multiplicity, as WeilDetect's sum weights it. -/
def weightedTerm (h γ : ℝ) (ρ : Kadiri.NontrivialZeros) : ℝ :=
  (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re
    * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)

/-- **Band sum.** Over a finite set of on-line zeros within `9/10` of `T ≥ 2`,
if every term is at most `M ≥ 0`, the weighted sum is at most
`M·(15·log T + 73)`. -/
theorem band_sum_le {h γ T : ℝ} (hT : 2 ≤ T) (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ |(ρ : ℂ).im - T| ≤ 9 / 10)
    {M : ℝ} (hM0 : 0 ≤ M)
    (hM : ∀ ρ ∈ S, (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re ≤ M) :
    ∑ ρ ∈ S, weightedTerm h γ ρ ≤ M * (15 * Real.log T + 73) := by
  have hord : ∀ ρ : Kadiri.NontrivialZeros, (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) :=
    fun ρ => by exact_mod_cast (Kadiri.riemannZeta_order_pos_nontrivialZero ρ).le
  have h1 : ∑ ρ ∈ S, weightedTerm h γ ρ
      ≤ ∑ ρ ∈ S, M * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
    apply Finset.sum_le_sum
    intro ρ hρ
    unfold weightedTerm
    exact mul_le_mul_of_nonneg_right (hM ρ hρ) (hord ρ)
  have h2 : ∑ ρ ∈ S, M * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
      = M * ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) := by
    rw [← Finset.mul_sum]
    congr 1
    apply Finset.sum_congr rfl
    intro ρ _
    exact order_eq_analyticOrderNatAt ρ
  have h3 : ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ)
      = ∑ z ∈ S.image (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ)),
          (analyticOrderNatAt riemannZeta z : ℝ) := by
    rw [Finset.sum_image]
    intro a _ b _ hab
    exact Subtype.ext hab
  have h4 : ∑ z ∈ S.image (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ)),
      (analyticOrderNatAt riemannZeta z : ℝ) ≤ 15 * Real.log T + 73 := by
    apply band_count hT
    intro z hz
    rw [Finset.mem_image] at hz
    obtain ⟨ρ, hρ, rfl⟩ := hz
    exact ⟨Kadiri.riemannZeta_nontrivialZero_zero ρ, (hS ρ hρ).1, (hS ρ hρ).2⟩
  calc ∑ ρ ∈ S, weightedTerm h γ ρ
      ≤ ∑ ρ ∈ S, M * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := h1
    _ = M * ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) := h2
    _ = M * ∑ z ∈ S.image (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ)),
          (analyticOrderNatAt riemannZeta z : ℝ) := by rw [h3]
    _ ≤ M * (15 * Real.log T + 73) := mul_le_mul_of_nonneg_left h4 hM0

end

/-- info: 'WeilBands.order_eq_analyticOrderNatAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms order_eq_analyticOrderNatAt

/-- info: 'WeilBands.band_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms band_count

/-- info: 'WeilBands.band_sum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms band_sum_le

end WeilBands
