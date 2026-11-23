/-
LandauMellinG — the Mellin transform of `G` on `Re s > 1`.
Block 2b of `lean_stage3/design/landau.md`. 2026-11-22.

For `Re s > 1`,

    ∫₁^∞ G(y)·y^(−s−1) dy = Phi s,
    Phi s = −ζ'/ζ(s)/(s(s−1)) − 1/(s−1)² + (1+γ)/(s−1),

where `G y = rampSum y − y·log y + (1+γ)·y` is `LandauWindow.G`. The ramp sum's
part is `LandauMellin.mellin_rampSum`; the other two are the elementary
integrals of `log y · y^(−s)` and `y^(−s)`.

  Phi                              the transform (the one definition)
  LSeries_vonMangoldt_real_ne_zero (hσ : 1 < σ) : L ↗Λ σ ≠ 0
  rampSum_mellin_integrable        (hs : 1 < s.re) :
                                     IntegrableOn (rampSum y · y^(−s−1)) (Ioi 1)
  log_cpow_integrable              (hs : 1 < s.re) :
                                     IntegrableOn (log y · y^(−s)) (Ioi 1)
  log_cpow_integral                (hs : 1 < s.re) :
                                     ∫ y in Ioi 1, log y · y^(−s) = 1/(s−1)²
  G_mellin_integrable              (hs : 1 < s.re) :
                                     IntegrableOn (G y · y^(−s−1)) (Ioi 1)
  mellin_G                         (hs : 1 < s.re) :
                                     ∫ y in Ioi 1, G y · y^(−s−1) = Phi s

What the next slice needs: the crude bound on `G` (block 5), then the Taylor
coefficients of this transform as integrals against powers of `log y`
(block 2c), and the poles of `Phi` (block 3).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauMellin

namespace LandauMellinG

noncomputable section

open Complex MeasureTheory Set Filter Topology
open scoped LSeries.notation ArithmeticFunction.vonMangoldt

/-- The Mellin transform of `G`: the `Φ` of the worksheet. -/
def Phi (s : ℂ) : ℂ :=
  -deriv riemannZeta s / riemannZeta s / (s * (s - 1))
    - 1 / (s - 1) ^ 2 + (1 + (Real.eulerMascheroniConstant : ℂ)) / (s - 1)

/-- For real `σ > 1`, the L-series of the von Mangoldt function is nonzero at `σ`. -/
theorem LSeries_vonMangoldt_real_ne_zero {σ : ℝ} (hσ : 1 < σ) : L ↗Λ (σ : ℂ) ≠ 0 := by
  have hs : 1 < ((σ : ℝ) : ℂ).re := by simpa using hσ
  have hsum := ArithmeticFunction.LSeriesSummable_vonMangoldt hs
  have hterm : ∀ n : ℕ, (LSeries.term ↗Λ (σ : ℂ) n).re = Λ n * (n : ℝ) ^ (-σ) := by
    intro n
    rw [LSeries.term_def₀ (by simp)]
    have : ((n : ℂ)) ^ (-(σ : ℂ)) = (((n : ℝ) ^ (-σ) : ℝ) : ℂ) := by
      rw [Complex.ofReal_cpow (Nat.cast_nonneg n)]
      push_cast
      rfl
    rw [this, ← Complex.ofReal_mul, Complex.ofReal_re]
  have hsumR : Summable fun n : ℕ => Λ n * (n : ℝ) ^ (-σ) := by
    have h := (Complex.hasSum_re hsum.hasSum).summable
    exact h.congr hterm
  have hre : (L ↗Λ (σ : ℂ)).re = ∑' n : ℕ, Λ n * (n : ℝ) ^ (-σ) := by
    rw [LSeries, Complex.re_tsum hsum]
    exact tsum_congr hterm
  have hpos : 0 < ∑' n : ℕ, Λ n * (n : ℝ) ^ (-σ) := by
    refine hsumR.tsum_pos (fun n => mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
      (Real.rpow_nonneg (Nat.cast_nonneg n) _)) 2 ?_
    have h2 : Λ 2 = Real.log 2 := by
      simpa using ArithmeticFunction.vonMangoldt_apply_prime Nat.prime_two
    rw [h2]
    have : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    positivity
  intro h
  rw [h] at hre
  simp at hre
  linarith

/-- For `Re s > 1`, the Mellin integrand of the ramp sum, `rampSum y · y^(−s−1)`,
is integrable on `(1, ∞)`. -/
theorem rampSum_mellin_integrable {s : ℂ} (hs : 1 < s.re) :
    IntegrableOn (fun y : ℝ => (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) := by
  have hσ : 1 < ((s.re : ℝ) : ℂ).re := by simpa using hs
  have hne : ∫ y in Ioi (1 : ℝ), (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-(s.re : ℂ) - 1) ≠ 0 := by
    rw [LandauMellin.mellin_rampSum hσ,
      ← ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hσ]
    refine div_ne_zero (LSeries_vonMangoldt_real_ne_zero hs) (mul_ne_zero ?_ ?_)
    · exact_mod_cast (by linarith : s.re ≠ 0)
    · have : (s.re : ℂ) - 1 = ((s.re - 1 : ℝ) : ℂ) := by push_cast; ring
      rw [this]
      exact_mod_cast (by linarith : s.re - 1 ≠ 0)
  have hint0 : IntegrableOn
      (fun y : ℝ => (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-(s.re : ℂ) - 1)) (Ioi 1) := by
    by_contra h
    exact hne (integral_undef h)
  have hcont : ContinuousOn (fun y : ℝ => (y : ℂ) ^ ((s.re : ℂ) - s)) (Ioi 1) := by
    intro y hy
    have hy0 : y ≠ 0 := by linarith [mem_Ioi.mp hy]
    exact (Complex.continuousAt_ofReal_cpow_const y _ (Or.inr hy0)).continuousWithinAt
  have hmeas : AEStronglyMeasurable
      (fun y : ℝ => (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1))
      (volume.restrict (Ioi 1)) := by
    have h1 := hint0.aestronglyMeasurable.mul (hcont.aestronglyMeasurable measurableSet_Ioi)
    refine h1.congr ?_
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
    have hy0 : (y : ℂ) ≠ 0 := by exact_mod_cast (by linarith [mem_Ioi.mp hy] : y ≠ 0)
    simp only [Pi.mul_apply]
    rw [mul_assoc, ← Complex.cpow_add _ _ hy0]
    congr 2
    ring
  refine Integrable.mono hint0 hmeas ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
  have hy0 : 0 < y := by linarith [mem_Ioi.mp hy]
  rw [norm_mul, norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos hy0,
    Complex.norm_cpow_eq_rpow_re_of_pos hy0]
  simp

/-- The primitive of `log y · y^(−s)`. -/
private def logPrim (s : ℂ) (t : ℝ) : ℂ :=
  (t : ℂ) ^ (-s + 1) / (-s + 1) * (Real.log t : ℂ) - (t : ℂ) ^ (-s + 1) / (-s + 1) / (-s + 1)

/-- Helper: for `s ≠ 1` and `y > 0`, the primitive `logPrim s` has derivative
`log y · y^(−s)` at `y`. -/
private lemma hasDerivAt_logPrim {s : ℂ} (hs1 : -s + 1 ≠ 0) {y : ℝ} (hy : 0 < y) :
    HasDerivAt (logPrim s) ((Real.log y : ℂ) * (y : ℂ) ^ (-s)) y := by
  have hr : -s ≠ -1 := by
    intro h; apply hs1; rw [h]; ring
  have hyC : (y : ℂ) ≠ 0 := by exact_mod_cast hy.ne'
  have hP := hasDerivAt_ofReal_cpow_const' hy.ne' hr
  have hL := (Real.hasDerivAt_log hy.ne').ofReal_comp
  have h := (hP.mul hL).sub (hP.div_const (-s + 1))
  have hpow : (y : ℂ) ^ (-s + 1) = (y : ℂ) ^ (-s) * y := by
    rw [Complex.cpow_add _ _ hyC, Complex.cpow_one]
  have h2 : HasDerivAt (logPrim s)
      ((y : ℂ) ^ (-s) * (Real.log y : ℂ) + (y : ℂ) ^ (-s + 1) / (-s + 1) * ((y⁻¹ : ℝ) : ℂ)
        - (y : ℂ) ^ (-s) / (-s + 1)) y := h
  refine h2.congr_deriv ?_
  rw [hpow]
  push_cast
  field_simp
  try ring

/-- Helper: for `Re s > 1` and `y > 1`, with `ε = (Re s − 1)/2`, the norm of
`log y · y^(−s)` is at most `y^(ε − Re s) / ε`. -/
private lemma log_cpow_norm_le {s : ℂ} (hs : 1 < s.re) {y : ℝ} (hy : 1 < y) :
    ‖(Real.log y : ℂ) * (y : ℂ) ^ (-s)‖
      ≤ y ^ ((s.re - 1) / 2 - s.re) / ((s.re - 1) / 2) := by
  have hy0 : 0 < y := by linarith
  have hε : 0 < (s.re - 1) / 2 := by linarith
  have hlog : 0 ≤ Real.log y := Real.log_nonneg hy.le
  rw [norm_mul, Complex.norm_real, Real.norm_of_nonneg hlog,
    Complex.norm_cpow_eq_rpow_re_of_pos hy0]
  have hre : (-s).re = -s.re := by simp
  rw [hre, sub_eq_add_neg, Real.rpow_add hy0, div_eq_mul_inv, mul_right_comm]
  have := Real.log_le_rpow_div hy0.le hε
  rw [div_eq_mul_inv] at this
  exact mul_le_mul_of_nonneg_right this (Real.rpow_nonneg hy0.le _)

/-- For `Re s > 1`, the function `log y · y^(−s)` is integrable on `(1, ∞)`. -/
theorem log_cpow_integrable {s : ℂ} (hs : 1 < s.re) :
    IntegrableOn (fun y : ℝ => (Real.log y : ℂ) * (y : ℂ) ^ (-s)) (Ioi 1) := by
  have hbound : IntegrableOn
      (fun y : ℝ => y ^ ((s.re - 1) / 2 - s.re) / ((s.re - 1) / 2)) (Ioi 1) :=
    (integrableOn_Ioi_rpow_of_lt (by linarith) one_pos).div_const _
  have hcont : ContinuousOn (fun y : ℝ => (Real.log y : ℂ) * (y : ℂ) ^ (-s)) (Ioi 1) := by
    intro y hy
    have hy0 : y ≠ 0 := by linarith [mem_Ioi.mp hy]
    have h1 : ContinuousAt (fun y : ℝ => (Real.log y : ℂ)) y :=
      Complex.continuous_ofReal.continuousAt.comp (Real.continuousAt_log hy0)
    exact (h1.mul (Complex.continuousAt_ofReal_cpow_const y _ (Or.inr hy0))).continuousWithinAt
  refine Integrable.mono' hbound (hcont.aestronglyMeasurable measurableSet_Ioi) ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
  exact log_cpow_norm_le hs (mem_Ioi.mp hy)

/-- Helper: for `Re s > 1`, the primitive `logPrim s` tends to `0` at `+∞`. -/
private lemma tendsto_logPrim {s : ℂ} (hs : 1 < s.re) :
    Tendsto (logPrim s) atTop (𝓝 0) := by
  have hr : 0 < s.re - 1 := by linarith
  have hre : (-s + 1).re = -(s.re - 1) := by simp; ring
  -- the power tends to zero
  have h1 : Tendsto (fun t : ℝ => (t : ℂ) ^ (-s + 1)) atTop (𝓝 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    refine (tendsto_rpow_neg_atTop hr).congr' ?_
    filter_upwards [eventually_gt_atTop 0] with t ht
    rw [Complex.norm_cpow_eq_rpow_re_of_pos ht, hre]
  -- the power times the logarithm tends to zero
  have h2 : Tendsto (fun t : ℝ => (t : ℂ) ^ (-s + 1) * (Real.log t : ℂ)) atTop (𝓝 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    refine ((isLittleO_log_rpow_atTop hr).tendsto_div_nhds_zero).congr' ?_
    filter_upwards [eventually_gt_atTop 1] with t ht
    have ht0 : 0 < t := by linarith
    rw [norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos ht0, hre, Complex.norm_real,
      Real.norm_of_nonneg (Real.log_nonneg ht.le), Real.rpow_neg ht0.le]
    field_simp
  have h3 := (h2.div_const (-s + 1)).sub ((h1.div_const (-s + 1)).div_const (-s + 1))
  simp only [zero_div, sub_zero] at h3
  refine h3.congr (fun t => ?_)
  rw [logPrim]
  ring

/-- For `Re s > 1`, the integral of `log y · y^(−s)` over `(1, ∞)` equals `1/(s−1)²`. -/
theorem log_cpow_integral {s : ℂ} (hs : 1 < s.re) :
    ∫ y in Ioi (1 : ℝ), (Real.log y : ℂ) * (y : ℂ) ^ (-s) = 1 / (s - 1) ^ 2 := by
  have hs1 : -s + 1 ≠ 0 := by
    intro h
    have : s = 1 := by linear_combination -h
    rw [this] at hs; simp at hs
  have hs1' : s - 1 ≠ 0 := by
    intro h; apply hs1; linear_combination -h
  rw [integral_Ioi_of_hasDerivAt_of_tendsto'
    (fun x hx => hasDerivAt_logPrim hs1 (lt_of_lt_of_le one_pos (mem_Ici.mp hx)))
    (log_cpow_integrable hs) (tendsto_logPrim hs)]
  simp only [logPrim, Complex.ofReal_one, Complex.one_cpow, Real.log_one, Complex.ofReal_zero,
    mul_zero, zero_sub]
  field_simp
  try ring

/-- Helper: for `y > 1`, the Mellin integrand `G y · y^(−s−1)` splits as
`rampSum y · y^(−s−1) − log y · y^(−s) + (1+γ) · y^(−s)`. -/
private lemma G_integrand_eq (s : ℂ) {y : ℝ} (hy : 1 < y) :
    (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1)
      = (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)
        - (Real.log y : ℂ) * (y : ℂ) ^ (-s)
        + (1 + (Real.eulerMascheroniConstant : ℂ)) * (y : ℂ) ^ (-s) := by
  have hyC : (y : ℂ) ≠ 0 := by exact_mod_cast (by linarith : y ≠ 0)
  have hpow : (y : ℂ) ^ (-s) = (y : ℂ) ^ (-s - 1) * y := by
    rw [show (-s : ℂ) = (-s - 1) + 1 by ring, Complex.cpow_add _ _ hyC, Complex.cpow_one]
    congr 2; ring
  rw [LandauWindow.G, hpow]
  push_cast
  ring

/-- For `Re s > 1`, the Mellin integrand `G y · y^(−s−1)` is integrable on `(1, ∞)`. -/
theorem G_mellin_integrable {s : ℂ} (hs : 1 < s.re) :
    IntegrableOn (fun y : ℝ => (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) := by
  have hC : IntegrableOn (fun y : ℝ => (y : ℂ) ^ (-s)) (Ioi (1 : ℝ)) :=
    integrableOn_Ioi_cpow_of_lt (by simp; linarith) one_pos
  have h := ((rampSum_mellin_integrable hs).sub (log_cpow_integrable hs)).add
    (hC.const_mul (1 + (Real.eulerMascheroniConstant : ℂ)))
  refine h.congr_fun (fun y hy => ?_) measurableSet_Ioi
  exact (G_integrand_eq s (mem_Ioi.mp hy)).symm

/-- For `Re s > 1`, the Mellin transform of `G` over `(1, ∞)`,
`∫ G y · y^(−s−1) dy`, equals `Phi s`. -/
theorem mellin_G {s : ℂ} (hs : 1 < s.re) :
    ∫ y in Ioi (1 : ℝ), (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = Phi s := by
  have hs1 : -s + 1 ≠ 0 := by
    intro h
    have : s = 1 := by linear_combination -h
    rw [this] at hs; simp at hs
  have hs1' : s - 1 ≠ 0 := by
    intro h; apply hs1; linear_combination -h
  have hA := rampSum_mellin_integrable hs
  have hB := log_cpow_integrable hs
  have hC : IntegrableOn (fun y : ℝ => (y : ℂ) ^ (-s)) (Ioi (1 : ℝ)) :=
    integrableOn_Ioi_cpow_of_lt (by simp; linarith) one_pos
  rw [setIntegral_congr_fun measurableSet_Ioi (fun y hy => G_integrand_eq s (mem_Ioi.mp hy)),
    integral_add (f := fun y : ℝ => (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)
        - (Real.log y : ℂ) * (y : ℂ) ^ (-s)) (hA.sub hB) (hC.const_mul _), integral_sub hA hB, integral_const_mul,
    LandauMellin.mellin_rampSum hs, log_cpow_integral hs,
    integral_Ioi_cpow_of_lt (by simp; linarith) one_pos, Phi]
  simp only [Complex.ofReal_one, Complex.one_cpow]
  field_simp
  try ring

/-- info: 'LandauMellinG.rampSum_mellin_integrable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rampSum_mellin_integrable

/-- info: 'LandauMellinG.log_cpow_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_cpow_integral

/-- info: 'LandauMellinG.mellin_G' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mellin_G

end

end LandauMellinG
