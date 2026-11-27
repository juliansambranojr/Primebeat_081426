/-
Landing — why a balance is exact only where its two sides meet within one unit.

The answer to unit 0593's open question, part 3. A cell of Julian's table is an integer. Split it as
a smooth part `S` and an oscillation `O` (real numbers, `cell = S + O`). Then the cell is zero only
when the two sides meet within one unit, `|S + O| < 1`, and it is nonzero whenever either side beats
the other by one or more. At (8,3) the sides are about ±2.05, at (20,6) about ±453; at a switch
where they are tens of thousands, landing exactly is the rare event.
-/
import Mathlib

namespace Landing

/-- **An integer cell is zero only when its two sides meet within one unit.** -/
theorem zero_only_if_meet {c : ℤ} {S O : ℝ} (h : (c : ℝ) = S + O) (hc : c = 0) : |S + O| < 1 := by
  rw [← h, hc]; norm_num

/-- **One side beating the other by a unit or more keeps the cell off zero.** -/
theorem ne_zero_of_gap {c : ℤ} {S O : ℝ} (h : (c : ℝ) = S + O) (hgap : 1 ≤ |S| - |O|) : c ≠ 0 := by
  intro hc
  have h0 : S + O = 0 := by rw [← h, hc]; norm_num
  have : |S| = |O| := by rw [show S = -O by linarith, abs_neg]
  linarith

/-- The same with the oscillation the larger. -/
theorem ne_zero_of_gap' {c : ℤ} {S O : ℝ} (h : (c : ℝ) = S + O) (hgap : 1 ≤ |O| - |S|) : c ≠ 0 := by
  intro hc
  have h0 : S + O = 0 := by rw [← h, hc]; norm_num
  have : |S| = |O| := by rw [show S = -O by linarith, abs_neg]
  linarith

/-- **An integer cell with a nonzero value is at least one in size.** So between a negative and a
positive cell an integer sequence either lands on zero or jumps it by a whole unit or more. -/
theorem one_le_abs_of_ne {c : ℤ} (hc : c ≠ 0) : (1 : ℝ) ≤ |(c : ℝ)| := by
  have : (1 : ℤ) ≤ |c| := Int.one_le_abs hc
  exact_mod_cast this

end Landing

/-- info: 'Landing.ne_zero_of_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Landing.ne_zero_of_gap

/-- info: 'Landing.zero_only_if_meet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Landing.zero_only_if_meet
