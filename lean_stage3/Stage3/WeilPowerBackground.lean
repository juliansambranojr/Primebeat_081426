/-
WeilPowerBackground — the switched window as a test function of the
explicit formula, every term of the zero form as minus a square, and the
on-line terms bounded. Rung 5, fifth slice. 2026-09-06.

Units 0320 and 0326 did this for the raised-cosine window; this module
does it for the switched window `W h γ m u = sin(πu/h)·P(u/h)^m·cos(γu)`
of unit 0330. The test function is

    φ(u) = 𝟙_{[−h,h]}(u) · W(u) · e^{−u/2},

and its Laplace transform is the window's transform read at `−z − 1/2`
(`laplace_phiW`). The transform is odd (`what_neg`, from `S_neg`: the
envelope is odd), so every term of the zero form is minus a square:

  term_eq_neg_sq   laplace φ(−ρ)·laplace φ(−(1−ρ)) = −what h γ m (ρ − 1/2)².

On the line `ρ − 1/2 = iγ_ρ` and the transform is purely imaginary,
`S m (it) = i·PsiW m t` with `PsiW m t = ∫₋₁¹ q m x · sin(tx) dx` real
(`S_I_mul`, by unit 0318's odd-part lemma), so

  online_term_eq   term(ρ) = (h/2)²·[PsiW m (h(γ_ρ + γ)) + PsiW m (h(γ_ρ − γ))]²  ≥ 0,
  online_term_le_near     ≤ 4h²        (|PsiW| ≤ 2: the envelope is at most 1),
  online_term_le_far      ≤ (h/2)²·[cS m·(2/(h(γ_ρ−γ))²)^{m+1} + cS m·(2/(h(γ_ρ+γ))²)^{m+1}]²
                          when both `h|γ_ρ ∓ γ|` are at least `√2·π(m+1)`
                          (unit 0331's far bound at real part zero).

The far bound is the decay of order `2m + 2` in the height, in place of
unit 0320's order 2. Everything else in the on-line background of units
0321–0324 is the same argument with the new near and far bounds; those
modules read the old window by name, so the next slice restates them
with the term as a parameter.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerBounds
import Stage3.WeilDetect

namespace WeilPowerBackground

noncomputable section

open Complex WeilWindow WeilTransform WeilPower WeilOddPower WeilPowerBounds WeilDetect
  intervalIntegral Real MeasureTheory

/-- The window as a test function of the explicit formula: cut off to
`[−h, h]`, times `e^{−u/2}`. Real-valued. -/
def phiW (h γ : ℝ) (m : ℕ) (u : ℝ) : ℝ :=
  Set.indicator (Set.Icc (-h) h) (fun u => W h γ m u * Real.exp (-u / 2)) u

/-- The complex-valued test function WeilDetect reads. -/
def phiWC (h γ : ℝ) (m : ℕ) : ℝ → ℂ := fun u => ((phiW h γ m u : ℝ) : ℂ)

theorem phiWC_real (h γ : ℝ) (m : ℕ) (u : ℝ) : (phiWC h γ m u).im = 0 := by
  unfold phiWC; simp

/-- **The transform in the explicit formula's convention.**
`laplace φ z = what h γ m (−z − 1/2)`. -/
theorem laplace_phiW {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (z : ℂ) :
    laplace (phiWC h γ m) z = what h γ m (-z - 1 / 2) := by
  unfold laplace phiWC phiW what
  have hind : ∀ u : ℝ,
      ((Set.indicator (Set.Icc (-h) h) (fun u => W h γ m u * Real.exp (-u / 2)) u : ℝ) : ℂ)
        * Complex.exp (-(z * (u : ℂ)))
      = Set.indicator (Set.Icc (-h) h)
          (fun u : ℝ => ((W h γ m u : ℝ) : ℂ) * Complex.exp ((-z - 1 / 2) * (u : ℂ))) u := by
    intro u
    by_cases hu : u ∈ Set.Icc (-h) h
    · rw [Set.indicator_of_mem hu, Set.indicator_of_mem hu]
      push_cast
      rw [mul_assoc, ← Complex.exp_add]
      congr 2
      ring
    · rw [Set.indicator_of_notMem hu, Set.indicator_of_notMem hu]
      simp
  simp_rw [hind]
  rw [MeasureTheory.integral_indicator measurableSet_Icc, MeasureTheory.integral_Icc_eq_integral_Ioc,
    intervalIntegral.integral_of_le (by linarith : -h ≤ h)]

/-- The odd envelope's transform through `sinh`: unit 0318's odd-part lemma. -/
theorem S_eq_sinh (m : ℕ) (w : ℂ) :
    S m w = ∫ x in (-1 : ℝ)..1, ((q m x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) := by
  unfold S
  exact odd_integral_exp (q m) (q_odd m) (continuous_q m) w

/-- `S` is odd. -/
theorem S_neg (m : ℕ) (w : ℂ) : S m (-w) = -S m w := by
  rw [S_eq_sinh, S_eq_sinh, ← intervalIntegral.integral_neg]
  congr 1
  funext x
  rw [neg_mul, Complex.sinh_neg]
  ring

/-- The window's transform is odd. -/
theorem what_neg {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (z : ℂ) :
    what h γ m (-z) = -what h γ m z := by
  rw [what_eq hh, what_eq hh]
  have e1 : (-z + Complex.I * (γ : ℂ)) * (h : ℂ) = -((z - Complex.I * (γ : ℂ)) * (h : ℂ)) := by
    ring
  have e2 : (-z - Complex.I * (γ : ℂ)) * (h : ℂ) = -((z + Complex.I * (γ : ℂ)) * (h : ℂ)) := by
    ring
  rw [e1, e2, S_neg, S_neg]
  ring

/-- **Every term is minus a square.** -/
theorem term_eq_neg_sq {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : ℂ) :
    laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))
      = -(what h γ m (ρ - 1 / 2)) ^ 2 := by
  rw [laplace_phiW hh, laplace_phiW hh]
  have e1 : -(-ρ) - 1 / 2 = ρ - 1 / 2 := by ring
  have e2 : -(-(1 - ρ)) - 1 / 2 = -(ρ - 1 / 2) := by ring
  rw [e1, e2, what_neg hh]
  ring

theorem term_re_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : ℂ) :
    (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re
      = (what h γ m (ρ - 1 / 2)).im ^ 2 - (what h γ m (ρ - 1 / 2)).re ^ 2 := by
  rw [term_eq_neg_sq hh, Complex.neg_re, sq, Complex.mul_re]
  ring

/-- `PsiW m t = ∫₋₁¹ q m x · sin(tx) dx`: the transform on the line, real. -/
def PsiW (m : ℕ) (t : ℝ) : ℝ := ∫ x in (-1 : ℝ)..1, q m x * Real.sin (t * x)

/-- `S m (it) = i·PsiW m t`. -/
theorem S_I_mul (m : ℕ) (t : ℝ) : S m (Complex.I * (t : ℂ)) = Complex.I * (PsiW m t : ℂ) := by
  rw [S_eq_sinh]
  unfold PsiW
  rw [← intervalIntegral.integral_ofReal, ← intervalIntegral.integral_const_mul]
  congr 1
  funext x
  have h1 : Complex.I * (t : ℂ) * (x : ℂ) = ((t * x : ℝ) : ℂ) * Complex.I := by
    push_cast; ring
  rw [h1, Complex.sinh_mul_I]
  push_cast
  ring

/-- The window's transform on the line: `what h γ m (it) = i(h/2)[PsiW(h(t+γ)) + PsiW(h(t−γ))]`. -/
theorem what_I {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (t : ℝ) :
    what h γ m (Complex.I * (t : ℂ)) =
      Complex.I * ((h : ℂ) / 2) * ((PsiW m (h * (t + γ)) : ℂ) + (PsiW m (h * (t - γ)) : ℂ)) := by
  rw [what_eq hh]
  have e1 : (Complex.I * (t : ℂ) + Complex.I * (γ : ℂ)) * (h : ℂ)
      = Complex.I * ((h * (t + γ) : ℝ) : ℂ) := by push_cast; ring
  have e2 : (Complex.I * (t : ℂ) - Complex.I * (γ : ℂ)) * (h : ℂ)
      = Complex.I * ((h * (t - γ) : ℝ) : ℂ) := by push_cast; ring
  rw [e1, e2, S_I_mul, S_I_mul]
  ring

/-- **On the line the term is a real square.** -/
theorem online_term_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))
      = (((h / 2) ^ 2 * (PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))) ^ 2 : ℝ) : ℂ) := by
  rw [term_eq_neg_sq hh]
  have harg : ρ - 1 / 2 = Complex.I * (ρ.im : ℂ) := by
    apply Complex.ext
    · simp [hρ]; try norm_num
    · simp
  rw [harg, what_I hh]
  push_cast
  ring_nf
  rw [Complex.I_sq]
  ring

theorem online_term_nonneg {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    0 ≤ (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re := by
  rw [online_term_eq hh γ m hρ, Complex.ofReal_re]
  positivity

/-- `|q m x| ≤ 1` on `[−1, 1]`. -/
theorem abs_q_le_one (m : ℕ) (x : ℝ) : |q m x| ≤ 1 := by
  unfold q
  rw [abs_mul, abs_of_nonneg (pow_nonneg (P_nonneg x) m)]
  have h1 := Real.abs_sin_le_one (Real.pi * x)
  have h2 : P x ^ m ≤ 1 := pow_le_one₀ (P_nonneg x) (P_le_one x)
  have h3 : 0 ≤ P x ^ m := pow_nonneg (P_nonneg x) m
  calc |Real.sin (Real.pi * x)| * P x ^ m ≤ 1 * 1 :=
        mul_le_mul h1 h2 h3 zero_le_one
    _ = 1 := by ring

/-- `|PsiW m t| ≤ 2`. -/
theorem PsiW_le_two (m : ℕ) (t : ℝ) : |PsiW m t| ≤ 2 := by
  unfold PsiW
  have h := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (-1 : ℝ)) (b := 1) (C := 1)
    (f := fun x : ℝ => q m x * Real.sin (t * x)) (by
      intro x _
      rw [Real.norm_eq_abs, abs_mul]
      calc |q m x| * |Real.sin (t * x)| ≤ 1 * 1 :=
            mul_le_mul (abs_q_le_one m x) (Real.abs_sin_le_one _) (abs_nonneg _) zero_le_one
        _ = 1 := by ring)
  rw [Real.norm_eq_abs] at h
  norm_num at h
  exact h

/-- Near the carrier: the on-line term is at most `4h²`. -/
theorem online_term_le_near {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re ≤ 4 * h ^ 2 := by
  rw [online_term_eq hh γ m hρ, Complex.ofReal_re]
  have h1 := PsiW_le_two m (h * (ρ.im + γ))
  have h2 := PsiW_le_two m (h * (ρ.im - γ))
  have hsum : |PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))| ≤ 4 := by
    calc |PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))|
        ≤ |PsiW m (h * (ρ.im + γ))| + |PsiW m (h * (ρ.im - γ))| := abs_add_le _ _
      _ ≤ 2 + 2 := add_le_add h1 h2
      _ = 4 := by norm_num
  have hsq : (PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))) ^ 2 ≤ 16 := by
    rw [← sq_abs]
    calc |PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))| ^ 2 ≤ 4 ^ 2 :=
          pow_le_pow_left₀ (abs_nonneg _) hsum 2
      _ = 16 := by norm_num
  nlinarith [sq_nonneg h]

/-- `|PsiW m t| ≤ cS m·(2/t²)^{m+1}` when `2π²(m+1)² ≤ t²`: unit 0331's far bound
at real part zero. -/
theorem PsiW_le_far {m : ℕ} {t : ℝ} (ht : 2 * (Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ t ^ 2) :
    |PsiW m t| ≤ cS m * (2 / t ^ 2) ^ (m + 1) := by
  have hS := norm_S_le_far (m := m) (w := Complex.I * (t : ℂ)) (by simpa using ht)
  rw [S_I_mul, norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs] at hS
  simpa using hS

/-- Away from the carrier: for `h|γ_ρ ∓ γ|` both at least `√2·π(m+1)`, the on-line
term is at most `(h/2)²·[cS m·(2/(h(γ_ρ−γ))²)^{m+1} + cS m·(2/(h(γ_ρ+γ))²)^{m+1}]²`. -/
theorem online_term_le_far {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) {ρ : ℂ} (hρ : ρ.re = 1 / 2)
    (hfar1 : 2 * (Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ (h * (ρ.im - γ)) ^ 2)
    (hfar2 : 2 * (Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ (h * (ρ.im + γ)) ^ 2) :
    (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re
      ≤ (h / 2) ^ 2 * (cS m * (2 / (h * (ρ.im - γ)) ^ 2) ^ (m + 1)
          + cS m * (2 / (h * (ρ.im + γ)) ^ 2) ^ (m + 1)) ^ 2 := by
  rw [online_term_eq hh γ m hρ, Complex.ofReal_re]
  have b1 := PsiW_le_far hfar2
  have b2 := PsiW_le_far hfar1
  have habs : |PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))|
      ≤ cS m * (2 / (h * (ρ.im - γ)) ^ 2) ^ (m + 1) + cS m * (2 / (h * (ρ.im + γ)) ^ 2) ^ (m + 1) := by
    calc |PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))|
        ≤ |PsiW m (h * (ρ.im + γ))| + |PsiW m (h * (ρ.im - γ))| := abs_add_le _ _
      _ ≤ cS m * (2 / (h * (ρ.im + γ)) ^ 2) ^ (m + 1)
          + cS m * (2 / (h * (ρ.im - γ)) ^ 2) ^ (m + 1) := add_le_add b1 b2
      _ = _ := by ring
  have hsq : (PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))) ^ 2
      ≤ (cS m * (2 / (h * (ρ.im - γ)) ^ 2) ^ (m + 1)
          + cS m * (2 / (h * (ρ.im + γ)) ^ 2) ^ (m + 1)) ^ 2 := by
    rw [← sq_abs]
    exact pow_le_pow_left₀ (abs_nonneg _) habs 2
  exact mul_le_mul_of_nonneg_left hsq (sq_nonneg _)

end

/-- info: 'WeilPowerBackground.laplace_phiW' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms laplace_phiW

/-- info: 'WeilPowerBackground.term_eq_neg_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_eq_neg_sq

/-- info: 'WeilPowerBackground.online_term_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms online_term_eq

/-- info: 'WeilPowerBackground.online_term_le_far' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms online_term_le_far

end WeilPowerBackground
