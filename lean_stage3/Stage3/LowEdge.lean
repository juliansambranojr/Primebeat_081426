/-
LowEdge — block E7d of `lean_stage3/design/joints.md`. 2026-11-22.

The logarithmic derivative of ζ on the short segment `Re s = −1/4`, `|t| ≤ 2`,
bounded by a numeral. `Glue.edge_left_bound` takes that supremum `Mc` from
compactness. `EdgeBound.gz_partial_fraction` gives the bound at heights `≥ 2`
because its right side is `C·log T′`; at heights in `[0, 2]` the same proof,
with `BoxBounds.sq_zeta_band_explicit` above and `gz_c0_lower` below, gives a
constant.

  low_ball_count_wide          0 ≤ T′ ≤ 2 ⊢ Σ over gz-zeros within 46/25 of c0 T′
                                 of the order ≤ 250
  gz_partial_fraction_low      0 ≤ T′ ≤ 2, u at height T′, −1/4 ≤ Re u ≤ 2, gz u ≠ 0
                                 ⊢ ‖gz′/gz(u) − Σ order/(u − w)‖ ≤ 1617537
  logDerivZeta_low_edge        0 ≤ t ≤ 2, Re u = −1/4, Im u = t ⊢ ‖ζ′/ζ(u)‖ ≤ 1620000
  logDerivZeta_short_segment   |t| ≤ 2 ⊢ ‖ζ′/ζ(−1/4 + it)‖ ≤ 1620000

`low_ball_count_wide` is `low_ball_count` at the partial fraction's radii;
`gz_partial_fraction_low` is `gz_partial_fraction`'s body with the height
bounded above (`LOOP.md` § 3). `EdgeBound.lean` is untouched.

What the next slice needs: the constants of the explicit formula written as
definitions, now that every quantity under them has a numeral.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LowCount

namespace EdgeBound

open Complex Topology Set

set_option maxHeartbeats 800000 in
/-- **Jensen's count at a low height, on the partial fraction's ball.** -/
theorem low_ball_count_wide {T' : ℝ} (h0 : 0 ≤ T') (h6 : T' ≤ 2) :
    (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 46 / 25)).toFinset,
      (analyticOrderNatAt gz w : ℝ)) ≤ 250 := by
  classical
  have hlow := gz_c0_lower T'
  have hgc0 : gz (c0 T') ≠ 0 := by
    rw [← norm_pos_iff]
    linarith
  set f : ℂ → ℂ := fun w ↦ gz (2 * w + c0 T') / gz (c0 T') with hfd
  have haffan : ∀ w : ℂ, AnalyticAt ℂ (fun w : ℂ ↦ gz (2 * w + c0 T')) w := by
    intro w
    have h7 : (fun w : ℂ ↦ gz (2 * w + c0 T')) = gz ∘ (fun w ↦ 2 * w + c0 T') := rfl
    rw [h7]
    exact (gz_analytic _).comp ((analyticAt_const.mul analyticAt_id).add analyticAt_const)
  have hfan : ∀ w : ℂ, AnalyticAt ℂ f w := by
    intro w
    rw [hfd]
    exact (haffan w).div analyticAt_const hgc0
  have hfAnalytic : AnalyticOnNhd ℂ f (Metric.closedBall (0 : ℂ) 1) := fun w _ ↦ hfan w
  have hf0 : f 0 = 1 := by
    rw [hfd]
    simp only [mul_zero, zero_add]
    exact div_self hgc0
  have hinj : Function.Injective (fun ρ : ℂ ↦ 2 * ρ + c0 T') := by
    intro a b hab
    have h8 : (2 : ℂ) * a = 2 * b := by
      have h9 : (2 : ℂ) * a + c0 T' = 2 * b + c0 T' := hab
      linear_combination h9
    exact mul_left_cancel₀ two_ne_zero h8
  have hball2 := gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 2)
  have hfin : (SetOfZeros 1 f).Finite := by
    apply Set.Finite.subset (Set.Finite.preimage hinj.injOn hball2)
    rintro ρ ⟨hρn, hρz⟩
    show gz (2 * ρ + c0 T') = 0 ∧ ‖(2 * ρ + c0 T') - c0 T'‖ ≤ 2
    have hρz2 : gz (2 * ρ + c0 T') = 0 := by
      rw [hfd] at hρz
      exact (div_eq_zero_iff.mp hρz).resolve_right hgc0
    refine ⟨hρz2, ?_⟩
    rw [show (2 * ρ + c0 T') - c0 T' = 2 * ρ by ring, norm_mul]
    simp only [Complex.norm_ofNat]
    linarith
  have hfz_bound : ∀ z : ℂ, ‖z‖ ≤ (49 / 50 : ℝ) → ‖f z‖ ≤ 2449440 := by
    intro z hzn
    rw [hfd]
    show ‖gz (2 * z + c0 T') / gz (c0 T')‖ ≤ 2449440
    rw [norm_div, div_le_iff₀ (norm_pos_iff.mpr hgc0)]
    have h10 := Complex.abs_re_le_norm z
    have h12 := Complex.abs_im_le_norm z
    have h11 : (2 * z + c0 T').re = 2 * z.re + 3 / 2 := by
      simp [Complex.add_re, Complex.mul_re, c0_re]
    have h13 : (2 * z + c0 T').im = 2 * z.im + T' := by
      simp [Complex.add_im, Complex.mul_im, c0_im]
    have h10' : |z.re| ≤ 49 / 50 := le_trans h10 hzn
    have h12' : |z.im| ≤ 49 / 50 := le_trans h12 hzn
    rw [abs_le] at h10' h12'
    have h14 := BoxBounds.sq_zeta_band_explicit (s := 2 * z + c0 T')
      (by rw [h11]; linarith [h10'.1]) (by rw [h11]; linarith [h10'.2])
    have h15im : |(2 * z + c0 T').im| ≤ 4 := by
      rw [h13, abs_le]
      constructor <;> linarith [h12'.1, h12'.2]
    have h15 : (2 + |(2 * z + c0 T').im|) ^ 4 ≤ (6 : ℝ) ^ 4 := by
      apply pow_le_pow_left₀ (by positivity)
      linarith
    have h16 : (6 : ℝ) ^ 4 ≤ 1296 := by norm_num
    have h20 : ‖gz (2 * z + c0 T')‖ ≤ 174960 := by
      calc ‖gz (2 * z + c0 T')‖ ≤ 135 * (2 + |(2 * z + c0 T').im|) ^ 4 := h14
        _ ≤ 135 * 1296 := by linarith
        _ = 174960 := by norm_num
    calc ‖gz (2 * z + c0 T')‖ ≤ 174960 := h20
      _ = 2449440 * (1 / 14) := by norm_num
      _ ≤ 2449440 * ‖gz (c0 T')‖ := mul_le_mul_of_nonneg_left hlow (by norm_num)
  have hrlt1 : (23 : ℝ) / 25 < 1 := by norm_num
  have hZB := ZerosBound (B := 2449440) (r := 23 / 25) (R := 49 / 50) (f := f)
    (by norm_num) hrlt1 (by norm_num) (by norm_num) hfAnalytic hf0 hfin hfz_bound
  rw [Nat.cast_sum, show (49 : ℝ) / 50 / (23 / 25) = 49 / 46 by norm_num] at hZB
  set Fg := (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 46 / 25)).toFinset with hFgd
  set Ff := (finiteSetOfZeros_mono hrlt1 hfin).toFinset with hFfd
  have hFeq : Fg = Ff.image (fun ρ ↦ 2 * ρ + c0 T') := by
    ext w
    rw [hFgd, hFfd, Set.Finite.mem_toFinset, Finset.mem_image]
    constructor
    · rintro ⟨hw0, hwball⟩
      refine ⟨(w - c0 T') / 2, ?_, by ring⟩
      rw [Set.Finite.mem_toFinset]
      constructor
      · rw [norm_div]
        simp only [Complex.norm_ofNat]
        linarith
      · rw [hfd]
        show gz (2 * ((w - c0 T') / 2) + c0 T') / gz (c0 T') = 0
        rw [show 2 * ((w - c0 T') / 2) + c0 T' = w by ring, hw0, zero_div]
    · rintro ⟨ρ, hρ, rfl⟩
      rw [Set.Finite.mem_toFinset] at hρ
      obtain ⟨hρn, hρz⟩ := hρ
      have hρz2 : gz (2 * ρ + c0 T') = 0 := by
        rw [hfd] at hρz
        exact (div_eq_zero_iff.mp hρz).resolve_right hgc0
      refine ⟨hρz2, ?_⟩
      rw [show (2 * ρ + c0 T') - c0 T' = 2 * ρ by ring, norm_mul]
      simp only [Complex.norm_ofNat]
      linarith
  have hsum : ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℝ)
      = ∑ ρ ∈ Ff, (analyticOrderNatAt f ρ : ℝ) := by
    rw [hFeq, Finset.sum_image (fun a _ b _ hab ↦ hinj hab)]
    apply Finset.sum_congr rfl
    intro ρ _
    have hord : analyticOrderNatAt f ρ = analyticOrderNatAt gz (2 * ρ + c0 T') := by
      rw [hfd]
      rw [show (fun w ↦ gz (2 * w + c0 T') / gz (c0 T'))
          = fun w ↦ (fun v ↦ gz (2 * v + c0 T')) w / gz (c0 T') from rfl]
      rw [analyticOrderNatAt_fun_div_const hgc0 (haffan ρ)]
      exact Stage3.analyticOrderNatAt_fun_comp_affine gz (c0 T') ρ two_ne_zero
    rw [hord]
  rw [hsum]
  have hlog1 : (3 : ℝ) / 49 ≤ Real.log (49 / 46) := by
    have h1 : Real.log (46 / 49) ≤ 46 / 49 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (49 : ℝ) / 46 = ((46 : ℝ) / 49)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hlog1pos : (0 : ℝ) < Real.log (49 / 46) := by linarith
  have hlogB : Real.log 2449440 ≤ 15.25 := by
    have h2 : Real.log 2449440 ≤ Real.log 4194304 :=
      Real.log_le_log (by norm_num) (by norm_num)
    have h3 : Real.log 4194304 = 22 * Real.log 2 := by
      rw [show (4194304 : ℝ) = 2 ^ (22 : ℕ) by norm_num, Real.log_pow]
      norm_num
    have h4 := Real.log_two_lt_d9
    linarith
  have hlogBnn : (0 : ℝ) ≤ Real.log 2449440 := Real.log_nonneg (by norm_num)
  have hinv : 1 / Real.log (49 / 46) ≤ 49 / 3 := by
    rw [div_le_iff₀ hlog1pos]
    nlinarith
  calc ∑ ρ ∈ Ff, (analyticOrderNatAt f ρ : ℝ)
      ≤ 1 / Real.log (49 / 46) * Real.log 2449440 := hZB
    _ ≤ 49 / 3 * 15.25 := mul_le_mul hinv hlogB hlogBnn (by norm_num)
    _ ≤ 250 := by norm_num

set_option maxHeartbeats 1600000 in
/-- **The partial fraction at a low height**, with a numeral. -/
theorem gz_partial_fraction_low {T' : ℝ} (h0T : 0 ≤ T') (h2T : T' ≤ 2) (u : ℂ)
    (him : u.im = T') (hre1 : -1/4 ≤ u.re) (hre2 : u.re ≤ 2) (hune : gz u ≠ 0) :
    ‖deriv gz u / gz u
        - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset,
            (analyticOrderNatAt gz w : ℂ) / (u - w)‖
      ≤ 1617537 := by
  classical
  set G : ℝ := 16 * (23/25:ℝ) ^ 2 / ((23/25:ℝ) - 22/25) ^ 3
      + 1 / (((49/50:ℝ) ^ 2 / (19/20) - 19/20) * Real.log ((49/50:ℝ) / (19/20))) with hGd
  have hlogR : (3:ℝ) / 98 ≤ Real.log ((49/50:ℝ) / (19/20)) := by
    have h1 : Real.log (95 / 98) ≤ 95 / 98 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show ((49/50:ℝ) / (19/20)) = ((95:ℝ) / 98)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hG0 : 0 < G := by
    rw [hGd]
    have h1 : (0:ℝ) < Real.log ((49/50:ℝ) / (19/20)) := by linarith
    have h2 : (0:ℝ) < (49/50:ℝ) ^ 2 / (19/20) - 19/20 := by norm_num
    positivity
  have hGle : G ≤ 212136 := by
    rw [hGd]
    have e1 : 16 * (23/25:ℝ) ^ 2 / ((23/25:ℝ) - 22/25) ^ 3 = 211600 := by norm_num
    have e2 : ((49/50:ℝ) ^ 2 / (19/20) - 19/20) = 579 / 9500 := by norm_num
    have e3 : 1 / ((579 / 9500 : ℝ) * Real.log ((49/50:ℝ) / (19/20))) ≤ 536 := by
      rw [div_le_iff₀ (by positivity)]
      nlinarith
    rw [e1, e2]
    linarith
  have hlogB : Real.log 2449440 ≤ 15.25 := by
    have h2 : Real.log 2449440 ≤ Real.log 4194304 :=
      Real.log_le_log (by norm_num) (by norm_num)
    have h3 : Real.log 4194304 = 22 * Real.log 2 := by
      rw [show (4194304 : ℝ) = 2 ^ (22 : ℕ) by norm_num, Real.log_pow]
      norm_num
    have h4 := Real.log_two_lt_d9
    linarith
  have hlogBnn : (0 : ℝ) ≤ Real.log 2449440 := Real.log_nonneg (by norm_num)
  clear_value G
  have hlow := gz_c0_lower T'
  have hgc0 : gz (c0 T') ≠ 0 := by
    rw [← norm_pos_iff]
    linarith
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
  have hfz_bound : ∀ z : ℂ, ‖z‖ ≤ (49/50:ℝ) → ‖f z‖ ≤ 2449440 := by
    intro z hzn
    rw [hfd]
    show ‖gz (2*z + c0 T') / gz (c0 T')‖ ≤ 2449440
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
    have h14 := BoxBounds.sq_zeta_band_explicit (s := 2*z + c0 T')
      (by rw [h11]; linarith [h10'.1]) (by rw [h11]; linarith [h10'.2])
    have h15im : |(2*z + c0 T').im| ≤ 4 := by
      rw [h13, abs_le]
      constructor <;> linarith [h12'.1, h12'.2]
    have h15 : (2 + |(2*z + c0 T').im|) ^ 4 ≤ (6:ℝ) ^ 4 := by
      apply pow_le_pow_left₀ (by positivity)
      linarith
    have h16 : (6:ℝ) ^ 4 ≤ 1296 := by norm_num
    have h20 : ‖gz (2*z + c0 T')‖ ≤ 174960 := by
      calc ‖gz (2*z + c0 T')‖ ≤ 135 * (2 + |(2*z + c0 T').im|) ^ 4 := h14
        _ ≤ 135 * 1296 := by linarith
        _ = 174960 := by norm_num
    calc ‖gz (2*z + c0 T')‖ ≤ 174960 := h20
      _ = 2449440 * (1/14) := by norm_num
      _ ≤ 2449440 * ‖gz (c0 T')‖ := mul_le_mul_of_nonneg_left hlow (by norm_num)
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
  have hFB := FinalBound (B := 2449440) (r' := 22/25) (r := 23/25) (R' := 19/20) (R := 49/50)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
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
      ≤ (1/2) * (G * Real.log 2449440) :=
        mul_le_mul_of_nonneg_left hFB (by norm_num)
    _ ≤ (1/2) * (212136 * 15.25) := by
        apply mul_le_mul_of_nonneg_left ?_ (by norm_num)
        exact mul_le_mul hGle hlogB hlogBnn (by norm_num)
    _ = 1617537 := by norm_num

/-- **The short segment, upper half.** -/
theorem logDerivZeta_low_edge {t : ℝ} (h0 : 0 ≤ t) (h2 : t ≤ 2) {u : ℂ}
    (hre : u.re = -1/4) (him : u.im = t) :
    ‖deriv riemannZeta u / riemannZeta u‖ ≤ 1620000 := by
  classical
  have hu1 : u ≠ 1 := by
    intro h
    have h3 := congrArg Complex.re h
    rw [hre, Complex.one_re] at h3
    norm_num at h3
  have huζ : riemannZeta u ≠ 0 :=
    ContourShift.zeta_ne_zero_of_re_mem (by rw [hre]; norm_num) (by rw [hre]; norm_num)
  have hgz : gz u ≠ 0 := mul_ne_zero (pow_ne_zero 2 (sub_ne_zero.mpr hu1)) huζ
  have hpf := gz_partial_fraction_low h0 h2 u him (by rw [hre]) (by rw [hre]; norm_num) hgz
  have hcount := low_ball_count_wide h0 h2
  set Fg := (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset with hFgd
  have hdist : ∀ w ∈ Fg, (1:ℝ)/4 ≤ ‖u - w‖ := by
    intro w hw
    rw [hFgd, Set.Finite.mem_toFinset] at hw
    obtain ⟨hz, hball⟩ := hw
    have habs := Complex.abs_re_le_norm (u - w)
    rw [Complex.sub_re, hre] at habs
    have hwre : 0 < w.re := by
      rcases gz_zero_cases hz with h1 | h1
      · rw [h1]
        norm_num
      · by_contra hle
        push_neg at hle
        have h4 := Complex.abs_re_le_norm (w - c0 t)
        rw [Complex.sub_re, c0_re] at h4
        have h5 : |w.re - 3/2| ≤ 46/25 := le_trans h4 hball
        rw [abs_le] at h5
        exact ContourShift.zeta_ne_zero_of_re_mem (by linarith [h5.1]) hle h1
    have h6 : (1:ℝ)/4 ≤ |(-1/4:ℝ) - w.re| := by
      rw [abs_sub_comm, abs_of_pos (by linarith)]
      linarith
    linarith
  have hsum : ‖∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w)‖ ≤ 4 * 250 := by
    calc ‖∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
        ≤ ∑ w ∈ Fg, ‖(analyticOrderNatAt gz w : ℂ) / (u - w)‖ := norm_sum_le _ _
      _ ≤ ∑ w ∈ Fg, 4 * (analyticOrderNatAt gz w : ℝ) := by
          apply Finset.sum_le_sum
          intro w hw
          have hd := hdist w hw
          have hpos : (0:ℝ) < ‖u - w‖ := by linarith
          rw [norm_div, Complex.norm_natCast, div_le_iff₀ hpos]
          have hn : (0:ℝ) ≤ (analyticOrderNatAt gz w : ℝ) := Nat.cast_nonneg _
          nlinarith
      _ = 4 * ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℝ) := by rw [Finset.mul_sum]
      _ ≤ 4 * 250 := by linarith
  have hpole : ‖(2:ℂ) / (u - 1)‖ ≤ 8/5 := by
    have habs := Complex.abs_re_le_norm (u - 1)
    rw [Complex.sub_re, hre, Complex.one_re] at habs
    have h7 : |(-1/4:ℝ) - 1| = 5/4 := by norm_num
    rw [h7] at habs
    rw [norm_div, Complex.norm_ofNat, div_le_iff₀ (by linarith)]
    linarith
  have hld := gz_logderiv hu1 huζ
  have heq : deriv riemannZeta u / riemannZeta u
      = (deriv gz u / gz u - ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w))
        + ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w) - 2 / (u - 1) := by
    rw [hld]
    ring
  rw [heq]
  calc ‖(deriv gz u / gz u - ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w))
        + ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w) - 2 / (u - 1)‖
      ≤ ‖(deriv gz u / gz u - ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w))
          + ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w)‖ + ‖(2:ℂ) / (u - 1)‖ :=
        norm_sub_le _ _
    _ ≤ ‖deriv gz u / gz u - ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
          + ‖∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w)‖ + ‖(2:ℂ) / (u - 1)‖ := by
        linarith [norm_add_le (deriv gz u / gz u
          - ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w))
          (∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w))]
    _ ≤ 1617537 + 4 * 250 + 8/5 := by linarith
    _ ≤ 1620000 := by norm_num

/-- **`Mc`, bounded by a numeral**: the short segment, both signs. -/
theorem logDerivZeta_short_segment {t : ℝ} (ht : |t| ≤ 2) :
    ‖deriv riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)
        / riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)‖ ≤ 1620000 := by
  set u : ℂ := ((-1/4 : ℝ):ℂ) + t * Complex.I with hud
  have hure : u.re = -1/4 := by rw [hud]; simp
  have huim : u.im = t := by rw [hud]; simp
  rcases le_or_gt 0 t with htp | htn
  · exact logDerivZeta_low_edge htp (le_trans (le_abs_self t) ht) hure huim
  · set v : ℂ := ((-1/4 : ℝ):ℂ) + (|t|) * Complex.I with hvd
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
      rw [← hconj, deriv_zeta_conj hv1, riemannZeta_conj, ← map_div₀, RCLike.norm_conj]
    rw [h15]
    exact logDerivZeta_low_edge (abs_nonneg t) ht hvre hvim

/-- info: 'EdgeBound.low_ball_count_wide' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms low_ball_count_wide

/-- info: 'EdgeBound.gz_partial_fraction_low' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gz_partial_fraction_low

/-- info: 'EdgeBound.logDerivZeta_short_segment' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms logDerivZeta_short_segment

end EdgeBound
