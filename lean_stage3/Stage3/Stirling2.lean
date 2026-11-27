/-
Stirling2 — toward the digamma comparison to second order, which drops the `97·log T` from the
Backlund phase (`Stirling.backlundPhase_holds`) and with it the zero count's `b₁` from `112` to
`15`, enough for depth twelve of the table (see `lean/RHDepths.lean`).

`trapezoid_log_le`: the trapezoid rule for `∫ dx/(w+x)` over a unit step, read through `u = 1/w`,
errs by at most `2‖u‖³` when `‖u‖ ≤ 1/2`.
-/
import Mathlib

namespace Stirling2
open Complex

theorem trapezoid_log_le {u : ℂ} (hu : ‖u‖ ≤ 1 / 2) :
    ‖u / 2 * (1 + 1 / (1 + u)) - Complex.log (1 + u)‖ ≤ 2 * ‖u‖ ^ 3 := by
  have hu1 : ‖u‖ < 1 := by linarith
  have hne : (1 : ℂ) + u ≠ 0 := by
    intro h
    have : u = -1 := by linear_combination h
    rw [this] at hu; norm_num at hu
  have hT := Complex.norm_log_sub_logTaylor_le 2 hu1
  have hlt : logTaylor (2 + 1) u = u - u ^ 2 / 2 := by
    simp [logTaylor, Finset.sum_range_succ]; ring
  rw [hlt] at hT
  -- (u/2)(1 + 1/(1+u)) = u − u²/2 + u³/(2(1+u))
  have hid : u / 2 * (1 + 1 / (1 + u)) = (u - u ^ 2 / 2) + u ^ 3 / (2 * (1 + u)) := by
    field_simp; ring
  rw [hid]
  have hsplit : (u - u ^ 2 / 2) + u ^ 3 / (2 * (1 + u)) - Complex.log (1 + u)
      = u ^ 3 / (2 * (1 + u)) - (Complex.log (1 + u) - (u - u ^ 2 / 2)) := by ring
  rw [hsplit]
  have hden : (1 / 2 : ℝ) ≤ ‖(1 : ℂ) + u‖ := by
    have := norm_sub_norm_le (1 : ℂ) (-u)
    simp at this
    have h2 : ‖(1 : ℂ) + u‖ = ‖(1 : ℂ) - -u‖ := by ring_nf
    rw [h2]; linarith
  have hA : ‖u ^ 3 / (2 * (1 + u))‖ ≤ ‖u‖ ^ 3 := by
    rw [norm_div, norm_mul, norm_pow]
    have : ‖(2 : ℂ)‖ = 2 := by simp
    rw [this, div_le_iff₀ (by positivity)]
    have h3 : (0 : ℝ) ≤ ‖u‖ ^ 3 := by positivity
    nlinarith
  have hB : ‖Complex.log (1 + u) - (u - u ^ 2 / 2)‖ ≤ ‖u‖ ^ 3 := by
    refine hT.trans ?_
    have h1 : (1 - ‖u‖)⁻¹ ≤ 2 := by
      rw [inv_le_comm₀ (by linarith) (by norm_num)]; linarith
    have h3 : (0 : ℝ) ≤ ‖u‖ ^ 3 := by positivity
    have : ‖u‖ ^ (2 + 1) * (1 - ‖u‖)⁻¹ ≤ ‖u‖ ^ 3 * 2 := by
      rw [show 2 + 1 = 3 by rfl]; exact mul_le_mul_of_nonneg_left h1 h3
    push_cast
    linarith
  calc _ ≤ ‖u ^ 3 / (2 * (1 + u))‖ + ‖Complex.log (1 + u) - (u - u ^ 2 / 2)‖ := norm_sub_le _ _
    _ ≤ _ := by linarith

end Stirling2

/-- info: 'Stirling2.trapezoid_log_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stirling2.trapezoid_log_le
