/-
PsiToPi — step 3: the transfer from ψ-error to π−Li error.

The classical chain: Mathlib's Abel-summation bridge
(`Chebyshev.primeCounting_eq_theta_div_log_add_integral`) writes
π(⌊x⌋) = θ(x)/log x + ∫₂ˣ θ(t)/(t·log²t) dt, and the same identity for
the logarithmic integral turns any bound on |θ − id| into a bound on
|π − Li|. Mathlib carries no li, so this module defines its own:

  Li x = x/log x + ∫₂ˣ dt/log²t

which differs from the literature's li by the constant li(2) ≈ 1.045 —
an offset the weak family's constants absorb. What this slice proves,
all integrability discharged:

  pi_sub_Li_eq        π(⌊x⌋) − Li x = (θx − x)/log x + ∫₂ˣ (θt − t)/(t·log²t)
                      — the EXACT decomposition, an identity
  abs_pi_sub_Li_le    the envelope transfer: any pointwise bound on
                      |θ − id| gives |π − Li| ≤ top/log x + ∫ env/(t·log²t)
  theta_err_of_psi    |θ − id| from |ψ − id| by Mathlib's |ψ−θ| ≤ 2√x·log x
  integral_A_rpow_le  the workhorse envelope integral: ∫₂ˣ A·t^(−1/2) ≤ 2A√x

Next slice: instantiate env with the family shape C·√t·(log t)^k and
compute the delivered (C', k−1) — the transfer drops one log and
inflates the constant explicitly.

The weld caveat from Stage3.lean applies. Companion to notes entry 122.
-/
import Mathlib

namespace Stage3

open Chebyshev MeasureTheory
open scoped Chebyshev

noncomputable section

/-- The offset logarithmic integral: `Li x = x/log x + ∫₂ˣ dt/log²t`.
Differs from the literature's `li` by the constant `li(2) ≈ 1.045`. -/
def Li (x : ℝ) : ℝ := x / Real.log x + ∫ t in (2 : ℝ)..x, 1 / Real.log t ^ 2

/-- `1/log²t` is continuous on any interval right of `2`. -/
theorem continuousOn_inv_log_sq {x : ℝ} (hx : 2 ≤ x) :
    ContinuousOn (fun t : ℝ => 1 / Real.log t ^ 2) (Set.uIcc 2 x) := by
  rw [Set.uIcc_of_le hx]
  intro t ht
  have h2t : (2 : ℝ) ≤ t := ht.1
  have hlog : Real.log t ≠ 0 := ne_of_gt (Real.log_pos (by linarith))
  exact continuousWithinAt_const.div
    (((Real.continuousAt_log (by linarith)).continuousWithinAt).pow 2)
    (pow_ne_zero 2 hlog)

/-- `(t·log²t)⁻¹` is continuous on any interval right of `2`. -/
theorem continuousOn_inv_mul_log_sq {x : ℝ} (hx : 2 ≤ x) :
    ContinuousOn (fun t : ℝ => (t * Real.log t ^ 2)⁻¹) (Set.uIcc 2 x) := by
  rw [Set.uIcc_of_le hx]
  intro t ht
  have h2t : (2 : ℝ) ≤ t := ht.1
  have hlog : Real.log t ≠ 0 := ne_of_gt (Real.log_pos (by linarith))
  have hne : t * Real.log t ^ 2 ≠ 0 :=
    mul_ne_zero (by linarith) (pow_ne_zero 2 hlog)
  exact (continuousWithinAt_id.mul
    (((Real.continuousAt_log (by linarith)).continuousWithinAt).pow 2)).inv₀ hne

/-- `θ(t)/(t·log²t)` is interval integrable on `[2, x]`: `θ` is monotone,
the cofactor is continuous. -/
theorem integrable_theta_term {x : ℝ} (hx : 2 ≤ x) :
    IntervalIntegrable (fun t => θ t / (t * Real.log t ^ 2)) volume 2 x := by
  have hθ : IntervalIntegrable θ volume 2 x :=
    (theta_mono.monotoneOn _).intervalIntegrable
  have h := hθ.mul_continuousOn (continuousOn_inv_mul_log_sq hx)
  simpa [div_eq_mul_inv] using h

/-- `(θ(t) − t)/(t·log²t)` is interval integrable on `[2, x]`. -/
theorem integrable_err_term {x : ℝ} (hx : 2 ≤ x) :
    IntervalIntegrable (fun t => (θ t - t) / (t * Real.log t ^ 2)) volume 2 x := by
  have hθ : IntervalIntegrable θ volume 2 x :=
    (theta_mono.monotoneOn _).intervalIntegrable
  have hid : IntervalIntegrable (fun t : ℝ => t) volume 2 x :=
    (continuous_id.continuousOn).intervalIntegrable
  have h := (hθ.sub hid).mul_continuousOn (continuousOn_inv_mul_log_sq hx)
  simpa [div_eq_mul_inv] using h

/-- **The exact decomposition** — an identity, from Mathlib's Abel-summation
bridge and the definition of `Li`:
`π(⌊x⌋) − Li x = (θx − x)/log x + ∫₂ˣ (θt − t)/(t·log²t) dt`. -/
theorem pi_sub_Li_eq {x : ℝ} (hx : 2 ≤ x) :
    (Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x
      = (θ x - x) / Real.log x
        + ∫ t in (2 : ℝ)..x, (θ t - t) / (t * Real.log t ^ 2) := by
  have hbridge := Chebyshev.primeCounting_eq_theta_div_log_add_integral hx
  have hAB : (∫ t in (2 : ℝ)..x, θ t / (t * Real.log t ^ 2))
        - ∫ t in (2 : ℝ)..x, 1 / Real.log t ^ 2
      = ∫ t in (2 : ℝ)..x, (θ t - t) / (t * Real.log t ^ 2) := by
    rw [← intervalIntegral.integral_sub (integrable_theta_term hx)
      ((continuousOn_inv_log_sq hx).intervalIntegrable)]
    apply intervalIntegral.integral_congr
    intro t ht
    rw [Set.uIcc_of_le hx] at ht
    have h2t : (2 : ℝ) ≤ t := ht.1
    have h0 : t ≠ 0 := by linarith
    have hlog : Real.log t ≠ 0 := ne_of_gt (Real.log_pos (by linarith))
    field_simp
  unfold Li
  linear_combination hbridge + hAB

/-- **The envelope transfer:** a pointwise bound on `|θ − id|` becomes a
bound on `|π − Li|`, top term plus envelope integral. -/
theorem abs_pi_sub_Li_le {x : ℝ} (hx : 2 ≤ x) {env : ℝ → ℝ}
    (hEnv : ∀ t ∈ Set.Icc (2 : ℝ) x, |θ t - t| ≤ env t)
    (hEnvInt : IntervalIntegrable
      (fun t => env t / (t * Real.log t ^ 2)) volume 2 x) :
    |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x|
      ≤ |θ x - x| / Real.log x
        + ∫ t in (2 : ℝ)..x, env t / (t * Real.log t ^ 2) := by
  rw [pi_sub_Li_eq hx]
  refine le_trans (abs_add_le _ _) (add_le_add ?_ ?_)
  · rw [abs_div, abs_of_pos (Real.log_pos (by linarith : (1 : ℝ) < x))]
  · rw [← Real.norm_eq_abs]
    refine intervalIntegral.norm_integral_le_of_norm_le
      (by linarith : (2 : ℝ) ≤ x) ?_ hEnvInt
    filter_upwards with t ht
    have h2t : (2 : ℝ) ≤ t := le_of_lt ht.1
    have htx : t ≤ x := ht.2
    have hpos : 0 < t * Real.log t ^ 2 :=
      mul_pos (by linarith)
        (pow_pos (Real.log_pos (by linarith)) 2)
    rw [Real.norm_eq_abs, abs_div, abs_of_pos hpos]
    gcongr
    exact hEnv t ⟨h2t, htx⟩

/-- **The workhorse envelope integral:** `∫₂ˣ A·t^(−1/2) dt ≤ 2A·√x`. -/
theorem integral_A_rpow_le {x A : ℝ} (hx : 2 ≤ x) (hA : 0 ≤ A) :
    (∫ t in (2 : ℝ)..x, A * t ^ (-(1 : ℝ) / 2)) ≤ 2 * A * Real.sqrt x := by
  rw [intervalIntegral.integral_const_mul]
  have h0 : (0 : ℝ) ∉ Set.uIcc 2 x := by
    rw [Set.uIcc_of_le hx]
    rintro ⟨h02, _⟩
    linarith
  rw [integral_rpow (Or.inl (by norm_num))]
  have hxs : x ^ (-(1 : ℝ) / 2 + 1) = Real.sqrt x := by
    rw [show (-(1 : ℝ) / 2 + 1) = 1 / 2 by norm_num, ← Real.sqrt_eq_rpow]
  have h2s : (0 : ℝ) ≤ (2 : ℝ) ^ (-(1 : ℝ) / 2 + 1) :=
    Real.rpow_nonneg (by norm_num) _
  rw [hxs]
  have hs : 0 ≤ Real.sqrt x := Real.sqrt_nonneg x
  have expand : (Real.sqrt x - (2 : ℝ) ^ (-(1 : ℝ) / 2 + 1)) / (-(1 : ℝ) / 2 + 1)
      = 2 * (Real.sqrt x - (2 : ℝ) ^ (-(1 : ℝ) / 2 + 1)) := by
    ring
  rw [expand]
  nlinarith [mul_nonneg hA h2s]

/-- **`θ`-error from `ψ`-error**, by Mathlib's `|ψ − θ| ≤ 2√x·log x`. -/
theorem theta_err_of_psi {x E : ℝ} (hx : 1 ≤ x) (hψ : |ψ x - x| ≤ E) :
    |θ x - x| ≤ E + 2 * Real.sqrt x * Real.log x := by
  have h := Chebyshev.abs_psi_sub_theta_le_sqrt_mul_log hx
  calc |θ x - x| ≤ |θ x - ψ x| + |ψ x - x| := abs_sub_le _ _ _
    _ = |ψ x - θ x| + |ψ x - x| := by rw [abs_sub_comm]
    _ ≤ 2 * Real.sqrt x * Real.log x + E := add_le_add h hψ
    _ = E + 2 * Real.sqrt x * Real.log x := by ring

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.continuousOn_inv_log_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.continuousOn_inv_log_sq

/-- info: 'Stage3.continuousOn_inv_mul_log_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.continuousOn_inv_mul_log_sq

/-- info: 'Stage3.integrable_theta_term' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.integrable_theta_term

/-- info: 'Stage3.integrable_err_term' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.integrable_err_term

/-- info: 'Stage3.pi_sub_Li_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.pi_sub_Li_eq

/-- info: 'Stage3.abs_pi_sub_Li_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.abs_pi_sub_Li_le

/-- info: 'Stage3.integral_A_rpow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.integral_A_rpow_le

/-- info: 'Stage3.theta_err_of_psi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.theta_err_of_psi

end Stage3
