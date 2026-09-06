/-
WeilWindow — the raised-cosine window of entry 302, first two rungs of the
detection ladder, crude constants. 2026-09-06.

Entry 302 fixes the test function `G(u) = N·(u/h)·P(u/h)·cos(γu)` with
`P(x) = cos²(πx/2)` on `[−1, 1]`, and reads the off-line contribution of a
zero at `1/2 + ε + iγ` as `2|B|²` with, to first order in `ε`,

    |B| = (N h / 2) · Σ(ε h),      Σ(s) = ∫₋₁¹ x·P(x)·sinh(s x) dx,

and `Σ(s) = s·m₂ + s³·m₄/6 + …`, `m₂ = ∫₋₁¹ x²·P(x) dx = 1/3 − 2/π² =
0.130691`. Detection needs `|B|` bounded BELOW, so it needs `Σ(s)` and `m₂`
bounded below; the background it is weighed against needs `m₂₂ = ∫ x²P²`
bounded ABOVE (next rung). This module proves the two lower bounds and one
upper bound, with constants chosen for provability:

  P_nonneg, P_le_one, P_one, P_neg_one    the window is a window
  m2_ge                                   1/24 ≤ m₂      (true value 0.1307)
  m2_le                                   m₂ ≤ 2/3
  Sigma_ge_mul                            0 ≤ s → s·m₂ ≤ Σ(s)
  Sigma_ge                                0 ≤ s → s/24 ≤ Σ(s)

The point of `Sigma_ge_mul`: `x·sinh(s x) ≥ s·x²` for every real `x` when
`s ≥ 0` (`sinh` lies above its argument on the right and below it on the
left, and `x` flips the sign back), so the odd envelope's integral is at
least `s` times the second moment, with no series and no small-`s`
hypothesis. The series' `s³` term is a gain, and it is not needed.

Crude is the spec (CLAUDE.md § Stage-3 conventions): `1/24` where the truth
is `0.1307` is a success if the ladder survives it, and the ladder's
consumer is a lower bound.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib

namespace WeilWindow

noncomputable section

open Real intervalIntegral

/-- The raised-cosine window, `cos²(πx/2)`, read on `[−1, 1]`. -/
def P (x : ℝ) : ℝ := Real.cos (Real.pi * x / 2) ^ 2

/-- The second moment `∫₋₁¹ x²·P(x) dx`. -/
def m2 : ℝ := ∫ x in (-1 : ℝ)..1, x ^ 2 * P x

/-- The odd-envelope integral `Σ(s) = ∫₋₁¹ x·P(x)·sinh(s x) dx`. -/
def Sigma (s : ℝ) : ℝ := ∫ x in (-1 : ℝ)..1, x * P x * Real.sinh (s * x)

theorem P_nonneg (x : ℝ) : 0 ≤ P x := by
  unfold P; positivity

theorem P_le_one (x : ℝ) : P x ≤ 1 := by
  unfold P
  have h := Real.cos_sq_le_one (Real.pi * x / 2)
  simpa using h

theorem P_one : P 1 = 0 := by
  unfold P
  rw [show Real.pi * 1 / 2 = Real.pi / 2 by ring, Real.cos_pi_div_two]
  norm_num

theorem P_neg_one : P (-1) = 0 := by
  unfold P
  rw [show Real.pi * (-1) / 2 = -(Real.pi / 2) by ring, Real.cos_neg, Real.cos_pi_div_two]
  norm_num

@[fun_prop]
theorem continuous_P : Continuous P := by
  unfold P; fun_prop

theorem continuous_x2P : Continuous fun x : ℝ => x ^ 2 * P x :=
  (continuous_pow 2).mul continuous_P

/-- On `|x| ≤ 1/2` the window is at least `1/2`: `cos(πx/2) ≥ cos(π/4) = √2/2`. -/
theorem P_ge_half {x : ℝ} (hx : |x| ≤ 1 / 2) : 1 / 2 ≤ P x := by
  unfold P
  have hx' : |Real.pi * x / 2| ≤ Real.pi / 4 := by
    rw [show Real.pi * x / 2 = (Real.pi / 2) * x by ring, abs_mul,
        abs_of_pos (by positivity : (0 : ℝ) < Real.pi / 2)]
    nlinarith [Real.pi_pos]
  have hcos : Real.cos (Real.pi / 4) ≤ Real.cos (Real.pi * x / 2) := by
    rw [← Real.cos_abs (Real.pi * x / 2)]
    apply Real.cos_le_cos_of_nonneg_of_le_pi (abs_nonneg _) _ hx'
    linarith [Real.pi_pos]
  rw [Real.cos_pi_div_four] at hcos
  have h0 : 0 ≤ Real.cos (Real.pi * x / 2) := by
    have := Real.sqrt_nonneg 2
    linarith
  have hsq : (Real.sqrt 2 / 2) ^ 2 ≤ Real.cos (Real.pi * x / 2) ^ 2 := by
    apply pow_le_pow_left₀ (by positivity) hcos
  have h2 : (Real.sqrt 2 / 2) ^ 2 = 1 / 2 := by
    rw [div_pow, Real.sq_sqrt (by norm_num)]; norm_num
  linarith

theorem m2_le : m2 ≤ 2 / 3 := by
  unfold m2
  have h : (∫ x in (-1 : ℝ)..1, x ^ 2 * P x) ≤ ∫ x in (-1 : ℝ)..1, x ^ 2 := by
    apply integral_mono_on (by norm_num)
    · exact continuous_x2P.intervalIntegrable _ _
    · exact (continuous_pow 2).intervalIntegrable _ _
    · intro x _
      have := P_le_one x
      nlinarith [sq_nonneg x]
  have h2 : (∫ x in (-1 : ℝ)..1, x ^ 2) = 2 / 3 := by
    rw [integral_pow]; norm_num
  linarith

theorem m2_ge : 1 / 24 ≤ m2 := by
  unfold m2
  have hint : IntervalIntegrable (fun x : ℝ => x ^ 2 * P x) MeasureTheory.volume (-1) 1 :=
    continuous_x2P.intervalIntegrable _ _
  have hsub : (∫ x in (-1 / 2 : ℝ)..(1 / 2), x ^ 2 * P x)
      ≤ ∫ x in (-1 : ℝ)..1, x ^ 2 * P x :=
    integral_mono_interval (by norm_num) (by norm_num) (by norm_num)
      (Filter.Eventually.of_forall fun x => by have := P_nonneg x; positivity) hint
  have hlow : (∫ x in (-1 / 2 : ℝ)..(1 / 2), x ^ 2 * (1 / 2 : ℝ))
      ≤ ∫ x in (-1 / 2 : ℝ)..(1 / 2), x ^ 2 * P x := by
    apply integral_mono_on (by norm_num)
    · exact ((continuous_pow 2).mul continuous_const).intervalIntegrable _ _
    · exact continuous_x2P.intervalIntegrable _ _
    · intro x hx
      have hx' : |x| ≤ 1 / 2 := abs_le.mpr ⟨by linarith [hx.1], hx.2⟩
      have := P_ge_half hx'
      nlinarith [sq_nonneg x]
  have hval : (∫ x in (-1 / 2 : ℝ)..(1 / 2), x ^ 2 * (1 / 2 : ℝ)) = 1 / 24 := by
    rw [integral_mul_const, integral_pow]; norm_num
  linarith

/-- `x·sinh(s x) ≥ s·x²` for every real `x`, when `s ≥ 0`. -/
theorem mul_sinh_ge {s : ℝ} (hs : 0 ≤ s) (x : ℝ) : s * x ^ 2 ≤ x * Real.sinh (s * x) := by
  rcases le_or_gt 0 x with hx | hx
  · have h : s * x ≤ Real.sinh (s * x) := Real.self_le_sinh_iff.mpr (by positivity)
    nlinarith
  · have h : Real.sinh (s * x) ≤ s * x := Real.sinh_le_self_iff.mpr (by nlinarith)
    nlinarith

theorem Sigma_ge_mul {s : ℝ} (hs : 0 ≤ s) : s * m2 ≤ Sigma s := by
  unfold Sigma m2
  rw [← integral_const_mul]
  apply integral_mono_on (by norm_num)
  · exact (continuous_const.mul continuous_x2P).intervalIntegrable _ _
  · exact ((continuous_id.mul continuous_P).mul
      (Real.continuous_sinh.comp (continuous_const.mul continuous_id))).intervalIntegrable _ _
  · intro x _
    have h := mul_sinh_ge hs x
    have hP := P_nonneg x
    nlinarith [mul_le_mul_of_nonneg_left h hP]

theorem Sigma_ge {s : ℝ} (hs : 0 ≤ s) : s / 24 ≤ Sigma s := by
  have h1 := Sigma_ge_mul hs
  have h2 := m2_ge
  nlinarith

end

/-- info: 'WeilWindow.m2_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms m2_ge

/-- info: 'WeilWindow.m2_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms m2_le

/-- info: 'WeilWindow.Sigma_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Sigma_ge

end WeilWindow
