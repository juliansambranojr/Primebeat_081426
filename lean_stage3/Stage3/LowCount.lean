/-
LowCount — block E7c of `lean_stage3/design/joints.md`. 2026-11-22.

The zeros of ζ below height six, counted. `EdgeBound.ball_order_sum_le` takes
their number `M0` as a finite sum with no numeral; here it is bounded by
Jensen's count (upstream `ZerosBound`) on six discs about `3/2 + i(j + 1/2)`,
`j = 0, …, 5`, each of radius `8/5`, with the pole cleared (`gz`).

  gz_c0_lower      1/14 ≤ ‖gz (c0 T′)‖, every T′
  low_ball_count   0 ≤ T′ ≤ 6 ⊢ Σ over gz-zeros within 8/5 of c0 T′ of the order ≤ 119
  low_rect_count   Σ over ζ-zeros in [0,1] × [0,6] of the order ≤ 714

Inputs: `BoxBounds.sq_zeta_band_explicit` for the upper bound on the disc and
`BoxBounds.zeta_ratio_ge` with `ZetaFixedLowerBound` for the centre.

What the next slice needs: E7d, the logarithmic derivative on the short
segment, which uses the same normalised function with `FinalBound`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.EdgeBound
import Stage3.BoxBounds

namespace EdgeBound

open Complex Topology Set

/-- The centre is bounded below at every height. -/
theorem gz_c0_lower (T' : ℝ) : 1 / 14 ≤ ‖gz (c0 T')‖ := by
  rw [gz, norm_mul, norm_pow]
  have h1 : (1 : ℝ) / 2 ≤ ‖c0 T' - 1‖ := by
    have h2 := Complex.abs_re_le_norm (c0 T' - 1)
    have h3 : (c0 T' - 1).re = 1 / 2 := by
      rw [Complex.sub_re, c0_re, Complex.one_re]
      norm_num
    rw [h3, abs_of_pos (by norm_num)] at h2
    exact h2
  have h4 := ZetaFixedLowerBound T'
  have h5 : ‖riemannZeta 3 / riemannZeta (3 / 2)‖
      ≤ ‖riemannZeta (3 / 2 + Complex.I * T')‖ := by
    exact_mod_cast h4
  have h6 : riemannZeta (c0 T') = riemannZeta (3 / 2 + Complex.I * (T' : ℂ)) := rfl
  rw [h6]
  have h7 := BoxBounds.zeta_ratio_ge
  have h8 : (1 : ℝ) / 4 ≤ ‖c0 T' - 1‖ ^ 2 := by nlinarith [norm_nonneg (c0 T' - 1)]
  have h9 : (2 : ℝ) / 7 ≤ ‖riemannZeta (3 / 2 + Complex.I * (T' : ℂ))‖ := le_trans h7 h5
  nlinarith

set_option maxHeartbeats 800000 in
/-- **Jensen's count at a low height.** -/
theorem low_ball_count {T' : ℝ} (h0 : 0 ≤ T') (h6 : T' ≤ 6) :
    (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 8 / 5)).toFinset,
      (analyticOrderNatAt gz w : ℝ)) ≤ 119 := by
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
  have hfz_bound : ∀ z : ℂ, ‖z‖ ≤ (15 / 16 : ℝ) → ‖f z‖ ≤ 18900000 := by
    intro z hzn
    rw [hfd]
    show ‖gz (2 * z + c0 T') / gz (c0 T')‖ ≤ 18900000
    rw [norm_div, div_le_iff₀ (norm_pos_iff.mpr hgc0)]
    have h10 := Complex.abs_re_le_norm z
    have h12 := Complex.abs_im_le_norm z
    have h11 : (2 * z + c0 T').re = 2 * z.re + 3 / 2 := by
      simp [Complex.add_re, Complex.mul_re, c0_re]
    have h13 : (2 * z + c0 T').im = 2 * z.im + T' := by
      simp [Complex.add_im, Complex.mul_im, c0_im]
    have h10' : |z.re| ≤ 15 / 16 := le_trans h10 hzn
    have h12' : |z.im| ≤ 15 / 16 := le_trans h12 hzn
    rw [abs_le] at h10' h12'
    have h14 := BoxBounds.sq_zeta_band_explicit (s := 2 * z + c0 T')
      (by rw [h11]; linarith [h10'.1]) (by rw [h11]; linarith [h10'.2])
    have h15im : |(2 * z + c0 T').im| ≤ 63 / 8 := by
      rw [h13, abs_le]
      constructor <;> linarith [h12'.1, h12'.2]
    have h15 : (2 + |(2 * z + c0 T').im|) ^ 4 ≤ (79 / 8 : ℝ) ^ 4 := by
      apply pow_le_pow_left₀ (by positivity)
      linarith
    have h16 : (79 / 8 : ℝ) ^ 4 ≤ 10000 := by norm_num
    have h20 : ‖gz (2 * z + c0 T')‖ ≤ 1350000 := by
      calc ‖gz (2 * z + c0 T')‖ ≤ 135 * (2 + |(2 * z + c0 T').im|) ^ 4 := h14
        _ ≤ 135 * 10000 := by linarith
        _ = 1350000 := by norm_num
    calc ‖gz (2 * z + c0 T')‖ ≤ 1350000 := h20
      _ = 18900000 * (1 / 14) := by norm_num
      _ ≤ 18900000 * ‖gz (c0 T')‖ := mul_le_mul_of_nonneg_left hlow (by norm_num)
  have hrlt1 : (4 : ℝ) / 5 < 1 := by norm_num
  have hZB := ZerosBound (B := 18900000) (r := 4 / 5) (R := 15 / 16) (f := f)
    (by norm_num) hrlt1 (by norm_num) (by norm_num) hfAnalytic hf0 hfin hfz_bound
  rw [Nat.cast_sum, show (15 : ℝ) / 16 / (4 / 5) = 75 / 64 by norm_num] at hZB
  set Fg := (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 8 / 5)).toFinset with hFgd
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
  have hlog1 : (11 : ℝ) / 75 ≤ Real.log (75 / 64) := by
    have h1 : Real.log (64 / 75) ≤ 64 / 75 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (75 : ℝ) / 64 = ((64 : ℝ) / 75)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hlog1pos : (0 : ℝ) < Real.log (75 / 64) := by linarith
  have hlogB : Real.log 18900000 ≤ 17.33 := by
    have h2 : Real.log 18900000 ≤ Real.log 33554432 :=
      Real.log_le_log (by norm_num) (by norm_num)
    have h3 : Real.log 33554432 = 25 * Real.log 2 := by
      rw [show (33554432 : ℝ) = 2 ^ (25 : ℕ) by norm_num, Real.log_pow]
      norm_num
    have h4 := Real.log_two_lt_d9
    linarith
  have hlogBnn : (0 : ℝ) ≤ Real.log 18900000 := Real.log_nonneg (by norm_num)
  have hinv : 1 / Real.log (75 / 64) ≤ 75 / 11 := by
    rw [div_le_iff₀ hlog1pos]
    nlinarith
  calc ∑ ρ ∈ Ff, (analyticOrderNatAt f ρ : ℝ)
      ≤ 1 / Real.log (75 / 64) * Real.log 18900000 := hZB
    _ ≤ 75 / 11 * 17.33 := mul_le_mul hinv hlogB hlogBnn (by norm_num)
    _ ≤ 119 := by norm_num

set_option maxHeartbeats 800000 in
/-- **`M0`, bounded by a numeral.** -/
theorem low_rect_count :
    (∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0 : ℂ)
        ((1 : ℝ) + Complex.I * (6 : ℝ))).toFinset,
      (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ 714 := by
  classical
  set lowFin := ContourShift.zeta_zeros_rectangle_finite (0 : ℂ)
      ((1 : ℝ) + Complex.I * (6 : ℝ)) with hlowd
  set Bf : ℝ → Finset ℂ := fun t ↦
    (gz_zeros_ball_finite t (by norm_num : (0 : ℝ) ≤ 8 / 5)).toFinset with hBfd
  have hmemB : ∀ t w, w ∈ Bf t ↔ (gz w = 0 ∧ ‖w - c0 t‖ ≤ 8 / 5) := by
    intro t w
    rw [hBfd]
    simp only [Set.Finite.mem_toFinset]
    exact Iff.rfl
  set U : Finset ℂ :=
    ((Bf (1 / 2) ∪ Bf (3 / 2)) ∪ (Bf (5 / 2) ∪ Bf (7 / 2))) ∪ (Bf (9 / 2) ∪ Bf (11 / 2))
    with hUd
  -- shape of a rectangle zero
  have hshape : ∀ ρ ∈ lowFin.toFinset,
      riemannZeta ρ = 0 ∧ (0 ≤ ρ.re ∧ ρ.re ≤ 1) ∧ (0 ≤ ρ.im ∧ ρ.im ≤ 6) := by
    intro ρ hρ
    rw [hlowd, Set.Finite.mem_toFinset] at hρ
    obtain ⟨hζ, hR⟩ := hρ
    simp only [Rectangle] at hR
    have hzre : (0 : ℂ).re = 0 := Complex.zero_re
    have hzim : (0 : ℂ).im = 0 := Complex.zero_im
    have hwre : ((1 : ℝ) + Complex.I * (6 : ℝ) : ℂ).re = 1 := by simp
    have hwim : ((1 : ℝ) + Complex.I * (6 : ℝ) : ℂ).im = 6 := by simp
    rw [Complex.mem_reProdIm, hzre, hzim, hwre, hwim,
      Set.uIcc_of_le (by norm_num : (0 : ℝ) ≤ 1),
      Set.uIcc_of_le (by norm_num : (0 : ℝ) ≤ 6),
      Set.mem_Icc, Set.mem_Icc] at hR
    exact ⟨hζ, hR.1, hR.2⟩
  have hne1 : ∀ ρ ∈ lowFin.toFinset, ρ ≠ 1 := by
    intro ρ hρ h1
    obtain ⟨hζ, -, -⟩ := hshape ρ hρ
    rw [h1] at hζ
    exact riemannZeta_one_ne_zero hζ
  have hin : ∀ (t : ℝ) (ρ : ℂ), riemannZeta ρ = 0 → 0 ≤ ρ.re → ρ.re ≤ 1 →
      |ρ.im - t| ≤ 1 / 2 → ρ ∈ Bf t := by
    intro t ρ hζ hre0 hre1 him
    rw [hmemB]
    refine ⟨by rw [gz, hζ, mul_zero], ?_⟩
    apply BoxBounds.norm_le_of_sq (by norm_num)
    rw [Complex.sub_re, Complex.sub_im, c0_re, c0_im]
    rw [abs_le] at him
    nlinarith [him.1, him.2]
  have hsub : lowFin.toFinset ⊆ U := by
    intro ρ hρ
    obtain ⟨hζ, ⟨hre0, hre1⟩, ⟨him0, him6⟩⟩ := hshape ρ hρ
    rw [hUd]
    rcases le_total ρ.im 1 with h1 | h1
    · apply Finset.mem_union_left; apply Finset.mem_union_left; apply Finset.mem_union_left
      exact hin _ ρ hζ hre0 hre1 (by rw [abs_le]; constructor <;> linarith)
    rcases le_total ρ.im 2 with h2 | h2
    · apply Finset.mem_union_left; apply Finset.mem_union_left; apply Finset.mem_union_right
      exact hin _ ρ hζ hre0 hre1 (by rw [abs_le]; constructor <;> linarith)
    rcases le_total ρ.im 3 with h3 | h3
    · apply Finset.mem_union_left; apply Finset.mem_union_right; apply Finset.mem_union_left
      exact hin _ ρ hζ hre0 hre1 (by rw [abs_le]; constructor <;> linarith)
    rcases le_total ρ.im 4 with h4 | h4
    · apply Finset.mem_union_left; apply Finset.mem_union_right; apply Finset.mem_union_right
      exact hin _ ρ hζ hre0 hre1 (by rw [abs_le]; constructor <;> linarith)
    rcases le_total ρ.im 5 with h5 | h5
    · apply Finset.mem_union_right; apply Finset.mem_union_left
      exact hin _ ρ hζ hre0 hre1 (by rw [abs_le]; constructor <;> linarith)
    · apply Finset.mem_union_right; apply Finset.mem_union_right
      exact hin _ ρ hζ hre0 hre1 (by rw [abs_le]; constructor <;> linarith)
  have hunion_le : ∀ (Aset Bset : Finset ℂ),
      ∑ w ∈ Aset ∪ Bset, (analyticOrderNatAt gz w : ℝ)
        ≤ (∑ w ∈ Aset, (analyticOrderNatAt gz w : ℝ))
          + ∑ w ∈ Bset, (analyticOrderNatAt gz w : ℝ) := by
    intro Aset Bset
    have h5 := Finset.sum_union_inter (s₁ := Aset) (s₂ := Bset)
      (f := fun w ↦ (analyticOrderNatAt gz w : ℝ))
    have h6 : (0 : ℝ) ≤ ∑ w ∈ Aset ∩ Bset, (analyticOrderNatAt gz w : ℝ) := by
      apply Finset.sum_nonneg
      intro w _
      positivity
    linarith
  have hB : ∀ t : ℝ, 0 ≤ t → t ≤ 6 →
      ∑ w ∈ Bf t, (analyticOrderNatAt gz w : ℝ) ≤ 119 := fun t h0 h6 ↦ low_ball_count h0 h6
  have hconv : ∑ ρ ∈ lowFin.toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ)
      = ∑ ρ ∈ lowFin.toFinset, (analyticOrderNatAt gz ρ : ℝ) := by
    apply Finset.sum_congr rfl
    intro ρ hρ
    rw [gz_order_eq (hne1 ρ hρ)]
  rw [hconv]
  calc ∑ ρ ∈ lowFin.toFinset, (analyticOrderNatAt gz ρ : ℝ)
      ≤ ∑ w ∈ U, (analyticOrderNatAt gz w : ℝ) := by
        apply Finset.sum_le_sum_of_subset_of_nonneg hsub
        intro w _ _
        positivity
    _ ≤ 119 + 119 + (119 + 119) + (119 + 119) := by
        rw [hUd]
        have a1 := hunion_le ((Bf (1 / 2) ∪ Bf (3 / 2)) ∪ (Bf (5 / 2) ∪ Bf (7 / 2)))
          (Bf (9 / 2) ∪ Bf (11 / 2))
        have a2 := hunion_le (Bf (1 / 2) ∪ Bf (3 / 2)) (Bf (5 / 2) ∪ Bf (7 / 2))
        have a3 := hunion_le (Bf (1 / 2)) (Bf (3 / 2))
        have a4 := hunion_le (Bf (5 / 2)) (Bf (7 / 2))
        have a5 := hunion_le (Bf (9 / 2)) (Bf (11 / 2))
        have b1 := hB (1 / 2) (by norm_num) (by norm_num)
        have b2 := hB (3 / 2) (by norm_num) (by norm_num)
        have b3 := hB (5 / 2) (by norm_num) (by norm_num)
        have b4 := hB (7 / 2) (by norm_num) (by norm_num)
        have b5 := hB (9 / 2) (by norm_num) (by norm_num)
        have b6 := hB (11 / 2) (by norm_num) (by norm_num)
        linarith
    _ = 714 := by norm_num

/-- info: 'EdgeBound.gz_c0_lower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gz_c0_lower

/-- info: 'EdgeBound.low_ball_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms low_ball_count

/-- info: 'EdgeBound.low_rect_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms low_rect_count

end EdgeBound
