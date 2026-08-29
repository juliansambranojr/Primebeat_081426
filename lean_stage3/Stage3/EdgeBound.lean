/-
# S3 — the edge bound (FinalBound rescale + gap-eating)

The Landau partial fraction transported from PNT+'s normalized
`FinalBound` (unit ball) to the ball at `3/2 + iT′`, for
`g = (s−1)²·ζ` (entire; the pole cleared, one extra order-1 zero at
`1`). Inputs: `ZetaGrowth.sq_zeta_band_bound` (the B), PNT+'s
`ZetaFixedLowerBound` (the f(0)), `ContourShift`'s good heights,
fences, and reflection-order (the eating).

This file sits downstream of ContourShift and ZetaGrowth; the scratch
`edge_bound` statement in ContourShift is superseded here.
-/
import Stage3.ZetaGrowth

namespace EdgeBound

open Complex Topology Set

/-- The ball center at height `T′`. -/
noncomputable def c0 (T' : ℝ) : ℂ := 3/2 + Complex.I * T'

/-- `g = (s−1)²·ζ` — entire, zeros = ζ-zeros plus an order-1 zero at 1. -/
noncomputable def gz (s : ℂ) : ℂ := (s - 1)^2 * riemannZeta s

theorem gz_analytic (s : ℂ) : AnalyticAt ℂ gz s := ZetaGrowth.sq_mul_zeta_analytic s

theorem c0_im (T' : ℝ) : (c0 T').im = T' := by
  rw [c0]
  simp

theorem c0_re (T' : ℝ) : (c0 T').re = 3/2 := by
  rw [c0]
  simp

/-- The explicit lower bound at the center. -/
theorem gz_lower {T' : ℝ} (hT' : 2 ≤ T') :
    4 * ‖riemannZeta 3 / riemannZeta (3/2)‖ ≤ ‖gz (c0 T')‖ := by
  rw [gz, norm_mul, norm_pow]
  have h1 : T' ≤ ‖c0 T' - 1‖ := by
    have h2 := Complex.abs_im_le_norm (c0 T' - 1)
    have h3 : (c0 T' - 1).im = T' := by
      rw [Complex.sub_im, c0_im, Complex.one_im, sub_zero]
    rw [h3] at h2
    calc T' ≤ |T'| := le_abs_self _
      _ ≤ ‖c0 T' - 1‖ := h2
  have h4 := ZetaFixedLowerBound T'
  have h5 : ‖riemannZeta 3 / riemannZeta (3/2)‖
      ≤ ‖riemannZeta (3/2 + Complex.I * T')‖ := by
    exact_mod_cast h4
  have h6 : riemannZeta (c0 T') = riemannZeta (3/2 + Complex.I * (T' : ℂ)) := rfl
  rw [h6]
  have h7 : (0:ℝ) ≤ ‖riemannZeta 3 / riemannZeta (3/2)‖ := norm_nonneg _
  have h8 : (4:ℝ) ≤ ‖c0 T' - 1‖^2 := by nlinarith [norm_nonneg (c0 T' - 1)]
  have h9 : (0:ℝ) ≤ ‖riemannZeta (3/2 + Complex.I * (T':ℂ))‖ := norm_nonneg _
  calc 4 * ‖riemannZeta 3 / riemannZeta (3/2)‖
      ≤ 4 * ‖riemannZeta (3/2 + Complex.I * (T':ℂ))‖ := by linarith
    _ ≤ ‖c0 T' - 1‖^2 * ‖riemannZeta (3/2 + Complex.I * (T':ℂ))‖ := by nlinarith

/-- The lower-bound constant is positive. -/
theorem zeta_ratio_pos : (0:ℝ) < ‖riemannZeta 3 / riemannZeta (3/2)‖ := by
  rw [norm_div]
  apply div_pos
  · rw [norm_pos_iff]
    exact riemannZeta_ne_zero_of_one_lt_re (by norm_num)
  · rw [norm_pos_iff]
    exact riemannZeta_ne_zero_of_one_lt_re (by norm_num)

/-- The center's value is nonzero. -/
theorem gz_c0_ne {T' : ℝ} (hT' : 2 ≤ T') : gz (c0 T') ≠ 0 := by
  have h1 := gz_lower hT'
  have h2 := zeta_ratio_pos
  rw [← norm_pos_iff]
  linarith

/-- A `gz`-zero is `1` or a `ζ`-zero. -/
theorem gz_zero_cases {w : ℂ} (h : gz w = 0) : w = 1 ∨ riemannZeta w = 0 := by
  rw [gz, mul_eq_zero] at h
  rcases h with h | h
  · left
    have h2 := pow_eq_zero_iff (n := 2) (by norm_num) |>.mp h
    linear_combination h2
  · right
    exact h

/-- The `gz`-zeros in any ball around the center are finite. -/
theorem gz_zeros_ball_finite (T' : ℝ) {ρ : ℝ} (hρ : 0 ≤ ρ) :
    {w : ℂ | gz w = 0 ∧ ‖w - c0 T'‖ ≤ ρ}.Finite := by
  set zc : ℂ := ((3/2 - ρ : ℝ) : ℂ) - Complex.I * ((|T'| + ρ : ℝ) : ℂ) with hzcd
  set wc : ℂ := ((3/2 + ρ : ℝ) : ℂ) + Complex.I * ((|T'| + ρ : ℝ) : ℂ) with hwcd
  have hzre : zc.re = 3/2 - ρ := by rw [hzcd]; simp
  have hzim : zc.im = -(|T'| + ρ) := by rw [hzcd]; simp
  have hwre : wc.re = 3/2 + ρ := by rw [hwcd]; simp
  have hwim : wc.im = |T'| + ρ := by rw [hwcd]; simp
  apply Set.Finite.subset
    ((ContourShift.zeta_zeros_rectangle_finite zc wc).union (Set.finite_singleton 1))
  rintro w ⟨hz, hball⟩
  rcases gz_zero_cases hz with h1 | h1
  · right
    exact h1
  · left
    refine ⟨h1, ?_⟩
    have hre := Complex.abs_re_le_norm (w - c0 T')
    have him := Complex.abs_im_le_norm (w - c0 T')
    rw [Complex.sub_re, c0_re] at hre
    rw [Complex.sub_im, c0_im] at him
    have h2 : |w.re - 3/2| ≤ ρ := le_trans hre hball
    have h3 : |w.im - T'| ≤ ρ := le_trans him hball
    rw [abs_le] at h2 h3
    have hT'a : T' ≤ |T'| := le_abs_self T'
    have hT'b : -|T'| ≤ T' := neg_abs_le T'
    simp only [Rectangle]
    rw [Complex.mem_reProdIm, hzre, hwre, hzim, hwim,
      Set.uIcc_of_le (by linarith : (3/2 - ρ : ℝ) ≤ 3/2 + ρ),
      Set.uIcc_of_le (by linarith : -(|T'| + ρ) ≤ |T'| + ρ),
      Set.mem_Icc, Set.mem_Icc]
    constructor
    · constructor <;> linarith [h2.1, h2.2]
    · constructor <;> linarith [h3.1, h3.2]

set_option maxHeartbeats 1600000 in
/-- **The rescaled Landau partial fraction.** At any height `T′ ≥ 2`
and any `u` on the segment `re ∈ [−1/4, 2]` at that height that is
not a `gz`-zero, the log-derivative of `gz` minus the simple-pole sum
over `gz`-zeros within `46/25` of the center is `≤ C·log T′`.
Transported from PNT+'s normalized `FinalBound` with radii
`22/25 < 23/25 < 19/20 < 49/50`. -/
theorem gz_partial_fraction :
    ∃ C : ℝ, 0 < C ∧ ∀ T' : ℝ, 2 ≤ T' → ∀ u : ℂ,
      u.im = T' → -1/4 ≤ u.re → u.re ≤ 2 → gz u ≠ 0 →
      ‖deriv gz u / gz u
          - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset,
              (analyticOrderNatAt gz w : ℂ) / (u - w)‖
        ≤ C * Real.log T' := by
  classical
  obtain ⟨Cb, hCb0, hCb⟩ := ZetaGrowth.sq_zeta_band_bound
  set cζ : ℝ := ‖riemannZeta 3 / riemannZeta (3/2)‖ with hcζd
  have hcζ0 : 0 < cζ := zeta_ratio_pos
  set G : ℝ := 16 * (23/25:ℝ) ^ 2 / ((23/25:ℝ) - 22/25) ^ 3
      + 1 / (((49/50:ℝ) ^ 2 / (19/20) - 19/20) * Real.log ((49/50:ℝ) / (19/20))) with hGd
  have hG0 : 0 < G := by
    rw [hGd]
    have h1 : (0:ℝ) < Real.log ((49/50:ℝ) / (19/20)) := by
      apply Real.log_pos
      norm_num
    have h2 : (0:ℝ) < (49/50:ℝ) ^ 2 / (19/20) - 19/20 := by norm_num
    positivity
  clear_value G
  set D0 : ℝ := Cb * 81 / (4*cζ) + 2 with hD0d
  have hD02 : (2:ℝ) ≤ D0 := by
    rw [hD0d]
    have h3 : 0 < Cb * 81 / (4*cζ) := by positivity
    linarith
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hlogD0 : (0:ℝ) < Real.log D0 := Real.log_pos (by linarith)
  set A : ℝ := Real.log D0 / Real.log 2 + 4 with hAd
  refine ⟨G / 2 * A, by rw [hAd]; positivity, ?_⟩
  intro T' hT' u him hre1 hre2 hune
  have hlogT : Real.log 2 ≤ Real.log T' := Real.log_le_log (by norm_num) hT'
  have hlogT0 : 0 < Real.log T' := lt_of_lt_of_le hlog2 hlogT
  have hT4 : (1:ℝ) ≤ T' ^ 4 := by
    have h40 := pow_le_pow_left₀ (show (0:ℝ) ≤ 2 by norm_num) hT' 4
    norm_num at h40
    linarith only [h40]
  set B : ℝ := D0 * T' ^ 4 with hBd
  have hB1 : 1 < B := by
    rw [hBd]
    nlinarith [hD02, hT4]
  have h19 : B * (4*cζ) = 81*Cb*T'^4 + 8*cζ*T'^4 := by
    rw [hBd, hD0d]
    field_simp
    ring
  have hlogB : Real.log B ≤ A * Real.log T' := by
    have h4 : Real.log B = Real.log D0 + 4 * Real.log T' := by
      rw [hBd, Real.log_mul (by linarith) (by positivity), Real.log_pow]
      push_cast
      ring
    have h5 : Real.log D0 ≤ Real.log D0 / Real.log 2 * Real.log T' := by
      rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
      exact mul_le_mul_of_nonneg_left hlogT hlogD0.le
    rw [h4, hAd, add_mul]
    linarith
  clear_value B D0 A
  have hgc0 : gz (c0 T') ≠ 0 := gz_c0_ne hT'
  set f : ℂ → ℂ := fun w ↦ gz (2*w + c0 T') / gz (c0 T') with hfd
  have haffan : ∀ w : ℂ, AnalyticAt ℂ (fun w : ℂ ↦ gz (2*w + c0 T')) w := by
    intro w
    have h7 : (fun w : ℂ ↦ gz (2*w + c0 T')) = gz ∘ (fun w ↦ 2*w + c0 T') := rfl
    rw [h7]
    exact (gz_analytic _).comp ((analyticAt_const.mul analyticAt_id).add analyticAt_const)
  have hfan : ∀ w : ℂ, AnalyticAt ℂ f w := by
    intro w
    rw [hfd]
    exact (haffan w).div analyticAt_const hgc0
  have hfAnalytic : AnalyticOnNhd ℂ f (Metric.closedBall (0:ℂ) 1) := fun w _ ↦ hfan w
  have hf0 : f 0 = 1 := by
    rw [hfd]
    simp only [mul_zero, zero_add]
    exact div_self hgc0
  have hinj : Function.Injective (fun ρ : ℂ ↦ 2*ρ + c0 T') := by
    intro a b hab
    have h8 : (2:ℂ) * a = 2 * b := by
      have h9 : (2:ℂ)*a + c0 T' = 2*b + c0 T' := hab
      linear_combination h9
    exact mul_left_cancel₀ two_ne_zero h8
  have hball2 := gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 2)
  have hfin : (SetOfZeros 1 f).Finite := by
    apply Set.Finite.subset (Set.Finite.preimage hinj.injOn hball2)
    rintro ρ ⟨hρn, hρz⟩
    show gz (2*ρ + c0 T') = 0 ∧ ‖(2*ρ + c0 T') - c0 T'‖ ≤ 2
    have hρz2 : gz (2*ρ + c0 T') = 0 := by
      rw [hfd] at hρz
      exact (div_eq_zero_iff.mp hρz).resolve_right hgc0
    refine ⟨hρz2, ?_⟩
    rw [show (2*ρ + c0 T') - c0 T' = 2*ρ by ring, norm_mul]
    simp only [Complex.norm_ofNat]
    linarith
  have hfz_bound : ∀ z : ℂ, ‖z‖ ≤ (49/50:ℝ) → ‖f z‖ ≤ B := by
    intro z hzn
    rw [hfd]
    show ‖gz (2*z + c0 T') / gz (c0 T')‖ ≤ B
    rw [norm_div, div_le_iff₀ (norm_pos_iff.mpr hgc0)]
    have h10 := Complex.abs_re_le_norm z
    have h12 := Complex.abs_im_le_norm z
    have h11 : (2*z + c0 T').re = 2*z.re + 3/2 := by
      simp [Complex.add_re, Complex.mul_re, c0_re]
    have h13 : (2*z + c0 T').im = 2*z.im + T' := by
      simp [Complex.add_im, Complex.mul_im, c0_im]
    have h10' : |z.re| ≤ 49/50 := le_trans h10 hzn
    have h12' : |z.im| ≤ 49/50 := le_trans h12 hzn
    rw [abs_le] at h10' h12'
    have h14 := hCb (2*z + c0 T')
      (by rw [h11]; nlinarith [h10'.1]) (by rw [h11]; nlinarith [h10'.2])
    have h15im : |(2*z + c0 T').im| ≤ 2 + T' := by
      rw [h13, abs_le]
      constructor <;> nlinarith [h12'.1, h12'.2]
    have h15 : (2 + |(2*z + c0 T').im|) ^ 4 ≤ (4 + T') ^ 4 := by
      apply pow_le_pow_left₀ (by positivity)
      linarith
    have h16 : (4+T') ^ 4 ≤ 81 * T'^4 := by
      calc (4+T') ^ 4 ≤ (3*T') ^ 4 := by
            apply pow_le_pow_left₀ (by linarith)
            linarith
        _ = 81 * T'^4 := by ring
    have h20 : ‖gz (2*z + c0 T')‖ ≤ B * (4*cζ) := by
      calc ‖gz (2*z + c0 T')‖ ≤ Cb * (2 + |(2*z + c0 T').im|) ^ 4 := h14
        _ ≤ Cb * (4+T') ^ 4 := mul_le_mul_of_nonneg_left h15 hCb0.le
        _ ≤ Cb * (81 * T'^4) := mul_le_mul_of_nonneg_left h16 hCb0.le
        _ ≤ B * (4*cζ) := by
            rw [h19]
            have h30 : Cb * (81 * T'^4) = 81*Cb*T'^4 := by ring
            have h31 : (0:ℝ) ≤ 8*cζ*T'^4 := by positivity
            linarith only [h30, h31]
    calc ‖gz (2*z + c0 T')‖ ≤ B * (4*cζ) := h20
      _ ≤ B * ‖gz (c0 T')‖ := by
          apply mul_le_mul_of_nonneg_left (gz_lower hT')
          linarith only [hB1]
  set z : ℂ := (u - c0 T') / 2 with hzd
  have h2z : 2*z + c0 T' = u := by rw [hzd]; ring
  have huc0 : u - c0 T' = ((u.re - 3/2 : ℝ) : ℂ) := by
    apply Complex.ext
    · simp [Complex.sub_re, c0_re]
    · simp [Complex.sub_im, c0_im, him]
  have hzn : ‖z‖ ≤ 22/25 := by
    rw [hzd, norm_div, huc0]
    simp only [Complex.norm_ofNat, Complex.norm_real, Real.norm_eq_abs]
    have h21 : |u.re - 3/2| ≤ 7/4 := by
      rw [abs_le]
      constructor <;> linarith
    calc |u.re - 3/2| / 2 ≤ (7/4)/2 := by linarith
      _ ≤ 22/25 := by norm_num
  have hfz_ne : f z ≠ 0 := by
    rw [hfd]
    show gz (2*z + c0 T') / gz (c0 T') ≠ 0
    rw [h2z]
    exact div_ne_zero hune hgc0
  have hzmem : z ∈ Metric.closedBall (0:ℂ) (22/25) \ SetOfZeros (19/20) f := by
    constructor
    · rw [Metric.mem_closedBall, dist_zero_right]
      exact hzn
    · rintro ⟨-, hfz0⟩
      exact hfz_ne hfz0
  have hFB := FinalBound (B := B) (r' := 22/25) (r := 23/25) (R' := 19/20) (R := 49/50)
    hB1 (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    hfAnalytic hf0 hfin hfz_bound hzmem
  have hgder : HasDerivAt gz (deriv gz u) u := (gz_analytic u).differentiableAt.hasDerivAt
  have haff : HasDerivAt (fun w : ℂ ↦ 2*w + c0 T') 2 z := by
    have h22 := ((hasDerivAt_id z).const_mul (2:ℂ)).add_const (c0 T')
    simpa using h22
  have hcomp : HasDerivAt (fun w : ℂ ↦ gz (2*w + c0 T')) (deriv gz u * 2) z := by
    have h23 : HasDerivAt gz (deriv gz u) (2*z + c0 T') := by
      rw [h2z]
      exact hgder
    exact h23.comp z haff
  have hfder : deriv f z = deriv gz u * 2 / gz (c0 T') := by
    rw [hfd]
    exact (hcomp.div_const _).deriv
  have hfval : f z = gz u / gz (c0 T') := by
    rw [hfd]
    show gz (2*z + c0 T') / gz (c0 T') = gz u / gz (c0 T')
    rw [h2z]
  set Fg := (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset with hFgd
  set Ff := (finiteSetOfZeros_mono (by norm_num : (23/25:ℝ) < 1) hfin).toFinset with hFfd
  have hFeq : Fg = Ff.image (fun ρ ↦ 2*ρ + c0 T') := by
    ext w
    rw [hFgd, hFfd, Set.Finite.mem_toFinset, Finset.mem_image]
    constructor
    · rintro ⟨hw0, hwball⟩
      refine ⟨(w - c0 T')/2, ?_, by ring⟩
      rw [Set.Finite.mem_toFinset]
      constructor
      · rw [norm_div]
        simp only [Complex.norm_ofNat]
        linarith
      · rw [hfd]
        show gz (2*((w - c0 T')/2) + c0 T') / gz (c0 T') = 0
        rw [show 2*((w - c0 T')/2) + c0 T' = w by ring, hw0, zero_div]
    · rintro ⟨ρ, hρ, rfl⟩
      rw [Set.Finite.mem_toFinset] at hρ
      obtain ⟨hρn, hρz⟩ := hρ
      have hρz2 : gz (2*ρ + c0 T') = 0 := by
        rw [hfd] at hρz
        exact (div_eq_zero_iff.mp hρz).resolve_right hgc0
      refine ⟨hρz2, ?_⟩
      rw [show (2*ρ + c0 T') - c0 T' = 2*ρ by ring, norm_mul]
      simp only [Complex.norm_ofNat]
      linarith
  have hsum : ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w)
      = (1/2 : ℂ) * ∑ ρ ∈ Ff, (analyticOrderNatAt f ρ : ℂ) / (z - ρ) := by
    rw [hFeq, Finset.sum_image (fun a _ b _ hab ↦ hinj hab), Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro ρ _
    have hord : analyticOrderNatAt f ρ = analyticOrderNatAt gz (2*ρ + c0 T') := by
      rw [hfd]
      rw [show (fun w ↦ gz (2*w + c0 T') / gz (c0 T'))
          = fun w ↦ (fun v ↦ gz (2*v + c0 T')) w / gz (c0 T') from rfl]
      rw [analyticOrderNatAt_fun_div_const hgc0 (haffan ρ)]
      exact Stage3.analyticOrderNatAt_fun_comp_affine gz (c0 T') ρ two_ne_zero
    rw [hord]
    have hzρ : u - (2*ρ + c0 T') = (z - ρ) * 2 := by
      rw [hzd]
      ring
    rw [hzρ, ← div_div]
    ring
  have hmain : deriv gz u / gz u - ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w)
      = (1/2 : ℂ) * (deriv f z / f z
          - ∑ ρ ∈ Ff, (analyticOrderNatAt f ρ : ℂ) / (z - ρ)) := by
    rw [hsum, hfder, hfval, mul_sub]
    congr 1
    field_simp
  rw [hmain, norm_mul, show ‖(1/2 : ℂ)‖ = 1/2 by norm_num]
  rw [← hGd] at hFB
  calc (1/2 : ℝ) * ‖deriv f z / f z
        - ∑ ρ ∈ Ff, (analyticOrderNatAt f ρ : ℂ) / (z - ρ)‖
      ≤ (1/2) * (G * Real.log B) :=
        mul_le_mul_of_nonneg_left hFB (by norm_num)
    _ ≤ (1/2) * (G * (A * Real.log T')) := by
        apply mul_le_mul_of_nonneg_left ?_ (by norm_num)
        exact mul_le_mul_of_nonneg_left hlogB hG0.le
    _ = G / 2 * A * Real.log T' := by ring


/-- Away from `1`, the order of `gz` is the order of `ζ` — the factor
`(s−1)²` carries order zero there. -/
theorem gz_order_eq {w : ℂ} (hw : w ≠ 1) :
    analyticOrderNatAt gz w = analyticOrderNatAt riemannZeta w := by
  have h1 : AnalyticAt ℂ (fun s : ℂ ↦ (s - 1)^2) w :=
    (analyticAt_id.sub analyticAt_const).pow 2
  have h2 : AnalyticAt ℂ riemannZeta w := ContourShift.zeta_analyticAt hw
  have h3 : analyticOrderAt (fun s : ℂ ↦ (s - 1)^2) w = 0 := by
    rw [h1.analyticOrderAt_eq_zero]
    intro hcon
    apply hw
    have h4 := pow_eq_zero_iff (n := 2) (by norm_num) |>.mp hcon
    linear_combination h4
  have h5 : analyticOrderAt gz w
      = analyticOrderAt (fun s : ℂ ↦ (s - 1)^2) w + analyticOrderAt riemannZeta w := by
    have h6 : gz = (fun s : ℂ ↦ (s - 1)^2) * riemannZeta := rfl
    rw [h6]
    exact analyticOrderAt_mul h1 h2
  show (analyticOrderAt gz w).toNat = (analyticOrderAt riemannZeta w).toNat
  rw [h5, h3, zero_add]

/-- Every ball zero at heights `≥ 2` is a `ζ`-zero on the open strip,
with ordinate within `46/25` of `T′`. -/
theorem ball_zero_shape {T' : ℝ} (hT' : 2 ≤ T') {w : ℂ}
    (hz : gz w = 0) (hball : ‖w - c0 T'‖ ≤ 46/25) :
    riemannZeta w = 0 ∧ (0 < w.re ∧ w.re < 1) ∧ |w.im - T'| ≤ 46/25 := by
  have hw1 : w ≠ 1 := by
    intro h1
    rw [h1] at hball
    have h2 := Complex.abs_im_le_norm ((1:ℂ) - c0 T')
    have h3 : ((1:ℂ) - c0 T').im = -T' := by
      rw [Complex.sub_im, c0_im, Complex.one_im]
      ring
    rw [h3, abs_neg, abs_of_pos (by linarith : (0:ℝ) < T')] at h2
    linarith
  have hζ : riemannZeta w = 0 := (gz_zero_cases hz).resolve_left hw1
  have h4 := Complex.abs_re_le_norm (w - c0 T')
  rw [Complex.sub_re, c0_re] at h4
  have h5 : |w.re - 3/2| ≤ 46/25 := le_trans h4 hball
  rw [abs_le] at h5
  have h6 := Complex.abs_im_le_norm (w - c0 T')
  rw [Complex.sub_im, c0_im] at h6
  refine ⟨hζ, ⟨?_, ?_⟩, le_trans h6 hball⟩
  · by_contra hle
    push_neg at hle
    exact ContourShift.zeta_ne_zero_of_re_mem (by linarith [h5.1]) hle hζ
  · by_contra hge
    push_neg at hge
    exact riemannZeta_ne_zero_of_one_le_re hge hζ

/-- **The ball order-count**: the total multiplicity of `gz`-zeros in
the `46/25`-ball at height `T′` is `≤ C·log T′` — four Jensen windows
for `T′ ≥ 4` with the reflection charging left-zeros to partners, and
a fixed-rectangle constant for `T′ < 4`. -/
theorem ball_order_sum_le :
    ∃ C : ℝ, 0 < C ∧ ∀ T' : ℝ, 2 ≤ T' →
      (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset,
        (analyticOrderNatAt gz w : ℝ)) ≤ C * Real.log T' := by
  classical
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  -- the fixed low-corner constant
  set lowFin := ContourShift.zeta_zeros_rectangle_finite (0:ℂ)
      ((1:ℝ) + Complex.I * (6:ℝ)) with hlowd
  set M0 : ℝ := ∑ ρ ∈ lowFin.toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ) with hM0d
  have hM00 : 0 ≤ M0 := by
    rw [hM0d]
    apply Finset.sum_nonneg
    intro ρ _
    positivity
  set W0 : ℝ := 15 + 88 / Real.log 2 with hW0d
  have hW00 : 0 < W0 := by
    rw [hW0d]
    positivity
  refine ⟨M0 / Real.log 2 + 8 * W0 + 1, by positivity, ?_⟩
  intro T' hT'
  have hlogT : Real.log 2 ≤ Real.log T' := Real.log_le_log (by norm_num) hT'
  have hlogT0 : 0 < Real.log T' := lt_of_lt_of_le hlog2 hlogT
  set BF := (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset with hBFd
  have hmemBF : ∀ w, w ∈ BF ↔ (gz w = 0 ∧ ‖w - c0 T'‖ ≤ 46/25) := by
    intro w
    rw [hBFd, Set.Finite.mem_toFinset]
    exact Iff.rfl
  -- convert to ζ-orders
  have hconv : ∀ w ∈ BF, (analyticOrderNatAt gz w : ℝ)
      = (analyticOrderNatAt riemannZeta w : ℝ) := by
    intro w hw
    obtain ⟨hz, hball⟩ := (hmemBF w).mp hw
    obtain ⟨hζ, ⟨hre0, hre1⟩, _⟩ := ball_zero_shape hT' hz hball
    have hw1 : w ≠ 1 := by
      intro h
      rw [h] at hre1
      simp at hre1
    rw [gz_order_eq hw1]
  rw [Finset.sum_congr rfl hconv]
  by_cases hT4 : T' < 4
  · -- low case: everything sits in the fixed rectangle
    have hsub : BF ⊆ lowFin.toFinset := by
      intro w hw
      obtain ⟨hz, hball⟩ := (hmemBF w).mp hw
      obtain ⟨hζ, ⟨hre0, hre1⟩, him⟩ := ball_zero_shape hT' hz hball
      rw [hlowd, Set.Finite.mem_toFinset]
      refine ⟨hζ, ?_⟩
      rw [abs_le] at him
      simp only [Rectangle]
      have hzre : (0:ℂ).re = 0 := Complex.zero_re
      have hzim : (0:ℂ).im = 0 := Complex.zero_im
      have hwre : ((1:ℝ) + Complex.I * (6:ℝ) : ℂ).re = 1 := by simp
      have hwim : ((1:ℝ) + Complex.I * (6:ℝ) : ℂ).im = 6 := by simp
      rw [Complex.mem_reProdIm, hzre, hzim, hwre, hwim,
        Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1),
        Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 6),
        Set.mem_Icc, Set.mem_Icc]
      constructor
      · exact ⟨hre0.le, hre1.le⟩
      · constructor <;> linarith [him.1, him.2]
    calc ∑ w ∈ BF, (analyticOrderNatAt riemannZeta w : ℝ)
        ≤ M0 := by
          rw [hM0d]
          apply Finset.sum_le_sum_of_subset_of_nonneg hsub
          intro w _ _
          positivity
      _ ≤ M0 / Real.log 2 * Real.log T' := by
          rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
          exact mul_le_mul_of_nonneg_left hlogT hM00
      _ ≤ (M0 / Real.log 2 + 8 * W0 + 1) * Real.log T' := by
          apply mul_le_mul_of_nonneg_right ?_ hlogT0.le
          nlinarith [hW00]
  · -- high case: four windows and the reflection
    push_neg at hT4
    have hc1 : (2:ℝ) ≤ T' - 9/5 := by linarith
    have hc2 : (2:ℝ) ≤ T' - 9/10 := by linarith
    have hc3 : (2:ℝ) ≤ T' := hT'
    have hc4 : (2:ℝ) ≤ T' + 9/5 := by linarith
    set W : Finset ℂ :=
      ((Stage3.zetaWindow_finite hc1).toFinset ∪ (Stage3.zetaWindow_finite hc2).toFinset)
        ∪ ((Stage3.zetaWindow_finite hc3).toFinset ∪ (Stage3.zetaWindow_finite hc4).toFinset)
      with hWd
    -- the window chooser
    have hchoice : ∀ ρ : ℂ, riemannZeta ρ = 0 → 1/2 ≤ ρ.re → ρ.re < 1 →
        |ρ.im - T'| ≤ 46/25 → ρ ∈ W := by
      intro ρ hζ hre hre1 him
      rw [hWd]
      rw [abs_le] at him
      rcases le_total (ρ.im - T') (-9/10) with h1 | h1
      · apply Finset.mem_union_left
        apply Finset.mem_union_left
        rw [Set.Finite.mem_toFinset]
        apply ContourShift.mem_zetaWindow hζ hre hre1
        rw [abs_le]
        constructor <;> linarith [him.1]
      rcases le_total (ρ.im - T') 0 with h2 | h2
      · apply Finset.mem_union_left
        apply Finset.mem_union_right
        rw [Set.Finite.mem_toFinset]
        apply ContourShift.mem_zetaWindow hζ hre hre1
        rw [abs_le]
        constructor <;> linarith
      rcases le_total (ρ.im - T') (9/10) with h3 | h3
      · apply Finset.mem_union_right
        apply Finset.mem_union_left
        rw [Set.Finite.mem_toFinset]
        apply ContourShift.mem_zetaWindow hζ hre hre1
        rw [abs_le]
        constructor <;> linarith
      · apply Finset.mem_union_right
        apply Finset.mem_union_right
        rw [Set.Finite.mem_toFinset]
        apply ContourShift.mem_zetaWindow hζ hre hre1
        rw [abs_le]
        constructor <;> linarith [him.2]
    -- union sums split
    have hunion_le : ∀ (Aset Bset : Finset ℂ),
        ∑ w ∈ Aset ∪ Bset, (analyticOrderNatAt riemannZeta w : ℝ)
          ≤ (∑ w ∈ Aset, (analyticOrderNatAt riemannZeta w : ℝ))
            + ∑ w ∈ Bset, (analyticOrderNatAt riemannZeta w : ℝ) := by
      intro Aset Bset
      have h5 := Finset.sum_union_inter (s₁ := Aset) (s₂ := Bset)
        (f := fun w ↦ (analyticOrderNatAt riemannZeta w : ℝ))
      have h6 : (0:ℝ) ≤ ∑ w ∈ Aset ∩ Bset, (analyticOrderNatAt riemannZeta w : ℝ) := by
        apply Finset.sum_nonneg
        intro w _
        positivity
      linarith
    have hwinsum : ∀ (T0 : ℝ) (hT0 : 2 ≤ T0),
        (∑ ρ ∈ (Stage3.zetaWindow_finite hT0).toFinset,
          (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ 15 * Real.log T0 + 73 :=
      fun T0 hT0 ↦ Stage3.zeta_local_zero_count hT0
    have hlogmono : ∀ (T0 : ℝ), 2 ≤ T0 → T0 ≤ T' + 9/5 →
        15 * Real.log T0 + 73 ≤ W0 * Real.log T' := by
      intro T0 hT0 hT0le
      have h7 : Real.log T0 ≤ Real.log (2 * T') := by
        apply Real.log_le_log (by linarith)
        linarith
      rw [Real.log_mul (by norm_num) (by linarith)] at h7
      have h8 : Real.log 2 ≤ 1 := by
        have := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 2)
        linarith
      have h9 : (73:ℝ) ≤ 73 / Real.log 2 * Real.log T' := by
        rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
        nlinarith
      have h10 : (15:ℝ) ≤ 15 / Real.log 2 * Real.log T' := by
        rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
        nlinarith
      have h13 : 15 * Real.log T0 ≤ 15 * (Real.log 2 + Real.log T') := by linarith
      have h11 : 73 / Real.log 2 * Real.log T' + 15 / Real.log 2 * Real.log T'
          = 88 / Real.log 2 * Real.log T' := by ring
      rw [hW0d, show (15 + 88 / Real.log 2) * Real.log T'
          = 15 * Real.log T' + 88 / Real.log 2 * Real.log T' by ring]
      linarith
    have hWsum : (∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ))
        ≤ 4 * (W0 * Real.log T') := by
      rw [hWd]
      calc ∑ w ∈ _ ∪ _, (analyticOrderNatAt riemannZeta w : ℝ)
          ≤ _ := hunion_le _ _
        _ ≤ (W0 * Real.log T') + (W0 * Real.log T')
            + ((W0 * Real.log T') + (W0 * Real.log T')) := by
            apply add_le_add
            · apply le_trans (hunion_le _ _)
              apply add_le_add
              · exact le_trans (hwinsum _ hc1) (hlogmono _ hc1 (by linarith))
              · exact le_trans (hwinsum _ hc2) (hlogmono _ hc2 (by linarith))
            · apply le_trans (hunion_le _ _)
              apply add_le_add
              · exact le_trans (hwinsum _ hc3) (hlogmono _ hc3 (by linarith))
              · exact le_trans (hwinsum _ hc4) (hlogmono _ hc4 (by linarith))
        _ = 4 * (W0 * Real.log T') := by ring
    -- split by half-plane
    rw [← Finset.sum_filter_add_sum_filter_not BF (fun w ↦ 1/2 ≤ w.re)]
    have hpart1 : (∑ w ∈ BF.filter (fun w ↦ 1/2 ≤ w.re),
        (analyticOrderNatAt riemannZeta w : ℝ))
          ≤ ∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ) := by
      apply Finset.sum_le_sum_of_subset_of_nonneg
      · intro w hw
        rw [Finset.mem_filter] at hw
        obtain ⟨hwBF, hwre⟩ := hw
        obtain ⟨hz, hball⟩ := (hmemBF w).mp hwBF
        obtain ⟨hζ, ⟨hre0, hre1⟩, him⟩ := ball_zero_shape hT' hz hball
        exact hchoice w hζ hwre hre1 him
      · intro w _ _
        positivity
    have hpart2 : (∑ w ∈ BF.filter (fun w ↦ ¬(1/2 ≤ w.re)),
        (analyticOrderNatAt riemannZeta w : ℝ))
          ≤ ∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ) := by
      have hrinj : Function.Injective (fun w : ℂ ↦ 1 - (starRingEnd ℂ) w) := by
        intro a b hab
        have h11 : (starRingEnd ℂ) a = (starRingEnd ℂ) b := by
          have h12 : (1:ℂ) - (starRingEnd ℂ) a = 1 - (starRingEnd ℂ) b := hab
          linear_combination -h12
        have h13 := congrArg (starRingEnd ℂ) h11
        rwa [Complex.conj_conj, Complex.conj_conj] at h13
      have hsum_refl : (∑ w ∈ BF.filter (fun w ↦ ¬(1/2 ≤ w.re)),
          (analyticOrderNatAt riemannZeta w : ℝ))
            = ∑ w ∈ (BF.filter (fun w ↦ ¬(1/2 ≤ w.re))).image
                (fun w ↦ 1 - (starRingEnd ℂ) w),
              (analyticOrderNatAt riemannZeta w : ℝ) := by
        rw [Finset.sum_image (fun a _ b _ hab ↦ hrinj hab)]
        apply Finset.sum_congr rfl
        intro w hw
        rw [Finset.mem_filter] at hw
        obtain ⟨hwBF, hwre⟩ := hw
        obtain ⟨hz, hball⟩ := (hmemBF w).mp hwBF
        obtain ⟨hζ, ⟨hre0, hre1⟩, _⟩ := ball_zero_shape hT' hz hball
        rw [ContourShift.zeta_order_reflect hre0 hre1]
      rw [hsum_refl]
      apply Finset.sum_le_sum_of_subset_of_nonneg
      · intro w' hw'
        rw [Finset.mem_image] at hw'
        obtain ⟨w, hw, rfl⟩ := hw'
        rw [Finset.mem_filter] at hw
        obtain ⟨hwBF, hwre⟩ := hw
        push_neg at hwre
        obtain ⟨hz, hball⟩ := (hmemBF w).mp hwBF
        obtain ⟨hζ, ⟨hre0, hre1⟩, him⟩ := ball_zero_shape hT' hz hball
        -- the reflected point is a zero at the same height, re ∈ (1/2, 1)
        have hcw : riemannZeta ((starRingEnd ℂ) w) = 0 := by
          rw [riemannZeta_conj, hζ, map_zero]
        have hwn : ∀ n : ℕ, (starRingEnd ℂ) w ≠ -(n:ℂ) := by
          intro n hcon
          have h14 := congrArg Complex.re hcon
          simp only [Complex.conj_re, Complex.neg_re, Complex.natCast_re] at h14
          have h15 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
          linarith
        have hw1c : (starRingEnd ℂ) w ≠ 1 := by
          intro hcon
          have h16 := congrArg Complex.re hcon
          simp only [Complex.conj_re, Complex.one_re] at h16
          linarith
        have hfe := riemannZeta_one_sub hwn hw1c
        rw [hcw, mul_zero] at hfe
        have hre' : (1 - (starRingEnd ℂ) w).re = 1 - w.re := by
          simp [Complex.sub_re, Complex.conj_re]
        have him' : (1 - (starRingEnd ℂ) w).im = w.im := by
          simp [Complex.sub_im, Complex.conj_im]
        apply hchoice _ hfe
        · rw [hre']
          linarith
        · rw [hre']
          linarith
        · rw [him']
          exact him
      · intro w _ _
        positivity
    calc (∑ w ∈ BF.filter (fun w ↦ 1/2 ≤ w.re),
          (analyticOrderNatAt riemannZeta w : ℝ))
        + ∑ w ∈ BF.filter (fun w ↦ ¬(1/2 ≤ w.re)),
          (analyticOrderNatAt riemannZeta w : ℝ)
        ≤ (∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ))
          + ∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ) :=
          add_le_add hpart1 hpart2
      _ ≤ 4 * (W0 * Real.log T') + 4 * (W0 * Real.log T') := by
          linarith [hWsum]
      _ ≤ (M0 / Real.log 2 + 8 * W0 + 1) * Real.log T' := by
          have h17 : 0 ≤ M0 / Real.log 2 * Real.log T' := by positivity
          nlinarith [hlogT0]

/-- The log-derivative identity: `gz′/gz = 2/(s−1) + ζ′/ζ` away from
the pole and the zeros. -/
theorem gz_logderiv {u : ℂ} (hu1 : u ≠ 1) (huζ : riemannZeta u ≠ 0) :
    deriv gz u / gz u = 2/(u - 1) + deriv riemannZeta u / riemannZeta u := by
  have hu1' : u - 1 ≠ 0 := sub_ne_zero.mpr hu1
  have h1 : HasDerivAt (fun s : ℂ ↦ (s-1)^2) (2*(u-1)) u := by
    have h2 : HasDerivAt (fun s : ℂ ↦ s - 1) 1 u := (hasDerivAt_id u).sub_const 1
    have h3 := h2.mul h2
    have h4 : (fun s : ℂ ↦ (s - 1)^2) = fun s : ℂ ↦ (s-1)*(s-1) := by
      funext y
      ring
    have h5 : (1:ℂ) * (u - 1) + (u - 1) * 1 = 2*(u-1) := by ring
    rw [h4, ← h5]
    exact h3
  have h6 : HasDerivAt riemannZeta (deriv riemannZeta u) u :=
    (differentiableAt_riemannZeta hu1).hasDerivAt
  have h7 : HasDerivAt gz (2*(u-1) * riemannZeta u + (u-1)^2 * deriv riemannZeta u) u :=
    h1.mul h6
  rw [h7.deriv]
  show (2*(u-1) * riemannZeta u + (u-1)^2 * deriv riemannZeta u) / ((u - 1)^2 * riemannZeta u)
      = 2/(u - 1) + deriv riemannZeta u / riemannZeta u
  field_simp

/-- Conjugation transfers the derivative of `ζ`. -/
theorem deriv_zeta_conj {s : ℂ} (hs : s ≠ 1) :
    deriv riemannZeta ((starRingEnd ℂ) s) = (starRingEnd ℂ) (deriv riemannZeta s) := by
  have h1 := (differentiableAt_riemannZeta hs).hasDerivAt.conj_conj
  have h2 : (starRingEnd ℂ) ∘ riemannZeta ∘ (starRingEnd ℂ) = riemannZeta := by
    funext w
    show (starRingEnd ℂ) (riemannZeta ((starRingEnd ℂ) w)) = riemannZeta w
    rw [riemannZeta_conj, Complex.conj_conj]
  rw [h2] at h1
  exact h1.deriv

/-- **The pointwise edge bound, unified.** For `u` on the band
`re ∈ [−1/4, 2]` at height `t ≥ 2`, with a lower bound `δ ≤ 1` on the
distance from `u` to every ball zero: `‖ζ′/ζ(u)‖ ≤ C·(log t)/δ + C·log t`.
Both edges specialize this: the left edge with `δ = 1/4`, the good
horizontals with `δ = zeroGap T`. -/
theorem edge_bound_core :
    ∃ C : ℝ, 0 < C ∧ ∀ t : ℝ, 2 ≤ t → ∀ u : ℂ,
      u.im = t → -1/4 ≤ u.re → u.re ≤ 2 →
      riemannZeta u ≠ 0 →
      ∀ δ : ℝ, 0 < δ → δ ≤ 1 →
      (∀ w ∈ (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset,
        δ ≤ ‖u - w‖) →
      ‖deriv riemannZeta u / riemannZeta u‖ ≤ C * Real.log t / δ := by
  classical
  obtain ⟨C1, hC10, hC1⟩ := gz_partial_fraction
  obtain ⟨C2, hC20, hC2⟩ := ball_order_sum_le
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine ⟨C1 + C2 + 1/Real.log 2, by positivity, ?_⟩
  intro t ht u huim hure1 hure2 huζ δ hδ0 hδ1 hδ
  have hlogt : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) ht
  have hlogt0 : 0 < Real.log t := lt_of_lt_of_le hlog2 hlogt
  have hu1 : u ≠ 1 := by
    intro h
    have h2 := congrArg Complex.im h
    rw [huim, Complex.one_im] at h2
    linarith
  have hugz : gz u ≠ 0 := by
    rw [gz]
    exact mul_ne_zero (pow_ne_zero _ (sub_ne_zero.mpr hu1)) huζ
  have hPF := hC1 t ht u huim hure1 hure2 hugz
  set BF := (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset with hBFd
  have hSumBound : ‖∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
      ≤ C2 * Real.log t / δ := by
    calc ‖∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
        ≤ ∑ w ∈ BF, ‖(analyticOrderNatAt gz w : ℂ) / (u - w)‖ := norm_sum_le _ _
      _ ≤ ∑ w ∈ BF, (analyticOrderNatAt gz w : ℝ) / δ := by
          apply Finset.sum_le_sum
          intro w hw
          have hdist := hδ w hw
          rw [norm_div, Complex.norm_natCast]
          apply div_le_div_of_nonneg_left ?_ hδ0 hdist
          positivity
      _ = (∑ w ∈ BF, (analyticOrderNatAt gz w : ℝ)) / δ := by
          rw [Finset.sum_div]
      _ ≤ C2 * Real.log t / δ := by
          gcongr
          exact hC2 t ht
  have hld := gz_logderiv hu1 huζ
  have hpole : ‖(2:ℂ)/(u - 1)‖ ≤ 1 := by
    rw [norm_div]
    have h7 := Complex.abs_im_le_norm (u - 1)
    have h8 : (u - 1).im = t := by
      rw [Complex.sub_im, huim, Complex.one_im, sub_zero]
    rw [h8, abs_of_pos (by linarith : (0:ℝ) < t)] at h7
    rw [div_le_one (by linarith : (0:ℝ) < ‖u - 1‖)]
    simp only [Complex.norm_ofNat]
    linarith
  have hsplit : deriv riemannZeta u / riemannZeta u
      = (deriv gz u / gz u
          - ∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
        + (∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
        - (2:ℂ)/(u - 1) := by
    rw [hld]
    ring
  rw [hsplit]
  have htri : ‖(deriv gz u / gz u
        - ∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
      + (∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
      - (2:ℂ)/(u - 1)‖
      ≤ ‖deriv gz u / gz u
          - ∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
        + ‖∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
        + ‖(2:ℂ)/(u - 1)‖ := by
    calc ‖_ + _ - _‖ ≤ ‖_ + _‖ + ‖(2:ℂ)/(u - 1)‖ := norm_sub_le _ _
      _ ≤ _ := by
          have := norm_add_le (deriv gz u / gz u
            - ∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
            (∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
          linarith
  calc ‖_‖ ≤ _ := htri
    _ ≤ C1 * Real.log t + C2 * Real.log t / δ + 1 := by
        have h9 := hPF
        linarith [hSumBound, hpole]
    _ ≤ (C1 + C2 + 1/Real.log 2) * Real.log t / δ := by
        have h10 : C1 * Real.log t ≤ C1 * Real.log t / δ := by
          rw [le_div_iff₀ hδ0]
          have hX : (0:ℝ) ≤ C1 * Real.log t := by positivity
          nlinarith
        have h11 : (1:ℝ) ≤ (1/Real.log 2) * Real.log t / δ := by
          rw [le_div_iff₀ hδ0]
          have h12 : (1:ℝ) ≤ (1/Real.log 2) * Real.log t := by
            rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
            linarith
          nlinarith
        have h13 : (C1 + C2 + 1/Real.log 2) * Real.log t / δ
            = C1 * Real.log t / δ + C2 * Real.log t / δ
              + (1/Real.log 2) * Real.log t / δ := by
          field_simp
        rw [h13]
        linarith


/-- info: 'EdgeBound.ball_order_sum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ball_order_sum_le

/-- info: 'EdgeBound.gz_partial_fraction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gz_partial_fraction

/-- info: 'EdgeBound.edge_bound_core' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms edge_bound_core

/-- info: 'EdgeBound.gz_logderiv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gz_logderiv

/-- info: 'EdgeBound.deriv_zeta_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms deriv_zeta_conj

end EdgeBound
