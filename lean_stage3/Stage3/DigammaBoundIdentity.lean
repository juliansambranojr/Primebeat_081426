/-
DigammaBoundIdentity — block S13 of `lean_stage3/design/stencil.md`, B4 step 2, the shift
identity for `V`. 2026-11-25.

`V = W/Gammaℝ = Q(1/2 − (D + g)/L) ζ` (`ConreyCount.V`). Taking the shift `g ≈ L/2` out
exactly: near `w`, `Λ(z) = Gammaℝ(w) · H_w(z) · e^{(L/2)(z − w)}` with

  `H_w(z) = ζ(z) · Gammaℝ(z)/Gammaℝ(w) · e^{−(L/2)(z − w)}`,

and `D e^{a z} f = e^{a z} (D + a) f` turns `Q(1/2 − D/L)` into `Q(1/2 − (D + L/2)/L) = Q(−D/L)`:

  `V(w) = Σ_j Q_j (−1/L)^j H_w^{(j)}(w)`,  `Q_j = Q.coeff j` (`V_eq_sum_H`).

The `j = 0` term is `Q(0) ζ(w)`. The point of the form: `H_w` carries no factor growing with
`L` on a disc of fixed radius about `w` at height `≍ e^L` (`DigammaBoundSize`), so each
`j ≥ 1` term is `O(L^{−j})` by Cauchy's estimate. No derivative of `g` (no digamma) enters.

  | name               | statement                                                          | status |
  |--------------------|--------------------------------------------------------------------|--------|
  | `H`                | `H L w z = ζ z · Gammaℝ z / Gammaℝ w · e^{−(L/2)(z − w)}`            | def    |
  | `poly_shift`       | `Σ_k b_k (−1/L)^k (X + L/2)^k = Σ_j Q_j (−1/L)^j X^j`, `L ≠ 0`      | PROVED |
  | `differentiableAt_H` | `0 < Re z`, `z ≠ 1` ⊢ `H L w` differentiable at `z`               | PROVED |
  | `V_eq_sum_H`       | `L ≠ 0`, `0 < Re w`, `w ≠ 1` ⊢ `V Q L w = Σ_j Q_j (−1/L)^j H_w^{(j)}(w)` | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ConreyCount

noncomputable section

namespace DigammaBound

open Complex Polynomial Filter Topology

/-- `H_w(z) = ζ(z) · Gammaℝ(z)/Gammaℝ(w) · e^{−(L/2)(z − w)}`. -/
def H (L : ℝ) (w z : ℂ) : ℂ :=
  riemannZeta z * Gammaℝ z / Gammaℝ w * cexp (-((L / 2 : ℝ) : ℂ) * (z - w))

/-- **The shift of the polynomial.** With `b_k` the Taylor coefficients of `Q` at `1/2`:
`Σ_k b_k (−1/L)^k (X + L/2)^k = Σ_j Q_j (−1/L)^j X^j`. -/
theorem poly_shift (Q : ℝ[X]) {L : ℝ} (hL : L ≠ 0) :
    (∑ k ∈ Finset.range (Q.natDegree + 1),
      C ((taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k) * (X + C (L / 2)) ^ k)
    = ∑ j ∈ Finset.range (Q.natDegree + 1), C (Q.coeff j * (-1 / L) ^ j) * X ^ j := by
  apply Polynomial.funext
  intro y
  simp only [eval_finsetSum, eval_mul, eval_C, eval_pow, eval_add, eval_X]
  have h1 : ∑ k ∈ Finset.range (Q.natDegree + 1),
      (taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k * (y + L / 2) ^ k
      = (taylor (1/2 : ℝ) Q).eval ((-1 / L) * (y + L / 2)) := by
    rw [eval_eq_sum_range, natDegree_taylor]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [mul_pow]
    ring
  have h2 : ∑ j ∈ Finset.range (Q.natDegree + 1), Q.coeff j * (-1 / L) ^ j * y ^ j
      = Q.eval ((-1 / L) * y) := by
    rw [eval_eq_sum_range]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [mul_pow]
    ring
  rw [h1, h2, taylor_eval]
  congr 1
  field_simp
  ring

/-- The coefficients of the shifted polynomial. -/
theorem poly_shift_coeff (Q : ℝ[X]) {L : ℝ} (hL : L ≠ 0) {i : ℕ}
    (hi : i ∈ Finset.range (Q.natDegree + 1)) :
    ∑ k ∈ Finset.range (Q.natDegree + 1),
      (taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k * ((X + C (L / 2)) ^ k).coeff i
    = Q.coeff i * (-1 / L) ^ i := by
  have h := congrArg (fun p : ℝ[X] => p.coeff i) (poly_shift Q hL)
  simp only [finsetSum_coeff, coeff_C_mul] at h
  rw [h]
  simp [coeff_X_pow, hi]

/-- `H_w` is differentiable on `Re > 0` off `1`. -/
theorem differentiableAt_H (L : ℝ) (w : ℂ) {z : ℂ} (hz : 0 < z.re) (hz1 : z ≠ 1) :
    DifferentiableAt ℂ (H L w) z := by
  have hG : Gammaℝ z ≠ 0 := Gammaℝ_ne_zero_of_re_pos hz
  have hGa := (ConreyCount.analyticAt_Gammaℝ' hG).differentiableAt
  have hζ := differentiableAt_riemannZeta hz1
  unfold H
  fun_prop

/-- `H_w` is analytic on `Re > 0` off `1`. -/
theorem analyticAt_H (L : ℝ) (w : ℂ) {z : ℂ} (hz : 0 < z.re) (hz1 : z ≠ 1) :
    AnalyticAt ℂ (H L w) z := by
  have hU : IsOpen {u : ℂ | 0 < u.re ∧ u ≠ 1} :=
    (isOpen_lt continuous_const Complex.continuous_re).inter isOpen_ne
  refine DifferentiableOn.analyticAt (s := {u : ℂ | 0 < u.re ∧ u ≠ 1}) ?_
    (hU.mem_nhds ⟨hz, hz1⟩)
  intro u hu
  exact (differentiableAt_H L w hu.1 hu.2).differentiableWithinAt

/-- The iterated derivatives of `e^{a(z − w)}` at `w`. -/
theorem iteratedDeriv_E (a w : ℂ) (m : ℕ) :
    iteratedDeriv m (fun z => cexp (a * (z - w))) w = a ^ m := by
  have h := congrFun (iteratedDeriv_comp_sub_const (n := m) (s := w)
    (f := fun z => cexp (a * z))) w
  rw [h, iteratedDeriv_cexp_const_mul]
  simp

/-- Near `w`, `Λ = Gammaℝ(w) · H_w · e^{(L/2)(z − w)}`. -/
theorem xi_eventually_eq (L : ℝ) {w : ℂ} (hw : 0 < w.re) :
    completedRiemannZeta =ᶠ[𝓝 w]
      fun z => Gammaℝ w * (H L w z * cexp (((L / 2 : ℝ) : ℂ) * (z - w))) := by
  have hGw : Gammaℝ w ≠ 0 := Gammaℝ_ne_zero_of_re_pos hw
  have hopen : IsOpen {z : ℂ | 0 < z.re} := isOpen_lt continuous_const Complex.continuous_re
  filter_upwards [hopen.mem_nhds hw] with z hz
  have hz0 : z ≠ 0 := by
    intro h; rw [h, Complex.zero_re] at hz; exact lt_irrefl _ hz
  have hGz : Gammaℝ z ≠ 0 := Gammaℝ_ne_zero_of_re_pos hz
  have hexp : cexp (-((L / 2 : ℝ) : ℂ) * (z - w)) * cexp (((L / 2 : ℝ) : ℂ) * (z - w)) = 1 := by
    rw [← Complex.exp_add, neg_mul, neg_add_cancel, Complex.exp_zero]
  have hζ := riemannZeta_def_of_ne_zero hz0
  unfold H
  rw [hζ]
  calc completedRiemannZeta z
      = Gammaℝ w * (completedRiemannZeta z / Gammaℝ z * Gammaℝ z / Gammaℝ w) *
          (cexp (-((L / 2 : ℝ) : ℂ) * (z - w)) * cexp (((L / 2 : ℝ) : ℂ) * (z - w))) := by
        rw [hexp]; field_simp
    _ = _ := by ring

/-- **The shift identity.** For `L ≠ 0`, `0 < Re w`, `w ≠ 1`:
`V Q L w = Σ_j Q_j (−1/L)^j H_w^{(j)}(w)`. -/
theorem V_eq_sum_H (Q : ℝ[X]) {L : ℝ} (hL : L ≠ 0) {w : ℂ} (hw : 0 < w.re) (hw1 : w ≠ 1) :
    ConreyCount.V Q L w = ∑ j ∈ Finset.range (Q.natDegree + 1),
      ((Q.coeff j * (-1 / L) ^ j : ℝ) : ℂ) * iteratedDeriv j (H L w) w := by
  have hGw : Gammaℝ w ≠ 0 := Gammaℝ_ne_zero_of_re_pos hw
  set a : ℂ := ((L / 2 : ℝ) : ℂ) with ha
  set h : ℕ → ℂ := fun j => iteratedDeriv j (H L w) w with hh
  have hHa := analyticAt_H L w hw hw1
  have hEa : AnalyticAt ℂ (fun z => cexp (a * (z - w))) w := by fun_prop
  -- each derivative of `Λ`
  have hk : ∀ k ∈ Finset.range (Q.natDegree + 1), iteratedDeriv k completedRiemannZeta w =
      Gammaℝ w * ∑ i ∈ Finset.range (Q.natDegree + 1),
        ((((X + C (L / 2)) ^ k).coeff i : ℝ) : ℂ) * h i := by
    intro k hkn
    have hkn' : k + 1 ≤ Q.natDegree + 1 := Finset.mem_range.mp hkn
    rw [(xi_eventually_eq L hw).iteratedDeriv_eq k, iteratedDeriv_const_mul_field,
      iteratedDeriv_fun_mul hHa.contDiffAt hEa.contDiffAt]
    congr 1
    have hsub : Finset.range (k + 1) ⊆ Finset.range (Q.natDegree + 1) :=
      Finset.range_subset_range.mpr hkn'
    have hz : ∀ i ∈ Finset.range (Q.natDegree + 1), i ∉ Finset.range (k + 1) →
        ((((X + C (L / 2)) ^ k).coeff i : ℝ) : ℂ) * h i = 0 := by
      intro i _ hi
      have hik : k < i := by
        have := Finset.mem_range.not.mp hi
        omega
      rw [coeff_X_add_C_pow, Nat.choose_eq_zero_of_lt hik]
      simp
    rw [← Finset.sum_subset hsub hz]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [iteratedDeriv_E, coeff_X_add_C_pow]
    simp only [hh, ha]
    push_cast
    ring
  have hW : OperatorQ.W Q L w = Gammaℝ w * ∑ k ∈ Finset.range (Q.natDegree + 1),
      (((taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k : ℝ) : ℂ) *
        ∑ i ∈ Finset.range (Q.natDegree + 1),
          ((((X + C (L / 2)) ^ k).coeff i : ℝ) : ℂ) * h i := by
    unfold OperatorQ.W
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun k hkn => ?_
    rw [hk k hkn]
    ring
  unfold ConreyCount.V
  rw [hW, mul_div_cancel_left₀ _ hGw]
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun i hi => ?_
  rw [← poly_shift_coeff Q hL hi]
  push_cast
  rw [Finset.sum_mul]
  refine Finset.sum_congr rfl fun k _ => ?_
  ring

/-- info: 'DigammaBound.poly_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms poly_shift

/-- info: 'DigammaBound.analyticAt_H' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms analyticAt_H

/-- info: 'DigammaBound.V_eq_sum_H' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_eq_sum_H

end DigammaBound

end
