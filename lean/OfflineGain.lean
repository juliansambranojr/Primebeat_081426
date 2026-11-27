/-
OfflineGain — depth does not amplify an offline zero beyond what the row already carries.

Along an edge diagonal a zero `ρ = β + iγ` enters a depth-`d` cell with `|2^ρ − 1|^d ≤ (2^β + 1)^d`
(`EdgeDiagonal.normSq_sub_one_le`), and the on-line zeros' largest factor is `2^(1/2) + 1`. Per unit
of depth an offline zero gains on that background at most `(2^β + 1)/(2^(1/2) + 1)`, and
`offline_gain_le` proves this is at most `2^(β − 1/2)`: the gain the row itself gives per unit of
row. Reading a zero deeper in the table never beats reading it higher in the row.
-/
import Mathlib

namespace OfflineGain

/-- **`2^β + 1 ≤ 2^(β − 1/2)·(2^(1/2) + 1)` for `β ≥ 1/2`**, with equality only at `β = 1/2`. -/
theorem offline_gain_le {β : ℝ} (hβ : 1 / 2 ≤ β) :
    (2 : ℝ) ^ β + 1 ≤ (2 : ℝ) ^ (β - 1 / 2) * ((2 : ℝ) ^ ((1 : ℝ) / 2) + 1) := by
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hsplit : (2 : ℝ) ^ (β - 1 / 2) * (2 : ℝ) ^ ((1 : ℝ) / 2) = (2 : ℝ) ^ β := by
    rw [← Real.rpow_add h2]; congr 1; ring
  have hone : (1 : ℝ) ≤ (2 : ℝ) ^ (β - 1 / 2) :=
    Real.one_le_rpow (by norm_num) (by linarith)
  nlinarith [hsplit]

/-- **Strict off the line.** -/
theorem offline_gain_lt {β : ℝ} (hβ : 1 / 2 < β) :
    (2 : ℝ) ^ β + 1 < (2 : ℝ) ^ (β - 1 / 2) * ((2 : ℝ) ^ ((1 : ℝ) / 2) + 1) := by
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hsplit : (2 : ℝ) ^ (β - 1 / 2) * (2 : ℝ) ^ ((1 : ℝ) / 2) = (2 : ℝ) ^ β := by
    rw [← Real.rpow_add h2]; congr 1; ring
  have hone : (1 : ℝ) < (2 : ℝ) ^ (β - 1 / 2) :=
    Real.one_lt_rpow (by norm_num) (by linarith)
  nlinarith [hsplit]

/-- **Over `d` depths.** The offline zero's gain on the on-line background along an edge diagonal is
at most `2^((β − 1/2)·d)`, the gain of `d` rows. -/
theorem offline_gain_pow_le {β : ℝ} (hβ : 1 / 2 ≤ β) (d : ℕ) :
    ((2 : ℝ) ^ β + 1) ^ d ≤ ((2 : ℝ) ^ (β - 1 / 2)) ^ d * ((2 : ℝ) ^ ((1 : ℝ) / 2) + 1) ^ d := by
  rw [← mul_pow]
  exact pow_le_pow_left₀ (by positivity) (offline_gain_le hβ) d

end OfflineGain

/-- info: 'OfflineGain.offline_gain_pow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms OfflineGain.offline_gain_pow_le

/-- info: 'OfflineGain.offline_gain_lt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms OfflineGain.offline_gain_lt
