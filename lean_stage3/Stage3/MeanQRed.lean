/-
MeanQRed — block S13 of `lean_stage3/design/stencil.md`, B4 step 3, the mean value with a
general Q: the reduction `V = Q(−D/L) ζ + E`. 2026-11-25.

Pins: `PINS.md` § Current, "B4 step 3, the mean value with a general Q".

`V = W/Gammaℝ` (`ConreyCount.V`), `W = Σ_k b_k (−1/L)^k Λ^{(k)}` (`OperatorQ.W`), `b_k` the
Taylor coefficients of `Q` at `1/2`. With `Λ = Gammaℝ·ζ` on `Re s > 0` and Leibniz,
`Λ^{(k)}/Gammaℝ = Σ_j C(k,j) (Gammaℝ^{(k−j)}/Gammaℝ) ζ^{(j)}`, so exactly

  `V = Σ_j A_j (−1/L)^j ζ^{(j)}`,  `A_j = Σ_k b_k C(k,j) (−1/L)^{k−j} Gammaℝ^{(k−j)}/Gammaℝ`.

The Taylor shift back to `0` is `q_j = Q.coeff j = Σ_k b_k C(k,j) (−1/2)^{k−j}`, so
`V − Q(−D/L)ζ = Σ_j (A_j − q_j)(−1/L)^j ζ^{(j)}` with
`A_j − q_j = Σ_k b_k C(k,j) ((−1/L)^i Gammaℝ^{(i)}/Gammaℝ − (−1/2)^i)`, `i = k − j`.
The one analytic input is the size of `Gammaℝ^{(i)}/Gammaℝ = g^i + (terms in g′, g″, …)` with
`g = Gammaℝ′/Gammaℝ = L/2 + O(1)` on `[T/4, 2T]`: `(−1/L)^i Gammaℝ^{(i)}/Gammaℝ = (−1/2)^i + O(1/L)`,
named `StmtGrRatio` (the digamma worker's domain, `Stage3/DigammaBound*.lean`; not proved here).

**Sizes.** `|E| ≤ (K/L)·Σ_j |ζ^{(j)}|/L^j`: each `ζ^{(j)}/L^j` is the size the mean value
carries (`O(T)` mean square), so `E` is `1/L` below the main term; the factor is `1/L`, a gain.
Numeric check (scratchpad `meanq/check.py`, `Qcubic`, `R = 1.3`): `V` agrees with the exact
reduction to working precision, and `L·|E|/Σ|ζ^{(j)}|/L^j` stays bounded as `T` grows.

  | name               | statement                                                        | status |
  |--------------------|------------------------------------------------------------------|--------|
  | `coeff_taylor`     | `(taylor r p).coeff j = Σ_k p_k C(k,j) r^{k−j}`                    | PROVED |
  | `coeff_eq_shift`   | `Q.coeff j = Σ_k b_k C(k,j) (−1/2)^{k−j}`                          | PROVED |
  | `iteratedDeriv_xi` | `Re s > 0`, `s ≠ 1` ⊢ Leibniz for `Λ = Gammaℝ·ζ`                   | PROVED |
  | `V_eq_sum`         | `V = Σ_j A_j (−1/L)^j ζ^{(j)}`                                     | PROVED |
  | `V_sub_VQ`         | `V − VQ = Σ_j (A_j − q_j)(−1/L)^j ζ^{(j)}`                         | PROVED |
  | `Acoef_sub`        | `A_j − q_j = Σ_k b_k C(k,j)((−1/L)^i grR i − (−1/2)^i)`            | PROVED |
  | `StmtGrRatio`      | `‖(−1/L)^i Gammaℝ^{(i)}/Gammaℝ − (−1/2)^i‖ ≤ C/L`, `i ≤ n`         | OPEN   |
  | `E_bound`          | `StmtGrRatio d` ⊢ `‖V − VQ‖ ≤ (K/L) Σ_j ‖ζ^{(j)}‖/L^j`              | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ConreyCountLine

noncomputable section

namespace MeanQ

open Complex Polynomial Filter Topology

/-! ### The Taylor shift -/

/-- The coefficients of a Taylor shift: `(taylor r p).coeff j = Σ_k p_k C(k,j) r^{k−j}`. -/
theorem coeff_taylor (p : ℝ[X]) (r : ℝ) (j : ℕ) :
    (taylor r p).coeff j = ∑ k ∈ Finset.range (p.natDegree + 1),
      p.coeff k * (k.choose j : ℝ) * r ^ (k - j) := by
  rw [taylor_coeff, hasseDeriv_apply, Polynomial.eval_sum, Polynomial.sum_over_range]
  · refine Finset.sum_congr rfl fun k _ => ?_
    rw [eval_monomial]
    ring
  · intro n
    simp

/-- **The shift back to `0`**: `Q.coeff j = Σ_k b_k C(k,j) (−1/2)^{k−j}`, `b = taylor (1/2) Q`. -/
theorem coeff_eq_shift (Q : ℝ[X]) (j : ℕ) :
    Q.coeff j = ∑ k ∈ Finset.range (Q.natDegree + 1),
      (taylor (1/2 : ℝ) Q).coeff k * (k.choose j : ℝ) * (-1/2 : ℝ) ^ (k - j) := by
  have h : taylor (-1/2 : ℝ) (taylor (1/2 : ℝ) Q) = Q := by
    rw [taylor_taylor]
    norm_num
  have h2 := coeff_taylor (taylor (1/2 : ℝ) Q) (-1/2) j
  rw [h, natDegree_taylor] at h2
  exact h2

/-! ### Leibniz for `Λ = Gammaℝ · ζ` -/

theorem zeta_analyticAt {s : ℂ} (hs1 : s ≠ 1) : AnalyticAt ℂ riemannZeta s := by
  have hd : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun _ hz =>
    (differentiableAt_riemannZeta (Set.mem_compl_singleton_iff.mp hz)).differentiableWithinAt
  exact hd.analyticOnNhd isOpen_compl_singleton s hs1

/-- `Λ = Gammaℝ · ζ` near a point with `Re s > 0`. -/
theorem xi_eventually {s : ℂ} (hs : 0 < s.re) :
    completedRiemannZeta =ᶠ[𝓝 s] fun z => Gammaℝ z * riemannZeta z := by
  have hO : IsOpen {z : ℂ | 0 < z.re} := isOpen_lt continuous_const Complex.continuous_re
  filter_upwards [hO.mem_nhds hs] with z hz
  have h0 : z ≠ 0 := by
    intro h
    rw [h] at hz
    simp at hz
  rw [riemannZeta_def_of_ne_zero h0, mul_div_cancel₀ _ (Gammaℝ_ne_zero_of_re_pos hz)]

/-- **Leibniz for `Λ`**: `Λ^{(k)}(s) = Σ_i C(k,i) Gammaℝ^{(i)}(s) ζ^{(k−i)}(s)`. -/
theorem iteratedDeriv_xi (k : ℕ) {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) :
    iteratedDeriv k completedRiemannZeta s = ∑ i ∈ Finset.range (k + 1),
      (k.choose i : ℂ) * iteratedDeriv i Gammaℝ s * iteratedDeriv (k - i) riemannZeta s := by
  rw [(xi_eventually hs).iteratedDeriv_eq k]
  exact iteratedDeriv_fun_mul
    (ConreyCount.analyticAt_Gammaℝ' (Gammaℝ_ne_zero_of_re_pos hs)).contDiffAt
    (zeta_analyticAt hs1).contDiffAt

/-! ### The reduction -/

/-- `Gammaℝ^{(i)}/Gammaℝ`. -/
def grR (i : ℕ) (s : ℂ) : ℂ := iteratedDeriv i Gammaℝ s / Gammaℝ s

/-- `A_j = Σ_k b_k C(k,j) (−1/L)^{k−j} Gammaℝ^{(k−j)}/Gammaℝ`. -/
def Acoef (Q : ℝ[X]) (L : ℝ) (j : ℕ) (s : ℂ) : ℂ :=
  ∑ k ∈ Finset.range (Q.natDegree + 1),
    (((taylor (1/2 : ℝ) Q).coeff k * (k.choose j : ℝ) * (-1 / L) ^ (k - j) : ℝ) : ℂ) *
      grR (k - j) s

/-- `Q(−(1/L) d/ds) ζ = Σ_j q_j (−1/L)^j ζ^{(j)}`, `q_j = Q.coeff j`. -/
def VQ (Q : ℝ[X]) (L : ℝ) (s : ℂ) : ℂ :=
  ∑ j ∈ Finset.range (Q.natDegree + 1),
    ((Q.coeff j * (-1 / L) ^ j : ℝ) : ℂ) * iteratedDeriv j riemannZeta s

/-- One `Λ^{(k)}/Gammaℝ`, reindexed by the order of `ζ` and extended to `range (d+1)`. -/
theorem xi_div_eq {d k : ℕ} (hk : k ≤ d) {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) :
    iteratedDeriv k completedRiemannZeta s / Gammaℝ s =
      ∑ j ∈ Finset.range (d + 1),
        (k.choose j : ℂ) * grR (k - j) s * iteratedDeriv j riemannZeta s := by
  rw [iteratedDeriv_xi k hs hs1, Finset.sum_div, ← Finset.sum_range_reflect]
  have hsub : Finset.range (k + 1) ⊆ Finset.range (d + 1) :=
    Finset.range_subset_range.mpr (by omega)
  rw [← Finset.sum_subset hsub (fun j _ hj => by
    have hkj : k < j := by simpa using hj
    rw [Nat.choose_eq_zero_of_lt hkj]
    simp)]
  refine Finset.sum_congr rfl fun j hj => ?_
  have hjk : j ≤ k := by simpa [Nat.lt_succ_iff] using hj
  have e1 : k + 1 - 1 - j = k - j := by omega
  have e2 : k - (k - j) = j := by omega
  rw [e1, e2, Nat.choose_symm hjk]
  unfold grR
  ring

/-- **The exact reduction**: `V = Σ_j A_j (−1/L)^j ζ^{(j)}` on `Re s > 0`, `s ≠ 1`. -/
theorem V_eq_sum (Q : ℝ[X]) (L : ℝ) {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) :
    ConreyCount.V Q L s = ∑ j ∈ Finset.range (Q.natDegree + 1),
      Acoef Q L j s * (((-1 / L) ^ j : ℝ) : ℂ) * iteratedDeriv j riemannZeta s := by
  unfold ConreyCount.V OperatorQ.W
  rw [Finset.sum_div]
  have h1 : ∀ k ∈ Finset.range (Q.natDegree + 1),
      (((taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k : ℝ) : ℂ) *
        iteratedDeriv k completedRiemannZeta s / Gammaℝ s =
      ∑ j ∈ Finset.range (Q.natDegree + 1),
        (((taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k : ℝ) : ℂ) *
          ((k.choose j : ℂ) * grR (k - j) s * iteratedDeriv j riemannZeta s) := by
    intro k hk
    rw [mul_div_assoc, xi_div_eq (by simpa [Nat.lt_succ_iff] using hk) hs hs1, Finset.mul_sum]
  rw [Finset.sum_congr rfl h1, Finset.sum_comm]
  refine Finset.sum_congr rfl fun j _ => ?_
  unfold Acoef
  rw [Finset.sum_mul, Finset.sum_mul]
  refine Finset.sum_congr rfl fun k _ => ?_
  rcases le_or_gt j k with hjk | hjk
  · have e : (-1 / L : ℝ) ^ k = (-1 / L) ^ (k - j) * (-1 / L) ^ j := by
      rw [← pow_add, Nat.sub_add_cancel hjk]
    rw [e]
    push_cast
    ring
  · rw [Nat.choose_eq_zero_of_lt hjk]
    push_cast
    ring

/-- **The error**: `V − Q(−D/L)ζ = Σ_j (A_j − q_j)(−1/L)^j ζ^{(j)}`. -/
theorem V_sub_VQ (Q : ℝ[X]) (L : ℝ) {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) :
    ConreyCount.V Q L s - VQ Q L s = ∑ j ∈ Finset.range (Q.natDegree + 1),
      (Acoef Q L j s - (Q.coeff j : ℂ)) * (((-1 / L) ^ j : ℝ) : ℂ) *
        iteratedDeriv j riemannZeta s := by
  rw [V_eq_sum Q L hs hs1, VQ, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun j _ => ?_
  push_cast
  ring

/-- **The coefficient error**: `A_j − q_j = Σ_k b_k C(k,j) ((−1/L)^i grR i − (−1/2)^i)`, `i = k − j`. -/
theorem Acoef_sub (Q : ℝ[X]) (L : ℝ) (j : ℕ) (s : ℂ) :
    Acoef Q L j s - (Q.coeff j : ℂ) = ∑ k ∈ Finset.range (Q.natDegree + 1),
      (((taylor (1/2 : ℝ) Q).coeff k * (k.choose j : ℝ) : ℝ) : ℂ) *
        ((((-1 / L) ^ (k - j) : ℝ) : ℂ) * grR (k - j) s - (((-1/2 : ℝ) ^ (k - j) : ℝ) : ℂ)) := by
  rw [coeff_eq_shift Q j, Acoef]
  push_cast
  rw [← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun k _ => ?_
  ring

/-- OPEN, **the `Gammaℝ` ratio**: for `i ≤ n`, uniformly on `σ ∈ [1/4, 1]`, `t ∈ [T/4, 2T]`,
`‖(−1/L)^i Gammaℝ^{(i)}(σ+it)/Gammaℝ(σ+it) − (−1/2)^i‖ ≤ C/L`, `L = log T`.
Budget: any `C`, any `T₀`. Route: `Gammaℝ^{(i)}/Gammaℝ` is the complete Bell polynomial in
`g, g′, …, g^{(i−1)}`, `g = Gammaℝ′/Gammaℝ = −(1/2) log π + (1/2) ψ(s/2)`; with
`|ψ(z) − log z| ≤ C/|z|` and `|ψ^{(m)}(z)| ≤ C_m/|z|^m` (the digamma worker,
`Stage3/DigammaBound*.lean`), `g = L/2 + O(1)` and `g^{(m)} = O(1/t^m)` on the window, so the
Bell polynomial is `g^i + O(L^{i−2}/t)` and `(−g/L)^i = (−1/2)^i + O(1/L)`. -/
def StmtGrRatio (n : ℕ) : Prop :=
  ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ i ≤ n, ∀ σ ∈ Set.Icc (1/4 : ℝ) 1,
    ∀ t ∈ Set.Icc (T / 4) (2 * T),
      ‖(((-1 / Real.log T) ^ i : ℝ) : ℂ) * grR i ((σ : ℂ) + t * I) -
          (((-1/2 : ℝ) ^ i : ℝ) : ℂ)‖ ≤ C / Real.log T

/-- **The size of `E`**: from `StmtGrRatio`, on `σ ∈ [1/4, 1]`, `t ∈ [T/4, 2T]`,
`‖V − Q(−D/L)ζ‖ ≤ (K/L) Σ_j ‖ζ^{(j)}‖/L^j`, `L = log T`. -/
theorem E_bound (Q : ℝ[X]) (hG : StmtGrRatio Q.natDegree) :
    ∃ K T₀ : ℝ, 0 ≤ K ∧ ∀ T : ℝ, T₀ ≤ T → ∀ σ ∈ Set.Icc (1/4 : ℝ) 1,
      ∀ t ∈ Set.Icc (T / 4) (2 * T),
        ‖ConreyCount.V Q (Real.log T) ((σ : ℂ) + t * I) - VQ Q (Real.log T) ((σ : ℂ) + t * I)‖ ≤
          K / Real.log T * ∑ j ∈ Finset.range (Q.natDegree + 1),
            ‖iteratedDeriv j riemannZeta ((σ : ℂ) + t * I)‖ / Real.log T ^ j := by
  obtain ⟨C, T₀, hC0, hC⟩ := hG
  set d := Q.natDegree with hd
  set b : ℕ → ℝ := fun k => (taylor (1/2 : ℝ) Q).coeff k with hb
  set B : ℝ := ∑ j ∈ Finset.range (d + 1), ∑ k ∈ Finset.range (d + 1),
    |b k| * (k.choose j : ℝ) with hB
  have hB0 : 0 ≤ B := Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => by positivity
  refine ⟨C * B, max T₀ 3, by positivity, fun T hT σ hσ t ht => ?_⟩
  have hT0 : T₀ ≤ T := le_trans (le_max_left _ _) hT
  have hT3 : 3 ≤ T := le_trans (le_max_right _ _) hT
  have hL0 : 0 < Real.log T := Real.log_pos (by linarith)
  set L := Real.log T with hL
  set s : ℂ := (σ : ℂ) + t * I with hs
  have hsre : 0 < s.re := by
    rw [hs]
    simp
    linarith [hσ.1]
  have hs1 : s ≠ 1 := by
    intro h
    have := congrArg Complex.im h
    rw [hs] at this
    simp at this
    linarith [ht.1]
  -- the coefficient error
  have hA : ∀ j ∈ Finset.range (d + 1), ‖Acoef Q L j s - (Q.coeff j : ℂ)‖ ≤
      C / L * ∑ k ∈ Finset.range (d + 1), |b k| * (k.choose j : ℝ) := by
    intro j _
    rw [Acoef_sub, Finset.mul_sum]
    refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun k hk => ?_)
    have hik : k - j ≤ d := le_trans (Nat.sub_le k j) (by simpa [Nat.lt_succ_iff] using hk)
    have h1 := hC T hT0 (k - j) hik σ hσ t ht
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_mul, Nat.abs_cast]
    calc |b k| * (k.choose j : ℝ) * ‖(((-1 / L) ^ (k - j) : ℝ) : ℂ) * grR (k - j) s -
          (((-1/2 : ℝ) ^ (k - j) : ℝ) : ℂ)‖
        ≤ |b k| * (k.choose j : ℝ) * (C / L) :=
          mul_le_mul_of_nonneg_left h1 (by positivity)
      _ = C / L * (|b k| * (k.choose j : ℝ)) := by ring
  rw [V_sub_VQ Q L hsre hs1]
  refine (norm_sum_le _ _).trans ?_
  rw [Finset.mul_sum]
  refine Finset.sum_le_sum fun j hj => ?_
  have hpow : ‖(((-1 / L) ^ j : ℝ) : ℂ)‖ = 1 / L ^ j := by
    rw [Complex.norm_real, Real.norm_eq_abs, abs_pow, abs_div, abs_neg, abs_one,
      abs_of_pos hL0, one_div_pow]
  have hsingle : ∑ k ∈ Finset.range (d + 1), |b k| * (k.choose j : ℝ) ≤ B :=
    Finset.single_le_sum (f := fun j => ∑ k ∈ Finset.range (d + 1), |b k| * (k.choose j : ℝ))
      (fun _ _ => Finset.sum_nonneg fun _ _ => by positivity) hj
  rw [norm_mul, norm_mul, hpow]
  have hz := norm_nonneg (iteratedDeriv j riemannZeta s)
  have hLj : 0 < L ^ j := pow_pos hL0 j
  calc ‖Acoef Q L j s - (Q.coeff j : ℂ)‖ * (1 / L ^ j) * ‖iteratedDeriv j riemannZeta s‖
      ≤ (C / L * B) * (1 / L ^ j) * ‖iteratedDeriv j riemannZeta s‖ := by
        have h2 : ‖Acoef Q L j s - (Q.coeff j : ℂ)‖ ≤ C / L * B :=
          (hA j hj).trans (mul_le_mul_of_nonneg_left hsingle (by positivity))
        have h3 : 0 ≤ 1 / L ^ j := by positivity
        exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right h2 h3) hz
    _ = C * B / L * (‖iteratedDeriv j riemannZeta s‖ / L ^ j) := by ring

/-- info: 'MeanQ.coeff_eq_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms coeff_eq_shift

/-- info: 'MeanQ.V_eq_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_eq_sum

/-- info: 'MeanQ.V_sub_VQ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_sub_VQ

/-- info: 'MeanQ.E_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms E_bound

end MeanQ

end
