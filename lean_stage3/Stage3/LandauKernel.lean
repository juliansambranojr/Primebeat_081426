/-
LandauKernel — the kernel's integral: for `a > 0`,
`∫₁^∞ (log y)^k · y^(−a−1) dy = k!/a^(k+1)`.
Block 4a of `lean_stage3/design/landau.md`. 2026-11-22.

This is `∫₀^∞ u^k e^(−au) du` after `y = e^u`, kept in the variable `y`.
Induction on `k`: `F(y) = −(log y)^(k+1)·y^(−a)/a` has derivative
`(log y)^(k+1) y^(−a−1) − ((k+1)/a)·(log y)^k y^(−a−1)`, vanishes at `1` and
tends to `0` at infinity.

  log_pow_le          (ha : 0 < a) (n) (hy : 1 ≤ y) :
                        (log y)^n ≤ y^(a/2) / (a/(2(n+1)))^n
  log_pow_integrable  (ha : 0 < a) (n) :
                        IntegrableOn ((log y)^n · y^(−a−1)) (Ioi 1)
  log_pow_integral    (ha : 0 < a) (k) :
                        ∫ y in Ioi 1, (log y)^k · y^(−a−1) = k!/a^(k+1)

What the next slice needs: this integral, for the absolute convergence that
lets a power series change places with the Mellin integral of `G` (block
2c), and as the total against which the tail off the window is measured
(block 4b).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib

namespace LandauKernel

noncomputable section

open MeasureTheory Set Filter Topology

theorem log_pow_le {a : ℝ} (ha : 0 < a) (n : ℕ) {y : ℝ} (hy : 1 ≤ y) :
    Real.log y ^ n ≤ y ^ (a / 2) / (a / (2 * (n + 1))) ^ n := by
  have hy0 : 0 < y := by linarith
  have hε : 0 < a / (2 * ((n : ℝ) + 1)) := by positivity
  have hL : 0 ≤ Real.log y := Real.log_nonneg hy
  have h1 : Real.log y ≤ y ^ (a / (2 * ((n : ℝ) + 1))) / (a / (2 * ((n : ℝ) + 1))) :=
    Real.log_le_rpow_div hy0.le hε
  have h2 : Real.log y ^ n
      ≤ (y ^ (a / (2 * ((n : ℝ) + 1))) / (a / (2 * ((n : ℝ) + 1)))) ^ n :=
    pow_le_pow_left₀ hL h1 n
  have h3 : (y ^ (a / (2 * ((n : ℝ) + 1)))) ^ n ≤ y ^ (a / 2) := by
    rw [← Real.rpow_natCast, ← Real.rpow_mul hy0.le]
    apply Real.rpow_le_rpow_of_exponent_le hy
    have hn : (n : ℝ) / ((n : ℝ) + 1) ≤ 1 := by
      rw [div_le_one (by positivity)]; linarith
    calc a / (2 * ((n : ℝ) + 1)) * n = a / 2 * ((n : ℝ) / ((n : ℝ) + 1)) := by
          field_simp
      _ ≤ a / 2 * 1 := mul_le_mul_of_nonneg_left hn (by positivity)
      _ = a / 2 := mul_one _
  rw [div_pow] at h2
  exact le_trans h2 (div_le_div_of_nonneg_right h3 (by positivity))

/-- The kernel is at most a power of `y` with exponent below `−1`. -/
private lemma kernel_le {a : ℝ} (ha : 0 < a) (n : ℕ) {y : ℝ} (hy : 1 ≤ y) :
    Real.log y ^ n * y ^ (-a - 1)
      ≤ y ^ (-(a / 2) - 1) / (a / (2 * (n + 1))) ^ n := by
  have hy0 : 0 < y := by linarith
  have h := mul_le_mul_of_nonneg_right (log_pow_le ha n hy) (Real.rpow_nonneg hy0.le (-a - 1))
  have e : y ^ (a / 2) * y ^ (-a - 1) = y ^ (-(a / 2) - 1) := by
    rw [← Real.rpow_add hy0]; congr 1; ring
  rw [div_mul_eq_mul_div, e] at h
  exact h

theorem log_pow_integrable {a : ℝ} (ha : 0 < a) (n : ℕ) :
    IntegrableOn (fun y : ℝ => Real.log y ^ n * y ^ (-a - 1)) (Ioi 1) := by
  have hbound : IntegrableOn
      (fun y : ℝ => y ^ (-(a / 2) - 1) / (a / (2 * ((n : ℝ) + 1))) ^ n) (Ioi 1) :=
    (integrableOn_Ioi_rpow_of_lt (by linarith) one_pos).div_const _
  have hcont : ContinuousOn (fun y : ℝ => Real.log y ^ n * y ^ (-a - 1)) (Ioi 1) := by
    intro y hy
    have hy0 : y ≠ 0 := by linarith [mem_Ioi.mp hy]
    exact (((Real.continuousAt_log hy0).pow n).mul
      (Real.continuousAt_rpow_const y _ (Or.inl hy0))).continuousWithinAt
  refine Integrable.mono' hbound (hcont.aestronglyMeasurable measurableSet_Ioi) ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
  have hy1 : 1 ≤ y := (mem_Ioi.mp hy).le
  have hnn : 0 ≤ Real.log y ^ n * y ^ (-a - 1) :=
    mul_nonneg (pow_nonneg (Real.log_nonneg hy1) n) (Real.rpow_nonneg (by linarith) _)
  rw [Real.norm_of_nonneg hnn]
  exact kernel_le ha n hy1

private lemma tendsto_log_pow_mul {a : ℝ} (ha : 0 < a) (n : ℕ) :
    Tendsto (fun y : ℝ => Real.log y ^ n * y ^ (-a)) atTop (𝓝 0) := by
  have hlim : Tendsto (fun y : ℝ => y ^ (-(a / 2)) / (a / (2 * ((n : ℝ) + 1))) ^ n)
      atTop (𝓝 0) := by
    have := (tendsto_rpow_neg_atTop (by linarith : 0 < a / 2)).div_const
      ((a / (2 * ((n : ℝ) + 1))) ^ n)
    simpa using this
  refine squeeze_zero' ?_ ?_ hlim
  · filter_upwards [eventually_ge_atTop 1] with y hy
    exact mul_nonneg (pow_nonneg (Real.log_nonneg hy) n) (Real.rpow_nonneg (by linarith) _)
  · filter_upwards [eventually_ge_atTop 1] with y hy
    have hy0 : 0 < y := by linarith
    have h := mul_le_mul_of_nonneg_right (log_pow_le ha n hy) (Real.rpow_nonneg hy0.le (-a))
    have e : y ^ (a / 2) * y ^ (-a) = y ^ (-(a / 2)) := by
      rw [← Real.rpow_add hy0]; congr 1; ring
    rw [div_mul_eq_mul_div, e] at h
    exact h

private lemma hasDerivAt_prim {a : ℝ} (ha : 0 < a) (k : ℕ) {y : ℝ} (hy : 0 < y) :
    HasDerivAt (fun t : ℝ => -(Real.log t ^ (k + 1) * t ^ (-a)) / a)
      (Real.log y ^ (k + 1) * y ^ (-a - 1)
        - ((k : ℝ) + 1) / a * (Real.log y ^ k * y ^ (-a - 1))) y := by
  have hL := (Real.hasDerivAt_log hy.ne').pow (k + 1)
  have hP := Real.hasDerivAt_rpow_const (p := -a) (Or.inl hy.ne')
  have h := ((hL.mul hP).neg).div_const a
  have e : y ^ (-a) = y ^ (-a - 1) * y := by
    rw [← Real.rpow_add_one hy.ne']; congr 1; ring
  refine h.congr_deriv ?_
  simp only [Nat.add_sub_cancel, Pi.pow_apply]
  rw [e]
  push_cast
  field_simp
  try ring

theorem log_pow_integral {a : ℝ} (ha : 0 < a) (k : ℕ) :
    ∫ y in Ioi (1 : ℝ), Real.log y ^ k * y ^ (-a - 1) = k.factorial / a ^ (k + 1) := by
  induction k with
  | zero =>
    simp only [pow_zero, one_mul, Nat.factorial_zero, Nat.cast_one, zero_add, pow_one]
    rw [integral_Ioi_rpow_of_lt (by linarith) one_pos]
    simp
  | succ k ih =>
    have hk1 := log_pow_integrable ha (k + 1)
    have hk := log_pow_integrable ha k
    have hF := integral_Ioi_of_hasDerivAt_of_tendsto'
      (f := fun t : ℝ => -(Real.log t ^ (k + 1) * t ^ (-a)) / a)
      (f' := fun y : ℝ => Real.log y ^ (k + 1) * y ^ (-a - 1)
        - ((k : ℝ) + 1) / a * (Real.log y ^ k * y ^ (-a - 1)))
      (a := 1) (m := 0)
      (fun x hx => hasDerivAt_prim ha k (lt_of_lt_of_le one_pos (mem_Ici.mp hx)))
      (hk1.sub (hk.const_mul _))
      (by
        have := ((tendsto_log_pow_mul ha (k + 1)).neg).div_const a
        simpa using this)
    rw [integral_sub hk1 (hk.const_mul _), integral_const_mul, ih] at hF
    simp only [Real.log_one, ne_eq, Nat.add_eq_zero_iff, one_ne_zero, and_false, not_false_eq_true,
      zero_pow, zero_mul, neg_zero, zero_div, sub_zero] at hF
    have hfac : ((k + 1).factorial : ℝ) = ((k : ℝ) + 1) * k.factorial := by
      rw [Nat.factorial_succ]; push_cast; ring
    rw [hfac]
    have ha0 : a ≠ 0 := ha.ne'
    have : ∫ y in Ioi (1 : ℝ), Real.log y ^ (k + 1) * y ^ (-a - 1)
        = ((k : ℝ) + 1) / a * (k.factorial / a ^ (k + 1)) := by linarith
    rw [this]
    field_simp
    try ring

/-- info: 'LandauKernel.log_pow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_pow_le

/-- info: 'LandauKernel.log_pow_integrable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_pow_integrable

/-- info: 'LandauKernel.log_pow_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_pow_integral

end

end LandauKernel
