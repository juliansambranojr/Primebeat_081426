/-
WeilPower — the m-th power window's transform in closed form. Rung 5,
second slice, first module of the switched window (units 0326–0328).
2026-09-06.

Unit 0327 found that the raised-cosine window `P = cos²(πx/2)` cannot give
the bounded-height theorem with an explicit support: its transform decays
only polynomially in height while every off-line zero's term grows
exponentially in its own real part. The fix is the envelope `P^m` with `m`
of the order of the support. This module gives that envelope's transform,

    K m w = ∫₋₁¹ P(x)^m · e^{wx} dx,

in closed form, by a recurrence in `m`.

The recurrence. With `c(x) = cos(πx/2)`, `P^m = c^{2m}`, and

    (c^n)'' = n(n−1)θ²·c^{n−2} − n²θ²·c^n,      θ = π/2,

two integrations by parts against `e^{wx}` (the boundary terms vanish,
`c` and `(c^n)'` being zero at `±1` for `n ≥ 2`) give
`w²·K m = (2m)(2m−1)θ²·K (m−1) − (2m)²θ²·K m`, that is

  K_succ      K (m+1) w · (w² + π²(m+1)²) = (m+1)(2m+1)π²/2 · K m w.

The product. Iterating from `K 0 w · w = 2 sinh w`,

  K_mul_Q     K m w · w·∏_{j=1}^{m}(w² + π²j²) = 2·π^{2m}·(2m)!/4^m · sinh w.

At `m = 1` this is `π²·sinh w/(w(w² + π²))`, unit 0328's hand check. The
statement is multiplied out, so it holds at every `w`, the poles included.

What the closed form gives the next slices: an upper bound on `‖K m w‖`
through `cosh(Re w)` over the product, and a lower bound at real `w`, in
the regime `|w| ≲ πm` where the product behaves like a Gaussian in `w`.
The window's own transform, the odd one with the factor `x`, is the
`w`-derivative of `K`, and is the slice after that.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilLobe

namespace WeilPower

noncomputable section

open Complex WeilWindow WeilTransform intervalIntegral Real

/-- The half-angle cosine `c(x) = cos(πx/2)`; `P = c²`. -/
def c (x : ℝ) : ℝ := Real.cos (Real.pi * x / 2)

theorem P_eq_c_sq (x : ℝ) : P x = c x ^ 2 := rfl

theorem P_pow (m : ℕ) (x : ℝ) : P x ^ m = c x ^ (2 * m) := by
  rw [P_eq_c_sq, ← pow_mul]

theorem c_one : c 1 = 0 := by
  unfold c; rw [mul_one, Real.cos_pi_div_two]

theorem c_neg_one : c (-1) = 0 := by
  unfold c
  rw [show Real.pi * (-1) / 2 = -(Real.pi / 2) by ring, Real.cos_neg, Real.cos_pi_div_two]

theorem continuous_c : Continuous c := by
  unfold c; fun_prop

attribute [fun_prop] continuous_c

theorem c_pow_one {n : ℕ} (hn : n ≠ 0) : c 1 ^ n = 0 := by
  rw [c_one]; exact zero_pow hn

theorem c_pow_neg_one {n : ℕ} (hn : n ≠ 0) : c (-1) ^ n = 0 := by
  rw [c_neg_one]; exact zero_pow hn

theorem hasDerivAt_c (x : ℝ) :
    HasDerivAt c (-(Real.pi / 2) * Real.sin (Real.pi * x / 2)) x := by
  have h := (Real.hasDerivAt_cos (Real.pi * x / 2)).comp x
    (((hasDerivAt_id' x).const_mul Real.pi).div_const 2)
  exact h.congr_deriv (by ring)

theorem hasDerivAt_s (x : ℝ) :
    HasDerivAt (fun y : ℝ => Real.sin (Real.pi * y / 2)) (Real.pi / 2 * c x) x := by
  have h := (Real.hasDerivAt_sin (Real.pi * x / 2)).comp x
    (((hasDerivAt_id' x).const_mul Real.pi).div_const 2)
  exact h.congr_deriv (by unfold c; ring)

/-- The derivative of `c^{k+1}`. -/
def f1 (k : ℕ) (x : ℝ) : ℝ :=
  ((k : ℝ) + 1) * c x ^ k * (-(Real.pi / 2) * Real.sin (Real.pi * x / 2))

/-- The second derivative of `c^{k+2}`. -/
def f2 (k : ℕ) (x : ℝ) : ℝ :=
  ((k : ℝ) + 2) * (Real.pi / 2) ^ 2 * (((k : ℝ) + 1) * c x ^ k - ((k : ℝ) + 2) * c x ^ (k + 2))

theorem hasDerivAt_f (k : ℕ) (x : ℝ) : HasDerivAt (fun y : ℝ => c y ^ (k + 1)) (f1 k x) x := by
  have h := (hasDerivAt_c x).pow (k + 1)
  simp only [Nat.add_sub_cancel] at h
  refine h.congr_deriv ?_
  unfold f1
  push_cast
  ring

theorem hasDerivAt_f1 (k : ℕ) (x : ℝ) : HasDerivAt (f1 (k + 1)) (f2 k x) x := by
  have h := ((hasDerivAt_f k x).const_mul (((k : ℝ) + 1) + 1)).mul
    ((hasDerivAt_s x).const_mul (-(Real.pi / 2)))
  have hs : Real.sin (Real.pi * x / 2) ^ 2 = 1 - c x ^ 2 := by
    unfold c; exact Real.sin_sq _
  have hf : f1 (k + 1) = fun y => (((k : ℝ) + 1) + 1) * c y ^ (k + 1)
      * (-(Real.pi / 2) * Real.sin (Real.pi * y / 2)) := by
    funext y; unfold f1; push_cast; ring
  rw [hf]
  refine h.congr_deriv ?_
  unfold f2 f1
  linear_combination (((k : ℝ) + 2) * (Real.pi / 2) ^ 2 * ((k : ℝ) + 1) * c x ^ k) * hs

theorem continuous_f1 (k : ℕ) : Continuous (f1 k) := by
  unfold f1
  exact (continuous_const.mul (continuous_c.pow k)).mul (continuous_const.mul (by fun_prop))

theorem continuous_f2 (k : ℕ) : Continuous (f2 k) := by
  unfold f2
  exact continuous_const.mul ((continuous_const.mul (continuous_c.pow k)).sub
    (continuous_const.mul (continuous_c.pow (k + 2))))

theorem f1_one (k : ℕ) : f1 (k + 1) 1 = 0 := by
  unfold f1; rw [c_one]; simp

theorem f1_neg_one (k : ℕ) : f1 (k + 1) (-1) = 0 := by
  unfold f1; rw [c_neg_one]; simp

/-- The envelope's transform, `∫₋₁¹ P(x)^m e^{wx} dx`. -/
def K (m : ℕ) (w : ℂ) : ℂ :=
  ∫ x in (-1 : ℝ)..1, ((P x ^ m : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))

theorem hasDerivAt_E (w : ℂ) (x : ℝ) :
    HasDerivAt (fun y : ℝ => Complex.exp (w * (y : ℂ))) (w * Complex.exp (w * (x : ℂ))) x := by
  have h := ((Complex.hasDerivAt_exp (w * (x : ℂ))).comp (x : ℂ)
    ((hasDerivAt_id' (x : ℂ)).const_mul w)).comp_ofReal
  exact h.congr_deriv (by ring)

/-- The integral of `c^{k+2} e^{wx}` in terms of the second derivative:
`w²·∫ c^{k+2} E = ∫ f2 k · E`. -/
theorem ibp_twice (k : ℕ) (w : ℂ) :
    w ^ 2 * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))
      = ∫ x in (-1 : ℝ)..1, ((f2 k x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) := by
  have cE : Continuous fun y : ℝ => Complex.exp (w * (y : ℂ)) := by fun_prop
  have cE' : Continuous fun y : ℝ => w * Complex.exp (w * (y : ℂ)) := by fun_prop
  have cf1 : Continuous fun y : ℝ => ((f1 (k + 1) y : ℝ) : ℂ) :=
    Complex.continuous_ofReal.comp (continuous_f1 (k + 1))
  have cf2 : Continuous fun y : ℝ => ((f2 k y : ℝ) : ℂ) :=
    Complex.continuous_ofReal.comp (continuous_f2 k)
  -- first: ∫ E · f2 = [E f1] − ∫ (wE) f1
  have ibp1 := integral_mul_deriv_eq_deriv_mul (a := (-1 : ℝ)) (b := 1)
    (u := fun y : ℝ => Complex.exp (w * (y : ℂ)))
    (v := fun y : ℝ => ((f1 (k + 1) y : ℝ) : ℂ))
    (u' := fun y : ℝ => w * Complex.exp (w * (y : ℂ)))
    (v' := fun y : ℝ => ((f2 k y : ℝ) : ℂ))
    (fun x _ => hasDerivAt_E w x) (fun x _ => (hasDerivAt_f1 k x).ofReal_comp)
    (cE'.intervalIntegrable _ _) (cf2.intervalIntegrable _ _)
  -- second: ∫ E · f1 = [E c^{k+2}] − ∫ (wE) c^{k+2}
  have ibp2 := integral_mul_deriv_eq_deriv_mul (a := (-1 : ℝ)) (b := 1)
    (u := fun y : ℝ => Complex.exp (w * (y : ℂ)))
    (v := fun y : ℝ => ((c y ^ (k + 2) : ℝ) : ℂ))
    (u' := fun y : ℝ => w * Complex.exp (w * (y : ℂ)))
    (v' := fun y : ℝ => ((f1 (k + 1) y : ℝ) : ℂ))
    (fun x _ => hasDerivAt_E w x) (fun x _ => (hasDerivAt_f (k + 1) x).ofReal_comp)
    (cE'.intervalIntegrable _ _) (cf1.intervalIntegrable _ _)
  have hk : k + 2 ≠ 0 := Nat.succ_ne_zero _
  simp only [f1_one, f1_neg_one, c_pow_one hk, c_pow_neg_one hk, Complex.ofReal_zero, mul_zero,
    sub_zero, zero_sub] at ibp1 ibp2
  have e1 : ∀ g : ℝ → ℂ, (∫ x in (-1 : ℝ)..1, w * Complex.exp (w * (x : ℂ)) * g x)
      = w * ∫ x in (-1 : ℝ)..1, g x * Complex.exp (w * (x : ℂ)) := by
    intro g
    rw [← integral_const_mul]
    congr 1; funext x; ring
  have e2 : ∀ g : ℝ → ℂ, (∫ x in (-1 : ℝ)..1, Complex.exp (w * (x : ℂ)) * g x)
      = ∫ x in (-1 : ℝ)..1, g x * Complex.exp (w * (x : ℂ)) := by
    intro g
    congr 1; funext x; ring
  rw [e1, e2] at ibp1 ibp2
  rw [ibp1, ibp2]
  ring

/-- **The recurrence.** `K (m+1) w · (w² + π²(m+1)²) = (m+1)(2m+1)π²/2 · K m w`. -/
theorem K_succ (m : ℕ) (w : ℂ) :
    K (m + 1) w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2)
      = ((m : ℂ) + 1) * (2 * (m : ℂ) + 1) * (Real.pi : ℂ) ^ 2 / 2 * K m w := by
  have hK1 : K (m + 1) w
      = ∫ x in (-1 : ℝ)..1, ((c x ^ (2 * m + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) := by
    unfold K
    congr 1; funext x
    rw [P_pow, show 2 * (m + 1) = 2 * m + 2 by ring]
  have hK0 : K m w
      = ∫ x in (-1 : ℝ)..1, ((c x ^ (2 * m) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) := by
    unfold K
    congr 1; funext x
    rw [P_pow]
  have h := ibp_twice (2 * m) w
  have hsplit : (∫ x in (-1 : ℝ)..1, ((f2 (2 * m) x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)))
      = ((2 * (m : ℂ) + 2) * ((Real.pi : ℂ) / 2) ^ 2 * (2 * (m : ℂ) + 1))
          * (∫ x in (-1 : ℝ)..1, ((c x ^ (2 * m) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)))
        - ((2 * (m : ℂ) + 2) * ((Real.pi : ℂ) / 2) ^ 2 * (2 * (m : ℂ) + 2))
          * (∫ x in (-1 : ℝ)..1, ((c x ^ (2 * m + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) := by
    rw [← integral_const_mul, ← integral_const_mul, ← integral_sub]
    · congr 1; funext x
      unfold f2
      push_cast
      ring
    · exact (by fun_prop : Continuous fun x : ℝ =>
        ((2 * (m : ℂ) + 2) * ((Real.pi : ℂ) / 2) ^ 2 * (2 * (m : ℂ) + 1))
          * (((c x ^ (2 * m) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)))).intervalIntegrable _ _
    · exact (by fun_prop : Continuous fun x : ℝ =>
        ((2 * (m : ℂ) + 2) * ((Real.pi : ℂ) / 2) ^ 2 * (2 * (m : ℂ) + 2))
          * (((c x ^ (2 * m + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)))).intervalIntegrable _ _
  rw [hK1, hK0]
  rw [hsplit] at h
  linear_combination h

/-- `w·∏_{j<m}(w² + π²(j+1)²)`, the denominator of the closed form. -/
def Q (m : ℕ) (w : ℂ) : ℂ :=
  w * ∏ j ∈ Finset.range m, (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)

/-- `2·π^{2m}·(2m)!/4^m`, the numerator's constant. -/
def cK (m : ℕ) : ℝ := 2 * Real.pi ^ (2 * m) * ((2 * m).factorial : ℝ) / 4 ^ m

theorem Q_succ (m : ℕ) (w : ℂ) :
    Q (m + 1) w = Q m w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) := by
  unfold Q
  rw [Finset.prod_range_succ]
  ring

theorem cK_succ (m : ℕ) :
    cK (m + 1) = ((m : ℝ) + 1) * (2 * (m : ℝ) + 1) * Real.pi ^ 2 / 2 * cK m := by
  unfold cK
  have h2 : 2 * (m + 1) = 2 * m + 1 + 1 := by ring
  rw [h2, Nat.factorial_succ, Nat.factorial_succ]
  push_cast
  rw [show (4 : ℝ) ^ (m + 1) = 4 ^ m * 4 by ring,
    show Real.pi ^ (2 * m + 1 + 1) = Real.pi ^ (2 * m) * Real.pi ^ 2 by ring]
  field_simp
  ring

theorem K_zero_mul (w : ℂ) : K 0 w * w = 2 * Complex.sinh w := by
  unfold K
  simp only [pow_zero, Complex.ofReal_one, one_mul]
  by_cases hw : w = 0
  · rw [hw]; simp
  · rw [integral_exp_mul_complex hw, Complex.sinh]
    field_simp
    push_cast
    ring_nf

/-- **The closed form, multiplied out.**
`K m w · w·∏_{j=1}^{m}(w² + π²j²) = 2·π^{2m}·(2m)!/4^m · sinh w`. -/
theorem K_mul_Q (m : ℕ) (w : ℂ) : K m w * Q m w = (cK m : ℂ) * Complex.sinh w := by
  induction m with
  | zero =>
    unfold Q cK
    simp only [Finset.range_zero, Finset.prod_empty, mul_one, mul_zero, pow_zero,
      Nat.factorial_zero, Nat.cast_one, mul_one, div_one]
    rw [K_zero_mul]
    push_cast
    ring
  | succ m ih =>
    rw [Q_succ, cK_succ]
    calc K (m + 1) w * (Q m w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2))
        = (K (m + 1) w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2)) * Q m w := by ring
      _ = ((m : ℂ) + 1) * (2 * (m : ℂ) + 1) * (Real.pi : ℂ) ^ 2 / 2 * (K m w * Q m w) := by
          rw [K_succ]; ring
      _ = ((m : ℂ) + 1) * (2 * (m : ℂ) + 1) * (Real.pi : ℂ) ^ 2 / 2 * ((cK m : ℂ) * Complex.sinh w) := by
          rw [ih]
      _ = _ := by push_cast; ring

/-- At `m = 1`: `K 1 w · w(w² + π²) = π²·sinh w`, unit 0328's hand check. -/
theorem cK_one : cK 1 = Real.pi ^ 2 := by
  unfold cK
  norm_num [Nat.factorial]
  ring

theorem K_one_mul (w : ℂ) :
    K 1 w * (w * (w ^ 2 + (Real.pi : ℂ) ^ 2)) = (Real.pi : ℂ) ^ 2 * Complex.sinh w := by
  have h := K_mul_Q 1 w
  unfold Q at h
  simp only [Finset.prod_range_one, Nat.cast_zero, zero_add, one_pow, mul_one] at h
  rw [h, cK_one]
  push_cast
  ring

end

/-- info: 'WeilPower.K_succ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms K_succ

/-- info: 'WeilPower.K_mul_Q' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms K_mul_Q

/-- info: 'WeilPower.K_one_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms K_one_mul

end WeilPower
