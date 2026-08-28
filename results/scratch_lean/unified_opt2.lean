import Stage3.JensenCount
import Stage3.Assembly
import PrimeNumberTheoremAnd.ZetaConj
import Mathlib.NumberTheory.LSeries.Dirichlet
import Mathlib.Analysis.SumIntegralComparisons
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals

/-
Slice 3 — the falsifier.  Crude explicit bound on ζ'/ζ just right of the
critical line, under RH, via Stage3.jensenF + PNT+ FinalBound.
Scratch only.
-/

open Complex

namespace Slice3

noncomputable section

local notation "ζ" => riemannZeta

/-- Under RH, ζ has no zero with `1/2 < re s`, other than `s = 1`. -/
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

/-- `log (30/29) ≥ 1/30`. -/
theorem log_3029_ge : (1:ℝ)/30 ≤ Real.log (30/29) := by
  have h1 : Real.log (29/30) ≤ 29/30 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
  rw [show (30:ℝ)/29 = ((29:ℝ)/30)⁻¹ by norm_num, Real.log_inv]
  linarith

/-- LEVER 2 — the FinalBound constant at `r' = 3/4, r = 181/200, R' = 29/32, R = 15/16`. -/
theorem finalBoundConst_le :
    16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3
      + 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32))) ≤ 3991 := by
  have hlog : (1:ℝ)/30 ≤ Real.log (30/29) := by
    have hh1 : Real.log (29/30) ≤ 29/30 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (30:ℝ)/29 = ((29:ℝ)/30)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hden : ((15/16:ℝ) ^ 2 / (29/32) - 29/32) = 59/928 := by norm_num
  have hrat : ((15/16:ℝ)/(29/32)) = 30/29 := by norm_num
  have hpos : (0:ℝ) < 59/27840 := by norm_num
  have hle : (59:ℝ)/27840 ≤ (59/928) * Real.log ((15/16)/(29/32)) := by
    rw [hrat]; nlinarith [hlog]
  have h2 : 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32)))
      ≤ 27840/59 := by
    rw [hden]
    calc 1 / ((59/928:ℝ) * Real.log ((15/16)/(29/32)))
        ≤ 1 / ((59:ℝ)/27840) := one_div_le_one_div_of_le hpos hle
      _ = 27840/59 := by norm_num
  have h1 : 16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3 = 104835200/29791 := by norm_num
  have h3 : (27840:ℝ)/59 ≤ 472 := by
    rw [div_le_iff₀ (by norm_num : (0:ℝ) < 59)]; norm_num
  have h4 : (104835200:ℝ)/29791 ≤ 3519.1 := by
    rw [div_le_iff₀ (by norm_num : (0:ℝ) < 29791)]; norm_num
  rw [h1]; linarith

section Main

variable (hRH : RiemannHypothesis)

/-- **Slice 3.**  Under RH, for `t ≥ 2` and `1/2 < σ₁ ≤ 3/2`,
`‖ζ'/ζ (σ₁ + it)‖ ≤ 1996 log(84 t) + (29 log t + 129)/(σ₁ - 1/2)`. -/
theorem logDerivZeta_crude (hRH : RiemannHypothesis) {t σ₁ : ℝ} (ht : 2 ≤ t)
    (hlo : 1/2 < σ₁) (hhi : σ₁ ≤ 2) :
    ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖
      ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - 1/2) := by
  classical
  set c : ℂ := 2 + I * (t : ℂ) with hc
  set s : ℂ := (σ₁ : ℂ) + I * (t : ℂ) with hs
  set z0 : ℂ := ((σ₁ - 2 : ℝ) : ℂ) / 2 with hz0
  -- basic real facts
  have hδ : (0:ℝ) < σ₁ - 1/2 := by linarith
  have htpos : (0:ℝ) < t := by linarith
  have hlogt : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) ht
  have hlogtpos : (0:ℝ) < Real.log t := lt_of_lt_of_le (Real.log_pos (by norm_num)) hlogt
  -- z0 coordinates
  have hz0re : z0.re = (σ₁ - 2)/2 := by
    simp [hz0]
  have hz0norm : ‖z0‖ = (2 - σ₁)/2 := by
    rw [hz0, norm_div, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonpos (by linarith : σ₁ - 2 ≤ 0)]
    simp only [Complex.norm_ofNat]
    ring
  have h2z0 : 2 * z0 + c = s := by
    rw [hz0, hc, hs]
    push_cast
    ring
  -- s facts
  have hsre : s.re = σ₁ := by simp [hs]
  have hsim : s.im = t := by simp [hs]
  have hsne1 : s ≠ 1 := by
    intro h; rw [h] at hsim; simp at hsim; linarith
  have hszero : ζ s ≠ 0 := zeta_ne_zero_of_RH hRH (by rw [hsre]; linarith) hsne1
  -- the local model
  set f : ℂ → ℂ := Stage3.jensenF t with hf
  have hfz0 : f z0 = ζ s / ζ c := by
    rw [hf, Stage3.jensenF, h2z0]
  have hcne : ζ c ≠ 0 := Stage3.zeta_centre_ne_zero t
  have hfz0ne : f z0 ≠ 0 := by
    rw [hfz0]; exact div_ne_zero hszero hcne
  -- derivative transfer
  have hderiv : deriv f z0 / f z0 = 2 * (deriv ζ s / ζ s) := by
    have hd1 : HasDerivAt (fun z : ℂ => 2 * z + c) 2 z0 := by
      simpa using ((hasDerivAt_id z0).const_mul (2:ℂ)).add_const c
    have hd2 : HasDerivAt ζ (deriv ζ s) ((fun z : ℂ => 2 * z + c) z0) := by
      show HasDerivAt ζ (deriv ζ s) (2 * z0 + c)
      rw [h2z0]
      exact (differentiableAt_riemannZeta hsne1).hasDerivAt
    have hd3 : HasDerivAt (fun z : ℂ => ζ (2 * z + c)) (deriv ζ s * 2) z0 := by
      simpa [Function.comp_def] using hd2.comp z0 hd1
    have hd4 : HasDerivAt f (deriv ζ s * 2 / ζ c) z0 := hd3.div_const (ζ c)
    rw [hd4.deriv, hfz0]
    field_simp
    try ring
  -- FinalBound inputs
  have hr1 : (181:ℝ)/200 < 1 := by norm_num
  have hfin : (SetOfZeros 1 f).Finite := Stage3.jensenF_zeros_finite ht
  have hana : AnalyticOnNhd ℂ f (Metric.closedBall (0:ℂ) 1) := Stage3.jensenF_analytic ht
  have hf0 : f 0 = 1 := Stage3.jensenF_zero_eq_one t
  have hbd : ∀ z : ℂ, ‖z‖ ≤ 15/16 → ‖f z‖ ≤ 84 * t := fun z hz => Stage3.jensenF_bound ht hz
  have hBgt : (1:ℝ) < 84 * t := by linarith
  have hmem : z0 ∈ Metric.closedBall (0:ℂ) (3/4) \ SetOfZeros (29/32) f := by
    constructor
    · simp only [Metric.mem_closedBall, dist_zero_right, hz0norm]
      linarith
    · intro hmem2
      exact hfz0ne hmem2.2
  have hFB := FinalBound (B := 84 * t) (r' := 3/4) (r := 181/200) (R' := 29/32) (R := 15/16)
    (f := f) (z := z0) hBgt (by norm_num) (by norm_num) hr1 (by norm_num) (by norm_num)
    (by norm_num) hana hf0 hfin hbd hmem
  have hZB := ZerosBound (B := 84 * t) (r := 181/200) (R := 15/16) (f := f)
    (by norm_num) hr1 (by norm_num) (by norm_num) hana hf0 hfin hbd
  -- the zeros all sit at re = -3/4 under RH
  set S := (finiteSetOfZeros_mono hr1 hfin).toFinset with hS
  have hzeroRe : ∀ ρ ∈ S, ρ.re = -(3/4) := by
    intro ρ hρ
    rw [hS, Set.Finite.mem_toFinset] at hρ
    obtain ⟨hρn, hρ0⟩ := hρ
    have hw0 : ζ (2 * ρ + c) = 0 := by
      have : f ρ = ζ (2 * ρ + c) / ζ c := rfl
      rw [this, div_eq_zero_iff] at hρ0
      exact hρ0.resolve_right hcne
    have hwc : ‖(2 * ρ + c) - c‖ ≤ 181/100 := by
      rw [show (2 * ρ + c) - c = 2 * ρ by ring, norm_mul]
      simp only [Complex.norm_ofNat]
      linarith
    have hwne1 : (2 * ρ + c) ≠ 1 := Stage3.pole_away_centre ht (by linarith [hwc] : ‖(2*ρ+c) - c‖ < 11/5)
    have hwre : (2 * ρ + c).re = 2 * ρ.re + 2 := by simp [hc]
    have hρre : |ρ.re| ≤ 181/200 := le_trans (Complex.abs_re_le_norm ρ) hρn
    have hrepos : (0:ℝ) < (2 * ρ + c).re := by
      rw [hwre]; cases abs_le.mp hρre with | intro h1 h2 => linarith
    have htriv : ¬ ∃ n : ℕ, (2 * ρ + c) = -2 * ((n:ℂ) + 1) := by
      rintro ⟨n, hn⟩
      rw [hn] at hrepos
      simp at hrepos
      nlinarith [Nat.cast_nonneg (α := ℝ) n]
    have := hRH (2 * ρ + c) hw0 htriv hwne1
    rw [hwre] at this
    linarith
  -- distance lower bound
  have hdist : ∀ ρ ∈ S, (σ₁ - 1/2)/2 ≤ ‖z0 - ρ‖ := by
    intro ρ hρ
    have h1 : (z0 - ρ).re = (σ₁ - 1/2)/2 := by
      rw [Complex.sub_re, hz0re, hzeroRe ρ hρ]; ring
    calc (σ₁ - 1/2)/2 = |(z0 - ρ).re| := by rw [h1, abs_of_nonneg (by linarith)]
      _ ≤ ‖z0 - ρ‖ := Complex.abs_re_le_norm _
  -- bound the sum
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
  -- count bound: 15 log t + 73
  have hlog1514 : (13 : ℝ) / 375 ≤ Real.log (375 / 362) := by
    have h1 : Real.log (362 / 375) ≤ 362 / 375 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (375 : ℝ) / 362 = ((362 : ℝ) / 375)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hlog1514pos : (0 : ℝ) < Real.log (375 / 362) := by linarith
  have hlog84 : Real.log 84 ≤ 4.44 := by
      have h5 : Real.log ((84:ℝ) ^ (5:ℕ)) ≤ Real.log ((2:ℝ) ^ (32:ℕ)) :=
        Real.log_le_log (by positivity) (by norm_num)
      rw [Real.log_pow, Real.log_pow] at h5
      have h3 := Real.log_two_lt_d9
      push_cast at h5
      linarith
  have hlog84nn : (0 : ℝ) ≤ Real.log 84 := Real.log_nonneg (by norm_num)
  have hlogB : Real.log (84 * t) = Real.log 84 + Real.log t :=
    Real.log_mul (by norm_num) (by linarith)
  have hcount : ((∑ ρ ∈ S, analyticOrderNatAt f ρ : ℕ) : ℝ) ≤ 29 * Real.log t + 129 := by
    have hinv : 1 / Real.log (375 / 362) ≤ 29 := by
      rw [div_le_iff₀ hlog1514pos]; linarith
    rw [hS]
    calc ((∑ ρ ∈ (finiteSetOfZeros_mono hr1 hfin).toFinset, analyticOrderNatAt f ρ : ℕ) : ℝ)
        ≤ 1 / Real.log ((15/16) / (181/200)) * Real.log (84 * t) := hZB
      _ = 1 / Real.log (375/362) * Real.log (84 * t) := by norm_num
      _ ≤ 29 * Real.log (84 * t) := by
          refine mul_le_mul_of_nonneg_right hinv ?_
          rw [hlogB]; linarith
      _ = 29 * (Real.log 84 + Real.log t) := by rw [hlogB]
      _ ≤ 29 * Real.log t + 129 := by linarith
  -- assemble
  have hK := finalBoundConst_le
  have hlogBnn : (0:ℝ) ≤ Real.log (84 * t) := by rw [hlogB]; linarith
  have hstep : ‖deriv f z0 / f z0‖ ≤ 3991 * Real.log (84 * t)
      + (2 / (σ₁ - 1/2)) * (29 * Real.log t + 129) := by
    have htri : ‖deriv f z0 / f z0‖
        ≤ ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
          + ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖ := by
      simpa using norm_add_le (deriv f z0 / f z0
        - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
        (∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
    have hA : ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ 3991 * Real.log (84 * t) := by
      refine le_trans hFB ?_
      exact mul_le_mul_of_nonneg_right hK hlogBnn
    have hB2 : ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ (2 / (σ₁ - 1/2)) * (29 * Real.log t + 129) := by
      refine le_trans hsum ?_
      exact mul_le_mul_of_nonneg_left hcount (by positivity)
    linarith
  rw [hderiv] at hstep
  rw [norm_mul] at hstep
  simp only [Complex.norm_ofNat] at hstep
  have hfinal : (2 / (σ₁ - 1/2)) * (29 * Real.log t + 129)
      = 2 * ((29 * Real.log t + 129) / (σ₁ - 1/2)) := by field_simp
  rw [hfinal] at hstep
  linarith

/-- **Corollary A — the literal `log²|t|` shape, at a `t`-tied abscissa.**
`σ₁ = 1/2 + 1/log t` gives `‖ζ'/ζ‖ ≤ 21600 (log t)²`.  The abscissa moves
with `t`, so this is not a vertical line. -/
theorem logDerivZeta_sq_at_t (hRH : RiemannHypothesis) {t : ℝ} (ht : 2 ≤ t) :
    ‖deriv ζ (((1/2 + 1/Real.log t : ℝ)) + I * (t : ℂ))
        / ζ (((1/2 + 1/Real.log t : ℝ)) + I * (t : ℂ))‖
      ≤ 21600 * (Real.log t) ^ 2 := by
  have hL : (0.6931:ℝ) ≤ Real.log t := by
    have h2 := Real.log_two_gt_d9
    have := Real.log_le_log (by norm_num : (0:ℝ) < 2) ht
    linarith
  have hLpos : (0:ℝ) < Real.log t := by linarith
  have hlo : (1:ℝ)/2 < 1/2 + 1/Real.log t := by
    have : (0:ℝ) < 1/Real.log t := by positivity
    linarith
  have hhi : (1:ℝ)/2 + 1/Real.log t ≤ 2 := by
    have : 1/Real.log t ≤ 3/2 := by
      rw [div_le_iff₀ hLpos]; linarith
    linarith
  have hmain := logDerivZeta_crude hRH ht hlo hhi
  refine le_trans hmain ?_
  have hδ : (1/2 + 1/Real.log t) - 1/2 = 1/Real.log t := by ring
  have hdd : (29 * Real.log t + 129) / (1 / Real.log t)
      = (29 * Real.log t + 129) * Real.log t := by
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
  nlinarith [hL, hLpos, sq_nonneg (Real.log t)]

/-- **Corollary B — the vertical-line shape the ψ-side actually consumes.**
`σ₁ = 1/2 + 1/log X` fixed, `2 ≤ t ≤ X`, `log X ≥ 1`:
`‖ζ'/ζ‖ ≤ 11100 (log X)²`, uniformly in `t` on the truncation range. -/
theorem logDerivZeta_sq_at_X (hRH : RiemannHypothesis) {t X : ℝ} (ht : 2 ≤ t)
    (hLX : 1 ≤ Real.log X) (htX : Real.log t ≤ Real.log X) :
    ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))
        / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖
      ≤ 11100 * (Real.log X) ^ 2 := by
  have hLXpos : (0:ℝ) < Real.log X := by linarith
  have hLt : (0.6931:ℝ) ≤ Real.log t := by
    have h2 := Real.log_two_gt_d9
    have := Real.log_le_log (by norm_num : (0:ℝ) < 2) ht
    linarith
  have hlo : (1:ℝ)/2 < 1/2 + 1/Real.log X := by
    have : (0:ℝ) < 1/Real.log X := by positivity
    linarith
  have hhi : (1:ℝ)/2 + 1/Real.log X ≤ 2 := by
    have : 1/Real.log X ≤ 1 := by rw [div_le_one hLXpos]; linarith
    linarith
  have hmain := logDerivZeta_crude hRH ht hlo hhi
  refine le_trans hmain ?_
  have hδ : (1/2 + 1/Real.log X) - 1/2 = 1/Real.log X := by ring
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

end Main

end

end Slice3


/-
Slice 4 — the compact patch.  `‖ζ'/ζ(σ₁+it)‖` for `|t| ≤ 2`, under RH.
Slice 3 covers `|t| ≥ 2`; there the pole at `s = 1` sits outside the Jensen
disk.  For `|t| ≤ 2` it does not, so the local model carries the pole
explicitly through the entire function `zetaE s = (s-1)ζ(s)`.
Scratch only.
-/

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

/-- `log 1300 ≤ 7.28`, from `1300² ≤ 2^21`. -/
theorem log_1300_le : Real.log 1300 ≤ 7.28 := by
  have h2 : Real.log ((1300:ℝ) ^ (2:ℕ)) ≤ Real.log ((2:ℝ) ^ (21:ℕ)) :=
    Real.log_le_log (by positivity) (by norm_num)
  rw [Real.log_pow, Real.log_pow] at h2
  have h3 := Real.log_two_lt_d9
  push_cast at h2
  linarith

/-- LEVER 2 — the FinalBound constant at `r' = 3/4, r = 181/200, R' = 29/32, R = 15/16` — the
same radii as slice 3. -/
theorem finalBoundConst_le :
    16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3
      + 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32))) ≤ 3991 := by
  have hlog : (1:ℝ)/30 ≤ Real.log (30/29) := by
    have hh1 : Real.log (29/30) ≤ 29/30 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (30:ℝ)/29 = ((29:ℝ)/30)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hden : ((15/16:ℝ) ^ 2 / (29/32) - 29/32) = 59/928 := by norm_num
  have hrat : ((15/16:ℝ)/(29/32)) = 30/29 := by norm_num
  have hpos : (0:ℝ) < 59/27840 := by norm_num
  have hle : (59:ℝ)/27840 ≤ (59/928) * Real.log ((15/16)/(29/32)) := by
    rw [hrat]; nlinarith [hlog]
  have h2 : 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32)))
      ≤ 27840/59 := by
    rw [hden]
    calc 1 / ((59/928:ℝ) * Real.log ((15/16)/(29/32)))
        ≤ 1 / ((59:ℝ)/27840) := one_div_le_one_div_of_le hpos hle
      _ = 27840/59 := by norm_num
  have h1 : 16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3 = 104835200/29791 := by norm_num
  have h3 : (27840:ℝ)/59 ≤ 472 := by
    rw [div_le_iff₀ (by norm_num : (0:ℝ) < 59)]; norm_num
  have h4 : (104835200:ℝ)/29791 ≤ 3519.1 := by
    rw [div_le_iff₀ (by norm_num : (0:ℝ) < 29791)]; norm_num
  rw [h1]; linarith

/-- **Slice 4 — the compact patch.**  Under RH, for `|t| ≤ 2` and
`1/2 < σ₁ ≤ 3/4`,
`‖ζ'/ζ (σ₁ + it)‖ ≤ 14535 + 212/(σ₁ - 1/2)`. -/
theorem logDerivZeta_compact (hRH : RiemannHypothesis) {t σ₁ : ℝ} (ht : |t| ≤ 2)
    (hlo : 1/2 < σ₁) (hhi : σ₁ ≤ 3/4) :
    ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖
      ≤ 14535 + 212 / (σ₁ - 1/2) := by
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
  -- the zeros: either a zeta zero (re = -3/4 under RH) or the pole point (re = -1/2)
  have hzeroRe : ∀ ρ ∈ S, ρ.re = -(3/4) ∨ ρ.re = -(1/2) := by
    intro ρ hρ
    rw [hS, Set.Finite.mem_toFinset] at hρ
    obtain ⟨hρn, hρ0⟩ := hρ
    have hw0 : zetaE (2 * ρ + c) = 0 := by
      have hval : f ρ = zetaE (2 * ρ + c) / zetaE c := rfl
      rw [hval, div_eq_zero_iff] at hρ0
      exact hρ0.resolve_right hzEc_ne
    have hρre : |ρ.re| ≤ 181/200 := le_trans (Complex.abs_re_le_norm ρ) hρn
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
  have hK := finalBoundConst_le
  have hstep : ‖deriv f z0 / f z0‖ ≤ 29060 + (2 / (σ₁ - 1/2)) * 212 := by
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
        ≤ (2 / (σ₁ - 1/2)) * 212 := by
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
  have hfinal : (2 / (σ₁ - 1/2)) * 212 = 424 / (σ₁ - 1/2) := by ring
  rw [hfinal] at hstep
  have h115 : (212:ℝ) / (σ₁ - 1/2) = (424 / (σ₁ - 1/2))/2 := by ring
  rw [h115]
  linarith

end

end Slice4


/-
Slice 4b — the uniform vertical-line bound, slices 3 and 4 welded, both signs
of `t`.  And slice 8 — PsiToPi at `k = 3`.
Scratch only.
-/

open Complex Set

namespace Slice4b

noncomputable section

local notation "ζ" => riemannZeta

/-! Slice 3 and slice 4, restated locally (proved in `slice3.lean` / `slice4.lean`). -/


/-- Reflection: the log-derivative's norm is even in `t`. -/
theorem logDerivZeta_norm_neg (σ t : ℝ) :
    ‖deriv ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ)) / ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ))‖
      = ‖deriv ζ ((σ : ℂ) + I * (t : ℂ)) / ζ ((σ : ℂ) + I * (t : ℂ))‖ := by
  have hconj : (starRingEnd ℂ) ((σ : ℂ) + I * (t : ℂ)) = (σ : ℂ) + I * ((-t : ℝ) : ℂ) := by
    simp [Complex.ext_iff]
  have h := logDerivZeta_conj ((σ : ℂ) + I * (t : ℂ))
  simp only [Pi.div_apply, hconj] at h
  rw [h, RCLike.norm_conj]

/-- **Slice 4b — the vertical line, uniform in `t`.**  Under RH, on
`σ₁ = 1/2 + 1/log X` with `log X ≥ 4` and `|t| ≤ X`:
`‖ζ'/ζ‖ ≤ 11100 (log X)²`. -/
theorem logDerivZeta_line (hRH : RiemannHypothesis) {X t : ℝ}
    (hLX : 4 ≤ Real.log X) (htX : |t| ≤ X) :
    ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))
        / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖
      ≤ 11100 * (Real.log X) ^ 2 := by
  set L : ℝ := Real.log X with hL
  have hLpos : (0:ℝ) < L := by linarith
  have hσlo : (1:ℝ)/2 < 1/2 + 1/L := by have : (0:ℝ) < 1/L := by positivity
                                        linarith
  have hσhi : (1:ℝ)/2 + 1/L ≤ 3/4 := by
    have : 1/L ≤ 1/4 := by rw [div_le_div_iff₀ hLpos (by norm_num)]; linarith
    linarith
  have hX1 : (1:ℝ) < X := by
    by_contra h
    push_neg at h
    have : Real.log X ≤ 0 := Real.log_nonpos (by linarith [abs_nonneg t, htX]) h
    linarith
  -- the three regimes
  rcases le_or_gt |t| 2 with hsmall | hbig
  · have h4 := Slice4.logDerivZeta_compact hRH hsmall hσlo hσhi
    refine le_trans h4 ?_
    have hd : (1/2 + 1/L) - 1/2 = 1/L := by ring
    rw [hd]
    have hdd : (212:ℝ) / (1 / L) = 212 * L := by field_simp
    rw [hdd]
    nlinarith [hLpos, sq_nonneg L]
  · have htabs : (2:ℝ) ≤ |t| := le_of_lt hbig
    have hlogabs : Real.log |t| ≤ L := Real.log_le_log (by linarith) (by
      calc |t| ≤ X := htX
        _ = X := rfl)
    have hmain := Slice3.logDerivZeta_sq_at_X hRH (t := |t|) (X := X) htabs (by linarith) hlogabs
    rcases abs_cases t with ⟨heq, _⟩ | ⟨heq, _⟩
    · rw [heq] at hmain; exact hmain
    · rw [heq] at hmain
      rw [← logDerivZeta_norm_neg (1/2 + 1/L) t] at *
      have : ((-t : ℝ) : ℂ) = ((-t : ℝ) : ℂ) := rfl
      exact hmain

end

end Slice4b

namespace Slice8

/-- **Slice 8 — PsiToPi at `k = 3`.**  A ψ-side weak bound at exponent `3`
delivers `StmtSchoenfeldWeak (3C+13) 2` — the shape entry 231's census
gate is stated against. -/
theorem schoenfeldWeak_of_psiWeak_three {C x₀ : ℝ} (hx₀ : 2 ≤ x₀) (hC : 0 ≤ C)
    (h : Stage3.StmtPsiWeak C 3 x₀) :
    Stage3.StmtSchoenfeldWeak (3 * C + 13) 2 (max (x₀ ^ 2) 9)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li := by
  have := Stage3.schoenfeldWeak_of_psiWeak (k := 3) (by norm_num) hx₀ hC h
  simpa using this

end Slice8


#print axioms Slice3.logDerivZeta_crude
#print axioms Slice3.logDerivZeta_sq_at_X
#print axioms Slice4.zetaE_disk_upper
#print axioms Slice4.logDerivZeta_compact
#print axioms Slice4b.logDerivZeta_norm_neg
#print axioms Slice4b.logDerivZeta_line
#print axioms Slice8.schoenfeldWeak_of_psiWeak_three


open Set MeasureTheory ArithmeticFunction


namespace Slice5

noncomputable section

local notation "ζ" => riemannZeta

/-! ### The p-series input -/

/-- Integral test: for `b > 0`, `∑_{n ≥ 2} n^{-1-b} ≤ 1/b`. -/
theorem pseries_tail_le {b : ℝ} (hb : 0 < b) :
    ∑' (n : ℕ), ((n + 1 + 1 : ℕ) : ℝ) ^ (-1 - b) ≤ 1 / b := by
  have hlt : (-1 - b) < -1 := by linarith
  have hanti : AntitoneOn (fun x : ℝ => x ^ (-1 - b)) (Ici ((1:ℕ) : ℝ)) := by
    refine (Real.antitoneOn_rpow_Ioi_of_exponent_nonpos (by linarith)).mono ?_
    intro x hx
    simp only [Nat.cast_one, mem_Ici] at hx
    exact mem_Ioi.mpr (by linarith)
  have hint : IntegrableOn (fun x : ℝ => x ^ (-1 - b)) (Ioi ((1:ℕ) : ℝ)) := by
    simpa using integrableOn_Ioi_rpow_of_lt hlt (by norm_num : (0:ℝ) < 1)
  have hnn : ∀ t ∈ Ioi ((1:ℕ) : ℝ), (0:ℝ) ≤ t ^ (-1 - b) := by
    intro t ht
    simp only [Nat.cast_one, mem_Ioi] at ht
    positivity
  have key := AntitoneOn.tsum_comp_add_le_integral (f := fun x : ℝ => x ^ (-1 - b)) 1 hanti hint hnn
  have hI : ∫ (x : ℝ) in Ioi ((1:ℕ) : ℝ), x ^ (-1 - b) = 1 / b := by
    rw [Nat.cast_one, integral_Ioi_rpow_of_lt hlt (by norm_num : (0:ℝ) < 1)]
    rw [Real.one_rpow, show (-1 - b + 1) = -b by ring]
    field_simp
  rw [hI] at key
  exact key

/-- For `b > 0`, `∑_{n ≥ 0} n^{-1-b} ≤ 1 + 1/b` (the `n = 0` term is `0`). -/
theorem pseries_le {b : ℝ} (hb : 0 < b) :
    ∑' (n : ℕ), ((n : ℝ)) ^ (-1 - b) ≤ 1 + 1 / b := by
  have hlt : (-1 - b) < -1 := by linarith
  have hsum : Summable (fun n : ℕ => ((n : ℝ)) ^ (-1 - b)) := Real.summable_nat_rpow.mpr hlt
  have hsplit := (hsum.sum_add_tsum_nat_add 2)
  have hhead : ∑ i ∈ Finset.range 2, ((i : ℝ)) ^ (-1 - b) = 1 := by
    rw [Finset.sum_range_succ, Finset.sum_range_one]
    rw [Nat.cast_zero, Nat.cast_one, Real.zero_rpow (by linarith), Real.one_rpow]
    ring
  have htail : ∑' (n : ℕ), (((n + 2 : ℕ)) : ℝ) ^ (-1 - b) ≤ 1 / b := pseries_tail_le hb
  rw [hhead] at hsplit
  linarith [hsplit, htail]

/-! ### The Dirichlet-series bound -/

/-- `Λ n / n^σ ≤ (1/b) · n^{-1-b}` when `σ = 1 + 2b`, `b > 0`. -/
theorem vonMangoldt_term_le {b : ℝ} (hb : 0 < b) (n : ℕ) :
    ‖LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) ((1 + 2 * b : ℝ) : ℂ) n‖
      ≤ (1 / b) * ((n : ℝ)) ^ (-1 - b) := by
  rcases eq_or_ne n 0 with rfl | hn
  · simp [Real.zero_rpow (show (-1 - b) ≠ 0 by linarith)]
  · have hnpos : (0:ℝ) < (n : ℝ) := by
      exact_mod_cast Nat.pos_of_ne_zero hn
    have hre : (((1 + 2 * b : ℝ) : ℂ)).re = 1 + 2 * b := by simp
    have hnorm : ‖((vonMangoldt n : ℝ) : ℂ)‖ = vonMangoldt n := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg vonMangoldt_nonneg]
    -- `log n ≤ n^b / b`
    have hlog : Real.log (n : ℝ) ≤ (n : ℝ) ^ b / b := by
      have h1 : Real.log ((n : ℝ) ^ b) ≤ (n : ℝ) ^ b - 1 :=
        Real.log_le_sub_one_of_pos (Real.rpow_pos_of_pos hnpos b)
      rw [Real.log_rpow hnpos] at h1
      rw [le_div_iff₀ hb]
      nlinarith [h1]
    have hΛ : vonMangoldt n ≤ (n : ℝ) ^ b / b := le_trans vonMangoldt_le_log hlog
    rw [LSeries.norm_term_eq, if_neg hn, hnorm, hre]
    have hden : (0:ℝ) < (n : ℝ) ^ (1 + 2 * b) := Real.rpow_pos_of_pos hnpos _
    rw [div_le_iff₀ hden]
    have hpow : ((n:ℝ)) ^ (-1 - b) * (n : ℝ) ^ (1 + 2 * b) = (n : ℝ) ^ b := by
      rw [← Real.rpow_add hnpos]
      ring_nf
    calc vonMangoldt n ≤ (n : ℝ) ^ b / b := hΛ
      _ = (1 / b) * ((n : ℝ) ^ (-1 - b) * (n : ℝ) ^ (1 + 2 * b)) := by rw [hpow]; ring
      _ = 1 / b * (n : ℝ) ^ (-1 - b) * (n : ℝ) ^ (1 + 2 * b) := by ring

/-- **Slice 5.**  For `Re s > 1`, elementary and RH-free:
`‖ζ'/ζ(s)‖ ≤ 2/(Re s - 1) + 4/(Re s - 1)²`. -/
theorem norm_logDerivZeta_of_one_lt_re {s : ℂ} (hs : 1 < s.re) :
    ‖deriv ζ s / ζ s‖ ≤ 2 / (s.re - 1) + 4 / (s.re - 1) ^ 2 := by
  set b : ℝ := (s.re - 1) / 2 with hbdef
  have hb : 0 < b := by rw [hbdef]; linarith
  have hsre : s.re = 1 + 2 * b := by rw [hbdef]; ring
  -- the identity
  have hid := ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs
  have hnormeq : ‖deriv ζ s / ζ s‖
      = ‖LSeries (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s‖ := by
    rw [hid, neg_div, norm_neg]
  -- absolute summability
  have hsummable : LSeriesSummable (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s :=
    ArithmeticFunction.LSeriesSummable_vonMangoldt hs
  have hnsum : Summable (fun n : ℕ =>
      ‖LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s n‖) :=
    summable_norm_iff.mpr hsummable
  -- majorant
  have hmajsum : Summable (fun n : ℕ => (1 / b) * ((n : ℝ)) ^ (-1 - b)) :=
    (Real.summable_nat_rpow.mpr (by linarith)).mul_left _
  have hterm : ∀ n : ℕ,
      ‖LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s n‖
        ≤ (1 / b) * ((n : ℝ)) ^ (-1 - b) := by
    intro n
    have := vonMangoldt_term_le hb n
    rw [LSeries.norm_term_eq] at this ⊢
    simpa [hsre] using this
  calc ‖deriv ζ s / ζ s‖
      = ‖∑' n : ℕ, LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s n‖ := hnormeq
    _ ≤ ∑' n : ℕ, ‖LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s n‖ :=
        norm_tsum_le_tsum_norm hnsum
    _ ≤ ∑' n : ℕ, (1 / b) * ((n : ℝ)) ^ (-1 - b) := hnsum.tsum_le_tsum hterm hmajsum
    _ = (1 / b) * ∑' n : ℕ, ((n : ℝ)) ^ (-1 - b) := tsum_mul_left
    _ ≤ (1 / b) * (1 + 1 / b) := by
        exact mul_le_mul_of_nonneg_left (pseries_le hb) (by positivity)
    _ = 2 / (s.re - 1) + 4 / (s.re - 1) ^ 2 := by
        have hd : s.re - 1 ≠ 0 := by linarith
        rw [hbdef]
        field_simp
        ring

/-- **Corollary — the shape the `I₁`/`I₉` integrals consume.**
At the standard abscissa `σ₀ = 1 + 1/L` with `L ≥ 1`, uniformly in `t`:
`‖ζ'/ζ(σ₀ + it)‖ ≤ 2 L + 4 L²`. -/
theorem norm_logDerivZeta_sigma0 {L t : ℝ} (hL : 1 ≤ L) :
    ‖deriv ζ (((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ)) / ζ (((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ))‖
      ≤ 2 * L + 4 * L ^ 2 := by
  have hLpos : (0:ℝ) < L := by linarith
  have hre : ((((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ))).re = 1 + 1 / L := by simp
  have hs : 1 < ((((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ))).re := by
    rw [hre]
    have : (0:ℝ) < 1 / L := by positivity
    linarith
  have h := norm_logDerivZeta_of_one_lt_re hs
  rw [hre] at h
  refine le_trans h (le_of_eq ?_)
  have h1 : (1 + 1 / L - 1) = 1 / L := by ring
  rw [h1]
  field_simp

end

end Slice5

#check @Slice5.norm_logDerivZeta_of_one_lt_re

#print axioms Slice5.norm_logDerivZeta_of_one_lt_re
#print axioms Slice5.norm_logDerivZeta_sigma0
