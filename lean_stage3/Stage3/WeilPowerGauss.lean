/-
WeilPowerGauss — the odd transform in the Gaussian regime, through Euler's
product for `sinh`. Rung 5, sixth slice. 2026-09-06.

Unit 0331's real-axis lower bound compares the target's product with its
largest factor to the `m`-th power and loses a factor near `e^{2m}`; with
`m` of the order of the support that swallows the main term. This module
takes the exact route. Euler's product, in Mathlib as
`Complex.tendsto_euler_sin_prod`, read at `iw/π`, gives

    sinh w = w · ∏_{j≥1} (1 + w²/(π²j²))            (euler_sinh),

so the head product of the closed form cancels against the head of Euler's
product and

    S m w = (cS m / D m) · w · ∏_{j≥m+2} (1 + w²/(π²j²)),
    D m   = π^{2(m+1)}·((m+1)!)²,   4/(π(m+1)(2m+3)) ≤ cS m / D m ≤ 4/(π(m+1)),

the constant through the central binomial coefficient (`cprime_le`,
`cprime_ge`). The tail product is controlled factor by factor: for
`‖x‖ ≤ 1/2`, `‖1 + x‖ ≤ exp(Re x + ‖x‖²)` and, for real `x ∈ [0, 1/2]`,
`exp(x − x²) ≤ 1 + x`, both from Mathlib's `norm_log_one_add_sub_self_le`.
Summing over the tail with `Σ_{j≥m+2} 1/j² ≤ 1/(m+1)` and the crude
`Σ_{j=m+2}^{2m+3} 1/j² ≥ (m+2)/(2m+3)²`, and passing through the limit:

  norm_S_le_gauss_pos   0 ≤ Re(w²):
        ‖S m w‖ ≤ 4/(π(m+1)) · ‖w‖ · exp(Re(w²)/(π²(m+1)) + ‖w‖⁴/(π⁴(m+1)³))
  norm_S_le_gauss_neg   Re(w²) ≤ 0:
        ‖S m w‖ ≤ 4/(π(m+1)) · ‖w‖ · exp(Re(w²)·(m+2)/(π²(2m+3)²) + ‖w‖⁴/(π⁴(m+1)³))
  S_real_ge_gauss       0 < s:
        4/(π(m+1)(2m+3)) · s · exp(s²(m+2)/(π²(2m+3)²) − s⁴/(π⁴(m+1)³)) ≤ Re (S m s)

all under `‖w‖² ≤ π²(m+2)²/2`, the regime in which every tail factor is
within `1/2` of `1`. At `w = (ε' + iΔ)h` and `m + 1 = λh` the exponent is
`(ε'² − Δ²)h/(π²λ)` up to the quartic error `(ε'² + Δ²)²h/(π⁴λ³)`: the
Gaussian amplitude, an upper bound at every zero and a lower bound at the
target, with the same constant on both sides.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerBounds
import Mathlib.Analysis.SpecialFunctions.Trigonometric.EulerSineProd
import Mathlib.Analysis.SpecialFunctions.Complex.LogBounds

namespace WeilPowerGauss

noncomputable section

open Complex WeilPower WeilOddPower WeilPowerBounds Real Filter Topology

/-- One factor of Euler's product for `sinh`: `1 + w²/(π²(j+1)²)`. -/
def g (w : ℂ) (j : ℕ) : ℂ := 1 + w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)

/-- **Euler's product for `sinh`.** `w·∏_{j<n}(1 + w²/(π²(j+1)²)) → sinh w`. -/
theorem euler_sinh (w : ℂ) :
    Tendsto (fun n : ℕ => w * ∏ j ∈ Finset.range n, g w j) atTop (𝓝 (Complex.sinh w)) := by
  have h := Complex.tendsto_euler_sin_prod (Complex.I * w / (Real.pi : ℂ))
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hg : ∀ j : ℕ, (1 : ℂ) - (Complex.I * w / (Real.pi : ℂ)) ^ 2 / ((j : ℂ) + 1) ^ 2 = g w j := by
    intro j
    unfold g
    have hj : ((j : ℂ) + 1) ≠ 0 := Nat.cast_add_one_ne_zero j
    rw [div_pow, mul_pow, Complex.I_sq]
    field_simp
    try ring
  have e1 : ∀ n : ℕ, (Real.pi : ℂ) * (Complex.I * w / (Real.pi : ℂ))
      * ∏ j ∈ Finset.range n, ((1 : ℂ) - (Complex.I * w / (Real.pi : ℂ)) ^ 2 / ((j : ℂ) + 1) ^ 2)
      = Complex.I * (w * ∏ j ∈ Finset.range n, g w j) := by
    intro n
    simp_rw [hg]
    field_simp
    try ring
  have e2 : Complex.sin ((Real.pi : ℂ) * (Complex.I * w / (Real.pi : ℂ)))
      = Complex.I * Complex.sinh w := by
    rw [show (Real.pi : ℂ) * (Complex.I * w / (Real.pi : ℂ)) = w * Complex.I by
      field_simp, Complex.sin_mul_I]
    ring
  simp_rw [e1, e2] at h
  have h2 := h.const_mul (Complex.I⁻¹)
  simp only [← mul_assoc, inv_mul_cancel₀ Complex.I_ne_zero, one_mul] at h2
  exact h2

/-- `D m = ∏_{j<m+1} π²(j+1)²`. -/
def D (m : ℕ) : ℝ := ∏ j ∈ Finset.range (m + 1), (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)

theorem D_pos (m : ℕ) : 0 < D m := by
  unfold D
  apply Finset.prod_pos
  intro j _
  positivity

theorem D_eq (m : ℕ) : D m = Real.pi ^ (2 * (m + 1)) * (((m + 1).factorial : ℕ) : ℝ) ^ 2 := by
  unfold D
  rw [Finset.prod_mul_distrib, Finset.prod_const, Finset.card_range, Finset.prod_pow]
  have hf : ∏ j ∈ Finset.range (m + 1), ((j : ℝ) + 1) = (((m + 1).factorial : ℕ) : ℝ) := by
    rw [← Finset.prod_range_add_one_eq_factorial]
    push_cast
    rfl
  rw [hf, ← pow_mul]

/-- The head of the closed form's product is `D m` times the head of Euler's product. -/
theorem QS_eq_D_mul (m : ℕ) (w : ℂ) :
    QS m w = (D m : ℂ) * ∏ j ∈ Finset.range (m + 1), g w j := by
  unfold QS D g
  push_cast
  rw [← Finset.prod_mul_distrib]
  apply Finset.prod_congr rfl
  intro j _
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hj : ((j : ℂ) + 1) ≠ 0 := Nat.cast_add_one_ne_zero j
  field_simp
  ring

/-- `cS m / D m = centralBinom (m+1) / (π (m+1) 4^m)`. -/
theorem cprime_eq (m : ℕ) :
    cS m / D m = ((Nat.centralBinom (m + 1) : ℕ) : ℝ) / (Real.pi * ((m : ℝ) + 1) * 4 ^ m) := by
  unfold cS
  rw [D_eq]
  have hcb : ((Nat.centralBinom (m + 1) : ℕ) : ℝ) * (((m + 1).factorial : ℕ) : ℝ) ^ 2
      = (((2 * (m + 1)).factorial : ℕ) : ℝ) := by
    rw [Nat.centralBinom_eq_two_mul_choose]
    have := Nat.choose_mul_factorial_mul_factorial (show m + 1 ≤ 2 * (m + 1) by omega)
    rw [show 2 * (m + 1) - (m + 1) = m + 1 by omega] at this
    rw [← this]
    push_cast
    ring
  have h2 : 2 * (m + 1) = 2 * m + 1 + 1 := by ring
  rw [h2, Nat.factorial_succ (2 * m + 1)] at hcb
  push_cast at hcb
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hm : ((m : ℝ) + 1) ≠ 0 := by positivity
  have hf : (((m + 1).factorial : ℕ) : ℝ) ≠ 0 := by positivity
  have h4 : (4 : ℝ) ^ m ≠ 0 := by positivity
  rw [div_eq_div_iff (by positivity) (by positivity), h2]
  field_simp
  linear_combination (-(Real.pi ^ (2 * m + 1 + 1))) * hcb

theorem cprime_le (m : ℕ) : cS m / D m ≤ 4 / (Real.pi * ((m : ℝ) + 1)) := by
  rw [cprime_eq]
  have hcb : ((Nat.centralBinom (m + 1) : ℕ) : ℝ) ≤ 4 ^ (m + 1) := by
    exact_mod_cast Nat.centralBinom_le_four_pow (m + 1)
  have hpi : 0 < Real.pi := Real.pi_pos
  rw [div_le_div_iff₀ (by positivity) (by positivity)]
  calc ((Nat.centralBinom (m + 1) : ℕ) : ℝ) * (Real.pi * ((m : ℝ) + 1))
      ≤ 4 ^ (m + 1) * (Real.pi * ((m : ℝ) + 1)) := by gcongr
    _ = 4 * (Real.pi * ((m : ℝ) + 1) * 4 ^ m) := by ring

theorem cprime_ge (m : ℕ) :
    4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) ≤ cS m / D m := by
  rw [cprime_eq]
  have hcb : (4 : ℝ) ^ (m + 1) ≤ (2 * ((m : ℝ) + 1) + 1) * ((Nat.centralBinom (m + 1) : ℕ) : ℝ) := by
    have := Nat.four_pow_le_two_mul_add_one_mul_central_binom (m + 1)
    exact_mod_cast this
  have hpi : 0 < Real.pi := Real.pi_pos
  rw [div_le_div_iff₀ (by positivity) (by positivity)]
  rw [show (4 : ℝ) ^ (m + 1) = 4 * 4 ^ m by ring] at hcb
  have key := mul_le_mul_of_nonneg_right hcb (by positivity : (0 : ℝ) ≤ Real.pi * ((m : ℝ) + 1))
  nlinarith [key]

theorem cprime_pos (m : ℕ) : 0 < cS m / D m :=
  lt_of_lt_of_le (by have := Real.pi_pos; positivity) (cprime_ge m)

/-- The tail of Euler's product from `m+1` to `n`. -/
def T (m : ℕ) (w : ℂ) (n : ℕ) : ℂ := ∏ j ∈ Finset.Ico (m + 1) n, g w j

/-- **The transform as a limit of tails.** -/
theorem tendsto_S {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0) :
    Tendsto (fun n : ℕ => ((cS m / D m : ℝ) : ℂ) * w * T m w n) atTop (𝓝 (S m w)) := by
  have hD : (D m : ℂ) ≠ 0 := by exact_mod_cast (D_pos m).ne'
  have key := (euler_sinh w).const_mul ((cS m : ℂ) / QS m w)
  have hS : (cS m : ℂ) / QS m w * Complex.sinh w = S m w := by
    rw [S_eq_div' hne]; ring
  rw [hS] at key
  apply key.congr'
  filter_upwards [eventually_ge_atTop (m + 1)] with n hn
  rw [← Finset.prod_range_mul_prod_Ico (g w) hn, QS_eq_D_mul]
  unfold T
  have hP : ∏ j ∈ Finset.range (m + 1), g w j ≠ 0 := by
    intro h0
    apply hne
    rw [QS_eq_D_mul, h0, mul_zero]
  push_cast
  field_simp
  try ring

/-- `‖1 + x‖ ≤ exp(Re x + ‖x‖²)` for `‖x‖ ≤ 1/2`. -/
theorem norm_one_add_le {x : ℂ} (hx : ‖x‖ ≤ 1 / 2) : ‖1 + x‖ ≤ Real.exp (x.re + ‖x‖ ^ 2) := by
  have hx1 : ‖x‖ < 1 := by linarith
  have hne : (1 : ℂ) + x ≠ 0 := by
    intro h0
    have : ‖(1 : ℂ) + x‖ = 0 := by rw [h0, norm_zero]
    have h1 : 1 - ‖x‖ ≤ ‖(1 : ℂ) + x‖ := by
      have := norm_sub_norm_le (1 : ℂ) (-x)
      simp only [norm_one, norm_neg, sub_neg_eq_add] at this
      exact this
    linarith
  rw [← Complex.exp_log hne, Complex.norm_exp]
  apply Real.exp_le_exp.mpr
  have hlog := Complex.norm_log_one_add_sub_self_le hx1
  have hre : (Complex.log (1 + x) - x).re ≤ ‖Complex.log (1 + x) - x‖ := Complex.re_le_norm _
  rw [Complex.sub_re] at hre
  have hinv : (1 - ‖x‖)⁻¹ ≤ 2 := by
    rw [inv_le_comm₀ (by linarith) (by norm_num)]
    linarith
  have hx0 : 0 ≤ ‖x‖ ^ 2 := sq_nonneg _
  have : ‖x‖ ^ 2 * (1 - ‖x‖)⁻¹ / 2 ≤ ‖x‖ ^ 2 := by
    calc ‖x‖ ^ 2 * (1 - ‖x‖)⁻¹ / 2 ≤ ‖x‖ ^ 2 * 2 / 2 := by gcongr
      _ = ‖x‖ ^ 2 := by ring
  linarith

/-- `exp(x − x²) ≤ 1 + x` for real `0 ≤ x ≤ 1/2`. -/
theorem exp_le_one_add {x : ℝ} (h0 : 0 ≤ x) (hx : x ≤ 1 / 2) :
    Real.exp (x - x ^ 2) ≤ 1 + x := by
  have hx1 : ‖(x : ℂ)‖ < 1 := by
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg h0]; linarith
  have hlog := Complex.norm_log_one_add_sub_self_le hx1
  rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg h0] at hlog
  have hre : -(Complex.log (1 + (x : ℂ)) - (x : ℂ)).re ≤ ‖Complex.log (1 + (x : ℂ)) - (x : ℂ)‖ := by
    have := Complex.abs_re_le_norm (Complex.log (1 + (x : ℂ)) - (x : ℂ))
    linarith [neg_abs_le (Complex.log (1 + (x : ℂ)) - (x : ℂ)).re]
  rw [Complex.sub_re, Complex.ofReal_re] at hre
  have hl : (Complex.log (1 + (x : ℂ))).re = Real.log (1 + x) := by
    rw [show (1 : ℂ) + (x : ℂ) = ((1 + x : ℝ) : ℂ) by push_cast; rfl,
      ← Complex.ofReal_log (by linarith), Complex.ofReal_re]
  rw [hl] at hre
  have hinv : (1 - x)⁻¹ ≤ 2 := by
    rw [inv_le_comm₀ (by linarith) (by norm_num)]
    linarith
  have : x ^ 2 * (1 - x)⁻¹ / 2 ≤ x ^ 2 := by
    calc x ^ 2 * (1 - x)⁻¹ / 2 ≤ x ^ 2 * 2 / 2 := by gcongr
      _ = x ^ 2 := by ring
  have hlog2 : x - x ^ 2 ≤ Real.log (1 + x) := by linarith
  calc Real.exp (x - x ^ 2) ≤ Real.exp (Real.log (1 + x)) := Real.exp_le_exp.mpr hlog2
    _ = 1 + x := Real.exp_log (by linarith)

/-- `Σ_{j ∈ Ico (m+1) n} 1/(j+1)² ≤ 1/(m+1)`. -/
theorem sum_inv_sq_le (m n : ℕ) :
    ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 ≤ 1 / ((m : ℝ) + 1) := by
  by_cases hn : m + 1 ≤ n
  · have key : ∀ k, m + 1 ≤ k →
        ∑ j ∈ Finset.Ico (m + 1) k, 1 / ((j : ℝ) + 1) ^ 2 ≤ 1 / ((m : ℝ) + 1) - 1 / (k : ℝ) := by
      intro k hk
      induction k, hk using Nat.le_induction with
      | base =>
        simp only [Finset.Ico_self, Finset.sum_empty]
        push_cast
        linarith
      | succ k hk ih =>
        rw [Finset.sum_Ico_succ_top hk]
        have hk0 : (0 : ℝ) < k := by
          have : 1 ≤ k := by omega
          exact_mod_cast this
        have hstep : 1 / ((k : ℝ) + 1) ^ 2 ≤ 1 / (k : ℝ) - 1 / ((k : ℝ) + 1) := by
          rw [div_sub_div _ _ hk0.ne' (by positivity), div_le_div_iff₀ (by positivity) (by positivity)]
          nlinarith
        push_cast
        linarith
    have := key n hn
    have hn0 : (0 : ℝ) ≤ 1 / (n : ℝ) := by positivity
    linarith
  · push Not at hn
    rw [Finset.Ico_eq_empty (by omega), Finset.sum_empty]
    positivity

/-- `(m+2)/(2m+3)² ≤ Σ_{j ∈ Ico (m+1) (2m+3)} 1/(j+1)²`. -/
theorem sum_inv_sq_ge (m : ℕ) :
    ((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2 ≤ ∑ j ∈ Finset.Ico (m + 1) (2 * m + 3), 1 / ((j : ℝ) + 1) ^ 2 := by
  have h1 : ∑ _j ∈ Finset.Ico (m + 1) (2 * m + 3), (1 / (2 * (m : ℝ) + 3) ^ 2)
      ≤ ∑ j ∈ Finset.Ico (m + 1) (2 * m + 3), 1 / ((j : ℝ) + 1) ^ 2 := by
    apply Finset.sum_le_sum
    intro j hj
    have hj' : (j : ℝ) + 1 ≤ 2 * (m : ℝ) + 3 := by
      have := (Finset.mem_Ico.mp hj).2
      have : j + 1 ≤ 2 * m + 3 := by omega
      exact_mod_cast this
    apply one_div_le_one_div_of_le (by positivity)
    exact pow_le_pow_left₀ (by positivity) hj' 2
  rw [Finset.sum_const, Nat.card_Ico, nsmul_eq_mul] at h1
  have hc : ((2 * m + 3 - (m + 1) : ℕ) : ℝ) = (m : ℝ) + 2 := by
    rw [show 2 * m + 3 - (m + 1) = m + 2 by omega]; push_cast; ring
  rw [hc] at h1
  calc ((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2 = ((m : ℝ) + 2) * (1 / (2 * (m : ℝ) + 3) ^ 2) := by ring
    _ ≤ _ := h1

/-- `Σ_{j ∈ Ico (m+1) n} 1/(j+1)⁴ ≤ 1/(m+1)³`. -/
theorem sum_inv_pow4_le (m n : ℕ) :
    ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 ≤ 1 / ((m : ℝ) + 1) ^ 3 := by
  have h1 : ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
      ≤ ∑ j ∈ Finset.Ico (m + 1) n, (1 / ((m : ℝ) + 1) ^ 2) * (1 / ((j : ℝ) + 1) ^ 2) := by
    apply Finset.sum_le_sum
    intro j hj
    have hj' : (m : ℝ) + 1 ≤ (j : ℝ) + 1 := by
      have := (Finset.mem_Ico.mp hj).1
      have : m + 1 ≤ j + 1 := by omega
      exact_mod_cast this
    have hm0 : (0 : ℝ) < (m : ℝ) + 1 := by positivity
    rw [show (1 : ℝ) / ((m : ℝ) + 1) ^ 2 * (1 / ((j : ℝ) + 1) ^ 2)
        = 1 / (((m : ℝ) + 1) ^ 2 * ((j : ℝ) + 1) ^ 2) by rw [one_div_mul_one_div]]
    apply one_div_le_one_div_of_le (by positivity)
    calc ((m : ℝ) + 1) ^ 2 * ((j : ℝ) + 1) ^ 2 ≤ ((j : ℝ) + 1) ^ 2 * ((j : ℝ) + 1) ^ 2 := by
          gcongr
      _ = ((j : ℝ) + 1) ^ 4 := by ring
  rw [← Finset.mul_sum] at h1
  have h2 := sum_inv_sq_le m n
  have hm0 : (0 : ℝ) < 1 / ((m : ℝ) + 1) ^ 2 := by positivity
  calc ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
      ≤ 1 / ((m : ℝ) + 1) ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := h1
    _ ≤ 1 / ((m : ℝ) + 1) ^ 2 * (1 / ((m : ℝ) + 1)) := by gcongr
    _ = 1 / ((m : ℝ) + 1) ^ 3 := by rw [one_div_mul_one_div]; ring

/-- Each tail factor's argument is within `1/2` of `0` when `‖w‖² ≤ π²(m+2)²/2`. -/
theorem norm_x_le {m : ℕ} {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    {j : ℕ} (hj : m + 1 ≤ j) :
    ‖w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)‖ ≤ 1 / 2 := by
  have hj' : (m : ℝ) + 2 ≤ (j : ℝ) + 1 := by
    have : m + 2 ≤ j + 1 := by omega
    exact_mod_cast this
  have hpi : 0 < Real.pi := Real.pi_pos
  have hden : ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2) = (((Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2 : ℝ)) : ℂ) := by
    push_cast; ring
  rw [hden, norm_div, norm_pow, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (by positivity)]
  rw [div_le_iff₀ (by positivity)]
  calc ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 := hsmall
    _ ≤ Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2 / 2 := by gcongr
    _ = 1 / 2 * (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) := by ring

theorem x_re (w : ℂ) (j : ℕ) :
    (w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)).re = (w ^ 2).re / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) := by
  have hden : ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2) = (((Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2 : ℝ)) : ℂ) := by
    push_cast; ring
  rw [hden, Complex.div_ofReal_re]

theorem x_norm (w : ℂ) (j : ℕ) :
    ‖w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)‖ = ‖w‖ ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) := by
  have hden : ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2) = (((Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2 : ℝ)) : ℂ) := by
    push_cast; ring
  rw [hden, norm_div, norm_pow, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (by positivity)]

/-- The tail's norm is at most the exponential of the tail sums. -/
theorem norm_T_le (m : ℕ) {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (n : ℕ) :
    ‖T m w n‖ ≤ Real.exp ((w ^ 2).re / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2
      + ‖w‖ ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4) := by
  unfold T
  rw [norm_prod]
  have hpi : 0 < Real.pi := Real.pi_pos
  calc ∏ j ∈ Finset.Ico (m + 1) n, ‖g w j‖
      ≤ ∏ j ∈ Finset.Ico (m + 1) n, Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)
          + (‖w‖ ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2) := by
        apply Finset.prod_le_prod (fun _ _ => norm_nonneg _)
        intro j hj
        have hjm := (Finset.mem_Ico.mp hj).1
        have := norm_one_add_le (norm_x_le hsmall hjm)
        unfold g
        rw [x_re, x_norm] at this
        exact this
    _ = Real.exp (∑ j ∈ Finset.Ico (m + 1) n, ((w ^ 2).re / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)
          + (‖w‖ ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2)) := by
        rw [Real.exp_sum]
    _ = _ := by
        congr 1
        rw [Finset.sum_add_distrib, Finset.mul_sum, Finset.mul_sum]
        congr 1
        · apply Finset.sum_congr rfl; intro j _; field_simp
        · apply Finset.sum_congr rfl; intro j _; field_simp; try ring

theorem norm_T_le_pos {m : ℕ} {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    (hre : 0 ≤ (w ^ 2).re) (n : ℕ) :
    ‖T m w n‖ ≤ Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1))
      + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
  refine (norm_T_le m hsmall n).trans (Real.exp_le_exp.mpr ?_)
  have hpi : 0 < Real.pi := Real.pi_pos
  have h1 := sum_inv_sq_le m n
  have h2 := sum_inv_pow4_le m n
  have ha : 0 ≤ (w ^ 2).re / Real.pi ^ 2 := by positivity
  have hb : 0 ≤ ‖w‖ ^ 4 / Real.pi ^ 4 := by positivity
  calc (w ^ 2).re / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2
        + ‖w‖ ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
      ≤ (w ^ 2).re / Real.pi ^ 2 * (1 / ((m : ℝ) + 1)) + ‖w‖ ^ 4 / Real.pi ^ 4 * (1 / ((m : ℝ) + 1) ^ 3) := by
        gcongr
    _ = _ := by field_simp

theorem norm_T_le_neg {m : ℕ} {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    (hre : (w ^ 2).re ≤ 0) {n : ℕ} (hn : 2 * m + 3 ≤ n) :
    ‖T m w n‖ ≤ Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
      + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
  refine (norm_T_le m hsmall n).trans (Real.exp_le_exp.mpr ?_)
  have hpi : 0 < Real.pi := Real.pi_pos
  have h2 := sum_inv_pow4_le m n
  have hsum : ((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2 ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := by
    refine (sum_inv_sq_ge m).trans ?_
    apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.Ico_subset_Ico_right hn)
    intro j _ _
    positivity
  have ha : (w ^ 2).re / Real.pi ^ 2 ≤ 0 := by
    apply div_nonpos_of_nonpos_of_nonneg hre (by positivity)
  have hb : 0 ≤ ‖w‖ ^ 4 / Real.pi ^ 4 := by positivity
  have hA : (w ^ 2).re / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2
      ≤ (w ^ 2).re / Real.pi ^ 2 * (((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2) :=
    mul_le_mul_of_nonpos_left hsum ha
  have hB : ‖w‖ ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
      ≤ ‖w‖ ^ 4 / Real.pi ^ 4 * (1 / ((m : ℝ) + 1) ^ 3) :=
    mul_le_mul_of_nonneg_left h2 hb
  have e : (w ^ 2).re / Real.pi ^ 2 * (((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2)
      + ‖w‖ ^ 4 / Real.pi ^ 4 * (1 / ((m : ℝ) + 1) ^ 3)
      = (w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
      + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
    field_simp
  linarith

/-- **Upper bound, Gaussian regime, `Re(w²) ≥ 0`.** -/
theorem norm_S_le_gauss_pos {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hre : 0 ≤ (w ^ 2).re) :
    ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖
      * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
  have hlim := (tendsto_S hne).norm
  apply le_of_tendsto hlim
  filter_upwards with n
  rw [norm_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (cprime_pos m)]
  have hc := cprime_le m
  have hT := norm_T_le_pos hsmall hre n
  have h1 : 0 ≤ ‖w‖ := norm_nonneg _
  calc cS m / D m * ‖w‖ * ‖T m w n‖
      ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * ‖T m w n‖ := by gcongr
    _ ≤ _ := by gcongr

/-- **Upper bound, Gaussian regime, `Re(w²) ≤ 0`.** -/
theorem norm_S_le_gauss_neg {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hre : (w ^ 2).re ≤ 0) :
    ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖
      * Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
          + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
  have hlim := (tendsto_S hne).norm
  apply le_of_tendsto hlim
  filter_upwards [eventually_ge_atTop (2 * m + 3)] with n hn
  rw [norm_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (cprime_pos m)]
  have hc := cprime_le m
  have hT := norm_T_le_neg hsmall hre hn
  have h1 : 0 ≤ ‖w‖ := norm_nonneg _
  calc cS m / D m * ‖w‖ * ‖T m w n‖
      ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * ‖T m w n‖ := by gcongr
    _ ≤ _ := by gcongr

/-- The tail at real `s` is a real product. -/
def Tr (m : ℕ) (s : ℝ) (n : ℕ) : ℝ :=
  ∏ j ∈ Finset.Ico (m + 1) n, (1 + s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2))

theorem T_ofReal (m : ℕ) (s : ℝ) (n : ℕ) : T m (s : ℂ) n = ((Tr m s n : ℝ) : ℂ) := by
  unfold T Tr g
  push_cast
  rfl

/-- The real tail is at least the exponential of the tail sums. -/
theorem Tr_ge {m : ℕ} {s : ℝ} (_hs : 0 ≤ s) (hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    {n : ℕ} (hn : 2 * m + 3 ≤ n) :
    Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
      - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ Tr m s n := by
  have hpi : 0 < Real.pi := Real.pi_pos
  have hx : ∀ j ∈ Finset.Ico (m + 1) n, s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) ≤ 1 / 2 := by
    intro j hj
    have hjm := (Finset.mem_Ico.mp hj).1
    have hj' : (m : ℝ) + 2 ≤ (j : ℝ) + 1 := by
      have : m + 2 ≤ j + 1 := by omega
      exact_mod_cast this
    rw [div_le_iff₀ (by positivity)]
    calc s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 := hsmall
      _ ≤ Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2 / 2 := by gcongr
      _ = 1 / 2 * (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) := by ring
  have h1 : ∏ j ∈ Finset.Ico (m + 1) n, Real.exp (s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)
      - (s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2) ≤ Tr m s n := by
    unfold Tr
    apply Finset.prod_le_prod (fun _ _ => (Real.exp_pos _).le)
    intro j hj
    exact exp_le_one_add (by positivity) (hx j hj)
  rw [← Real.exp_sum] at h1
  refine le_trans (Real.exp_le_exp.mpr ?_) h1
  rw [Finset.sum_sub_distrib]
  have hA : s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
      ≤ ∑ j ∈ Finset.Ico (m + 1) n, s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) := by
    have hsum : ((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2
        ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := by
      refine (sum_inv_sq_ge m).trans ?_
      apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.Ico_subset_Ico_right hn)
      intro j _ _
      positivity
    have e : ∑ j ∈ Finset.Ico (m + 1) n, s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)
        = s ^ 2 / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      field_simp
    rw [e]
    have hs2 : 0 ≤ s ^ 2 / Real.pi ^ 2 := by positivity
    calc s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
        = s ^ 2 / Real.pi ^ 2 * (((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2) := by field_simp
      _ ≤ _ := mul_le_mul_of_nonneg_left hsum hs2
  have hB : ∑ j ∈ Finset.Ico (m + 1) n, (s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2
      ≤ s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
    have e : ∑ j ∈ Finset.Ico (m + 1) n, (s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2
        = s ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      field_simp
      try ring
    rw [e]
    have hs4 : 0 ≤ s ^ 4 / Real.pi ^ 4 := by positivity
    calc s ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
        ≤ s ^ 4 / Real.pi ^ 4 * (1 / ((m : ℝ) + 1) ^ 3) :=
          mul_le_mul_of_nonneg_left (sum_inv_pow4_le m n) hs4
      _ = _ := by field_simp
  linarith

/-- **Lower bound at the target, Gaussian regime.** For `0 < s`,
`4/(π(m+1)(2m+3)) · s · exp(s²(m+2)/(π²(2m+3)²) − s⁴/(π⁴(m+1)³)) ≤ Re (S m s)`. -/
theorem S_real_ge_gauss {m : ℕ} {s : ℝ} (hs : 0 < s)
    (hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s
      * Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
          - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ (S m (s : ℂ)).re := by
  have hne : QS m (s : ℂ) ≠ 0 := QS_ne_zero (by simpa using hs.ne')
  have hlim := (Complex.continuous_re.tendsto _).comp (tendsto_S hne)
  apply ge_of_tendsto hlim
  filter_upwards [eventually_ge_atTop (2 * m + 3)] with n hn
  simp only [Function.comp]
  rw [T_ofReal]
  have e : (((cS m / D m : ℝ) : ℂ) * (s : ℂ) * ((Tr m s n : ℝ) : ℂ)).re = cS m / D m * s * Tr m s n := by
    have : ((cS m / D m : ℝ) : ℂ) * (s : ℂ) * ((Tr m s n : ℝ) : ℂ)
        = ((cS m / D m * s * Tr m s n : ℝ) : ℂ) := by push_cast; ring
    rw [this, Complex.ofReal_re]
  rw [e]
  have hc := cprime_ge m
  have hT := Tr_ge hs.le hsmall hn
  have hE : 0 ≤ Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
      - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := (Real.exp_pos _).le
  have hpi : 0 < Real.pi := Real.pi_pos
  calc 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s
        * Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
          - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3))
      ≤ cS m / D m * s
        * Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
          - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by gcongr
    _ ≤ cS m / D m * s * Tr m s n := by
        apply mul_le_mul_of_nonneg_left hT
        exact mul_nonneg (cprime_pos m).le hs.le

end

/-- info: 'WeilPowerGauss.euler_sinh' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms euler_sinh

/-- info: 'WeilPowerGauss.norm_S_le_gauss_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_S_le_gauss_pos

/-- info: 'WeilPowerGauss.norm_S_le_gauss_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_S_le_gauss_neg

/-- info: 'WeilPowerGauss.S_real_ge_gauss' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S_real_ge_gauss

end WeilPowerGauss
