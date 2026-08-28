/-
Slice 3 — the falsifier.  Crude explicit bound on ζ'/ζ just right of the
critical line, under RH, via Stage3.jensenF + PNT+ FinalBound.
Scratch only.
-/
import Stage3.JensenCount
import Stage3.Assembly

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

/-- `log (25/24) ≥ 1/25`. -/
theorem log_2524_ge : (1:ℝ)/25 ≤ Real.log (25/24) := by
  have h1 : Real.log (24/25) ≤ 24/25 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
  rw [show (25:ℝ)/24 = ((24:ℝ)/25)⁻¹ by norm_num, Real.log_inv]
  linarith

/-- The FinalBound constant at `r' = 3/4, r = 7/8, R' = 9/10, R = 15/16`. -/
theorem finalBoundConst_le :
    16 * ((7:ℝ)/8) ^ 2 / ((7/8) - (3/4)) ^ 3
      + 1 / (((15/16:ℝ) ^ 2 / (9/10) - 9/10) * Real.log ((15/16)/(9/10))) ≤ 6600 := by
  have hden : ((15/16:ℝ) ^ 2 / (9/10) - 9/10) = 49/640 := by norm_num
  have hrat : ((15/16:ℝ)/(9/10)) = 25/24 := by norm_num
  have hlog := log_2524_ge
  have hpos : (0:ℝ) < 49/16000 := by norm_num
  have hle : (49:ℝ)/16000 ≤ (49/640) * Real.log ((15/16)/(9/10)) := by
    rw [hrat]; nlinarith [hlog]
  have h2 : 1 / (((15/16:ℝ) ^ 2 / (9/10) - 9/10) * Real.log ((15/16)/(9/10)))
      ≤ 16000/49 := by
    rw [hden]
    calc 1 / ((49/640:ℝ) * Real.log ((15/16)/(9/10)))
        ≤ 1 / ((49:ℝ)/16000) := by
          exact one_div_le_one_div_of_le hpos hle
      _ = 16000/49 := by norm_num
  have h1 : 16 * ((7:ℝ)/8) ^ 2 / ((7/8) - (3/4)) ^ 3 = 6272 := by norm_num
  rw [h1]; linarith

section Main

variable (hRH : RiemannHypothesis)

/-- **Slice 3.**  Under RH, for `t ≥ 2` and `1/2 < σ₁ ≤ 3/2`,
`‖ζ'/ζ (σ₁ + it)‖ ≤ 3300 log(84 t) + (15 log t + 73)/(σ₁ - 1/2)`. -/
theorem logDerivZeta_crude (hRH : RiemannHypothesis) {t σ₁ : ℝ} (ht : 2 ≤ t)
    (hlo : 1/2 < σ₁) (hhi : σ₁ ≤ 2) :
    ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖
      ≤ 3300 * Real.log (84 * t) + (15 * Real.log t + 73) / (σ₁ - 1/2) := by
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
  have hr1 : (7:ℝ)/8 < 1 := by norm_num
  have hfin : (SetOfZeros 1 f).Finite := Stage3.jensenF_zeros_finite ht
  have hana : AnalyticOnNhd ℂ f (Metric.closedBall (0:ℂ) 1) := Stage3.jensenF_analytic ht
  have hf0 : f 0 = 1 := Stage3.jensenF_zero_eq_one t
  have hbd : ∀ z : ℂ, ‖z‖ ≤ 15/16 → ‖f z‖ ≤ 84 * t := fun z hz => Stage3.jensenF_bound ht hz
  have hBgt : (1:ℝ) < 84 * t := by linarith
  have hmem : z0 ∈ Metric.closedBall (0:ℂ) (3/4) \ SetOfZeros (9/10) f := by
    constructor
    · simp only [Metric.mem_closedBall, dist_zero_right, hz0norm]
      linarith
    · intro hmem2
      exact hfz0ne hmem2.2
  have hFB := FinalBound (B := 84 * t) (r' := 3/4) (r := 7/8) (R' := 9/10) (R := 15/16)
    (f := f) (z := z0) hBgt (by norm_num) (by norm_num) hr1 (by norm_num) (by norm_num)
    (by norm_num) hana hf0 hfin hbd hmem
  have hZB := ZerosBound (B := 84 * t) (r := 7/8) (R := 15/16) (f := f)
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
    have hwc : ‖(2 * ρ + c) - c‖ ≤ 7/4 := by
      rw [show (2 * ρ + c) - c = 2 * ρ by ring, norm_mul]
      simp only [Complex.norm_ofNat]
      linarith
    have hwne1 : (2 * ρ + c) ≠ 1 := Stage3.pole_away_centre ht (by linarith [hwc] : ‖(2*ρ+c) - c‖ < 11/5)
    have hwre : (2 * ρ + c).re = 2 * ρ.re + 2 := by simp [hc]
    have hρre : |ρ.re| ≤ 7/8 := le_trans (Complex.abs_re_le_norm ρ) hρn
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
  have hlog1514 : (1 : ℝ) / 15 ≤ Real.log (15 / 14) := by
    have h1 : Real.log (14 / 15) ≤ 14 / 15 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (15 : ℝ) / 14 = ((14 : ℝ) / 15)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hlog1514pos : (0 : ℝ) < Real.log (15 / 14) := by linarith
  have hlog84 : Real.log 84 ≤ 4.86 := by
    have h128 : Real.log 84 ≤ Real.log 128 := Real.log_le_log (by norm_num) (by norm_num)
    have h2 : Real.log 128 = 7 * Real.log 2 := by
      rw [show (128 : ℝ) = 2 ^ (7 : ℕ) by norm_num, Real.log_pow]; norm_num
    have h3 := Real.log_two_lt_d9
    linarith
  have hlog84nn : (0 : ℝ) ≤ Real.log 84 := Real.log_nonneg (by norm_num)
  have hlogB : Real.log (84 * t) = Real.log 84 + Real.log t :=
    Real.log_mul (by norm_num) (by linarith)
  have hcount : ((∑ ρ ∈ S, analyticOrderNatAt f ρ : ℕ) : ℝ) ≤ 15 * Real.log t + 73 := by
    have hinv : 1 / Real.log (15 / 14) ≤ 15 := by
      rw [div_le_iff₀ hlog1514pos]; linarith
    rw [hS]
    calc ((∑ ρ ∈ (finiteSetOfZeros_mono hr1 hfin).toFinset, analyticOrderNatAt f ρ : ℕ) : ℝ)
        ≤ 1 / Real.log ((15/16) / (7/8)) * Real.log (84 * t) := hZB
      _ = 1 / Real.log (15/14) * Real.log (84 * t) := by norm_num
      _ ≤ 15 * Real.log (84 * t) := by
          refine mul_le_mul_of_nonneg_right hinv ?_
          rw [hlogB]; linarith
      _ = 15 * (Real.log 84 + Real.log t) := by rw [hlogB]
      _ ≤ 15 * Real.log t + 73 := by linarith
  -- assemble
  have hK := finalBoundConst_le
  have hlogBnn : (0:ℝ) ≤ Real.log (84 * t) := by rw [hlogB]; linarith
  have hstep : ‖deriv f z0 / f z0‖ ≤ 6600 * Real.log (84 * t)
      + (2 / (σ₁ - 1/2)) * (15 * Real.log t + 73) := by
    have htri : ‖deriv f z0 / f z0‖
        ≤ ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
          + ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖ := by
      simpa using norm_add_le (deriv f z0 / f z0
        - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
        (∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
    have hA : ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ 6600 * Real.log (84 * t) := by
      refine le_trans hFB ?_
      exact mul_le_mul_of_nonneg_right hK hlogBnn
    have hB2 : ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ (2 / (σ₁ - 1/2)) * (15 * Real.log t + 73) := by
      refine le_trans hsum ?_
      exact mul_le_mul_of_nonneg_left hcount (by positivity)
    linarith
  rw [hderiv] at hstep
  rw [norm_mul] at hstep
  simp only [Complex.norm_ofNat] at hstep
  have hfinal : (2 / (σ₁ - 1/2)) * (15 * Real.log t + 73)
      = 2 * ((15 * Real.log t + 73) / (σ₁ - 1/2)) := by field_simp
  rw [hfinal] at hstep
  linarith

/-- **Corollary A — the literal `log²|t|` shape, at a `t`-tied abscissa.**
`σ₁ = 1/2 + 1/log t` gives `‖ζ'/ζ‖ ≤ 40000 (log t)²`.  The abscissa moves
with `t`, so this is not a vertical line. -/
theorem logDerivZeta_sq_at_t (hRH : RiemannHypothesis) {t : ℝ} (ht : 2 ≤ t) :
    ‖deriv ζ (((1/2 + 1/Real.log t : ℝ)) + I * (t : ℂ))
        / ζ (((1/2 + 1/Real.log t : ℝ)) + I * (t : ℂ))‖
      ≤ 40000 * (Real.log t) ^ 2 := by
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
  have hdd : (15 * Real.log t + 73) / (1 / Real.log t)
      = (15 * Real.log t + 73) * Real.log t := by
    field_simp
  rw [hδ, hdd]
  have hlog84 : Real.log 84 ≤ 4.86 := by
    have h128 : Real.log 84 ≤ Real.log 128 := Real.log_le_log (by norm_num) (by norm_num)
    have h2 : Real.log 128 = 7 * Real.log 2 := by
      rw [show (128 : ℝ) = 2 ^ (7 : ℕ) by norm_num, Real.log_pow]; norm_num
    have h3 := Real.log_two_lt_d9
    linarith
  have hlogB : Real.log (84 * t) = Real.log 84 + Real.log t :=
    Real.log_mul (by norm_num) (by linarith)
  rw [hlogB]
  nlinarith [hL, hLpos, sq_nonneg (Real.log t)]

/-- **Corollary B — the vertical-line shape the ψ-side actually consumes.**
`σ₁ = 1/2 + 1/log X` fixed, `2 ≤ t ≤ X`, `log X ≥ 1`:
`‖ζ'/ζ‖ ≤ 20000 (log X)²`, uniformly in `t` on the truncation range. -/
theorem logDerivZeta_sq_at_X (hRH : RiemannHypothesis) {t X : ℝ} (ht : 2 ≤ t)
    (hLX : 1 ≤ Real.log X) (htX : Real.log t ≤ Real.log X) :
    ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))
        / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖
      ≤ 20000 * (Real.log X) ^ 2 := by
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
  have hdd : (15 * Real.log t + 73) / (1 / Real.log X)
      = (15 * Real.log t + 73) * Real.log X := by
    field_simp
  rw [hδ, hdd]
  have hlog84 : Real.log 84 ≤ 4.86 := by
    have h128 : Real.log 84 ≤ Real.log 128 := Real.log_le_log (by norm_num) (by norm_num)
    have h2 : Real.log 128 = 7 * Real.log 2 := by
      rw [show (128 : ℝ) = 2 ^ (7 : ℕ) by norm_num, Real.log_pow]; norm_num
    have h3 := Real.log_two_lt_d9
    linarith
  have hlogB : Real.log (84 * t) = Real.log 84 + Real.log t :=
    Real.log_mul (by norm_num) (by linarith)
  rw [hlogB]
  nlinarith [hLX, hLXpos, htX, hLt, sq_nonneg (Real.log X)]

end Main

end

end Slice3

#check @Slice3.logDerivZeta_crude
#check @Slice3.logDerivZeta_sq_at_t
#check @Slice3.logDerivZeta_sq_at_X
#print axioms Slice3.logDerivZeta_crude
#print axioms Slice3.logDerivZeta_sq_at_t
#print axioms Slice3.logDerivZeta_sq_at_X
