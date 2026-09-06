/-
WeilPowerBounds — bounds on the odd transform read off its polynomial.
Rung 5, fourth slice. 2026-09-06.

Unit 0330 gave `S m w · QS m w = cS m · sinh w`, with
`QS m w = ∏_{j=1}^{m+1}(w² + π²j²)`. Each factor is `(w − iπj)(w + iπj)`,
and both of those have real part `Re w`, so off the imaginary axis the
product never vanishes and the closed form is a quotient. Three bounds
follow, each crude and explicit.

  norm_S_le        Re w ≠ 0:  ‖S m w‖ ≤ cS m · cosh(Re w) / ‖QS m w‖,
                   with ‖QS m w‖ ≥ (Re w)^{2(m+1)} (`norm_QS_ge`).
  norm_S_le_far    2·((Re w)² + π²(m+1)²) ≤ (Im w)²:
                   ‖S m w‖ ≤ cS m · cosh(Re w) · (2/(Im w)²)^{m+1}.
                   Far up in height every factor is at least half the
                   height squared: decay of order `2m + 2` in the height.
  S_real_eq        at real `s`: S m s is real, `cS m · sinh s / ∏(s² + π²j²)`.
  S_real_ge        1 ≤ s:  cS m · e^s / (4·(s² + π²(m+1)²)^{m+1}) ≤ Re (S m s).
                   The main term at the target, bounded below.

What the assembly does with them: for a zero at `1/2 + ε' + iγ'` and the
window tuned at `γ` with support `h`, the transform is read at
`w = (ε' + i(γ' − γ))h`, so `Re w = ε'h` and `Im w = (γ' − γ)h`. The far
bound with `m` of the order of `h` makes every zero farther than a fixed
height from the target exponentially small against the target's main
term, at every real part. The near zeros are the cluster, and they are
the slice after the background.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilOddPower

namespace WeilPowerBounds

noncomputable section

open Complex WeilPower WeilOddPower WeilLobe Real

/-- One factor of the product, factored: `w² + a² = (w − ia)(w + ia)`. -/
theorem factor_eq (w : ℂ) (a : ℝ) :
    w ^ 2 + (a : ℂ) ^ 2 = (w - Complex.I * (a : ℂ)) * (w + Complex.I * (a : ℂ)) := by
  linear_combination (a : ℂ) ^ 2 * Complex.I_sq

/-- Each factor has norm at least `(Re w)²`. -/
theorem norm_factor_ge (w : ℂ) (a : ℝ) : w.re ^ 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ := by
  rw [factor_eq, norm_mul]
  have h1 : |w.re| ≤ ‖w - Complex.I * (a : ℂ)‖ := by
    have := Complex.abs_re_le_norm (w - Complex.I * (a : ℂ))
    simpa using this
  have h2 : |w.re| ≤ ‖w + Complex.I * (a : ℂ)‖ := by
    have := Complex.abs_re_le_norm (w + Complex.I * (a : ℂ))
    simpa using this
  calc w.re ^ 2 = |w.re| * |w.re| := by rw [← sq, sq_abs]
    _ ≤ ‖w - Complex.I * (a : ℂ)‖ * ‖w + Complex.I * (a : ℂ)‖ :=
        mul_le_mul h1 h2 (abs_nonneg _) (norm_nonneg _)

theorem QS_factor (m : ℕ) (w : ℂ) :
    QS m w = ∏ j ∈ Finset.range (m + 1), (w ^ 2 + ((Real.pi * ((j : ℝ) + 1) : ℝ) : ℂ) ^ 2) := by
  unfold QS
  apply Finset.prod_congr rfl
  intro j _
  push_cast
  ring

/-- `‖QS m w‖ ≥ (Re w)^{2(m+1)}`. -/
theorem norm_QS_ge (m : ℕ) (w : ℂ) : (w.re ^ 2) ^ (m + 1) ≤ ‖QS m w‖ := by
  rw [QS_factor, norm_prod]
  calc (w.re ^ 2) ^ (m + 1) = ∏ _j ∈ Finset.range (m + 1), w.re ^ 2 := by
        rw [Finset.prod_const, Finset.card_range]
    _ ≤ ∏ j ∈ Finset.range (m + 1), ‖w ^ 2 + ((Real.pi * ((j : ℝ) + 1) : ℝ) : ℂ) ^ 2‖ :=
        Finset.prod_le_prod (fun _ _ => sq_nonneg _) (fun j _ => norm_factor_ge w _)

theorem QS_ne_zero {m : ℕ} {w : ℂ} (hw : w.re ≠ 0) : QS m w ≠ 0 := by
  intro h0
  have h := norm_QS_ge m w
  rw [h0, norm_zero] at h
  have : 0 < (w.re ^ 2) ^ (m + 1) := by positivity
  linarith

theorem cS_pos (m : ℕ) : 0 < cS m := by
  unfold cS
  positivity

/-- Wherever the product is nonzero the closed form is a quotient. -/
theorem S_eq_div' {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0) :
    S m w = (cS m : ℂ) * Complex.sinh w / QS m w := by
  rw [eq_div_iff hne]
  exact S_mul_QS m w

theorem S_eq_div {m : ℕ} {w : ℂ} (hw : w.re ≠ 0) :
    S m w = (cS m : ℂ) * Complex.sinh w / QS m w :=
  S_eq_div' (QS_ne_zero hw)

/-- The norm of the quotient, bounded by `cosh(Re w)` over the product's norm. -/
theorem norm_S_le' {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0) :
    ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ := by
  rw [S_eq_div' hne, norm_div, norm_mul, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos (cS_pos m)]
  have hQ : 0 < ‖QS m w‖ := norm_pos_iff.mpr hne
  apply div_le_div_of_nonneg_right _ hQ.le
  exact mul_le_mul_of_nonneg_left (norm_sinh_le w) (cS_pos m).le

/-- **Upper bound.** `‖S m w‖ ≤ cS m · cosh(Re w) / ‖QS m w‖` for `Re w ≠ 0`. -/
theorem norm_S_le {m : ℕ} {w : ℂ} (hw : w.re ≠ 0) :
    ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ :=
  norm_S_le' (QS_ne_zero hw)

/-- Far up in height each factor is at least half the height squared. -/
theorem norm_factor_ge_far {w : ℂ} {a : ℝ}
    (hfar : 2 * (w.re ^ 2 + a ^ 2) ≤ w.im ^ 2) :
    w.im ^ 2 / 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ := by
  have hre : (w ^ 2 + (a : ℂ) ^ 2).re = w.re ^ 2 - w.im ^ 2 + a ^ 2 := by
    simp [sq, Complex.mul_re]
  have h := Complex.abs_re_le_norm (w ^ 2 + (a : ℂ) ^ 2)
  rw [hre] at h
  calc w.im ^ 2 / 2 ≤ -(w.re ^ 2 - w.im ^ 2 + a ^ 2) := by linarith
    _ ≤ |w.re ^ 2 - w.im ^ 2 + a ^ 2| := neg_le_abs _
    _ ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ := h

/-- `‖QS m w‖ ≥ ((Im w)²/2)^{m+1}` when `2·((Re w)² + π²(m+1)²) ≤ (Im w)²`. -/
theorem norm_QS_ge_far {m : ℕ} {w : ℂ}
    (hfar : 2 * (w.re ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ w.im ^ 2) :
    (w.im ^ 2 / 2) ^ (m + 1) ≤ ‖QS m w‖ := by
  rw [QS_factor, norm_prod]
  calc (w.im ^ 2 / 2) ^ (m + 1) = ∏ _j ∈ Finset.range (m + 1), w.im ^ 2 / 2 := by
        rw [Finset.prod_const, Finset.card_range]
    _ ≤ ∏ j ∈ Finset.range (m + 1), ‖w ^ 2 + ((Real.pi * ((j : ℝ) + 1) : ℝ) : ℂ) ^ 2‖ := by
        apply Finset.prod_le_prod (fun _ _ => by positivity)
        intro j hj
        apply norm_factor_ge_far
        have hj' : (j : ℝ) + 1 ≤ (m : ℝ) + 1 := by
          have : j + 1 ≤ m + 1 := Finset.mem_range.mp hj
          exact_mod_cast this
        have hsq : (Real.pi * ((j : ℝ) + 1)) ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2 := by
          rw [mul_pow]
          apply mul_le_mul_of_nonneg_left _ (sq_nonneg _)
          exact pow_le_pow_left₀ (by positivity) hj' 2
        linarith

/-- **Far bound.** `‖S m w‖ ≤ cS m · cosh(Re w) · (2/(Im w)²)^{m+1}` when
`2·((Re w)² + π²(m+1)²) ≤ (Im w)²`. -/
theorem norm_S_le_far {m : ℕ} {w : ℂ}
    (hfar : 2 * (w.re ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ w.im ^ 2) :
    ‖S m w‖ ≤ cS m * Real.cosh w.re * (2 / w.im ^ 2) ^ (m + 1) := by
  have him : 0 < w.im ^ 2 := by
    have hpi : 0 < Real.pi := Real.pi_pos
    have : 0 < 2 * (w.re ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) := by positivity
    linarith
  have hQ : (w.im ^ 2 / 2) ^ (m + 1) ≤ ‖QS m w‖ := norm_QS_ge_far hfar
  have hQpos : 0 < ‖QS m w‖ := lt_of_lt_of_le (by positivity) hQ
  have hne : QS m w ≠ 0 := norm_pos_iff.mp hQpos
  have hnum : 0 ≤ cS m * Real.cosh w.re := by
    have := cS_pos m
    have := Real.cosh_pos w.re
    positivity
  calc ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ := norm_S_le' hne
    _ ≤ cS m * Real.cosh w.re / (w.im ^ 2 / 2) ^ (m + 1) :=
        div_le_div_of_nonneg_left hnum (by positivity) hQ
    _ = cS m * Real.cosh w.re * (2 / w.im ^ 2) ^ (m + 1) := by
        rw [div_eq_mul_inv, ← inv_pow, inv_div]

/-- The real product `∏_{j=1}^{m+1}(s² + π²j²)`. -/
def Ps (m : ℕ) (s : ℝ) : ℝ :=
  ∏ j ∈ Finset.range (m + 1), (s ^ 2 + Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)

theorem Ps_pos (m : ℕ) (s : ℝ) : 0 < Ps m s := by
  unfold Ps
  apply Finset.prod_pos
  intro j _
  positivity

theorem QS_ofReal (m : ℕ) (s : ℝ) : QS m (s : ℂ) = ((Ps m s : ℝ) : ℂ) := by
  unfold QS Ps
  push_cast
  rfl

/-- At real `s` the transform is real: `cS m · sinh s / ∏(s² + π²j²)`. -/
theorem S_real_eq (m : ℕ) (s : ℝ) :
    S m (s : ℂ) = ((cS m * Real.sinh s / Ps m s : ℝ) : ℂ) := by
  have hne : ((Ps m s : ℝ) : ℂ) ≠ 0 := by exact_mod_cast (Ps_pos m s).ne'
  have h := S_mul_QS m (s : ℂ)
  rw [QS_ofReal] at h
  push_cast
  rw [eq_div_iff hne]
  exact h

/-- `Ps m s ≤ (s² + π²(m+1)²)^{m+1}`. -/
theorem Ps_le (m : ℕ) (s : ℝ) : Ps m s ≤ (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1) := by
  unfold Ps
  calc ∏ j ∈ Finset.range (m + 1), (s ^ 2 + Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)
      ≤ ∏ _j ∈ Finset.range (m + 1), (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) := by
        apply Finset.prod_le_prod (fun _ _ => by positivity)
        intro j hj
        have hj' : (j : ℝ) + 1 ≤ (m : ℝ) + 1 := by
          have : j + 1 ≤ m + 1 := Finset.mem_range.mp hj
          exact_mod_cast this
        have := mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (by positivity) hj' 2)
          (sq_nonneg Real.pi)
        linarith
    _ = _ := by rw [Finset.prod_const, Finset.card_range]

/-- `sinh s ≥ e^s/4` for `s ≥ 1`. -/
theorem sinh_ge {s : ℝ} (hs : 1 ≤ s) : Real.exp s / 4 ≤ Real.sinh s := by
  rw [Real.sinh_eq]
  have h1 : Real.exp (-s) ≤ Real.exp (-1) := Real.exp_le_exp.mpr (by linarith)
  have he : 2 < Real.exp 1 := by
    have := Real.add_one_lt_exp (one_ne_zero : (1 : ℝ) ≠ 0)
    linarith
  have hes : Real.exp 1 ≤ Real.exp s := Real.exp_le_exp.mpr hs
  have h2 : Real.exp (-1) ≤ Real.exp s / 2 := by
    rw [Real.exp_neg, inv_le_iff_one_le_mul₀ (Real.exp_pos 1)]
    nlinarith [Real.exp_pos 1, he, hes]
  linarith

/-- **Lower bound at the target.** For `1 ≤ s`,
`cS m · e^s / (4·(s² + π²(m+1)²)^{m+1}) ≤ Re (S m s)`. -/
theorem S_real_ge {m : ℕ} {s : ℝ} (hs : 1 ≤ s) :
    cS m * Real.exp s / (4 * (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1))
      ≤ (S m (s : ℂ)).re := by
  rw [S_real_eq, Complex.ofReal_re]
  have hP := Ps_pos m s
  have hPle := Ps_le m s
  have hsinh := sinh_ge hs
  have hc := cS_pos m
  have hM : 0 < (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1) := by positivity
  have hsinh0 : 0 ≤ Real.sinh s := le_trans (by positivity) hsinh
  calc cS m * Real.exp s / (4 * (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1))
      = cS m * (Real.exp s / 4) / (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1) := by
        field_simp
    _ ≤ cS m * Real.sinh s / (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1) :=
        div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hsinh hc.le) hM.le
    _ ≤ cS m * Real.sinh s / Ps m s :=
        div_le_div_of_nonneg_left (by positivity) hP hPle

end

/-- info: 'WeilPowerBounds.norm_S_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_S_le

/-- info: 'WeilPowerBounds.norm_S_le_far' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_S_le_far

/-- info: 'WeilPowerBounds.S_real_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S_real_ge

end WeilPowerBounds
