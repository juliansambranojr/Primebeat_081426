/-
TurnaroundLine — a row's balance sits on its one crossover.

Julian's table: each cell is a smooth part and an oscillation. The smooth part halves down the
depth; the oscillation grows. `Crossover.lean` proves that two geometric families with distinct
ratios cross exactly once. This module carries that onto the table.

  PROVED HERE
    pos_of_smooth_wins     smooth part above the oscillation's size ⟹ the cell is positive
    ne_zero_of_osc_wins    oscillation's size above the smooth part ⟹ the cell is not zero
    balance_on_crossover   a zero cell has the two sizes equal: the dominance ratio is 1 there
    at_most_one_balance    if along a row the smooth part is `A x^d` and the oscillation's size
                           is `B y^d` with `x < y`, the row has at most one zero

  NOT PROVED HERE
    That the table's own rows have that two-family form, and that the crossover depth of
    any row past 20 misses an integer balance. The split `cell = S + O` is a hypothesis.

Companion to `Crossover.lean`, `Zeros.zero_iff_repeat`, and the turnaround measurement of
2026-11-26 (exploratory, scratch).
-/
import Mathlib
import Construction
import Crossover

open Construction

namespace TurnaroundLine

/-- Off the line, smooth side: the cell is positive. -/
theorem pos_of_smooth_wins {c S O : ℝ} (h : c = S + O) (hw : |O| < S) : 0 < c := by
  have := neg_abs_le O; linarith

/-- Off the line, oscillation side: the cell is not zero. -/
theorem ne_zero_of_osc_wins {c S O : ℝ} (h : c = S + O) (hS : 0 ≤ S) (hw : S < |O|) :
    c ≠ 0 := by
  intro hc
  have : O = -S := by linarith
  rw [this, abs_neg, abs_of_nonneg hS] at hw
  exact lt_irrefl _ hw

/-- **A balance is on the crossover.** A zero cell with positive smooth part has the
oscillation's size equal to the smooth part. -/
theorem balance_on_crossover {c S O : ℝ} (h : c = S + O) (hS : 0 < S) (hc : c = 0) :
    |O| = S := by
  have : O = -S := by linarith
  rw [this, abs_neg, abs_of_pos hS]

/-- **At most one balance per row.** Along row `r`, if the cell is `S d + O d`, the smooth part
is `A x^d` and the oscillation's size is `B y^d` with `0 < x < y`, two zeros of the row are at
the same depth. -/
theorem at_most_one_balance (N : ℤ → ℤ) (r : ℤ) (S O : ℕ → ℝ) {A B x y : ℝ}
    (hA : 0 < A) (hB : 0 < B) (hx : 0 < x) (hxy : x < y)
    (hsplit : ∀ d, (tableFrom N r d : ℝ) = S d + O d)
    (hS : ∀ d : ℕ, S d = A * x ^ (d : ℝ)) (hO : ∀ d : ℕ, |O d| = B * y ^ (d : ℝ))
    {d₁ d₂ : ℕ} (h₁ : tableFrom N r d₁ = 0) (h₂ : tableFrom N r d₂ = 0) : d₁ = d₂ := by
  have hy : 0 < y := lt_trans hx hxy
  have key : ∀ d : ℕ, tableFrom N r d = 0 → Crossover.ratio A B x y d = 1 := by
    intro d hd
    have hSpos : 0 < S d := by rw [hS d]; positivity
    have hb := balance_on_crossover (hsplit d) hSpos (by exact_mod_cast hd)
    rw [hO d, hS d] at hb
    unfold Crossover.ratio
    rw [Real.div_rpow hy.le hx.le]
    have hxd : 0 < x ^ (d : ℝ) := Real.rpow_pos_of_pos hx _
    field_simp
    linarith
  have := Crossover.at_most_one_crossover hA hB hx hxy (key d₁ h₁) (key d₂ h₂)
  exact_mod_cast this

end TurnaroundLine

/-- info: 'TurnaroundLine.pos_of_smooth_wins' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TurnaroundLine.pos_of_smooth_wins

/-- info: 'TurnaroundLine.ne_zero_of_osc_wins' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TurnaroundLine.ne_zero_of_osc_wins

/-- info: 'TurnaroundLine.balance_on_crossover' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TurnaroundLine.balance_on_crossover

/-- info: 'TurnaroundLine.at_most_one_balance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TurnaroundLine.at_most_one_balance
