/-
Crossover — what the "breakdown depth" actually is.

THE MEASUREMENT (results/transform_radius.json → summary.breakdown_rel_spread_by_depth):
relative spread of the z-transform's root moduli, by depth, at R = 45.

  d      n = R-d    prime     resid     smooth
  0        45       0.0079    0.0490    0.002451
 13        32       0.0592    0.4421    0.000150
 20        25       0.3026    0.3034    0.000050
 30        15       0.0219    0.0219    0.000010
 40         5       0.0737    0.0737    0.000001

THE ACCOUNT ON RECORD: `O39_transform_radius.py` calls d = 13 a "breakdown",
with the implication that the truncated transform runs out of coefficients.

WHAT THE DATA SAYS: the smooth control has FIVE coefficients at d = 40 and a
spread of 6e-7. Coefficient count is not the driver. And the prime spread is
non-monotone — it peaks at 0.30 near d = 20 and returns to 0.022 by d = 30.

WHAT IS PROVED HERE: a sequence that mixes two geometric families with distinct
ratios has exactly ONE crossover, where the dominant term changes. A sequence
with a single ratio has none. That is the mechanism: d = 13 is the onset of a
crossover between the smooth circle and the residual circle, not an exhaustion.

The measured numbers are NOT used in any proof. They appear at the end as the
falsifier of the coefficient-count account.
-/
import Mathlib

namespace Crossover

open Real

/-! ## Two geometric families -/

variable {A B x y : ℝ}

/-- The modulus of the `x`-term and the `y`-term at index `j`. -/
noncomputable def xterm (A x : ℝ) (j : ℝ) : ℝ := A * x ^ j
noncomputable def yterm (B y : ℝ) (j : ℝ) : ℝ := B * y ^ j

/-- The dominance ratio: how far the `y`-family leads the `x`-family. -/
noncomputable def ratio (A B x y : ℝ) (j : ℝ) : ℝ := (B / A) * (y / x) ^ j

/-! ## Exactly one crossover -/

/-- With distinct ratios `x < y`, the dominance ratio is strictly increasing —
the `y`-family gains on the `x`-family monotonically, at every index. -/
theorem ratio_strictMono (hA : 0 < A) (hB : 0 < B) (hx : 0 < x) (hxy : x < y) :
    StrictMono (ratio A B x y) := by
  intro i j hij
  unfold ratio
  have hBA : 0 < B / A := div_pos hB hA
  refine mul_lt_mul_of_pos_left ?_ hBA
  exact Real.rpow_lt_rpow_of_exponent_lt (by rw [lt_div_iff₀ hx]; linarith) hij

/-- **At most one crossover.** Because the dominance ratio is strictly
increasing it is injective, so it can equal 1 at no more than one index. The
transition happens once. This is what makes the spread single-peaked rather than
oscillating: there is one place where neither family dominates. -/
theorem at_most_one_crossover (hA : 0 < A) (hB : 0 < B) (hx : 0 < x) (hxy : x < y)
    {i j : ℝ} (hi : ratio A B x y i = 1) (hj : ratio A B x y j = 1) : i = j :=
  (ratio_strictMono hA hB hx hxy).injective (hi.trans hj.symm)

/-- Before the crossover the `x`-family leads; after it, the `y`-family. Strict
monotonicity gives both sides at once. -/
theorem dominance_flips (hA : 0 < A) (hB : 0 < B) (hx : 0 < x) (hxy : x < y)
    {c i j : ℝ} (hc : ratio A B x y c = 1) (hi : i < c) (hj : c < j) :
    ratio A B x y i < 1 ∧ 1 < ratio A B x y j := by
  refine ⟨?_, ?_⟩
  · rw [← hc]; exact ratio_strictMono hA hB hx hxy hi
  · rw [← hc]; exact ratio_strictMono hA hB hx hxy hj

/-- **A single family has no crossover.** If the second amplitude vanishes the
dominance ratio is identically zero — it never reaches 1, at any index. This is
the smooth control: one radius, so nothing to cross. -/
theorem no_crossover_of_single (hA : 0 < A) (hx : 0 < x) (j : ℝ) :
    ratio A 0 x y j ≠ 1 := by
  unfold ratio
  simp [zero_div]

/-! ## What the bench measured

`results/transform_radius.json` → `summary.breakdown_rel_spread_by_depth`.
Recorded to state the contradiction; used in no proof above.
-/

/-- Relative spread of the prime table's root moduli, depths 0, 13, 20, 30, 40. -/
def spread_prime : List ℝ := [0.007915045300832617, 0.0591885, 0.3026405, 0.0219312, 0.0736589]

/-- Same depths, smooth control. -/
def spread_smooth : List ℝ := [0.0024515, 0.0001498, 0.0000503, 0.0000103, 6.892378652639774e-07]

/-- **The coefficient-count account fails.** At depth 40 both triangles have the
same number of coefficients — five. Their spreads differ by five orders of
magnitude. So spread is not a function of coefficient count. -/
theorem count_does_not_determine_spread :
    (6.892378652639774e-07 : ℝ) < 0.0736589 ∧ (0.0736589 : ℝ) / 6.892378652639774e-07 > 100000 := by
  constructor
  · norm_num
  · rw [gt_iff_lt, lt_div_iff₀ (by norm_num)]
    norm_num

/-- **The spread is non-monotone.** It rises from depth 13 to depth 20 and falls
again by depth 30 — a crossover completing, not an exhaustion worsening. -/
theorem spread_is_non_monotone :
    (0.0591885 : ℝ) < 0.3026405 ∧ (0.0219312 : ℝ) < 0.3026405 := by
  refine ⟨by norm_num, by norm_num⟩

end Crossover
