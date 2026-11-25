/-
# ApproxDerivAll — block S12 of `lean_stage3/design/stencil.md`, all orders. 2026-11-25.

Young's (4.3) (arXiv 1002.4403, Lemma 4's Remark) for every `j ≥ 1`, the `t`-derivatives of
`dY` to every order, and `j` integrations by parts; the decision is unit 0535 (the number of
integrations by parts in the off-diagonal must grow with the mollifier length). Notation as in
`ApproxFE`, `ApproxBounds`, `ApproxDeriv`: `u = uA α t`, `v = vB β t`, `V = VY α β c x t` on the
line `Re s = c`, `N = 1 + ‖α+β‖^(−2)`, `e_λ(t) = eL λ t = e^(−iλt)` (`TwistedMoment`).

The route. (1) `∂_tᵏ dY` is the termwise series `dYk k`, with terms
`(i/2)[(i/2)ᵏ τ⁽ᵏ⁾(u/2) − (−i/2)ᵏ τ⁽ᵏ⁾(v/2)]`, `τ⁽ᵏ⁾ₙ = (−1)ᵏ k! ((n+w)^(−(k+1)) − (n+w+h)^(−(k+1)))`
(`tauK`); `a^(−m) − b^(−m)` through the geometric sum gives `‖τ⁽ᵏ⁾ₙ‖ ≤ (k+1)! ‖h‖ 2^(k+2) b^(−k)/(n+b)²`,
the telescoping majorant of `ApproxDeriv` sums it, and `hasDerivAt_tsum` differentiates it, so
`t ↦ dY` is smooth and `t^(k+1)‖∂_tᵏ dY‖ ≤ Dk k (1+|σ|)(1+|y|)^(k+2)`, `Dk k = 84 (k+1)! 40^(k+1)`
(bulk `|y| ≤ t/2` with `b ≥ t/5`, else `t < 2|y|`). (2) `∂_t g = g·dY` makes `g` smooth, and
Leibniz (`iteratedDeriv_fun_mul`) gives `∂_t^(j+1) g = Σ_{i≤j} C(j,i) ∂_tⁱ g · ∂_t^(j−i) dY`: this
is `∂_tʲ g = g·Pⱼ` with `Pⱼ` defined by that recursion instead of `P_{j+1} = ∂_t Pⱼ + dY·Pⱼ`.
An induction on the recursion alone (`leib_bound`) gives `‖∂_tʲ g‖ ≤ ‖g‖ M_j ((1+|σ|)(1+|y|)²/t)^j`.
(3) The integrand of `∂_tʲ V` is `G(s)/s · ∂_tʲ g · x^(−s)` (`IYk`); differentiation under the
integral is dominated locally in `t` by `KY_local` and the crude form of (2), so it holds at every
real `t` and every order. The assembly is `VY_decay_young`'s: the line `A` for `x > t`, the line
`−1/4` for `x ≤ t`, the residue `1` dropping out of every derivative (`VYk_lines`).

| statement | content | status |
|---|---|---|
| `ibp_iter_chain` | `∫_a^b F₀ e_λ = (1/(iλ))^j ∫_a^b F_j e_λ`, `F_{k+1} = F_k'`, `F_k(a) = F_k(b) = 0`, `k < j` | proved |
| `ibp_iter` | the same for `F` of class `Cʲ` on `ℝ`, `F^(k)(a) = F^(k)(b) = 0`, `k < j` | proved |
| `tauK`, `hasDerivAt_tauK_line`, `norm_tauK_le` | the `k`-th derivative of `τₙ` along a line, and its size | proved |
| `dYk_hasDerivAt` | `∂_t dYk k = dYk (k+1)`, every real `t`, `Re s ≥ −1/4` | proved |
| `dYk_contDiff`, `dY_contDiff`, `iteratedDeriv_dY` | `t ↦ dY` is `C^∞`, `∂_tᵏ dY = dYk k` | proved |
| `dYk_bound`, `dY_iter_bound` | target 1: `t^(k+1)‖∂_tᵏ dY‖ ≤ Dk k (1+|σ|)(1+|y|)^(k+2)`, `t ≥ 1`, every `k` | proved |
| `gY_contDiff`, `gY_iter_succ` | `t ↦ g` is `C^∞`; Leibniz for `∂_t^(j+1) g` | proved |
| `leib_bound`, `gY_iter_bound` | `‖∂_tʲ g‖ ≤ ‖g‖ M_j ((1+|σ|)(1+|y|)²/t)^j`, `t ≥ 1` | proved |
| `VYk_hasDerivAt` | `∂_t VYk j = VYk (j+1)` (under the integral), every real `t`, `σ ≥ −1/4`, `σ ≠ 0` | proved |
| `iteratedDeriv_VY_all`, `VY_contDiff` | `∂_tʲ V = VYk j`; `t ↦ V` is `C^∞`, line `c > 0` | proved |
| `VYk_line_bound`, `VYk_lines` | `‖tʲ VYk j‖ ≤ C N (t/2π)^σ x^(−σ)` on one line; line independence, `j ≥ 1` | proved |
| `VY_iter_bound` | target 2, (4.3) for every `j ≥ 1`: `‖tʲ ∂_tʲ V‖ ≤ C N (1 + x/t)^(−A)`, every `A > 0` | proved |

Differences from the targets. (i) `ibp_iter` is stated with `TwistedMoment.eL λ t = e^(−iλt)`,
`ibp_twice`'s convention, so its factor is `(1/(iλ))^j`; the target's `(−1/(iλ))^j` is the
same identity for `e^(+iλt)`. It asks `F` to be `Cʲ` on all of `ℝ` (as `ibp_twice` asks
`HasDerivAt` at every `t`), and holds for every `j`, `j = 0` included; `ibp_iter_chain` is
the form with an explicit chain of derivatives. (ii) Target 1 carries the factor `(1+|σ|)` with
`σ = Re s ≥ −1/4`, as `ApproxDeriv.dY_bound` does, with the explicit constant `Dk k`.
(iii) `Pⱼ` is not a named polynomial: `∂_tʲ g / g` is handled through the Leibniz recursion,
and the bound is on `‖∂_tʲ g‖ / ‖g‖`. (iv) As in `ApproxDeriv`: the direction `(1 + x/t)^(−A)`,
the factor `N`, uniformity in `‖α‖, ‖β‖ ≤ 1/10`, `t ≥ 1`, `α + β ≠ 0`, any line `c > 0`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.TwistedMoment

namespace ApproxDerivAll

open Complex MeasureTheory Filter Topology ApproxFE ApproxBounds ApproxDeriv TwistedMoment
open scoped ContDiff

/-! ## Part 3: `j` integrations by parts -/

/-- `j` integrations by parts against `e_λ(t) = e^(−iλt)`, for a chain `F 0, F 1, …, F j`
with `F (k+1)` the derivative of `F k` and `F k` vanishing at `a`, `b` for `k < j`. -/
theorem ibp_iter_chain {a b l : ℝ} (hl : l ≠ 0) (j : ℕ) :
    ∀ F : ℕ → ℝ → ℂ, (∀ k < j, ∀ t, HasDerivAt (F k) (F (k + 1) t) t) →
      IntervalIntegrable (F j) volume a b → (∀ k < j, F k a = 0) → (∀ k < j, F k b = 0) →
        ∫ t in a..b, F 0 t * eL l t =
          (1 / ((l : ℂ) * I)) ^ j * ∫ t in a..b, F j t * eL l t := by
  induction j with
  | zero => intro F _ _ _ _; simp
  | succ j ih =>
    intro F hF hFj ha hb
    have h1 : IntervalIntegrable (F 1) volume a b := by
      rcases Nat.eq_zero_or_pos j with h0 | h0
      · subst h0; simpa using hFj
      · have hc : Continuous (F 1) := continuous_iff_continuousAt.mpr fun t =>
          (hF 1 (by omega) t).continuousAt
        exact hc.intervalIntegrable a b
    have e0 := ibp_once hl (hF 0 (by omega)) h1 (ha 0 (by omega)) (hb 0 (by omega))
    have e1 := ih (fun k => F (k + 1)) (fun k hk t => hF (k + 1) (by omega) t)
      (by simpa using hFj) (fun k hk => ha (k + 1) (by omega)) (fun k hk => hb (k + 1) (by omega))
    simp only [zero_add] at e1
    rw [e0, e1, pow_succ]
    ring

/-- **`j` integrations by parts.** For `F` of class `Cʲ` with `F, F', …, F^(j−1)` vanishing at
`a` and `b`, and `λ ≠ 0`: `∫_a^b F e_λ = (1/(iλ))^j ∫_a^b F^(j) e_λ`, `e_λ(t) = e^(−iλt)`. -/
theorem ibp_iter {F : ℝ → ℂ} {a b l : ℝ} (hl : l ≠ 0) (j : ℕ) (hF : ContDiff ℝ j F)
    (ha : ∀ k < j, iteratedDeriv k F a = 0) (hb : ∀ k < j, iteratedDeriv k F b = 0) :
    ∫ t in a..b, F t * eL l t =
      (1 / ((l : ℂ) * I)) ^ j * ∫ t in a..b, iteratedDeriv j F t * eL l t := by
  have h := ibp_iter_chain hl j (fun k => iteratedDeriv k F) (fun k hk t => by
      have hd := hF.differentiable_iteratedDeriv k (by exact_mod_cast hk)
      rw [iteratedDeriv_succ]
      exact (hd t).hasDerivAt)
    ((hF.continuous_iteratedDeriv j le_rfl).intervalIntegrable a b) ha hb
  simpa using h

/-! ## Part 1: the `t`-derivatives of `dY` to every order -/

/-- The `k`-th derivative in `w` of `τₙ`, up to the factor `e^k` of the line:
`(−1)^k k! ((n+w)^(−(k+1)) − (n+w+h)^(−(k+1)))`. -/
noncomputable
def tauK (k : ℕ) (h w : ℂ) (n : ℕ) : ℂ :=
  (-1) ^ k * (k.factorial : ℂ) * ((((n : ℂ) + w) ^ (k + 1))⁻¹ - (((n : ℂ) + w + h) ^ (k + 1))⁻¹)

theorem tauK_zero (h w : ℂ) (n : ℕ) : tauK 0 h w n = tau h w n := by
  simp [tauK, tau]

theorem hasDerivAt_tauK_line (h w₀ e : ℂ) (k n : ℕ) (t : ℝ) (hp : (n : ℂ) + (w₀ + t * e) ≠ 0)
    (hq : (n : ℂ) + (w₀ + t * e) + h ≠ 0) :
    HasDerivAt (fun t : ℝ => tauK k h (w₀ + t * e) n) (e * tauK (k + 1) h (w₀ + t * e) n) t := by
  have h1 : HasDerivAt (fun t : ℝ => (n : ℂ) + (w₀ + t * e)) e t :=
    (hasDerivAt_line w₀ e t).const_add _
  have h2 : HasDerivAt (fun t : ℝ => (n : ℂ) + (w₀ + t * e) + h) e t := h1.add_const h
  have p1 := (h1.fun_pow (k + 1)).fun_inv (pow_ne_zero _ hp)
  have p2 := (h2.fun_pow (k + 1)).fun_inv (pow_ne_zero _ hq)
  have h3 := (p1.sub p2).const_mul ((-1) ^ k * (k.factorial : ℂ))
  unfold tauK
  refine h3.congr_deriv ?_
  simp only [Nat.add_sub_cancel, Nat.factorial_succ]
  push_cast
  field_simp
  try ring

theorem norm_tauK_le {h w : ℂ} {a Y : ℝ} (ha : 0 < a) (hY : 0 ≤ Y) (h1 : a ≤ w.re)
    (h2 : a ≤ (w + h).re) (h3 : Y ≤ |w.im|) (h4 : Y ≤ |(w + h).im|) (k n : ℕ) :
    ‖tauK k h w n‖ ≤ ((k + 1).factorial : ℝ) * ‖h‖ * 2 ^ (k + 2) * (1 / (a + Y)) ^ k *
      (1 / ((n : ℝ) + (a + Y)) ^ 2) := by
  set r : ℝ := (n : ℝ) + (a + Y) with hr
  set b : ℝ := a + Y with hb
  have hb0 : 0 < b := by positivity
  have hr0 : 0 < r := by positivity
  have hrb : b ≤ r := by rw [hr]; have := n.cast_nonneg (α := ℝ); linarith
  have hp := norm_nat_add_ge h1 h3 n
  have hq := norm_nat_add_ge h2 h4 n
  rw [← add_assoc] at hq
  set P : ℂ := (n : ℂ) + w with hP
  set Q : ℂ := (n : ℂ) + w + h with hQ
  have hp' : r / 2 ≤ ‖P‖ := by rw [hr]; linarith
  have hq' : r / 2 ≤ ‖Q‖ := by rw [hr]; linarith
  have hP0 : P ≠ 0 := norm_pos_iff.mp (by linarith)
  have hQ0 : Q ≠ 0 := norm_pos_iff.mp (by linarith)
  set ρ : ℝ := 2 * (1 / r) with hρ
  have hρ0 : 0 ≤ ρ := by positivity
  have hx : ‖P⁻¹‖ ≤ ρ := by
    rw [norm_inv, hρ]
    rw [inv_le_iff_one_le_mul₀ (by linarith)]
    have : 2 * (1 / r) * (r / 2) = 1 := by field_simp; try ring
    nlinarith
  have hy : ‖Q⁻¹‖ ≤ ρ := by
    rw [norm_inv, hρ]
    rw [inv_le_iff_one_le_mul₀ (by linarith)]
    have : 2 * (1 / r) * (r / 2) = 1 := by field_simp; try ring
    nlinarith
  have e1 : ((P ^ (k + 1))⁻¹ - (Q ^ (k + 1))⁻¹) =
      (∑ i ∈ Finset.range (k + 1), P⁻¹ ^ i * Q⁻¹ ^ (k + 1 - 1 - i)) * (P⁻¹ - Q⁻¹) := by
    rw [geom_sum₂_mul, inv_pow, inv_pow]
  have e2 : P⁻¹ - Q⁻¹ = h * P⁻¹ * Q⁻¹ := by
    have hQP : Q = P + h := by rw [hQ, hP]
    rw [hQP] at hQ0 ⊢
    field_simp
    try ring
  have hsum : ‖∑ i ∈ Finset.range (k + 1), P⁻¹ ^ i * Q⁻¹ ^ (k + 1 - 1 - i)‖ ≤
      (k + 1) * ρ ^ k := by
    refine (norm_sum_le _ _).trans ?_
    have hterm : ∀ i ∈ Finset.range (k + 1), ‖P⁻¹ ^ i * Q⁻¹ ^ (k + 1 - 1 - i)‖ ≤ ρ ^ k := by
      intro i hi
      have hik : i ≤ k := by simp at hi; omega
      rw [norm_mul, norm_pow, norm_pow]
      have e : ρ ^ k = ρ ^ i * ρ ^ (k + 1 - 1 - i) := by
        rw [← pow_add]; congr 1; omega
      rw [e]
      exact mul_le_mul (pow_le_pow_left₀ (norm_nonneg _) hx i)
        (pow_le_pow_left₀ (norm_nonneg _) hy _) (by positivity) (by positivity)
    refine (Finset.sum_le_sum hterm).trans ?_
    simp
  have hdiff : ‖P⁻¹ - Q⁻¹‖ ≤ ‖h‖ * ρ ^ 2 := by
    rw [e2, norm_mul, norm_mul]
    have := mul_le_mul hx hy (norm_nonneg _) hρ0
    calc ‖h‖ * ‖P⁻¹‖ * ‖Q⁻¹‖ = ‖h‖ * (‖P⁻¹‖ * ‖Q⁻¹‖) := by ring
      _ ≤ ‖h‖ * (ρ * ρ) := mul_le_mul_of_nonneg_left this (norm_nonneg _)
      _ = ‖h‖ * ρ ^ 2 := by ring
  have hnorm1 : ‖((-1 : ℂ) ^ k * (k.factorial : ℂ))‖ = (k.factorial : ℝ) := by
    rw [norm_mul, norm_pow, norm_neg, norm_one, one_pow, one_mul]
    simp
  have hmain : ‖tauK k h w n‖ ≤ (k.factorial : ℝ) * (((k : ℝ) + 1) * ρ ^ k) * (‖h‖ * ρ ^ 2) := by
    unfold tauK
    rw [← hP, ← hQ, norm_mul, hnorm1, e1, norm_mul, mul_assoc]
    gcongr
  have hbr : (1 / r) ^ k ≤ (1 / b) ^ k :=
    pow_le_pow_left₀ (by positivity) (one_div_le_one_div_of_le hb0 hrb) k
  refine hmain.trans ?_
  rw [Nat.factorial_succ]
  push_cast
  have e3 : (k.factorial : ℝ) * (((k : ℝ) + 1) * ρ ^ k) * (‖h‖ * ρ ^ 2) =
      ((k : ℝ) + 1) * k.factorial * ‖h‖ * 2 ^ (k + 2) * (1 / r) ^ k * (1 / r ^ 2) := by
    rw [hρ]; ring_nf
  rw [e3]
  gcongr

/-- The `n`-th term of `∂_tᵏ dY`. -/
noncomputable
def dYterm (α β : ℂ) (k : ℕ) (t : ℝ) (s : ℂ) (n : ℕ) : ℂ :=
  I / 2 * ((I / 2) ^ k * tauK k (s / 2) (uA α t / 2) n -
    (-(I / 2)) ^ k * tauK k (s / 2) (vB β t / 2) n)

/-- `∂_tᵏ dY`, as the termwise derivative of the digamma series. -/
noncomputable
def dYk (α β : ℂ) (k : ℕ) (t : ℝ) (s : ℂ) : ℂ := ∑' n : ℕ, dYterm α β k t s n

theorem dYk_zero {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (t : ℝ) : dYk α β 0 t s = dY α β t s := by
  rw [← (dY_hasSum hα hβ hs t).tsum_eq]
  unfold dYk dYterm
  simp [tauK_zero]

theorem norm_pow_I_half (k : ℕ) : ‖(I / 2) ^ k‖ = (1 / 2) ^ k := by
  rw [norm_pow, norm_I_half]

theorem norm_pow_neg_I_half (k : ℕ) : ‖(-(I / 2)) ^ k‖ = (1 / 2) ^ k := by
  rw [norm_pow, norm_neg, norm_I_half]

theorem norm_dYterm_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) {Y : ℝ} (hY : 0 ≤ Y)
    (i1 : Y ≤ |(uA α t / 2).im|) (i2 : Y ≤ |(uA α t / 2 + s / 2).im|)
    (i3 : Y ≤ |(vB β t / 2).im|) (i4 : Y ≤ |(vB β t / 2 + s / 2).im|) (k n : ℕ) :
    ‖dYterm α β k t s n‖ ≤ 4 * ((k + 1).factorial : ℝ) * ‖s / 2‖ * (1 / (1 / 20 + Y)) ^ k *
      (1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n := by
  obtain ⟨r1, r2, r3, r4⟩ := re_conds hα hβ hs t
  have hb : 0 < 1 / 20 + Y := by positivity
  have a1 := norm_tauK_le (by norm_num : (0 : ℝ) < 1 / 20) hY r1 r2 i1 i2 k n
  have a2 := norm_tauK_le (by norm_num : (0 : ℝ) < 1 / 20) hY r3 r4 i3 i4 k n
  have a3 := sq_le_tel hb n
  set X : ℝ := ((k + 1).factorial : ℝ) * ‖s / 2‖ * 2 ^ (k + 2) * (1 / (1 / 20 + Y)) ^ k *
    (1 / ((n : ℝ) + (1 / 20 + Y)) ^ 2) with hX
  have h2 : (1 / 2 : ℝ) ^ k * 2 ^ k = 1 := by rw [← mul_pow]; norm_num
  calc ‖dYterm α β k t s n‖
      = 1 / 2 * ‖(I / 2) ^ k * tauK k (s / 2) (uA α t / 2) n -
          (-(I / 2)) ^ k * tauK k (s / 2) (vB β t / 2) n‖ := by
        unfold dYterm; rw [norm_mul, norm_I_half]
    _ ≤ 1 / 2 * ((1 / 2) ^ k * ‖tauK k (s / 2) (uA α t / 2) n‖ +
          (1 / 2) ^ k * ‖tauK k (s / 2) (vB β t / 2) n‖) := by
        gcongr
        refine (norm_sub_le _ _).trans ?_
        rw [norm_mul, norm_mul, norm_pow_I_half, norm_pow_neg_I_half]
    _ ≤ 1 / 2 * ((1 / 2) ^ k * X + (1 / 2) ^ k * X) := by gcongr
    _ = 4 * ((k + 1).factorial : ℝ) * ‖s / 2‖ * (1 / (1 / 20 + Y)) ^ k *
          (1 / ((n : ℝ) + (1 / 20 + Y)) ^ 2) * ((1 / 2) ^ k * 2 ^ k) := by
        rw [hX]; ring
    _ = 4 * ((k + 1).factorial : ℝ) * ‖s / 2‖ * (1 / (1 / 20 + Y)) ^ k *
          (1 / ((n : ℝ) + (1 / 20 + Y)) ^ 2) := by rw [h2, mul_one]
    _ ≤ 4 * ((k + 1).factorial : ℝ) * ‖s / 2‖ * (1 / (1 / 20 + Y)) ^ k *
          ((1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n) := by gcongr
    _ = _ := by ring

theorem summable_dYterm {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (k : ℕ) (t : ℝ) : Summable (dYterm α β k t s) :=
  Summable.of_norm_bounded (((hasSum_tel (by norm_num : (0 : ℝ) < 1 / 20 + 0)).summable).mul_left
    (4 * ((k + 1).factorial : ℝ) * ‖s / 2‖ * (1 / (1 / 20 + 0)) ^ k * (1 + 1 / (1 / 20 + 0))))
    (norm_dYterm_le hα hβ hs le_rfl (abs_nonneg _) (abs_nonneg _) (abs_nonneg _) (abs_nonneg _) k)

/-- `‖∂_tᵏ dY‖ ≤ 4 (k+1)! ‖s/2‖ (1/b)^k (1 + 1/b)/b`, `b = 1/20 + Y`. -/
theorem norm_dYk_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) {Y : ℝ} (hY : 0 ≤ Y)
    (i1 : Y ≤ |(uA α t / 2).im|) (i2 : Y ≤ |(uA α t / 2 + s / 2).im|)
    (i3 : Y ≤ |(vB β t / 2).im|) (i4 : Y ≤ |(vB β t / 2 + s / 2).im|) (k : ℕ) :
    ‖dYk α β k t s‖ ≤ 4 * ((k + 1).factorial : ℝ) * ‖s / 2‖ * (1 / (1 / 20 + Y)) ^ k *
      (1 + 1 / (1 / 20 + Y)) * (1 / (1 / 20 + Y)) := by
  have hb : 0 < 1 / 20 + Y := by positivity
  exact tsum_of_norm_bounded ((hasSum_tel hb).mul_left _)
    (norm_dYterm_le hα hβ hs hY i1 i2 i3 i4 k)

/-- `∂_t (∂_tᵏ dY) = ∂_t^(k+1) dY`, for every real `t`: the termwise derivative. -/
theorem dYk_hasDerivAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (k : ℕ) (t : ℝ) :
    HasDerivAt (fun t => dYk α β k t s) (dYk α β (k + 1) t s) t := by
  have eu : ∀ t : ℝ, uA α t / 2 = (1 / 2 + α) / 2 + (t : ℂ) * (I / 2) := fun t => by
    unfold uA; ring
  have ev : ∀ t : ℝ, vB β t / 2 = (1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2)) := fun t => by
    unfold vB; ring
  have hfun : (fun t => dYk α β k t s) = fun t : ℝ => ∑' n : ℕ, I / 2 *
      ((I / 2) ^ k * tauK k (s / 2) ((1 / 2 + α) / 2 + (t : ℂ) * (I / 2)) n -
        (-(I / 2)) ^ k * tauK k (s / 2) ((1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2))) n) := by
    funext t
    simp only [dYk, dYterm, eu, ev]
  have hval : dYk α β (k + 1) t s = ∑' n : ℕ, I / 2 *
      ((I / 2) ^ (k + 1) * tauK (k + 1) (s / 2) ((1 / 2 + α) / 2 + (t : ℂ) * (I / 2)) n -
        (-(I / 2)) ^ (k + 1) * tauK (k + 1) (s / 2) ((1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2))) n) := by
    simp only [dYk, dYterm, eu, ev]
  rw [hfun, hval]
  have hb : (0 : ℝ) < 1 / 20 + 0 := by norm_num
  refine hasDerivAt_tsum (𝕜 := ℝ) (F := ℂ)
    (g := fun (n : ℕ) (t : ℝ) => I / 2 *
      ((I / 2) ^ k * tauK k (s / 2) ((1 / 2 + α) / 2 + (t : ℂ) * (I / 2)) n -
        (-(I / 2)) ^ k * tauK k (s / 2) ((1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2))) n))
    (g' := fun (n : ℕ) (t : ℝ) => I / 2 *
      ((I / 2) ^ (k + 1) * tauK (k + 1) (s / 2) ((1 / 2 + α) / 2 + (t : ℂ) * (I / 2)) n -
        (-(I / 2)) ^ (k + 1) * tauK (k + 1) (s / 2) ((1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2))) n))
    (u := fun n => 4 * ((k + 1 + 1).factorial : ℝ) * ‖s / 2‖ * (1 / (1 / 20 + 0)) ^ (k + 1) *
      (1 + 1 / (1 / 20 + 0)) * tel (1 / 20 + 0) n)
    ((hasSum_tel hb).summable.mul_left _) ?_ ?_ (y₀ := t) ?_ t
  · intro n y
    obtain ⟨r1, r2, r3, r4⟩ := re_conds hα hβ hs y
    rw [eu] at r1 r2
    rw [ev] at r3 r4
    have p1 := nat_add_ne (by linarith : 0 < ((1 / 2 + α) / 2 + (y : ℂ) * (I / 2)).re) n
    have p2 := nat_add_ne (by linarith : 0 < ((1 / 2 + α) / 2 + (y : ℂ) * (I / 2) + s / 2).re) n
    have p3 := nat_add_ne (by linarith : 0 < ((1 / 2 + β) / 2 + (y : ℂ) * (-(I / 2))).re) n
    have p4 := nat_add_ne
      (by linarith : 0 < ((1 / 2 + β) / 2 + (y : ℂ) * (-(I / 2)) + s / 2).re) n
    rw [← add_assoc] at p2 p4
    have d1 := hasDerivAt_tauK_line (s / 2) _ _ k n y p1 p2
    have d2 := hasDerivAt_tauK_line (s / 2) _ _ k n y p3 p4
    refine (((d1.const_mul ((I / 2) ^ k)).sub (d2.const_mul ((-(I / 2)) ^ k))).const_mul
      (I / 2)).congr_deriv ?_
    ring
  · intro n y
    have h := norm_dYterm_le hα hβ hs le_rfl (abs_nonneg _) (abs_nonneg _) (abs_nonneg _)
      (abs_nonneg _) (k + 1) n (t := y)
    simp only [dYterm, eu, ev] at h
    exact h
  · have h := summable_dYterm hα hβ hs k t
    unfold dYterm at h
    simp only [eu, ev] at h
    exact h

/-- `t ↦ ∂_tᵏ dY` is `Cⁿ` for every `n` and `k`. -/
theorem dYk_contDiff {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (n : ℕ) : ∀ k : ℕ, ContDiff ℝ n (fun t => dYk α β k t s) := by
  induction n with
  | zero =>
    intro k
    exact contDiff_zero.mpr (continuous_iff_continuousAt.mpr fun t =>
      (dYk_hasDerivAt hα hβ hs k t).continuousAt)
  | succ n ih =>
    intro k
    have e : ((n + 1 : ℕ) : ℕ∞ω) = (n : ℕ∞ω) + 1 := by push_cast; rfl
    rw [e, contDiff_succ_iff_deriv]
    refine ⟨fun t => (dYk_hasDerivAt hα hβ hs k t).differentiableAt, by simp, ?_⟩
    have hd : deriv (fun t => dYk α β k t s) = fun t => dYk α β (k + 1) t s :=
      funext fun t => (dYk_hasDerivAt hα hβ hs k t).deriv
    rw [hd]
    exact ih (k + 1)

/-- `iteratedDeriv k (t ↦ dY) = ∂_tᵏ dY`, the termwise series. -/
theorem iteratedDeriv_dY {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (k : ℕ) :
    iteratedDeriv k (fun t => dY α β t s) = fun t => dYk α β k t s := by
  induction k with
  | zero =>
    rw [iteratedDeriv_zero]
    exact funext fun t => (dYk_zero hα hβ hs t).symm
  | succ k ih =>
    rw [iteratedDeriv_succ, ih]
    exact funext fun t => (dYk_hasDerivAt hα hβ hs k t).deriv

/-- **`t ↦ dY` is smooth**, through the termwise derivatives of the digamma series. -/
theorem dY_contDiff {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) : ContDiff ℝ ∞ (fun t => dY α β t s) := by
  have e : (fun t => dY α β t s) = fun t => dYk α β 0 t s :=
    funext fun t => (dYk_zero hα hβ hs t).symm
  rw [e]
  exact contDiff_infty.mpr fun n => dYk_contDiff hα hβ hs n 0

/-- The crude constant, valid at every real `t`. -/
noncomputable
def Dc (k : ℕ) : ℝ := 84 * ((k + 1).factorial : ℝ) * 20 ^ (k + 1)

/-- The constant of `dY_iter_bound`. -/
noncomputable
def Dk (k : ℕ) : ℝ := 84 * ((k + 1).factorial : ℝ) * 40 ^ (k + 1)

theorem Dc_nonneg (k : ℕ) : 0 ≤ Dc k := by unfold Dc; positivity

theorem Dk_nonneg (k : ℕ) : 0 ≤ Dk k := by unfold Dk; positivity

/-- `‖∂_tᵏ dY(σ+iy, t)‖ ≤ Dc k (1+|σ|)(1+|y|)` for every real `t`. -/
theorem dYk_crude {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (k : ℕ) (t y : ℝ) :
    ‖dYk α β k t (σ + y * I)‖ ≤ Dc k * ((1 + |σ|) * (1 + |y|)) := by
  have h := norm_dYk_le hα hβ (s := (σ : ℂ) + y * I) (t := t) (by simpa using hσ0) le_rfl
    (abs_nonneg _) (abs_nonneg _) (abs_nonneg _) (abs_nonneg _) k
  have e : (1 / (1 / 20 + 0) : ℝ) = 20 := by norm_num
  rw [e] at h
  have h2 := norm_half_le σ y
  refine h.trans ?_
  have hF : 0 ≤ ((k + 1).factorial : ℝ) := by positivity
  calc 4 * ((k + 1).factorial : ℝ) * ‖((σ : ℂ) + y * I) / 2‖ * 20 ^ k * (1 + 20) * 20
      ≤ 4 * ((k + 1).factorial : ℝ) * ((1 + |σ|) * (1 + |y|)) * 20 ^ k * (1 + 20) * 20 := by
        gcongr
    _ = Dc k * ((1 + |σ|) * (1 + |y|)) := by unfold Dc; ring

/-- **Target 1, the bounds.** `t^(k+1) ‖∂_tᵏ dY(σ+iy, t)‖ ≤ Dk k (1+|σ|)(1+|y|)^(k+2)` for
`t ≥ 1`, every `k`; `k = 0, 1` are `ApproxDeriv.dY_bound`, `d2Y_bound` up to the constant. -/
theorem dYk_bound {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (k : ℕ) {t : ℝ} (ht : 1 ≤ t) (y : ℝ) :
    t ^ (k + 1) * ‖dYk α β k t (σ + y * I)‖ ≤ Dk k * (1 + |σ|) * (1 + |y|) ^ (k + 2) := by
  have ht0 : 0 < t := by linarith
  have hh := norm_half_le σ y
  have hy0 := abs_nonneg y
  have hy1 : 1 ≤ 1 + |y| := by linarith
  have hσ1 : 0 ≤ 1 + |σ| := by positivity
  have hF : 0 ≤ ((k + 1).factorial : ℝ) := by positivity
  have hyk : (1 + |y|) ≤ (1 + |y|) ^ (k + 2) := le_self_pow₀ hy1 (by omega)
  rcases le_or_gt |y| (t / 2) with hy | hy
  · obtain ⟨i1, i2, i3, i4⟩ := im_conds hα hβ (σ := σ) ht hy
    have h := norm_dYk_le hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) (by positivity)
      i1 i2 i3 i4 k
    obtain ⟨k1, k2⟩ := b_facts ht
    have hn := norm_nonneg (((σ : ℂ) + y * I) / 2)
    have hb0 : 0 ≤ 1 / (1 / 20 + t / 5) := by positivity
    have k3 : (t * (1 / (1 / 20 + t / 5))) ^ (k + 1) ≤ 5 ^ (k + 1) :=
      pow_le_pow_left₀ (by positivity) k1 _
    have k4 : (5 : ℝ) ^ (k + 1) ≤ 40 ^ (k + 1) := pow_le_pow_left₀ (by norm_num) (by norm_num) _
    calc t ^ (k + 1) * ‖dYk α β k t (σ + y * I)‖
        ≤ t ^ (k + 1) * (4 * ((k + 1).factorial : ℝ) * ‖((σ : ℂ) + y * I) / 2‖ *
          (1 / (1 / 20 + t / 5)) ^ k * (1 + 1 / (1 / 20 + t / 5)) * (1 / (1 / 20 + t / 5))) :=
          mul_le_mul_of_nonneg_left h (by positivity)
      _ = 4 * ((k + 1).factorial : ℝ) * ‖((σ : ℂ) + y * I) / 2‖ * (1 + 1 / (1 / 20 + t / 5)) *
          (t * (1 / (1 / 20 + t / 5))) ^ (k + 1) := by ring
      _ ≤ 4 * ((k + 1).factorial : ℝ) * ((1 + |σ|) * (1 + |y|)) * 6 * 40 ^ (k + 1) := by
          gcongr
          linarith
      _ ≤ 84 * ((k + 1).factorial : ℝ) * 40 ^ (k + 1) * (1 + |σ|) * (1 + |y|) ^ (k + 2) := by
          have h40 : (0 : ℝ) ≤ 40 ^ (k + 1) := by positivity
          have e1 : 4 * ((k + 1).factorial : ℝ) * ((1 + |σ|) * (1 + |y|)) * 6 * 40 ^ (k + 1) =
              24 * (((k + 1).factorial : ℝ) * 40 ^ (k + 1) * (1 + |σ|)) * (1 + |y|) := by ring
          have e2 : 84 * ((k + 1).factorial : ℝ) * 40 ^ (k + 1) * (1 + |σ|) * (1 + |y|) ^ (k + 2) =
              84 * (((k + 1).factorial : ℝ) * 40 ^ (k + 1) * (1 + |σ|)) * (1 + |y|) ^ (k + 2) := by
            ring
          rw [e1, e2]
          have hP : 0 ≤ ((k + 1).factorial : ℝ) * 40 ^ (k + 1) * (1 + |σ|) := by positivity
          gcongr
          · norm_num
      _ = Dk k * (1 + |σ|) * (1 + |y|) ^ (k + 2) := by unfold Dk; ring
  · have h := dYk_crude hα hβ hσ0 k t y
    have htl : t ≤ 2 * (1 + |y|) := by linarith
    have htk : t ^ (k + 1) ≤ (2 * (1 + |y|)) ^ (k + 1) := pow_le_pow_left₀ ht0.le htl _
    calc t ^ (k + 1) * ‖dYk α β k t (σ + y * I)‖
        ≤ (2 * (1 + |y|)) ^ (k + 1) * (Dc k * ((1 + |σ|) * (1 + |y|))) :=
          mul_le_mul htk h (norm_nonneg _) (by positivity)
      _ = Dk k * (1 + |σ|) * (1 + |y|) ^ (k + 2) := by
          unfold Dc Dk
          rw [mul_pow, show (40 : ℝ) ^ (k + 1) = 2 ^ (k + 1) * 20 ^ (k + 1) by
            rw [← mul_pow]; norm_num]
          ring

/-- **Target 1.** For every `k`, `t^(k+1) ‖∂_tᵏ dY α β t (σ+iy)‖ ≤ Dk k (1+|σ|)(1+|y|)^(k+2)`,
uniformly in `‖α‖, ‖β‖ ≤ 1/10`, `σ ≥ −1/4`, `t ≥ 1`, with `∂_tᵏ` the iterated derivative of the
smooth map `t ↦ dY` (`dY_contDiff`). -/
theorem dY_iter_bound {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (k : ℕ) {t : ℝ} (ht : 1 ≤ t) (y : ℝ) :
    t ^ (k + 1) * ‖iteratedDeriv k (fun t => dY α β t (σ + y * I)) t‖ ≤
      Dk k * (1 + |σ|) * (1 + |y|) ^ (k + 2) := by
  rw [iteratedDeriv_dY hα hβ (by simpa using hσ0) k]
  exact dYk_bound hα hβ hσ0 k ht y

/-! ## Part 2a: Leibniz on `∂_t g = g·dY` -/

theorem pow_key {a q : ℝ} (ha : 1 ≤ a) (hq : 0 ≤ q) {i J : ℕ} (hi : i ≤ J) :
    (a * q) ^ i * a * q ^ (J - i + 1) ≤ (a * q) ^ (J + 1) := by
  have e : (a * q) ^ i * a * q ^ (J - i + 1) = a ^ (i + 1) * q ^ (J + 1) := by
    have : q ^ (J + 1) = q ^ i * q ^ (J - i + 1) := by rw [← pow_add]; congr 1; omega
    rw [mul_pow, this]
    ring
  rw [e, mul_pow]
  have ha0 : 0 ≤ a := by linarith
  exact mul_le_mul_of_nonneg_right (pow_le_pow_right₀ ha (by omega)) (by positivity)

/-- The algebra of the induction: if `H (j+1) = Σ C(j,i) H i d(j−i)` and
`‖d m‖ ≤ D m a q^(m+1)`, then `‖H i‖ ≤ ‖H 0‖-bound · M (aq)^i`, with `M` depending on `D`
and the order only. -/
theorem leib_bound (D : ℕ → ℝ) (hD : ∀ m, 0 ≤ D m) (J : ℕ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ (H d : ℕ → ℂ) (G a q : ℝ), 1 ≤ a → 0 ≤ q → ‖H 0‖ ≤ G →
      (∀ j, H (j + 1) = ∑ i ∈ Finset.range (j + 1), (j.choose i : ℂ) * H i * d (j - i)) →
      (∀ m, ‖d m‖ ≤ D m * a * q ^ (m + 1)) → ∀ i ≤ J, ‖H i‖ ≤ G * M * (a * q) ^ i := by
  induction J with
  | zero =>
    refine ⟨1, by norm_num, fun H d G a q ha hq h0 _ _ i hi => ?_⟩
    obtain rfl : i = 0 := by omega
    simpa using h0
  | succ J ih =>
    obtain ⟨M, hM0, hM⟩ := ih
    set S : ℝ := ∑ i ∈ Finset.range (J + 1), (J.choose i : ℝ) * D (J - i) with hS
    have hS0 : 0 ≤ S := Finset.sum_nonneg fun i _ => mul_nonneg (by positivity) (hD _)
    refine ⟨M * (1 + S), by positivity, fun H d G a q ha hq h0 hrec hd i hi => ?_⟩
    have hG : 0 ≤ G := (norm_nonneg _).trans h0
    have ha0 : 0 ≤ a := by linarith
    have hprev := hM H d G a q ha hq h0 hrec hd
    have hMS : M ≤ M * (1 + S) := by nlinarith
    rcases Nat.lt_or_ge i (J + 1) with hi' | hi'
    · refine (hprev i (by omega)).trans ?_
      have : 0 ≤ (a * q) ^ i := by positivity
      gcongr
    · obtain rfl : i = J + 1 := by omega
      rw [hrec J]
      refine (norm_sum_le _ _).trans ?_
      have hterm : ∀ i ∈ Finset.range (J + 1), ‖(J.choose i : ℂ) * H i * d (J - i)‖ ≤
          (J.choose i : ℝ) * D (J - i) * (G * M * (a * q) ^ (J + 1)) := by
        intro i hi
        have hiJ : i ≤ J := by simp at hi; omega
        have hc : ‖(J.choose i : ℂ)‖ = (J.choose i : ℝ) := by simp
        rw [norm_mul, norm_mul, hc]
        have h1 := hprev i hiJ
        have h2 := hd (J - i)
        have hk := pow_key ha hq hiJ
        have hC : (0 : ℝ) ≤ J.choose i := by positivity
        calc (J.choose i : ℝ) * ‖H i‖ * ‖d (J - i)‖
            ≤ (J.choose i : ℝ) * (G * M * (a * q) ^ i) * (D (J - i) * a * q ^ (J - i + 1)) := by
              gcongr
          _ = (J.choose i : ℝ) * D (J - i) * (G * M) * ((a * q) ^ i * a * q ^ (J - i + 1)) := by
              ring
          _ ≤ (J.choose i : ℝ) * D (J - i) * (G * M) * (a * q) ^ (J + 1) := by
              have : 0 ≤ (J.choose i : ℝ) * D (J - i) * (G * M) :=
                mul_nonneg (mul_nonneg hC (hD _)) (mul_nonneg hG hM0)
              exact mul_le_mul_of_nonneg_left hk this
          _ = _ := by ring
      refine (Finset.sum_le_sum hterm).trans ?_
      rw [← Finset.sum_mul, ← hS]
      have : 0 ≤ G * M * (a * q) ^ (J + 1) := by positivity
      calc S * (G * M * (a * q) ^ (J + 1)) ≤ (1 + S) * (G * M * (a * q) ^ (J + 1)) := by
            gcongr; linarith
        _ = G * (M * (1 + S)) * (a * q) ^ (J + 1) := by ring

/-- `t ↦ g(s,t)` is `Cⁿ` for every `n`, from `∂_t g = g·dY`. -/
theorem gY_contDiff {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (n : ℕ) : ContDiff ℝ n (fun t => gY α β t s) := by
  induction n with
  | zero =>
    exact contDiff_zero.mpr (continuous_iff_continuousAt.mpr fun t =>
      (gY_hasDerivAt hα hβ hs t).continuousAt)
  | succ n ih =>
    have e : ((n + 1 : ℕ) : ℕ∞ω) = (n : ℕ∞ω) + 1 := by push_cast; rfl
    rw [e, contDiff_succ_iff_deriv]
    refine ⟨fun t => (gY_hasDerivAt hα hβ hs t).differentiableAt, by simp, ?_⟩
    have hd : deriv (fun t => gY α β t s) = fun t => gY α β t s * dY α β t s :=
      funext fun t => (gY_hasDerivAt hα hβ hs t).deriv
    rw [hd]
    have h2 : ContDiff ℝ n (fun t => dY α β t s) := (dY_contDiff hα hβ hs).of_le
      (by exact_mod_cast le_top)
    exact ih.mul h2

theorem gY_contDiff_top {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) : ContDiff ℝ ∞ (fun t => gY α β t s) :=
  contDiff_infty.mpr fun n => gY_contDiff hα hβ hs n

/-- Leibniz: `∂_t^(j+1) g = Σ_{i ≤ j} C(j,i) ∂_tⁱ g · ∂_t^(j−i) dY`. -/
theorem gY_iter_succ {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (j : ℕ) (t : ℝ) :
    iteratedDeriv (j + 1) (fun t => gY α β t s) t = ∑ i ∈ Finset.range (j + 1),
      (j.choose i : ℂ) * iteratedDeriv i (fun t => gY α β t s) t * dYk α β (j - i) t s := by
  have hd : deriv (fun t => gY α β t s) = fun t => gY α β t s * dY α β t s :=
    funext fun t => (gY_hasDerivAt hα hβ hs t).deriv
  rw [iteratedDeriv_succ', hd]
  have h2 : ContDiff ℝ j (fun t => dY α β t s) := (dY_contDiff hα hβ hs).of_le
    (by exact_mod_cast le_top)
  rw [iteratedDeriv_fun_mul (gY_contDiff hα hβ hs j).contDiffAt h2.contDiffAt]
  simp only [iteratedDeriv_dY hα hβ hs]

/-- Crude: `‖∂_tʲ g‖ ≤ ‖g‖ R ((1+|σ|)(1+|y|))^j` at every real `t`. -/
theorem gY_iter_crude {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (j : ℕ) :
    ∃ R : ℝ, 0 ≤ R ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t y : ℝ,
      ‖iteratedDeriv j (fun t => gY α β t (σ + y * I)) t‖ ≤
        ‖gY α β t (σ + y * I)‖ * R * ((1 + |σ|) * (1 + |y|)) ^ j := by
  obtain ⟨M, hM0, hM⟩ := leib_bound Dc Dc_nonneg j
  refine ⟨M, hM0, fun α β hα hβ t y => ?_⟩
  have hs : -(1 / 4) ≤ ((σ : ℂ) + y * I).re := by simpa using hσ0
  have ha : 1 ≤ (1 + |σ|) * (1 + |y|) := by
    nlinarith [abs_nonneg σ, abs_nonneg y, mul_nonneg (abs_nonneg σ) (abs_nonneg y)]
  have h := hM (fun i => iteratedDeriv i (fun t => gY α β t (σ + y * I)) t)
    (fun m => dYk α β m t (σ + y * I)) ‖gY α β t (σ + y * I)‖ ((1 + |σ|) * (1 + |y|)) 1 ha
    zero_le_one (by simp) (fun i => gY_iter_succ hα hβ hs i t)
    (fun m => by rw [one_pow, mul_one]; exact dYk_crude hα hβ hσ0 m t y) j le_rfl
  simpa using h

/-- At `t ≥ 1`: `‖∂_tʲ g‖ ≤ ‖g‖ M ((1+|σ|)(1+|y|)²/t)^j`. -/
theorem gY_iter_bound {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (j : ℕ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ y : ℝ,
      ‖iteratedDeriv j (fun t => gY α β t (σ + y * I)) t‖ ≤
        ‖gY α β t (σ + y * I)‖ * M * ((1 + |σ|) * (1 + |y|) ^ 2 / t) ^ j := by
  obtain ⟨M, hM0, hM⟩ := leib_bound Dk Dk_nonneg j
  refine ⟨M, hM0, fun α β hα hβ t ht y => ?_⟩
  have ht0 : 0 < t := by linarith
  have hs : -(1 / 4) ≤ ((σ : ℂ) + y * I).re := by simpa using hσ0
  have ha : 1 ≤ (1 + |σ|) * (1 + |y|) := by
    nlinarith [abs_nonneg σ, abs_nonneg y, mul_nonneg (abs_nonneg σ) (abs_nonneg y)]
  have hdm : ∀ m, ‖dYk α β m t (σ + y * I)‖ ≤
      Dk m * ((1 + |σ|) * (1 + |y|)) * ((1 + |y|) / t) ^ (m + 1) := by
    intro m
    have h := dYk_bound hα hβ hσ0 m ht y
    have htm : 0 < t ^ (m + 1) := by positivity
    have e : Dk m * ((1 + |σ|) * (1 + |y|)) * ((1 + |y|) / t) ^ (m + 1) =
        Dk m * (1 + |σ|) * (1 + |y|) ^ (m + 2) / t ^ (m + 1) := by
      rw [div_pow]; ring
    rw [e, le_div_iff₀ htm]
    linarith
  have h := hM (fun i => iteratedDeriv i (fun t => gY α β t (σ + y * I)) t)
    (fun m => dYk α β m t (σ + y * I)) ‖gY α β t (σ + y * I)‖ ((1 + |σ|) * (1 + |y|))
    ((1 + |y|) / t) ha (by positivity) (by simp) (fun i => gY_iter_succ hα hβ hs i t) hdm j le_rfl
  have e : (1 + |σ|) * (1 + |y|) * ((1 + |y|) / t) = (1 + |σ|) * (1 + |y|) ^ 2 / t := by ring
  rw [e] at h
  exact h

/-! ## Part 2b: measurability in `y` -/

theorem cont_gY {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (t : ℝ) : Continuous fun y : ℝ => gY α β t (σ + y * I) := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have hre : ∀ y : ℝ, ((σ : ℂ) + y * I).re = σ := fun y => by simp
  have k1 : Continuous fun y : ℝ => Gammaℝ (uA α t + ((σ : ℂ) + y * I)) :=
    continuous_iff_continuousAt.mpr fun y => ContinuousAt.comp (g := Gammaℝ)
      (hasDerivAt_Gammaℝ (by rw [Complex.add_re, uA_re, hre]; linarith)).continuousAt
      (by fun_prop : Continuous fun y : ℝ => uA α t + ((σ : ℂ) + y * I)).continuousAt
  have k2 : Continuous fun y : ℝ => Gammaℝ (vB β t + ((σ : ℂ) + y * I)) :=
    continuous_iff_continuousAt.mpr fun y => ContinuousAt.comp (g := Gammaℝ)
      (hasDerivAt_Gammaℝ (by rw [Complex.add_re, vB_re, hre]; linarith)).continuousAt
      (by fun_prop : Continuous fun y : ℝ => vB β t + ((σ : ℂ) + y * I)).continuousAt
  unfold gY
  exact (k1.mul k2).div_const _

theorem cont_pre {α β : ℂ} {σ : ℝ} (hσ : σ ≠ 0) :
    Continuous fun y : ℝ => GY α β ((σ : ℂ) + y * I) / ((σ : ℂ) + y * I) := by
  have hs0 : ∀ y : ℝ, (σ : ℂ) + y * I ≠ 0 := fun y h => by
    have := congrArg Complex.re h
    simp at this
    exact hσ this
  have cG : Continuous fun y : ℝ => GY α β ((σ : ℂ) + y * I) := by unfold GY; fun_prop
  exact cG.div (by fun_prop) hs0

theorem cont_xpow {σ x : ℝ} (hx : 0 < x) :
    Continuous fun y : ℝ => (x : ℂ) ^ (-((σ : ℂ) + y * I)) := by
  have hx0 : (x : ℂ) ≠ 0 := by exact_mod_cast hx.ne'
  exact (by fun_prop : Continuous fun y : ℝ => -((σ : ℂ) + y * I)).const_cpow (Or.inl hx0)

theorem meas_dYk {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (k : ℕ) (t : ℝ) :
    AEStronglyMeasurable (fun y : ℝ => dYk α β k t (σ + y * I)) volume := by
  have hterm : ∀ n : ℕ, Continuous fun y : ℝ => dYterm α β k t ((σ : ℂ) + y * I) n := by
    intro n
    have q1 : ∀ y : ℝ, ((n : ℂ) + uA α t / 2 + ((σ : ℂ) + y * I) / 2) ^ (k + 1) ≠ 0 := fun y => by
      obtain ⟨_, r2, _, _⟩ := re_conds hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) t
      apply pow_ne_zero
      rw [add_assoc]
      exact nat_add_ne (by linarith) n
    have q2 : ∀ y : ℝ, ((n : ℂ) + vB β t / 2 + ((σ : ℂ) + y * I) / 2) ^ (k + 1) ≠ 0 := fun y => by
      obtain ⟨_, _, _, r4⟩ := re_conds hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) t
      apply pow_ne_zero
      rw [add_assoc]
      exact nat_add_ne (by linarith) n
    have c1 : Continuous fun y : ℝ => ((n : ℂ) + uA α t / 2 + ((σ : ℂ) + y * I) / 2) ^ (k + 1) := by
      fun_prop
    have c2 : Continuous fun y : ℝ => ((n : ℂ) + vB β t / 2 + ((σ : ℂ) + y * I) / 2) ^ (k + 1) := by
      fun_prop
    have t1 : Continuous fun y : ℝ => tauK k (((σ : ℂ) + y * I) / 2) (uA α t / 2) n := by
      unfold tauK
      exact continuous_const.mul (continuous_const.sub (c1.inv₀ q1))
    have t2 : Continuous fun y : ℝ => tauK k (((σ : ℂ) + y * I) / 2) (vB β t / 2) n := by
      unfold tauK
      exact continuous_const.mul (continuous_const.sub (c2.inv₀ q2))
    unfold dYterm
    exact continuous_const.mul ((continuous_const.mul t1).sub (continuous_const.mul t2))
  refine aestronglyMeasurable_of_tendsto_ae atTop
    (f := fun (N : ℕ) (y : ℝ) => ∑ n ∈ Finset.range N, dYterm α β k t ((σ : ℂ) + y * I) n)
    (fun N => (continuous_finsetSum _ fun n _ => hterm n).aestronglyMeasurable)
    (ae_of_all _ fun y => ?_)
  exact (summable_dYterm hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) k t).hasSum.tendsto_sum_nat

theorem meas_gY_iter {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (t : ℝ) (J : ℕ) : ∀ i ≤ J,
    AEStronglyMeasurable (fun y : ℝ => iteratedDeriv i (fun t => gY α β t (σ + y * I)) t) volume := by
  have hs : ∀ y : ℝ, -(1 / 4) ≤ ((σ : ℂ) + y * I).re := fun y => by simpa using hσ0
  induction J with
  | zero =>
    intro i hi
    obtain rfl : i = 0 := by omega
    simp only [iteratedDeriv_zero]
    exact (cont_gY hα hβ hσ0 t).aestronglyMeasurable
  | succ J ih =>
    intro i hi
    rcases Nat.lt_or_ge i (J + 1) with hi' | hi'
    · exact ih i (by omega)
    · obtain rfl : i = J + 1 := by omega
      have e : (fun y : ℝ => iteratedDeriv (J + 1) (fun t => gY α β t (σ + y * I)) t) =
          fun y : ℝ => ∑ i ∈ Finset.range (J + 1), (J.choose i : ℂ) *
            iteratedDeriv i (fun t => gY α β t (σ + y * I)) t * dYk α β (J - i) t (σ + y * I) :=
        funext fun y => gY_iter_succ hα hβ (hs y) J t
      rw [e]
      exact Finset.aestronglyMeasurable_fun_sum _ fun i hi =>
        (aestronglyMeasurable_const.mul (ih i (by simp at hi; omega))).mul
          (meas_dYk hα hβ hσ0 (J - i) t)

/-! ## Part 2c: the derivatives of `V` under the integral -/

/-- The integrand of `∂_tʲ V`: `G(s)/s · ∂_tʲ g(s,t) · x^(−s)`. -/
noncomputable
def IYk (α β : ℂ) (x : ℝ) (j : ℕ) (t : ℝ) (s : ℂ) : ℂ :=
  GY α β s / s * iteratedDeriv j (fun t => gY α β t s) t * (x : ℂ) ^ (-s)

/-- `∂_tʲ V`, read on the line `Re s = c`. -/
noncomputable
def VYk (α β : ℂ) (j : ℕ) (c x t : ℝ) : ℂ :=
  VerticalIntegral' (fun s => IYk α β x j t s) c

theorem VYk_zero (α β : ℂ) (c x t : ℝ) : VYk α β 0 c x t = VY α β c x t := by
  unfold VYk VY IYk KY
  simp only [iteratedDeriv_zero]

theorem IYk_hasDerivAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (x : ℝ) (j : ℕ) (t : ℝ) :
    HasDerivAt (fun t => IYk α β x j t s) (IYk α β x (j + 1) t s) t := by
  have hc := gY_contDiff_top hα hβ hs
  have hd : Differentiable ℝ (iteratedDeriv j (fun t => gY α β t s)) :=
    hc.differentiable_iteratedDeriv j (by exact_mod_cast ENat.coe_lt_top j)
  have h1 : HasDerivAt (iteratedDeriv j (fun t => gY α β t s))
      (iteratedDeriv (j + 1) (fun t => gY α β t s) t) t := by
    rw [iteratedDeriv_succ]
    exact (hd t).hasDerivAt
  exact (h1.const_mul (GY α β s / s)).mul_const ((x : ℂ) ^ (-s))

theorem norm_IYk_le {α β : ℂ} {x : ℝ} {j : ℕ} {t : ℝ} {s : ℂ} {B : ℝ}
    (h : ‖iteratedDeriv j (fun t => gY α β t s) t‖ ≤ ‖gY α β t s‖ * B) :
    ‖IYk α β x j t s‖ ≤ ‖KY α β t s * (x : ℂ) ^ (-s)‖ * B := by
  unfold IYk KY
  rw [norm_mul, norm_mul, norm_mul, norm_mul]
  calc ‖GY α β s / s‖ * ‖iteratedDeriv j (fun t => gY α β t s) t‖ * ‖(x : ℂ) ^ (-s)‖
      ≤ ‖GY α β s / s‖ * (‖gY α β t s‖ * B) * ‖(x : ℂ) ^ (-s)‖ := by gcongr
    _ = ‖GY α β s / s‖ * ‖gY α β t s‖ * ‖(x : ℂ) ^ (-s)‖ * B := by ring

theorem meas_IYk {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) {x : ℝ} (hx : 0 < x) (j : ℕ) (t : ℝ) :
    AEStronglyMeasurable (fun y : ℝ => IYk α β x j t (σ + y * I)) volume := by
  unfold IYk
  exact ((cont_pre hσ).aestronglyMeasurable.mul (meas_gY_iter hα hβ hσ0 t j j le_rfl)).mul
    (cont_xpow hx).aestronglyMeasurable

/-- Local domination: near any `t₀`, `‖IYk j‖ ≤ K e^(−y²/4)` on the line `σ`. -/
theorem IYk_local {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) {x : ℝ} (hx : 0 < x) (j : ℕ) (t₀ : ℝ) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ t ∈ Metric.closedBall t₀ 1, ∀ y : ℝ,
      ‖IYk α β x j t (σ + y * I)‖ ≤ K * Real.exp (-(1 / 4) * y ^ 2) := by
  obtain ⟨C, hC0, hC⟩ := KY_local hα hβ hσ0 hσ t₀
  obtain ⟨R, hR0, hR⟩ := gY_iter_crude hσ0 j
  have hx0 : 0 ≤ x ^ (-σ) := by positivity
  refine ⟨C * x ^ (-σ) * R * (1 + |σ|) ^ j * (((j + 2).factorial : ℝ) * Real.exp 2),
    by positivity, fun t ht y => ?_⟩
  have a1 := norm_F_local hx (hC t ht y)
  have a2 := norm_IYk_le (x := x) (B := R * ((1 + |σ|) * (1 + |y|)) ^ j)
    (by rw [← mul_assoc]; exact hR α β hα hβ t y)
  have a3 := gauss_loc j y
  calc ‖IYk α β x j t (σ + y * I)‖
      ≤ ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ *
          (R * ((1 + |σ|) * (1 + |y|)) ^ j) := a2
    _ ≤ C * x ^ (-σ) * (Real.exp (-y ^ 2) * (1 + y ^ 2)) * (R * ((1 + |σ|) * (1 + |y|)) ^ j) :=
        mul_le_mul_of_nonneg_right a1 (by positivity)
    _ = C * x ^ (-σ) * R * (1 + |σ|) ^ j * (Real.exp (-y ^ 2) * (1 + y ^ 2) * (1 + |y|) ^ j) := by
        rw [mul_pow]; ring
    _ ≤ C * x ^ (-σ) * R * (1 + |σ|) ^ j *
          (((j + 2).factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2)) := by gcongr
    _ = _ := by ring

/-- **Differentiability of `∂_tʲ V` in `t`**, every `j`, every real `t`, every line `σ ≥ −1/4`,
`σ ≠ 0`: `∂_t VYk j = VYk (j+1)`, the derivative under the integral. -/
theorem VYk_hasDerivAt {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ} (hx : 0 < x) (j : ℕ) (t₀ : ℝ) :
    HasDerivAt (fun t => VYk α β j σ x t) (VYk α β (j + 1) σ x t₀) t₀ := by
  obtain ⟨K, hK0, hK⟩ := IYk_local hα hβ hσ0 hσ hx (j + 1) t₀
  obtain ⟨K0, hK00, hK0⟩ := IYk_local hα hβ hσ0 hσ hx j t₀
  have hsre : ∀ y : ℝ, -(1 / 4) ≤ ((σ : ℂ) + y * I).re := fun y => by simpa using hσ0
  have hint : Integrable fun y : ℝ => K * Real.exp (-(1 / 4) * y ^ 2) :=
    (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul K
  have hFint : Integrable fun y : ℝ => IYk α β x j t₀ (σ + y * I) :=
    Integrable.mono' ((integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul K0)
      (meas_IYk hα hβ hσ0 hσ hx j t₀)
      (ae_of_all _ fun y => hK0 t₀ (Metric.mem_closedBall_self zero_le_one) y)
  have h := hasDerivAt_integral_of_dominated_loc_of_deriv_le (μ := volume)
    (F := fun t y => IYk α β x j t (σ + y * I))
    (F' := fun t y => IYk α β x (j + 1) t (σ + y * I))
    (x₀ := t₀) (bound := fun y => K * Real.exp (-(1 / 4) * y ^ 2))
    (Metric.ball_mem_nhds t₀ one_pos)
    (Eventually.of_forall fun t => meas_IYk hα hβ hσ0 hσ hx j t) hFint
    (meas_IYk hα hβ hσ0 hσ hx (j + 1) t₀)
    (ae_of_all _ fun y t ht => hK t (Metric.ball_subset_closedBall ht) y) hint
    (ae_of_all _ fun y t _ => IYk_hasDerivAt hα hβ (hsre y) x j t)
  have h3 := (h.2.const_mul I).const_mul (1 / (2 * (Real.pi : ℂ) * I))
  unfold VYk
  simp only [VerticalIntegral', VerticalIntegral, smul_eq_mul]
  exact h3

/-- The derivatives on one line `σ ≥ −1/4`, `σ ≠ 0`, `t ≥ 1`:
`‖tʲ VYk j‖ ≤ C (1 + ‖α+β‖^(−2)) (t/2π)^σ x^(−σ)`, every `j`. -/
theorem VYk_line_bound {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) (j : ℕ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x →
        ‖(t : ℂ) ^ j * VYk α β j σ x t‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) := by
  obtain ⟨C0, hC00, hC0⟩ := integrand_bound (σ₀ := σ) (σ₁ := σ) (δ := |σ|) (by linarith)
    (abs_pos.mpr hσ)
  obtain ⟨M, hM0, hM⟩ := gY_iter_bound hσ0 j
  set G : ℝ := Real.sqrt (Real.pi / (1 / 4)) with hG
  set C : ℝ := C0 * M * (1 + |σ|) ^ j * (((2 * j).factorial : ℝ) * Real.exp 2) * G /
    (2 * Real.pi) with hC
  have hC0' : 0 ≤ C := by positivity
  refine ⟨C, hC0', fun α β hα hβ t ht x hx => ?_⟩
  have ht0 : 0 < t := by linarith
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  set P : ℝ := (t / (2 * Real.pi)) ^ σ * x ^ (-σ) with hP
  have hN0 : 0 ≤ N := by positivity
  have hP0 : 0 ≤ P := by positivity
  have hK : ∀ y : ℝ, ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ ≤
      C0 * N * P * Real.exp (-(1 / 2) * y ^ 2) := fun y =>
    hC0 α β hα hβ t ht x hx σ y le_rfl le_rfl
      (by simpa using Complex.abs_re_le_norm ((σ : ℂ) + y * I))
  have htn : ‖(t : ℂ)‖ = t := by rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos ht0]
  set B : ℝ := C0 * N * P * M * (1 + |σ|) ^ j * (((2 * j).factorial : ℝ) * Real.exp 2) / t ^ j
    with hB
  have hb : ∀ y : ℝ, ‖IYk α β x j t (σ + y * I)‖ ≤ B * Real.exp (-(1 / 4) * y ^ 2) := by
    intro y
    have e : ((1 + |σ|) * (1 + |y|) ^ 2 / t) ^ j = (1 + |σ|) ^ j * (1 + |y|) ^ (2 * j) / t ^ j := by
      rw [div_pow, mul_pow, ← pow_mul]
    have a2 := norm_IYk_le (x := x) (B := M * ((1 + |σ|) ^ j * (1 + |y|) ^ (2 * j) / t ^ j))
      (by rw [← e, ← mul_assoc]; exact hM α β hα hβ t ht y)
    have a3 := poly_gauss (2 * j) y
    have hMj : 0 ≤ M * ((1 + |σ|) ^ j * (1 + |y|) ^ (2 * j) / t ^ j) := by positivity
    calc ‖IYk α β x j t (σ + y * I)‖
        ≤ ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ *
            (M * ((1 + |σ|) ^ j * (1 + |y|) ^ (2 * j) / t ^ j)) := a2
      _ ≤ (C0 * N * P * Real.exp (-(1 / 2) * y ^ 2)) *
            (M * ((1 + |σ|) ^ j * (1 + |y|) ^ (2 * j) / t ^ j)) :=
          mul_le_mul_of_nonneg_right (hK y) hMj
      _ = C0 * N * P * M * (1 + |σ|) ^ j / t ^ j *
            ((1 + |y|) ^ (2 * j) * Real.exp (-(1 / 2) * y ^ 2)) := by ring
      _ ≤ C0 * N * P * M * (1 + |σ|) ^ j / t ^ j *
            (((2 * j).factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2)) := by gcongr
      _ = B * Real.exp (-(1 / 4) * y ^ 2) := by rw [hB]; ring
  have hV := VI_gauss (f := fun s => IYk α β x j t s) (σ := σ) hb
  have hV' : ‖VYk α β j σ x t‖ ≤ 1 / (2 * Real.pi) * (B * G) := hV
  rw [norm_mul, norm_pow, htn]
  have htj : 0 < t ^ j := by positivity
  calc t ^ j * ‖VYk α β j σ x t‖ ≤ t ^ j * (1 / (2 * Real.pi) * (B * G)) :=
        mul_le_mul_of_nonneg_left hV' htj.le
    _ = C * N * P := by
        rw [hC, hB]
        field_simp
        try ring

/-- The derivatives do not depend on the line, and the residue `1` drops out: for `t ≥ 1` and
every `j`, `VYk (j+1) c = VYk (j+1) A = VYk (j+1) (−1/4)`. -/
theorem VYk_lines {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {x : ℝ} (hx : 0 < x) {c A : ℝ} (hc : 0 < c) (hA : 0 < A) (j : ℕ) :
    ∀ y : ℝ, 1 ≤ y → VYk α β (j + 1) c x y = VYk α β (j + 1) A x y ∧
      VYk α β (j + 1) c x y = VYk α β (j + 1) (-(1 / 4)) x y := by
  have hc' : -(1 / 4) ≤ c := by linarith
  have hA' : -(1 / 4) ≤ A := by linarith
  have hm : -(1 / 4) ≤ (-(1 / 4) : ℝ) := le_rfl
  have hm0 : (-(1 / 4) : ℝ) ≠ 0 := by norm_num
  induction j with
  | zero =>
    have eA : ∀ y : ℝ, 1 ≤ y → VY α β c x y = VY α β A x y := by
      intro y hy
      rcases le_total c A with h | h
      · exact VY_line_eq hc h hα hβ hy hx
      · exact (VY_line_eq hA h hα hβ hy hx).symm
    have em : ∀ y : ℝ, 1 ≤ y → VY α β c x y = 1 + VY α β (-(1 / 4)) x y := by
      intro y hy
      have hline : VY α β c x y = VY α β (1 / 4) x y := by
        rcases le_total c (1 / 4) with h | h
        · exact VY_line_eq hc h hα hβ hy hx
        · exact (VY_line_eq (by norm_num) h hα hβ hy hx).symm
      rw [hline]
      linear_combination VY_residue hα hβ hαβ hy hx
    have hV : ∀ σ : ℝ, -(1 / 4) ≤ σ → σ ≠ 0 → ∀ z : ℝ,
        HasDerivAt (fun t => VY α β σ x t) (VYk α β 1 σ x z) z := by
      intro σ h0 h1 z
      have h := VYk_hasDerivAt h0 h1 hα hβ hx 0 z
      simp only [VYk_zero] at h
      exact h
    intro y hy
    exact ⟨deriv_eq_of_eq_Ici (hV c hc' hc.ne' y) (hV A hA' hA.ne' y)
        (fun z hz => eA z (hy.trans hz)),
      deriv_eq_of_eq_Ici (hV c hc' hc.ne' y) ((hV _ hm hm0 y).const_add 1)
        (fun z hz => em z (hy.trans hz))⟩
  | succ j ih =>
    intro y hy
    exact ⟨deriv_eq_of_eq_Ici (VYk_hasDerivAt hc' hc.ne' hα hβ hx (j + 1) y)
        (VYk_hasDerivAt hA' hA.ne' hα hβ hx (j + 1) y) (fun z hz => (ih z (hy.trans hz)).1),
      deriv_eq_of_eq_Ici (VYk_hasDerivAt hc' hc.ne' hα hβ hx (j + 1) y)
        (VYk_hasDerivAt hm hm0 hα hβ hx (j + 1) y) (fun z hz => (ih z (hy.trans hz)).2)⟩

/-- `∂_tʲ V = VYk j` as functions, every `j`, on every line `c > 0`. -/
theorem iteratedDeriv_VY_all {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ}
    (hx : 0 < x) {c : ℝ} (hc : 0 < c) (j : ℕ) :
    iteratedDeriv j (fun t => VY α β c x t) = fun t => VYk α β j c x t := by
  have hc' : -(1 / 4) ≤ c := by linarith
  induction j with
  | zero =>
    rw [iteratedDeriv_zero]
    exact funext fun t => (VYk_zero α β c x t).symm
  | succ j ih =>
    rw [iteratedDeriv_succ, ih]
    exact funext fun t => (VYk_hasDerivAt hc' hc.ne' hα hβ hx j t).deriv

/-- **`t ↦ V_{α,β}(x,t)` is smooth**, on every line `c > 0`. -/
theorem VY_contDiff {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ}
    (hx : 0 < x) {c : ℝ} (hc : 0 < c) : ContDiff ℝ ∞ (fun t => VY α β c x t) := by
  have hc' : -(1 / 4) ≤ c := by linarith
  refine contDiff_of_differentiable_iteratedDeriv (n := ⊤) fun m _ => ?_
  rw [iteratedDeriv_VY_all hα hβ hx hc m]
  exact fun t => (VYk_hasDerivAt hc' hc.ne' hα hβ hx m t).differentiableAt

/-- **Young's (4.3) for every `j ≥ 1`.** For every `j ≥ 1` and `A > 0` there is `C` with
`‖t^j ∂_t^j V_{α,β}(x,t)‖ ≤ C (1 + ‖α+β‖^(−2)) (1 + x/t)^(−A)`, uniformly in
`‖α‖, ‖β‖ ≤ 1/10` with `α + β ≠ 0`, `t ≥ 1`, `x > 0`, and the line `c > 0` of `V`. -/
theorem VY_iter_bound {j : ℕ} (hj : 1 ≤ j) {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖(t : ℂ) ^ j * iteratedDeriv j (fun t => VY α β c x t) t‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A) := by
  obtain ⟨j', rfl⟩ : ∃ j', j = j' + 1 := ⟨j - 1, by omega⟩
  obtain ⟨Ca, hCa0, hCa⟩ := VYk_line_bound (σ := A) (by linarith) hA.ne' (j' + 1)
  obtain ⟨Cm, hCm0, hCm⟩ := VYk_line_bound (σ := -(1 / 4)) le_rfl (by norm_num) (j' + 1)
  refine ⟨8 * Cm * 2 ^ A + Ca * 2 ^ A, by positivity,
    fun α β hα hβ hαβ t ht x hx c hc => ?_⟩
  have hN : 0 ≤ 1 + 1 / ‖α + β‖ ^ 2 := by positivity
  rw [iteratedDeriv_VY_all hα hβ hx hc]
  beta_reduce
  obtain ⟨lA, lm⟩ := VYk_lines hα hβ hαβ hx hc hA j' t ht
  refine assemble hA hCa0 hCm0 hN ht hx (fun _ => ?_) (fun _ => ?_)
  · rw [lA]; exact hCa α β hα hβ t ht x hx
  · rw [lm]; exact hCm α β hα hβ t ht x hx

/-! ## Axiom pins -/

/-- info: 'ApproxDerivAll.ibp_iter_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ibp_iter_chain

/-- info: 'ApproxDerivAll.ibp_iter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ibp_iter

/-- info: 'ApproxDerivAll.hasDerivAt_tauK_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hasDerivAt_tauK_line

/-- info: 'ApproxDerivAll.norm_tauK_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_tauK_le

/-- info: 'ApproxDerivAll.dYk_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dYk_hasDerivAt

/-- info: 'ApproxDerivAll.dYk_contDiff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dYk_contDiff

/-- info: 'ApproxDerivAll.iteratedDeriv_dY' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iteratedDeriv_dY

/-- info: 'ApproxDerivAll.dY_contDiff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dY_contDiff

/-- info: 'ApproxDerivAll.dYk_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dYk_bound

/-- info: 'ApproxDerivAll.dY_iter_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dY_iter_bound

/-- info: 'ApproxDerivAll.leib_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms leib_bound

/-- info: 'ApproxDerivAll.gY_contDiff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gY_contDiff

/-- info: 'ApproxDerivAll.gY_iter_succ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gY_iter_succ

/-- info: 'ApproxDerivAll.gY_iter_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gY_iter_bound

/-- info: 'ApproxDerivAll.VYk_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VYk_hasDerivAt

/-- info: 'ApproxDerivAll.VYk_line_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VYk_line_bound

/-- info: 'ApproxDerivAll.VYk_lines' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VYk_lines

/-- info: 'ApproxDerivAll.iteratedDeriv_VY_all' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iteratedDeriv_VY_all

/-- info: 'ApproxDerivAll.VY_contDiff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_contDiff

/-- info: 'ApproxDerivAll.VY_iter_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_iter_bound

end ApproxDerivAll
