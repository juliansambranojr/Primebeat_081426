/-
Slice 2 — the flat Mellin bound.  `‖𝓜(ν)(w)‖ ≤ 3M` for `0 < Re w ≤ 2`,
hence `‖𝓜(Smooth1 ν ε)(s)‖ ≤ 3M/‖s‖` with NO `1/ε`.
Scratch only.
-/
import PrimeNumberTheoremAnd.MellinCalculus

open Set MeasureTheory Complex Real

local notation (name := mellintransform3) "𝓜" => mellin

namespace Slice2

noncomputable section

/-- On `[1/2, 2]` and `0 < re w ≤ 2`, `‖x^(w-1)‖ ≤ 2`. -/
theorem cpow_bound {x : ℝ} (hx : x ∈ Icc (1/2 : ℝ) 2) {w : ℂ}
    (hw0 : 0 < w.re) (hw2 : w.re ≤ 2) : ‖(x : ℂ) ^ (w - 1)‖ ≤ 2 := by
  obtain ⟨hx1, hx2⟩ := hx
  have hxpos : (0:ℝ) < x := by linarith
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hxpos]
  simp only [Complex.sub_re, Complex.one_re]
  rcases le_or_gt 0 (w.re - 1) with h | h
  · calc x ^ (w.re - 1) ≤ (2:ℝ) ^ (w.re - 1) := Real.rpow_le_rpow hxpos.le hx2 h
      _ ≤ (2:ℝ) ^ (1:ℝ) := Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
      _ = 2 := by norm_num
  · have he : (0:ℝ) ≤ 1 - w.re := by linarith
    have hxe : x ^ (w.re - 1) = (x ^ (1 - w.re))⁻¹ := by
      rw [show w.re - 1 = -(1 - w.re) by ring, Real.rpow_neg hxpos.le]
    have hlow : ((1:ℝ)/2) ^ (1 - w.re) ≤ x ^ (1 - w.re) :=
      Real.rpow_le_rpow (by norm_num) hx1 he
    have hhalfpos : (0:ℝ) < ((1:ℝ)/2) ^ (1 - w.re) := Real.rpow_pos_of_pos (by norm_num) _
    have hhalf : ((1:ℝ)/2) ^ (1 - w.re) = ((2:ℝ) ^ (1 - w.re))⁻¹ := by
      rw [one_div, Real.inv_rpow (by norm_num)]
    have h2e : (2:ℝ) ^ (1 - w.re) ≤ 2 := by
      calc (2:ℝ) ^ (1 - w.re) ≤ (2:ℝ) ^ (1:ℝ) :=
            Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
        _ = 2 := by norm_num
    rw [hxe]
    calc (x ^ (1 - w.re))⁻¹ ≤ (((1:ℝ)/2) ^ (1 - w.re))⁻¹ := inv_anti₀ hhalfpos hlow
      _ = (2:ℝ) ^ (1 - w.re) := by rw [hhalf, inv_inv]
      _ ≤ 2 := h2e

/-- **Slice 2.**  For a bump `ν` supported in `[1/2,2]` with `|ν| ≤ M`,
`‖𝓜(ν)(w)‖ ≤ 3M` on the whole strip `0 < re w ≤ 2` — flat in `w`. -/
theorem mellin_flat_bound {ν : ℝ → ℝ} (_contν : Continuous ν)
    (suppν : ν.support ⊆ Icc (1/2 : ℝ) 2) {M : ℝ} (hM : ∀ x, |ν x| ≤ M)
    {w : ℂ} (hw0 : 0 < w.re) (hw2 : w.re ≤ 2) :
    ‖𝓜 (fun x ↦ (ν x : ℂ)) w‖ ≤ 3 * M := by
  have hM0 : 0 ≤ M := le_trans (abs_nonneg _) (hM 0)
  have hsupp : (fun x : ℝ => ‖(x : ℂ) ^ (w - 1) • ((ν x : ℝ) : ℂ)‖).support
      ⊆ Icc (1/2 : ℝ) 2 := by
    intro x hx
    simp only [Function.mem_support, ne_eq, norm_eq_zero, smul_eq_mul,
      mul_eq_zero, not_or] at hx
    exact suppν (by simpa using hx.2)
  calc ‖𝓜 (fun x ↦ (ν x : ℂ)) w‖
      ≤ ∫ x in Ioi (0:ℝ), ‖(x : ℂ) ^ (w - 1) • ((ν x : ℝ) : ℂ)‖ :=
        norm_integral_le_integral_norm _
    _ = ∫ x in Icc (1/2 : ℝ) 2, ‖(x : ℂ) ^ (w - 1) • ((ν x : ℝ) : ℂ)‖ :=
        SetIntegral.integral_eq_integral_inter_of_support_subset_Icc hsupp
          ((Icc_subset_Ioi_iff (by norm_num)).mpr (by norm_num))
    _ ≤ 3 * M := by
        have hb : ∀ x ∈ Icc (1/2 : ℝ) 2,
            ‖(x : ℂ) ^ (w - 1) • ((ν x : ℝ) : ℂ)‖ ≤ 2 * M := by
          intro x hx
          rw [smul_eq_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs]
          exact mul_le_mul (cpow_bound hx hw0 hw2) (hM x) (abs_nonneg _) (by norm_num)
        have := intervalIntegral.norm_integral_le_of_norm_le_const'
          (C := 2 * M) (f := fun x : ℝ => ‖(x : ℂ) ^ (w - 1) • ((ν x : ℝ) : ℂ)‖)
          (a := (1/2 : ℝ)) (b := 2) (by norm_num) (by
            intro x hx
            rw [Real.norm_eq_abs, abs_of_nonneg (norm_nonneg _)]
            exact hb x hx)
        rw [intervalIntegral.integral_of_le (by norm_num),
          ← integral_Icc_eq_integral_Ioc] at this
        have h2 : |(2:ℝ) - 1/2| = 3/2 := by norm_num
        rw [h2] at this
        calc ∫ x in Icc (1/2 : ℝ) 2, ‖(x : ℂ) ^ (w - 1) • ((ν x : ℝ) : ℂ)‖
            ≤ |∫ x in Icc (1/2 : ℝ) 2, ‖(x : ℂ) ^ (w - 1) • ((ν x : ℝ) : ℂ)‖| :=
              le_abs_self _
          _ ≤ 2 * M * (3/2) := by rw [← Real.norm_eq_abs]; exact this
          _ = 3 * M := by ring

/-- **Slice 2, the consumer's form.**  `‖𝓜(Smooth1 ν ε)(s)‖ ≤ 3M/‖s‖`,
uniformly in `ε ∈ (0,1)` — no `1/ε`. -/
theorem mellin_smooth1_flat {ν : ℝ → ℝ} (diffν : ContDiff ℝ 1 ν)
    (suppν : ν.support ⊆ Icc (1/2 : ℝ) 2) {M : ℝ} (hM : ∀ x, |ν x| ≤ M)
    {ε : ℝ} (εpos : 0 < ε) (εlt : ε ≤ 1) {s : ℂ} (hs0 : 0 < s.re) (hs2 : s.re ≤ 2) :
    ‖𝓜 (fun x ↦ (Smooth1 ν ε x : ℂ)) s‖ ≤ 3 * M / ‖s‖ := by
  have hsne : s ≠ 0 := by
    intro h; rw [h] at hs0; simp at hs0
  have hsn : 0 < ‖s‖ := norm_pos_iff.mpr hsne
  rw [MellinOfSmooth1a diffν suppν εpos hs0]
  have hre : (ε * s).re = ε * s.re := by simp
  have h1 : 0 < (ε * s).re := by rw [hre]; positivity
  have h2 : (ε * s).re ≤ 2 := by
    rw [hre]; nlinarith
  have hb := mellin_flat_bound (diffν.continuous) suppν hM h1 h2
  rw [norm_mul, norm_inv, div_eq_inv_mul]
  exact mul_le_mul_of_nonneg_left hb (by positivity)

end

end Slice2

#check @Slice2.mellin_flat_bound
#check @Slice2.mellin_smooth1_flat
#print axioms Slice2.mellin_flat_bound
#print axioms Slice2.mellin_smooth1_flat
