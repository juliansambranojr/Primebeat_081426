/-
PNTWeld — the prime number theorem read at the doublings.

`subst_doubling`: `∫ t in 1..m, 2^t/t = ∫ x in 2..2^m, 1/log x`, the substitution `x = 2^t`.
-/
import Mathlib
import PrimeNumberTheoremAnd.Consequences

namespace Stage3.PNTWeld
open Real Set

theorem subst_doubling (m : ℝ) :
    ∫ t in (1 : ℝ)..m, Real.exp (Real.log 2 * t) / t
      = ∫ x in (2 : ℝ)..Real.exp (Real.log 2 * m), 1 / Real.log x := by
  have hl : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have key := intervalIntegral.integral_comp_mul_deriv_of_deriv_nonneg (a := (1 : ℝ)) (b := m)
    (f := fun t => Real.exp (Real.log 2 * t)) (f' := fun t => Real.exp (Real.log 2 * t) * Real.log 2)
    (g := fun x => 1 / Real.log x)
    (Real.continuous_exp.comp (continuous_const.mul continuous_id)).continuousOn
    (fun t _ => by
      have := ((hasDerivAt_id t).const_mul (Real.log 2)).exp
      simpa [mul_comm] using this)
    (fun t _ => by positivity)
  simp only [Function.comp, mul_one, Real.exp_log (by norm_num : (0 : ℝ) < 2)] at key
  rw [← key]
  refine intervalIntegral.integral_congr fun t _ => ?_
  show Real.exp (Real.log 2 * t) / t = 1 / Real.log (Real.exp (Real.log 2 * t)) * (Real.exp (Real.log 2 * t) * Real.log 2)
  rw [Real.log_exp]
  by_cases ht : t = 0
  · subst ht; simp
  · field_simp

end Stage3.PNTWeld

/-- info: 'Stage3.PNTWeld.subst_doubling' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.PNTWeld.subst_doubling
