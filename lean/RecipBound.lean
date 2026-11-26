/-
RecipBound — each term of the exact floor against its main term, pointwise in the offset a ≤ 1:
C(d,i)·|Δ^i (1/(m − a))| ≤ (d/(m − 1 − d))^i · 1/(m − a). With q = d/(m − 1 − d) < 1/2, i.e.
d < (m − 1)/3, the terms past the main one sum to less than it.
-/
import Mathlib
import ExactFloor

namespace ExactFloor
open Finset Nonvanishing

theorem fall_ge (a : ℝ) (ha1 : a ≤ 1) (d : ℕ) (m : ℤ) (hm : (d : ℝ) + 1 < m) :
    ∀ i ≤ d, ((m : ℝ) - a) * ((m : ℝ) - 1 - d) ^ i ≤ fall a i m := by
  intro i
  induction i with
  | zero => intro _; simp [fall]
  | succ n ih =>
    intro hn
    rw [fall_succ_right, pow_succ, ← mul_assoc]
    have hn' : (n : ℝ) + 1 ≤ d := by exact_mod_cast hn
    have hpos : 0 ≤ ((m : ℝ) - 1 - d) := by linarith
    have hpos2 : 0 ≤ ((m : ℝ) - a) * ((m : ℝ) - 1 - d) ^ n := by
      apply mul_nonneg (by linarith) (pow_nonneg hpos _)
    exact mul_le_mul (ih (by omega)) (by linarith) hpos (le_trans hpos2 (ih (by omega)))

/-- **Each term of the floor against the main term, pointwise in the offset.** -/
theorem recip_term_le (a : ℝ) (ha1 : a ≤ 1) {d i : ℕ} (hi : i ≤ d) (m : ℤ)
    (hm : (d : ℝ) + 1 < m) :
    (d.choose i : ℝ) * |(bdiffZ^[i]) (fun x : ℤ => 1 / ((x : ℝ) - a)) m|
      ≤ ((d : ℝ) / ((m : ℝ) - 1 - d)) ^ i * (1 / ((m : ℝ) - a)) := by
  have hq : 0 < (m : ℝ) - 1 - d := by linarith
  have hma : 0 < (m : ℝ) - a := by linarith
  rw [iter_recip a i m (fun j hj => by
    have : (j : ℝ) ≤ d := by exact_mod_cast hj.trans hi
    linarith)]
  have hF := fall_ge a ha1 d m hm i hi
  have hFpos : 0 < fall a i m := lt_of_lt_of_le (by positivity) hF
  rw [abs_div, abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul,
    abs_of_pos hFpos, Nat.abs_cast]
  have hdesc : (d.choose i : ℝ) * i.factorial ≤ (d : ℝ) ^ i := by
    have := Nat.descFactorial_le_pow d i
    rw [Nat.descFactorial_eq_factorial_mul_choose] at this
    have h' : ((i.factorial * d.choose i : ℕ) : ℝ) ≤ ((d ^ i : ℕ) : ℝ) := by exact_mod_cast this
    push_cast at h'; linarith
  rw [div_pow, ← mul_div_assoc, div_mul_div_comm, mul_one]
  apply div_le_div₀ (by positivity) hdesc (by positivity)
  calc (m - 1 - d : ℝ) ^ i * (m - a) = (m - a) * (m - 1 - d) ^ i := by ring
    _ ≤ fall a i m := hF

end ExactFloor

/-- info: 'ExactFloor.recip_term_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactFloor.recip_term_le
