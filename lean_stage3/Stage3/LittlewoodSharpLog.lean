/-
LittlewoodSharpLog — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: sharper
Littlewood constants, part 1, the one-variable integrals and the numerals. 2026-11-25.

Three facts the sharper lower side `LittlewoodSharp.horizLower_sharp` integrates.

**One zero's singularity, sharp.** `∫_{1/2}^{2} log|x − β| dx ≥ −(3/2)(1 + log(4/3)) ≥ −2` for
every `β` (the crude form `TuringLW.integral_log_sub_ge` has `−7/2`). With `φ(u) = u log|u|`
(`Real.log` is even), `integral_log` gives `φ(2 − β) − φ(1/2 − β) − 3/2`, and

  `φ(b) − φ(a) ≥ (b − a) log((b − a)/2)` for `a ≤ b`   (`mul_log_sub_ge_sharp`),

in three cases: `0 ≤ a` (superadditivity of `φ` on `[0, ∞)`), `b ≤ 0` (the mirror), and
`a < 0 < b` (`x log x ≥ x log c + x − c` at `c = (b − a)/2`, from `log y ≥ 1 − 1/y`). Equality at
`β` the midpoint, so `(3/2)(1 + log(4/3)) ≈ 1.93` is the sharp constant; `−2` uses
`log(4/3) ≤ 1/3`.

**The pointwise Borel–Carathéodory weight.** On the segment `z(x) = (x − 2)/2`, the outer radius
`r = 25/32` turns `2‖z‖/(r − ‖z‖)` into `2 (2 − x)/(x − 7/16)`, and

  `∫_{1/2}^{2} (2 − x)/(x − 7/16) dx = (25/16) log 25 − 3/2`   (`integral_bcw`).

**Numerals.** `log 25 ≤ 13/4`, `log 84 ≤ 89/20`, `log 3 ≤ 11/10`, `log(25/16) ≤ 1/2`,
`9/50 ≤ log(6/5)`, from `exp 1 > 2.7182818283`, `1 + x + x²/2 ≤ exp x` and `Real.exp_bound'`.

| name | content | status |
|---|---|---|
| `mul_log_sub_ge_sharp` | `a ≤ b ⊢ (b − a) log((b − a)/2) ≤ b log b − a log a` | proved |
| `integral_log_sub_ge_sharp` | `−(3/2)(1 + log(4/3)) ≤ ∫_{1/2}^{2} log(x − β)` | proved |
| `integral_log_sub_ge_two` | `−2 ≤ ∫_{1/2}^{2} log(x − β)` | proved |
| `bcw x` | `(2 − x)/(x − 7/16)` | def |
| `intervalIntegrable_bcw` | `bcw` integrable on `[1/2, 2]` | proved |
| `integral_bcw` | `∫_{1/2}^{2} bcw = (25/16) log 25 − 3/2` | proved |
| `log25_le`, `log84_le'`, `log3_le'`, `log2516_le`, `log65_ge` | the numerals | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Mathlib

namespace LittlewoodSharp

open MeasureTheory

/-- `x log x − x log c ≥ x − c` for `x, c > 0`. -/
theorem mul_log_ge_tangent {x c : ℝ} (hx : 0 < x) (hc : 0 < c) :
    x * Real.log c + x - c ≤ x * Real.log x := by
  have h := Real.one_sub_inv_le_log_of_pos (div_pos hx hc)
  rw [Real.log_div hx.ne' hc.ne', inv_div] at h
  have h2 : x * (1 - c / x) ≤ x * (Real.log x - Real.log c) := mul_le_mul_of_nonneg_left h hx.le
  have h3 : x * (1 - c / x) = x - c := by field_simp
  nlinarith

/-- The case `0 ≤ a ≤ b`: superadditivity, then `log(b − a) ≥ log((b − a)/2)`. -/
theorem sharp_of_nonneg {a b : ℝ} (ha : 0 ≤ a) (hab : a ≤ b) :
    (b - a) * Real.log ((b - a) / 2) ≤ b * Real.log b - a * Real.log a := by
  have e1 : a * Real.log a ≤ a * Real.log b := by
    rcases eq_or_lt_of_le ha with h0 | hpos
    · rw [← h0]; simp
    · exact mul_le_mul_of_nonneg_left (Real.log_le_log hpos hab) ha
  have hd : 0 ≤ b - a := by linarith
  have e2 : (b - a) * Real.log ((b - a) / 2) ≤ (b - a) * Real.log b := by
    rcases eq_or_lt_of_le hd with h0 | hpos
    · rw [← h0]; simp
    · exact mul_le_mul_of_nonneg_left (Real.log_le_log (by positivity) (by linarith)) hd
  have e3 : b * Real.log b = a * Real.log b + (b - a) * Real.log b := by ring
  linarith

/-- **The sharp two-point bound.** `(b − a) log((b − a)/2) ≤ b log b − a log a` for `a ≤ b`. -/
theorem mul_log_sub_ge_sharp {a b : ℝ} (hab : a ≤ b) :
    (b - a) * Real.log ((b - a) / 2) ≤ b * Real.log b - a * Real.log a := by
  rcases le_or_gt 0 a with ha | ha
  · exact sharp_of_nonneg ha hab
  rcases le_or_gt b 0 with hb | hb
  · have h := sharp_of_nonneg (a := -b) (b := -a) (by linarith) (by linarith)
    rw [Real.log_neg_eq_log, Real.log_neg_eq_log, show -a - -b = b - a by ring] at h
    linarith
  · have hc : 0 < (b - a) / 2 := by linarith
    have h1 := mul_log_ge_tangent hb hc
    have h2 := mul_log_ge_tangent (x := -a) (by linarith) hc
    rw [Real.log_neg_eq_log] at h2
    nlinarith

/-- `x ↦ log(x − β)` is integrable on `[1/2, 2]`. -/
theorem intervalIntegrable_log_sub (β : ℝ) :
    IntervalIntegrable (fun x : ℝ => Real.log (x - β)) volume (1 / 2) 2 := by
  have h := (intervalIntegral.intervalIntegrable_log' (a := 1 / 2 - β) (b := 2 - β)).comp_sub_right β
  simpa using h

/-- **One zero's singularity, sharp.** -/
theorem integral_log_sub_ge_sharp (β : ℝ) :
    -((3 / 2) * (1 + Real.log (4 / 3))) ≤ ∫ x in (1 / 2 : ℝ)..2, Real.log (x - β) := by
  rw [intervalIntegral.integral_comp_sub_right (fun x => Real.log x) β, integral_log]
  have h := mul_log_sub_ge_sharp (a := 1 / 2 - β) (b := 2 - β) (by linarith)
  rw [show 2 - β - (1 / 2 - β) = 3 / 2 by ring, show (3 / 2 : ℝ) / 2 = 3 / 4 by norm_num] at h
  have h34 : Real.log (3 / 4) = -Real.log (4 / 3) := by
    rw [show (3 / 4 : ℝ) = (4 / 3)⁻¹ by norm_num, Real.log_inv]
  rw [h34] at h
  linarith

/-- `log(4/3) ≤ 1/3`. -/
theorem log43_le : Real.log (4 / 3) ≤ 1 / 3 := by
  have := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 4 / 3)
  linarith

/-- `−2 ≤ ∫_{1/2}^{2} log(x − β)`. -/
theorem integral_log_sub_ge_two (β : ℝ) :
    -2 ≤ ∫ x in (1 / 2 : ℝ)..2, Real.log (x - β) := by
  have h := integral_log_sub_ge_sharp β
  have h2 := log43_le
  linarith

/-- The pointwise Borel–Carathéodory weight on the segment, outer radius `25/32`. -/
noncomputable def bcw (x : ℝ) : ℝ := (2 - x) / (x - 7 / 16)

theorem continuousOn_bcw : ContinuousOn bcw (Set.uIcc (1 / 2) 2) := by
  rw [Set.uIcc_of_le (by norm_num)]
  unfold bcw
  refine ContinuousOn.div (by fun_prop) (by fun_prop) ?_
  intro x hx
  have := hx.1
  linarith

theorem intervalIntegrable_bcw : IntervalIntegrable bcw volume (1 / 2) 2 :=
  continuousOn_bcw.intervalIntegrable

/-- **The weight integrated.** `∫_{1/2}^{2} (2 − x)/(x − 7/16) dx = (25/16) log 25 − 3/2`. -/
theorem integral_bcw : ∫ x in (1 / 2 : ℝ)..2, bcw x = (25 / 16) * Real.log 25 - 3 / 2 := by
  have hcongr : Set.EqOn bcw (fun x => (25 / 16) * (x - 7 / 16)⁻¹ - 1) (Set.uIcc (1 / 2) 2) := by
    intro x hx
    rw [Set.uIcc_of_le (by norm_num)] at hx
    have hpos : x - 7 / 16 ≠ 0 := by have := hx.1; intro h; linarith
    show (2 - x) / (x - 7 / 16) = 25 / 16 * (x - 7 / 16)⁻¹ - 1
    rw [eq_sub_iff_add_eq, div_add_one hpos, ← div_eq_mul_inv]
    congr 1; ring
  rw [intervalIntegral.integral_congr hcongr]
  have hinv : IntervalIntegrable (fun x : ℝ => (x - 7 / 16)⁻¹) volume (1 / 2) 2 := by
    refine ContinuousOn.intervalIntegrable ?_
    rw [Set.uIcc_of_le (by norm_num)]
    refine ContinuousOn.inv₀ (by fun_prop) ?_
    intro x hx; have := hx.1; intro h; linarith
  rw [intervalIntegral.integral_sub (hinv.const_mul _) intervalIntegrable_const,
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const, smul_eq_mul,
    intervalIntegral.integral_comp_sub_right (fun x => x⁻¹) (7 / 16),
    integral_inv_of_pos (by norm_num) (by norm_num)]
  norm_num

/-- `exp 1 ^ 2 ≥ 7.389`. -/
theorem exp2_ge : (7389 / 1000 : ℝ) ≤ Real.exp 1 * Real.exp 1 := by
  have h := Real.exp_one_gt_d9
  nlinarith

/-- `log 25 ≤ 13/4`. -/
theorem log25_le : Real.log 25 ≤ 13 / 4 := by
  rw [Real.log_le_iff_le_exp (by norm_num)]
  have hq := Real.quadratic_le_exp_of_nonneg (x := 1 / 4) (by norm_num)
  have h1 := Real.exp_one_gt_d9
  have h2 := exp2_ge
  have he : Real.exp (13 / 4) = Real.exp 1 * Real.exp 1 * Real.exp 1 * Real.exp (1 / 4) := by
    rw [← Real.exp_add, ← Real.exp_add, ← Real.exp_add]; norm_num
  rw [he]
  have h3 : (20 : ℝ) ≤ Real.exp 1 * Real.exp 1 * Real.exp 1 := by nlinarith
  nlinarith [Real.exp_pos (1 / 4)]

/-- `log 84 ≤ 89/20`. -/
theorem log84_le' : Real.log 84 ≤ 89 / 20 := by
  rw [Real.log_le_iff_le_exp (by norm_num)]
  have hq := Real.quadratic_le_exp_of_nonneg (x := 9 / 20) (by norm_num)
  have h2 := exp2_ge
  have he : Real.exp (89 / 20) =
      (Real.exp 1 * Real.exp 1) * (Real.exp 1 * Real.exp 1) * Real.exp (9 / 20) := by
    rw [← Real.exp_add, ← Real.exp_add, ← Real.exp_add]; norm_num
  rw [he]
  have h4 : (54 : ℝ) ≤ (Real.exp 1 * Real.exp 1) * (Real.exp 1 * Real.exp 1) := by nlinarith
  nlinarith [Real.exp_pos (9 / 20)]

/-- `log 3 ≤ 11/10`. -/
theorem log3_le' : Real.log 3 ≤ 11 / 10 := by
  rw [Real.log_le_iff_le_exp (by norm_num)]
  have hq := Real.quadratic_le_exp_of_nonneg (x := 1 / 10) (by norm_num)
  have h1 := Real.exp_one_gt_d9
  have he : Real.exp (11 / 10) = Real.exp 1 * Real.exp (1 / 10) := by
    rw [← Real.exp_add]; norm_num
  rw [he]
  nlinarith [Real.exp_pos (1 / 10)]

/-- `log(25/16) ≤ 1/2`. -/
theorem log2516_le : Real.log (25 / 16) ≤ 1 / 2 := by
  have h : Real.log (25 / 16) = 2 * Real.log (5 / 4) := by
    rw [show (25 / 16 : ℝ) = (5 / 4) ^ 2 by norm_num, Real.log_pow]; norm_num
  have h2 := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 5 / 4)
  linarith

/-- `9/50 ≤ log(6/5)`. -/
theorem log65_ge : (9 / 50 : ℝ) ≤ Real.log (6 / 5) := by
  rw [Real.le_log_iff_exp_le (by norm_num)]
  have h := Real.exp_bound' (x := 9 / 50) (by norm_num) (by norm_num) (n := 3) (by norm_num)
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial] at h
  norm_num at h
  linarith

/-- info: 'LittlewoodSharp.mul_log_sub_ge_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mul_log_sub_ge_sharp

/-- info: 'LittlewoodSharp.integral_log_sub_ge_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_log_sub_ge_sharp

/-- info: 'LittlewoodSharp.integral_log_sub_ge_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_log_sub_ge_two

/-- info: 'LittlewoodSharp.integral_bcw' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_bcw

/-- info: 'LittlewoodSharp.log65_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log65_ge

end LittlewoodSharp
