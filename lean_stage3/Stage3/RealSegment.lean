/-
RealSegment — block E5 of `lean_stage3/design/joints.md`. 2026-11-22.

ζ has no zero on the real segment `(0, 1)`, so the bucket `W` of real
nontrivial zeros in the explicit-formula route is zero.

  zeta_real_ne_zero_upper            1/3 < σ < 1 ⊢ riemannZeta σ ≠ 0
  zeta_real_ne_zero                  0 < σ < 1 ⊢ riemannZeta σ ≠ 0
  isEmpty_zeroHeight                 IsEmpty Kadiri.ZeroHeightNontrivialZeros
  weightedZeroHeightBucket_eq_zero   Kadiri.weightedZeroHeightBucket = 0

Route: on `(1/3, 1)` the strip formula `Zeta0EqZeta` at `N = 1` with the
upstream bound `ZetaBnd_aux1b` on its integral; on `(0, 1/2]` the functional
equation at `1 − σ`.

What the next slice needs: `M0`, `Mc`, the compact patch.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.Assembly

namespace Stage3

open Complex Set

noncomputable section

/-- No zero on `(1/3, 1)`, from the strip formula at `N = 1`. -/
theorem zeta_real_ne_zero_upper {σ : ℝ} (h0 : 1 / 3 < σ) (h1 : σ < 1) :
    riemannZeta (σ : ℂ) ≠ 0 := by
  have hσ0 : 0 < σ := by linarith
  have hre : 0 < ((σ : ℝ) : ℂ).re := by simpa using hσ0
  have hne1 : ((σ : ℝ) : ℂ) ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    simp at this
    linarith
  have hne0 : ((σ : ℝ) : ℂ) ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    simp at this
    linarith
  have hEq := Zeta0EqZeta (N := 1) (by norm_num) hre hne1
  intro hz
  rw [hz] at hEq
  have hB := ZetaBnd_aux1b 1 le_rfl (σ := σ) (t := 0) hσ0
  have hs : ((σ : ℝ) : ℂ) + ((0 : ℝ) : ℂ) * I = ((σ : ℝ) : ℂ) := by simp
  rw [hs] at hB
  simp only [Nat.cast_one, Real.one_rpow] at hB
  unfold riemannZeta0 at hEq
  rw [Finset.sum_range_succ, Finset.sum_range_one] at hEq
  simp only [Nat.cast_zero, Nat.cast_one, Complex.zero_cpow hne0, Complex.one_cpow,
    div_zero, zero_add, div_one] at hEq
  set J : ℂ := ∫ x in Ioi (1 : ℝ), (⌊x⌋ + 1 / 2 - x) / (x : ℂ) ^ ((σ : ℂ) + 1) with hJ
  have hJn : ‖(σ : ℂ) * J‖ ≤ 1 := by
    rw [norm_mul, Complex.norm_real, Real.norm_of_nonneg hσ0.le]
    calc σ * ‖J‖ ≤ σ * (1 / σ) := mul_le_mul_of_nonneg_left hB hσ0.le
      _ = 1 := by field_simp
  have h1σ : (1 : ℂ) - (σ : ℂ) ≠ 0 := sub_ne_zero.mpr (Ne.symm hne1)
  have hval : (σ : ℂ) * J = ((1 / (1 - σ) - 1 / 2 : ℝ) : ℂ) := by
    push_cast
    linear_combination hEq
  rw [hval, Complex.norm_real, Real.norm_eq_abs] at hJn
  have hpos : (0 : ℝ) < 1 - σ := by linarith
  have hbig : 1 < 1 / (1 - σ) - 1 / 2 := by
    rw [lt_sub_iff_add_lt, lt_div_iff₀ hpos]
    linarith
  rw [abs_of_pos (by linarith)] at hJn
  linarith

/-- No zero on `(0, 1)`. -/
theorem zeta_real_ne_zero {σ : ℝ} (h0 : 0 < σ) (h1 : σ < 1) :
    riemannZeta (σ : ℂ) ≠ 0 := by
  rcases lt_or_ge (1 / 3) σ with h | h
  · exact zeta_real_ne_zero_upper h h1
  · -- functional equation at w = 1 − σ ∈ [2/3, 1)
    set w : ℝ := 1 - σ with hw
    have hw0 : 1 / 3 < w := by rw [hw]; linarith
    have hw1 : w < 1 := by rw [hw]; linarith
    have hzw := zeta_real_ne_zero_upper hw0 hw1
    have hrw : ((σ : ℝ) : ℂ) = 1 - ((w : ℝ) : ℂ) := by rw [hw]; push_cast; ring
    rw [hrw]
    have hw_neg_nat : ∀ n : ℕ, ((w : ℝ) : ℂ) ≠ -↑n := by
      intro n hn
      have hre' := congrArg Complex.re hn
      simp at hre'
      have : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
      linarith
    have hw_ne_one : ((w : ℝ) : ℂ) ≠ 1 := by
      intro hh
      have hre' := congrArg Complex.re hh
      simp at hre'
      linarith
    have hpow : (2 * ↑Real.pi : ℂ) ^ (-((w : ℝ) : ℂ)) ≠ 0 := by
      rw [Complex.cpow_ne_zero_iff]; left
      norm_num [Complex.ofReal_ne_zero, Real.pi_ne_zero]
    have hGamma : Complex.Gamma ((w : ℝ) : ℂ) ≠ 0 := Complex.Gamma_ne_zero hw_neg_nat
    have hcos : Complex.cos (↑Real.pi * ((w : ℝ) : ℂ) / 2) ≠ 0 := by
      have harg : (↑Real.pi * ((w : ℝ) : ℂ) / 2) = ((Real.pi * w / 2 : ℝ) : ℂ) := by
        push_cast; ring
      rw [harg, ← Complex.ofReal_cos, Complex.ofReal_ne_zero]
      apply ne_of_gt
      apply Real.cos_pos_of_mem_Ioo
      constructor <;> nlinarith [Real.pi_pos]
    have hfe := riemannZeta_one_sub (s := ((w : ℝ) : ℂ)) hw_neg_nat hw_ne_one
    rw [hfe]
    exact mul_ne_zero
      (mul_ne_zero (mul_ne_zero (mul_ne_zero (by norm_num) hpow) hGamma) hcos) hzw

/-- The bucket of real nontrivial zeros is empty. -/
theorem isEmpty_zeroHeight : IsEmpty Kadiri.ZeroHeightNontrivialZeros := by
  refine ⟨fun rho => ?_⟩
  have him' : ((rho.1 : ℂ)).im = 0 := rho.2
  obtain ⟨hzre, -, hz⟩ := rho.1.2
  set z : ℂ := (rho.1 : ℂ) with hzdef
  have hz0 : riemannZeta z = 0 := hz
  have hzr : z = ((z.re : ℝ) : ℂ) := by
    apply Complex.ext <;> simp [him']
  have hne := zeta_real_ne_zero hzre.1 hzre.2
  rw [← hzr] at hne
  exact hne hz0

/-- **`W = 0`.** -/
theorem weightedZeroHeightBucket_eq_zero : Kadiri.weightedZeroHeightBucket = 0 := by
  haveI := isEmpty_zeroHeight
  unfold Kadiri.weightedZeroHeightBucket
  exact tsum_empty

end

/-- info: 'Stage3.zeta_real_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_real_ne_zero

/-- info: 'Stage3.weightedZeroHeightBucket_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms weightedZeroHeightBucket_eq_zero

end Stage3
