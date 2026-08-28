/-
Slice 4 — the compact patch.  `‖ζ'/ζ(σ₁+it)‖` for `|t| ≤ 2`, under RH.
Slice 3 covers `|t| ≥ 2`; there the pole at `s = 1` sits outside the Jensen
disk.  For `|t| ≤ 2` it does not, so the local model carries the pole
explicitly through the entire function `zetaE s = (s-1)ζ(s)`.
Scratch only.
-/
import Stage3.JensenCount
import Stage3.Assembly

open Complex Set

namespace Slice4

noncomputable section

local notation "ζ" => riemannZeta

/-- Under RH, `ζ` has no zero with `1/2 < re s`, other than `s = 1`. -/
theorem zeta_ne_zero_of_RH (hRH : RiemannHypothesis) {s : ℂ}
    (hs : 1/2 < s.re) (hs1 : s ≠ 1) : ζ s ≠ 0 := by
  intro hz
  rcases le_or_gt 1 s.re with h | h
  · exact riemannZeta_ne_zero_of_one_le_re h hz
  · have htriv : ¬ ∃ n : ℕ, s = -2 * (n + 1) := by
      rintro ⟨n, rfl⟩
      simp at hs
      nlinarith [Nat.cast_nonneg (α := ℝ) n]
    have := hRH s hz htriv hs1
    rw [this] at hs
    linarith

/-- **The pole absorbed.**  `zetaE s = (s-1)·ζ s`, with the removable
singularity at `s = 1` filled in with its residue `1`.  Entire. -/
def zetaE : ℂ → ℂ := Function.update (fun s => (s - 1) * ζ s) 1 1

theorem zetaE_eq {s : ℂ} (hs : s ≠ 1) : zetaE s = (s - 1) * ζ s :=
  Function.update_of_ne hs _ _

theorem zetaE_one : zetaE 1 = 1 := Function.update_self _ _ _

theorem zetaE_differentiableAt_of_ne {s : ℂ} (hs : s ≠ 1) :
    DifferentiableAt ℂ zetaE s := by
  have heq : zetaE =ᶠ[nhds s] (fun u : ℂ => (u - 1) * ζ u) := by
    filter_upwards [isOpen_ne.mem_nhds hs] with u hu
    exact zetaE_eq hu
  refine DifferentiableAt.congr_of_eventuallyEq ?_ heq
  exact ((differentiableAt_id).sub_const 1).mul (differentiableAt_riemannZeta hs)

theorem zetaE_differentiable : Differentiable ℂ zetaE := by
  intro s
  rcases ne_or_eq s 1 with hs | rfl
  · exact zetaE_differentiableAt_of_ne hs
  · refine (analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt ?_ ?_).differentiableAt
    · filter_upwards [self_mem_nhdsWithin] with u hu
      exact zetaE_differentiableAt_of_ne hu
    · simpa only [zetaE, continuousAt_update_same] using riemannZeta_residue_one

/-- **The log-derivative shift.**  `zetaE'/zetaE = 1/(s-1) + ζ'/ζ`. -/
theorem logDeriv_zetaE {s : ℂ} (hs : s ≠ 1) (hz : ζ s ≠ 0) :
    deriv zetaE s / zetaE s = 1 / (s - 1) + deriv ζ s / ζ s := by
  have hs1 : s - 1 ≠ 0 := sub_ne_zero.mpr hs
  have hderiv : HasDerivAt (fun u : ℂ => (u - 1) * ζ u)
      (1 * ζ s + (s - 1) * deriv ζ s) s := by
    exact (((hasDerivAt_id s).sub_const 1).mul
      (differentiableAt_riemannZeta hs).hasDerivAt)
  have heq : ∀ᶠ u in nhds s, ((fun u : ℂ => (u - 1) * ζ u) u) = zetaE u := by
    filter_upwards [isOpen_ne.mem_nhds hs] with u hu
    exact (zetaE_eq hu).symm
  have hd : deriv zetaE s = 1 * ζ s + (s - 1) * deriv ζ s := by
    rw [← Filter.EventuallyEq.deriv_eq heq, hderiv.deriv]
  rw [hd, zetaE_eq hs]
  field_simp

theorem zetaE_ne_zero_of_RH (hRH : RiemannHypothesis) {s : ℂ} (hs : 1/2 < s.re) :
    zetaE s ≠ 0 := by
  rcases eq_or_ne s 1 with rfl | hs1
  · rw [zetaE_one]; norm_num
  · rw [zetaE_eq hs1]
    exact mul_ne_zero (sub_ne_zero.mpr hs1) (zeta_ne_zero_of_RH hRH hs hs1)

/-- **The majorant on the wide disk, pole included.**  `‖zetaE w‖ ≤ 430` for
`|t| ≤ 2` and `‖w - (2 + it)‖ ≤ 15/8`. -/
theorem zetaE_disk_upper {t : ℝ} (ht : |t| ≤ 2) {w : ℂ}
    (hw : ‖w - (2 + Complex.I * (t : ℂ))‖ ≤ 15 / 8) : ‖zetaE w‖ ≤ 430 := by
  obtain ⟨hta, htb⟩ := abs_le.mp ht
  rcases eq_or_ne w 1 with rfl | hw1
  · rw [zetaE_one]; norm_num
  have hu_re : (w - (2 + Complex.I * (t : ℂ))).re = w.re - 2 := by simp
  have hu_im : (w - (2 + Complex.I * (t : ℂ))).im = w.im - t := by simp
  have h1 : |w.re - 2| ≤ 15 / 8 := by
    rw [← hu_re]; exact le_trans (Complex.abs_re_le_norm _) hw
  have h2 : |w.im - t| ≤ 15 / 8 := by
    rw [← hu_im]; exact le_trans (Complex.abs_im_le_norm _) hw
  obtain ⟨h1a, h1b⟩ := abs_le.mp h1
  obtain ⟨h2a, h2b⟩ := abs_le.mp h2
  have hre : (1 : ℝ) / 8 ≤ w.re := by linarith
  have hrepos : 0 < w.re := by linarith
  have himabs : |w.im| ≤ 31 / 8 := abs_le.mpr ⟨by linarith, by linarith⟩
  have hnw1 : ‖w - 1‖ ≤ 27 / 4 := by
    refine le_trans (Complex.norm_le_abs_re_add_abs_im _) ?_
    have e1 : (w - 1).re = w.re - 1 := by simp
    have e2 : (w - 1).im = w.im := by simp
    rw [e1, e2]
    have : |w.re - 1| ≤ 23 / 8 := abs_le.mpr ⟨by linarith, by linarith⟩
    linarith
  have hnw : ‖w‖ ≤ 31 / 4 := by
    refine le_trans (Complex.norm_le_abs_re_add_abs_im _) ?_
    have : |w.re| ≤ 31 / 8 := abs_le.mpr ⟨by linarith, by linarith⟩
    linarith
  -- the tail integral, as in JensenCount.zeta_disk_upper
  have domBound : ∀ {x : ℝ}, x ∈ Set.Ioi (1 : ℝ) →
      |Int.fract x| * ‖(x : ℂ) ^ (-w - 1)‖ ≤ x ^ (-w.re - 1) := by
    intro x hu
    rw [Set.mem_Ioi] at hu
    rw [Complex.norm_cpow_eq_rpow_re_of_pos (by linarith)]
    simp only [Complex.sub_re, Complex.neg_re, Complex.one_re, Int.abs_fract]
    exact mul_le_of_le_one_left (Real.rpow_nonneg (by linarith) _) (Int.fract_lt_one x).le
  have domIntegral : MeasureTheory.Integrable (fun x : ℝ => x ^ (-w.re - 1))
      (MeasureTheory.volume.restrict (Set.Ioi 1)) :=
    integrableOn_Ioi_rpow_of_lt (by linarith) zero_lt_one
  have hint : ‖∫ (u : ℝ) in Set.Ioi 1, ((Int.fract u : ℝ) : ℂ) * (u : ℂ) ^ (-w - 1)‖
      ≤ 1 / w.re := by
    refine (MeasureTheory.norm_integral_le_integral_norm _).trans ?_
    have hI := integral_Ioi_rpow_of_lt (a := -w.re - 1) (by linarith) one_pos
    simp only [sub_add_cancel, Real.one_rpow, neg_div_neg_eq] at hI
    simp only [Complex.norm_mul, Complex.norm_real, Real.norm_eq_abs, ← hI]
    refine MeasureTheory.integral_mono_ae (domIntegral.mono' (((measurable_fract.abs).mul
      ((Complex.measurable_ofReal.pow_const _).norm)).aestronglyMeasurable) ?_) domIntegral
      (by filter_upwards [MeasureTheory.self_mem_ae_restrict measurableSet_Ioi] with x hx using
        domBound hx)
    filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with x hx
    rw [norm_mul, Real.norm_eq_abs, abs_abs, norm_norm]
    exact domBound hx
  have hinv : (1 : ℝ) / w.re ≤ 8 := by rw [div_le_iff₀ hrepos]; linarith
  rw [zetaE_eq hw1, ZetaAltFormula hrepos hw1]
  have hform : (w - 1) * riemannZeta1 w
      = ((w - 1) + 1)
        - (w - 1) * w * (∫ (u : ℝ) in Set.Ioi 1,
            ((Int.fract u : ℝ) : ℂ) * (u : ℂ) ^ (-w - 1)) := by
    unfold riemannZeta1
    field_simp
  rw [hform]
  have hA : ‖(w - 1) + 1‖ ≤ 27 / 4 + 1 := le_trans (norm_add_le _ _) (by
    rw [norm_one]; linarith)
  have hB : ‖(w - 1) * w * (∫ (u : ℝ) in Set.Ioi 1,
      ((Int.fract u : ℝ) : ℂ) * (u : ℂ) ^ (-w - 1))‖ ≤ 27 / 4 * (31 / 4) * 8 := by
    rw [norm_mul, norm_mul]
    have h0 : (0:ℝ) ≤ ‖w - 1‖ := norm_nonneg _
    have h3 : ‖∫ (u : ℝ) in Set.Ioi 1, ((Int.fract u : ℝ) : ℂ) * (u : ℂ) ^ (-w - 1)‖ ≤ 8 :=
      le_trans hint hinv
    have h4 : ‖w - 1‖ * ‖w‖ ≤ 27 / 4 * (31 / 4) :=
      mul_le_mul hnw1 hnw (norm_nonneg _) (by norm_num)
    exact mul_le_mul h4 h3 (norm_nonneg _) (by norm_num)
  refine le_trans (norm_sub_le_of_le hA hB) ?_
  norm_num

/-- `log 1300 ≤ 7.625`, from `1300 ≤ 2^11`. -/
theorem log_1300_le : Real.log 1300 ≤ 7.625 := by
  have h1 : Real.log 1300 ≤ Real.log 2048 := Real.log_le_log (by norm_num) (by norm_num)
  have h2 : Real.log 2048 = 11 * Real.log 2 := by
    rw [show (2048 : ℝ) = 2 ^ (11 : ℕ) by norm_num, Real.log_pow]; norm_num
  have h3 := Real.log_two_lt_d9
  linarith

/-- The FinalBound constant at `r' = 3/4, r = 7/8, R' = 9/10, R = 15/16` — the
same radii as slice 3. -/
theorem finalBoundConst_le :
    16 * ((7:ℝ)/8) ^ 2 / ((7/8) - (3/4)) ^ 3
      + 1 / (((15/16:ℝ) ^ 2 / (9/10) - 9/10) * Real.log ((15/16)/(9/10))) ≤ 6600 := by
  have hlog : (1:ℝ)/25 ≤ Real.log (25/24) := by
    have h1 : Real.log (24/25) ≤ 24/25 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (25:ℝ)/24 = ((24:ℝ)/25)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hden : ((15/16:ℝ) ^ 2 / (9/10) - 9/10) = 49/640 := by norm_num
  have hrat : ((15/16:ℝ)/(9/10)) = 25/24 := by norm_num
  have hpos : (0:ℝ) < 49/16000 := by norm_num
  have hle : (49:ℝ)/16000 ≤ (49/640) * Real.log ((15/16)/(9/10)) := by
    rw [hrat]; nlinarith [hlog]
  have h2 : 1 / (((15/16:ℝ) ^ 2 / (9/10) - 9/10) * Real.log ((15/16)/(9/10)))
      ≤ 16000/49 := by
    rw [hden]
    calc 1 / ((49/640:ℝ) * Real.log ((15/16)/(9/10)))
        ≤ 1 / ((49:ℝ)/16000) := one_div_le_one_div_of_le hpos hle
      _ = 16000/49 := by norm_num
  have h1 : 16 * ((7:ℝ)/8) ^ 2 / ((7/8) - (3/4)) ^ 3 = 6272 := by norm_num
  rw [h1]; linarith

/-- **Slice 4 — the compact patch.**  Under RH, for `|t| ≤ 2` and
`1/2 < σ₁ ≤ 3/4`,
`‖ζ'/ζ (σ₁ + it)‖ ≤ 25200 + 115/(σ₁ - 1/2)`. -/
theorem logDerivZeta_compact (hRH : RiemannHypothesis) {t σ₁ : ℝ} (ht : |t| ≤ 2)
    (hlo : 1/2 < σ₁) (hhi : σ₁ ≤ 3/4) :
    ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖
      ≤ 25200 + 115 / (σ₁ - 1/2) := by
  classical
  set c : ℂ := 2 + I * (t : ℂ) with hc
  set s : ℂ := (σ₁ : ℂ) + I * (t : ℂ) with hs
  set z0 : ℂ := ((σ₁ - 2 : ℝ) : ℂ) / 2 with hz0
  have hδ : (0:ℝ) < σ₁ - 1/2 := by linarith
  have hz0re : z0.re = (σ₁ - 2)/2 := by simp [hz0]
  have hz0norm : ‖z0‖ = (2 - σ₁)/2 := by
    rw [hz0, norm_div, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonpos (by linarith : σ₁ - 2 ≤ 0)]
    simp only [Complex.norm_ofNat]
    ring
  have h2z0 : 2 * z0 + c = s := by rw [hz0, hc, hs]; push_cast; ring
  have hsre : s.re = σ₁ := by simp [hs]
  have hsne1 : s ≠ 1 := by
    intro h; rw [h] at hsre; simp at hsre; linarith
  have hszero : ζ s ≠ 0 := zeta_ne_zero_of_RH hRH (by rw [hsre]; linarith) hsne1
  -- the centre
  have hcre : c.re = 2 := by simp [hc]
  have hcne1 : c ≠ 1 := by
    intro h; rw [h] at hcre; simp at hcre
  have hzc : ζ c ≠ 0 := Stage3.zeta_centre_ne_zero t
  have hzEc_ne : zetaE c ≠ 0 := by
    rw [zetaE_eq hcne1]; exact mul_ne_zero (sub_ne_zero.mpr hcne1) hzc
  have hc1norm : (1:ℝ) ≤ ‖c - 1‖ := by
    have : |(c - 1).re| ≤ ‖c - 1‖ := Complex.abs_re_le_norm _
    have hre : (c - 1).re = 1 := by
      rw [Complex.sub_re, hcre, Complex.one_re]; norm_num
    rw [hre] at this; simpa using this
  have hzEc_lower : (1:ℝ)/3 ≤ ‖zetaE c‖ := by
    rw [zetaE_eq hcne1, norm_mul]
    have h1 := Stage3.zeta_centre_lower t
    have h2 : (0:ℝ) ≤ ‖ζ c‖ := norm_nonneg _
    nlinarith
  -- the local model
  set f : ℂ → ℂ := fun z => zetaE (2 * z + c) / zetaE c with hf
  have hfz0 : f z0 = zetaE s / zetaE c := by rw [hf]; simp only; rw [h2z0]
  have hzEs_ne : zetaE s ≠ 0 := by
    rw [zetaE_eq hsne1]; exact mul_ne_zero (sub_ne_zero.mpr hsne1) hszero
  have hfz0ne : f z0 ≠ 0 := by rw [hfz0]; exact div_ne_zero hzEs_ne hzEc_ne
  have hf0 : f 0 = 1 := by
    rw [hf]; simp only [mul_zero, zero_add]; exact div_self hzEc_ne
  have hana : AnalyticOnNhd ℂ f (Metric.closedBall (0:ℂ) 1) := by
    have hdiff : Differentiable ℂ f := by
      refine Differentiable.div_const ?_ _
      exact zetaE_differentiable.comp (by fun_prop)
    exact fun z _ => (DifferentiableOn.analyticOnNhd
      (Differentiable.differentiableOn hdiff) isOpen_univ) z (Set.mem_univ z)
  have hana2 : AnalyticOnNhd ℂ f (Metric.ball (0:ℂ) 2) := by
    have hdiff : Differentiable ℂ f := by
      refine Differentiable.div_const ?_ _
      exact zetaE_differentiable.comp (by fun_prop)
    exact fun z _ => (DifferentiableOn.analyticOnNhd
      (Differentiable.differentiableOn hdiff) isOpen_univ) z (Set.mem_univ z)
  have hfin : (SetOfZeros 1 f).Finite := by
    by_contra hinf
    rw [Set.not_finite] at hinf
    have hsub : SetOfZeros 1 f ⊆ Metric.closedBall (0:ℂ) 1 := by
      intro x hx
      simpa only [Metric.mem_closedBall, dist_zero_right] using hx.1
    obtain ⟨x, hxK, hacc⟩ := hinf.exists_accPt_of_subset_isCompact
      (isCompact_closedBall (0:ℂ) 1) hsub
    have hxmem : x ∈ Metric.ball (0:ℂ) 2 := by
      simp only [Metric.mem_closedBall] at hxK
      simp only [Metric.mem_ball]
      linarith
    have hfeq : Set.EqOn f 0 (Metric.ball (0:ℂ) 2) := by
      refine AnalyticOnNhd.eqOn_zero_of_preconnected_of_mem_closure hana2
        (Metric.isPreconnected_ball) (z₀ := x) hxmem ?_
      simp only [mem_closure_iff_clusterPt, ← accPt_principal_iff_clusterPt]
      exact hacc.mono (Filter.principal_mono.mpr fun _ h => h.2)
    have := hfeq (Metric.mem_ball_self (by norm_num))
    rw [hf0] at this
    simp at this
  have hBgt : (1:ℝ) < 1300 := by norm_num
  have hbd : ∀ z : ℂ, ‖z‖ ≤ 15/16 → ‖f z‖ ≤ 1300 := by
    intro z hz
    have hwin : ‖(2 * z + c) - c‖ ≤ 15/8 := by
      rw [show (2 * z + c) - c = 2 * z by ring, norm_mul]
      simp only [Complex.norm_ofNat]
      linarith
    have hnum := zetaE_disk_upper ht hwin
    rw [hf]
    simp only [norm_div]
    rw [div_le_iff₀ (by linarith : (0:ℝ) < ‖zetaE c‖)]
    nlinarith [norm_nonneg (zetaE (2 * z + c))]
  have hr1 : (7:ℝ)/8 < 1 := by norm_num
  have hmem : z0 ∈ Metric.closedBall (0:ℂ) (3/4) \ SetOfZeros (9/10) f := by
    constructor
    · simp only [Metric.mem_closedBall, dist_zero_right, hz0norm]
      linarith
    · intro hmem2
      exact hfz0ne hmem2.2
  have hFB := FinalBound (B := 1300) (r' := 3/4) (r := 7/8) (R' := 9/10) (R := 15/16)
    (f := f) (z := z0) hBgt (by norm_num) (by norm_num) hr1 (by norm_num) (by norm_num)
    (by norm_num) hana hf0 hfin hbd hmem
  have hZB := ZerosBound (B := 1300) (r := 7/8) (R := 15/16) (f := f)
    (by norm_num) hr1 (by norm_num) (by norm_num) hana hf0 hfin hbd
  set S := (finiteSetOfZeros_mono hr1 hfin).toFinset with hS
  -- the zeros: either a zeta zero (re = -3/4 under RH) or the pole point (re = -1/2)
  have hzeroRe : ∀ ρ ∈ S, ρ.re = -(3/4) ∨ ρ.re = -(1/2) := by
    intro ρ hρ
    rw [hS, Set.Finite.mem_toFinset] at hρ
    obtain ⟨hρn, hρ0⟩ := hρ
    have hw0 : zetaE (2 * ρ + c) = 0 := by
      have hval : f ρ = zetaE (2 * ρ + c) / zetaE c := rfl
      rw [hval, div_eq_zero_iff] at hρ0
      exact hρ0.resolve_right hzEc_ne
    have hρre : |ρ.re| ≤ 7/8 := le_trans (Complex.abs_re_le_norm ρ) hρn
    obtain ⟨hρ1, hρ2⟩ := abs_le.mp hρre
    have hwre : (2 * ρ + c).re = 2 * ρ.re + 2 := by simp [hc]
    rcases eq_or_ne (2 * ρ + c) 1 with hv1 | hv1
    · right
      have : (2 * ρ + c).re = 1 := by rw [hv1]; simp
      rw [hwre] at this
      linarith
    · left
      rw [zetaE_eq hv1] at hw0
      have hzv : ζ (2 * ρ + c) = 0 := by
        rcases mul_eq_zero.mp hw0 with h | h
        · exact absurd (sub_eq_zero.mp h) hv1
        · exact h
      have hrepos : (0:ℝ) < (2 * ρ + c).re := by rw [hwre]; linarith
      have htriv : ¬ ∃ n : ℕ, (2 * ρ + c) = -2 * ((n:ℂ) + 1) := by
        rintro ⟨n, hn⟩
        rw [hn] at hrepos
        simp at hrepos
        nlinarith [Nat.cast_nonneg (α := ℝ) n]
      have := hRH (2 * ρ + c) hzv htriv hv1
      rw [hwre] at this
      linarith
  have hdist : ∀ ρ ∈ S, (σ₁ - 1/2)/2 ≤ ‖z0 - ρ‖ := by
    intro ρ hρ
    have hre : (z0 - ρ).re = (σ₁ - 2)/2 - ρ.re := by rw [Complex.sub_re, hz0re]
    have habs : (σ₁ - 1/2)/2 ≤ |(z0 - ρ).re| := by
      rcases hzeroRe ρ hρ with h | h
      · rw [hre, h, abs_of_nonneg (by linarith)]; linarith
      · rw [hre, h, abs_of_nonpos (by linarith)]; linarith
    exact le_trans habs (Complex.abs_re_le_norm _)
  have hsum : ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
      ≤ (2 / (σ₁ - 1/2)) * ((∑ ρ ∈ S, analyticOrderNatAt f ρ : ℕ) : ℝ) := by
    refine le_trans (norm_sum_le _ _) ?_
    rw [Nat.cast_sum, Finset.mul_sum]
    refine Finset.sum_le_sum ?_
    intro ρ hρ
    rw [norm_div, Complex.norm_natCast]
    have hd := hdist ρ hρ
    have hdpos : (0:ℝ) < ‖z0 - ρ‖ := lt_of_lt_of_le (by linarith) hd
    have hm : (0:ℝ) ≤ (analyticOrderNatAt f ρ : ℝ) := Nat.cast_nonneg _
    have hinvle : 1 / ‖z0 - ρ‖ ≤ 1 / ((σ₁ - 1/2)/2) :=
      one_div_le_one_div_of_le (by linarith) hd
    have h2 : (1:ℝ) / ((σ₁ - 1/2)/2) = 2 / (σ₁ - 1/2) := one_div_div _ _
    rw [h2] at hinvle
    calc ((analyticOrderNatAt f ρ : ℝ)) / ‖z0 - ρ‖
        = (analyticOrderNatAt f ρ : ℝ) * (1 / ‖z0 - ρ‖) := by ring
      _ ≤ (analyticOrderNatAt f ρ : ℝ) * (2 / (σ₁ - 1/2)) :=
          mul_le_mul_of_nonneg_left hinvle hm
      _ = 2 / (σ₁ - 1/2) * (analyticOrderNatAt f ρ : ℝ) := by ring
  have hlogB := log_1300_le
  have hlogBnn : (0:ℝ) ≤ Real.log 1300 := Real.log_nonneg (by norm_num)
  have hcount : ((∑ ρ ∈ S, analyticOrderNatAt f ρ : ℕ) : ℝ) ≤ 115 := by
    have hlog1514 : (1 : ℝ) / 15 ≤ Real.log (15 / 14) := by
      have h1 : Real.log (14 / 15) ≤ 14 / 15 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
      rw [show (15 : ℝ) / 14 = ((14 : ℝ) / 15)⁻¹ by norm_num, Real.log_inv]
      linarith
    have hlog1514pos : (0 : ℝ) < Real.log (15 / 14) := by linarith
    have hinv : 1 / Real.log (15 / 14) ≤ 15 := by
      rw [div_le_iff₀ hlog1514pos]; linarith
    rw [hS]
    calc ((∑ ρ ∈ (finiteSetOfZeros_mono hr1 hfin).toFinset, analyticOrderNatAt f ρ : ℕ) : ℝ)
        ≤ 1 / Real.log ((15/16) / (7/8)) * Real.log 1300 := hZB
      _ = 1 / Real.log (15/14) * Real.log 1300 := by norm_num
      _ ≤ 15 * Real.log 1300 := mul_le_mul_of_nonneg_right hinv hlogBnn
      _ ≤ 115 := by linarith
  have hK := finalBoundConst_le
  have hstep : ‖deriv f z0 / f z0‖ ≤ 50325 + (2 / (σ₁ - 1/2)) * 115 := by
    have htri : ‖deriv f z0 / f z0‖
        ≤ ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
          + ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖ := by
      simpa using norm_add_le (deriv f z0 / f z0
        - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
        (∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
    have hA : ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ 50325 := by
      refine le_trans hFB ?_
      calc (16 * ((7:ℝ)/8) ^ 2 / ((7/8) - (3/4)) ^ 3
            + 1 / (((15/16:ℝ) ^ 2 / (9/10) - 9/10) * Real.log ((15/16)/(9/10))))
            * Real.log 1300
          ≤ 6600 * Real.log 1300 := mul_le_mul_of_nonneg_right hK hlogBnn
        _ ≤ 50325 := by linarith
    have hB2 : ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ (2 / (σ₁ - 1/2)) * 115 := by
      refine le_trans hsum ?_
      exact mul_le_mul_of_nonneg_left hcount (by positivity)
    linarith
  -- transfer to ζ'/ζ, paying the pole term
  have hderiv : deriv f z0 / f z0 = 2 * (deriv zetaE s / zetaE s) := by
    have hd1 : HasDerivAt (fun z : ℂ => 2 * z + c) 2 z0 := by
      simpa using ((hasDerivAt_id z0).const_mul (2:ℂ)).add_const c
    have hd2 : HasDerivAt zetaE (deriv zetaE s) ((fun z : ℂ => 2 * z + c) z0) := by
      show HasDerivAt zetaE (deriv zetaE s) (2 * z0 + c)
      rw [h2z0]
      exact (zetaE_differentiable s).hasDerivAt
    have hd3 : HasDerivAt (fun z : ℂ => zetaE (2 * z + c)) (deriv zetaE s * 2) z0 := by
      simpa [Function.comp_def] using hd2.comp z0 hd1
    have hd4 : HasDerivAt f (deriv zetaE s * 2 / zetaE c) z0 := hd3.div_const (zetaE c)
    rw [hd4.deriv, hfz0]
    field_simp
  rw [hderiv, logDeriv_zetaE hsne1 hszero] at hstep
  have hpole : ‖(1:ℂ) / (s - 1)‖ ≤ 4 := by
    have hre : (s - 1).re = σ₁ - 1 := by rw [Complex.sub_re, hsre]; simp
    have h1 : (1:ℝ)/4 ≤ ‖s - 1‖ := by
      have := Complex.abs_re_le_norm (s - 1)
      rw [hre, abs_of_nonpos (by linarith)] at this
      linarith
    rw [norm_div, norm_one, div_le_iff₀ (by linarith : (0:ℝ) < ‖s - 1‖)]
    linarith
  have hexp : ‖2 * ((1:ℂ) / (s - 1) + deriv ζ s / ζ s)‖
      ≥ 2 * ‖deriv ζ s / ζ s‖ - 2 * ‖(1:ℂ) / (s - 1)‖ := by
    have h := norm_add_le ((1:ℂ) / (s - 1)) (deriv ζ s / ζ s)
    have h2 : ‖deriv ζ s / ζ s‖ ≤ ‖(1:ℂ)/(s-1) + deriv ζ s / ζ s‖ + ‖(1:ℂ)/(s-1)‖ := by
      have := norm_sub_le ((1:ℂ)/(s-1) + deriv ζ s / ζ s) ((1:ℂ)/(s-1))
      simpa using this
    rw [norm_mul]
    simp only [Complex.norm_ofNat]
    linarith
  have hfinal : (2 / (σ₁ - 1/2)) * 115 = 230 / (σ₁ - 1/2) := by ring
  rw [hfinal] at hstep
  have h115 : (115:ℝ) / (σ₁ - 1/2) = (230 / (σ₁ - 1/2))/2 := by ring
  rw [h115]
  linarith

end

end Slice4

#check @Slice4.zetaE_differentiable
#check @Slice4.logDeriv_zetaE
#check @Slice4.zetaE_disk_upper
#print axioms Slice4.zetaE_differentiable
#print axioms Slice4.logDeriv_zetaE
#print axioms Slice4.zetaE_disk_upper
#check @Slice4.logDerivZeta_compact
#print axioms Slice4.logDerivZeta_compact
