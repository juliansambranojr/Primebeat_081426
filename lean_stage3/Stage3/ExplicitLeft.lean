/-
ExplicitLeft — block F1 of `lean_stage3/design/leftedge.md`. 2026-11-23.

The truncated explicit formula at every height `T ≥ 2`, with no cap `T ≤ x²`.
`Glue.explicit_formula_split_num` used the cap once, to bound the left edge
`VIntegral (Gf x) (-1/4) (-T') T'` by `log²x`. Here the left edge is kept as a
term, and bounded separately by `log²T'`. The bound grows with the height:
an absolute value on the line `Re s = −1/4` loses `log²T'` (the lost factor of
the design note). Block F2 removes it.

  Aleft   8·Dln

  explicit_formula_left   16 ≤ x, 2 ≤ T ⊢ the formula with the left edge's norm
                            as a term, at some T′ ∈ [T, T+1]
  edge_left_any           16 ≤ x, 2 ≤ T′ ⊢ the left edge ≤ Aleft·log²T′·x^(−1/4)
  explicit_formula_any    the two joined: error
                            c1n·x·log²(xT)/T + c3n·log x + Aleft·log²(T+1)·x^(−1/4)

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.GlueNum

namespace ExplicitLeft

open Complex Topology Set

/-- The left-edge constant at every height: eight times `Glue.Dln`. -/
noncomputable def Aleft : ℝ := 8 * Glue.Dln

/-- The left-edge constant `Aleft` is positive. -/
theorem Aleft_pos : 0 < Aleft := by
  have h := Glue.Dln_pos
  unfold Aleft
  positivity

set_option maxHeartbeats 1600000 in
/-- **The explicit formula with the left edge kept.** For `16 ≤ x` and `2 ≤ T`
there is a height `T′` in `[T, T+1]` with
`‖ψ(x) − x + Σ_{|γ|<T} m·x^ρ/ρ‖ ≤ c1n·x·log²(xT)/T + c3n·log x + ‖left edge at T′‖`.
`Glue.explicit_formula_split_num`'s proof with the left edge left unbounded; no
cap on `T`. -/
theorem explicit_formula_left {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ∃ T' : ℝ, T ≤ T' ∧ T' ≤ T + 1 ∧
      ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
        ≤ Glue.c1n * x * Real.log (x*T)^2 / T + Glue.c3n * Real.log x
          + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
  classical
  obtain ⟨Ch, hChdef⟩ : ∃ Ch : ℝ, Ch = Glue.Chn := ⟨_, rfl⟩
  have hCh0 : 0 < Ch := by rw [hChdef]; exact Glue.Chn_pos
  have hCh := Glue.edge_horizontal_bound_num
  rw [← hChdef] at hCh
  obtain ⟨Cs, hCsdef⟩ : ∃ Cs : ℝ, Cs = Glue.Csn := ⟨_, rfl⟩
  have hCs0 : 0 < Cs := by rw [hCsdef]; exact Glue.Csn_pos
  have hCs := Glue.zeroPartialSum_swap_num
  rw [← hCsdef] at hCs
  set K0 : ℝ := ‖deriv riemannZeta 0 / riemannZeta 0‖ with hK0d
  have hK00 : (0:ℝ) ≤ K0 := norm_nonneg _
  have hC1 : Glue.c1n = 2400 + 2*Ch + Cs := by
    unfold Glue.c1n
    rw [hChdef, hCsdef]
  have hC3 : Glue.c3n = 13 + K0/2 := by
    unfold Glue.c3n
    rw [hK0d]
  rw [hC1, hC3]
  have hx0 : (0:ℝ) < x := by linarith
  have hlx2 : (2:ℝ) < Real.log x := by
    have h1 : Real.log 16 ≤ Real.log x := Real.log_le_log (by norm_num) hx
    rw [show (16:ℝ) = 2^4 by norm_num, Real.log_pow] at h1
    have h2 : (0.6931471803:ℝ) < Real.log 2 := Real.log_two_gt_d9
    push_cast at h1
    nlinarith
  obtain ⟨T', hT'mem, hgood⟩ := ContourShift.goodT_exists hT
  obtain ⟨hT'lo, hT'hi⟩ := hT'mem
  refine ⟨T', hT'lo, hT'hi, ?_⟩
  have hT'2 : (2:ℝ) ≤ T' := le_trans hT hT'lo
  have hT'1 : (1:ℝ) ≤ T' := by linarith
  have hT0 : (0:ℝ) < T := by linarith
  have hT'0 : (0:ℝ) < T' := by linarith
  have hS1 := PerronKernel.explicit_formula_perron (x := x) (T := T') hx hT'1
  have hS4 := ContourShift.residue_identity hx hT ⟨hT'lo, hT'hi⟩ hgood
  set P : ℂ := (2 * (Real.pi:ℂ) * Complex.I)⁻¹
      * ∫ t in (-T')..T',
          (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
            / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t))
          * ((x:ℝ):ℂ) ^ (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
          / (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) * Complex.I with hPd
  set zc : ℂ := ((-1/4 : ℝ):ℂ) - Complex.I * (T':ℂ) with hzcd
  set wc : ℂ := ((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * (T':ℂ) with hwcd
  have hS4g : RectangleIntegral' (Glue.Gf x) zc wc
      = (x:ℂ) - deriv riemannZeta 0 / riemannZeta 0
        - Stage3.zeroPartialSum x T' := hS4
  have hzre : zc.re = -1/4 := by rw [hzcd]; simp
  have hzim : zc.im = -T' := by rw [hzcd]; simp
  have hwre : wc.re = 1 + 1/Real.log x := by rw [hwcd]; simp
  have hwim : wc.im = T' := by rw [hwcd]; simp
  have hsplit : RectangleIntegral (Glue.Gf x) zc wc
      = HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')
        - HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'
        + VIntegral (Glue.Gf x) (1 + 1/Real.log x) (-T') T'
        - VIntegral (Glue.Gf x) (-1/4) (-T') T' := by
    simp only [RectangleIntegral]
    rw [hzre, hzim, hwre, hwim]
  have hPV : P = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
      * VIntegral (Glue.Gf x) (1 + 1/Real.log x) (-T') T' := by
    rw [hPd, VIntegral, smul_eq_mul]
    congr 1
    rw [intervalIntegral.integral_mul_const, mul_comm]
    congr 1
    apply intervalIntegral.integral_congr
    intro t _
    have harg : ((1 + 1/Real.log x : ℝ):ℂ) + (t:ℂ) * Complex.I
        = ((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * (t:ℂ) := by ring
    simp only [Glue.Gf]
    rw [harg]
  have hPR : P - RectangleIntegral' (Glue.Gf x) zc wc
      = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
        * (- HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')
          + HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'
          + VIntegral (Glue.Gf x) (-1/4) (-T') T') := by
    rw [hPV, RectangleIntegral', smul_eq_mul, hsplit,
      show (1 / (2 * (Real.pi:ℂ) * Complex.I)) = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
        from one_div _]
    ring
  have hinv : ‖(2 * (Real.pi:ℂ) * Complex.I)⁻¹‖ ≤ 1 := by
    rw [norm_inv, norm_mul, norm_mul, Complex.norm_I, mul_one]
    have h3 : ‖(2:ℂ)‖ = 2 := by norm_num
    have h4 : ‖((Real.pi:ℝ):ℂ)‖ = Real.pi := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos Real.pi_pos]
    rw [h3, h4]
    have h5 : (1:ℝ) ≤ 2 * Real.pi := by nlinarith [Real.pi_gt_three]
    exact inv_le_one_of_one_le₀ h5
  have hEtop := hCh x T T' hx hT ⟨hT'lo, hT'hi⟩ hgood T'
    (abs_of_pos (by linarith))
  have hEbot := hCh x T T' hx hT ⟨hT'lo, hT'hi⟩ hgood (-T')
    (by rw [abs_neg]; exact abs_of_pos (by linarith))
  have hE : ‖P - RectangleIntegral' (Glue.Gf x) zc wc‖
      ≤ 2*(Ch * x * Real.log T^2 / T) + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
    rw [hPR, norm_mul]
    have h6 : ‖- HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')
        + HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'
        + VIntegral (Glue.Gf x) (-1/4) (-T') T'‖
        ≤ ‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')‖
          + ‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'‖
          + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
      calc ‖_ + _ + _‖ ≤ ‖- HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')
            + HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'‖
            + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := norm_add_le _ _
        _ ≤ _ := by
            have h7 := norm_add_le (- HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T'))
              (HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T')
            rw [norm_neg] at h7
            linarith
    calc ‖(2 * (Real.pi:ℂ) * Complex.I)⁻¹‖ * ‖_‖
        ≤ 1 * (‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')‖
          + ‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'‖
          + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖) := by
          apply mul_le_mul hinv h6 (norm_nonneg _) (by norm_num)
      _ ≤ 2*(Ch * x * Real.log T^2 / T) + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
          rw [one_mul]
          linarith [hEtop, hEbot]
  have hswap := hCs x T T' hx hT hT'lo (by linarith)
  have hswap' : ‖Stage3.zeroPartialSum x T - Stage3.zeroPartialSum x T'‖
      ≤ Cs * x * Real.log T / T := by
    rw [← norm_neg, neg_sub]
    exact hswap
  have hkey : (Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T
      = ((Chebyshev.psi x : ℂ) - P)
        + (P - RectangleIntegral' (Glue.Gf x) zc wc)
        + (RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ) + Stage3.zeroPartialSum x T')
        + (Stage3.zeroPartialSum x T - Stage3.zeroPartialSum x T') := by
    ring
  have hCn : ‖RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ)
      + Stage3.zeroPartialSum x T'‖ = K0 := by
    rw [show RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ) + Stage3.zeroPartialSum x T'
        = - (deriv riemannZeta 0 / riemannZeta 0) by rw [hS4g]; ring]
    rw [norm_neg]
  -- the arithmetic
  have hL1 : (1:ℝ) ≤ Real.log (x*T) := by
    have h8 : (32:ℝ) ≤ x*T := by nlinarith
    have h9 : Real.log 32 ≤ Real.log (x*T) := Real.log_le_log (by norm_num) h8
    rw [show (32:ℝ) = 2^5 by norm_num, Real.log_pow] at h9
    have h10 : (0.6931471803:ℝ) < Real.log 2 := Real.log_two_gt_d9
    push_cast at h9
    nlinarith
  have hL0 : (0:ℝ) ≤ Real.log (x*T) := by linarith
  have hsq : Real.log (x*T')^2 ≤ 4*Real.log (x*T)^2 := by
    have h11 : x*T' ≤ 2*(x*T) := by nlinarith
    have h12 : Real.log (x*T') ≤ Real.log (2*(x*T)) :=
      Real.log_le_log (by positivity) h11
    have h12b : Real.log (2*(x*T)) = Real.log 2 + Real.log (x*T) :=
      Real.log_mul (by norm_num) (by positivity)
    rw [h12b] at h12
    have h13 : Real.log 2 ≤ 1 := by
      have := Real.log_le_sub_one_of_pos (show (0:ℝ) < 2 by norm_num)
      linarith
    have h14 : Real.log (x*T') ≤ 2*Real.log (x*T) := by linarith
    have h15 : (0:ℝ) ≤ Real.log (x*T') := by
      apply Real.log_nonneg
      nlinarith
    calc Real.log (x*T')^2 ≤ (2*Real.log (x*T))^2 := by
          apply pow_le_pow_left₀ h15 h14
      _ = 4*Real.log (x*T)^2 := by ring
  have he1 : 600 * x * Real.log (x*T')^2 / T' + 13*Real.log x
      ≤ 2400 * x * Real.log (x*T)^2 / T + 13*Real.log x := by
    have h16 : 600 * x * Real.log (x*T')^2 ≤ 2400 * x * Real.log (x*T)^2 := by
      have h16b := mul_le_mul_of_nonneg_left hsq (show (0:ℝ) ≤ 600*x by linarith)
      nlinarith [h16b]
    have h17 : 600 * x * Real.log (x*T')^2 / T'
        ≤ 2400 * x * Real.log (x*T)^2 / T' := by
      apply div_le_div_of_nonneg_right h16 hT'0.le
    have h18 : 2400 * x * Real.log (x*T)^2 / T'
        ≤ 2400 * x * Real.log (x*T)^2 / T := by
      apply div_le_div_of_nonneg_left (by positivity) hT0 hT'lo
    linarith
  have he2 : 2*(Ch * x * Real.log T^2 / T) ≤ 2*Ch * x * Real.log (x*T)^2 / T := by
    have h19 : Real.log T ≤ Real.log (x*T) := by
      apply Real.log_le_log hT0
      nlinarith
    have h20 : (0:ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
    have h21 : Real.log T^2 ≤ Real.log (x*T)^2 := by
      apply pow_le_pow_left₀ h20 h19
    have h22 : 2*Ch * x * Real.log T^2 ≤ 2*Ch * x * Real.log (x*T)^2 := by
      have h22b := mul_le_mul_of_nonneg_left h21 (show (0:ℝ) ≤ 2*Ch*x by positivity)
      nlinarith [h22b]
    have h23 : 2*Ch * x * Real.log T^2 / T ≤ 2*Ch * x * Real.log (x*T)^2 / T := by
      apply div_le_div_of_nonneg_right h22 hT0.le
    calc 2*(Ch * x * Real.log T^2 / T) = 2*Ch * x * Real.log T^2 / T := by ring
      _ ≤ 2*Ch * x * Real.log (x*T)^2 / T := h23
  have he3 : K0 ≤ K0/2 * Real.log x := by
    nlinarith [hlx2, hK00]
  have he4 : Cs * x * Real.log T / T ≤ Cs * x * Real.log (x*T)^2 / T := by
    have h19 : Real.log T ≤ Real.log (x*T) := by
      apply Real.log_le_log hT0
      nlinarith
    have h20 : (0:ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
    have h24 : Real.log T ≤ Real.log (x*T)^2 := by
      nlinarith [hL1]
    have h25 : Cs * x * Real.log T ≤ Cs * x * Real.log (x*T)^2 := by
      have h25b := mul_le_mul_of_nonneg_left h24 (show (0:ℝ) ≤ Cs*x by positivity)
      nlinarith [h25b]
    apply div_le_div_of_nonneg_right h25 hT0.le
  rw [hkey]
  calc ‖((Chebyshev.psi x : ℂ) - P)
        + (P - RectangleIntegral' (Glue.Gf x) zc wc)
        + (RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ) + Stage3.zeroPartialSum x T')
        + (Stage3.zeroPartialSum x T - Stage3.zeroPartialSum x T')‖
      ≤ ‖(Chebyshev.psi x : ℂ) - P‖
        + ‖P - RectangleIntegral' (Glue.Gf x) zc wc‖
        + ‖RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ) + Stage3.zeroPartialSum x T'‖
        + ‖Stage3.zeroPartialSum x T - Stage3.zeroPartialSum x T'‖ := norm_add₄_le
    _ ≤ (600 * x * Real.log (x*T')^2 / T' + 13*Real.log x)
        + (2*(Ch * x * Real.log T^2 / T) + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖)
        + K0 + Cs * x * Real.log T / T := by
        rw [hCn]
        linarith [hS1, hE, hswap']
    _ ≤ (2400 + 2*Ch + Cs) * x * Real.log (x*T)^2 / T
        + (13 + K0/2) * Real.log x + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
        have h26 : (2400 + 2*Ch + Cs) * x * Real.log (x*T)^2 / T
            = 2400 * x * Real.log (x*T)^2 / T + 2*Ch * x * Real.log (x*T)^2 / T
              + Cs * x * Real.log (x*T)^2 / T := by ring
        have h27 : (13 + K0/2) * Real.log x
            = 13*Real.log x + K0/2 * Real.log x := by ring
        rw [h26, h27]
        linarith [he1, he2, he3, he4]

/-- info: 'ExplicitLeft.explicit_formula_left' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms explicit_formula_left

set_option maxHeartbeats 1600000 in
/-- **The left edge at any height.** For `16 ≤ x` and `2 ≤ T′`, the integral of
`−ζ′/ζ(s)·x^s/s` up `Re s = −1/4` from `−T′` to `T′` has norm at most
`Aleft·log²T′·x^(−1/4)`. `Glue.edge_left_sharp_num`'s proof with `log T′` kept. -/
theorem edge_left_any {x T' : ℝ} (hx : 16 ≤ x) (hT'2 : 2 ≤ T') :
    ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖
      ≤ Aleft * (Real.log T')^2 * x ^ (-(1:ℝ)/4) := by
  classical
  obtain ⟨Ce, hCedef⟩ : ∃ Ce : ℝ, Ce = EdgeBound.Cen := ⟨_, rfl⟩
  have hCe0 : 0 < Ce := by rw [hCedef]; exact EdgeBound.Cen_pos
  have hCe := EdgeBound.edge_bound_core_num
  rw [← hCedef] at hCe
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  -- the compact-segment constant for ζ′/ζ
  have hccont : ContinuousOn (fun t : ℝ ↦
      ‖deriv riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)
        / riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)‖) (Set.Icc (-2:ℝ) 2) := by
    intro t _
    apply ContinuousAt.continuousWithinAt
    apply ContinuousAt.norm
    have hpre : ((((-1/4 : ℝ):ℂ)) + (t:ℝ) * Complex.I).re = -1/4 := by simp
    have hu1 : (((-1/4 : ℝ):ℂ) + t * Complex.I) ≠ 1 := by
      intro h
      have h2 := congrArg Complex.re h
      rw [hpre, Complex.one_re] at h2
      norm_num at h2
    have hζne : riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I) ≠ 0 := by
      apply ContourShift.zeta_ne_zero_of_re_mem (by rw [hpre]; norm_num)
        (by rw [hpre]; norm_num)
    have han := ContourShift.zeta_analyticAt hu1
    have hpar : Continuous (fun τ : ℝ ↦ ((-1/4 : ℝ):ℂ) + τ * Complex.I) := by
      fun_prop
    apply ContinuousAt.div
    · exact ContinuousAt.comp (g := deriv riemannZeta)
        (f := fun τ : ℝ ↦ ((-1/4 : ℝ):ℂ) + τ * Complex.I)
        (han.deriv.continuousAt) hpar.continuousAt
    · exact ContinuousAt.comp (g := riemannZeta)
        (f := fun τ : ℝ ↦ ((-1/4 : ℝ):ℂ) + τ * Complex.I)
        (han.continuousAt) hpar.continuousAt
    · exact hζne
  obtain ⟨Mc, hMcdef⟩ : ∃ Mc : ℝ, Mc = 1620000 := ⟨_, rfl⟩
  have hMc : ∀ x ∈ Set.Icc (-2:ℝ) 2,
      ‖‖deriv riemannZeta (((-1/4 : ℝ):ℂ) + x * Complex.I)
        / riemannZeta (((-1/4 : ℝ):ℂ) + x * Complex.I)‖‖ ≤ Mc := by
    intro x hx
    rw [norm_norm, hMcdef]
    exact EdgeBound.logDerivZeta_short_segment (abs_le.mpr ⟨hx.1, hx.2⟩)
  have hMc0 : (0:ℝ) ≤ Mc := by rw [hMcdef]; norm_num
  set D : ℝ := 36*Ce + 9*(Mc+1)/Real.log 2 with hDd
  have hD0 : 0 < D := by
    rw [hDd]
    positivity
  clear_value D
  have hCdef : Glue.Dln = D := by
    unfold Glue.Dln
    rw [hDd, hCedef, hMcdef]
  unfold Aleft
  rw [hCdef]
  have hx0 : (0:ℝ) < x := by linarith
  have hx1 : (1:ℝ) ≤ x := by linarith
  have hlx : (0:ℝ) < Real.log x := Real.log_pos (by linarith)
  have hlx2 : (2:ℝ) < Real.log x := by
    have h1 : Real.log 16 ≤ Real.log x := Real.log_le_log (by norm_num) hx
    have h2 : (16:ℝ) = 2^4 := by norm_num
    rw [h2, Real.log_pow] at h1
    have h3 : (0.6931471803:ℝ) < Real.log 2 := Real.log_two_gt_d9
    push_cast at h1
    nlinarith
  have hlogT' : (0:ℝ) < Real.log T' := Real.log_pos (by linarith)
  have hlogT'2 : Real.log 2 ≤ Real.log T' := Real.log_le_log (by norm_num) hT'2
  -- the pointwise dominating bound
  have hpoint : ∀ t : ℝ, -T' ≤ t → t ≤ T' →
      ‖Glue.Gf x (((-1/4 : ℝ):ℂ) + t * Complex.I)‖
        ≤ D * Real.log T' * x ^ (-(1:ℝ)/4) / (1/4 + |t|) := by
    intro t ht1 ht2
    set u : ℂ := ((-1/4 : ℝ):ℂ) + t * Complex.I with hud
    have hure : u.re = -1/4 := by rw [hud]; simp
    have huim : u.im = t := by rw [hud]; simp
    have hu1 : u ≠ 1 := by
      intro h
      have h2 := congrArg Complex.re h
      rw [hure] at h2
      simp at h2
      linarith
    have hxu : ‖((x:ℝ):ℂ) ^ u‖ = x ^ (-(1:ℝ)/4) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos hx0, hure]
      try norm_num
    have hun : 1/4 ≤ ‖u‖ := by
      have h5 := Complex.abs_re_le_norm u
      rw [hure] at h5
      have h6 : |(-1/4 : ℝ)| = 1/4 := by norm_num
      linarith [h5, h6.symm.le.trans h5]
    have hun2 : |t| ≤ ‖u‖ := by
      have h7 := Complex.abs_im_le_norm u
      rwa [huim] at h7
    have hun0 : (0:ℝ) < ‖u‖ := by linarith
    have hζbound : ‖deriv riemannZeta u / riemannZeta u‖
        ≤ (4*Ce*Real.log T') + Mc := by
      by_cases hth : 2 ≤ |t|
      · -- via edge_bound_core at height |t|
        have hkey : ∀ v : ℂ, v.re = -1/4 → v.im = |t| →
            ‖deriv riemannZeta v / riemannZeta v‖ ≤ 4*Ce*Real.log T' := by
          intro v hvre hvim
          have hvζ : riemannZeta v ≠ 0 := by
            apply ContourShift.zeta_ne_zero_of_re_mem <;> rw [hvre] <;> norm_num
          have hδ : ∀ w ∈ (EdgeBound.gz_zeros_ball_finite (|t|)
              (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (1/4 : ℝ) ≤ ‖v - w‖ := by
            intro w hw
            rw [Set.Finite.mem_toFinset] at hw
            obtain ⟨_, ⟨hwre0, _⟩, _⟩ := EdgeBound.ball_zero_shape hth hw.1 hw.2
            have h8 := Complex.abs_re_le_norm (v - w)
            rw [Complex.sub_re, hvre] at h8
            have h9 : (1/4:ℝ) ≤ |(-1/4) - w.re| := by
              rw [abs_sub_comm, abs_of_pos (by linarith)]
              linarith
            linarith
          have h10 := hCe (|t|) hth v hvim (by rw [hvre])
            (by rw [hvre]; norm_num) hvζ (1/4) (by norm_num) (by norm_num) hδ
          have h11 : Real.log (|t|) ≤ Real.log T' := by
            apply Real.log_le_log (by linarith)
            exact abs_le.mpr ⟨by linarith, by linarith⟩
          calc ‖deriv riemannZeta v / riemannZeta v‖
              ≤ Ce * Real.log (|t|) / (1/4) := h10
            _ = 4 * Ce * Real.log (|t|) := by ring
            _ ≤ 4*Ce*Real.log T' := by nlinarith
        rcases le_or_gt 0 t with htp | htn
        · have h12 : |t| = t := abs_of_nonneg htp
          have h13 := hkey u hure (by rw [huim, h12])
          linarith [h13, hMc0]
        · -- negative height via conjugation
          set v : ℂ := ((-1/4 : ℝ):ℂ) + (|t|) * Complex.I with hvd
          have hvre : v.re = -1/4 := by rw [hvd]; simp
          have hvim : v.im = |t| := by rw [hvd]; simp
          have hv1 : v ≠ 1 := by
            intro h
            have h2 := congrArg Complex.re h
            rw [hvre] at h2
            simp at h2
            linarith
          have hconj : (starRingEnd ℂ) v = u := by
            rw [hvd, hud, map_add, map_mul, Complex.conj_I, Complex.conj_ofReal,
              Complex.conj_ofReal, abs_of_neg htn]
            push_cast
            ring
          have h15 : ‖deriv riemannZeta u / riemannZeta u‖
              = ‖deriv riemannZeta v / riemannZeta v‖ := by
            rw [← hconj, EdgeBound.deriv_zeta_conj hv1, riemannZeta_conj,
              ← map_div₀, RCLike.norm_conj]
          rw [h15]
          have h16 := hkey v hvre hvim
          linarith [hMc0]
      · -- compact segment
        rw [not_le] at hth
        have h17' := hMc t (by
          rw [Set.mem_Icc]
          rw [abs_lt] at hth
          constructor <;> linarith [hth.1, hth.2])
        rw [norm_norm] at h17'
        have h17 : ‖deriv riemannZeta u / riemannZeta u‖ ≤ Mc := h17'
        have h18 : (0:ℝ) ≤ 4*Ce*Real.log T' := by positivity
        show ‖deriv riemannZeta u / riemannZeta u‖ ≤ (4*Ce*Real.log T') + Mc
        calc ‖deriv riemannZeta u / riemannZeta u‖ ≤ Mc := h17
          _ ≤ (4*Ce*Real.log T') + Mc := by linarith
    -- assemble the pointwise bound
    show ‖(- deriv riemannZeta u / riemannZeta u) * ((x:ℝ):ℂ) ^ u / u‖
      ≤ D * Real.log T' * x ^ (-(1:ℝ)/4) / (1/4 + |t|)
    rw [norm_div, norm_mul, neg_div, norm_neg, hxu]
    have hq : (0:ℝ) < 1/4 + |t| := by positivity
    rw [div_le_div_iff₀ hun0 hq]
    have hrp : (0:ℝ) ≤ x ^ (-(1:ℝ)/4) := Real.rpow_nonneg hx0.le _
    have h20 : Mc ≤ (Mc+1)/Real.log 2 * Real.log T' := by
      rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
      nlinarith
    have hDlog : ((4*Ce*Real.log T') + Mc) * (1/4 + |t|)
        ≤ D * Real.log T' * ‖u‖ := by
      rcases le_or_gt 2 (|t|) with hth | hth
      · have h19 : 1/4 + |t| ≤ 2 * ‖u‖ := by
          have h19a : 1/4 + |t| ≤ 2*|t| := by linarith
          linarith [hun2]
        have hA : ((4*Ce*Real.log T') + Mc) * (1/4 + |t|)
            ≤ ((4*Ce*Real.log T') + Mc) * (2*‖u‖) := by
          apply mul_le_mul_of_nonneg_left h19 (by positivity)
        have hC : 2*Mc*‖u‖ ≤ 9*(Mc+1)/Real.log 2 * Real.log T' * ‖u‖ := by
          apply mul_le_mul_of_nonneg_right ?_ (norm_nonneg u)
          have h25 : (0:ℝ) ≤ (Mc+1)/Real.log 2 * Real.log T' := by positivity
          have h26 : 9*(Mc+1)/Real.log 2 * Real.log T'
              = 9*((Mc+1)/Real.log 2 * Real.log T') := by ring
          rw [h26]
          linarith
        have hE : 8*Ce*Real.log T'*‖u‖ ≤ 36*Ce*Real.log T'*‖u‖ := by
          have h27 : (0:ℝ) ≤ Ce*Real.log T'*‖u‖ := by positivity
          nlinarith
        rw [hDd]
        calc ((4*Ce*Real.log T') + Mc) * (1/4 + |t|)
            ≤ ((4*Ce*Real.log T') + Mc) * (2*‖u‖) := hA
          _ = 8*Ce*Real.log T'*‖u‖ + 2*Mc*‖u‖ := by ring
          _ ≤ 36*Ce*Real.log T'*‖u‖
              + 9*(Mc+1)/Real.log 2 * Real.log T' * ‖u‖ := by linarith
          _ = (36*Ce + 9*(Mc+1)/Real.log 2) * Real.log T' * ‖u‖ := by ring
      · have h22 : 1/4 + |t| ≤ 9/4 := by linarith
        have hA : ((4*Ce*Real.log T') + Mc) * (1/4 + |t|)
            ≤ ((4*Ce*Real.log T') + Mc) * (9/4) := by
          apply mul_le_mul_of_nonneg_left h22 (by positivity)
        have hB : D * Real.log T' * (1/4) ≤ D * Real.log T' * ‖u‖ := by
          apply mul_le_mul_of_nonneg_left hun (by positivity)
        have hC : ((4*Ce*Real.log T') + Mc) * (9/4) ≤ D * Real.log T' * (1/4) := by
          rw [hDd]
          have h28 : (9/4:ℝ)*Mc ≤ (9/4)*((Mc+1)/Real.log 2 * Real.log T') := by
            linarith
          have h29 : (36*Ce + 9*(Mc+1)/Real.log 2) * Real.log T' * (1/4)
              = 9*Ce*Real.log T' + (9/4)*((Mc+1)/Real.log 2 * Real.log T') := by
            ring
          rw [h29]
          have h30 : ((4*Ce*Real.log T') + Mc) * (9/4)
              = 9*Ce*Real.log T' + (9/4)*Mc := by ring
          rw [h30]
          linarith
        linarith
    calc ‖deriv riemannZeta u / riemannZeta u‖ * x ^ (-(1:ℝ)/4) * (1/4 + |t|)
        ≤ ((4*Ce*Real.log T') + Mc) * x ^ (-(1:ℝ)/4) * (1/4 + |t|) := by
          apply mul_le_mul_of_nonneg_right ?_ hq.le
          exact mul_le_mul_of_nonneg_right hζbound hrp
      _ = ((4*Ce*Real.log T') + Mc) * (1/4 + |t|) * x ^ (-(1:ℝ)/4) := by ring
      _ ≤ D * Real.log T' * ‖u‖ * x ^ (-(1:ℝ)/4) := by
          apply mul_le_mul_of_nonneg_right hDlog hrp
      _ = D * Real.log T' * x ^ (-(1:ℝ)/4) * ‖u‖ := by ring
  -- continuity of the integrand along the edge
  have hGcont : ContinuousOn (fun t : ℝ ↦ Glue.Gf x (((-1/4 : ℝ):ℂ) + t * Complex.I))
      (Set.uIcc (-T') T') := by
    intro t _
    apply ContinuousAt.continuousWithinAt
    have hpre : ((((-1/4 : ℝ):ℂ)) + (t:ℝ) * Complex.I).re = -1/4 := by simp
    have hu1 : (((-1/4 : ℝ):ℂ) + t * Complex.I) ≠ 1 := by
      intro h
      have h2 := congrArg Complex.re h
      rw [hpre, Complex.one_re] at h2
      norm_num at h2
    have hu0 : (((-1/4 : ℝ):ℂ) + t * Complex.I) ≠ 0 := by
      intro h
      have h2 := congrArg Complex.re h
      rw [hpre, Complex.zero_re] at h2
      norm_num at h2
    have hζne : riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I) ≠ 0 :=
      ContourShift.zeta_ne_zero_of_re_mem (by rw [hpre]; norm_num)
        (by rw [hpre]; norm_num)
    have han := ContourShift.zeta_analyticAt hu1
    have hpar : Continuous (fun τ : ℝ ↦ ((-1/4 : ℝ):ℂ) + τ * Complex.I) := by
      fun_prop
    show ContinuousAt
      (fun t : ℝ ↦ (- deriv riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)
          / riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I))
        * ((x:ℝ):ℂ) ^ (((-1/4 : ℝ):ℂ) + t * Complex.I)
        / (((-1/4 : ℝ):ℂ) + t * Complex.I)) t
    apply ContinuousAt.div
    · apply ContinuousAt.mul
      · apply ContinuousAt.div
        · apply ContinuousAt.neg
          exact ContinuousAt.comp (g := deriv riemannZeta)
            (f := fun τ : ℝ ↦ ((-1/4 : ℝ):ℂ) + τ * Complex.I)
            (han.deriv.continuousAt) hpar.continuousAt
        · exact ContinuousAt.comp (g := riemannZeta)
            (f := fun τ : ℝ ↦ ((-1/4 : ℝ):ℂ) + τ * Complex.I)
            (han.continuousAt) hpar.continuousAt
        · exact hζne
      · apply ContinuousAt.const_cpow ?_ (Or.inl (Complex.ofReal_ne_zero.mpr (ne_of_gt hx0)))
        exact hpar.continuousAt
    · exact hpar.continuousAt
    · exact hu0
  have hrp0 : (0:ℝ) ≤ x ^ (-(1:ℝ)/4) := Real.rpow_nonneg hx0.le _
  have hdomcont : ContinuousOn
      (fun t : ℝ ↦ D * Real.log T' * x ^ (-(1:ℝ)/4) / (1/4 + |t|))
      (Set.uIcc (-T') T') := by
    apply ContinuousOn.div continuousOn_const
    · fun_prop
    · intro t _
      positivity
  -- the |t|-integral
  have habs_int : ∫ t in (-T')..T', 1/(1/4 + |t|) ≤ 8 * Real.log T' := by
    have hcont1 : ContinuousOn (fun t : ℝ ↦ 1/(1/4 + |t|)) (Set.uIcc (-T') 0) := by
      apply ContinuousOn.div continuousOn_const
      · fun_prop
      · intro t _
        positivity
    have hcont2 : ContinuousOn (fun t : ℝ ↦ 1/(1/4 + |t|)) (Set.uIcc 0 T') := by
      apply ContinuousOn.div continuousOn_const
      · fun_prop
      · intro t _
        positivity
    have hii1 : IntervalIntegrable (fun t : ℝ ↦ 1/(1/4 + |t|))
        MeasureTheory.volume (-T') 0 := hcont1.intervalIntegrable
    have hii2 : IntervalIntegrable (fun t : ℝ ↦ 1/(1/4 + |t|))
        MeasureTheory.volume 0 T' := hcont2.intervalIntegrable
    have hsplit := intervalIntegral.integral_add_adjacent_intervals hii1 hii2
    have hpos : ∫ t in (0:ℝ)..T', 1/(1/4 + |t|) = Real.log ((1/4+T')/(1/4)) := by
      rw [intervalIntegral.integral_congr (g := fun t : ℝ ↦ 1/(1/4 + t)) ?_]
      · have hderiv : ∀ t ∈ Set.uIcc (0:ℝ) T', HasDerivAt
            (fun τ : ℝ ↦ Real.log (1/4 + τ)) (1/(1/4 + t)) t := by
          intro t ht
          rw [Set.uIcc_of_le (by linarith : (0:ℝ) ≤ T')] at ht
          have h31 : (0:ℝ) < 1/4 + t := by linarith [ht.1]
          have h32 := Real.hasDerivAt_log (ne_of_gt h31)
          have h33 : HasDerivAt (fun τ : ℝ ↦ 1/4 + τ) 1 t :=
            (hasDerivAt_id t).const_add (1/4)
          have h34 := HasDerivAt.comp t h32 h33
          have h36 : (1/(1/4 + t) : ℝ) = (1/4+t)⁻¹ * 1 := by
            rw [one_div, mul_one]
          rw [h36]
          exact h34
        have hcont3 : ContinuousOn (fun t : ℝ ↦ 1/(1/4 + t)) (Set.uIcc (0:ℝ) T') := by
          apply ContinuousOn.div continuousOn_const (by fun_prop)
          intro t ht
          rw [Set.uIcc_of_le (by linarith : (0:ℝ) ≤ T')] at ht
          have := ht.1
          positivity
        rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv
          hcont3.intervalIntegrable]
        rw [Real.log_div (by linarith) (by norm_num)]
        ring_nf
      · intro t ht
        rw [Set.uIcc_of_le (by linarith : (0:ℝ) ≤ T')] at ht
        show 1/(1/4 + |t|) = 1/(1/4 + t)
        rw [abs_of_nonneg ht.1]
    have hneg : ∫ t in (-T')..(0:ℝ), 1/(1/4 + |t|)
        = ∫ t in (0:ℝ)..T', 1/(1/4 + |t|) := by
      have h35 : (∫ t in (0:ℝ)..T', (fun s : ℝ ↦ 1/(1/4 + |s|)) (-t))
          = ∫ t in (-T')..(-(0:ℝ)), 1/(1/4 + |t|) :=
        intervalIntegral.integral_comp_neg (fun s : ℝ ↦ 1/(1/4 + |s|))
      simp only [abs_neg, neg_zero] at h35
      exact h35.symm
    have hlog5 : Real.log ((1/4+T')/(1/4)) ≤ 4 * Real.log T' := by
      have h36 : (1/4+T')/(1/4 : ℝ) = 1 + 4*T' := by ring
      rw [h36]
      have h37 : Real.log (1 + 4*T') ≤ Real.log (T'^4) := by
        apply Real.log_le_log (by linarith)
        have hsq : 2*T' ≤ T'^2 := by nlinarith
        have hq4 : 4*T'^2 ≤ T'^4 := by nlinarith [hsq]
        nlinarith [hsq, hq4]
      rw [Real.log_pow] at h37
      push_cast at h37
      linarith
    have h38 : ∫ t in (-T')..T', 1/(1/4 + |t|)
        = 2 * Real.log ((1/4+T')/(1/4)) := by
      rw [← hsplit, hneg, hpos]
      ring
    rw [h38]
    linarith
  -- assemble
  rw [VIntegral, norm_smul, Complex.norm_I, one_mul]
  have hInorm : ‖∫ t in (-T')..T', Glue.Gf x (((-1/4:ℝ):ℂ) + t * Complex.I)‖
      ≤ D * Real.log T' * x ^ (-(1:ℝ)/4) * (8 * Real.log T') := by
    calc ‖∫ t in (-T')..T', Glue.Gf x (((-1/4:ℝ):ℂ) + t * Complex.I)‖
        ≤ ∫ t in (-T')..T', ‖Glue.Gf x (((-1/4:ℝ):ℂ) + t * Complex.I)‖ :=
          intervalIntegral.norm_integral_le_integral_norm (by linarith)
      _ ≤ ∫ t in (-T')..T', D * Real.log T' * x ^ (-(1:ℝ)/4) / (1/4 + |t|) := by
          apply intervalIntegral.integral_mono_on (by linarith)
            (hGcont.norm.intervalIntegrable) (hdomcont.intervalIntegrable)
          intro t ht
          exact hpoint t ht.1 ht.2
      _ = D * Real.log T' * x ^ (-(1:ℝ)/4) * ∫ t in (-T')..T', 1/(1/4 + |t|) := by
          rw [← intervalIntegral.integral_const_mul]
          congr 1
          funext t
          ring
      _ ≤ D * Real.log T' * x ^ (-(1:ℝ)/4) * (8 * Real.log T') := by
          apply mul_le_mul_of_nonneg_left habs_int
          positivity
  calc ‖∫ t in (-T')..T', Glue.Gf x (((-1/4:ℝ):ℂ) + t * Complex.I)‖
      ≤ D * Real.log T' * x ^ (-(1:ℝ)/4) * (8 * Real.log T') := hInorm
    _ = 8 * D * (Real.log T')^2 * x ^ (-(1:ℝ)/4) := by ring

/-- info: 'ExplicitLeft.edge_left_any' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms edge_left_any

/-- **The truncated explicit formula at every height.** For `16 ≤ x` and `2 ≤ T`,
`‖ψ(x) − x + Σ_{|γ|<T} m·x^ρ/ρ‖ ≤ c1n·x·log²(xT)/T + c3n·log x
+ Aleft·log²(T+1)·x^(−1/4)`. No cap on `T`; the last term grows with `T`. -/
theorem explicit_formula_any {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
      ≤ Glue.c1n * x * Real.log (x*T)^2 / T + Glue.c3n * Real.log x
        + Aleft * (Real.log (T+1))^2 * x ^ (-(1:ℝ)/4) := by
  obtain ⟨T', hT'lo, hT'hi, hF⟩ := explicit_formula_left hx hT
  have hT'2 : (2:ℝ) ≤ T' := le_trans hT hT'lo
  have hE := edge_left_any hx hT'2
  have hl0 : (0:ℝ) ≤ Real.log T' := Real.log_nonneg (by linarith)
  have hl1 : Real.log T' ≤ Real.log (T+1) := Real.log_le_log (by linarith) hT'hi
  have hsq : (Real.log T')^2 ≤ (Real.log (T+1))^2 := pow_le_pow_left₀ hl0 hl1 2
  have hA : (0:ℝ) ≤ Aleft := Aleft_pos.le
  have hr : (0:ℝ) ≤ x ^ (-(1:ℝ)/4) := Real.rpow_nonneg (by linarith) _
  have hE2 : Aleft * (Real.log T')^2 * x ^ (-(1:ℝ)/4)
      ≤ Aleft * (Real.log (T+1))^2 * x ^ (-(1:ℝ)/4) := by
    apply mul_le_mul_of_nonneg_right ?_ hr
    exact mul_le_mul_of_nonneg_left hsq hA
  linarith

/-- info: 'ExplicitLeft.explicit_formula_any' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms explicit_formula_any

end ExplicitLeft
