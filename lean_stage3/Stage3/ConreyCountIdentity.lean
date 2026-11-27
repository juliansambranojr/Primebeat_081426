/-
ConreyCountIdentity — block S13 of `lean_stage3/design/stencil.md`, B4 step 1, Conrey's identity.
2026-11-25.

Conrey (J. Number Theory 16 (1983), §4) takes a real polynomial `Q` with `Q(0) = 1` and
`Q(x) + Q(1 − x) = K`, `K ≠ 0`, and proves `K·ξ^{(m)}(s) = Q_m(s) + (−1)^m Q_m(1 − s)` (his (1))
through a Riemann–Siegel integral. At `m = 0` and for `W = OperatorQ.W Q L`
(`W = Σ_k b_k (−1/L)^k Λ^{(k)}`, `b_k` the Taylor coefficients of `Q` at `1/2`) the identity is
`W(s) + W(1 − s) = K·Λ(s)`, `K = 2·Q(1/2)`, and it follows from the functional equation alone:
`Λ(1 − s) = Λ(s)` for every `s` (Mathlib's `completedRiemannZeta_one_sub`, no domain condition,
since Mathlib's `Λ` is a total function), so `Λ^{(k)}(1 − s) = (−1)^k Λ^{(k)}(s)` for every `s`
(Mathlib's `iteratedDeriv_comp_const_sub`, which needs no differentiability). The odd terms
cancel, and the even terms past the zeroth vanish by `OperatorQ.taylor_coeff_even_eq_zero`,
since `Q′(x) = Q′(1 − x)` is the derivative of Conrey's `Q(x) + Q(1 − x) = K`.

  | name                          | statement                                                  | status |
  |-------------------------------|------------------------------------------------------------|--------|
  | `iteratedDeriv_xi_one_sub`    | `Λ^{(k)}(1 − s) = (−1)^k Λ^{(k)}(s)`, every `s`              | PROVED |
  | `conrey_identity`             | `Q′(x) = Q′(1−x)` ⊢ `W(s) + W(1 − s) = 2·Q(1/2)·Λ(s)`, every `s` | PROVED |
  | `sym_of_add_const`            | `Q(x) + Q(1 − x) = K` for all `x` ⊢ `Q′(x) = Q′(1 − x)`      | PROVED |
  | `conrey_identity_K`           | Conrey's hypothesis form: `W(s) + W(1 − s) = K·Λ(s)`, `K = 2Q(1/2)` | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.OperatorQ

noncomputable section

namespace ConreyCount

open Complex Polynomial

/-- **The parity of the derivatives of `Λ`.** `Λ^{(k)}(1 − s) = (−1)^k Λ^{(k)}(s)` for every
`s ∈ ℂ`. -/
theorem iteratedDeriv_xi_one_sub (k : ℕ) (s : ℂ) :
    iteratedDeriv k completedRiemannZeta (1 - s) =
      (-1 : ℂ) ^ k * iteratedDeriv k completedRiemannZeta s := by
  have hfun : (fun z : ℂ => completedRiemannZeta (1 - z)) = completedRiemannZeta :=
    funext completedRiemannZeta_one_sub
  have h := congrFun (iteratedDeriv_comp_const_sub k completedRiemannZeta (1 : ℂ)) (1 - s)
  rw [hfun, sub_sub_cancel, smul_eq_mul] at h
  exact h

/-- **Conrey's identity at `m = 0`.** For `Q′(x) = Q′(1 − x)`:
`W(s) + W(1 − s) = 2·Q(1/2)·Λ(s)` for every `s`. -/
theorem conrey_identity (Q : ℝ[X])
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x)) (L : ℝ) (s : ℂ) :
    OperatorQ.W Q L s + OperatorQ.W Q L (1 - s) =
      2 * ((Q.eval (1/2 : ℝ) : ℝ) : ℂ) * completedRiemannZeta s := by
  unfold OperatorQ.W
  rw [← Finset.sum_add_distrib]
  simp_rw [iteratedDeriv_xi_one_sub]
  rw [Finset.sum_eq_single 0]
  · rw [taylor_coeff_zero]
    simp only [pow_zero, mul_one, iteratedDeriv_zero, one_mul]
    ring
  · intro k _ hk0
    rcases Nat.even_or_odd k with he | ho
    · rw [OperatorQ.taylor_coeff_even_eq_zero Q hQ he hk0]
      simp
    · rw [ho.neg_one_pow]
      ring
  · intro h
    exact absurd (Finset.mem_range.mpr (Nat.succ_pos _)) h

/-- Conrey's hypothesis `Q(x) + Q(1 − x) = K` gives the symmetry of `Q′`. -/
theorem sym_of_add_const (Q : ℝ[X]) (K : ℝ) (hK : ∀ x : ℝ, Q.eval x + Q.eval (1 - x) = K) :
    ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x) := by
  have hp : Q + Q.comp (1 - X) = C K := by
    apply Polynomial.funext
    intro x
    simp only [eval_add, eval_comp, eval_sub, eval_one, eval_X, eval_C]
    exact hK x
  have hd := congrArg Polynomial.derivative hp
  rw [derivative_add, derivative_comp, derivative_sub, derivative_one, derivative_X,
    derivative_C] at hd
  intro x
  have hx := congrArg (Polynomial.eval x) hd
  simp only [eval_add, eval_mul, eval_comp, eval_sub, eval_one, eval_X, eval_zero] at hx
  linarith

/-- **Conrey's identity in his form.** For `Q(x) + Q(1 − x) = K`:
`W(s) + W(1 − s) = K·Λ(s)` for every `s` (and `K = 2·Q(1/2)`). -/
theorem conrey_identity_K (Q : ℝ[X]) (K : ℝ) (hK : ∀ x : ℝ, Q.eval x + Q.eval (1 - x) = K)
    (L : ℝ) (s : ℂ) :
    OperatorQ.W Q L s + OperatorQ.W Q L (1 - s) = (K : ℂ) * completedRiemannZeta s := by
  rw [conrey_identity Q (sym_of_add_const Q K hK) L s]
  have h := hK (1/2)
  have e : (1 : ℝ) - 1/2 = 1/2 := by norm_num
  rw [e] at h
  have hK2 : K = 2 * Q.eval (1/2) := by linarith
  rw [hK2]
  push_cast
  ring

/-- info: 'ConreyCount.iteratedDeriv_xi_one_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iteratedDeriv_xi_one_sub

/-- info: 'ConreyCount.conrey_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms conrey_identity

/-- info: 'ConreyCount.sym_of_add_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sym_of_add_const

/-- info: 'ConreyCount.conrey_identity_K' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms conrey_identity_K

end ConreyCount

end
