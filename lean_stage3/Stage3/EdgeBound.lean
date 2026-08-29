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

/-- info: 'EdgeBound.gz_partial_fraction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gz_partial_fraction

end EdgeBound
