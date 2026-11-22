/-
BoxBounds — blocks E7a and E7b of `lean_stage3/design/joints.md`. 2026-11-22.

Two of the quantities the explicit-formula route took from existence
statements, as numerals.

  sq_zeta_box                 −1/2 ≤ Re s ≤ 4, |Im s| ≤ 2 ⊢ ‖(s−1)²·ζ s‖ ≤ 135
  sq_zeta_band_explicit       −1/2 ≤ Re s ≤ 4 ⊢ ‖(s−1)²·ζ s‖ ≤ 135·(2 + |Im s|)⁴
  norm_zeta_three_halves_le   ‖ζ (3/2)‖ ≤ 7/2
  one_le_norm_zeta_three      1 ≤ ‖ζ 3‖
  zeta_ratio_ge               2/7 ≤ ‖ζ 3 / ζ (3/2)‖

`sq_zeta_band_explicit` is `ZetaGrowth.sq_zeta_band_bound` with its constant
named: that theorem takes the box from compactness (`max 135 CK + 1`); here
the box is bounded by the continued Euler–Maclaurin form at its first level.

What the next slice needs: E7c (the zeros below height six) and E7d (the
logarithmic derivative on the short segment), which consume both.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ZetaGrowth

namespace BoxBounds

open Complex Set ZetaGrowth

noncomputable section

theorem norm_le_of_sq {z : ℂ} {c : ℝ} (hc : 0 ≤ c) (h : z.re ^ 2 + z.im ^ 2 ≤ c ^ 2) :
    ‖z‖ ≤ c := by
  rw [Complex.norm_def]
  calc Real.sqrt (Complex.normSq z) ≤ Real.sqrt (c ^ 2) := by
        apply Real.sqrt_le_sqrt
        rw [Complex.normSq_apply]
        nlinarith
    _ = c := Real.sqrt_sq hc

/-- **The compact patch, with a numeral.** -/
theorem sq_zeta_box {s : ℂ} (h1 : -1 / 2 ≤ s.re) (h2 : s.re ≤ 4) (ht : |s.im| ≤ 2) :
    ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 := by
  by_cases hs1 : s = 1
  · rw [hs1]
    simp
  have hmem : s ∈ stripRegion := ⟨by linarith, hs1⟩
  have hT := tail_norm_le (N := 1) one_pos (s := s) h1
  rw [← zeta1_eq_zeta_strip (N := 1) one_pos hmem, zeta1]
  simp only [Finset.sum_range_one, Nat.cast_zero, zero_add, Nat.cast_one,
    Complex.one_cpow, div_one, Real.one_rpow, mul_one] at hT ⊢
  set T : ℂ := ∫ x in Ioi (1 : ℝ), (emA x : ℂ) * (x : ℂ) ^ (-(s + 2)) with hTd
  have h1s : (1 : ℂ) - s ≠ 0 := sub_ne_zero.mpr (Ne.symm hs1)
  have hid : (s - 1) ^ 2 * (1 + -1 / (1 - s) + -1 / 2 + s * ((s + 1) * T))
      = (s - 1) ^ 2 * (1 / 2 + s * ((s + 1) * T)) + (s - 1) := by
    field_simp
    try ring
  rw [hid]
  obtain ⟨hi1, hi2⟩ := abs_le.mp ht
  have him : s.im ^ 2 ≤ 4 := by nlinarith
  have hn1 : ‖s - 1‖ ≤ 4 := by
    apply norm_le_of_sq (by norm_num)
    simp only [Complex.sub_re, Complex.sub_im, Complex.one_re, Complex.one_im, sub_zero]
    nlinarith
  have hn0 : ‖s‖ ≤ 5 := by
    apply norm_le_of_sq (by norm_num)
    nlinarith
  have hn2 : ‖s + 1‖ ≤ 6 := by
    apply norm_le_of_sq (by norm_num)
    simp only [Complex.add_re, Complex.add_im, Complex.one_re, Complex.one_im, add_zero]
    nlinarith
  have hsT : ‖s * ((s + 1) * T)‖ ≤ 5 * (6 * (1 / 4)) := by
    rw [norm_mul, norm_mul]
    exact mul_le_mul hn0 (mul_le_mul hn2 hT (norm_nonneg _) (by norm_num))
      (by positivity) (by norm_num)
  have hin : ‖(1 / 2 : ℂ) + s * ((s + 1) * T)‖ ≤ 1 / 2 + 5 * (6 * (1 / 4)) := by
    refine le_trans (norm_add_le _ _) ?_
    have : ‖(1 / 2 : ℂ)‖ = 1 / 2 := by norm_num
    rw [this]
    linarith
  calc ‖(s - 1) ^ 2 * (1 / 2 + s * ((s + 1) * T)) + (s - 1)‖
      ≤ ‖(s - 1) ^ 2 * (1 / 2 + s * ((s + 1) * T))‖ + ‖s - 1‖ := norm_add_le _ _
    _ = ‖s - 1‖ ^ 2 * ‖(1 / 2 : ℂ) + s * ((s + 1) * T)‖ + ‖s - 1‖ := by
        rw [norm_mul, norm_pow]
    _ ≤ 4 ^ 2 * (1 / 2 + 5 * (6 * (1 / 4))) + 4 := by
        apply add_le_add ?_ hn1
        exact mul_le_mul (pow_le_pow_left₀ (norm_nonneg _) hn1 2) hin (norm_nonneg _)
          (by norm_num)
    _ ≤ 135 := by norm_num

/-- **The band bound with its constant named.** -/
theorem sq_zeta_band_explicit {s : ℂ} (hσ1 : -1 / 2 ≤ s.re) (hσ2 : s.re ≤ 4) :
    ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 * (2 + |s.im|) ^ 4 := by
  have hpow1 : (1 : ℝ) ≤ (2 + |s.im|) ^ 4 := by
    have h0 : (0 : ℝ) ≤ |s.im| := abs_nonneg _
    have h1 : (1 : ℝ) ≤ 2 + |s.im| := by linarith
    calc (1 : ℝ) = 1 ^ 4 := by norm_num
      _ ≤ (2 + |s.im|) ^ 4 := pow_le_pow_left₀ (by norm_num) h1 4
  by_cases ht : 2 ≤ |s.im|
  · have hζ := zeta_growth_strip (by linarith) hσ2 ht
    have hs1 : ‖s - 1‖ ≤ 5 + |s.im| := by
      apply norm_le_of_sq (by positivity)
      simp only [Complex.sub_re, Complex.sub_im, Complex.one_re, Complex.one_im, sub_zero]
      nlinarith [sq_abs s.im, abs_nonneg s.im]
    have h6 : (5 : ℝ) + |s.im| ≤ 3 * (2 + |s.im|) := by
      have := abs_nonneg s.im
      linarith
    have h7 : |s.im| ≤ 2 + |s.im| := by linarith [abs_nonneg s.im]
    calc ‖(s - 1) ^ 2 * riemannZeta s‖
        = ‖s - 1‖ ^ 2 * ‖riemannZeta s‖ := by rw [norm_mul, norm_pow]
      _ ≤ (3 * (2 + |s.im|)) ^ 2 * (15 * |s.im| ^ 2) := by
          apply mul_le_mul ?_ hζ (norm_nonneg _) (by positivity)
          exact pow_le_pow_left₀ (norm_nonneg _) (le_trans hs1 h6) 2
      _ ≤ (3 * (2 + |s.im|)) ^ 2 * (15 * (2 + |s.im|) ^ 2) := by
          apply mul_le_mul_of_nonneg_left ?_ (by positivity)
          have h8 : |s.im| ^ 2 ≤ (2 + |s.im|) ^ 2 := pow_le_pow_left₀ (abs_nonneg _) h7 2
          linarith
      _ = 135 * (2 + |s.im|) ^ 4 := by ring
  · push_neg at ht
    calc ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 := sq_zeta_box (by linarith) hσ2 ht.le
      _ ≤ 135 * (2 + |s.im|) ^ 4 := by linarith

/-- `‖ζ(3/2)‖ ≤ 7/2`, from the strip formula at its first level. -/
theorem norm_zeta_three_halves_le : ‖riemannZeta (3 / 2)‖ ≤ 7 / 2 := by
  have hcast : (3 / 2 : ℂ) = (((3 / 2 : ℝ)) : ℂ) := by push_cast; ring
  rw [hcast]
  have hre : 0 < (((3 / 2 : ℝ)) : ℂ).re := by simp
  have hne1 : (((3 / 2 : ℝ)) : ℂ) ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    simp at this
    linarith
  have hne0 : (((3 / 2 : ℝ)) : ℂ) ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    simp at this
  have hEq := Zeta0EqZeta (N := 1) (by norm_num) hre hne1
  have hB := ZetaBnd_aux1b 1 le_rfl (σ := 3 / 2) (t := 0) (by norm_num)
  have hs : (((3 / 2 : ℝ)) : ℂ) + ((0 : ℝ) : ℂ) * I = (((3 / 2 : ℝ)) : ℂ) := by simp
  rw [hs] at hB
  simp only [Nat.cast_one, Real.one_rpow] at hB
  rw [← hEq]
  unfold riemannZeta0
  rw [Finset.sum_range_succ, Finset.sum_range_one]
  simp only [Nat.cast_zero, Nat.cast_one, Complex.zero_cpow hne0, Complex.one_cpow,
    div_zero, zero_add, div_one]
  set J : ℂ := ∫ x in Ioi (1 : ℝ),
    (⌊x⌋ + 1 / 2 - x) / (x : ℂ) ^ ((((3 / 2 : ℝ)) : ℂ) + 1) with hJ
  have hJn : ‖(((3 / 2 : ℝ)) : ℂ) * J‖ ≤ 1 := by
    rw [norm_mul, Complex.norm_real, Real.norm_of_nonneg (by norm_num)]
    calc (3 / 2 : ℝ) * ‖J‖ ≤ 3 / 2 * (1 / (3 / 2)) :=
          mul_le_mul_of_nonneg_left hB (by norm_num)
      _ = 1 := by norm_num
  have hval : (1 : ℂ) + -1 / (1 - (((3 / 2 : ℝ)) : ℂ)) + -1 / 2
      = ((5 / 2 : ℝ) : ℂ) := by
    push_cast
    norm_num
  rw [hval]
  calc ‖((5 / 2 : ℝ) : ℂ) + (((3 / 2 : ℝ)) : ℂ) * J‖
      ≤ ‖((5 / 2 : ℝ) : ℂ)‖ + ‖(((3 / 2 : ℝ)) : ℂ) * J‖ := norm_add_le _ _
    _ ≤ 5 / 2 + 1 := by
        rw [Complex.norm_real, Real.norm_of_nonneg (by norm_num)]
        linarith
    _ = 7 / 2 := by norm_num

/-- `1 ≤ ‖ζ 3‖`, from the Dirichlet series. -/
theorem one_le_norm_zeta_three : 1 ≤ ‖riemannZeta 3‖ := by
  have h := zeta_nat_eq_tsum_of_gt_one (k := 3) (by norm_num)
  have hcast : ((3 : ℕ) : ℂ) = 3 := by norm_num
  rw [hcast] at h
  have hreal : (∑' n : ℕ, 1 / (n : ℂ) ^ 3) = ((∑' n : ℕ, 1 / (n : ℝ) ^ 3 : ℝ) : ℂ) := by
    rw [Complex.ofReal_tsum]
    congr 1
    funext n
    push_cast
    rfl
  have hsum : Summable (fun n : ℕ => 1 / (n : ℝ) ^ 3) :=
    Real.summable_one_div_nat_pow.mpr (by norm_num)
  have hge : (1 : ℝ) ≤ ∑' n : ℕ, 1 / (n : ℝ) ^ 3 := by
    have h1 := hsum.le_tsum 1 (fun j _ => by positivity)
    simpa using h1
  rw [h, hreal, Complex.norm_real, Real.norm_of_nonneg (by linarith)]
  exact hge

/-- **`cζ`, bounded below by a numeral.** -/
theorem zeta_ratio_ge : 2 / 7 ≤ ‖riemannZeta 3 / riemannZeta (3 / 2)‖ := by
  have h1 := one_le_norm_zeta_three
  have h2 := norm_zeta_three_halves_le
  have hpos : 0 < ‖riemannZeta (3 / 2)‖ := by
    rcases (norm_nonneg (riemannZeta (3 / 2))).lt_or_eq with hlt | heq
    · exact hlt
    · exfalso
      have hz : riemannZeta (3 / 2) = 0 := norm_eq_zero.mp heq.symm
      exact riemannZeta_ne_zero_of_one_le_re (by norm_num) hz
  rw [norm_div, le_div_iff₀ hpos]
  linarith

end

/-- info: 'BoxBounds.sq_zeta_box' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sq_zeta_box

/-- info: 'BoxBounds.sq_zeta_band_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sq_zeta_band_explicit

/-- info: 'BoxBounds.zeta_ratio_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_ratio_ge

end BoxBounds
