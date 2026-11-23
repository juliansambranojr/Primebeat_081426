/-
SquareMean — block C5a of `lean_stage3/design/carlson.md`. 2026-11-23.

An analytic function cannot be small in mean square on a square around a point where it has size
one. For `f` complex differentiable on an open set containing the closed square of half-side `δ`
about `c`, the iterated integral of `‖f‖²` over the square is at least `π·δ²·‖f c‖²`. The proof
takes the mean value property of `f²` on each circle of radius `r < δ`, which gives
`2π‖f c‖² ≤ ∫ ‖f‖²` over the circle; multiplies by `r` and integrates in polar coordinates over
the disc of radius `δ`; and compares the disc with the square, whose area integral is the
iterated cartesian integral by Fubini.

  circle_sq_mean   closedBall c r ⊆ U ⊢ 2π‖f c‖² ≤ ∫_{(−π,π)} ‖f(c + r(cos θ + i sin θ))‖² dθ
  ball_subset_sq   the closed disc of radius δ about c lies in the closed square of half-side δ
  norm_polar       ‖r(cos θ + i sin θ)‖ = |r|
  disc_sq_mean     π δ² ‖f c‖² ≤ ∫ over ℂ of ‖f‖² times the indicator of the disc
  sq_set_integral  the area integral of a function continuous on the square, as an iterated one
  sq_mean_lower    π δ² ‖f c‖² ≤ ∫_{u} ∫_{t} ‖f(u + i t)‖² over the square of half-side δ

What the next slice needs: `sq_mean_lower` at each zero `ρ` of `f = ζ·M_X − 1`, where
`‖f ρ‖ = 1`, summed over the zeros with the overlap count of the squares from the zero count in a
box of height two. It is not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib

namespace SquareMean

open MeasureTheory Set Metric Real

noncomputable section

/-- If `f` is complex differentiable on `U` and the closed disc of radius `r > 0` about `c` lies
in `U`, then `2π‖f c‖²` is at most the integral of `‖f‖²` over the circle of radius `r`,
parametrized by the angle in `(−π, π)`. -/
theorem circle_sq_mean {f : ℂ → ℂ} {c : ℂ} {r : ℝ} (hr : 0 < r) {U : Set ℂ}
    (hsub : closedBall c r ⊆ U) (hf : DifferentiableOn ℂ f U) :
    2 * π * ‖f c‖ ^ 2 ≤ ∫ θ in Ioo (-π) π,
      ‖f (c + (r : ℂ) * ((Real.cos θ : ℂ) + (Real.sin θ : ℂ) * Complex.I))‖ ^ 2 := by
  have hpi : 0 < 2 * π := by positivity
  have hg : DiffContOnCl ℂ (fun z => f z ^ 2) (ball c |r|) := by
    apply DifferentiableOn.diffContOnCl
    rw [closure_ball c (abs_pos.mpr hr.ne').ne', abs_of_pos hr]
    exact (hf.pow 2).mono hsub
  have hmv := hg.circleAverage
  rw [Real.circleAverage_def] at hmv
  set h : ℝ → ℝ := fun θ => ‖f (circleMap c r θ)‖ ^ 2 with hh
  have key : ‖f c‖ ^ 2 ≤ (2 * π)⁻¹ * ∫ θ in (0 : ℝ)..2 * π, h θ := by
    calc ‖f c‖ ^ 2 = ‖f c ^ 2‖ := (norm_pow _ _).symm
      _ = ‖(2 * π)⁻¹ • ∫ θ in (0 : ℝ)..2 * π, f (circleMap c r θ) ^ 2‖ := by rw [hmv]
      _ = (2 * π)⁻¹ * ‖∫ θ in (0 : ℝ)..2 * π, f (circleMap c r θ) ^ 2‖ := by
        rw [norm_smul, Real.norm_of_nonneg (by positivity)]
      _ ≤ (2 * π)⁻¹ * ∫ θ in (0 : ℝ)..2 * π, ‖f (circleMap c r θ) ^ 2‖ :=
        mul_le_mul_of_nonneg_left
          (intervalIntegral.norm_integral_le_integral_norm hpi.le) (by positivity)
      _ = (2 * π)⁻¹ * ∫ θ in (0 : ℝ)..2 * π, h θ := by simp_rw [hh, norm_pow]
  have hper : Function.Periodic h (2 * π) :=
    (periodic_circleMap c r).comp (fun z => ‖f z‖ ^ 2)
  have hshift := hper.intervalIntegral_add_eq 0 (-π)
  have e1 : (0 : ℝ) + 2 * π = 2 * π := by ring
  have e2 : -π + 2 * π = π := by ring
  rw [e1, e2] at hshift
  rw [hshift, intervalIntegral.integral_of_le (by linarith [Real.pi_pos]),
    integral_Ioc_eq_integral_Ioo] at key
  have hcm : ∀ θ : ℝ, h θ =
      ‖f (c + (r : ℂ) * ((Real.cos θ : ℂ) + (Real.sin θ : ℂ) * Complex.I))‖ ^ 2 := by
    intro θ
    simp only [hh, circleMap, Complex.exp_mul_I, Complex.ofReal_cos, Complex.ofReal_sin]
  simp_rw [hcm] at key
  have h2 := mul_le_mul_of_nonneg_left key hpi.le
  rw [← mul_assoc, mul_inv_cancel₀ hpi.ne', one_mul] at h2
  exact h2

/-- The closed disc of radius `δ` about `c` lies in the closed square of half-side `δ`
about `c`. -/
theorem ball_subset_sq (c : ℂ) (δ : ℝ) :
    closedBall c δ ⊆ (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)) := by
  intro z hz
  rw [mem_closedBall, dist_eq_norm] at hz
  have h1 := abs_le.mp ((Complex.abs_re_le_norm (z - c)).trans hz)
  have h2 := abs_le.mp ((Complex.abs_im_le_norm (z - c)).trans hz)
  rw [Complex.sub_re] at h1
  rw [Complex.sub_im] at h2
  simp only [Complex.mem_reProdIm, mem_Icc]
  exact ⟨⟨by linarith [h1.1], by linarith [h1.2]⟩, ⟨by linarith [h2.1], by linarith [h2.2]⟩⟩

/-- The norm of `r(cos θ + i sin θ)` is `|r|`. -/
theorem norm_polar (r θ : ℝ) :
    ‖(r : ℂ) * ((Real.cos θ : ℂ) + (Real.sin θ : ℂ) * Complex.I)‖ = |r| := by
  have := Complex.norm_polarCoord_symm (r, θ)
  rwa [Complex.polarCoord_symm_apply] at this

/-- If `f` is complex differentiable on an open `U` containing the closed disc of radius `δ`
about `c`, then `π δ² ‖f c‖²` is at most the integral over `ℂ` of `‖f‖²` cut off to the open
disc. -/
theorem disc_sq_mean {f : ℂ → ℂ} {c : ℂ} {δ : ℝ} (hδ : 0 < δ) {U : Set ℂ}
    (hsub : closedBall c δ ⊆ U) (hf : DifferentiableOn ℂ f U) :
    π * δ ^ 2 * ‖f c‖ ^ 2 ≤ ∫ z, (ball c δ).indicator (fun z => ‖f z‖ ^ 2) z := by
  set F : ℂ → ℝ := fun z => ‖f z‖ ^ 2 with hF
  set g : ℝ × ℝ → ℂ := fun p =>
    c + (p.1 : ℂ) * ((Real.cos p.2 : ℂ) + (Real.sin p.2 : ℂ) * Complex.I) with hg
  set K : ℝ × ℝ → ℝ := fun p => p.1 * F (g p) with hK
  set A : Set (ℝ × ℝ) := {p | |p.1| < δ} with hA
  have hAm : MeasurableSet A := (isOpen_lt (by fun_prop) continuous_const).measurableSet
  have hgc : Continuous g := by rw [hg]; fun_prop
  have hFc : ContinuousOn F (closedBall c δ) := (hf.continuousOn.mono hsub).norm.pow 2
  -- `K` is integrable on the polar rectangle
  have hKc : ContinuousOn K (Icc 0 δ ×ˢ Icc (-π) π) := by
    refine continuousOn_fst.mul (hFc.comp hgc.continuousOn ?_)
    intro p hp
    rw [mem_closedBall, dist_eq_norm, hg]
    simp only [add_sub_cancel_left]
    rw [norm_polar, abs_of_nonneg hp.1.1]
    exact hp.1.2
  have hKint : IntegrableOn K (Ioo 0 δ ×ˢ Ioo (-π) π) :=
    (hKc.integrableOn_compact (isCompact_Icc.prod isCompact_Icc)).mono_set
      (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)
  -- polar coordinates
  have hstep : ∀ p : ℝ × ℝ,
      p.1 • (ball c δ).indicator F (c + Complex.polarCoord.symm p) = A.indicator K p := by
    intro p
    have hmem : c + Complex.polarCoord.symm p ∈ ball c δ ↔ |p.1| < δ := by
      rw [mem_ball, dist_eq_norm, add_sub_cancel_left, Complex.norm_polarCoord_symm]
    by_cases hp : |p.1| < δ
    · rw [indicator_of_mem (hmem.mpr hp), indicator_of_mem (show p ∈ A from hp)]
      simp [hK, hg, hF, smul_eq_mul]
    · rw [indicator_of_notMem (fun h => hp (hmem.mp h)),
        indicator_of_notMem (show p ∉ A from hp), smul_zero]
  have hset : polarCoord.target ∩ A = Ioo 0 δ ×ˢ Ioo (-π) π := by
    ext p
    simp only [polarCoord_target, mem_inter_iff, mem_prod, mem_Ioi, mem_Ioo, hA,
      mem_setOf_eq]
    constructor
    · rintro ⟨⟨h1, h2⟩, h3⟩
      exact ⟨⟨h1, by rwa [abs_of_pos h1] at h3⟩, h2⟩
    · rintro ⟨⟨h1, h3⟩, h2⟩
      exact ⟨⟨h1, h2⟩, by rwa [abs_of_pos h1]⟩
  have hpolar : ∫ z, (ball c δ).indicator F z
      = ∫ r in Ioo 0 δ, ∫ θ in Ioo (-π) π, K (r, θ) := by
    rw [← integral_add_left_eq_self ((ball c δ).indicator F) c,
      ← Complex.integral_comp_polarCoord_symm]
    simp_rw [hstep]
    rw [setIntegral_indicator hAm, hset]
    exact setIntegral_prod K hKint
  -- the inner integral is at least `2π r ‖f c‖²`
  have hinner : ∀ r ∈ Ioo 0 δ, 2 * π * ‖f c‖ ^ 2 * r ≤ ∫ θ in Ioo (-π) π, K (r, θ) := by
    intro r hr
    have hcb : closedBall c r ⊆ U :=
      (closedBall_subset_closedBall hr.2.le).trans hsub
    have := circle_sq_mean hr.1 hcb hf
    simp only [hK, hg, hF]
    rw [integral_const_mul]
    nlinarith [hr.1]
  have hint_in : IntegrableOn (fun r => ∫ θ in Ioo (-π) π, K (r, θ)) (Ioo 0 δ) := by
    have h := hKint
    rw [IntegrableOn, Measure.volume_eq_prod, ← Measure.prod_restrict] at h
    exact h.integral_prod_left
  have hint_lin : IntegrableOn (fun r : ℝ => 2 * π * ‖f c‖ ^ 2 * r) (Ioo 0 δ) :=
    (continuous_const.mul continuous_id).integrableOn_Icc.mono_set Ioo_subset_Icc_self
  have hlow := setIntegral_mono_on hint_lin hint_in measurableSet_Ioo hinner
  have hcomp : ∫ r in Ioo 0 δ, 2 * π * ‖f c‖ ^ 2 * r = π * δ ^ 2 * ‖f c‖ ^ 2 := by
    rw [← integral_Ioc_eq_integral_Ioo, ← intervalIntegral.integral_of_le hδ.le,
      intervalIntegral.integral_const_mul, integral_id]
    ring
  rw [hpolar, ← hcomp]
  exact hlow

/-- For `F` continuous on the closed square of half-side `δ` about `c`, the area integral of `F`
over the square equals the iterated integral, outer over the real part and inner over the
imaginary part. -/
theorem sq_set_integral {F : ℂ → ℝ} {c : ℂ} {δ : ℝ} (hδ : 0 < δ)
    (hF : ContinuousOn F ((Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)))) :
    ∫ z in (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)), F z
      = ∫ u in (c.re - δ)..(c.re + δ), ∫ t in (c.im - δ)..(c.im + δ),
          F ((u : ℂ) + Complex.I * (t : ℂ)) := by
  set G : ℝ × ℝ → ℝ := fun p => F ((p.1 : ℂ) + Complex.I * (p.2 : ℂ)) with hG
  have hpre : (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ))
      = Complex.measurableEquivRealProd ⁻¹'
          (Icc (c.re - δ) (c.re + δ) ×ˢ Icc (c.im - δ) (c.im + δ)) := by
    ext z
    simp only [Complex.mem_reProdIm, Complex.measurableEquivRealProd_apply, mem_preimage,
      mem_prod]
  have hcongr : ∀ z : ℂ, F z = G (Complex.measurableEquivRealProd z) := by
    intro z
    simp only [hG, Complex.measurableEquivRealProd_apply]
    congr 1
    rw [mul_comm, Complex.re_add_im]
  have hGc : ContinuousOn G (Icc (c.re - δ) (c.re + δ) ×ˢ Icc (c.im - δ) (c.im + δ)) := by
    refine hF.comp (by fun_prop : Continuous fun p : ℝ × ℝ =>
      (p.1 : ℂ) + Complex.I * (p.2 : ℂ)).continuousOn ?_
    intro p hp
    simp only [Complex.mem_reProdIm, Complex.add_re, Complex.ofReal_re, Complex.mul_re,
      Complex.I_re, Complex.I_im, Complex.ofReal_im, Complex.add_im, Complex.mul_im]
    simp only [zero_mul, one_mul, sub_zero, add_zero, mul_zero, zero_add]
    exact ⟨hp.1, hp.2⟩
  have hGint : IntegrableOn G (Icc (c.re - δ) (c.re + δ) ×ˢ Icc (c.im - δ) (c.im + δ)) :=
    hGc.integrableOn_compact (isCompact_Icc.prod isCompact_Icc)
  have hL : (∫ z in (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)), F z)
      = ∫ z in (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)),
          G (Complex.measurableEquivRealProd z) := by
    congr 1
    funext z
    exact hcongr z
  rw [hL, hpre, Complex.volume_preserving_equiv_real_prod.setIntegral_preimage_emb
    Complex.measurableEquivRealProd.measurableEmbedding]
  rw [Measure.volume_eq_prod, setIntegral_prod G hGint]
  rw [intervalIntegral.integral_of_le (by linarith), ← integral_Icc_eq_integral_Ioc]
  refine setIntegral_congr_fun measurableSet_Icc (fun u _ => ?_)
  rw [intervalIntegral.integral_of_le (by linarith), ← integral_Icc_eq_integral_Ioc]

/-- An analytic function is not small in mean square on a square about a point where it is
large: for `f` complex differentiable on an open set containing the closed square of half-side
`δ` about `c`, the iterated integral of `‖f‖²` over the square is at least `π δ² ‖f c‖²`. -/
theorem sq_mean_lower {f : ℂ → ℂ} {c : ℂ} {δ : ℝ} (hδ : 0 < δ) {U : Set ℂ} (hU : IsOpen U)
    (hsub : (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)) ⊆ U)
    (hf : DifferentiableOn ℂ f U) :
    π * δ ^ 2 * ‖f c‖ ^ 2
      ≤ ∫ u in (c.re - δ)..(c.re + δ), ∫ t in (c.im - δ)..(c.im + δ),
          ‖f ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 := by
  set S := (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)) with hS
  set F : ℂ → ℝ := fun z => ‖f z‖ ^ 2 with hF
  have hSc : IsCompact S := isCompact_Icc.reProdIm isCompact_Icc
  have hSm : MeasurableSet S := hSc.isClosed.measurableSet
  have hFc : ContinuousOn F S := (hf.continuousOn.mono hsub).norm.pow 2
  have hFS : IntegrableOn F S := hFc.integrableOn_compact hSc
  have hcb : closedBall c δ ⊆ S := ball_subset_sq c δ
  have hball : ball c δ ⊆ S := ball_subset_closedBall.trans hcb
  have h1 := disc_sq_mean hδ (hcb.trans hsub) hf
  have h2 : ∫ z, (ball c δ).indicator F z ≤ ∫ z in S, F z := by
    rw [← integral_indicator hSm]
    exact integral_mono ((integrable_indicator_iff measurableSet_ball).2 (hFS.mono_set hball))
      ((integrable_indicator_iff hSm).2 hFS)
      (indicator_le_indicator_of_subset hball (fun z => by positivity))
  have h3 := sq_set_integral hδ hFc
  have _hU := hU
  calc π * δ ^ 2 * ‖f c‖ ^ 2 ≤ ∫ z, (ball c δ).indicator F z := h1
    _ ≤ ∫ z in S, F z := h2
    _ = _ := h3

/-- info: 'SquareMean.sq_mean_lower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sq_mean_lower

end

end SquareMean
