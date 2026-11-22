/-
RowLeaves — block E4 of `lean_stage3/design/joints.md`. 2026-11-22.

Two leaves the route to the gate left open (unit 0412).

  hasDerivAt_Li            1 < y ⊢ HasDerivAt Li (1 / Real.log y) y
  Li_two_rpow              0 < x ⊢ Li (2^x) = 2/log 2 + ∫ t in 1..x, exp (log 2·t)/t
  norm_logDerivZeta_zero   ‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2π)

`Li_two_rpow`'s right side is what `lean/Interpolant.liRow_eq` gives for the
table tree's interpolant from one half on, with `Expansion.f2x` unfolded: the
main term is the same function in the two trees. The two are on different
toolchains and meet by statement text.

`norm_logDerivZeta_zero` is the `K0` of `Glue.explicit_formula_poly` and
`Glue.explicit_formula_split`, as a number.

What the next slice needs: the other unnamed quantities (`W`, `M0`, `Mc`, the
compact patch), which need bounds on ζ in a bounded region.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.PsiToPi

namespace Stage3

open Set Filter Topology

noncomputable section

theorem continuousOn_inv_log_sq_Ioi :
    ContinuousOn (fun t : ℝ => 1 / Real.log t ^ 2) (Ioi 1) := by
  intro t ht
  have ht1 : (1 : ℝ) < t := ht
  have hl : Real.log t ≠ 0 := (Real.log_pos ht1).ne'
  apply ContinuousAt.continuousWithinAt
  exact continuousAt_const.div ((Real.continuousAt_log (by linarith)).pow 2)
    (pow_ne_zero 2 hl)

/-- `Li′ = 1/log` beyond one. -/
theorem hasDerivAt_Li {y : ℝ} (hy : 1 < y) : HasDerivAt Li (1 / Real.log y) y := by
  have hl : Real.log y ≠ 0 := (Real.log_pos hy).ne'
  have hy0 : y ≠ 0 := by linarith
  have hsub : uIcc (2 : ℝ) y ⊆ Ioi 1 := by
    intro t ht
    rcases mem_uIcc.mp ht with ⟨h1, _⟩ | ⟨h1, _⟩
    · exact lt_of_lt_of_le (by norm_num) h1
    · exact lt_of_lt_of_le hy h1
  have hint : IntervalIntegrable (fun t : ℝ => 1 / Real.log t ^ 2)
      MeasureTheory.volume 2 y :=
    (continuousOn_inv_log_sq_Ioi.mono hsub).intervalIntegrable
  have hmeas : StronglyMeasurableAtFilter (fun t : ℝ => 1 / Real.log t ^ 2) (𝓝 y)
      MeasureTheory.volume :=
    continuousOn_inv_log_sq_Ioi.stronglyMeasurableAtFilter isOpen_Ioi y hy
  have hcont : ContinuousAt (fun t : ℝ => 1 / Real.log t ^ 2) y :=
    continuousOn_inv_log_sq_Ioi.continuousAt (Ioi_mem_nhds hy)
  have h2 := intervalIntegral.integral_hasDerivAt_right hint hmeas hcont
  have h1 : HasDerivAt (fun t : ℝ => t / Real.log t)
      ((1 * Real.log y - y * y⁻¹) / Real.log y ^ 2) y :=
    (hasDerivAt_id y).div (Real.hasDerivAt_log hy0) hl
  have h := h1.add h2
  have heq : (1 * Real.log y - y * y⁻¹) / Real.log y ^ 2 + 1 / Real.log y ^ 2
      = 1 / Real.log y := by
    field_simp
    try ring
  rw [heq] at h
  exact h

/-- The derivative of `x ↦ Li (2^x)` is `e^(log 2·x)/x`. -/
theorem hasDerivAt_Li_two_rpow {x : ℝ} (hx : 0 < x) :
    HasDerivAt (fun u : ℝ => Li ((2 : ℝ) ^ u)) (Real.exp (Real.log 2 * x) / x) x := by
  have h2 : (1 : ℝ) < (2 : ℝ) ^ x := Real.one_lt_rpow (by norm_num) hx
  have hpow : HasDerivAt (fun u : ℝ => (2 : ℝ) ^ u) (Real.log 2 * 1 * (2 : ℝ) ^ x) x :=
    (hasDerivAt_id' x).const_rpow (a := (2 : ℝ)) (by norm_num)
  have hcomp := (hasDerivAt_Li h2).comp x hpow
  have hlog : Real.log ((2 : ℝ) ^ x) = x * Real.log 2 := Real.log_rpow (by norm_num) x
  have hexp : Real.exp (Real.log 2 * x) = (2 : ℝ) ^ x :=
    (Real.rpow_def_of_pos (by norm_num) x).symm
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  have heq : 1 / Real.log ((2 : ℝ) ^ x) * (Real.log 2 * 1 * (2 : ℝ) ^ x)
      = Real.exp (Real.log 2 * x) / x := by
    rw [hlog, hexp]
    field_simp
  rw [heq] at hcomp
  exact hcomp

theorem continuousOn_exp_div : ContinuousOn (fun t : ℝ => Real.exp (Real.log 2 * t) / t)
    (Ioi 0) := by
  intro t ht
  have ht0 : t ≠ 0 := ne_of_gt ht
  apply ContinuousAt.continuousWithinAt
  exact ((Real.continuous_exp.comp (continuous_const.mul continuous_id)).continuousAt).div
    continuousAt_id ht0

theorem hasDerivAt_rowIntegral {x : ℝ} (hx : 0 < x) :
    HasDerivAt (fun u : ℝ => 2 / Real.log 2
        + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t)
      (Real.exp (Real.log 2 * x) / x) x := by
  have hsub : uIcc (1 : ℝ) x ⊆ Ioi 0 := by
    intro t ht
    rcases mem_uIcc.mp ht with ⟨h1, _⟩ | ⟨h1, _⟩
    · exact lt_of_lt_of_le one_pos h1
    · exact lt_of_lt_of_le hx h1
  have hint : IntervalIntegrable (fun t : ℝ => Real.exp (Real.log 2 * t) / t)
      MeasureTheory.volume 1 x :=
    (continuousOn_exp_div.mono hsub).intervalIntegrable
  have hmeas := continuousOn_exp_div.stronglyMeasurableAtFilter
    (μ := MeasureTheory.volume) isOpen_Ioi x hx
  have hcont := continuousOn_exp_div.continuousAt (Ioi_mem_nhds hx)
  exact (intervalIntegral.integral_hasDerivAt_right hint hmeas hcont).const_add _

/-- **The main term at the doublings.** Stage 3's `Li` at `2^x` is the
antiderivative of `2^t/t` through `2/log 2` at `x = 1`. -/
theorem Li_two_rpow {x : ℝ} (hx : 0 < x) :
    Li ((2 : ℝ) ^ x)
      = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp (Real.log 2 * t) / t := by
  have hf : DifferentiableOn ℝ (fun u : ℝ => Li ((2 : ℝ) ^ u)) (Ioi 0) :=
    fun u hu => (hasDerivAt_Li_two_rpow hu).differentiableAt.differentiableWithinAt
  have hg : DifferentiableOn ℝ (fun u : ℝ => 2 / Real.log 2
      + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t) (Ioi 0) :=
    fun u hu => (hasDerivAt_rowIntegral hu).differentiableAt.differentiableWithinAt
  have hd : (Ioi (0 : ℝ)).EqOn (deriv (fun u : ℝ => Li ((2 : ℝ) ^ u)))
      (deriv (fun u : ℝ => 2 / Real.log 2
        + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t)) :=
    fun u hu => by
      rw [(hasDerivAt_Li_two_rpow hu).deriv, (hasDerivAt_rowIntegral hu).deriv]
  have h1 : (fun u : ℝ => Li ((2 : ℝ) ^ u)) 1
      = (fun u : ℝ => 2 / Real.log 2
        + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t) 1 := by
    simp [Li]
  exact isOpen_Ioi.eqOn_of_deriv_eq isPreconnected_Ioi hf hg hd
    (Set.mem_Ioi.mpr one_pos) h1 hx

/-- **`K0`, as a number.** -/
theorem norm_logDerivZeta_zero :
    ‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2 * Real.pi) := by
  rw [deriv_riemannZeta_zero, riemannZeta_zero]
  have h2pi : (1 : ℝ) ≤ 2 * Real.pi := by nlinarith [Real.pi_gt_three]
  have hcast : (2 * (Real.pi : ℂ)) = ((2 * Real.pi : ℝ) : ℂ) := by push_cast; ring
  rw [hcast, ← Complex.ofReal_log (by positivity)]
  have hq : (-((Real.log (2 * Real.pi) : ℝ) : ℂ) / 2) / (-1 / 2)
      = ((Real.log (2 * Real.pi) : ℝ) : ℂ) := by
    field_simp
  rw [hq, Complex.norm_real, Real.norm_of_nonneg (Real.log_nonneg h2pi)]

end

/-- info: 'Stage3.hasDerivAt_Li' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hasDerivAt_Li

/-- info: 'Stage3.Li_two_rpow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Li_two_rpow

/-- info: 'Stage3.norm_logDerivZeta_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_logDerivZeta_zero

end Stage3
