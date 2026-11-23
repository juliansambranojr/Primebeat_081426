/-
StepsPole — block R4 of `lean_stage3/design/runs.md`. 2026-11-23.

Unit 0472 turned the steps of the staircase and saw them line up at the
heights of the zeros. The exact core: the sum of the turned steps is the
logarithmic derivative of zeta, and it has a pole at every nontrivial zero,
whose weight is the zero's order over the zero, the same weight the zero
carries in the table's residual.

  steps_sum          1 < Re s ⊢ Σ Λ(n)·n^(−s) = −ζ'(s)/ζ(s): the turned steps
  order_pos          a nontrivial zero has order at least one
  steps_pole         at a nontrivial zero ρ of order m,
                       (s − ρ)·(−ζ'(s)/ζ(s)/s) → −m/ρ as s → ρ
  steps_pole_ne_zero that limit is not zero: the pole is there
  steps_regular      where ζ does not vanish (and s ≠ 1) the logarithmic
                       derivative is analytic: no pole away from the zeros

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.SieveResidual
import Stage3.ContourShift

namespace StepsPole

open Filter Topology Kadiri

/-- **The turned steps.** Right of the line `Re s = 1` the sum over the integers
of the step `Λ(n)` turned and weighed by `n^(−s)` is minus the logarithmic
derivative of zeta. -/
theorem steps_sum {s : ℂ} (hs : 1 < s.re) :
    LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s
      = - deriv riemannZeta s / riemannZeta s :=
  ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs

/-- A nontrivial zero has order at least one. -/
theorem order_pos (ρ : NontrivialZeros) : 0 < analyticOrderNatAt riemannZeta (ρ : ℂ) := by
  have hρ1 : (ρ : ℂ) ≠ 1 := nontrivialZero_ne_one ρ
  have hz : riemannZeta (ρ : ℂ) = 0 := ρ.2.2.2
  have han := ContourShift.zeta_analyticAt hρ1
  have htop := ContourShift.zeta_order_ne_top hρ1
  rw [Nat.pos_iff_ne_zero]
  intro h0
  have h1 : analyticOrderAt riemannZeta (ρ : ℂ) = 0 := by
    have := ENat.coe_toNat htop
    unfold analyticOrderNatAt at h0
    rw [h0] at this
    exact_mod_cast this.symm
  exact (han.analyticOrderAt_eq_zero.mp h1) hz

/-- **The pole at a zero.** At a nontrivial zero `ρ` of order `m`, the turned
steps' sum over `s`, times the distance `s − ρ`, tends to `−m/ρ`. -/
theorem steps_pole (ρ : NontrivialZeros) :
    Tendsto (fun s : ℂ => (s - (ρ : ℂ)) * (- deriv riemannZeta s / riemannZeta s / s))
      (𝓝[≠] (ρ : ℂ))
      (𝓝 (-(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ))) := by
  have hρ1 : (ρ : ℂ) ≠ 1 := nontrivialZero_ne_one ρ
  have hρ0 : (ρ : ℂ) ≠ 0 := by
    intro h
    have := ρ.2.1.1
    rw [h] at this
    simp at this
  have hz : riemannZeta (ρ : ℂ) = 0 := ρ.2.2.2
  obtain ⟨h, hh, hev⟩ := ContourShift.zeta_local_data_zero (x := 1) one_pos hρ0 hρ1 hz
  set c : ℂ := -(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ) with hc
  have hlim : Tendsto (fun s : ℂ => (s - (ρ : ℂ)) * h s + c) (𝓝[≠] (ρ : ℂ)) (𝓝 c) := by
    have h1 : Tendsto (fun s : ℂ => (s - (ρ : ℂ)) * h s + c) (𝓝 (ρ : ℂ))
        (𝓝 (((ρ : ℂ) - (ρ : ℂ)) * h (ρ : ℂ) + c)) :=
      (((continuous_id.sub continuous_const).continuousAt).mul hh.continuousAt).add_const c
    rw [sub_self, zero_mul, zero_add] at h1
    exact h1.mono_left nhdsWithin_le_nhds
  refine hlim.congr' ?_
  filter_upwards [hev, self_mem_nhdsWithin] with s hs hne
  have hsne : s - (ρ : ℂ) ≠ 0 := sub_ne_zero.mpr hne
  have e : - deriv riemannZeta s / riemannZeta s / s = h s + c / (s - (ρ : ℂ)) := by
    have := hs
    simp only [Complex.ofReal_one, Complex.one_cpow, mul_one] at this
    rw [this, hc]
  rw [e, mul_add, mul_div_cancel₀ _ hsne]

/-- The pole is there: its weight is not zero. -/
theorem steps_pole_ne_zero (ρ : NontrivialZeros) :
    -(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ) ≠ 0 := by
  have hρ0 : (ρ : ℂ) ≠ 0 := by
    intro h
    have := ρ.2.1.1
    rw [h] at this
    simp at this
  have hm : (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) ≠ 0 := by
    exact_mod_cast (order_pos ρ).ne'
  exact div_ne_zero (neg_ne_zero.mpr hm) hρ0

/-- **No pole away from the zeros.** Where zeta does not vanish, and away from
`1`, the logarithmic derivative of zeta is analytic. -/
theorem steps_regular {s : ℂ} (hs1 : s ≠ 1) (hz : riemannZeta s ≠ 0) :
    AnalyticAt ℂ (fun t : ℂ => deriv riemannZeta t / riemannZeta t) s :=
  (ContourShift.zeta_analyticAt hs1).deriv.div (ContourShift.zeta_analyticAt hs1) hz

/-- info: 'StepsPole.steps_pole' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms steps_pole

/-- info: 'StepsPole.steps_pole_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms steps_pole_ne_zero

/-- info: 'StepsPole.steps_regular' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms steps_regular

end StepsPole
