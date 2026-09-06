/-
WeilLobe — the 2γ lobe bounded above. Rung 4a of the detection ladder
(units 0316–0318). 2026-09-06.

Unit 0318 wrote the transform at the off-line point as
`(h/2)·[Σc((ε + 2iγ)h) + Σ(εh)]`: the main term `Σ(εh) ≥ εh/24` (unit 0317)
and a lobe at twice the height. Detection needs the lobe SMALL against the
main term, and it is, because the envelope `q(x) = x·P(x)` is smooth and
vanishes to first order at both ends: integrating by parts twice,

    Σc(w) = ∫₋₁¹ q(x)·sinh(wx) dx = (1/w²)·∫₋₁¹ q''(x)·sinh(wx) dx,

with no boundary terms (`q(±1) = q'(±1) = 0`), so

    ‖Σc(w)‖ ≤ (2π + π²)·cosh(Re w) / ‖w‖².                        (†)

At `w = (ε + 2iγ)h`: `Re w = εh`, `‖w‖ ≥ 2γh`, and (†) reads
`‖lobe‖ ≤ (2π + π²)·cosh(εh)/(2γh)²`, decaying like `(γh)⁻²`. Entry 302
records cubic decay from a third vanishing boundary; two orders are enough
for the ladder and crude is the spec.

  P_eq                 P(x) = (1 + cos πx)/2, the half-angle form
  q, q1, q2            the envelope and its two derivatives, explicit
  hasDerivAt_q, hasDerivAt_q1
  q_one, q_neg_one, q1_one, q1_neg_one    the boundary values
  q2_bound             |q''(x)| ≤ π + π²/2 on [−1, 1]
  norm_sinh_le         ‖sinh z‖ ≤ cosh(Re z)
  SigmaC_eq_ibp        Σc(w) = w⁻²·∫ q''·sinh(w·)
  SigmaC_bound         (†)
  lobe_bound           (†) at w = (ε + 2iγ)h

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilTransform

namespace WeilLobe

noncomputable section

open Complex WeilWindow WeilTransform intervalIntegral Real

/-- The half-angle form of the window. -/
theorem P_eq (x : ℝ) : P x = (1 + Real.cos (Real.pi * x)) / 2 := by
  unfold P
  rw [Real.cos_sq]
  rw [show 2 * (Real.pi * x / 2) = Real.pi * x by ring]
  ring

/-- The envelope `q(x) = x·P(x)` in half-angle form. -/
def q (x : ℝ) : ℝ := x * (1 + Real.cos (Real.pi * x)) / 2

/-- `q'`. -/
def q1 (x : ℝ) : ℝ := 1 / 2 + Real.cos (Real.pi * x) / 2 - Real.pi * x / 2 * Real.sin (Real.pi * x)

/-- `q''`. -/
def q2 (x : ℝ) : ℝ := -Real.pi * Real.sin (Real.pi * x) - Real.pi ^ 2 * x / 2 * Real.cos (Real.pi * x)

theorem q_eq (x : ℝ) : x * P x = q x := by
  unfold q; rw [P_eq]; ring

theorem hasDerivAt_cos_pi (x : ℝ) :
    HasDerivAt (fun y : ℝ => Real.cos (Real.pi * y)) (-Real.sin (Real.pi * x) * Real.pi) x := by
  have h := (Real.hasDerivAt_cos (Real.pi * x)).comp x ((hasDerivAt_id' x).const_mul Real.pi)
  exact h.congr_deriv (by ring)

theorem hasDerivAt_sin_pi (x : ℝ) :
    HasDerivAt (fun y : ℝ => Real.sin (Real.pi * y)) (Real.cos (Real.pi * x) * Real.pi) x := by
  have h := (Real.hasDerivAt_sin (Real.pi * x)).comp x ((hasDerivAt_id' x).const_mul Real.pi)
  exact h.congr_deriv (by ring)

theorem hasDerivAt_q (x : ℝ) : HasDerivAt q (q1 x) x := by
  have h : HasDerivAt (fun y : ℝ => y * (1 + Real.cos (Real.pi * y)) / 2) (q1 x) x := by
    refine (((hasDerivAt_id' x).mul ((hasDerivAt_cos_pi x).const_add 1)).div_const 2).congr_deriv ?_
    unfold q1; ring
  exact h

theorem hasDerivAt_q1 (x : ℝ) : HasDerivAt q1 (q2 x) x := by
  have h : HasDerivAt
      (fun y : ℝ => 1 / 2 + Real.cos (Real.pi * y) / 2 - Real.pi * y / 2 * Real.sin (Real.pi * y))
      (q2 x) x := by
    refine (((hasDerivAt_const x (1 / 2 : ℝ)).add ((hasDerivAt_cos_pi x).div_const 2)).sub
      ((((hasDerivAt_id' x).const_mul Real.pi).div_const 2).mul (hasDerivAt_sin_pi x))).congr_deriv ?_
    unfold q2; ring
  exact h

theorem q_one : q 1 = 0 := by
  unfold q; simp [Real.cos_pi]

theorem q_neg_one : q (-1) = 0 := by
  unfold q; simp [Real.cos_pi]

theorem q1_one : q1 1 = 0 := by
  unfold q1; simp [Real.cos_pi, Real.sin_pi]; norm_num

theorem q1_neg_one : q1 (-1) = 0 := by
  unfold q1; simp [Real.cos_pi, Real.sin_pi]; norm_num

@[fun_prop]
theorem continuous_q1 : Continuous q1 := by
  unfold q1; fun_prop

@[fun_prop]
theorem continuous_q2 : Continuous q2 := by
  unfold q2; fun_prop

/-- `|q''(x)| ≤ π + π²/2` on `[−1, 1]`. -/
theorem q2_bound {x : ℝ} (hx : |x| ≤ 1) : |q2 x| ≤ Real.pi + Real.pi ^ 2 / 2 := by
  unfold q2
  have h1 : |(-Real.pi) * Real.sin (Real.pi * x)| ≤ Real.pi := by
    rw [abs_mul, abs_neg, abs_of_pos Real.pi_pos]
    have := Real.abs_sin_le_one (Real.pi * x)
    nlinarith [Real.pi_pos]
  have h2 : |Real.pi ^ 2 * x / 2 * Real.cos (Real.pi * x)| ≤ Real.pi ^ 2 / 2 := by
    rw [abs_mul, abs_div, abs_mul, abs_of_pos (by positivity : (0:ℝ) < Real.pi ^ 2),
        abs_of_pos (by norm_num : (0:ℝ) < 2)]
    have := Real.abs_cos_le_one (Real.pi * x)
    calc Real.pi ^ 2 * |x| / 2 * |Real.cos (Real.pi * x)|
        ≤ Real.pi ^ 2 * 1 / 2 * 1 := by gcongr
      _ = Real.pi ^ 2 / 2 := by ring
  calc |(-Real.pi) * Real.sin (Real.pi * x) - Real.pi ^ 2 * x / 2 * Real.cos (Real.pi * x)|
      ≤ |(-Real.pi) * Real.sin (Real.pi * x)| + |Real.pi ^ 2 * x / 2 * Real.cos (Real.pi * x)| :=
        abs_sub _ _
    _ ≤ Real.pi + Real.pi ^ 2 / 2 := add_le_add h1 h2

/-- `‖sinh z‖ ≤ cosh(Re z)`. -/
theorem norm_sinh_le (z : ℂ) : ‖Complex.sinh z‖ ≤ Real.cosh z.re := by
  calc ‖Complex.sinh z‖ = ‖(Complex.exp z - Complex.exp (-z)) / 2‖ := by rw [Complex.sinh]
    _ = ‖Complex.exp z - Complex.exp (-z)‖ / 2 := by rw [norm_div]; try norm_num
    _ ≤ (‖Complex.exp z‖ + ‖Complex.exp (-z)‖) / 2 := by
        gcongr; exact norm_sub_le _ _
    _ = (Real.exp z.re + Real.exp (-z.re)) / 2 := by
        rw [Complex.norm_exp, Complex.norm_exp, Complex.neg_re]
    _ = Real.cosh z.re := by rw [Real.cosh_eq]; try ring

/-- **Integration by parts, twice**: `Σc(w) = w⁻²·∫ q''·sinh(w·)`. -/
theorem SigmaC_eq_ibp (w : ℂ) (hw : w ≠ 0) :
    SigmaC w = (1 / w ^ 2) * ∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) := by
  unfold SigmaC
  have hq : ∀ x : ℝ, ((x * P x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ))
      = ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) := by
    intro x; rw [q_eq]
  simp_rw [hq]
  have dcosh : ∀ x : ℝ, HasDerivAt (fun y : ℝ => Complex.cosh (w * (y : ℂ)) / w)
      (Complex.sinh (w * (x : ℂ))) x := by
    intro x
    have h1 : HasDerivAt (fun y : ℂ => Complex.cosh (w * y)) (Complex.sinh (w * (x : ℂ)) * w) (x : ℂ) :=
      ((Complex.hasDerivAt_cosh (w * (x : ℂ))).comp (x : ℂ)
        ((hasDerivAt_id' (x : ℂ)).const_mul w)).congr_deriv (by ring)
    exact ((h1.comp_ofReal).div_const w).congr_deriv (by field_simp)
  have dsinh : ∀ x : ℝ, HasDerivAt (fun y : ℝ => Complex.sinh (w * (y : ℂ)) / w)
      (Complex.cosh (w * (x : ℂ))) x := by
    intro x
    have h1 : HasDerivAt (fun y : ℂ => Complex.sinh (w * y)) (Complex.cosh (w * (x : ℂ)) * w) (x : ℂ) :=
      ((Complex.hasDerivAt_sinh (w * (x : ℂ))).comp (x : ℂ)
        ((hasDerivAt_id' (x : ℂ)).const_mul w)).congr_deriv (by ring)
    exact ((h1.comp_ofReal).div_const w).congr_deriv (by field_simp)
  have dq : ∀ x : ℝ, HasDerivAt (fun y : ℝ => ((q y : ℝ) : ℂ)) ((q1 x : ℝ) : ℂ) x :=
    fun x => (hasDerivAt_q x).ofReal_comp
  have dq1 : ∀ x : ℝ, HasDerivAt (fun y : ℝ => ((q1 y : ℝ) : ℂ)) ((q2 x : ℝ) : ℂ) x :=
    fun x => (hasDerivAt_q1 x).ofReal_comp
  have cq1 : Continuous fun y : ℝ => ((q1 y : ℝ) : ℂ) := Complex.continuous_ofReal.comp continuous_q1
  have cq2 : Continuous fun y : ℝ => ((q2 y : ℝ) : ℂ) := Complex.continuous_ofReal.comp continuous_q2
  have csinh : Continuous fun y : ℝ => Complex.sinh (w * (y : ℂ)) := by fun_prop
  have ccosh : Continuous fun y : ℝ => Complex.cosh (w * (y : ℂ)) := by fun_prop
  have ibp1 := integral_mul_deriv_eq_deriv_mul (a := (-1 : ℝ)) (b := 1)
    (u := fun y : ℝ => ((q y : ℝ) : ℂ)) (v := fun y : ℝ => Complex.cosh (w * (y : ℂ)) / w)
    (u' := fun y : ℝ => ((q1 y : ℝ) : ℂ)) (v' := fun y : ℝ => Complex.sinh (w * (y : ℂ)))
    (fun x _ => dq x) (fun x _ => dcosh x)
    (cq1.intervalIntegrable _ _) (csinh.intervalIntegrable _ _)
  have ibp2 := integral_mul_deriv_eq_deriv_mul (a := (-1 : ℝ)) (b := 1)
    (u := fun y : ℝ => ((q1 y : ℝ) : ℂ)) (v := fun y : ℝ => Complex.sinh (w * (y : ℂ)) / w)
    (u' := fun y : ℝ => ((q2 y : ℝ) : ℂ)) (v' := fun y : ℝ => Complex.cosh (w * (y : ℂ)))
    (fun x _ => dq1 x) (fun x _ => dsinh x)
    (cq2.intervalIntegrable _ _) (ccosh.intervalIntegrable _ _)
  simp only [q_one, q_neg_one, q1_one, q1_neg_one, Complex.ofReal_zero, zero_mul, sub_zero,
    zero_sub] at ibp1 ibp2
  have e1 : (∫ x in (-1 : ℝ)..1, ((q1 x : ℝ) : ℂ) * (Complex.cosh (w * (x : ℂ)) / w))
      = (1 / w) * ∫ x in (-1 : ℝ)..1, ((q1 x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ)) := by
    rw [← integral_const_mul]; congr 1; funext x; field_simp
  have e2 : (∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * (Complex.sinh (w * (x : ℂ)) / w))
      = (1 / w) * ∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) := by
    rw [← integral_const_mul]; congr 1; funext x; field_simp
  rw [ibp1, e1, ibp2, e2]
  field_simp

/-- **(†)** `‖Σc(w)‖ ≤ (2π + π²)·cosh(Re w)/‖w‖²`. -/
theorem SigmaC_bound (w : ℂ) (hw : w ≠ 0) :
    ‖SigmaC w‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh w.re / ‖w‖ ^ 2 := by
  rw [SigmaC_eq_ibp w hw, norm_mul, norm_div, norm_one, norm_pow]
  have hbound : ‖∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ))‖
      ≤ (Real.pi + Real.pi ^ 2 / 2) * Real.cosh w.re * |(1 : ℝ) - (-1)| := by
    apply norm_integral_le_of_norm_le_const
    intro x hx
    have hx1 : |x| ≤ 1 := by
      rcases Set.mem_uIoc.mp hx with h | h
      · exact abs_le.mpr ⟨by linarith [h.1], h.2⟩
      · exact abs_le.mpr ⟨by linarith [h.1], by linarith [h.2]⟩
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    have hq := q2_bound hx1
    have hs : ‖Complex.sinh (w * (x : ℂ))‖ ≤ Real.cosh w.re := by
      calc ‖Complex.sinh (w * (x : ℂ))‖ ≤ Real.cosh (w * (x : ℂ)).re := norm_sinh_le _
        _ ≤ Real.cosh w.re := by
          rw [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero, sub_zero]
          rw [← Real.cosh_abs, ← Real.cosh_abs w.re]
          apply Real.cosh_le_cosh.mpr
          rw [abs_abs, abs_abs, abs_mul]
          nlinarith [abs_nonneg w.re, abs_nonneg x]
    have hpi : 0 ≤ Real.pi + Real.pi ^ 2 / 2 := by positivity
    exact mul_le_mul hq hs (norm_nonneg _) hpi
  have hw2 : 0 < ‖w‖ ^ 2 := by positivity
  rw [div_mul_eq_mul_div, one_mul, div_le_div_iff_of_pos_right hw2]
  calc ‖∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ))‖
      ≤ (Real.pi + Real.pi ^ 2 / 2) * Real.cosh w.re * |(1 : ℝ) - (-1)| := hbound
    _ = (2 * Real.pi + Real.pi ^ 2) * Real.cosh w.re := by
        rw [show |(1 : ℝ) - (-1)| = 2 by norm_num]; ring

/-- **The lobe at the off-line point**: for `h, γ > 0`,
`‖Σc((ε + 2iγ)h)‖ ≤ (2π + π²)·cosh(εh)/(2γh)²`. -/
theorem lobe_bound {h γ : ℝ} (hh : 0 < h) (hγ : 0 < γ) (ε : ℝ) :
    ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ))‖
      ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / (2 * γ * h) ^ 2 := by
  set w : ℂ := ((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ) with hw
  have hw' : w = ((ε * h : ℝ) : ℂ) + ((2 * γ * h : ℝ) : ℂ) * Complex.I := by
    rw [hw]; push_cast; ring
  have hre : w.re = ε * h := by rw [hw']; simp
  have him : w.im = 2 * γ * h := by rw [hw']; simp
  have hpos : 0 < 2 * γ * h := by positivity
  have hwne : w ≠ 0 := by
    intro h0
    have : w.im = 0 := by rw [h0]; simp
    linarith [him]
  have hnorm : 2 * γ * h ≤ ‖w‖ := by
    rw [← him]
    exact le_trans (le_abs_self _) (Complex.abs_im_le_norm w)
  calc ‖SigmaC w‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh w.re / ‖w‖ ^ 2 := SigmaC_bound w hwne
    _ = (2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / ‖w‖ ^ 2 := by rw [hre]
    _ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / (2 * γ * h) ^ 2 := by
        apply div_le_div_of_nonneg_left (by positivity) (by positivity)
        exact pow_le_pow_left₀ hpos.le hnorm 2

end

/-- info: 'WeilLobe.SigmaC_eq_ibp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms SigmaC_eq_ibp

/-- info: 'WeilLobe.SigmaC_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms SigmaC_bound

/-- info: 'WeilLobe.lobe_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lobe_bound

end WeilLobe
