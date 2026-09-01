/-
ThetaLine — the vertical-line bound on `ζ'/ζ`, at a general abscissa `θ`.

WHAT THIS PORTS. `RHPull.integrand_norm_le` (`LineBound.lean:1096`) draws
its line bound from `Slice4b.logDerivZeta_line` (`:801`), which splits on
`|t| ≤ 2`:

    |t| ≥ 2   Slice3.logDerivZeta_sq_at_X   (:295)   ← logDerivZeta_crude
    |t| ≤ 2   Slice4.logDerivZeta_compact   (:531)   the pole is IN the disk

`Abscissa.logDerivZeta_crude_theta` already generalises the first input.
This module generalises the compact patch and reassembles the line.

WHERE `θ` ACTUALLY ENTERS THE COMPACT PATCH. The local model is
`zetaE(2z + c)/zetaE(c)` with `zetaE s = (s−1)ζ(s)`, so its zeros are the
ζ-zeros AND the pole point `s = 1`, which sits at `re = −1/2` in disk
coordinates. Under RH the ζ-zeros sit at `re = −3/4` exactly; a zero-free
half-plane at `θ` gives `re ≤ (θ−2)/2`, and — as in the crude bound — the
proof only ever used the lower bound. The pole point does not move.

The distance bound lumps both under one denominator. For the pole,
`|(z₀ − ρ_pole).re| = (1 − σ₁)/2`, and lumping it under `(σ₁ − θ)/2`
requires `1 − σ₁ ≥ σ₁ − θ`, i.e.

    σ₁ ≤ (1 + θ)/2          (RH version: σ₁ ≤ 3/4)

That is the ONE geometric constraint that shifts with `θ`, and it is what
makes the line theorem's `4 ≤ log X` become `2/(1−θ) ≤ log X`: the
abscissa `θ + 1/log X` must stay left of the midpoint between the
zero-free boundary and the pole. At `θ = 1/2` the two hypotheses agree.

The pole term `‖1/(s−1)‖` is bounded by `2/(1−θ)` (RH: `4`) and carried
separately, so the `θ = 1/2` instance implies the built statement.

CONSTANTS. `29060 = 3991·log 1300`, `212 = 29·log 1300`, `11100`: all from
the fixed radii and the fixed `B = 1300`. None depends on `θ`.

Companion to notes entries 284–288.
-/
import Mathlib
import Stage3.Abscissa

namespace Stage3

open Complex

noncomputable section

local notation "ζ" => riemannZeta

open Slice4 (zetaE zetaE_eq zetaE_differentiable logDeriv_zetaE zetaE_disk_upper log_1300_le)

/-! ## The compact patch, `|t| ≤ 2`, at abscissa `θ` -/

/-- **The compact patch at a general zero-free abscissa.** `|t| ≤ 2`,
`θ < σ₁ ≤ (1+θ)/2`:
`‖ζ'/ζ (σ₁ + it)‖ ≤ 14530 + 2/(1−θ) + 212/(σ₁ − θ)`.
`Slice4.logDerivZeta_compact` is the `θ = 1/2` instance (where the pole
term is `4` and `14534 ≤ 14535`). -/
theorem logDerivZeta_compact_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {t σ₁ : ℝ} (ht : |t| ≤ 2)
    (hlo : θ < σ₁) (hhi : σ₁ ≤ (1 + θ)/2) :
    ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖
      ≤ 14530 + 2 / (1 - θ) + 212 / (σ₁ - θ) := by
  classical
  set c : ℂ := 2 + I * (t : ℂ) with hc
  set s : ℂ := (σ₁ : ℂ) + I * (t : ℂ) with hs
  set z0 : ℂ := ((σ₁ - 2 : ℝ) : ℂ) / 2 with hz0
  have hδ : (0:ℝ) < σ₁ - θ := by linarith
  have h1θ : (0:ℝ) < 1 - θ := by linarith
  have hσ1 : σ₁ < 1 := by linarith
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
  have hszero : ζ s ≠ 0 := zeta_ne_zero_right_of hθ (by rw [hsre]; linarith) hsne1
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
  have hr1 : (181:ℝ)/200 < 1 := by norm_num
  have hmem : z0 ∈ Metric.closedBall (0:ℂ) (3/4) \ SetOfZeros (29/32) f := by
    constructor
    · simp only [Metric.mem_closedBall, dist_zero_right, hz0norm]
      linarith
    · intro hmem2
      exact hfz0ne hmem2.2
  have hFB := FinalBound (B := 1300) (r' := 3/4) (r := 181/200) (R' := 29/32) (R := 15/16)
    (f := f) (z := z0) hBgt (by norm_num) (by norm_num) hr1 (by norm_num) (by norm_num)
    (by norm_num) hana hf0 hfin hbd hmem
  have hZB := ZerosBound (B := 1300) (r := 181/200) (R := 15/16) (f := f)
    (by norm_num) hr1 (by norm_num) (by norm_num) hana hf0 hfin hbd
  set S := (finiteSetOfZeros_mono hr1 hfin).toFinset with hS
  -- THE ONE SUBSTANTIVE CHANGE.  A zero of the model is a ζ-zero, now only known
  -- to satisfy `re ≤ (θ-2)/2`, or the pole point at `re = -1/2`, which does not move.
  have hzeroRe : ∀ ρ ∈ S, ρ.re ≤ (θ - 2)/2 ∨ ρ.re = -(1/2) := by
    intro ρ hρ
    rw [hS, Set.Finite.mem_toFinset] at hρ
    obtain ⟨hρn, hρ0⟩ := hρ
    have hw0 : zetaE (2 * ρ + c) = 0 := by
      have hval : f ρ = zetaE (2 * ρ + c) / zetaE c := rfl
      rw [hval, div_eq_zero_iff] at hρ0
      exact hρ0.resolve_right hzEc_ne
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
      by_contra hcon
      push_neg at hcon
      exact hθ (2 * ρ + c) (by rw [hwre]; linarith) hv1 hzv
  -- distance lower bound: the ζ-zeros by the half-plane, the pole by `σ₁ ≤ (1+θ)/2`
  have hdist : ∀ ρ ∈ S, (σ₁ - θ)/2 ≤ ‖z0 - ρ‖ := by
    intro ρ hρ
    have hre : (z0 - ρ).re = (σ₁ - 2)/2 - ρ.re := by rw [Complex.sub_re, hz0re]
    have habs : (σ₁ - θ)/2 ≤ |(z0 - ρ).re| := by
      rcases hzeroRe ρ hρ with h | h
      · have h' : (σ₁ - θ)/2 ≤ (z0 - ρ).re := by rw [hre]; linarith
        exact le_trans h' (le_abs_self _)
      · rw [hre, h, abs_of_nonpos (by linarith)]; linarith
    exact le_trans habs (Complex.abs_re_le_norm _)
  have hsum : ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
      ≤ (2 / (σ₁ - θ)) * ((∑ ρ ∈ S, analyticOrderNatAt f ρ : ℕ) : ℝ) := by
    refine le_trans (norm_sum_le _ _) ?_
    rw [Nat.cast_sum, Finset.mul_sum]
    refine Finset.sum_le_sum ?_
    intro ρ hρ
    rw [norm_div, Complex.norm_natCast]
    have hd := hdist ρ hρ
    have hdpos : (0:ℝ) < ‖z0 - ρ‖ := lt_of_lt_of_le (by linarith) hd
    have hm : (0:ℝ) ≤ (analyticOrderNatAt f ρ : ℝ) := Nat.cast_nonneg _
    have hinvle : 1 / ‖z0 - ρ‖ ≤ 1 / ((σ₁ - θ)/2) :=
      one_div_le_one_div_of_le (by linarith) hd
    have h2 : (1:ℝ) / ((σ₁ - θ)/2) = 2 / (σ₁ - θ) := one_div_div _ _
    rw [h2] at hinvle
    calc ((analyticOrderNatAt f ρ : ℝ)) / ‖z0 - ρ‖
        = (analyticOrderNatAt f ρ : ℝ) * (1 / ‖z0 - ρ‖) := by ring
      _ ≤ (analyticOrderNatAt f ρ : ℝ) * (2 / (σ₁ - θ)) :=
          mul_le_mul_of_nonneg_left hinvle hm
      _ = 2 / (σ₁ - θ) * (analyticOrderNatAt f ρ : ℝ) := by ring
  have hlogB := log_1300_le
  have hlogBnn : (0:ℝ) ≤ Real.log 1300 := Real.log_nonneg (by norm_num)
  have hcount : ((∑ ρ ∈ S, analyticOrderNatAt f ρ : ℕ) : ℝ) ≤ 212 := by
    have hlog1514 : (13 : ℝ) / 375 ≤ Real.log (375 / 362) := by
      have h1 : Real.log (362 / 375) ≤ 362 / 375 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
      rw [show (375 : ℝ) / 362 = ((362 : ℝ) / 375)⁻¹ by norm_num, Real.log_inv]
      linarith
    have hlog1514pos : (0 : ℝ) < Real.log (375 / 362) := by linarith
    have hinv : 1 / Real.log (375 / 362) ≤ 29 := by
      rw [div_le_iff₀ hlog1514pos]; linarith
    rw [hS]
    calc ((∑ ρ ∈ (finiteSetOfZeros_mono hr1 hfin).toFinset, analyticOrderNatAt f ρ : ℕ) : ℝ)
        ≤ 1 / Real.log ((15/16) / (181/200)) * Real.log 1300 := hZB
      _ = 1 / Real.log (375/362) * Real.log 1300 := by norm_num
      _ ≤ 29 * Real.log 1300 := mul_le_mul_of_nonneg_right hinv hlogBnn
      _ ≤ 212 := by linarith
  have hK := Slice3.finalBoundConst_le
  have hstep : ‖deriv f z0 / f z0‖ ≤ 29060 + (2 / (σ₁ - θ)) * 212 := by
    have htri : ‖deriv f z0 / f z0‖
        ≤ ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
          + ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖ := by
      simpa using norm_add_le (deriv f z0 / f z0
        - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
        (∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
    have hA : ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ 29060 := by
      refine le_trans hFB ?_
      calc (16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3
            + 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32))))
            * Real.log 1300
          ≤ 3991 * Real.log 1300 := mul_le_mul_of_nonneg_right hK hlogBnn
        _ ≤ 29060 := by linarith
    have hB2 : ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ (2 / (σ₁ - θ)) * 212 := by
      refine le_trans hsum ?_
      exact mul_le_mul_of_nonneg_left hcount (by positivity)
    linarith
  -- transfer to ζ'/ζ, paying the pole term — now `2/(1-θ)` rather than `4`
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
  have hpole : ‖(1:ℂ) / (s - 1)‖ ≤ 2 / (1 - θ) := by
    have hre : (s - 1).re = σ₁ - 1 := by rw [Complex.sub_re, hsre]; simp
    have h1 : (1 - θ)/2 ≤ ‖s - 1‖ := by
      have := Complex.abs_re_le_norm (s - 1)
      rw [hre, abs_of_nonpos (by linarith)] at this
      linarith
    have hpos : (0:ℝ) < ‖s - 1‖ := lt_of_lt_of_le (by linarith) h1
    rw [norm_div, norm_one, div_le_div_iff₀ hpos h1θ]
    linarith
  have hexp : ‖2 * ((1:ℂ) / (s - 1) + deriv ζ s / ζ s)‖
      ≥ 2 * ‖deriv ζ s / ζ s‖ - 2 * ‖(1:ℂ) / (s - 1)‖ := by
    have h2 : ‖deriv ζ s / ζ s‖ ≤ ‖(1:ℂ)/(s-1) + deriv ζ s / ζ s‖ + ‖(1:ℂ)/(s-1)‖ := by
      have := norm_sub_le ((1:ℂ)/(s-1) + deriv ζ s / ζ s) ((1:ℂ)/(s-1))
      simpa using this
    rw [norm_mul]
    simp only [Complex.norm_ofNat]
    linarith
  have hfinal : (2 / (σ₁ - θ)) * 212 = 2 * (212 / (σ₁ - θ)) := by ring
  rw [hfinal] at hstep
  linarith

/-! ## The `|t| ≥ 2` half, at abscissa `θ + 1/log X` -/

/-- **`logDerivZeta_sq_at_X` at general `θ`.** On `σ₁ = θ + 1/log X` the
denominator `σ₁ − θ` is `1/log X` for EVERY `θ`, so `11100` survives
unchanged. `Slice3.logDerivZeta_sq_at_X` is the `θ = 1/2` instance. -/
theorem logDerivZeta_sq_at_X_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ ≤ 1) {t X : ℝ} (ht : 2 ≤ t)
    (hLX : 1 ≤ Real.log X) (htX : Real.log t ≤ Real.log X) :
    ‖deriv ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ))
        / ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ))‖
      ≤ 11100 * (Real.log X) ^ 2 := by
  have hLXpos : (0:ℝ) < Real.log X := by linarith
  have hLt : (0.6931:ℝ) ≤ Real.log t := by
    have h2 := Real.log_two_gt_d9
    have := Real.log_le_log (by norm_num : (0:ℝ) < 2) ht
    linarith
  have hlo : θ < θ + 1/Real.log X := by
    have : (0:ℝ) < 1/Real.log X := by positivity
    linarith
  have hhi : θ + 1/Real.log X ≤ 2 := by
    have : 1/Real.log X ≤ 1 := by rw [div_le_one hLXpos]; linarith
    linarith
  have hmain := logDerivZeta_crude_theta hθ hθlo ht hlo hhi
  refine le_trans hmain ?_
  have hδ : (θ + 1/Real.log X) - θ = 1/Real.log X := by ring
  have hdd : (29 * Real.log t + 129) / (1 / Real.log X)
      = (29 * Real.log t + 129) * Real.log X := by
    field_simp
  rw [hδ, hdd]
  have hlog84 : Real.log 84 ≤ 4.44 := by
      have h5 : Real.log ((84:ℝ) ^ (5:ℕ)) ≤ Real.log ((2:ℝ) ^ (32:ℕ)) :=
        Real.log_le_log (by positivity) (by norm_num)
      rw [Real.log_pow, Real.log_pow] at h5
      have h3 := Real.log_two_lt_d9
      push_cast at h5
      linarith
  have hlogB : Real.log (84 * t) = Real.log 84 + Real.log t :=
    Real.log_mul (by norm_num) (by linarith)
  rw [hlogB]
  nlinarith [hLX, hLXpos, htX, hLt, sq_nonneg (Real.log X)]

/-! ## The line, uniform in `t` -/

/-- **The vertical line at abscissa `θ`, uniform in `|t| ≤ X`.** On
`σ₁ = θ + 1/log X` with `log X ≥ 2/(1−θ)` and `|t| ≤ X`:
`‖ζ'/ζ‖ ≤ 11100 (log X)²`.

The hypothesis `2/(1−θ) ≤ log X` is the RH version's `4 ≤ log X` with the
`1/2` made explicit: it is exactly what keeps the abscissa left of the
midpoint `(1+θ)/2` between the zero-free boundary and the pole, which is
what the compact patch needs. `Slice4b.logDerivZeta_line` is the `θ = 1/2`
instance. -/
theorem logDerivZeta_line_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {X t : ℝ}
    (hLX : 2 / (1 - θ) ≤ Real.log X) (htX : |t| ≤ X) :
    ‖deriv ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ))
        / ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ))‖
      ≤ 11100 * (Real.log X) ^ 2 := by
  set L : ℝ := Real.log X with hL
  have h1θ : (0:ℝ) < 1 - θ := by linarith
  have h1θle : 1 - θ ≤ 1/2 := by linarith
  have hL2 : (2:ℝ) ≤ L := by
    have : (2:ℝ) ≤ 2 / (1 - θ) := by
      rw [le_div_iff₀ h1θ]; linarith
    linarith
  have hLpos : (0:ℝ) < L := by linarith
  have hσlo : θ < θ + 1/L := by
    have : (0:ℝ) < 1/L := by positivity
    linarith
  -- `1/L ≤ (1-θ)/2`, from `L ≥ 2/(1-θ)`
  have hinvL : 1/L ≤ (1 - θ)/2 := by
    rw [div_le_iff₀ hLpos]
    have : 2 / (1 - θ) * (1 - θ) = 2 := by field_simp
    nlinarith [hLX, h1θ]
  have hσhi : θ + 1/L ≤ (1 + θ)/2 := by linarith
  have hX1 : (1:ℝ) < X := by
    by_contra h
    push_neg at h
    have : Real.log X ≤ 0 := Real.log_nonpos (by linarith [abs_nonneg t, htX]) h
    linarith
  rcases le_or_gt |t| 2 with hsmall | hbig
  · have h4 := logDerivZeta_compact_theta hθ hθlo hθhi hsmall hσlo hσhi
    refine le_trans h4 ?_
    have hd : (θ + 1/L) - θ = 1/L := by ring
    rw [hd]
    have hdd : (212:ℝ) / (1 / L) = 212 * L := by field_simp
    rw [hdd]
    -- `2/(1-θ) ≤ L`, so the pole term is at most `L`
    have hpole : 2 / (1 - θ) ≤ L := hLX
    nlinarith [hLpos, hL2, sq_nonneg L]
  · have htabs : (2:ℝ) ≤ |t| := le_of_lt hbig
    have hlogabs : Real.log |t| ≤ L := Real.log_le_log (by linarith) htX
    have hmain := logDerivZeta_sq_at_X_theta hθ hθlo (le_of_lt hθhi) (t := |t|) (X := X)
      htabs (by linarith) hlogabs
    rcases abs_cases t with ⟨heq, _⟩ | ⟨heq, _⟩
    · rw [heq] at hmain; exact hmain
    · rw [heq] at hmain
      rw [← Slice4b.logDerivZeta_norm_neg (θ + 1/L) t] at *
      exact hmain

/-- **The weld at `θ = 1/2`.** Under RH the general line bound is
`Slice4b.logDerivZeta_line`'s statement, with `2/(1 − 1/2) = 4`. -/
theorem logDerivZeta_line_half (hRH : RiemannHypothesis) {X t : ℝ}
    (hLX : 4 ≤ Real.log X) (htX : |t| ≤ X) :
    ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))
        / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖
      ≤ 11100 * (Real.log X) ^ 2 :=
  logDerivZeta_line_theta (zeroFreeRight_of_RH hRH) le_rfl (by norm_num)
    (by norm_num; linarith) htX

end

/-! ## Axiom check -/

/-- info: 'Stage3.logDerivZeta_compact_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDerivZeta_compact_theta

/-- info: 'Stage3.logDerivZeta_sq_at_X_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDerivZeta_sq_at_X_theta

/-- info: 'Stage3.logDerivZeta_line_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDerivZeta_line_theta

/-- info: 'Stage3.logDerivZeta_line_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDerivZeta_line_half

end Stage3
