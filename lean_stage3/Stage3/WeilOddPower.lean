/-
WeilOddPower — the odd envelope `sin(πx)·P(x)^m` and its transform in
closed form; the switched window and its transform. Rung 5, third slice.
2026-09-06.

Unit 0329 gave `K m w = ∫₋₁¹ P^m e^{wx} dx` in closed form. The window's
envelope has to be odd (unit 0326: oddness is what makes every term of the
zero form minus a square). Entry 302's odd factor was `x`, whose transform
is the `w`-derivative of `K`, awkward to bound. This module takes the odd
factor `sin(πx)` instead:

    q m x = sin(πx)·P(x)^m = 2·sin(πx/2)·c(x)^{2m+1},      c = cos(πx/2),

which is an exact derivative, `q m = −(2/((m+1)π))·(c^{2m+2})'`. One
integration by parts then gives the transform with no derivative in it:

  S_eq        S m w = 2w·K (m+1) w / ((m+1)π),
  S_mul_QS    S m w · ∏_{j=1}^{m+1}(w² + π²j²) = 2·π^{2m+1}·(2m+1)!/4^m · sinh w.

At `m = 0`, `S 0 w · (w² + π²) = 2π·sinh w`, the elementary integral of
`sin(πx)e^{wx}`. The statement is multiplied out and holds at every `w`.

The window. `W h γ m u = q m (u/h)·cos(γu)` on `[−h, h]`, and its transform

  what_eq     what h γ m z = (h/2)·[S m ((z + iγ)h) + S m ((z − iγ)h)],

the same shape as unit 0318's `ghat_eq`, by the same change of variables
and the same splitting of the carrier `cos(γu)` into two exponentials.

What the closed form gives: the transform of the window at any point of
the plane is `sinh` over a polynomial of degree `2m + 2` in `w`, with all
its zeros on the imaginary axis at `±iπj`. The bounds of the next slice
read off that polynomial.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPower

namespace WeilOddPower

noncomputable section

open Complex WeilWindow WeilTransform WeilPower intervalIntegral Real

/-- The odd envelope `sin(πx)·P(x)^m`. -/
def q (m : ℕ) (x : ℝ) : ℝ := Real.sin (Real.pi * x) * P x ^ m

theorem q_odd (m : ℕ) (x : ℝ) : q m (-x) = -q m x := by
  unfold q
  rw [show Real.pi * (-x) = -(Real.pi * x) by ring, Real.sin_neg, P_even]
  ring

theorem continuous_q (m : ℕ) : Continuous (q m) := by
  unfold q
  exact (by fun_prop : Continuous fun x : ℝ => Real.sin (Real.pi * x)).mul (continuous_P.pow m)

attribute [fun_prop] continuous_q

/-- `sin(πx) = 2·sin(πx/2)·c(x)`. -/
theorem sin_pi_mul (x : ℝ) : Real.sin (Real.pi * x) = 2 * Real.sin (Real.pi * x / 2) * c x := by
  unfold c
  have h := Real.sin_two_mul (Real.pi * x / 2)
  rw [show 2 * (Real.pi * x / 2) = Real.pi * x by ring] at h
  exact h

/-- The odd envelope is an exact derivative: `q m = −(2/((m+1)π))·f1 (2m+1)`,
where `f1 (2m+1)` is the derivative of `c^{2m+2}`. -/
theorem q_eq (m : ℕ) (x : ℝ) : q m x = -(2 / (((m : ℝ) + 1) * Real.pi)) * f1 (2 * m + 1) x := by
  unfold q f1
  rw [sin_pi_mul, P_pow]
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hm : ((m : ℝ) + 1) ≠ 0 := by positivity
  push_cast
  field_simp
  ring

/-- The odd envelope's transform, `∫₋₁¹ q m x · e^{wx} dx`. -/
def S (m : ℕ) (w : ℂ) : ℂ :=
  ∫ x in (-1 : ℝ)..1, ((q m x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))

/-- One integration by parts: `∫ f1 (k+1) · E = −w·∫ c^{k+2} · E`. -/
theorem ibp_once (k : ℕ) (w : ℂ) :
    (∫ x in (-1 : ℝ)..1, ((f1 (k + 1) x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)))
      = -(w * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) := by
  have cE' : Continuous fun y : ℝ => w * Complex.exp (w * (y : ℂ)) := by fun_prop
  have cf1 : Continuous fun y : ℝ => ((f1 (k + 1) y : ℝ) : ℂ) :=
    Complex.continuous_ofReal.comp (continuous_f1 (k + 1))
  have ibp := integral_mul_deriv_eq_deriv_mul (a := (-1 : ℝ)) (b := 1)
    (u := fun y : ℝ => Complex.exp (w * (y : ℂ)))
    (v := fun y : ℝ => ((c y ^ (k + 2) : ℝ) : ℂ))
    (u' := fun y : ℝ => w * Complex.exp (w * (y : ℂ)))
    (v' := fun y : ℝ => ((f1 (k + 1) y : ℝ) : ℂ))
    (fun x _ => hasDerivAt_E w x) (fun x _ => (hasDerivAt_f (k + 1) x).ofReal_comp)
    (cE'.intervalIntegrable _ _) (cf1.intervalIntegrable _ _)
  have hk : k + 2 ≠ 0 := Nat.succ_ne_zero _
  simp only [c_pow_one hk, c_pow_neg_one hk, Complex.ofReal_zero, mul_zero, sub_zero,
    zero_sub] at ibp
  have e1 : (∫ x in (-1 : ℝ)..1, w * Complex.exp (w * (x : ℂ)) * ((c x ^ (k + 2) : ℝ) : ℂ))
      = w * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) := by
    rw [← integral_const_mul]
    congr 1; funext x; ring
  have e2 : (∫ x in (-1 : ℝ)..1, Complex.exp (w * (x : ℂ)) * ((f1 (k + 1) x : ℝ) : ℂ))
      = ∫ x in (-1 : ℝ)..1, ((f1 (k + 1) x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) := by
    congr 1; funext x; ring
  rw [e1, e2] at ibp
  exact ibp

/-- **The odd transform through the even one.** `S m w = 2w·K (m+1) w/((m+1)π)`. -/
theorem S_eq (m : ℕ) (w : ℂ) :
    S m w = 2 * w * K (m + 1) w / (((m : ℂ) + 1) * (Real.pi : ℂ)) := by
  have hq : ∀ x : ℝ, ((q m x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))
      = (-(2 / (((m : ℂ) + 1) * (Real.pi : ℂ)))) * (((f1 (2 * m + 1) x : ℝ) : ℂ)
          * Complex.exp (w * (x : ℂ))) := by
    intro x
    rw [q_eq]
    push_cast
    ring
  unfold S
  simp_rw [hq]
  rw [integral_const_mul, ibp_once (2 * m) w]
  have hK : K (m + 1) w
      = ∫ x in (-1 : ℝ)..1, ((c x ^ (2 * m + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) := by
    unfold K
    congr 1; funext x
    rw [P_pow, show 2 * (m + 1) = 2 * m + 2 by ring]
  rw [hK]
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hm : ((m : ℂ) + 1) ≠ 0 := Nat.cast_add_one_ne_zero m
  field_simp
  try ring

/-- `∏_{j=1}^{m+1}(w² + π²j²)`: the odd transform's denominator. -/
def QS (m : ℕ) (w : ℂ) : ℂ :=
  ∏ j ∈ Finset.range (m + 1), (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)

/-- `2·π^{2m+1}·(2m+1)!/4^m`: the odd transform's constant. -/
def cS (m : ℕ) : ℝ := 2 * Real.pi ^ (2 * m + 1) * ((2 * m + 1).factorial : ℝ) / 4 ^ m

theorem Q_succ_eq (m : ℕ) (w : ℂ) : Q (m + 1) w = w * QS m w := by
  unfold Q QS; ring

theorem cS_eq (m : ℕ) : cS m * (((m : ℝ) + 1) * Real.pi) = 2 * cK (m + 1) := by
  unfold cS cK
  have h2 : 2 * (m + 1) = 2 * m + 1 + 1 := by ring
  rw [h2, Nat.factorial_succ (2 * m + 1)]
  push_cast
  rw [show (4 : ℝ) ^ (m + 1) = 4 ^ m * 4 by ring,
    show Real.pi ^ (2 * m + 1 + 1) = Real.pi ^ (2 * m + 1) * Real.pi by ring]
  field_simp
  ring

/-- **The closed form, multiplied out.**
`S m w · ∏_{j=1}^{m+1}(w² + π²j²) = 2·π^{2m+1}·(2m+1)!/4^m · sinh w`. -/
theorem S_mul_QS (m : ℕ) (w : ℂ) : S m w * QS m w = (cS m : ℂ) * Complex.sinh w := by
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hm : ((m : ℂ) + 1) ≠ 0 := Nat.cast_add_one_ne_zero m
  have hKQ := K_mul_Q (m + 1) w
  rw [Q_succ_eq] at hKQ
  have hc : (cS m : ℂ) * (((m : ℂ) + 1) * (Real.pi : ℂ)) = 2 * (cK (m + 1) : ℂ) := by
    exact_mod_cast cS_eq m
  rw [S_eq]
  field_simp
  linear_combination 2 * hKQ - Complex.sinh w * hc

/-- At `m = 0`: `S 0 w · (w² + π²) = 2π·sinh w`, the elementary integral of `sin(πx)e^{wx}`. -/
theorem S_zero_mul (w : ℂ) :
    S 0 w * (w ^ 2 + (Real.pi : ℂ) ^ 2) = 2 * (Real.pi : ℂ) * Complex.sinh w := by
  have h := S_mul_QS 0 w
  unfold QS cS at h
  simp only [Finset.prod_range_one, Nat.cast_zero, zero_add, one_pow, mul_one, mul_zero,
    pow_zero, pow_one, Nat.factorial_one, Nat.cast_one, div_one] at h
  rw [h]
  push_cast
  ring

/-- The switched window: `sin(πu/h)·P(u/h)^m·cos(γu)`, read on `[−h, h]`. -/
def W (h γ : ℝ) (m : ℕ) (u : ℝ) : ℝ := q m (u / h) * Real.cos (γ * u)

/-- Its transform, `∫₋ₕʰ W(u)·e^{zu} du`. -/
def what (h γ : ℝ) (m : ℕ) (z : ℂ) : ℂ :=
  ∫ u in (-h)..h, ((W h γ m u : ℝ) : ℂ) * Complex.exp (z * (u : ℂ))

/-- **The window's transform in closed form.**
`what h γ m z = (h/2)·[S m ((z + iγ)h) + S m ((z − iγ)h)]`. -/
theorem what_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (z : ℂ) :
    what h γ m z = ((h : ℂ) / 2) *
      (S m ((z + Complex.I * (γ : ℂ)) * (h : ℂ)) + S m ((z - Complex.I * (γ : ℂ)) * (h : ℂ))) := by
  unfold what
  have hcv : (∫ u in (-h)..h, ((W h γ m u : ℝ) : ℂ) * Complex.exp (z * (u : ℂ)))
      = (h : ℂ) * ∫ x in (-1 : ℝ)..1, ((W h γ m (h * x) : ℝ) : ℂ) * Complex.exp (z * ((h * x : ℝ) : ℂ)) := by
    have := intervalIntegral.integral_comp_mul_left
      (fun u : ℝ => ((W h γ m u : ℝ) : ℂ) * Complex.exp (z * (u : ℂ))) (a := (-1 : ℝ)) (b := 1)
      (ne_of_gt hh)
    simp only [mul_neg, mul_one] at this
    rw [this, Complex.real_smul, ← mul_assoc]
    rw [show (h : ℂ) * ((h⁻¹ : ℝ) : ℂ) = 1 by
          push_cast; exact mul_inv_cancel₀ (by exact_mod_cast (ne_of_gt hh)), one_mul]
  rw [hcv]
  have hW : ∀ x : ℝ, W h γ m (h * x) = q m x * Real.cos (γ * (h * x)) := by
    intro x
    unfold W
    rw [show h * x / h = x by field_simp]
  have key : ∀ θ a : ℂ, Complex.cos θ * Complex.exp a
      = (Complex.exp (a + θ * Complex.I) + Complex.exp (a - θ * Complex.I)) / 2 := by
    intro θ a
    simp only [Complex.cos, Complex.exp_add, sub_eq_add_neg, neg_mul, Complex.exp_neg]
    ring
  have hcarrier : ∀ x : ℝ, ((W h γ m (h * x) : ℝ) : ℂ) * Complex.exp (z * ((h * x : ℝ) : ℂ))
      = (1 / 2 : ℂ) * (((q m x : ℝ) : ℂ) * Complex.exp ((z + Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ))
          + ((q m x : ℝ) : ℂ) * Complex.exp ((z - Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ))) := by
    intro x
    rw [hW x]
    push_cast
    have e1 : (z + Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ)
        = z * ((h : ℂ) * (x : ℂ)) + ((γ : ℂ) * ((h : ℂ) * (x : ℂ))) * Complex.I := by ring
    have e2 : (z - Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ)
        = z * ((h : ℂ) * (x : ℂ)) - ((γ : ℂ) * ((h : ℂ) * (x : ℂ))) * Complex.I := by ring
    rw [e1, e2, mul_assoc, key]
    ring
  simp_rw [hcarrier]
  rw [intervalIntegral.integral_const_mul, intervalIntegral.integral_add
        ((by fun_prop : Continuous fun x : ℝ => ((q m x : ℝ) : ℂ) *
            Complex.exp ((z + Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ))).intervalIntegrable _ _)
        ((by fun_prop : Continuous fun x : ℝ => ((q m x : ℝ) : ℂ) *
            Complex.exp ((z - Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ))).intervalIntegrable _ _)]
  unfold S
  simp_rw [mul_assoc]
  ring

end

/-- info: 'WeilOddPower.S_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S_eq

/-- info: 'WeilOddPower.S_mul_QS' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S_mul_QS

/-- info: 'WeilOddPower.what_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms what_eq

end WeilOddPower
