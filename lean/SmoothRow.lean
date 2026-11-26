/-
SmoothRow — the smooth row is `2^m · H(m)` with the weight `2^(−u)`.

`liRow m − liRow (m−1) = ∫_{m−1}^m 2^t/t dt`, and the substitution `t = m − u` gives
`2^m · ∫₀¹ 2^(−u)/(m − u) du = 2^m · H w2 m` (`liRow_sub_eq`). With `RecipIntegral`
this puts the exact floor under the smooth row (`smoothRow_stencil_pos`).
-/
import Mathlib
import Interpolant
import RecipIntegral

namespace SmoothRow
open Set ExactFloor Nonvanishing

noncomputable section

/-- The weight `2^(−u)`. -/
def w2 (u : ℝ) : ℝ := Real.exp (-(Real.log 2 * u))

theorem w2_cont : ContinuousOn w2 (uIcc 0 1) :=
  (Real.continuous_exp.comp ((continuous_const.mul continuous_id).neg)).continuousOn

theorem w2_nonneg : ∀ u ∈ Icc (0 : ℝ) 1, 0 ≤ w2 u := fun _ _ => (Real.exp_pos _).le

theorem zpow_two_eq (m : ℤ) : (2 : ℝ) ^ m = Real.exp (Real.log 2 * m) := by
  rw [← Real.rpow_intCast, Real.rpow_def_of_pos (by norm_num)]

/-- **The smooth row.** -/
theorem liRow_sub_eq {m : ℤ} (hm : (2 : ℝ) ≤ m) :
    Interpolant.liRow m - Interpolant.liRow ((m - 1 : ℤ) : ℝ) = (2 : ℝ) ^ m * H w2 m := by
  have hm1 : (1 / 2 : ℝ) ≤ ((m - 1 : ℤ) : ℝ) := by push_cast; linarith
  rw [Interpolant.liRow_eq (by linarith), Interpolant.liRow_eq hm1]
  have hint : ∀ a b : ℝ, 1 ≤ a → 1 ≤ b →
      IntervalIntegrable Expansion.f2x MeasureTheory.volume a b := by
    intro a b ha hb
    refine (Interpolant.f2x_continuousOn.mono fun x hx => ?_).intervalIntegrable
    rcases le_total a b with h | h
    · rw [uIcc_of_le h] at hx; exact lt_of_lt_of_le (by norm_num) (ha.trans hx.1)
    · rw [uIcc_of_ge h] at hx; exact lt_of_lt_of_le (by norm_num) (hb.trans hx.1)
  have hm1' : (1 : ℝ) ≤ ((m - 1 : ℤ) : ℝ) := by push_cast; linarith
  rw [add_sub_add_left_eq_sub,
    intervalIntegral.integral_interval_sub_left (hint 1 m le_rfl (by linarith)) (hint 1 _ le_rfl hm1')]
  have hsub : ∫ x in ((m - 1 : ℤ) : ℝ)..(m : ℝ), Expansion.f2x x
      = ∫ u in (0 : ℝ)..1, Expansion.f2x ((m : ℝ) - u) := by
    rw [intervalIntegral.integral_comp_sub_left]; push_cast; simp
  rw [hsub, H, zpow_two_eq, ← intervalIntegral.integral_const_mul]
  refine intervalIntegral.integral_congr fun u _ => ?_
  simp only [Expansion.f2x, w2]
  rw [show Real.log 2 * ((m : ℝ) - u) = Real.log 2 * m + -(Real.log 2 * u) by ring, Real.exp_add]
  ring


theorem H_w2_pos {m : ℤ} (hm : (1 : ℝ) < m) : 0 < H w2 m := by
  unfold H
  refine intervalIntegral.intervalIntegral_pos_of_pos_on ?_ (fun u hu => ?_) zero_lt_one
  · exact (w2_cont.mul (cont_recip hm)).intervalIntegrable
  · have : 0 < (m : ℝ) - u := by linarith [hu.2]
    exact mul_pos (Real.exp_pos _) (by positivity)

/-- **The smooth row's stencil is positive across the band `3d + 1 < r`.** -/
theorem smoothRow_stencil_pos (d : ℕ) (r : ℤ) (hband : 3 * (d : ℝ) + 1 < r) :
    0 < stencilR d (fun m : ℤ => Interpolant.liRow m - Interpolant.liRow ((m - 1 : ℤ) : ℝ)) r := by
  have hd0 : (0 : ℝ) ≤ d := Nat.cast_nonneg d
  have heq : stencilR d (fun m : ℤ => Interpolant.liRow m - Interpolant.liRow ((m - 1 : ℤ) : ℝ)) r
      = stencilR d (fun m => (2 : ℝ) ^ m * H w2 m) r := by
    unfold stencilR
    refine Finset.sum_congr rfl fun k hk => ?_
    have hk' : (k : ℝ) ≤ d := by exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
    show _ * (Interpolant.liRow ((r - k : ℤ) : ℝ) - Interpolant.liRow ((r - k - 1 : ℤ) : ℝ)) = _
    have hbZ : 3 * (d : ℤ) + 1 < r := by exact_mod_cast hband
    have hkZ : (k : ℤ) ≤ d := by exact_mod_cast hk'
    have h2 : (2 : ℤ) ≤ r - k := by omega
    rw [liRow_sub_eq (m := r - k) (by exact_mod_cast h2)]
  rw [heq]
  exact stencil_H_pos w2_cont w2_nonneg d r hband (H_w2_pos (by linarith))

end

end SmoothRow

/-- info: 'SmoothRow.liRow_sub_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms SmoothRow.liRow_sub_eq

/-- info: 'SmoothRow.smoothRow_stencil_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms SmoothRow.smoothRow_stencil_pos
