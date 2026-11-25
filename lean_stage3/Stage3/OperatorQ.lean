/-
OperatorQ — block S13 of `lean_stage3/design/stencil.md`, B4, the operator with a general Q. 2026-11-25.

Step (1) of the plan, the line identity, for a real polynomial `Q` with `Q(0) = 1` and
`Q'(x) = Q'(1 − x)`.

**What fails.** For `V = Q(−(1/L) d/ds) ζ` with `Q` of degree `≥ 2`, the identity of
`LevinsonLine.re_gammaR_G_line`, `Re(Gammaℝ·V) = Λ · (real factor)` on the line, is not
exact. Write `g = Gammaℝ'/Gammaℝ`, so that `Gammaℝ · D(Λ/Gammaℝ) = (D − g)Λ` and
`Gammaℝ·V = Q(−(D − g)/L) Λ`. On the line `Λ^{(k)} = i^{−k} × real`. Then `Re(Gammaℝ·V)`
carries `Λ''` with the coefficient `3 q₃ (Re g − L/2)/L³` and `Λ'/i` with a coefficient
of the same size, and neither vanishes, because `Re g = (1/2) log(t/2π) + O(1/t)` moves
with `t` while `L` is fixed. So the zeros of `Re(Gammaℝ·V)` on the line are not the zeros
of `ζ`. Numerically, with `Q(x) = 1 − x + 2((x − 1/2)³ + 1/8)` and `L = log 1000`,
`Re(Gammaℝ·V) = 1.17e-7` at the first zero of `ζ` (the scale `|Gammaℝ·ζ'| = 1.38e-5`), and
`1.90e-13` at the fifth (scale `7.54e-12`); for `Q = 1 − x` both are `0` to 35 digits
(scratchpad `opq/linecheck.py`).

**What holds, proved here.** Put `W = Q(1/2 − (1/L) d/ds) Λ`, the operator applied to `Λ`
with `Q` recentred at `1/2`: `W = Σ_k b_k (−1/L)^k Λ^{(k)}`, `b_k` the Taylor coefficients
of `Q` at `1/2` (`Polynomial.taylor`). The symmetry `Q'(x) = Q'(1 − x)` is exactly
`b_k = 0` for even `k ≥ 2`, and on the line `Λ^{(k)}` is purely imaginary for odd `k`. So
`Re W = Q(1/2) · Λ` on the line, with a constant factor, and where `Q(1/2) ≠ 0` the zeros
of `ζ` on the line are exactly the zeros of `Re W`. For `Q = 1 − x` this is
`W = Λ/2 + Λ'/L`. The two operators are conjugate: `W/Gammaℝ = Q(−(D + g − L/2)/L) ζ`,
which is `V` up to the shift `(g − L/2)/L = O(1/L)` inside `Q`.

  | name                        | statement                                              | status |
  |-----------------------------|--------------------------------------------------------|--------|
  | `im_I_pow_iteratedDeriv`    | `(I^k · Λ^{(k)}(1/2+ti)).im = 0`                        | PROVED |
  | `re_iteratedDeriv_odd`      | `k` odd ⊢ `(Λ^{(k)}(1/2+ti)).re = 0`                    | PROVED |
  | `re_sum_line`               | `a k = 0` for even `k ≠ 0` ⊢ `Re Σ a_k Λ^{(k)} = a₀ Λ`  | PROVED |
  | `taylor_coeff_even_eq_zero` | `Q'(x) = Q'(1−x)` ⊢ `(taylor (1/2) Q).coeff k = 0`, even `k ≠ 0` | PROVED |
  | `re_W_line`                 | `Re W(1/2+ti) = Q(1/2) · Λ(1/2+ti)`                     | PROVED |
  | `zeta_line_zero_iff_W`      | `Q(1/2) ≠ 0` ⊢ `ζ(1/2+ti) = 0 ↔ Re W(1/2+ti) = 0`       | PROVED |
  | `cubic_sym`, `cubic_re_W_line` | the hypotheses hold for `1 + x/2 − 3x² + 2x³`; `Re W = (3/4)·Λ` | PROVED |

Where this stops: the plan's step (1) for `V` itself, the count through
`Re(Gammaℝ·V)`, is false for nonlinear `Q` and is not stated. Steps (2)–(5) are not
started. The redesign the identity suggests (count through `W`, mollify `W/Gammaℝ`,
and pay the `O(1/L)` shift inside `Q` in the mean value) is a decision for the block.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonLine

noncomputable section

namespace OperatorQ

open Complex HardyZ LevinsonLine Polynomial

/-- The domain of `Λ`: away from `0` and `1`. -/
def domXi : Set ℂ := {z | z ≠ 0 ∧ z ≠ 1}

theorem isOpen_domXi : IsOpen domXi := by
  have h : domXi = {(0 : ℂ)}ᶜ ∩ {(1 : ℂ)}ᶜ := by
    ext z; simp [domXi]
  rw [h]
  exact isOpen_compl_singleton.inter isOpen_compl_singleton

theorem analyticOnNhd_xi : AnalyticOnNhd ℂ completedRiemannZeta domXi :=
  DifferentiableOn.analyticOnNhd
    (fun _ hz => (differentiableAt_completedZeta hz.1 hz.2).differentiableWithinAt)
    isOpen_domXi

theorem line_mem (t : ℝ) : ((1/2 : ℂ) + t * I) ∈ domXi := by
  obtain ⟨h0, h1, -⟩ := line_facts t
  exact ⟨h0, h1⟩

/-- Every iterated derivative of `Λ` is complex-differentiable on the line. -/
theorem differentiableAt_iteratedDeriv (k : ℕ) (t : ℝ) :
    DifferentiableAt ℂ (iteratedDeriv k completedRiemannZeta) ((1/2 : ℂ) + t * I) := by
  rw [iteratedDeriv_eq_iterate]
  exact ((analyticOnNhd_xi.iterated_deriv k) _ (line_mem t)).differentiableAt

/-- A function differentiable on the line and real there has `I · F'` real there. -/
theorem im_I_mul_deriv {F : ℂ → ℂ}
    (hF : ∀ t : ℝ, DifferentiableAt ℂ F ((1/2 : ℂ) + t * I))
    (hr : ∀ t : ℝ, (F ((1/2 : ℂ) + t * I)).im = 0) (t : ℝ) :
    (I * deriv F ((1/2 : ℂ) + t * I)).im = 0 := by
  set s : ℂ := 1/2 + t * I with hs_def
  have hlin : HasDerivAt (fun w : ℂ => (1/2 : ℂ) + w * I) I (t : ℂ) := by
    have := ((hasDerivAt_id (t : ℂ)).mul_const I).const_add (1/2 : ℂ)
    simpa using this
  have hΛ : HasDerivAt F (deriv F s) s := (hF t).hasDerivAt
  have hcomp : HasDerivAt (fun w : ℂ => F ((1/2 : ℂ) + w * I))
      (deriv F s * I) (t : ℂ) :=
    HasDerivAt.comp (t : ℂ) (h₂ := F) (h := fun w : ℂ => (1/2 : ℂ) + w * I) hΛ hlin
  have hreal : HasDerivAt (fun y : ℝ => F ((1/2 : ℂ) + y * I)) (deriv F s * I) t :=
    hcomp.comp_ofReal
  have him : HasDerivAt (Complex.imCLM ∘ fun y : ℝ => F ((1/2 : ℂ) + y * I))
      (Complex.imCLM (deriv F s * I)) t :=
    Complex.imCLM.hasFDerivAt.comp_hasDerivAt t hreal
  have hfun : (Complex.imCLM ∘ fun y : ℝ => F ((1/2 : ℂ) + y * I)) =
      fun _ : ℝ => (0 : ℝ) := by
    funext y
    simp only [Function.comp_apply, Complex.imCLM_apply]
    exact hr y
  rw [hfun] at him
  have h00 := him.unique (hasDerivAt_const t (0 : ℝ))
  rw [Complex.imCLM_apply] at h00
  rw [mul_comm]
  exact h00

/-- **Target 1.** On the line, `I^k · Λ^{(k)}` is real. -/
theorem im_I_pow_iteratedDeriv (k : ℕ) (t : ℝ) :
    (I ^ k * iteratedDeriv k completedRiemannZeta ((1/2 : ℂ) + t * I)).im = 0 := by
  induction k generalizing t with
  | zero =>
    simp only [pow_zero, one_mul, iteratedDeriv_zero]
    exact xi_line_real t
  | succ k ih =>
    have hF : ∀ u : ℝ, DifferentiableAt ℂ
        (fun z => I ^ k * iteratedDeriv k completedRiemannZeta z) ((1/2 : ℂ) + u * I) :=
      fun u => (differentiableAt_iteratedDeriv k u).const_mul _
    have h := im_I_mul_deriv hF ih t
    have hd : deriv (fun z => I ^ k * iteratedDeriv k completedRiemannZeta z)
        ((1/2 : ℂ) + t * I) =
        I ^ k * iteratedDeriv (k + 1) completedRiemannZeta ((1/2 : ℂ) + t * I) := by
      rw [deriv_const_mul _ (differentiableAt_iteratedDeriv k t), iteratedDeriv_succ]
    rw [hd] at h
    rw [pow_succ, mul_comm (I ^ k) I, mul_assoc]
    exact h

/-- **Target 2.** On the line, an odd derivative of `Λ` is purely imaginary. -/
theorem re_iteratedDeriv_odd {k : ℕ} (hk : Odd k) (t : ℝ) :
    (iteratedDeriv k completedRiemannZeta ((1/2 : ℂ) + t * I)).re = 0 := by
  obtain ⟨j, rfl⟩ := hk
  have h := im_I_pow_iteratedDeriv (2 * j + 1) t
  set z := iteratedDeriv (2 * j + 1) completedRiemannZeta ((1/2 : ℂ) + t * I) with hz
  have hI : I ^ (2 * j + 1) = ((-1 : ℝ) ^ j : ℝ) * I := by
    rw [pow_succ, pow_mul, I_sq]
    push_cast
    try ring
  rw [hI, mul_assoc, Complex.im_ofReal_mul, Complex.mul_im, Complex.I_re,
    Complex.I_im] at h
  have hne : ((-1 : ℝ) ^ j) ≠ 0 := pow_ne_zero _ (by norm_num)
  have h2 : (-1 : ℝ) ^ j * z.re = 0 := by rw [← h]; ring
  exact (mul_eq_zero.mp h2).resolve_left hne

/-- **Target 3.** A real combination of derivatives of `Λ` with no even derivative past
the zeroth has real part `a₀ · Λ` on the line. -/
theorem re_sum_line (a : ℕ → ℝ) (n : ℕ) (ha : ∀ k, Even k → k ≠ 0 → a k = 0) (t : ℝ) :
    (∑ k ∈ Finset.range (n + 1),
        (a k : ℂ) * iteratedDeriv k completedRiemannZeta ((1/2 : ℂ) + t * I)).re =
      a 0 * (completedRiemannZeta ((1/2 : ℂ) + t * I)).re := by
  rw [Finset.sum_range_succ', Complex.add_re, Complex.re_sum]
  have hterm : ∀ k ∈ Finset.range n,
      ((a (k + 1) : ℂ) *
        iteratedDeriv (k + 1) completedRiemannZeta ((1/2 : ℂ) + t * I)).re = 0 := by
    intro k _
    rw [Complex.re_ofReal_mul]
    rcases Nat.even_or_odd (k + 1) with he | ho
    · rw [ha (k + 1) he (Nat.succ_ne_zero k), zero_mul]
    · rw [re_iteratedDeriv_odd ho t, mul_zero]
  rw [Finset.sum_eq_zero hterm, zero_add, iteratedDeriv_zero, Complex.re_ofReal_mul]

/-- The coefficients of `p.comp (−X)` are those of `p` times `(−1)^n`. -/
theorem coeff_comp_neg_X (p : ℝ[X]) (n : ℕ) :
    (p.comp (-X)).coeff n = (-1) ^ n * p.coeff n := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq => rw [add_comp, coeff_add, coeff_add, hp, hq]; ring
  | monomial k c =>
    rw [← C_mul_X_pow_eq_monomial, mul_comp, C_comp, X_pow_comp, neg_pow]
    have e : C c * ((-1 : ℝ[X]) ^ k * X ^ k) = C (c * (-1) ^ k) * X ^ k := by
      rw [C_mul, C_pow, C_neg, C_1]; ring
    rw [e, coeff_C_mul_X_pow, coeff_C_mul_X_pow]
    split_ifs with h
    · subst h; ring
    · ring

/-- **Target 4.** `Q'(x) = Q'(1 − x)` makes the even Taylor coefficients of `Q` at `1/2`
vanish past the zeroth. -/
theorem taylor_coeff_even_eq_zero (Q : ℝ[X])
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    {k : ℕ} (hk : Even k) (hk0 : k ≠ 0) : (taylor (1/2 : ℝ) Q).coeff k = 0 := by
  set p := taylor (1/2 : ℝ) Q with hp
  have hder : p.derivative = Q.derivative.comp (X + C (1/2 : ℝ)) := by
    rw [hp, taylor_apply, derivative_comp, derivative_add, derivative_X, derivative_C,
      add_zero, one_mul]
  have hsym : p.derivative.comp (-X) = p.derivative := by
    apply Polynomial.funext
    intro y
    simp only [eval_comp, hder, eval_neg, eval_X, eval_add, eval_C]
    rw [hQ]
    congr 1
    ring
  obtain ⟨j, rfl⟩ := hk
  have hj : j ≠ 0 := by omega
  obtain ⟨i, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hj
  -- coefficient `2i+1` of `p'` is `(2i+2)·b_{2i+2}`, and the symmetry kills it
  have h1 := congrArg (fun r => r.coeff (2 * i + 1)) hsym
  rw [coeff_comp_neg_X, coeff_derivative] at h1
  have hodd : ((-1 : ℝ) ^ (2 * i + 1)) = -1 := by rw [pow_succ, pow_mul]; norm_num
  rw [hodd] at h1
  have h2 : p.coeff (2 * i + 1 + 1) * ((↑(2 * i + 1) : ℝ) + 1) = 0 := by linarith
  have hne : ((↑(2 * i + 1) : ℝ) + 1) ≠ 0 := by positivity
  have h3 := (mul_eq_zero.mp h2).resolve_right hne
  have he : i.succ + i.succ = 2 * i + 1 + 1 := by omega
  rw [he]
  exact h3

/-- `W = Q(1/2 − (1/L) d/ds) Λ`: the Taylor coefficients `b_k` of `Q` at `1/2`, against
`(−1/L)^k Λ^{(k)}`. -/
def W (Q : ℝ[X]) (L : ℝ) (s : ℂ) : ℂ :=
  ∑ k ∈ Finset.range (Q.natDegree + 1),
    (((taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k : ℝ) : ℂ) *
      iteratedDeriv k completedRiemannZeta s

/-- **Target 5.** On the line, `Re W = Q(1/2) · Λ`. -/
theorem re_W_line (Q : ℝ[X])
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x)) (L t : ℝ) :
    (W Q L ((1/2 : ℂ) + t * I)).re =
      Q.eval (1/2) * (completedRiemannZeta ((1/2 : ℂ) + t * I)).re := by
  unfold W
  rw [re_sum_line (fun k => (taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k) Q.natDegree
    (fun k hk hk0 => by
      show (taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k = 0
      rw [taylor_coeff_even_eq_zero Q hQ hk hk0, zero_mul]) t]
  rw [taylor_coeff_zero, pow_zero, mul_one]

/-- **Target 6.** Where `Q(1/2) ≠ 0`, the zeros of `ζ` on the line are exactly the zeros
of `Re W`. -/
theorem zeta_line_zero_iff_W (Q : ℝ[X])
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (L t : ℝ) :
    riemannZeta ((1/2 : ℂ) + t * I) = 0 ↔ (W Q L ((1/2 : ℂ) + t * I)).re = 0 := by
  obtain ⟨h0, -, hre⟩ := line_facts t
  have hG : Gammaℝ ((1/2 : ℂ) + t * I) ≠ 0 := Gammaℝ_ne_zero_of_re_pos hre
  have hΛ : completedRiemannZeta ((1/2 : ℂ) + t * I) =
      Gammaℝ ((1/2 : ℂ) + t * I) * riemannZeta ((1/2 : ℂ) + t * I) := by
    rw [riemannZeta_def_of_ne_zero h0, mul_div_cancel₀ _ hG]
  rw [re_W_line Q hQ, mul_eq_zero, or_iff_right hQh]
  constructor
  · intro hz
    rw [hΛ, hz, mul_zero, Complex.zero_re]
  · intro hz
    have hΛ0 : completedRiemannZeta ((1/2 : ℂ) + t * I) = 0 :=
      Complex.ext hz (xi_line_real t)
    rw [hΛ] at hΛ0
    exact (mul_eq_zero.mp hΛ0).resolve_left hG

/-- The cubic of the numerical check, `Q = 1 + x/2 − 3x² + 2x³ = 1 − x + 2((x − 1/2)³ + 1/8)`. -/
def Qcubic : ℝ[X] := 1 + C (1/2) * X - C 3 * X ^ 2 + C 2 * X ^ 3

/-- **Target 7.** The hypotheses hold for a nonlinear `Q`: `Qcubic` has `Q(0) = 1`,
`Q'(x) = Q'(1 − x)` and `Q(1/2) = 3/4`. -/
theorem cubic_sym :
    Qcubic.eval 0 = 1 ∧
      (∀ x : ℝ, Qcubic.derivative.eval x = Qcubic.derivative.eval (1 - x)) ∧
      Qcubic.eval (1/2) = 3/4 := by
  refine ⟨?_, ?_, ?_⟩
  · simp [Qcubic]
  · intro x
    simp only [Qcubic, derivative_add, derivative_sub, derivative_one, derivative_C_mul_X,
      derivative_C_mul_X_pow, eval_add, eval_sub, eval_mul, eval_C, eval_pow, eval_X,
      eval_zero]
    ring
  · simp [Qcubic]; norm_num

/-- **Target 8.** For `Qcubic`, `Re W = (3/4) · Λ` on the line, for every `L`. -/
theorem cubic_re_W_line (L t : ℝ) :
    (W Qcubic L ((1/2 : ℂ) + t * I)).re =
      3/4 * (completedRiemannZeta ((1/2 : ℂ) + t * I)).re := by
  rw [re_W_line Qcubic cubic_sym.2.1, cubic_sym.2.2]

/-- info: 'OperatorQ.im_I_pow_iteratedDeriv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms im_I_pow_iteratedDeriv

/-- info: 'OperatorQ.re_iteratedDeriv_odd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_iteratedDeriv_odd

/-- info: 'OperatorQ.re_sum_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_sum_line

/-- info: 'OperatorQ.coeff_comp_neg_X' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms coeff_comp_neg_X

/-- info: 'OperatorQ.taylor_coeff_even_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms taylor_coeff_even_eq_zero

/-- info: 'OperatorQ.re_W_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_W_line

/-- info: 'OperatorQ.zeta_line_zero_iff_W' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_line_zero_iff_W

/-- info: 'OperatorQ.cubic_sym' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cubic_sym

/-- info: 'OperatorQ.cubic_re_W_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cubic_re_W_line

end OperatorQ

end
