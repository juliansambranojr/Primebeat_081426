/-
TuringLWHorizLog — block S14 of `lean_stage3/design/stencil.md`, Turing's method, Littlewood's
pieces: the lower side `StmtHorizLower`, part 1, the integral of one zero's singularity.
2026-11-25.

One zero `ρ` near the segment `[1/2, 2] + it` contributes `log|x + it − ρ|` to `log|ζ|`; that is
at least `log|x − β|` for `β = Re ρ`, and the integral of `log|x − β|` over any interval of length
`3/2` is bounded below by an absolute constant, whatever `β`. With `G(u) = u log u − u`
(`integral_log`, Mathlib, valid for all endpoints since `Real.log` is even):

  `∫_{1/2}^{2} log(x − β) dx = G(2 − β) − G(1/2 − β) ≥ −2 − 3/2 = −7/2`,

from `b log b − a log a ≥ −2` for `a ≤ b` (`mul_log_sub_ge`: three cases on the signs; the key
facts are `u log u ≥ −1` for `u ≥ 0` and `u log u ≤ 0` on `[0, 1]`). The sharp constant is
`(3/2)(log(3/4) − 1) ≈ −1.93`; `−7/2` is the crude one.

| name | content | status |
|---|---|---|
| `mul_log_ge` | `0 ≤ u ⊢ −1 ≤ u log u` | proved |
| `mul_log_sub_ge` | `a ≤ b ⊢ −2 ≤ b log b − a log a` | proved |
| `intervalIntegrable_log_sub` | `x ↦ log(x − β)` integrable on `[1/2, 2]` | proved |
| `integral_log_sub_ge` | `−7/2 ≤ ∫_{1/2}^{2} log(x − β) dx` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Mathlib

namespace TuringLW

open MeasureTheory

/-- `u log u ≥ −1` for `u ≥ 0`. -/
theorem mul_log_ge {u : ℝ} (hu : 0 ≤ u) : -1 ≤ u * Real.log u := by
  rcases eq_or_lt_of_le hu with h0 | hpos
  · rw [← h0]; simp
  · have h := Real.one_sub_inv_le_log_of_pos hpos
    have h2 : u * (1 - u⁻¹) ≤ u * Real.log u := mul_le_mul_of_nonneg_left h hu
    have h3 : u * (1 - u⁻¹) = u - 1 := by field_simp
    linarith

/-- `u log u ≤ 0` on `[0, 1]`. -/
theorem mul_log_nonpos {u : ℝ} (hu : 0 ≤ u) (h1 : u ≤ 1) : u * Real.log u ≤ 0 :=
  mul_nonpos_of_nonneg_of_nonpos hu (Real.log_nonpos hu h1)

/-- The case `0 ≤ a ≤ b`. -/
theorem mul_log_sub_ge_of_nonneg {a b : ℝ} (ha : 0 ≤ a) (hab : a ≤ b) :
    -2 ≤ b * Real.log b - a * Real.log a := by
  rcases le_or_gt a 1 with h1 | h1
  · have := mul_log_nonpos ha h1
    have := mul_log_ge (le_trans ha hab)
    linarith
  · have hlb : Real.log a ≤ Real.log b := Real.log_le_log (by linarith) hab
    have hla : 0 ≤ Real.log a := Real.log_nonneg h1.le
    have e1 : a * Real.log a ≤ a * Real.log b := mul_le_mul_of_nonneg_left hlb ha
    have e2 : a * Real.log b ≤ b * Real.log b :=
      mul_le_mul_of_nonneg_right hab (le_trans hla hlb)
    linarith

/-- **`b log b − a log a ≥ −2` for all `a ≤ b`** (`Real.log` is even). -/
theorem mul_log_sub_ge {a b : ℝ} (hab : a ≤ b) :
    -2 ≤ b * Real.log b - a * Real.log a := by
  rcases le_or_gt 0 a with ha | ha
  · exact mul_log_sub_ge_of_nonneg ha hab
  rcases le_or_gt b 0 with hb | hb
  · have h := mul_log_sub_ge_of_nonneg (a := -b) (b := -a) (by linarith) (by linarith)
    rw [Real.log_neg_eq_log, Real.log_neg_eq_log] at h
    linarith
  · have h1 := mul_log_ge hb.le
    have h2 := mul_log_ge (u := -a) (by linarith)
    rw [Real.log_neg_eq_log] at h2
    linarith

/-- `x ↦ log(x − β)` is integrable on `[1/2, 2]`. -/
theorem intervalIntegrable_log_sub (β : ℝ) :
    IntervalIntegrable (fun x : ℝ => Real.log (x - β)) volume (1 / 2) 2 := by
  have h := (intervalIntegral.intervalIntegrable_log' (a := 1 / 2 - β) (b := 2 - β)).comp_sub_right β
  simpa using h

/-- **One zero's singularity, integrated.** `∫_{1/2}^{2} log(x − β) dx ≥ −7/2` for every `β`. -/
theorem integral_log_sub_ge (β : ℝ) :
    -(7 / 2) ≤ ∫ x in (1 / 2 : ℝ)..2, Real.log (x - β) := by
  rw [intervalIntegral.integral_comp_sub_right (fun x => Real.log x) β, integral_log]
  have h := mul_log_sub_ge (a := 1 / 2 - β) (b := 2 - β) (by linarith)
  linarith

/-- info: 'TuringLW.mul_log_sub_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mul_log_sub_ge

/-- info: 'TuringLW.intervalIntegrable_log_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms intervalIntegrable_log_sub

/-- info: 'TuringLW.integral_log_sub_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_log_sub_ge

end TuringLW
