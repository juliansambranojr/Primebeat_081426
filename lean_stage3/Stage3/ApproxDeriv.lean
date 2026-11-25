/-
# ApproxDeriv — block S12 of `lean_stage3/design/stencil.md`, piece 2b-i, the derivatives of V. 2026-11-25.

Young's (4.3) (arXiv 1002.4403, Lemma 4's Remark) for `j = 1, 2`:
`t^j ∂_t^j V_{α,β}(x,t) ≪_{A,j} (1 + x/t)^(−A)`, the bounds Lemma 5's integration by parts in `t`
uses. Notation as in `ApproxFE` and `ApproxBounds`: `u = uA α t`, `v = vB β t`,
`V = VY α β c x t` on the line `Re s = c`, `N = 1 + ‖α+β‖^(−2)`.

The route. `∂_t g(s,t) = g·dY`, `dY = (i/2)[(ψ((u+s)/2) − ψ(u/2)) − (ψ((v+s)/2) − ψ(v/2))]`,
from `Gammaℝ' = Gammaℝ·ψℝ`, `ψℝ(w) = −(log π)/2 + ψ(w/2)/2` (`hasDerivAt_Gammaℝ`). The digamma
series (PNT+ `Complex.hasSum_digamma`) gives `ψ(w+h) − ψ(w) = Σ τₙ`, `τₙ = 1/(n+w) − 1/(n+w+h)`,
and `|n+w| ≥ (n + Re w + |Im w|)/2` with a telescoping majorant gives `‖dY‖ ≪ |s|/b`, where `b`
is `1/20` plus a lower bound for `|Im|` of the four points. In the bulk `|Im s| ≤ t/2` that
lower bound is `t/5`, so `t‖dY‖ ≪ |s|`; outside it `t < 2|Im s|`. The second derivative
differentiates the series termwise in `t` (`hasDerivAt_tsum`), `∂_t dY = d2Y`, with
`t²‖d2Y‖ ≪ (1+|Im s|)³`. The polynomial in `|Im s|` is absorbed by `e^(−y²/2)` of
`integrand_bound`. Differentiation under the integral
(`hasDerivAt_integral_of_dominated_loc_of_deriv_le`) is dominated locally in `t` by
`norm_Gammaℝ_le` for the numerator and compactness for `1/(Gammaℝ(u)Gammaℝ(v))`, so it holds at
every real `t`. The assembly is `VY_decay_young`'s: the line `A` for `x > t`, the line `−1/4`
for `x ≤ t`. The residue `1` there is constant in `t` and drops out of the derivatives
(`deriv_eq_of_eq_Ici`).

| statement | content | status |
|---|---|---|
| `hasDerivAt_Gammaℝ` | `Gammaℝ' w = Gammaℝ w · ψℝ(w)`, `Re w > 0` | proved |
| `gY_hasDerivAt` | `∂_t g(s,t) = g(s,t)·dY(s,t)`, every real `t`, `Re s ≥ −1/4` | proved |
| `hasSum_tau`, `dY_hasSum` | `ψ(w+h) − ψ(w) = Σ τₙ`; `dY` as a series | proved |
| `norm_dY_le`, `norm_d2Y_le` | `‖dY‖ ≤ 4‖s/2‖(1+1/b)/b`, `‖d2Y‖ ≤ 8‖s/2‖(1+1/b)/b²` | proved |
| `dY_hasDerivAt` | `∂_t dY = d2Y`, every real `t` | proved |
| `VY_hasDerivAt` | `∂_t V_σ(x,t) = VY1` (the derivative under the integral), every real `t`, `σ ≥ −1/4`, `σ ≠ 0` | proved |
| `VY1_hasDerivAt` | `∂_t VY1 = VY2`, same range | proved |
| `iteratedDeriv_VY` | `iteratedDeriv 1 V = VY1`, `iteratedDeriv 2 V = VY2`, line `c > 0` | proved |
| `dY_bound`, `d2Y_bound` | `t‖dY‖ ≤ 3360(1+|σ|)(1+|y|)²`, `t²‖d2Y‖ ≤ 268800(1+|σ|)(1+|y|)³`, `t ≥ 1` | proved |
| `VYj_line_bound` | `‖t VY1‖, ‖t² VY2‖ ≤ C N (t/2π)^σ x^(−σ)` on one line | proved |
| `VYj_lines` | `VYj c = VYj A = VYj (−1/4)` for `t ≥ 1`, `j = 1, 2` | proved |
| `VY_deriv_bound` | (4.3), `j = 1, 2`: `‖t^j ∂_t^j V‖ ≤ C N (1 + x/t)^(−A)`, every `A > 0` | proved |
| (4.3) for `j ≥ 3` | the general `j` | OPEN, not stated |

Differences from Young. (i) The direction is `(1 + x/t)^(−A)`, as in `VY_decay_young` (the
scratchpad text reads `(1 + |t/x|)^(−A)`; `ApproxBounds`' header gives the reason).
(ii) The constant carries `N = 1 + ‖α+β‖^(−2)`, the `1/(α+β)²` of `p(s)`; Young's `≪_{A,j}`
absorbs it under `|α+β| ≫ 1/L`. (iii) Uniform in `‖α‖, ‖β‖ ≤ 1/10`, `t ≥ 1`, `α + β ≠ 0`,
where Young has `α, β ≪ 1/L` and `t` large. (iv) `j = 1, 2` only; Young states every `j`.
(v) `V` is read on any line `c > 0`; Young's is `c = 1`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.ApproxBounds
import PrimeNumberTheoremAnd.Mathlib.Analysis.SpecialFunctions.Gamma.DigammaSeries

namespace ApproxDeriv

open Complex MeasureTheory Filter Topology ApproxFE ApproxBounds

/-! ## The log-derivative of `Gammaℝ` -/

/-- `ψℝ(w) = −(log π)/2 + ψ(w/2)/2`, the log-derivative of `Gammaℝ`. -/
noncomputable
def psiR (w : ℂ) : ℂ := -(Complex.log Real.pi) / 2 + digamma (w / 2) / 2

theorem ne_neg_nat_of_re_pos {z : ℂ} (hz : 0 < z.re) (m : ℕ) : z ≠ -(m : ℂ) := by
  intro h
  have := congrArg Complex.re h
  simp at this
  have : (0 : ℝ) ≤ m := m.cast_nonneg
  linarith

theorem hasDerivAt_Gammaℝ {w : ℂ} (hw : 0 < w.re) :
    HasDerivAt Gammaℝ (Gammaℝ w * psiR w) w := by
  have hw2 : 0 < (w / 2).re := by simp; linarith
  have hG : Gamma (w / 2) ≠ 0 := Complex.Gamma_ne_zero_of_re_pos hw2
  have hd : HasDerivAt Gamma (Gamma (w / 2) * digamma (w / 2)) (w / 2) := by
    have h := (Complex.differentiableAt_Gamma _ (ne_neg_nat_of_re_pos hw2)).hasDerivAt
    have e : deriv Gamma (w / 2) = Gamma (w / 2) * digamma (w / 2) := by
      rw [Complex.digamma_def, logDeriv_apply]
      field_simp
      try ring
    rwa [e] at h
  have h1 : HasDerivAt (fun s : ℂ => s / 2) (1 / 2) w := (hasDerivAt_id' w).div_const 2
  have hG2 : HasDerivAt (fun s : ℂ => Gamma (s / 2)) (Gamma (w / 2) * digamma (w / 2) * (1 / 2)) w :=
    hd.comp w h1
  have hP : HasDerivAt (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2))
      ((Real.pi : ℂ) ^ (-w / 2) * Complex.log Real.pi * (-1 / 2)) w := by
    have h2 : HasDerivAt (fun s : ℂ => -s / 2) (-1 / 2) w := (hasDerivAt_id' w).neg.div_const 2
    exact h2.const_cpow (Or.inl (ofReal_ne_zero.mpr Real.pi_ne_zero))
  have hprod := hP.mul hG2
  have he : Gammaℝ = fun s => (Real.pi : ℂ) ^ (-s / 2) * Gamma (s / 2) := by
    funext s
    exact Gammaℝ_def s
  have hfin : HasDerivAt Gammaℝ ((Real.pi : ℂ) ^ (-w / 2) * Complex.log Real.pi * (-1 / 2) *
      Gamma (w / 2) + (Real.pi : ℂ) ^ (-w / 2) * (Gamma (w / 2) * digamma (w / 2) * (1 / 2))) w := by
    rw [he]
    exact hprod
  refine hfin.congr_deriv ?_
  rw [Gammaℝ_def]
  unfold psiR
  ring

/-- A real line in `ℂ`: `t ↦ w₀ + t e` has derivative `e`. -/
theorem hasDerivAt_line (w₀ e : ℂ) (t : ℝ) : HasDerivAt (fun t : ℝ => w₀ + (t : ℂ) * e) e t := by
  have h := ((hasDerivAt_id' t).ofReal_comp.mul_const e).const_add w₀
  refine h.congr_deriv ?_
  simp

/-- `t ↦ Gammaℝ(f t)` for `f : ℝ → ℂ` with `Re f t > 0`. -/
theorem hasDerivAt_Gammaℝ_comp {f : ℝ → ℂ} {e : ℂ} {t : ℝ} (hf : HasDerivAt f e t)
    (hw : 0 < (f t).re) :
    HasDerivAt (fun t => Gammaℝ (f t)) (Gammaℝ (f t) * psiR (f t) * e) t :=
  (hasDerivAt_Gammaℝ hw).comp t hf

/-! ## The `t`-derivative of `g` -/

/-- The factor `∂_t log g(s,t)`:
`(i/2)·[(ψ((u+s)/2) − ψ(u/2)) − (ψ((v+s)/2) − ψ(v/2))]`. -/
noncomputable
def dY (α β : ℂ) (t : ℝ) (s : ℂ) : ℂ :=
  I / 2 * ((digamma ((uA α t + s) / 2) - digamma (uA α t / 2)) -
    (digamma ((vB β t + s) / 2) - digamma (vB β t / 2)))

theorem re_conds {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (t : ℝ) :
    1 / 20 ≤ (uA α t / 2).re ∧ 1 / 20 ≤ (uA α t / 2 + s / 2).re ∧
      1 / 20 ≤ (vB β t / 2).re ∧ 1 / 20 ≤ (vB β t / 2 + s / 2).re := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  simp only [Complex.add_re, Complex.div_re, uA_re, vB_re]
  norm_num
  refine ⟨by linarith, by linarith, by linarith, by linarith⟩

theorem gY_hasDerivAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (t : ℝ) :
    HasDerivAt (fun t => gY α β t s) (gY α β t s * dY α β t s) t := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have eA : (fun t : ℝ => uA α t + s) = fun t : ℝ => (1 / 2 + α + s) + (t : ℂ) * I := by
    funext t; unfold uA; ring
  have eB : (fun t : ℝ => vB β t + s) = fun t : ℝ => (1 / 2 + β + s) + (t : ℂ) * (-I) := by
    funext t; unfold vB; ring
  have eC : (fun t : ℝ => uA α t) = fun t : ℝ => (1 / 2 + α) + (t : ℂ) * I := by
    funext t; unfold uA; ring
  have eD : (fun t : ℝ => vB β t) = fun t : ℝ => (1 / 2 + β) + (t : ℂ) * (-I) := by
    funext t; unfold vB; ring
  have dA : HasDerivAt (fun t : ℝ => uA α t + s) I t := by rw [eA]; exact hasDerivAt_line _ _ t
  have dB : HasDerivAt (fun t : ℝ => vB β t + s) (-I) t := by rw [eB]; exact hasDerivAt_line _ _ t
  have dC : HasDerivAt (fun t : ℝ => uA α t) I t := by rw [eC]; exact hasDerivAt_line _ _ t
  have dD : HasDerivAt (fun t : ℝ => vB β t) (-I) t := by rw [eD]; exact hasDerivAt_line _ _ t
  have pA : 0 < (uA α t + s).re := by rw [Complex.add_re, uA_re]; linarith
  have pB : 0 < (vB β t + s).re := by rw [Complex.add_re, vB_re]; linarith
  have pC : 0 < (uA α t).re := by rw [uA_re]; linarith
  have pD : 0 < (vB β t).re := by rw [vB_re]; linarith
  have gA := hasDerivAt_Gammaℝ_comp dA pA
  have gB := hasDerivAt_Gammaℝ_comp dB pB
  have gC := hasDerivAt_Gammaℝ_comp dC pC
  have gD := hasDerivAt_Gammaℝ_comp dD pD
  have nC := Gammaℝ_ne_zero_of_re_pos pC
  have nD := Gammaℝ_ne_zero_of_re_pos pD
  have h := (gA.mul gB).div (gC.mul gD) (mul_ne_zero nC nD)
  show HasDerivAt (fun t => Gammaℝ (uA α t + s) * Gammaℝ (vB β t + s) /
    (Gammaℝ (uA α t) * Gammaℝ (vB β t))) _ t
  refine h.congr_deriv ?_
  simp only [Pi.mul_apply]
  unfold gY dY psiR
  generalize Gammaℝ (uA α t + s) = A
  generalize Gammaℝ (vB β t + s) = B
  generalize digamma ((uA α t + s) / 2) = a
  generalize digamma ((vB β t + s) / 2) = b
  generalize digamma (uA α t / 2) = c
  generalize digamma (vB β t / 2) = d
  generalize Gammaℝ (uA α t) = C at nC ⊢
  generalize Gammaℝ (vB β t) = D at nD ⊢
  field_simp
  try ring

/-! ## The digamma series -/

/-- The `n`-th term of `ψ(w+h) − ψ(w)`. -/
noncomputable
def tau (h w : ℂ) (n : ℕ) : ℂ := ((n : ℂ) + w)⁻¹ - ((n : ℂ) + w + h)⁻¹

/-- Its `w`-derivative. -/
noncomputable
def tau' (h w : ℂ) (n : ℕ) : ℂ := (((n : ℂ) + w + h) ^ 2)⁻¹ - (((n : ℂ) + w) ^ 2)⁻¹

theorem hasSum_tau {h w : ℂ} (hw : 0 < w.re) (hwh : 0 < (w + h).re) :
    HasSum (tau h w) (digamma (w + h) - digamma w) := by
  have h1 := Complex.hasSum_digamma (ne_neg_nat_of_re_pos hwh)
  have h2 := Complex.hasSum_digamma (ne_neg_nat_of_re_pos hw)
  have e : (fun n : ℕ => (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + (w + h))) -
      (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + w))) = tau h w := by
    funext n
    simp only [tau, one_div]
    rw [← add_assoc]
    ring
  have h3 := h1.sub h2
  rw [e] at h3
  have e2 : digamma (w + h) + (Real.eulerMascheroniConstant : ℂ) -
      (digamma w + (Real.eulerMascheroniConstant : ℂ)) = digamma (w + h) - digamma w := by ring
  rwa [e2] at h3

theorem norm_nat_add_ge {z : ℂ} {a Y : ℝ} (hre : a ≤ z.re) (him : Y ≤ |z.im|) (n : ℕ) :
    ((n : ℝ) + a + Y) / 2 ≤ ‖(n : ℂ) + z‖ := by
  have h1 : (n : ℝ) + a ≤ ‖(n : ℂ) + z‖ := by
    have := Complex.re_le_norm ((n : ℂ) + z)
    simp at this
    linarith
  have h2 : Y ≤ ‖(n : ℂ) + z‖ := by
    have := Complex.abs_im_le_norm ((n : ℂ) + z)
    simp at this
    linarith
  linarith

/-- `‖τₙ‖ ≤ 4‖h‖/(n+a+Y)²` when `Re w, Re(w+h) ≥ a > 0` and `|Im w|, |Im(w+h)| ≥ Y ≥ 0`. -/
theorem norm_tau_le {h w : ℂ} {a Y : ℝ} (ha : 0 < a) (hY : 0 ≤ Y) (h1 : a ≤ w.re)
    (h2 : a ≤ (w + h).re) (h3 : Y ≤ |w.im|) (h4 : Y ≤ |(w + h).im|) (n : ℕ) :
    ‖tau h w n‖ ≤ 4 * ‖h‖ * (1 / ((n : ℝ) + (a + Y)) ^ 2) := by
  set r : ℝ := (n : ℝ) + (a + Y) with hr
  have hr0 : 0 < r := by positivity
  have hp := norm_nat_add_ge h1 h3 n
  have hq := norm_nat_add_ge h2 h4 n
  rw [← add_assoc] at hq
  have hp' : r / 2 ≤ ‖(n : ℂ) + w‖ := by rw [hr]; linarith
  have hq' : r / 2 ≤ ‖(n : ℂ) + w + h‖ := by rw [hr]; linarith
  have hp0 : (n : ℂ) + w ≠ 0 := norm_pos_iff.mp (by linarith)
  have hq0 : (n : ℂ) + w + h ≠ 0 := norm_pos_iff.mp (by linarith)
  have e : tau h w n = h / (((n : ℂ) + w) * ((n : ℂ) + w + h)) := by
    unfold tau
    field_simp
    try ring
  rw [e, norm_div, norm_mul]
  have hpq : r ^ 2 / 4 ≤ ‖(n : ℂ) + w‖ * ‖(n : ℂ) + w + h‖ := by
    have := mul_le_mul hp' hq' (by positivity) (norm_nonneg _)
    nlinarith
  calc ‖h‖ / (‖(n : ℂ) + w‖ * ‖(n : ℂ) + w + h‖) ≤ ‖h‖ / (r ^ 2 / 4) :=
        div_le_div_of_nonneg_left (norm_nonneg _) (by positivity) hpq
    _ = 4 * ‖h‖ * (1 / r ^ 2) := by field_simp; try ring

/-- `‖τ'ₙ‖ ≤ 16‖h‖/(a+Y) · 1/(n+a+Y)²` under the same conditions. -/
theorem norm_tau'_le {h w : ℂ} {a Y : ℝ} (ha : 0 < a) (hY : 0 ≤ Y) (h1 : a ≤ w.re)
    (h2 : a ≤ (w + h).re) (h3 : Y ≤ |w.im|) (h4 : Y ≤ |(w + h).im|) (n : ℕ) :
    ‖tau' h w n‖ ≤ 16 * ‖h‖ / (a + Y) * (1 / ((n : ℝ) + (a + Y)) ^ 2) := by
  set r : ℝ := (n : ℝ) + (a + Y) with hr
  set b : ℝ := a + Y with hb
  have hb0 : 0 < b := by positivity
  have hr0 : 0 < r := by positivity
  have hrb : b ≤ r := by rw [hr]; have := n.cast_nonneg (α := ℝ); linarith
  have hp := norm_nat_add_ge h1 h3 n
  have hq := norm_nat_add_ge h2 h4 n
  rw [← add_assoc] at hq
  set P : ℝ := ‖(n : ℂ) + w‖ with hP
  set Q : ℝ := ‖(n : ℂ) + w + h‖ with hQ
  have hp' : r / 2 ≤ P := by rw [hr]; linarith
  have hq' : r / 2 ≤ Q := by rw [hr]; linarith
  have hP0 : 0 < P := by linarith
  have hQ0 : 0 < Q := by linarith
  have hp0 : (n : ℂ) + w ≠ 0 := norm_pos_iff.mp hP0
  have hq0 : (n : ℂ) + w + h ≠ 0 := norm_pos_iff.mp hQ0
  have e : tau' h w n = -(h * (((n : ℂ) + w) + ((n : ℂ) + w + h))) /
      (((n : ℂ) + w) ^ 2 * ((n : ℂ) + w + h) ^ 2) := by
    unfold tau'
    field_simp
    try ring
  have hsum : ‖((n : ℂ) + w) + ((n : ℂ) + w + h)‖ ≤ P + Q := norm_add_le _ _
  have hden : 0 < P ^ 2 * Q ^ 2 := by positivity
  rw [e, norm_div, norm_neg, norm_mul, norm_mul, norm_pow, norm_pow, ← hP, ← hQ]
  have k1 : r ^ 3 ≤ 8 * (P * Q ^ 2) := by
    have a1 := mul_le_mul hp' hq' (by positivity) hP0.le
    have a2 := mul_le_mul a1 hq' (by positivity) (by positivity)
    nlinarith
  have k2 : r ^ 3 ≤ 8 * (P ^ 2 * Q) := by
    have a1 := mul_le_mul hp' hp' (by positivity) hP0.le
    have a2 := mul_le_mul a1 hq' (by positivity) (by positivity)
    nlinarith
  have key : (P + Q) * r ^ 3 ≤ 16 * (P ^ 2 * Q ^ 2) := by
    have e1 : P * r ^ 3 ≤ P * (8 * (P * Q ^ 2)) := mul_le_mul_of_nonneg_left k1 hP0.le
    have e2 : Q * r ^ 3 ≤ Q * (8 * (P ^ 2 * Q)) := mul_le_mul_of_nonneg_left k2 hQ0.le
    nlinarith
  have hh := norm_nonneg h
  rw [div_le_iff₀ hden]
  have key2 : ‖h‖ * (P + Q) * (b * r ^ 2) ≤ 16 * ‖h‖ * (P ^ 2 * Q ^ 2) := by
    have : (P + Q) * (b * r ^ 2) ≤ (P + Q) * r ^ 3 := by
      have : b * r ^ 2 ≤ r * r ^ 2 := mul_le_mul_of_nonneg_right hrb (by positivity)
      nlinarith [mul_le_mul_of_nonneg_left this (by positivity : (0 : ℝ) ≤ P + Q)]
    nlinarith [mul_le_mul_of_nonneg_left (this.trans key) hh]
  have hfin : 16 * ‖h‖ / b * (1 / r ^ 2) * (P ^ 2 * Q ^ 2) =
      16 * ‖h‖ * (P ^ 2 * Q ^ 2) / (b * r ^ 2) := by
    field_simp
    try ring
  rw [hfin, le_div_iff₀ (by positivity)]
  calc ‖h‖ * ‖((n : ℂ) + w) + ((n : ℂ) + w + h)‖ * (b * r ^ 2)
      ≤ ‖h‖ * (P + Q) * (b * r ^ 2) := by gcongr
    _ ≤ 16 * ‖h‖ * (P ^ 2 * Q ^ 2) := key2

/-- The telescoping majorant `1/(n+b) − 1/(n+1+b)`. -/
noncomputable
def tel (b : ℝ) (n : ℕ) : ℝ := 1 / ((n : ℝ) + b) - 1 / (((n + 1 : ℕ) : ℝ) + b)

theorem hasSum_tel {b : ℝ} (hb : 0 < b) : HasSum (tel b) (1 / b) := by
  have hnn : ∀ n : ℕ, 0 ≤ tel b n := fun n => by
    unfold tel
    have h1 : 0 < (n : ℝ) + b := by positivity
    have h2 : (n : ℝ) + b ≤ ((n + 1 : ℕ) : ℝ) + b := by push_cast; linarith
    have := one_div_le_one_div_of_le h1 h2
    linarith
  rw [hasSum_iff_tendsto_nat_of_nonneg hnn]
  have hpart : ∀ N : ℕ, ∑ i ∈ Finset.range N, tel b i = 1 / b - 1 / ((N : ℝ) + b) := by
    intro N
    have := Finset.sum_range_sub' (fun n : ℕ => 1 / ((n : ℝ) + b)) N
    simp only [tel]
    rw [this]
    simp
  simp only [hpart]
  have hlim : Tendsto (fun N : ℕ => 1 / ((N : ℝ) + b)) atTop (𝓝 0) :=
    tendsto_const_nhds.div_atTop (tendsto_atTop_add_const_right _ b tendsto_natCast_atTop_atTop)
  simpa using (tendsto_const_nhds (x := 1 / b)).sub hlim

theorem sq_le_tel {b : ℝ} (hb : 0 < b) (n : ℕ) :
    1 / ((n : ℝ) + b) ^ 2 ≤ (1 + 1 / b) * tel b n := by
  have h1 : 0 < (n : ℝ) + b := by positivity
  have e : tel b n = 1 / (((n : ℝ) + b) * ((n : ℝ) + b + 1)) := by
    unfold tel
    push_cast
    field_simp
    try ring
  rw [e]
  have key : (1 + 1 / b) * (1 / (((n : ℝ) + b) * ((n : ℝ) + b + 1))) - 1 / ((n : ℝ) + b) ^ 2 =
      (n : ℝ) / (b * ((n : ℝ) + b) ^ 2 * ((n : ℝ) + b + 1)) := by
    field_simp
    try ring
  have : 0 ≤ (n : ℝ) / (b * ((n : ℝ) + b) ^ 2 * ((n : ℝ) + b + 1)) := by positivity
  linarith

/-! ## `dY` and `d2Y` through the series -/

theorem nat_add_ne {z : ℂ} (hz : 0 < z.re) (n : ℕ) : (n : ℂ) + z ≠ 0 := by
  intro h
  have := congrArg Complex.re h
  simp at this
  have : (0 : ℝ) ≤ n := n.cast_nonneg
  linarith

theorem dY_hasSum {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (t : ℝ) :
    HasSum (fun n => I / 2 * (tau (s / 2) (uA α t / 2) n - tau (s / 2) (vB β t / 2) n))
      (dY α β t s) := by
  obtain ⟨r1, r2, r3, r4⟩ := re_conds hα hβ hs t
  have h1 := hasSum_tau (h := s / 2) (w := uA α t / 2) (by linarith) (by linarith)
  have h2 := hasSum_tau (h := s / 2) (w := vB β t / 2) (by linarith) (by linarith)
  have eu : uA α t / 2 + s / 2 = (uA α t + s) / 2 := by ring
  have ev : vB β t / 2 + s / 2 = (vB β t + s) / 2 := by ring
  rw [eu] at h1
  rw [ev] at h2
  exact (h1.sub h2).mul_left (I / 2)

theorem norm_I_half : ‖I / 2‖ = 1 / 2 := by
  rw [norm_div, Complex.norm_I]
  norm_num

/-- The term bound for `dY`. -/
theorem norm_dterm_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) {Y : ℝ} (hY : 0 ≤ Y)
    (i1 : Y ≤ |(uA α t / 2).im|) (i2 : Y ≤ |(uA α t / 2 + s / 2).im|)
    (i3 : Y ≤ |(vB β t / 2).im|) (i4 : Y ≤ |(vB β t / 2 + s / 2).im|) (n : ℕ) :
    ‖I / 2 * (tau (s / 2) (uA α t / 2) n - tau (s / 2) (vB β t / 2) n)‖ ≤
      4 * ‖s / 2‖ * (1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n := by
  obtain ⟨r1, r2, r3, r4⟩ := re_conds hα hβ hs t
  have hb : 0 < 1 / 20 + Y := by positivity
  have a1 := norm_tau_le (by norm_num : (0 : ℝ) < 1 / 20) hY r1 r2 i1 i2 n
  have a2 := norm_tau_le (by norm_num : (0 : ℝ) < 1 / 20) hY r3 r4 i3 i4 n
  have a3 := sq_le_tel hb n
  have hh := norm_nonneg (s / 2)
  calc ‖I / 2 * (tau (s / 2) (uA α t / 2) n - tau (s / 2) (vB β t / 2) n)‖
      = 1 / 2 * ‖tau (s / 2) (uA α t / 2) n - tau (s / 2) (vB β t / 2) n‖ := by
        rw [norm_mul, norm_I_half]
    _ ≤ 1 / 2 * (‖tau (s / 2) (uA α t / 2) n‖ + ‖tau (s / 2) (vB β t / 2) n‖) := by
        gcongr
        exact norm_sub_le _ _
    _ ≤ 1 / 2 * (4 * ‖s / 2‖ * (1 / ((n : ℝ) + (1 / 20 + Y)) ^ 2) +
          4 * ‖s / 2‖ * (1 / ((n : ℝ) + (1 / 20 + Y)) ^ 2)) := by gcongr
    _ = 4 * ‖s / 2‖ * (1 / ((n : ℝ) + (1 / 20 + Y)) ^ 2) := by ring
    _ ≤ 4 * ‖s / 2‖ * ((1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n) := by gcongr
    _ = 4 * ‖s / 2‖ * (1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n := by ring

/-- `‖dY‖ ≤ 4‖s/2‖ (1 + 1/b)/b`, `b = 1/20 + Y`, `Y` a lower bound for the four imaginary parts. -/
theorem norm_dY_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) {Y : ℝ} (hY : 0 ≤ Y)
    (i1 : Y ≤ |(uA α t / 2).im|) (i2 : Y ≤ |(uA α t / 2 + s / 2).im|)
    (i3 : Y ≤ |(vB β t / 2).im|) (i4 : Y ≤ |(vB β t / 2 + s / 2).im|) :
    ‖dY α β t s‖ ≤ 4 * ‖s / 2‖ * (1 + 1 / (1 / 20 + Y)) * (1 / (1 / 20 + Y)) := by
  have hb : 0 < 1 / 20 + Y := by positivity
  exact (dY_hasSum hα hβ hs t).norm_le_of_bounded
    ((hasSum_tel hb).mul_left (4 * ‖s / 2‖ * (1 + 1 / (1 / 20 + Y))))
    (norm_dterm_le hα hβ hs hY i1 i2 i3 i4)

/-- The factor of `∂_t² g / g` beyond `dY²`: `∂_t dY = −(1/4)·Σ (τ'ₙ(u/2) + τ'ₙ(v/2))`. -/
noncomputable
def d2Y (α β : ℂ) (t : ℝ) (s : ℂ) : ℂ :=
  ∑' n : ℕ, -(1 / 4) * (tau' (s / 2) (uA α t / 2) n + tau' (s / 2) (vB β t / 2) n)

theorem norm_d2term_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) {Y : ℝ} (hY : 0 ≤ Y)
    (i1 : Y ≤ |(uA α t / 2).im|) (i2 : Y ≤ |(uA α t / 2 + s / 2).im|)
    (i3 : Y ≤ |(vB β t / 2).im|) (i4 : Y ≤ |(vB β t / 2 + s / 2).im|) (n : ℕ) :
    ‖-(1 / 4) * (tau' (s / 2) (uA α t / 2) n + tau' (s / 2) (vB β t / 2) n)‖ ≤
      8 * ‖s / 2‖ / (1 / 20 + Y) * (1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n := by
  obtain ⟨r1, r2, r3, r4⟩ := re_conds hα hβ hs t
  have hb : 0 < 1 / 20 + Y := by positivity
  have a1 := norm_tau'_le (by norm_num : (0 : ℝ) < 1 / 20) hY r1 r2 i1 i2 n
  have a2 := norm_tau'_le (by norm_num : (0 : ℝ) < 1 / 20) hY r3 r4 i3 i4 n
  have a3 := sq_le_tel hb n
  have hh := norm_nonneg (s / 2)
  have hq : ‖(-(1 / 4) : ℂ)‖ = 1 / 4 := by norm_num
  have hc : 0 ≤ 16 * ‖s / 2‖ / (1 / 20 + Y) := by positivity
  calc ‖-(1 / 4) * (tau' (s / 2) (uA α t / 2) n + tau' (s / 2) (vB β t / 2) n)‖
      = 1 / 4 * ‖tau' (s / 2) (uA α t / 2) n + tau' (s / 2) (vB β t / 2) n‖ := by
        rw [norm_mul, hq]
    _ ≤ 1 / 4 * (‖tau' (s / 2) (uA α t / 2) n‖ + ‖tau' (s / 2) (vB β t / 2) n‖) := by
        gcongr
        exact norm_add_le _ _
    _ ≤ 1 / 4 * (16 * ‖s / 2‖ / (1 / 20 + Y) * (1 / ((n : ℝ) + (1 / 20 + Y)) ^ 2) +
          16 * ‖s / 2‖ / (1 / 20 + Y) * (1 / ((n : ℝ) + (1 / 20 + Y)) ^ 2)) := by gcongr
    _ = 8 * ‖s / 2‖ / (1 / 20 + Y) * (1 / ((n : ℝ) + (1 / 20 + Y)) ^ 2) := by ring
    _ ≤ 8 * ‖s / 2‖ / (1 / 20 + Y) * ((1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n) := by
        gcongr
    _ = 8 * ‖s / 2‖ / (1 / 20 + Y) * (1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n := by ring

theorem summable_d2term {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (t : ℝ) :
    Summable fun n => -(1 / 4) * (tau' (s / 2) (uA α t / 2) n + tau' (s / 2) (vB β t / 2) n) :=
  Summable.of_norm_bounded (((hasSum_tel (by norm_num : (0 : ℝ) < 1 / 20 + 0)).summable).mul_left
    (8 * ‖s / 2‖ / (1 / 20 + 0) * (1 + 1 / (1 / 20 + 0))))
    (norm_d2term_le hα hβ hs le_rfl (abs_nonneg _) (abs_nonneg _) (abs_nonneg _) (abs_nonneg _))

/-- `‖d2Y‖ ≤ 8‖s/2‖/b · (1 + 1/b)/b`. -/
theorem norm_d2Y_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) {Y : ℝ} (hY : 0 ≤ Y)
    (i1 : Y ≤ |(uA α t / 2).im|) (i2 : Y ≤ |(uA α t / 2 + s / 2).im|)
    (i3 : Y ≤ |(vB β t / 2).im|) (i4 : Y ≤ |(vB β t / 2 + s / 2).im|) :
    ‖d2Y α β t s‖ ≤ 8 * ‖s / 2‖ / (1 / 20 + Y) * (1 + 1 / (1 / 20 + Y)) * (1 / (1 / 20 + Y)) := by
  have hb : 0 < 1 / 20 + Y := by positivity
  exact tsum_of_norm_bounded
    ((hasSum_tel hb).mul_left (8 * ‖s / 2‖ / (1 / 20 + Y) * (1 + 1 / (1 / 20 + Y))))
    (norm_d2term_le hα hβ hs hY i1 i2 i3 i4)

theorem hasDerivAt_tau_line (h w₀ e : ℂ) (n : ℕ) (t : ℝ) (hp : (n : ℂ) + (w₀ + t * e) ≠ 0)
    (hq : (n : ℂ) + (w₀ + t * e) + h ≠ 0) :
    HasDerivAt (fun t : ℝ => tau h (w₀ + t * e) n) (e * tau' h (w₀ + t * e) n) t := by
  have h1 : HasDerivAt (fun t : ℝ => (n : ℂ) + (w₀ + t * e)) e t :=
    (hasDerivAt_line w₀ e t).const_add _
  have h2 : HasDerivAt (fun t : ℝ => (n : ℂ) + (w₀ + t * e) + h) e t := h1.add_const h
  have h3 := (h1.fun_inv hp).sub (h2.fun_inv hq)
  unfold tau
  refine h3.congr_deriv ?_
  unfold tau'
  field_simp
  try ring

/-- `∂_t dY = d2Y`, for every real `t`. -/
theorem dY_hasDerivAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (t : ℝ) :
    HasDerivAt (fun t => dY α β t s) (d2Y α β t s) t := by
  have eu : ∀ t : ℝ, uA α t / 2 = (1 / 2 + α) / 2 + (t : ℂ) * (I / 2) := fun t => by
    unfold uA; ring
  have ev : ∀ t : ℝ, vB β t / 2 = (1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2)) := fun t => by
    unfold vB; ring
  have hfun : (fun t => dY α β t s) = fun t : ℝ => ∑' n : ℕ, I / 2 *
      (tau (s / 2) ((1 / 2 + α) / 2 + (t : ℂ) * (I / 2)) n -
        tau (s / 2) ((1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2))) n) := by
    funext t
    rw [← (dY_hasSum hα hβ hs t).tsum_eq]
    simp only [eu, ev]
  have hval : d2Y α β t s = ∑' n : ℕ, -(1 / 4) *
      (tau' (s / 2) ((1 / 2 + α) / 2 + (t : ℂ) * (I / 2)) n +
        tau' (s / 2) ((1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2))) n) := by
    simp only [d2Y, eu, ev]
  rw [hfun, hval]
  have hb : (0 : ℝ) < 1 / 20 + 0 := by norm_num
  refine hasDerivAt_tsum (𝕜 := ℝ) (F := ℂ)
    (g := fun (n : ℕ) (t : ℝ) => I / 2 * (tau (s / 2) ((1 / 2 + α) / 2 + (t : ℂ) * (I / 2)) n -
        tau (s / 2) ((1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2))) n))
    (g' := fun (n : ℕ) (t : ℝ) => -(1 / 4) * (tau' (s / 2) ((1 / 2 + α) / 2 + (t : ℂ) * (I / 2)) n +
        tau' (s / 2) ((1 / 2 + β) / 2 + (t : ℂ) * (-(I / 2))) n))
    (u := fun n => 8 * ‖s / 2‖ / (1 / 20 + 0) * (1 + 1 / (1 / 20 + 0)) *
      tel (1 / 20 + 0) n)
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
    have d1 := hasDerivAt_tau_line (s / 2) _ _ n y p1 p2
    have d2 := hasDerivAt_tau_line (s / 2) _ _ n y p3 p4
    refine ((d1.sub d2).const_mul (I / 2)).congr_deriv ?_
    linear_combination (tau' (s / 2) ((1 / 2 + α) / 2 + (y : ℂ) * (I / 2)) n +
      tau' (s / 2) ((1 / 2 + β) / 2 + (y : ℂ) * (-(I / 2))) n) / 4 * Complex.I_sq
  · intro n y
    have h := norm_d2term_le hα hβ hs le_rfl (abs_nonneg _) (abs_nonneg _) (abs_nonneg _)
      (abs_nonneg _) n (t := y)
    simp only [eu, ev] at h
    exact h
  · have h := (dY_hasSum hα hβ hs t).summable
    simp only [eu, ev] at h
    exact h

/-! ## Gaussian absorption -/

/-- `(1+|y|)^k e^(−y²/2) ≤ k! e² e^(−y²/4)`. -/
theorem poly_gauss (k : ℕ) (y : ℝ) :
    (1 + |y|) ^ k * Real.exp (-(1 / 2) * y ^ 2) ≤
      (k.factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2) := by
  have hk : (0 : ℝ) < k.factorial := by exact_mod_cast k.factorial_pos
  have h1 := Real.pow_div_factorial_le_exp (1 + |y|) (by positivity) k
  rw [div_le_iff₀ hk] at h1
  have h2 : Real.exp (1 + |y|) * Real.exp (-(1 / 2) * y ^ 2) ≤
      Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2) := by
    rw [← Real.exp_add, ← Real.exp_add]
    apply Real.exp_le_exp.mpr
    nlinarith [sq_abs y, sq_nonneg (|y| / 2 - 1)]
  calc (1 + |y|) ^ k * Real.exp (-(1 / 2) * y ^ 2)
      ≤ (Real.exp (1 + |y|) * k.factorial) * Real.exp (-(1 / 2) * y ^ 2) :=
        mul_le_mul_of_nonneg_right h1 (Real.exp_pos _).le
    _ = k.factorial * (Real.exp (1 + |y|) * Real.exp (-(1 / 2) * y ^ 2)) := by ring
    _ ≤ k.factorial * (Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2)) := by gcongr
    _ = (k.factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2) := by ring

/-- `e^(−y²)(1+y²)(1+|y|)^k ≤ (k+2)! e² e^(−y²/4)`. -/
theorem gauss_loc (k : ℕ) (y : ℝ) :
    Real.exp (-y ^ 2) * (1 + y ^ 2) * (1 + |y|) ^ k ≤
      ((k + 2).factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2) := by
  have h1 : Real.exp (-y ^ 2) ≤ Real.exp (-(1 / 2) * y ^ 2) :=
    Real.exp_le_exp.mpr (by nlinarith [sq_nonneg y])
  have h2 : 1 + y ^ 2 ≤ (1 + |y|) ^ 2 := by nlinarith [sq_abs y, abs_nonneg y]
  calc Real.exp (-y ^ 2) * (1 + y ^ 2) * (1 + |y|) ^ k
      ≤ Real.exp (-(1 / 2) * y ^ 2) * (1 + |y|) ^ 2 * (1 + |y|) ^ k := by gcongr
    _ = (1 + |y|) ^ (k + 2) * Real.exp (-(1 / 2) * y ^ 2) := by ring
    _ ≤ _ := poly_gauss (k + 2) y

/-- `‖(σ + iy)/2‖ ≤ (1+|σ|)(1+|y|)`. -/
theorem norm_half_le (σ y : ℝ) : ‖((σ : ℂ) + y * I) / 2‖ ≤ (1 + |σ|) * (1 + |y|) := by
  have h := Complex.norm_le_abs_re_add_abs_im ((σ : ℂ) + y * I)
  simp at h
  rw [norm_div]
  have : ‖(2 : ℂ)‖ = 2 := by norm_num
  rw [this]
  nlinarith [mul_nonneg (abs_nonneg σ) (abs_nonneg y), abs_nonneg σ, abs_nonneg y]

/-- Crude bounds valid for every real `t`: `‖dY‖ ≤ 1680(1+|σ|)(1+|y|)`. -/
theorem dY_crude {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (t y : ℝ) :
    ‖dY α β t (σ + y * I)‖ ≤ 1680 * (1 + |σ|) * (1 + |y|) := by
  have h := norm_dY_le hα hβ (s := (σ : ℂ) + y * I) (t := t) (by simpa using hσ0) le_rfl
    (abs_nonneg _) (abs_nonneg _) (abs_nonneg _) (abs_nonneg _)
  have h2 := norm_half_le σ y
  norm_num at h h2
  linarith

/-- `‖d2Y‖ ≤ 67200(1+|σ|)(1+|y|)` for every real `t`. -/
theorem d2Y_crude {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (t y : ℝ) :
    ‖d2Y α β t (σ + y * I)‖ ≤ 67200 * (1 + |σ|) * (1 + |y|) := by
  have h := norm_d2Y_le hα hβ (s := (σ : ℂ) + y * I) (t := t) (by simpa using hσ0) le_rfl
    (abs_nonneg _) (abs_nonneg _) (abs_nonneg _) (abs_nonneg _)
  have h2 := norm_half_le σ y
  norm_num at h h2
  linarith

/-! ## Local domination in `t` -/

/-- Near any `t₀`, the kernel is bounded by `C e^(−y²)(1+y²)` on the line `σ`, uniformly in
`t ∈ [t₀−1, t₀+1]`: the numerator by `norm_Gammaℝ_le`, `1/(Gammaℝ(u)Gammaℝ(v))` by compactness. -/
theorem KY_local {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) (t₀ : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ t ∈ Metric.closedBall t₀ 1, ∀ y : ℝ,
      ‖KY α β t (σ + y * I)‖ ≤ C * (Real.exp (-y ^ 2) * (1 + y ^ 2)) := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have hcont : Continuous fun t : ℝ => (Gammaℝ (uA α t))⁻¹ * (Gammaℝ (vB β t))⁻¹ := by
    have h1 : Continuous fun t : ℝ => uA α t := by unfold uA; fun_prop
    have h2 : Continuous fun t : ℝ => vB β t := by unfold vB; fun_prop
    exact (differentiable_Gammaℝ_inv.continuous.comp h1).mul
      (differentiable_Gammaℝ_inv.continuous.comp h2)
  obtain ⟨M, hM⟩ := (isCompact_closedBall t₀ 1).exists_bound_of_continuousOn hcont.continuousOn
  set B1 : ℝ := Real.pi ^ (-(1 / 2 + α.re + σ) / 2) * Real.Gamma ((1 / 2 + α.re + σ) / 2)
  set B2 : ℝ := Real.pi ^ (-(1 / 2 + β.re + σ) / 2) * Real.Gamma ((1 / 2 + β.re + σ) / 2)
  set Q : ℝ := (‖α + β‖ ^ 2 + 4 * |σ| ^ 2 + 4) / ‖α + β‖ ^ 2
  have hB10 : 0 ≤ B1 := by
    have := Real.Gamma_pos_of_pos (by linarith : (0 : ℝ) < (1 / 2 + α.re + σ) / 2)
    positivity
  have hB20 : 0 ≤ B2 := by
    have := Real.Gamma_pos_of_pos (by linarith : (0 : ℝ) < (1 / 2 + β.re + σ) / 2)
    positivity
  have hQ0 : 0 ≤ Q := by positivity
  have hσa : 0 < |σ| := abs_pos.mpr hσ
  refine ⟨Real.exp (|σ| ^ 2) * Q * (1 / |σ|) * (B1 * B2 * max M 0), by positivity,
    fun t ht y => ?_⟩
  set s : ℂ := (σ : ℂ) + y * I with hs
  have hsre : s.re = σ := by simp [hs]
  have hsim : s.im = y := by simp [hs]
  have hG := ApproxShift.GY_norm_le (α := α) (β := β) (c := |σ|) (s := s) (by rw [hsre])
  rw [hsim] at hG
  have hsn : |σ| ≤ ‖s‖ := hsre ▸ Complex.abs_re_le_norm s
  have hinv : 1 / ‖s‖ ≤ 1 / |σ| := one_div_le_one_div_of_le hσa hsn
  have h1 : 0 < (uA α t + s).re := by rw [Complex.add_re, uA_re, hsre]; linarith
  have h2 : 0 < (vB β t + s).re := by rw [Complex.add_re, vB_re, hsre]; linarith
  have g1 := norm_Gammaℝ_le h1
  have g2 := norm_Gammaℝ_le h2
  rw [Complex.add_re, uA_re, hsre] at g1
  rw [Complex.add_re, vB_re, hsre] at g2
  have hMt : ‖(Gammaℝ (uA α t))⁻¹ * (Gammaℝ (vB β t))⁻¹‖ ≤ max M 0 :=
    (hM t ht).trans (le_max_left _ _)
  have hg : ‖gY α β t s‖ ≤ B1 * B2 * max M 0 := by
    have e : gY α β t s = Gammaℝ (uA α t + s) * Gammaℝ (vB β t + s) *
        ((Gammaℝ (uA α t))⁻¹ * (Gammaℝ (vB β t))⁻¹) := by
      unfold gY
      rw [div_eq_mul_inv, mul_inv]
    rw [e, norm_mul, norm_mul]
    gcongr
  have hE : Real.exp (|σ| ^ 2 - y ^ 2) = Real.exp (|σ| ^ 2) * Real.exp (-y ^ 2) := by
    rw [← Real.exp_add]; ring_nf
  rw [KY, norm_mul, norm_div]
  calc ‖GY α β s‖ / ‖s‖ * ‖gY α β t s‖ = ‖GY α β s‖ * (1 / ‖s‖) * ‖gY α β t s‖ := by ring
    _ ≤ (Real.exp (|σ| ^ 2 - y ^ 2) * (Q * (1 + y ^ 2))) * (1 / |σ|) * (B1 * B2 * max M 0) := by
        gcongr
    _ = Real.exp (|σ| ^ 2) * Q * (1 / |σ|) * (B1 * B2 * max M 0) *
          (Real.exp (-y ^ 2) * (1 + y ^ 2)) := by rw [hE]; ring

/-! ## Continuity in `y` -/

theorem cont_F {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) {x : ℝ} (hx : 0 < x) (t : ℝ) :
    Continuous fun y : ℝ => KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) := by
  refine continuous_iff_continuousAt.mpr fun y => ?_
  have hre : ((σ : ℂ) + y * I).re = σ := by simp
  have hs0 : ((σ : ℂ) + y * I) ≠ 0 := by
    intro h
    rw [h] at hre
    simp at hre
    exact hσ hre.symm
  exact ContinuousAt.comp (g := fun s => KY α β t s * (x : ℂ) ^ (-s))
    (f := fun y : ℝ => (σ : ℂ) + y * I)
    (integrand_differentiableAt' hx hα hβ (by rw [hre]; linarith) hs0).continuousAt
    (by fun_prop)

theorem re_half_pos {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (t y : ℝ) :
    0 < ((uA α t + ((σ : ℂ) + y * I)) / 2).re ∧ 0 < ((vB β t + ((σ : ℂ) + y * I)) / 2).re := by
  obtain ⟨_, r2, _, r4⟩ := re_conds hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) t
  rw [show uA α t / 2 + ((σ : ℂ) + y * I) / 2 = (uA α t + ((σ : ℂ) + y * I)) / 2 by ring] at r2
  rw [show vB β t / 2 + ((σ : ℂ) + y * I) / 2 = (vB β t + ((σ : ℂ) + y * I)) / 2 by ring] at r4
  exact ⟨by linarith, by linarith⟩

theorem cont_dY {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (t : ℝ) :
    Continuous fun y : ℝ => dY α β t (σ + y * I) := by
  have k1 : Continuous fun y : ℝ => digamma ((uA α t + ((σ : ℂ) + y * I)) / 2) :=
    continuous_iff_continuousAt.mpr fun y => ContinuousAt.comp (g := digamma)
      (Complex.continuousAt_digamma_of_re_pos (re_half_pos hα hβ hσ0 t y).1)
      (by fun_prop : Continuous fun y : ℝ => (uA α t + ((σ : ℂ) + y * I)) / 2).continuousAt
  have k2 : Continuous fun y : ℝ => digamma ((vB β t + ((σ : ℂ) + y * I)) / 2) :=
    continuous_iff_continuousAt.mpr fun y => ContinuousAt.comp (g := digamma)
      (Complex.continuousAt_digamma_of_re_pos (re_half_pos hα hβ hσ0 t y).2)
      (by fun_prop : Continuous fun y : ℝ => (vB β t + ((σ : ℂ) + y * I)) / 2).continuousAt
  unfold dY
  exact continuous_const.mul ((k1.sub continuous_const).sub (k2.sub continuous_const))

theorem meas_d2Y {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (t : ℝ) :
    AEStronglyMeasurable (fun y : ℝ => d2Y α β t (σ + y * I)) volume := by
  have hterm : ∀ n : ℕ, Continuous fun y : ℝ =>
      -(1 / 4) * (tau' (((σ : ℂ) + y * I) / 2) (uA α t / 2) n +
        tau' (((σ : ℂ) + y * I) / 2) (vB β t / 2) n) := by
    intro n
    have q1 : ∀ y : ℝ, ((n : ℂ) + uA α t / 2 + ((σ : ℂ) + y * I) / 2) ^ 2 ≠ 0 := fun y => by
      obtain ⟨_, r2, _, _⟩ := re_conds hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) t
      apply pow_ne_zero
      rw [add_assoc]
      exact nat_add_ne (by linarith) n
    have q2 : ∀ y : ℝ, ((n : ℂ) + vB β t / 2 + ((σ : ℂ) + y * I) / 2) ^ 2 ≠ 0 := fun y => by
      obtain ⟨_, _, _, r4⟩ := re_conds hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) t
      apply pow_ne_zero
      rw [add_assoc]
      exact nat_add_ne (by linarith) n
    have c1 : Continuous fun y : ℝ => ((n : ℂ) + uA α t / 2 + ((σ : ℂ) + y * I) / 2) ^ 2 := by
      fun_prop
    have c2 : Continuous fun y : ℝ => ((n : ℂ) + vB β t / 2 + ((σ : ℂ) + y * I) / 2) ^ 2 := by
      fun_prop
    unfold tau'
    exact continuous_const.mul (((c1.inv₀ q1).sub continuous_const).add
      ((c2.inv₀ q2).sub continuous_const))
  refine aestronglyMeasurable_of_tendsto_ae atTop
    (f := fun (N : ℕ) (y : ℝ) => ∑ n ∈ Finset.range N, -(1 / 4) *
      (tau' (((σ : ℂ) + y * I) / 2) (uA α t / 2) n + tau' (((σ : ℂ) + y * I) / 2) (vB β t / 2) n))
    (fun N => (continuous_finsetSum _ fun n _ => hterm n).aestronglyMeasurable)
    (ae_of_all _ fun y => ?_)
  exact (summable_d2term hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) t).hasSum.tendsto_sum_nat

/-! ## Differentiability of `V` in `t` -/

/-- `∂_t V`, read on the line `Re s = c`: `(1/2πi)∫_(c) G(s)/s·g(s,t)·x^(−s)·dY(s,t) ds`. -/
noncomputable
def VY1 (α β : ℂ) (c x t : ℝ) : ℂ :=
  VerticalIntegral' (fun s => KY α β t s * (x : ℂ) ^ (-s) * dY α β t s) c

/-- `∂_t² V`, read on the line `Re s = c`: the integrand carries `dY² + d2Y`. -/
noncomputable
def VY2 (α β : ℂ) (c x t : ℝ) : ℂ :=
  VerticalIntegral' (fun s => KY α β t s * (x : ℂ) ^ (-s) * (dY α β t s * dY α β t s + d2Y α β t s)) c

theorem norm_F_local {α β : ℂ} {σ C : ℝ} {x : ℝ} (hx : 0 < x) {t : ℝ} {y : ℝ}
    (hC : ‖KY α β t (σ + y * I)‖ ≤ C * (Real.exp (-y ^ 2) * (1 + y ^ 2))) :
    ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ ≤
      C * x ^ (-σ) * (Real.exp (-y ^ 2) * (1 + y ^ 2)) := by
  rw [norm_mul, norm_cpow_eq_rpow_re_of_pos hx]
  have : (-((σ : ℂ) + y * I)).re = -σ := by simp
  rw [this]
  have hx' : 0 ≤ x ^ (-σ) := by positivity
  calc ‖KY α β t (σ + y * I)‖ * x ^ (-σ) ≤ C * (Real.exp (-y ^ 2) * (1 + y ^ 2)) * x ^ (-σ) :=
        mul_le_mul_of_nonneg_right hC hx'
    _ = _ := by ring

theorem F_hasDerivAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (x t : ℝ) :
    HasDerivAt (fun t => KY α β t s * (x : ℂ) ^ (-s))
      (KY α β t s * (x : ℂ) ^ (-s) * dY α β t s) t := by
  have h := ((gY_hasDerivAt hα hβ hs t).const_mul (GY α β s / s)).mul_const ((x : ℂ) ^ (-s))
  refine h.congr_deriv ?_
  unfold KY
  ring

/-- **Differentiability of `V` in `t`**, for every real `t`, on every line `σ ≥ −1/4`,
`σ ≠ 0`: `∂_t V_σ(x,t) = VY1 α β σ x t`, the derivative under the integral. -/
theorem VY_hasDerivAt {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ} (hx : 0 < x) (t₀ : ℝ) :
    HasDerivAt (fun t => VY α β σ x t) (VY1 α β σ x t₀) t₀ := by
  obtain ⟨C, hC0, hC⟩ := KY_local hα hβ hσ0 hσ t₀
  have hsre : ∀ y : ℝ, -(1 / 4) ≤ ((σ : ℂ) + y * I).re := fun y => by simpa using hσ0
  have hx0 : 0 ≤ x ^ (-σ) := by positivity
  set K : ℝ := C * x ^ (-σ) * (1680 * (1 + |σ|)) * ((1 + 2).factorial * Real.exp 2) with hK
  set K0 : ℝ := C * x ^ (-σ) * ((0 + 2).factorial * Real.exp 2) with hK0
  have hbound : ∀ t ∈ Metric.closedBall t₀ 1, ∀ y : ℝ,
      ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) * dY α β t (σ + y * I)‖ ≤
        K * Real.exp (-(1 / 4) * y ^ 2) := by
    intro t ht y
    have a1 := norm_F_local hx (hC t ht y)
    have a2 := dY_crude hα hβ hσ0 t y
    have a3 := gauss_loc 1 y
    rw [norm_mul]
    calc _ ≤ C * x ^ (-σ) * (Real.exp (-y ^ 2) * (1 + y ^ 2)) * (1680 * (1 + |σ|) * (1 + |y|)) :=
          mul_le_mul a1 a2 (norm_nonneg _) (by positivity)
      _ = C * x ^ (-σ) * (1680 * (1 + |σ|)) * (Real.exp (-y ^ 2) * (1 + y ^ 2) * (1 + |y|) ^ 1) := by
          ring
      _ ≤ C * x ^ (-σ) * (1680 * (1 + |σ|)) *
            (((1 + 2).factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2)) := by gcongr
      _ = K * Real.exp (-(1 / 4) * y ^ 2) := by rw [hK]; ring
  have hint : Integrable fun y : ℝ => K * Real.exp (-(1 / 4) * y ^ 2) :=
    (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul K
  have hFint : Integrable fun y : ℝ => KY α β t₀ (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) := by
    refine Integrable.mono' ((integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul K0)
      (cont_F hα hβ hσ0 hσ hx t₀).aestronglyMeasurable (ae_of_all _ fun y => ?_)
    have a1 := norm_F_local hx (hC t₀ (Metric.mem_closedBall_self zero_le_one) y)
    have a3 := gauss_loc 0 y
    calc _ ≤ C * x ^ (-σ) * (Real.exp (-y ^ 2) * (1 + y ^ 2)) := a1
      _ = C * x ^ (-σ) * (Real.exp (-y ^ 2) * (1 + y ^ 2) * (1 + |y|) ^ 0) := by ring
      _ ≤ C * x ^ (-σ) * (((0 + 2).factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2)) := by
          gcongr
      _ = K0 * Real.exp (-(1 / 4) * y ^ 2) := by rw [hK0]; ring
  have h := hasDerivAt_integral_of_dominated_loc_of_deriv_le (μ := volume)
    (F := fun t y => KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)))
    (F' := fun t y => KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) * dY α β t (σ + y * I))
    (x₀ := t₀) (bound := fun y => K * Real.exp (-(1 / 4) * y ^ 2))
    (Metric.ball_mem_nhds t₀ one_pos)
    (Eventually.of_forall fun t => (cont_F hα hβ hσ0 hσ hx t).aestronglyMeasurable) hFint
    ((cont_F hα hβ hσ0 hσ hx t₀).mul (cont_dY hα hβ hσ0 t₀)).aestronglyMeasurable
    (ae_of_all _ fun y t ht => hbound t (Metric.ball_subset_closedBall ht) y) hint
    (ae_of_all _ fun y t _ => F_hasDerivAt hα hβ (hsre y) x t)
  have h3 := (h.2.const_mul I).const_mul (1 / (2 * (Real.pi : ℂ) * I))
  unfold VY VY1
  simp only [VerticalIntegral', VerticalIntegral, smul_eq_mul]
  exact h3

/-- **Differentiability of `∂_t V` in `t`**: `∂_t VY1 α β σ x t = VY2 α β σ x t`. -/
theorem VY1_hasDerivAt {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ} (hx : 0 < x) (t₀ : ℝ) :
    HasDerivAt (fun t => VY1 α β σ x t) (VY2 α β σ x t₀) t₀ := by
  obtain ⟨C, hC0, hC⟩ := KY_local hα hβ hσ0 hσ t₀
  have hsre : ∀ y : ℝ, -(1 / 4) ≤ ((σ : ℂ) + y * I).re := fun y => by simpa using hσ0
  have hx0 : 0 ≤ x ^ (-σ) := by positivity
  set D : ℝ := (1680 * (1 + |σ|)) ^ 2 + 67200 * (1 + |σ|) with hD
  have hD0 : 0 ≤ D := by positivity
  set K : ℝ := C * x ^ (-σ) * D * ((2 + 2).factorial * Real.exp 2) with hK
  set K1 : ℝ := C * x ^ (-σ) * (1680 * (1 + |σ|)) * ((1 + 2).factorial * Real.exp 2) with hK1
  have hbound : ∀ t ∈ Metric.closedBall t₀ 1, ∀ y : ℝ,
      ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) *
        (dY α β t (σ + y * I) * dY α β t (σ + y * I) + d2Y α β t (σ + y * I))‖ ≤
        K * Real.exp (-(1 / 4) * y ^ 2) := by
    intro t ht y
    have a1 := norm_F_local hx (hC t ht y)
    have a2 := dY_crude hα hβ hσ0 t y
    have a4 := d2Y_crude hα hβ hσ0 t y
    have a3 := gauss_loc 2 y
    have hy1 : 1 ≤ 1 + |y| := by linarith [abs_nonneg y]
    have hsum : ‖dY α β t (σ + y * I) * dY α β t (σ + y * I) + d2Y α β t (σ + y * I)‖ ≤
        D * (1 + |y|) ^ 2 := by
      refine (norm_add_le _ _).trans ?_
      rw [norm_mul]
      have b1 : ‖dY α β t (σ + y * I)‖ * ‖dY α β t (σ + y * I)‖ ≤
          (1680 * (1 + |σ|) * (1 + |y|)) * (1680 * (1 + |σ|) * (1 + |y|)) :=
        mul_le_mul a2 a2 (norm_nonneg _) (by positivity)
      have b2 : 67200 * (1 + |σ|) * (1 + |y|) ≤ 67200 * (1 + |σ|) * (1 + |y|) ^ 2 := by
        have : (1 + |y|) ≤ (1 + |y|) ^ 2 := by nlinarith
        exact mul_le_mul_of_nonneg_left this (by positivity)
      rw [hD]
      nlinarith
    rw [norm_mul]
    calc _ ≤ C * x ^ (-σ) * (Real.exp (-y ^ 2) * (1 + y ^ 2)) * (D * (1 + |y|) ^ 2) :=
          mul_le_mul a1 hsum (norm_nonneg _) (by positivity)
      _ = C * x ^ (-σ) * D * (Real.exp (-y ^ 2) * (1 + y ^ 2) * (1 + |y|) ^ 2) := by ring
      _ ≤ C * x ^ (-σ) * D *
            (((2 + 2).factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2)) := by gcongr
      _ = K * Real.exp (-(1 / 4) * y ^ 2) := by rw [hK]; ring
  have hint : Integrable fun y : ℝ => K * Real.exp (-(1 / 4) * y ^ 2) :=
    (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul K
  have hFint : Integrable fun y : ℝ =>
      KY α β t₀ (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) * dY α β t₀ (σ + y * I) := by
    refine Integrable.mono' ((integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul K1)
      ((cont_F hα hβ hσ0 hσ hx t₀).mul (cont_dY hα hβ hσ0 t₀)).aestronglyMeasurable
      (ae_of_all _ fun y => ?_)
    have a1 := norm_F_local hx (hC t₀ (Metric.mem_closedBall_self zero_le_one) y)
    have a2 := dY_crude hα hβ hσ0 t₀ y
    have a3 := gauss_loc 1 y
    rw [norm_mul]
    calc _ ≤ C * x ^ (-σ) * (Real.exp (-y ^ 2) * (1 + y ^ 2)) * (1680 * (1 + |σ|) * (1 + |y|)) :=
          mul_le_mul a1 a2 (norm_nonneg _) (by positivity)
      _ = C * x ^ (-σ) * (1680 * (1 + |σ|)) * (Real.exp (-y ^ 2) * (1 + y ^ 2) * (1 + |y|) ^ 1) := by
          ring
      _ ≤ C * x ^ (-σ) * (1680 * (1 + |σ|)) *
            (((1 + 2).factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2)) := by gcongr
      _ = K1 * Real.exp (-(1 / 4) * y ^ 2) := by rw [hK1]; ring
  have hmeas2 := ((cont_F hα hβ hσ0 hσ hx t₀).aestronglyMeasurable).mul
    ((((cont_dY hα hβ hσ0 t₀).mul (cont_dY hα hβ hσ0 t₀)).aestronglyMeasurable).add
      (meas_d2Y hα hβ hσ0 t₀))
  have h := hasDerivAt_integral_of_dominated_loc_of_deriv_le (μ := volume)
    (F := fun t y => KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) * dY α β t (σ + y * I))
    (F' := fun t y => KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) *
      (dY α β t (σ + y * I) * dY α β t (σ + y * I) + d2Y α β t (σ + y * I)))
    (x₀ := t₀) (bound := fun y => K * Real.exp (-(1 / 4) * y ^ 2))
    (Metric.ball_mem_nhds t₀ one_pos)
    (Eventually.of_forall fun t =>
      ((cont_F hα hβ hσ0 hσ hx t).mul (cont_dY hα hβ hσ0 t)).aestronglyMeasurable) hFint
    hmeas2
    (ae_of_all _ fun y t ht => hbound t (Metric.ball_subset_closedBall ht) y) hint
    (ae_of_all _ fun y t _ => by
      have d1 := F_hasDerivAt hα hβ (hsre y) x t
      have d2 := dY_hasDerivAt hα hβ (hsre y) t
      refine (d1.mul d2).congr_deriv ?_
      ring)
  have h3 := (h.2.const_mul I).const_mul (1 / (2 * (Real.pi : ℂ) * I))
  unfold VY1 VY2
  simp only [VerticalIntegral', VerticalIntegral, smul_eq_mul]
  exact h3

/-! ## The bounds at `t ≥ 1` -/

/-- In the bulk `|y| ≤ t/2`, the four imaginary parts are at least `t/5`. -/
theorem im_conds {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t σ y : ℝ} (ht : 1 ≤ t)
    (hy : |y| ≤ t / 2) :
    t / 5 ≤ |(uA α t / 2).im| ∧ t / 5 ≤ |(uA α t / 2 + ((σ : ℂ) + y * I) / 2).im| ∧
      t / 5 ≤ |(vB β t / 2).im| ∧ t / 5 ≤ |(vB β t / 2 + ((σ : ℂ) + y * I) / 2).im| := by
  have ia := abs_le.mp ((Complex.abs_im_le_norm α).trans hα)
  have ib := abs_le.mp ((Complex.abs_im_le_norm β).trans hβ)
  have hy' := abs_le.mp hy
  have hsim : (((σ : ℂ) + y * I) / 2).im = y / 2 := by rw [Complex.div_ofNat_im]; simp
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [Complex.div_ofNat_im, uA_im]
    exact le_abs.mpr (Or.inl (by linarith))
  · rw [Complex.add_im, Complex.div_ofNat_im, uA_im, hsim]
    exact le_abs.mpr (Or.inl (by linarith))
  · rw [Complex.div_ofNat_im, vB_im]
    exact le_abs.mpr (Or.inr (by linarith))
  · rw [Complex.add_im, Complex.div_ofNat_im, vB_im, hsim]
    exact le_abs.mpr (Or.inr (by linarith))

theorem b_facts {t : ℝ} (ht : 1 ≤ t) :
    t * (1 / (1 / 20 + t / 5)) ≤ 5 ∧ 1 + 1 / (1 / 20 + t / 5) ≤ 6 := by
  have hb : 0 < 1 / 20 + t / 5 := by linarith
  constructor
  · rw [mul_one_div, div_le_iff₀ hb]; linarith
  · have : 1 / (1 / 20 + t / 5) ≤ 5 := by rw [div_le_iff₀ hb]; linarith
    linarith

/-- `t ‖dY(σ+iy, t)‖ ≤ 3360 (1+|σ|)(1+|y|)²` for `t ≥ 1`: the digamma differences are
`O(|s|/t)` in the bulk `|y| ≤ t/2`, and `O(|s|)` with `t < 2|y|` outside it. -/
theorem dY_bound {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) {t : ℝ} (ht : 1 ≤ t) (y : ℝ) :
    t * ‖dY α β t (σ + y * I)‖ ≤ 3360 * (1 + |σ|) * (1 + |y|) ^ 2 := by
  have ht0 : 0 < t := by linarith
  have hh := norm_half_le σ y
  have hy0 := abs_nonneg y
  have hσ1 : 0 ≤ 1 + |σ| := by positivity
  rcases le_or_gt |y| (t / 2) with hy | hy
  · obtain ⟨i1, i2, i3, i4⟩ := im_conds hα hβ (σ := σ) ht hy
    have h := norm_dY_le hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) (by positivity)
      i1 i2 i3 i4
    obtain ⟨k1, k2⟩ := b_facts ht
    have hn := norm_nonneg (((σ : ℂ) + y * I) / 2)
    calc t * ‖dY α β t (σ + y * I)‖
        ≤ t * (4 * ‖((σ : ℂ) + y * I) / 2‖ * (1 + 1 / (1 / 20 + t / 5)) *
          (1 / (1 / 20 + t / 5))) := mul_le_mul_of_nonneg_left h ht0.le
      _ = 4 * ‖((σ : ℂ) + y * I) / 2‖ * (1 + 1 / (1 / 20 + t / 5)) *
          (t * (1 / (1 / 20 + t / 5))) := by ring
      _ ≤ 4 * ((1 + |σ|) * (1 + |y|)) * 6 * 5 := by gcongr
      _ ≤ 3360 * (1 + |σ|) * (1 + |y|) ^ 2 := by
          have : (1 + |y|) ≤ (1 + |y|) ^ 2 := by nlinarith
          nlinarith [mul_le_mul_of_nonneg_left this hσ1]
  · have h := dY_crude hα hβ hσ0 t y
    have htl : t ≤ 2 * (1 + |y|) := by linarith
    calc t * ‖dY α β t (σ + y * I)‖ ≤ (2 * (1 + |y|)) * (1680 * (1 + |σ|) * (1 + |y|)) :=
          mul_le_mul htl h (norm_nonneg _) (by positivity)
      _ = 3360 * (1 + |σ|) * (1 + |y|) ^ 2 := by ring

/-- `t² ‖d2Y(σ+iy, t)‖ ≤ 268800 (1+|σ|)(1+|y|)³` for `t ≥ 1`. -/
theorem d2Y_bound {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) {t : ℝ} (ht : 1 ≤ t) (y : ℝ) :
    t ^ 2 * ‖d2Y α β t (σ + y * I)‖ ≤ 268800 * (1 + |σ|) * (1 + |y|) ^ 3 := by
  have ht0 : 0 < t := by linarith
  have hh := norm_half_le σ y
  have hy0 := abs_nonneg y
  have hσ1 : 0 ≤ 1 + |σ| := by positivity
  have hy1 : 1 ≤ 1 + |y| := by linarith
  rcases le_or_gt |y| (t / 2) with hy | hy
  · obtain ⟨i1, i2, i3, i4⟩ := im_conds hα hβ (σ := σ) ht hy
    have h := norm_d2Y_le hα hβ (s := (σ : ℂ) + y * I) (by simpa using hσ0) (by positivity)
      i1 i2 i3 i4
    obtain ⟨k1, k2⟩ := b_facts ht
    have hn := norm_nonneg (((σ : ℂ) + y * I) / 2)
    have hk : 0 ≤ t * (1 / (1 / 20 + t / 5)) := by positivity
    calc t ^ 2 * ‖d2Y α β t (σ + y * I)‖
        ≤ t ^ 2 * (8 * ‖((σ : ℂ) + y * I) / 2‖ / (1 / 20 + t / 5) * (1 + 1 / (1 / 20 + t / 5)) *
          (1 / (1 / 20 + t / 5))) := mul_le_mul_of_nonneg_left h (by positivity)
      _ = 8 * ‖((σ : ℂ) + y * I) / 2‖ * (1 + 1 / (1 / 20 + t / 5)) *
          ((t * (1 / (1 / 20 + t / 5))) * (t * (1 / (1 / 20 + t / 5)))) := by ring
      _ ≤ 8 * ((1 + |σ|) * (1 + |y|)) * 6 * (5 * 5) := by gcongr
      _ ≤ 268800 * (1 + |σ|) * (1 + |y|) ^ 3 := by
          have e1 : (1 + |y|) ≤ (1 + |y|) ^ 3 := le_self_pow₀ hy1 (by norm_num)
          nlinarith [mul_le_mul_of_nonneg_left e1 hσ1]
  · have h := d2Y_crude hα hβ hσ0 t y
    have htl : t ^ 2 ≤ 4 * (1 + |y|) ^ 2 := by nlinarith
    calc t ^ 2 * ‖d2Y α β t (σ + y * I)‖ ≤ (4 * (1 + |y|) ^ 2) * (67200 * (1 + |σ|) * (1 + |y|)) :=
          mul_le_mul htl h (norm_nonneg _) (by positivity)
      _ = 268800 * (1 + |σ|) * (1 + |y|) ^ 3 := by ring

/-- `t² ‖dY² + d2Y‖ ≤ E (1+|y|)⁴`, `E = 3360²(1+|σ|)² + 268800(1+|σ|)`. -/
theorem d12_bound {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) {t : ℝ} (ht : 1 ≤ t) (y : ℝ) :
    t ^ 2 * ‖dY α β t (σ + y * I) * dY α β t (σ + y * I) + d2Y α β t (σ + y * I)‖ ≤
      ((3360 * (1 + |σ|)) ^ 2 + 268800 * (1 + |σ|)) * (1 + |y|) ^ 4 := by
  have h1 := dY_bound hα hβ hσ0 ht y
  have h2 := d2Y_bound hα hβ hσ0 ht y
  have hy1 : 1 ≤ 1 + |y| := by linarith [abs_nonneg y]
  have hσ1 : 0 ≤ 1 + |σ| := by positivity
  have ht0 : 0 ≤ t := by linarith
  have hd := norm_nonneg (dY α β t (σ + y * I))
  have hsq : (t * ‖dY α β t (σ + y * I)‖) ^ 2 ≤ (3360 * (1 + |σ|) * (1 + |y|) ^ 2) ^ 2 :=
    pow_le_pow_left₀ (by positivity) h1 2
  have e3 : (1 + |y|) ^ 3 ≤ (1 + |y|) ^ 4 := pow_le_pow_right₀ hy1 (by norm_num)
  have e4 := mul_le_mul_of_nonneg_left e3 (by positivity : (0 : ℝ) ≤ 268800 * (1 + |σ|))
  calc t ^ 2 * ‖dY α β t (σ + y * I) * dY α β t (σ + y * I) + d2Y α β t (σ + y * I)‖
      ≤ t ^ 2 * (‖dY α β t (σ + y * I)‖ * ‖dY α β t (σ + y * I)‖ + ‖d2Y α β t (σ + y * I)‖) := by
        gcongr
        exact (norm_add_le _ _).trans (by rw [norm_mul])
    _ = (t * ‖dY α β t (σ + y * I)‖) ^ 2 + t ^ 2 * ‖d2Y α β t (σ + y * I)‖ := by ring
    _ ≤ (3360 * (1 + |σ|) * (1 + |y|) ^ 2) ^ 2 + 268800 * (1 + |σ|) * (1 + |y|) ^ 3 := by
        linarith
    _ ≤ _ := by nlinarith

theorem norm_VI_le (f : ℂ → ℂ) (σ : ℝ) :
    ‖VerticalIntegral' f σ‖ ≤ 1 / (2 * Real.pi) * ∫ y : ℝ, ‖f (σ + y * I)‖ := by
  rw [VerticalIntegral', VerticalIntegral, norm_smul, norm_smul, Complex.norm_I, one_mul]
  have h1 : ‖(1 / (2 * Real.pi * I) : ℂ)‖ = 1 / (2 * Real.pi) := by
    rw [norm_div, norm_one, norm_mul, norm_mul, Complex.norm_I, Complex.norm_real,
      Real.norm_eq_abs, abs_of_pos Real.pi_pos]
    norm_num
  rw [h1]
  exact mul_le_mul_of_nonneg_left (norm_integral_le_integral_norm _) (by positivity)

/-- A line integral bounded through a pointwise `B e^(−y²/4)` bound. -/
theorem VI_gauss {f : ℂ → ℂ} {σ B : ℝ}
    (h : ∀ y : ℝ, ‖f (σ + y * I)‖ ≤ B * Real.exp (-(1 / 4) * y ^ 2)) :
    ‖VerticalIntegral' f σ‖ ≤ 1 / (2 * Real.pi) * (B * Real.sqrt (Real.pi / (1 / 4))) := by
  have hgi : Integrable (fun y : ℝ => B * Real.exp (-(1 / 4) * y ^ 2)) :=
    (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul _
  have hle : ∫ y : ℝ, ‖f (σ + y * I)‖ ≤ ∫ y : ℝ, B * Real.exp (-(1 / 4) * y ^ 2) :=
    integral_mono_of_nonneg (ae_of_all _ fun y => norm_nonneg _) hgi (ae_of_all _ h)
  rw [integral_const_mul, integral_gaussian] at hle
  exact (norm_VI_le f σ).trans (mul_le_mul_of_nonneg_left hle (by positivity))

/-- The derivatives on one line `σ ≥ −1/4`, `σ ≠ 0`, for `t ≥ 1`:
`‖t VY1‖, ‖t² VY2‖ ≤ C (1 + ‖α+β‖^(−2)) (t/2π)^σ x^(−σ)`. -/
theorem VYj_line_bound {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x →
        ‖(t : ℂ) ^ 1 * VY1 α β σ x t‖ ≤
            C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) ∧
          ‖(t : ℂ) ^ 2 * VY2 α β σ x t‖ ≤
            C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) := by
  obtain ⟨C0, hC00, hC0⟩ := integrand_bound (σ₀ := σ) (σ₁ := σ) (δ := |σ|) (by linarith)
    (abs_pos.mpr hσ)
  set E1 : ℝ := 3360 * (1 + |σ|) with hE1
  set E2 : ℝ := (3360 * (1 + |σ|)) ^ 2 + 268800 * (1 + |σ|) with hE2
  set G : ℝ := Real.sqrt (Real.pi / (1 / 4)) with hG
  have hE10 : 0 ≤ E1 := by positivity
  have hE20 : 0 ≤ E2 := by positivity
  set C1 : ℝ := C0 * E1 * ((2 : ℕ).factorial * Real.exp 2) * G / (2 * Real.pi) with hC1
  set C2 : ℝ := C0 * E2 * ((4 : ℕ).factorial * Real.exp 2) * G / (2 * Real.pi) with hC2
  have hC10 : 0 ≤ C1 := by positivity
  have hC20 : 0 ≤ C2 := by positivity
  refine ⟨C1 + C2, by positivity, fun α β hα hβ t ht x hx => ?_⟩
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
  constructor
  · -- `j = 1`
    have hb : ∀ y : ℝ, ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) *
        dY α β t (σ + y * I)‖ ≤ (C0 * N * P * E1 * ((2 : ℕ).factorial * Real.exp 2) / t) *
          Real.exp (-(1 / 4) * y ^ 2) := by
      intro y
      have a2 := dY_bound hα hβ hσ0 ht y
      have a2' : ‖dY α β t (σ + y * I)‖ ≤ E1 * (1 + |y|) ^ 2 / t := by
        rw [le_div_iff₀ ht0]; linarith
      have a3 := poly_gauss 2 y
      rw [norm_mul]
      calc _ ≤ (C0 * N * P * Real.exp (-(1 / 2) * y ^ 2)) * (E1 * (1 + |y|) ^ 2 / t) :=
            mul_le_mul (hK y) a2' (norm_nonneg _) (by positivity)
        _ = C0 * N * P * E1 / t * ((1 + |y|) ^ 2 * Real.exp (-(1 / 2) * y ^ 2)) := by ring
        _ ≤ C0 * N * P * E1 / t * ((2 : ℕ).factorial * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2)) := by
            gcongr
        _ = _ := by ring
    have hV := VI_gauss (f := fun s => KY α β t s * (x : ℂ) ^ (-s) * dY α β t s) (σ := σ) hb
    have hV' : ‖VY1 α β σ x t‖ ≤ 1 / (2 * Real.pi) *
        (C0 * N * P * E1 * ((2 : ℕ).factorial * Real.exp 2) / t * G) := hV
    rw [norm_mul, norm_pow, htn, pow_one]
    calc t * ‖VY1 α β σ x t‖ ≤ t * (1 / (2 * Real.pi) *
          (C0 * N * P * E1 * ((2 : ℕ).factorial * Real.exp 2) / t * G)) :=
          mul_le_mul_of_nonneg_left hV' ht0.le
      _ = C1 * N * P := by
          rw [hC1]
          field_simp
          try ring
      _ ≤ (C1 + C2) * N * P := by gcongr; linarith
  · -- `j = 2`
    have hb : ∀ y : ℝ, ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) *
        (dY α β t (σ + y * I) * dY α β t (σ + y * I) + d2Y α β t (σ + y * I))‖ ≤
          (C0 * N * P * E2 * ((4 : ℕ).factorial * Real.exp 2) / t ^ 2) *
          Real.exp (-(1 / 4) * y ^ 2) := by
      intro y
      have a2 := d12_bound hα hβ hσ0 ht y
      have a2' : ‖dY α β t (σ + y * I) * dY α β t (σ + y * I) + d2Y α β t (σ + y * I)‖ ≤
          E2 * (1 + |y|) ^ 4 / t ^ 2 := by
        rw [le_div_iff₀ (by positivity)]; linarith
      have a3 := poly_gauss 4 y
      rw [norm_mul]
      calc _ ≤ (C0 * N * P * Real.exp (-(1 / 2) * y ^ 2)) * (E2 * (1 + |y|) ^ 4 / t ^ 2) :=
            mul_le_mul (hK y) a2' (norm_nonneg _) (by positivity)
        _ = C0 * N * P * E2 / t ^ 2 * ((1 + |y|) ^ 4 * Real.exp (-(1 / 2) * y ^ 2)) := by ring
        _ ≤ C0 * N * P * E2 / t ^ 2 *
              ((4 : ℕ).factorial * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2)) := by gcongr
        _ = _ := by ring
    have hV := VI_gauss (f := fun s => KY α β t s * (x : ℂ) ^ (-s) *
      (dY α β t s * dY α β t s + d2Y α β t s)) (σ := σ) hb
    have hV' : ‖VY2 α β σ x t‖ ≤ 1 / (2 * Real.pi) *
        (C0 * N * P * E2 * ((4 : ℕ).factorial * Real.exp 2) / t ^ 2 * G) := hV
    rw [norm_mul, norm_pow, htn]
    calc t ^ 2 * ‖VY2 α β σ x t‖ ≤ t ^ 2 * (1 / (2 * Real.pi) *
          (C0 * N * P * E2 * ((4 : ℕ).factorial * Real.exp 2) / t ^ 2 * G)) :=
          mul_le_mul_of_nonneg_left hV' (by positivity)
      _ = C2 * N * P := by
          rw [hC2]
          field_simp
          try ring
      _ ≤ (C1 + C2) * N * P := by gcongr; linarith

/-! ## Assembly -/

/-- The two lines give Young's shape: the line `A` for `x > t`, the line `−1/4` for `x ≤ t`. -/
theorem assemble {A : ℝ} (hA : 0 < A) {Ca Cm N t x z : ℝ} (hCa : 0 ≤ Ca) (hCm : 0 ≤ Cm)
    (hN : 0 ≤ N) (ht : 1 ≤ t) (hx : 0 < x)
    (ha : t < x → z ≤ Ca * N * ((t / (2 * Real.pi)) ^ A * x ^ (-A)))
    (hm : x ≤ t → z ≤ Cm * N * ((t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) * x ^ (-(-(1 / 4)) : ℝ))) :
    z ≤ (8 * Cm * 2 ^ A + Ca * 2 ^ A) * N * (1 + x / t) ^ (-A) := by
  have ht0 : 0 < t := by linarith
  have h2A : 1 ≤ (2 : ℝ) ^ A := Real.one_le_rpow (by norm_num) hA.le
  have hq : 0 < 1 + x / t := by positivity
  have hqA : 0 < (1 + x / t) ^ A := by positivity
  have hneg : (1 + x / t) ^ (-A) = ((1 + x / t) ^ A)⁻¹ := Real.rpow_neg hq.le A
  have hq0 : 0 ≤ (1 + x / t) ^ (-A) := by positivity
  rcases le_or_gt x t with hxt | hxt
  · have hP : (t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) * x ^ (-(-(1 / 4)) : ℝ) ≤ 8 := by
      have e : (t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) * x ^ (-(-(1 / 4)) : ℝ) =
          (2 * Real.pi * x / t) ^ (1 / 4 : ℝ) := by
        rw [Real.rpow_neg (by positivity), ← Real.inv_rpow (by positivity), neg_neg,
          ← Real.mul_rpow (by positivity) hx.le]
        congr 1
        field_simp
        try ring
      rw [e]
      have hb' : 2 * Real.pi * x / t ≤ 2 * Real.pi := by
        rw [div_le_iff₀ ht0]; nlinarith [Real.pi_pos]
      have := rpow_quarter_le (by positivity : (0 : ℝ) ≤ 2 * Real.pi * x / t)
      linarith [Real.pi_lt_d2]
    have hz : z ≤ Cm * N * 8 := (hm hxt).trans (mul_le_mul_of_nonneg_left hP (by positivity))
    have hlow : (2 : ℝ) ^ (-A) ≤ (1 + x / t) ^ (-A) :=
      Real.rpow_le_rpow_of_nonpos hq (by linarith [(div_le_one ht0).mpr hxt]) (by linarith)
    have h2 : (2 : ℝ) ^ A * (2 : ℝ) ^ (-A) = 1 := by
      rw [← Real.rpow_add (by norm_num), add_neg_cancel, Real.rpow_zero]
    calc z ≤ Cm * N * 8 := hz
      _ = 8 * Cm * 2 ^ A * N * (2 : ℝ) ^ (-A) := by
          linear_combination (-(8 * Cm) * N) * h2
      _ ≤ 8 * Cm * 2 ^ A * N * (1 + x / t) ^ (-A) := by gcongr
      _ ≤ (8 * Cm * 2 ^ A + Ca * 2 ^ A) * N * (1 + x / t) ^ (-A) := by
          gcongr
          nlinarith [Real.rpow_nonneg (by norm_num : (0 : ℝ) ≤ 2) A]
  · have hP : (t / (2 * Real.pi)) ^ A * x ^ (-A) ≤ (t / x) ^ A := by
      have h2pi : 1 ≤ (2 * Real.pi) ^ A :=
        Real.one_le_rpow (by linarith [Real.pi_gt_three]) hA.le
      rw [Real.div_rpow ht0.le (by positivity), Real.div_rpow ht0.le hx.le, Real.rpow_neg hx.le]
      have hxA : 0 < x ^ A := by positivity
      have htA : 0 < t ^ A := by positivity
      rw [div_mul_eq_mul_div, div_le_div_iff₀ (by positivity) hxA]
      have : t ^ A * (x ^ A)⁻¹ * x ^ A = t ^ A := by field_simp; try ring
      rw [this]
      nlinarith
    have hkey : (t / x) ^ A ≤ 2 ^ A * (1 + x / t) ^ (-A) := by
      rw [hneg, ← div_eq_mul_inv, le_div_iff₀ hqA, ← Real.mul_rpow (by positivity) hq.le]
      apply Real.rpow_le_rpow (by positivity) _ hA.le
      have : t / x * (1 + x / t) = t / x + 1 := by field_simp; try ring
      rw [this]
      have : t / x ≤ 1 := by rw [div_le_one hx]; linarith
      linarith
    calc z ≤ Ca * N * ((t / (2 * Real.pi)) ^ A * x ^ (-A)) := ha hxt
      _ ≤ Ca * N * (2 ^ A * (1 + x / t) ^ (-A)) :=
          mul_le_mul_of_nonneg_left (hP.trans hkey) (by positivity)
      _ = Ca * 2 ^ A * N * (1 + x / t) ^ (-A) := by ring
      _ ≤ (8 * Cm * 2 ^ A + Ca * 2 ^ A) * N * (1 + x / t) ^ (-A) := by
          gcongr
          nlinarith [Real.rpow_nonneg (by norm_num : (0 : ℝ) ≤ 2) A]

/-- Two functions differentiable at `t` that agree on `[t, ∞)` have the same derivative. -/
theorem deriv_eq_of_eq_Ici {f g : ℝ → ℂ} {f' g' : ℂ} {t : ℝ} (hf : HasDerivAt f f' t)
    (hg : HasDerivAt g g' t) (h : ∀ y, t ≤ y → f y = g y) : f' = g' :=
  (uniqueDiffOn_Ici t t Set.self_mem_Ici).eq_deriv _ hf.hasDerivWithinAt
    (hg.hasDerivWithinAt.congr (fun y hy => h y hy) (h t le_rfl))

/-- The derivatives do not depend on the line, and the residue `1` drops out: for `t ≥ 1`,
`VYj c = VYj A = VYj (−1/4)`, `j = 1, 2`. -/
theorem VYj_lines {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {x : ℝ} (hx : 0 < x) {c A : ℝ} (hc : 0 < c) (hA : 0 < A) {t : ℝ} (ht : 1 ≤ t) :
    VY1 α β c x t = VY1 α β A x t ∧ VY1 α β c x t = VY1 α β (-(1 / 4)) x t ∧
      VY2 α β c x t = VY2 α β A x t ∧ VY2 α β c x t = VY2 α β (-(1 / 4)) x t := by
  have hc' : -(1 / 4) ≤ c := by linarith
  have hA' : -(1 / 4) ≤ A := by linarith
  have hm : -(1 / 4) ≤ (-(1 / 4) : ℝ) := le_rfl
  have hm0 : (-(1 / 4) : ℝ) ≠ 0 := by norm_num
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
  have d1A : ∀ y : ℝ, 1 ≤ y → VY1 α β c x y = VY1 α β A x y := fun y hy =>
    deriv_eq_of_eq_Ici (VY_hasDerivAt hc' hc.ne' hα hβ hx y)
      (VY_hasDerivAt hA' hA.ne' hα hβ hx y) (fun z hz => eA z (hy.trans hz))
  have d1m : ∀ y : ℝ, 1 ≤ y → VY1 α β c x y = VY1 α β (-(1 / 4)) x y := fun y hy =>
    deriv_eq_of_eq_Ici (VY_hasDerivAt hc' hc.ne' hα hβ hx y)
      ((VY_hasDerivAt hm hm0 hα hβ hx y).const_add 1) (fun z hz => em z (hy.trans hz))
  refine ⟨d1A t ht, d1m t ht, ?_, ?_⟩
  · exact deriv_eq_of_eq_Ici (VY1_hasDerivAt hc' hc.ne' hα hβ hx t)
      (VY1_hasDerivAt hA' hA.ne' hα hβ hx t) (fun z hz => d1A z (ht.trans hz))
  · exact deriv_eq_of_eq_Ici (VY1_hasDerivAt hc' hc.ne' hα hβ hx t)
      (VY1_hasDerivAt hm hm0 hα hβ hx t) (fun z hz => d1m z (ht.trans hz))

/-- `∂_t V = VY1` and `∂_t² V = VY2` as functions, on every line `c > 0`. -/
theorem iteratedDeriv_VY {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ}
    (hx : 0 < x) {c : ℝ} (hc : 0 < c) :
    iteratedDeriv 1 (fun t => VY α β c x t) = (fun t => VY1 α β c x t) ∧
      iteratedDeriv 2 (fun t => VY α β c x t) = (fun t => VY2 α β c x t) := by
  have hc' : -(1 / 4) ≤ c := by linarith
  have h1 : deriv (fun t => VY α β c x t) = fun t => VY1 α β c x t :=
    funext fun t => (VY_hasDerivAt hc' hc.ne' hα hβ hx t).deriv
  have h2 : deriv (fun t => VY1 α β c x t) = fun t => VY2 α β c x t :=
    funext fun t => (VY1_hasDerivAt hc' hc.ne' hα hβ hx t).deriv
  refine ⟨by rw [iteratedDeriv_one, h1], ?_⟩
  rw [show (2 : ℕ) = 1 + 1 from rfl, iteratedDeriv_succ, iteratedDeriv_one, h1, h2]

/-- **Young's (4.3) for `j = 1, 2`.** For every `A > 0` there is `C` with
`‖t^j ∂_t^j V_{α,β}(x,t)‖ ≤ C (1 + ‖α+β‖^(−2)) (1 + x/t)^(−A)`, `j = 1, 2`, uniformly in
`‖α‖, ‖β‖ ≤ 1/10` with `α + β ≠ 0`, `t ≥ 1`, `x > 0`, and the line `c > 0` of `V`. -/
theorem VY_deriv_bound {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ∀ j : ℕ, 1 ≤ j → j ≤ 2 →
        ‖(t : ℂ) ^ j * iteratedDeriv j (fun t => VY α β c x t) t‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A) := by
  obtain ⟨Ca, hCa0, hCa⟩ := VYj_line_bound (σ := A) (by linarith) hA.ne'
  obtain ⟨Cm, hCm0, hCm⟩ := VYj_line_bound (σ := -(1 / 4)) le_rfl (by norm_num)
  refine ⟨8 * Cm * 2 ^ A + Ca * 2 ^ A, by positivity,
    fun α β hα hβ hαβ t ht x hx c hc j hj1 hj2 => ?_⟩
  have hN : 0 ≤ 1 + 1 / ‖α + β‖ ^ 2 := by positivity
  obtain ⟨l1A, l1m, l2A, l2m⟩ := VYj_lines hα hβ hαβ hx hc hA ht
  obtain ⟨i1, i2⟩ := iteratedDeriv_VY hα hβ hx hc
  rcases (show j = 1 ∨ j = 2 by omega) with rfl | rfl
  · rw [i1]
    beta_reduce
    refine assemble hA hCa0 hCm0 hN ht hx (fun _ => ?_) (fun _ => ?_)
    · rw [l1A]; exact (hCa α β hα hβ t ht x hx).1
    · rw [l1m]; exact (hCm α β hα hβ t ht x hx).1
  · rw [i2]
    beta_reduce
    refine assemble hA hCa0 hCm0 hN ht hx (fun _ => ?_) (fun _ => ?_)
    · rw [l2A]; exact (hCa α β hα hβ t ht x hx).2
    · rw [l2m]; exact (hCm α β hα hβ t ht x hx).2

/-! ## Axiom pins -/

/-- info: 'ApproxDeriv.hasDerivAt_Gammaℝ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hasDerivAt_Gammaℝ

/-- info: 'ApproxDeriv.gY_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gY_hasDerivAt

/-- info: 'ApproxDeriv.hasSum_tau' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hasSum_tau

/-- info: 'ApproxDeriv.dY_hasSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dY_hasSum

/-- info: 'ApproxDeriv.norm_dY_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_dY_le

/-- info: 'ApproxDeriv.norm_d2Y_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_d2Y_le

/-- info: 'ApproxDeriv.dY_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dY_hasDerivAt

/-- info: 'ApproxDeriv.VY_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_hasDerivAt

/-- info: 'ApproxDeriv.VY1_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY1_hasDerivAt

/-- info: 'ApproxDeriv.iteratedDeriv_VY' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iteratedDeriv_VY

/-- info: 'ApproxDeriv.dY_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dY_bound

/-- info: 'ApproxDeriv.d2Y_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms d2Y_bound

/-- info: 'ApproxDeriv.VYj_line_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VYj_line_bound

/-- info: 'ApproxDeriv.VYj_lines' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VYj_lines

/-- info: 'ApproxDeriv.VY_deriv_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_deriv_bound

end ApproxDeriv
