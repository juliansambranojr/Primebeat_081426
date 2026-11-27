/-
# ApproxBounds — block S12 of `lean_stage3/design/stencil.md`, piece 2a, the sizes. 2026-11-25.

The sizes Young's Lemma 3 (arXiv 1002.4403, §5) takes from Lemma 4's Remark: (4.2) for
`X_{α,β,t}`, (4.3) with `j = 0` for `V_{α,β}(x,t)`, and the remainder `resY` of
`ApproxShift.approxFE`. Notation as in `ApproxFE`: `u = uA α t`, `v = vB β t`. Every bound is
uniform in `‖α‖, ‖β‖ ≤ 1/10` and `t ≥ 1`; `N = 1 + ‖α+β‖^(−2)` carries the `1/(α+β)²` of
`p(s)`.

The Γ tool. Euler's limit (`Complex.GammaSeq_tendsto_Gamma`) gives
`‖Γ(x+iY)‖/Γ(x) = Π_j (1 + Y²/(x+j)²)^(−1/2)`. For `0 < x₁ ≤ x₂` the mean value theorem on
`L(u) = log(1 + Y²/u²)`, whose derivative `−2f`, `f(u) = Y²/(u(u²+Y²))`, decreases, and the
telescoping `f(u+1) ≤ (L(u) − L(u+1))/2 ≤ f(u)` give `gamma_shift`: the real shift at a fixed
height is `(x₂ − x₁)·ℓ(Y)` up to `(x₂ − x₁)(1/x₁ + |log x₁| + |log x₂|)`, `ℓ(Y) = log(1+Y²)/2`.
With `‖Γ(1/2+iY)‖² = π/cosh(πY)` this is a crude Stirling on every vertical line
(`log_norm_Gamma_approx`): `log‖Γ(r+iY)‖ = log Γ(r) − log Γ(1/2) + (log π)/2 − π|Y|/2 +
(r − 1/2)ℓ(Y) + O_r(1)`, the error explicit (`gErr r`). The tree's `stmtDigammaLog_holds` sits
on one line; this file does not use it.

| statement | content | status |
|---|---|---|
| `gamma_shift`, `gamma_rel` | the real shift of `log‖Γ‖` at a fixed height, from Euler's product | proved |
| `log_norm_Gamma_approx` | `|log‖Γ z‖ − gModel(Re z, Im z)| ≤ gErr(Re z)`, `Re z > 0` | proved |
| `log_norm_Gammaℝ_approx` | the same for `Gammaℝ` | proved |
| `XY_log` | `|log‖X‖ − Re(α+β)(log π − log(t/2))| ≤ K` | proved |
| `XY_size` | target 1, (4.2) two-sided: `‖X‖ ≤ C (t/2π)^(−Re(α+β))` and `(t/2π)^(−Re(α+β)) ≤ C ‖X‖` | proved |
| `gY_bound` | `‖g(σ+iy,t)‖ ≤ C (t/2π)^σ e^(B|y|)` on `σ₀ ≤ σ ≤ σ₁`, `σ₀ > −2/5` | proved |
| `integrand_bound` | `‖G(s)/s·g·x^(−s)‖ ≤ C N (t/2π)^σ x^(−σ) e^(−y²/2)` on a strip, `‖s‖ ≥ δ` | proved |
| `VY_line_bound` | `‖V_σ(x,t)‖ ≤ C N (t/2π)^σ x^(−σ)`, `σ ≠ 0`, `σ > −2/5` | proved |
| `VY_line_eq` | `V_c = V_{c'}` for `0 < c ≤ c'` (Cauchy on `[c, c'] × [−T, T]`) | proved |
| `VY_residue` | `V_{1/4} − V_{−1/4} = 1`, the residue `G(0)g(0)` at `s = 0`, `α + β ≠ 0` | proved |
| `VY_decay` | target 3: `‖V_c(x,t)‖ ≤ C_A N (t/x)^A`, every `A > 0`, `c > 0` | proved |
| `VY_decay_young` | target 3 in Young's form: `‖V_c(x,t)‖ ≤ C_A N (1 + x/t)^(−A)`, `α + β ≠ 0` | proved |
| `resY_small` | target 2: `‖resY α β t‖ ≤ C N e^(−t²/2)` | proved |
| (4.2) for `g` with `1 + O(t^(−1)(1+|s|²))`; (4.3) for `j ≥ 1` | the asymptotic forms, the `t`-derivatives | OPEN, not stated |

The direction in (4.3). Young's arXiv text reads `(1 + |t/x|)^(−A)`. The integral fixes
`(1 + x/t)^(−A)`: `g(s,t) ≈ (t/2π)^s`, so the line `Re s = A` gives `(t/x)^A`, small for large
`x/t`, and the shift left past `s = 0` gives the residue `1`, so `V ≈ 1` for small `x/t`. Young's
own use in Lemma 5's proof, `(1 + |x/T|)^(−A)`, has this direction.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.ApproxShift

namespace ApproxBounds

open Complex MeasureTheory Filter Topology ApproxFE

/-- `f(u) = Y²/(u(u²+Y²))`, minus half the derivative of `LY`. -/
noncomputable
def fY (Y u : ℝ) : ℝ := Y ^ 2 / (u * (u ^ 2 + Y ^ 2))

/-- `L(u) = log(1 + Y²/u²)`. -/
noncomputable
def LY (Y u : ℝ) : ℝ := Real.log (1 + Y ^ 2 / u ^ 2)

theorem LY_hasDerivAt (Y : ℝ) {u : ℝ} (hu : 0 < u) :
    HasDerivAt (LY Y) (-2 * fY Y u) u := by
  have hu0 : u ≠ 0 := hu.ne'
  have h0 := (hasDerivAt_const u (Y ^ 2)).div (hasDerivAt_pow 2 u) (pow_ne_zero 2 hu0)
  have h2 : HasDerivAt (fun u : ℝ => 1 + Y ^ 2 / u ^ 2)
      ((0 * u ^ 2 - Y ^ 2 * (((2 : ℕ) : ℝ) * u ^ (2 - 1))) / (u ^ 2) ^ 2) u := h0.const_add 1
  have hpos : 0 < 1 + Y ^ 2 / u ^ 2 := by positivity
  have h3 := h2.log hpos.ne'
  show HasDerivAt (fun u : ℝ => Real.log (1 + Y ^ 2 / u ^ 2)) _ u
  refine h3.congr_deriv ?_
  unfold fY
  have hY : 0 < u ^ 2 + Y ^ 2 := by positivity
  field_simp
  try ring

theorem fY_nonneg (Y : ℝ) {u : ℝ} (hu : 0 < u) : 0 ≤ fY Y u := by
  unfold fY
  positivity

theorem fY_anti (Y : ℝ) {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) : fY Y b ≤ fY Y a := by
  unfold fY
  apply div_le_div_of_nonneg_left (sq_nonneg Y) (by positivity)
  have hb : 0 < b := lt_of_lt_of_le ha hab
  have h2 : a ^ 2 ≤ b ^ 2 := pow_le_pow_left₀ ha.le hab 2
  exact mul_le_mul hab (by linarith) (by positivity) hb.le

theorem fY_le_inv (Y : ℝ) {u : ℝ} (hu : 0 < u) : fY Y u ≤ 1 / u := by
  unfold fY
  rw [div_le_div_iff₀ (by positivity) hu]
  nlinarith [sq_nonneg u, sq_nonneg Y, mul_pos hu hu]

theorem LY_nonneg (Y u : ℝ) : 0 ≤ LY Y u := by
  unfold LY
  apply Real.log_nonneg
  have : 0 ≤ Y ^ 2 / u ^ 2 := by positivity
  linarith

/-- One step: `2(b−a) f(b) ≤ L(a) − L(b) ≤ 2(b−a) f(a)` for `0 < a ≤ b`. -/
theorem LY_step (Y : ℝ) {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) :
    2 * (b - a) * fY Y b ≤ LY Y a - LY Y b ∧ LY Y a - LY Y b ≤ 2 * (b - a) * fY Y a := by
  rcases eq_or_lt_of_le hab with h | h
  · subst h
    simp
  have hcont : ContinuousOn (LY Y) (Set.Icc a b) := fun x hx =>
    (LY_hasDerivAt Y (lt_of_lt_of_le ha hx.1)).continuousAt.continuousWithinAt
  obtain ⟨c, hc, hcd⟩ := exists_hasDerivAt_eq_slope (LY Y) (fun u => -2 * fY Y u) h hcont
    (fun x hx => LY_hasDerivAt Y (ha.trans hx.1))
  have hba : 0 < b - a := by linarith
  have heq : LY Y a - LY Y b = 2 * (b - a) * fY Y c := by
    rw [eq_div_iff hba.ne'] at hcd
    linarith
  have h1 := fY_anti Y (ha.trans hc.1) hc.2.le
  have h2 := fY_anti Y ha hc.1.le
  rw [heq]
  constructor
  · exact mul_le_mul_of_nonneg_left h1 (by linarith)
  · exact mul_le_mul_of_nonneg_left h2 (by linarith)

/-- `Σ_{j ≤ n} f(x+j) ≤ f(x) + L(x)/2`. -/
theorem sum_fY_le (Y : ℝ) {x : ℝ} (hx : 0 < x) (n : ℕ) :
    ∑ j ∈ Finset.range (n + 1), fY Y (x + j) ≤ fY Y x + LY Y x / 2 := by
  rw [Finset.sum_range_succ']
  have hstep : ∀ j ∈ Finset.range n, fY Y (x + ((j + 1 : ℕ) : ℝ)) ≤
      LY Y (x + j) / 2 - LY Y (x + ((j + 1 : ℕ) : ℝ)) / 2 := by
    intro j _
    have hj : 0 < x + j := by positivity
    have := (LY_step Y hj (by push_cast; linarith : x + (j : ℝ) ≤ x + ((j + 1 : ℕ) : ℝ))).1
    push_cast at this ⊢
    linarith
  have hsum := Finset.sum_le_sum hstep
  rw [Finset.sum_range_sub' (fun j : ℕ => LY Y (x + j) / 2)] at hsum
  have hL := LY_nonneg Y (x + n)
  simp only [Nat.cast_zero, add_zero, Nat.cast_add, Nat.cast_one] at hsum ⊢
  linarith

/-- `(L(x) − L(x+n+1))/2 ≤ Σ_{j ≤ n} f(x+j)`. -/
theorem sum_fY_ge (Y : ℝ) {x : ℝ} (hx : 0 < x) (n : ℕ) :
    LY Y x / 2 - LY Y (x + ((n + 1 : ℕ) : ℝ)) / 2 ≤ ∑ j ∈ Finset.range (n + 1), fY Y (x + j) := by
  have hstep : ∀ j ∈ Finset.range (n + 1),
      LY Y (x + j) / 2 - LY Y (x + ((j + 1 : ℕ) : ℝ)) / 2 ≤ fY Y (x + j) := by
    intro j _
    have hj : 0 < x + j := by positivity
    have := (LY_step Y hj (by push_cast; linarith : x + (j : ℝ) ≤ x + ((j + 1 : ℕ) : ℝ))).2
    push_cast at this ⊢
    linarith
  have hsum := Finset.sum_le_sum hstep
  rw [Finset.sum_range_sub' (fun j : ℕ => LY Y (x + j) / 2)] at hsum
  simpa using hsum

/-- `log ‖a + iY‖ = log a + L(a)/2` for `a > 0`. -/
theorem log_norm_add_I {a : ℝ} (ha : 0 < a) (Y : ℝ) :
    Real.log ‖(a : ℂ) + Y * I‖ = Real.log a + LY Y a / 2 := by
  rw [norm_add_mul_I, Real.log_sqrt (by positivity)]
  unfold LY
  have h : a ^ 2 + Y ^ 2 = a ^ 2 * (1 + Y ^ 2 / a ^ 2) := by
    field_simp
    try ring
  rw [h, Real.log_mul (by positivity) (by positivity), Real.log_pow]
  push_cast
  ring

theorem norm_GammaSeq (s : ℂ) (n : ℕ) :
    ‖GammaSeq s n‖ = ‖(n : ℂ) ^ s‖ * (n.factorial : ℝ) /
      ∏ j ∈ Finset.range (n + 1), ‖s + j‖ := by
  rw [GammaSeq, norm_div, norm_mul, norm_prod]
  simp

/-- The partial product: `log‖GammaSeq (x+iY) n‖ − log‖GammaSeq x n‖ = −½ Σ_{j≤n} L(x+j)`. -/
theorem log_GammaSeq_sub {x : ℝ} (hx : 0 < x) (Y : ℝ) {n : ℕ} (hn : 1 ≤ n) :
    Real.log ‖GammaSeq ((x : ℂ) + Y * I) n‖ - Real.log ‖GammaSeq (x : ℂ) n‖ =
      -(1 / 2) * ∑ j ∈ Finset.range (n + 1), LY Y (x + j) := by
  have hn0 : 0 < n := hn
  rw [norm_GammaSeq, norm_GammaSeq, norm_natCast_cpow_of_pos hn0,
    norm_natCast_cpow_of_pos hn0]
  simp only [add_re, ofReal_re, mul_re, I_re, mul_zero, ofReal_im, I_im, mul_one, sub_self,
    add_zero]
  have hterm1 : ∀ j ∈ Finset.range (n + 1), ‖(x : ℂ) + Y * I + j‖ = ‖((x + j : ℝ) : ℂ) + Y * I‖ := by
    intro j _
    congr 1
    push_cast
    ring
  have hterm2 : ∀ j ∈ Finset.range (n + 1), ‖(x : ℂ) + j‖ = x + j := by
    intro j _
    have : (x : ℂ) + j = ((x + j : ℝ) : ℂ) := by push_cast; ring
    rw [this, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (by positivity)]
  rw [Finset.prod_congr rfl hterm1, Finset.prod_congr rfl hterm2]
  have hA : 0 < (n : ℝ) ^ x * (n.factorial : ℝ) := by positivity
  have hP1 : 0 < ∏ j ∈ Finset.range (n + 1), ‖((x + j : ℝ) : ℂ) + Y * I‖ := by
    apply Finset.prod_pos
    intro j _
    have : (0 : ℝ) < x + j := by positivity
    rw [norm_add_mul_I]
    positivity
  have hP2 : 0 < ∏ j ∈ Finset.range (n + 1), (x + (j : ℝ)) := by
    apply Finset.prod_pos
    intro j _
    positivity
  rw [Real.log_div hA.ne' hP1.ne', Real.log_div hA.ne' hP2.ne',
    Real.log_prod (fun j _ => by
      have : (0 : ℝ) < x + j := by positivity
      rw [norm_add_mul_I]; positivity),
    Real.log_prod (fun j _ => by positivity)]
  have hsum : ∑ j ∈ Finset.range (n + 1), Real.log ‖((x + j : ℝ) : ℂ) + Y * I‖ =
      ∑ j ∈ Finset.range (n + 1), (Real.log (x + j) + LY Y (x + j) / 2) := by
    apply Finset.sum_congr rfl
    intro j _
    exact log_norm_add_I (by positivity) Y
  rw [hsum, Finset.sum_add_distrib, ← Finset.sum_div]
  ring

/-- `lg x Y = log ‖Γ(x+iY)‖ − log Γ(x)`. -/
noncomputable
def lg (x Y : ℝ) : ℝ := Real.log ‖Complex.Gamma ((x : ℂ) + Y * I)‖ - Real.log (Real.Gamma x)

theorem tendsto_log_GammaSeq {x : ℝ} (hx : 0 < x) (Y : ℝ) :
    Tendsto (fun n : ℕ => Real.log ‖GammaSeq ((x : ℂ) + Y * I) n‖ -
      Real.log ‖GammaSeq (x : ℂ) n‖) atTop (𝓝 (lg x Y)) := by
  have hre : 0 < ((x : ℂ) + Y * I).re := by simp [hx]
  have h1 := (GammaSeq_tendsto_Gamma ((x : ℂ) + Y * I)).norm
  have h2 := (GammaSeq_tendsto_Gamma (x : ℂ)).norm
  have hG1 : ‖Complex.Gamma ((x : ℂ) + Y * I)‖ ≠ 0 :=
    norm_ne_zero_iff.mpr (Complex.Gamma_ne_zero_of_re_pos hre)
  have hG2 : ‖Complex.Gamma (x : ℂ)‖ = Real.Gamma x := by
    rw [Complex.Gamma_ofReal, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (Real.Gamma_pos_of_pos hx)]
  have hG2' : Real.Gamma x ≠ 0 := (Real.Gamma_pos_of_pos hx).ne'
  have l1 := (Real.continuousAt_log hG1).tendsto.comp h1
  have l2 := (Real.continuousAt_log (hG2 ▸ hG2')).tendsto.comp h2
  rw [hG2] at l2
  exact l1.sub l2

theorem LY_tendsto (Y x : ℝ) :
    Tendsto (fun n : ℕ => LY Y (x + ((n + 1 : ℕ) : ℝ))) atTop (𝓝 0) := by
  have h1 : Tendsto (fun u : ℝ => Y ^ 2 / u ^ 2) atTop (𝓝 0) :=
    tendsto_const_nhds.div_atTop (tendsto_pow_atTop two_ne_zero)
  have h2 : Tendsto (fun u : ℝ => 1 + Y ^ 2 / u ^ 2) atTop (𝓝 1) := by
    simpa using h1.const_add 1
  have h3 := (Real.continuousAt_log one_ne_zero).tendsto.comp h2
  have h4 : Tendsto (fun u : ℝ => LY Y u) atTop (𝓝 0) := by
    simpa [LY, Function.comp_def] using h3
  have h5 : Tendsto (fun n : ℕ => x + ((n + 1 : ℕ) : ℝ)) atTop atTop :=
    tendsto_atTop_add_const_left _ x
      (tendsto_natCast_atTop_atTop.comp (tendsto_add_atTop_nat 1))
  exact h4.comp h5

/-- The real shift at a fixed height, from Euler's product: for `0 < x₁ ≤ x₂`,
`(x₂−x₁) L(x₂)/2 ≤ lg x₂ Y − lg x₁ Y ≤ (x₂−x₁)(f(x₁) + L(x₁)/2)`. -/
theorem gamma_shift {x₁ x₂ : ℝ} (h1 : 0 < x₁) (h12 : x₁ ≤ x₂) (Y : ℝ) :
    (x₂ - x₁) * (LY Y x₂ / 2) ≤ lg x₂ Y - lg x₁ Y ∧
      lg x₂ Y - lg x₁ Y ≤ (x₂ - x₁) * (fY Y x₁ + LY Y x₁ / 2) := by
  have h2 : 0 < x₂ := lt_of_lt_of_le h1 h12
  have hlim := (tendsto_log_GammaSeq h2 Y).sub (tendsto_log_GammaSeq h1 Y)
  set e : ℕ → ℝ := fun n => (Real.log ‖GammaSeq ((x₂ : ℂ) + Y * I) n‖ -
      Real.log ‖GammaSeq (x₂ : ℂ) n‖) - (Real.log ‖GammaSeq ((x₁ : ℂ) + Y * I) n‖ -
      Real.log ‖GammaSeq (x₁ : ℂ) n‖) with he
  have hd : 0 ≤ x₂ - x₁ := by linarith
  have hbounds : ∀ n : ℕ, 1 ≤ n →
      (x₂ - x₁) * (LY Y x₂ / 2 - LY Y (x₂ + ((n + 1 : ℕ) : ℝ)) / 2) ≤ e n ∧
        e n ≤ (x₂ - x₁) * (fY Y x₁ + LY Y x₁ / 2) := by
    intro n hn
    have hen : e n = ∑ j ∈ Finset.range (n + 1), (LY Y (x₁ + j) - LY Y (x₂ + j)) / 2 := by
      simp only [he]
      rw [log_GammaSeq_sub h2 Y hn, log_GammaSeq_sub h1 Y hn, ← Finset.sum_div,
        Finset.sum_sub_distrib]
      ring
    have hterm : ∀ j ∈ Finset.range (n + 1),
        (x₂ - x₁) * fY Y (x₂ + j) ≤ (LY Y (x₁ + j) - LY Y (x₂ + j)) / 2 ∧
          (LY Y (x₁ + j) - LY Y (x₂ + j)) / 2 ≤ (x₂ - x₁) * fY Y (x₁ + j) := by
      intro j _
      have hj : 0 < x₁ + j := by positivity
      have hs := LY_step Y hj (by linarith : x₁ + (j : ℝ) ≤ x₂ + j)
      have e1 : x₂ + (j : ℝ) - (x₁ + j) = x₂ - x₁ := by ring
      rw [e1] at hs
      constructor <;> linarith [hs.1, hs.2]
    have hlo := Finset.sum_le_sum fun j hj => (hterm j hj).1
    have hhi := Finset.sum_le_sum fun j hj => (hterm j hj).2
    rw [← Finset.mul_sum] at hlo hhi
    rw [hen]
    constructor
    · calc (x₂ - x₁) * (LY Y x₂ / 2 - LY Y (x₂ + ((n + 1 : ℕ) : ℝ)) / 2)
          ≤ (x₂ - x₁) * ∑ j ∈ Finset.range (n + 1), fY Y (x₂ + j) :=
            mul_le_mul_of_nonneg_left (sum_fY_ge Y h2 n) hd
        _ ≤ _ := hlo
    · calc _ ≤ (x₂ - x₁) * ∑ j ∈ Finset.range (n + 1), fY Y (x₁ + j) := hhi
        _ ≤ _ := mul_le_mul_of_nonneg_left (sum_fY_le Y h1 n) hd
  have hev : ∀ᶠ n in atTop, 1 ≤ n := eventually_ge_atTop 1
  constructor
  · have hlow : Tendsto (fun n : ℕ => (x₂ - x₁) * (LY Y x₂ / 2 -
        LY Y (x₂ + ((n + 1 : ℕ) : ℝ)) / 2)) atTop (𝓝 ((x₂ - x₁) * (LY Y x₂ / 2 - 0 / 2))) :=
      ((tendsto_const_nhds.sub ((LY_tendsto Y x₂).div_const 2)).const_mul _)
    simp only [zero_div, sub_zero] at hlow
    exact le_of_tendsto_of_tendsto hlow hlim (hev.mono fun n hn => (hbounds n hn).1)
  · exact le_of_tendsto hlim (hev.mono fun n hn => (hbounds n hn).2)

/-- `ℓ(Y) = log(1 + Y²)/2`. -/
noncomputable
def lY (Y : ℝ) : ℝ := Real.log (1 + Y ^ 2) / 2

theorem lY_nonneg (Y : ℝ) : 0 ≤ lY Y := by
  unfold lY
  have := Real.log_nonneg (by nlinarith [sq_nonneg Y] : (1 : ℝ) ≤ 1 + Y ^ 2)
  linarith

theorem lY_neg (Y : ℝ) : lY (-Y) = lY Y := by
  simp [lY]

theorem LY_eq {x : ℝ} (hx : 0 < x) (Y : ℝ) :
    LY Y x = Real.log (x ^ 2 + Y ^ 2) - 2 * Real.log x := by
  unfold LY
  have h : 1 + Y ^ 2 / x ^ 2 = (x ^ 2 + Y ^ 2) / x ^ 2 := by
    field_simp
    try ring
  rw [h, Real.log_div (by positivity) (by positivity), Real.log_pow]
  push_cast
  ring

theorem LY_half_sub {x : ℝ} (hx : 0 < x) (Y : ℝ) : |LY Y x / 2 - lY Y| ≤ |Real.log x| := by
  rw [LY_eq hx]
  unfold lY
  have hY : 0 < 1 + Y ^ 2 := by positivity
  rcases le_or_gt x 1 with h | h
  · have hl : Real.log x ≤ 0 := Real.log_nonpos hx.le h
    have hx2 : x ^ 2 ≤ 1 := by nlinarith
    have a1 : Real.log (x ^ 2 + Y ^ 2) ≤ Real.log (1 + Y ^ 2) :=
      Real.log_le_log (by positivity) (by linarith)
    have a2 : Real.log (x ^ 2 * (1 + Y ^ 2)) ≤ Real.log (x ^ 2 + Y ^ 2) :=
      Real.log_le_log (by positivity) (by nlinarith [sq_nonneg Y, sq_nonneg x])
    rw [Real.log_mul (by positivity) hY.ne', Real.log_pow] at a2
    push_cast at a2
    rw [abs_le, abs_of_nonpos hl]
    constructor <;> linarith
  · have hl : 0 ≤ Real.log x := Real.log_nonneg h.le
    have hx2 : 1 ≤ x ^ 2 := by nlinarith
    have a1 : Real.log (1 + Y ^ 2) ≤ Real.log (x ^ 2 + Y ^ 2) :=
      Real.log_le_log hY (by linarith)
    have a2 : Real.log (x ^ 2 + Y ^ 2) ≤ Real.log (x ^ 2 * (1 + Y ^ 2)) :=
      Real.log_le_log (by positivity) (by nlinarith [sq_nonneg Y, sq_nonneg x])
    rw [Real.log_mul (by positivity) hY.ne', Real.log_pow] at a2
    push_cast at a2
    rw [abs_le, abs_of_nonneg hl]
    constructor <;> linarith

/-- The real shift in the `ℓ` form: `|lg x₂ Y − lg x₁ Y − (x₂−x₁) ℓ(Y)| ≤ (x₂−x₁)(1/x₁ + |log x₁| + |log x₂|)`. -/
theorem gamma_rel {x₁ x₂ : ℝ} (h1 : 0 < x₁) (h12 : x₁ ≤ x₂) (Y : ℝ) :
    |lg x₂ Y - lg x₁ Y - (x₂ - x₁) * lY Y| ≤
      (x₂ - x₁) * (1 / x₁ + |Real.log x₁| + |Real.log x₂|) := by
  have h2 : 0 < x₂ := lt_of_lt_of_le h1 h12
  have hd : 0 ≤ x₂ - x₁ := by linarith
  obtain ⟨lo, hi⟩ := gamma_shift h1 h12 Y
  have f1 := fY_le_inv Y h1
  have r1 := abs_le.mp (LY_half_sub h1 Y)
  have r2 := abs_le.mp (LY_half_sub h2 Y)
  have q1 := abs_nonneg (Real.log x₁)
  have q2 := abs_nonneg (Real.log x₂)
  have k1 : (x₂ - x₁) * (LY Y x₂ / 2) ≥ (x₂ - x₁) * (lY Y - |Real.log x₂|) :=
    mul_le_mul_of_nonneg_left (by linarith [r2.1]) hd
  have k2 : (x₂ - x₁) * (fY Y x₁ + LY Y x₁ / 2) ≤ (x₂ - x₁) * (1 / x₁ + lY Y + |Real.log x₁|) :=
    mul_le_mul_of_nonneg_left (by linarith [r1.2]) hd
  have k3 : 0 ≤ (x₂ - x₁) * (1 / x₁) := mul_nonneg hd (by positivity)
  have k4 : 0 ≤ (x₂ - x₁) * |Real.log x₁| := mul_nonneg hd q1
  have k5 : 0 ≤ (x₂ - x₁) * |Real.log x₂| := mul_nonneg hd q2
  rw [abs_le]
  constructor <;> nlinarith

/-- `‖Γ(1/2+iY)‖² = π / cosh(πY)` (PNT+ `gamma_half_vertical_norm_sq`, not built at the pin;
re-proved). -/
theorem gamma_half_norm_sq (Y : ℝ) :
    ‖Complex.Gamma (((1 / 2 : ℝ) : ℂ) + Y * I)‖ ^ 2 = Real.pi / Real.cosh (Real.pi * Y) := by
  set z : ℂ := ((1 / 2 : ℝ) : ℂ) + (Y : ℂ) * I with hz
  have hconj : (starRingEnd ℂ) z = 1 - z := by
    apply Complex.ext <;> simp [z]
    norm_num
  have hleft : Complex.Gamma z * Complex.Gamma (1 - z) = ((‖Complex.Gamma z‖ ^ 2 : ℝ) : ℂ) := by
    rw [← hconj, Complex.Gamma_conj, Complex.mul_conj, Complex.normSq_eq_norm_sq]
  have harg : (Real.pi : ℂ) * z = (Real.pi / 2 : ℂ) + ((Real.pi * Y : ℝ) : ℂ) * I := by
    simp only [z]
    push_cast
    ring
  have hsin : Complex.sin (Real.pi * z) = (Real.cosh (Real.pi * Y) : ℂ) := by
    rw [harg]
    simp [Complex.sin_add, Complex.sin_pi_div_two, Complex.cos_pi_div_two, Complex.cos_mul_I,
      Complex.sin_mul_I, Complex.ofReal_cosh]
  have hc : ((‖Complex.Gamma z‖ ^ 2 : ℝ) : ℂ) = ((Real.pi / Real.cosh (Real.pi * Y) : ℝ) : ℂ) := by
    rw [← hleft, Complex.Gamma_mul_Gamma_one_sub, hsin]
    push_cast
    rfl
  exact Complex.ofReal_injective hc

theorem log_cosh_bounds (x : ℝ) :
    |x| - Real.log 2 ≤ Real.log (Real.cosh x) ∧ Real.log (Real.cosh x) ≤ |x| := by
  have hc : 0 < Real.cosh x := Real.cosh_pos x
  have e1 : Real.exp |x| / 2 ≤ Real.cosh x := by
    rw [Real.cosh_eq]
    rcases le_or_gt 0 x with h | h
    · rw [abs_of_nonneg h]; nlinarith [Real.exp_pos (-x)]
    · rw [abs_of_neg h]; nlinarith [Real.exp_pos x]
  have e2 : Real.cosh x ≤ Real.exp |x| := by
    rw [Real.cosh_eq]
    have a1 : Real.exp x ≤ Real.exp |x| := Real.exp_le_exp.mpr (le_abs_self x)
    have a2 : Real.exp (-x) ≤ Real.exp |x| := Real.exp_le_exp.mpr (neg_le_abs x)
    linarith
  constructor
  · have := Real.log_le_log (by positivity) e1
    rw [Real.log_div (Real.exp_pos _).ne' (by norm_num), Real.log_exp] at this
    exact this
  · have := Real.log_le_log hc e2
    rwa [Real.log_exp] at this

/-- On the half line: `|log‖Γ(1/2+iY)‖ − (log π − π|Y|)/2| ≤ log 2 / 2`. -/
theorem log_gamma_half (Y : ℝ) :
    |Real.log ‖Complex.Gamma (((1 / 2 : ℝ) : ℂ) + Y * I)‖ - (Real.log Real.pi - Real.pi * |Y|) / 2| ≤
      Real.log 2 / 2 := by
  have hn : 0 < ‖Complex.Gamma (((1 / 2 : ℝ) : ℂ) + Y * I)‖ :=
    norm_pos_iff.mpr (Complex.Gamma_ne_zero_of_re_pos (by simp))
  have h2 : Real.log ‖Complex.Gamma (((1 / 2 : ℝ) : ℂ) + Y * I)‖ =
      (Real.log Real.pi - Real.log (Real.cosh (Real.pi * Y))) / 2 := by
    have := congrArg Real.log (gamma_half_norm_sq Y)
    rw [Real.log_pow, Real.log_div Real.pi_pos.ne' (Real.cosh_pos _).ne'] at this
    simp only [Nat.cast_ofNat] at this
    linarith
  rw [h2]
  have hb := log_cosh_bounds (Real.pi * Y)
  rw [abs_mul, abs_of_pos Real.pi_pos] at hb
  rw [abs_le]
  constructor <;> linarith [hb.1, hb.2]

/-- The model of `log ‖Γ(r+iY)‖`. -/
noncomputable
def gModel (r Y : ℝ) : ℝ :=
  Real.log (Real.Gamma r) - Real.log (Real.Gamma (1 / 2)) + Real.log Real.pi / 2 -
    Real.pi * |Y| / 2 + (r - 1 / 2) * lY Y

/-- Its error. -/
noncomputable
def gErr (r : ℝ) : ℝ := |r - 1 / 2| * (2 + 1 / r + |Real.log r| + Real.log 2) + Real.log 2 / 2

/-- Stirling in the crude-explicit form, for `Re z > 0`, every height:
`|log ‖Γ z‖ − gModel (Re z) (Im z)| ≤ gErr (Re z)`. -/
theorem log_norm_Gamma_approx {z : ℂ} (hz : 0 < z.re) :
    |Real.log ‖Complex.Gamma z‖ - gModel z.re z.im| ≤ gErr z.re := by
  set r := z.re
  set Y := z.im
  have hzr : z = (r : ℂ) + Y * I := (Complex.re_add_im z).symm
  have hlgr : Real.log ‖Complex.Gamma z‖ = lg r Y + Real.log (Real.Gamma r) := by
    rw [lg, hzr]
    ring
  have hlgh : lg (1 / 2) Y = Real.log ‖Complex.Gamma (((1 / 2 : ℝ) : ℂ) + Y * I)‖ -
      Real.log (Real.Gamma (1 / 2)) := rfl
  have hh := abs_le.mp (log_gamma_half Y)
  have hl2 : |Real.log (1 / 2 : ℝ)| = Real.log 2 := by
    rw [one_div, Real.log_inv, abs_neg, abs_of_nonneg (Real.log_nonneg (by norm_num))]
  have hl2p : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have hlr := abs_nonneg (Real.log r)
  rw [hlgr]
  unfold gModel gErr
  rcases le_or_gt (1 / 2) r with h | h
  · have hrel := abs_le.mp (gamma_rel (by norm_num : (0 : ℝ) < 1 / 2) h Y)
    rw [hl2] at hrel
    rw [abs_of_nonneg (by linarith : 0 ≤ r - 1 / 2)]
    have k : 0 ≤ (r - 1 / 2) * (1 / r) := mul_nonneg (by linarith) (by positivity)
    have e : (r - 1 / 2) * (1 / (1 / 2) + Real.log 2 + |Real.log r|) ≤
        (r - 1 / 2) * (2 + 1 / r + |Real.log r| + Real.log 2) := by nlinarith
    rw [abs_le]
    constructor <;> nlinarith [hrel.1, hrel.2, hh.1, hh.2]
  · have hrel := abs_le.mp (gamma_rel hz h.le Y)
    rw [hl2] at hrel
    rw [abs_of_neg (by linarith : r - 1 / 2 < 0)]
    have e : (1 / 2 - r) * (1 / r + |Real.log r| + Real.log 2) ≤
        -(r - 1 / 2) * (2 + 1 / r + |Real.log r| + Real.log 2) := by nlinarith
    rw [abs_le]
    constructor <;> nlinarith [hrel.1, hrel.2, hh.1, hh.2]

/-! ## `Gammaℝ` -/

theorem log_norm_Gammaℝ {w : ℂ} (hw : 0 < w.re) :
    Real.log ‖Gammaℝ w‖ = -(w.re / 2) * Real.log Real.pi + Real.log ‖Complex.Gamma (w / 2)‖ := by
  have hG : Complex.Gamma (w / 2) ≠ 0 := Complex.Gamma_ne_zero_of_re_pos (by simp; linarith)
  rw [Gammaℝ_def, norm_mul, norm_cpow_eq_rpow_re_of_pos Real.pi_pos,
    Real.log_mul (by positivity) (norm_ne_zero_iff.mpr hG), Real.log_rpow Real.pi_pos]
  congr 2
  simp
  ring

/-- The model of `log ‖Gammaℝ w‖`. -/
noncomputable
def gRModel (w : ℂ) : ℝ := -(w.re / 2) * Real.log Real.pi + gModel (w.re / 2) (w.im / 2)

theorem log_norm_Gammaℝ_approx {w : ℂ} (hw : 0 < w.re) :
    |Real.log ‖Gammaℝ w‖ - gRModel w| ≤ gErr (w.re / 2) := by
  have h := log_norm_Gamma_approx (z := w / 2) (by simp; linarith)
  have e1 : (w / 2).re = w.re / 2 := by simp
  have e2 : (w / 2).im = w.im / 2 := by simp
  rw [e1, e2] at h
  rw [log_norm_Gammaℝ hw, gRModel]
  convert h using 2
  ring

theorem gErr_nonneg {r : ℝ} (hr : 0 < r) : 0 ≤ gErr r := by
  unfold gErr
  have := Real.log_nonneg (by norm_num : (1 : ℝ) ≤ 2)
  have : 0 ≤ 1 / r := by positivity
  positivity

/-- Uniform constants on a compact range of real parts. -/
theorem const_bound {lo hi : ℝ} (hlo : 0 < lo) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ r : ℝ, lo ≤ r → r ≤ hi →
      |Real.log (Real.Gamma r)| ≤ K ∧ gErr r ≤ K := by
  have hc : ContinuousOn (fun r : ℝ => |Real.log (Real.Gamma r)| + gErr r) (Set.Icc lo hi) := by
    intro r hr
    apply ContinuousAt.continuousWithinAt
    have hr0 : 0 < r := lt_of_lt_of_le hlo hr.1
    have hG : ∀ m : ℕ, r ≠ -(m : ℝ) := fun m h => by
      have := m.cast_nonneg (α := ℝ)
      linarith
    have hGc : ContinuousAt Real.Gamma r := (Real.differentiableAt_Gamma hG).continuousAt
    have hlog : ContinuousAt (fun r : ℝ => Real.log (Real.Gamma r)) r :=
      ContinuousAt.comp (g := Real.log) (f := Real.Gamma)
        (Real.continuousAt_log (Real.Gamma_pos_of_pos hr0).ne') hGc
    have hlogr : ContinuousAt Real.log r := Real.continuousAt_log hr0.ne'
    have hinv : ContinuousAt (fun r : ℝ => 1 / r) r :=
      continuousAt_const.div continuousAt_id hr0.ne'
    unfold gErr
    apply ContinuousAt.add hlog.abs
    apply ContinuousAt.add _ continuousAt_const
    apply ContinuousAt.mul (continuousAt_id.sub continuousAt_const).abs
    exact ((continuousAt_const.add hinv).add hlogr.abs).add continuousAt_const
  obtain ⟨C, hC⟩ := isCompact_Icc.exists_bound_of_continuousOn hc
  refine ⟨max C 0, le_max_right _ _, fun r h1 h2 => ?_⟩
  have hr0 : 0 < r := lt_of_lt_of_le hlo h1
  have h3 := hC r ⟨h1, h2⟩
  have h4 := gErr_nonneg hr0
  have h5 := abs_nonneg (Real.log (Real.Gamma r))
  rw [Real.norm_eq_abs, abs_of_nonneg (by linarith)] at h3
  constructor
  · linarith [le_max_left C 0]
  · linarith [le_max_left C 0]

/-- `|ℓ(Y) − log(t/2)| ≤ 3` for `t ≥ 1`, `|Y − t/2| ≤ t/10`. -/
theorem lY_near {t Y : ℝ} (ht : 1 ≤ t) (hY : |Y - t / 2| ≤ t / 10) :
    |lY Y - Real.log (t / 2)| ≤ 3 := by
  have hY' := abs_le.mp hY
  have hYlo : 2 * t / 5 ≤ Y := by linarith
  have hYhi : Y ≤ 3 * t / 5 := by linarith
  have ht0 : 0 < t := by linarith
  have h6 : (7 : ℝ) ≤ Real.exp 6 := by linarith [Real.add_one_le_exp (6 : ℝ)]
  have hpos : 0 < 1 + Y ^ 2 := by positivity
  have hq : 0 < (t / 2) ^ 2 := by positivity
  have hup : 1 + Y ^ 2 ≤ Real.exp 6 * (t / 2) ^ 2 := by nlinarith
  have hlo : Real.exp (-6) * (t / 2) ^ 2 ≤ 1 + Y ^ 2 := by
    have : Real.exp (-6) ≤ 1 / 7 := by
      rw [Real.exp_neg, ← one_div]
      exact one_div_le_one_div_of_le (by norm_num) h6
    nlinarith
  have a1 := Real.log_le_log hpos hup
  have a2 := Real.log_le_log (by positivity) hlo
  rw [Real.log_mul (by positivity) hq.ne', Real.log_exp, Real.log_pow] at a1 a2
  simp only [Nat.cast_ofNat] at a1 a2
  unfold lY
  rw [abs_le]
  constructor <;> linarith

/-! ## Target 1: the size of `X_{α,β,t}` -/

theorem re_one_sub_uA (α : ℂ) (t : ℝ) : (1 - uA α t).re = 1 / 2 - α.re := by
  simp [uA]; ring
theorem im_one_sub_uA (α : ℂ) (t : ℝ) : (1 - uA α t).im = -(α.im + t) := by
  simp [uA]
theorem re_one_sub_vB (β : ℂ) (t : ℝ) : (1 - vB β t).re = 1 / 2 - β.re := by
  simp [vB]; ring
theorem im_one_sub_vB (β : ℂ) (t : ℝ) : (1 - vB β t).im = -(β.im - t) := by
  simp [vB]

/-- The model difference `gRModel(1−u) − gRModel(u)`. -/
theorem gRModel_reflect (w : ℂ) (a Y : ℝ) (hre : w.re = 1 / 2 + a) (him : w.im = Y)
    (w' : ℂ) (hre' : w'.re = 1 / 2 - a) (him' : w'.im = -Y) :
    gRModel w' - gRModel w = a * Real.log Real.pi + Real.log (Real.Gamma ((1 / 2 - a) / 2)) -
      Real.log (Real.Gamma ((1 / 2 + a) / 2)) - a * lY (Y / 2) := by
  unfold gRModel gModel
  rw [hre, him, hre', him', neg_div, abs_neg, lY_neg]
  ring

/-- The log of `‖X_{α,β,t}‖` is `Re(α+β)·(log π − log(t/2))` up to a constant, uniformly for
`‖α‖, ‖β‖ ≤ 1/10`, `t ≥ 1`. -/
theorem XY_log :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      |Real.log ‖XY α β t‖ - (α + β).re * (Real.log Real.pi - Real.log (t / 2))| ≤ K := by
  obtain ⟨K, hK0, hK⟩ := const_bound (lo := 1 / 5) (hi := 3 / 10) (by norm_num)
  refine ⟨8 * K + 6 / 10, by positivity, fun α β hα hβ t ht => ?_⟩
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have ia := abs_le.mp ((Complex.abs_im_le_norm α).trans hα)
  have ib := abs_le.mp ((Complex.abs_im_le_norm β).trans hβ)
  have hu : 0 < (uA α t).re := by rw [uA_re]; linarith
  have hv : 0 < (vB β t).re := by rw [vB_re]; linarith
  have hu' : 0 < (1 - uA α t).re := by rw [re_one_sub_uA]; linarith
  have hv' : 0 < (1 - vB β t).re := by rw [re_one_sub_vB]; linarith
  have n1 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hu)
  have n2 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hv)
  have n3 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hu')
  have n4 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hv')
  have hlog : Real.log ‖XY α β t‖ = Real.log ‖Gammaℝ (1 - uA α t)‖ +
      Real.log ‖Gammaℝ (1 - vB β t)‖ - Real.log ‖Gammaℝ (uA α t)‖ -
      Real.log ‖Gammaℝ (vB β t)‖ := by
    rw [XY, norm_div, norm_mul, norm_mul, Real.log_div (by positivity) (by positivity),
      Real.log_mul n3.ne' n4.ne', Real.log_mul n1.ne' n2.ne']
    ring
  have e1 := abs_le.mp (log_norm_Gammaℝ_approx hu)
  have e2 := abs_le.mp (log_norm_Gammaℝ_approx hv)
  have e3 := abs_le.mp (log_norm_Gammaℝ_approx hu')
  have e4 := abs_le.mp (log_norm_Gammaℝ_approx hv')
  rw [uA_re] at e1
  rw [vB_re] at e2
  rw [re_one_sub_uA] at e3
  rw [re_one_sub_vB] at e4
  have k1 := hK ((1 / 2 + α.re) / 2) (by linarith) (by linarith)
  have k2 := hK ((1 / 2 + β.re) / 2) (by linarith) (by linarith)
  have k3 := hK ((1 / 2 - α.re) / 2) (by linarith) (by linarith)
  have k4 := hK ((1 / 2 - β.re) / 2) (by linarith) (by linarith)
  have m1 := gRModel_reflect (uA α t) α.re (uA α t).im (uA_re α t) rfl (1 - uA α t)
    (re_one_sub_uA α t) (by rw [im_one_sub_uA, uA_im])
  have m2 := gRModel_reflect (vB β t) β.re (vB β t).im (vB_re β t) rfl (1 - vB β t)
    (re_one_sub_vB β t) (by rw [im_one_sub_vB, vB_im])
  rw [uA_im] at m1
  rw [vB_im] at m2
  have l1 := (lY_near (Y := (α.im + t) / 2) ht (by
    rw [abs_le]; constructor <;> linarith))
  have l2 : |lY ((β.im - t) / 2) - Real.log (t / 2)| ≤ 3 := by
    have : (β.im - t) / 2 = -((t - β.im) / 2) := by ring
    rw [this, lY_neg]
    exact lY_near ht (by rw [abs_le]; constructor <;> linarith)
  have p1 : |α.re * lY ((α.im + t) / 2) - α.re * Real.log (t / 2)| ≤ 3 / 10 := by
    rw [← mul_sub, abs_mul]
    have := mul_le_mul ((Complex.abs_re_le_norm α).trans hα) (lY_near (Y := (α.im + t) / 2) ht
      (by rw [abs_le]; constructor <;> linarith)) (abs_nonneg _) (by norm_num)
    linarith
  have p2 : |β.re * lY ((β.im - t) / 2) - β.re * Real.log (t / 2)| ≤ 3 / 10 := by
    rw [← mul_sub, abs_mul]
    have := mul_le_mul ((Complex.abs_re_le_norm β).trans hβ) l2 (abs_nonneg _) (by norm_num)
    linarith
  have p1' := abs_le.mp p1
  have p2' := abs_le.mp p2
  have g1 := abs_le.mp k1.1
  have g2 := abs_le.mp k2.1
  have g3 := abs_le.mp k3.1
  have g4 := abs_le.mp k4.1
  rw [hlog, Complex.add_re, abs_le]
  constructor <;> linarith [k1.2, k2.2, k3.2, k4.2]

theorem log_div_two_pi {t : ℝ} (ht : 0 < t) :
    Real.log (t / (2 * Real.pi)) = Real.log (t / 2) - Real.log Real.pi := by
  have : t / (2 * Real.pi) = (t / 2) / Real.pi := by ring
  rw [this, Real.log_div (by positivity) Real.pi_pos.ne']

/-- **Target 1**, Young's (4.2) in the bound form, both sides: for `‖α‖, ‖β‖ ≤ 1/10` and
`t ≥ 1`, `‖X_{α,β,t}‖ ≤ C (t/2π)^(−Re(α+β))` and `(t/2π)^(−Re(α+β)) ≤ C ‖X_{α,β,t}‖`,
with one `C`. -/
theorem XY_size :
    ∃ C : ℝ, 0 < C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ‖XY α β t‖ ≤ C * (t / (2 * Real.pi)) ^ (-(α + β).re) ∧
        (t / (2 * Real.pi)) ^ (-(α + β).re) ≤ C * ‖XY α β t‖ := by
  obtain ⟨K, hK0, hK⟩ := XY_log
  refine ⟨Real.exp K, Real.exp_pos _, fun α β hα hβ t ht => ?_⟩
  have ht0 : 0 < t := by linarith
  have hb := abs_le.mp (hK α β hα hβ t ht)
  have hX : 0 < ‖XY α β t‖ := by
    have hu : 0 < (uA α t).re := by
      rw [uA_re]; linarith [abs_le.mp ((Complex.abs_re_le_norm α).trans hα)]
    have hv : 0 < (vB β t).re := by
      rw [vB_re]; linarith [abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)]
    have hu' : 0 < (1 - uA α t).re := by
      rw [re_one_sub_uA]; linarith [abs_le.mp ((Complex.abs_re_le_norm α).trans hα)]
    have hv' : 0 < (1 - vB β t).re := by
      rw [re_one_sub_vB]; linarith [abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)]
    rw [XY]
    apply norm_pos_iff.mpr
    exact div_ne_zero (mul_ne_zero (Gammaℝ_ne_zero_of_re_pos hu') (Gammaℝ_ne_zero_of_re_pos hv'))
      (mul_ne_zero (Gammaℝ_ne_zero_of_re_pos hu) (Gammaℝ_ne_zero_of_re_pos hv))
  have hpow : (t / (2 * Real.pi)) ^ (-(α + β).re) =
      Real.exp ((α + β).re * (Real.log Real.pi - Real.log (t / 2))) := by
    rw [Real.rpow_def_of_pos (by positivity), log_div_two_pi ht0]
    congr 1
    ring
  have hXe : ‖XY α β t‖ = Real.exp (Real.log ‖XY α β t‖) := (Real.exp_log hX).symm
  rw [hpow]
  constructor
  · rw [hXe, ← Real.exp_add]
    exact Real.exp_le_exp.mpr (by linarith)
  · rw [hXe, ← Real.exp_add]
    exact Real.exp_le_exp.mpr (by linarith)

/-! ## The `Gammaℝ` ratio at shifted points -/

/-- `|ℓ(Y + h) − ℓ(Y)| ≤ |h|`. -/
theorem lY_lip (Y h : ℝ) : |lY (Y + h) - lY Y| ≤ |h| := by
  have key : ∀ A B : ℝ, lY B - lY A ≤ |B - A| := by
    intro A B
    unfold lY
    have hA : 0 < 1 + A ^ 2 := by positivity
    have hk : 1 + B ^ 2 ≤ (1 + A ^ 2) * (1 + |B - A|) ^ 2 := by
      have e : B = A + (B - A) := by ring
      set d := B - A
      rw [e]
      have hd := abs_nonneg d
      have h1 : 2 * A * d ≤ 2 * |A| * |d| := by
        have := le_abs_self (A * d)
        rw [abs_mul] at this
        linarith
      have h2 : 2 * |A| ≤ 1 + A ^ 2 := by nlinarith [sq_abs A, sq_nonneg (|A| - 1)]
      have h3 : d ^ 2 = |d| ^ 2 := (sq_abs d).symm
      nlinarith [mul_le_mul_of_nonneg_right h2 hd, sq_nonneg A, sq_nonneg |d|]
    have hl := Real.log_le_log (by positivity) hk
    rw [Real.log_mul hA.ne' (by positivity), Real.log_pow] at hl
    have hl2 : Real.log (1 + |B - A|) ≤ |B - A| := by
      have := Real.log_le_sub_one_of_pos (by positivity : (0 : ℝ) < 1 + |B - A|)
      linarith
    simp only [Nat.cast_ofNat] at hl
    linarith
  rw [abs_le]
  constructor
  · have := key (Y + h) Y
    rw [show Y - (Y + h) = -h by ring, abs_neg] at this
    linarith
  · have := key Y (Y + h)
    rwa [show Y + h - Y = h by ring] at this

/-- One factor of `g`: `log‖Gammaℝ(w+s)‖ − log‖Gammaℝ w‖` for `s = σ + iy`, `Re w = 1/2 + a`,
`Im w = 2Y₀` with `ℓ(Y₀)` within `3` of `log(t/2)`. -/
theorem gR_shift {w : ℂ} {a Y₀ σ y K K' t : ℝ} (hre : w.re = 1 / 2 + a) (him : w.im = 2 * Y₀)
    (ha : |a| ≤ 1 / 10) (hY₀ : |lY Y₀ - Real.log (t / 2)| ≤ 3) (hσ : -(2 / 5) < σ)
    (hK : |Real.log (Real.Gamma ((1 / 2 + a) / 2))| ≤ K ∧ gErr ((1 / 2 + a) / 2) ≤ K)
    (hK' : |Real.log (Real.Gamma ((1 / 2 + a + σ) / 2))| ≤ K' ∧ gErr ((1 / 2 + a + σ) / 2) ≤ K') :
    Real.log ‖Gammaℝ (w + (σ + y * I))‖ - Real.log ‖Gammaℝ w‖ ≤
      σ / 2 * (Real.log (t / 2) - Real.log Real.pi) + 2 * K + 2 * K' + 3 * |σ| / 2 +
        (Real.pi / 4 + |σ| / 4 + 1 / 4) * |y| := by
  have ha' := abs_le.mp ha
  have hw0 : 0 < w.re := by rw [hre]; linarith
  have hre1 : (w + (σ + y * I)).re = 1 / 2 + a + σ := by simp [hre]
  have him1 : (w + (σ + y * I)).im = 2 * (Y₀ + y / 2) := by simp [him]; ring
  have hw1 : 0 < (w + (σ + y * I)).re := by rw [hre1]; linarith
  have e0 := abs_le.mp (log_norm_Gammaℝ_approx hw0)
  have e1 := abs_le.mp (log_norm_Gammaℝ_approx hw1)
  rw [hre] at e0
  rw [hre1] at e1
  set d₁ := lY Y₀ - Real.log (t / 2) with hd₁
  set d₂ := lY (Y₀ + y / 2) - lY Y₀ with hd₂
  have hmod : gRModel (w + (σ + y * I)) - gRModel w =
      -(σ / 2) * Real.log Real.pi + Real.log (Real.Gamma ((1 / 2 + a + σ) / 2)) -
        Real.log (Real.Gamma ((1 / 2 + a) / 2)) -
        Real.pi * (|Y₀ + y / 2| - |Y₀|) / 2 + σ / 2 * Real.log (t / 2) + σ / 2 * d₁ +
        σ / 2 * d₂ + ((1 / 2 + a) / 2 - 1 / 2) * d₂ := by
    unfold gRModel gModel
    rw [hre, hre1, him, him1]
    simp only [hd₁, hd₂]
    ring_nf
  have hd₂b : |d₂| ≤ |y| / 2 := by
    have := lY_lip Y₀ (y / 2)
    rwa [abs_div, abs_two] at this
  have habs : |Y₀| - |y| / 2 ≤ |Y₀ + y / 2| := by
    have := abs_sub_abs_le_abs_sub Y₀ (-(y / 2))
    rw [sub_neg_eq_add, abs_neg, abs_div, abs_two] at this
    linarith
  have pr : ∀ p q : ℝ, p * q ≤ |p| * |q| := fun p q => by
    rw [← abs_mul]; exact le_abs_self _
  have t1 : σ / 2 * d₁ ≤ |σ| / 2 * 3 := by
    have := pr (σ / 2) d₁
    rw [abs_div, abs_two] at this
    exact this.trans (mul_le_mul_of_nonneg_left hY₀ (by positivity))
  have t2 : σ / 2 * d₂ ≤ |σ| / 2 * (|y| / 2) := by
    have := pr (σ / 2) d₂
    rw [abs_div, abs_two] at this
    exact this.trans (mul_le_mul_of_nonneg_left hd₂b (by positivity))
  have t3 : ((1 / 2 + a) / 2 - 1 / 2) * d₂ ≤ (3 / 10) * (|y| / 2) := by
    have := pr ((1 / 2 + a) / 2 - 1 / 2) d₂
    have hb : |(1 / 2 + a) / 2 - 1 / 2| ≤ 3 / 10 := by
      rw [abs_le]; constructor <;> linarith
    exact this.trans (mul_le_mul hb hd₂b (abs_nonneg _) (by norm_num))
  have g1 := abs_le.mp hK.1
  have g2 := abs_le.mp hK'.1
  have hy := abs_nonneg y
  have hpi : 0 < Real.pi := Real.pi_pos
  have t4 : -(Real.pi * (|Y₀ + y / 2| - |Y₀|) / 2) ≤ Real.pi / 4 * |y| := by nlinarith
  have hsσ := abs_nonneg σ
  have t5 : |σ| / 2 * (|y| / 2) = |σ| / 4 * |y| := by ring
  nlinarith [hK.2, hK'.2, e0.1, e0.2, e1.1, e1.2]

/-- Young's `g_{α,β}(s,t) = (t/2π)^s (1 + …)` in the bound form, on a strip
`σ₀ ≤ Re s ≤ σ₁` with `σ₀ > −2/5`: `‖g(σ+iy, t)‖ ≤ C (t/2π)^σ e^{B|y|}`, uniformly in
`‖α‖, ‖β‖ ≤ 1/10`, `t ≥ 1`. -/
theorem gY_bound {σ₀ σ₁ : ℝ} (h0 : -(2 / 5) < σ₀) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ →
        ‖gY α β t (σ + y * I)‖ ≤ C * (t / (2 * Real.pi)) ^ σ *
          Real.exp ((Real.pi / 2 + (|σ₀| + |σ₁|) / 2 + 1 / 2) * |y|) := by
  obtain ⟨K, hK0, hK⟩ := const_bound (lo := 1 / 5) (hi := 3 / 10) (by norm_num)
  obtain ⟨K', hK'0, hK'⟩ := const_bound (lo := (2 / 5 + σ₀) / 2) (hi := (3 / 5 + σ₁) / 2)
    (by linarith)
  refine ⟨Real.exp (4 * K + 4 * K' + 3 * (|σ₀| + |σ₁|)), (Real.exp_pos _).le,
    fun α β hα hβ t ht σ y hσ0 hσ1 => ?_⟩
  have ht0 : 0 < t := by linarith
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have ia := abs_le.mp ((Complex.abs_im_le_norm α).trans hα)
  have ib := abs_le.mp ((Complex.abs_im_le_norm β).trans hβ)
  have hσ : -(2 / 5) < σ := by linarith
  have hσM : |σ| ≤ |σ₀| + |σ₁| := by
    rw [abs_le]; constructor <;>
      linarith [neg_abs_le σ₀, le_abs_self σ₁, abs_nonneg σ₀, abs_nonneg σ₁]
  have f1 := gR_shift (w := uA α t) (a := α.re) (Y₀ := (α.im + t) / 2) (σ := σ) (y := y)
    (K := K) (K' := K') (t := t) (uA_re α t) (by rw [uA_im]; ring)
    ((Complex.abs_re_le_norm α).trans hα)
    (lY_near ht (by rw [abs_le]; constructor <;> linarith)) hσ
    (hK _ (by linarith) (by linarith)) (hK' _ (by linarith) (by linarith))
  have f2 := gR_shift (w := vB β t) (a := β.re) (Y₀ := (β.im - t) / 2) (σ := σ) (y := y)
    (K := K) (K' := K') (t := t) (vB_re β t) (by rw [vB_im]; ring)
    ((Complex.abs_re_le_norm β).trans hβ)
    (by
      have : (β.im - t) / 2 = -((t - β.im) / 2) := by ring
      rw [this, lY_neg]
      exact lY_near ht (by rw [abs_le]; constructor <;> linarith)) hσ
    (hK _ (by linarith) (by linarith)) (hK' _ (by linarith) (by linarith))
  have hu : 0 < (uA α t).re := by rw [uA_re]; linarith
  have hv : 0 < (vB β t).re := by rw [vB_re]; linarith
  have hus : 0 < (uA α t + (σ + y * I)).re := by simp [uA_re]; linarith
  have hvs : 0 < (vB β t + (σ + y * I)).re := by simp [vB_re]; linarith
  have n1 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hu)
  have n2 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hv)
  have n3 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hus)
  have n4 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hvs)
  have hg : 0 < ‖gY α β t (σ + y * I)‖ := by
    rw [gY, norm_div, norm_mul, norm_mul]
    positivity
  have hlog : Real.log ‖gY α β t (σ + y * I)‖ =
      (Real.log ‖Gammaℝ (uA α t + (σ + y * I))‖ - Real.log ‖Gammaℝ (uA α t)‖) +
      (Real.log ‖Gammaℝ (vB β t + (σ + y * I))‖ - Real.log ‖Gammaℝ (vB β t)‖) := by
    rw [gY, norm_div, norm_mul, norm_mul, Real.log_div (by positivity) (by positivity),
      Real.log_mul n3.ne' n4.ne', Real.log_mul n1.ne' n2.ne']
    ring
  have hpow : (t / (2 * Real.pi)) ^ σ =
      Real.exp (σ * (Real.log (t / 2) - Real.log Real.pi)) := by
    rw [Real.rpow_def_of_pos (by positivity), log_div_two_pi ht0]
    ring_nf
  rw [← Real.exp_log hg, hpow, ← Real.exp_add, ← Real.exp_add]
  apply Real.exp_le_exp.mpr
  have hy := abs_nonneg y
  have e1 : (Real.pi / 4 + |σ| / 4 + 1 / 4) * |y| + (Real.pi / 4 + |σ| / 4 + 1 / 4) * |y| ≤
      (Real.pi / 2 + (|σ₀| + |σ₁|) / 2 + 1 / 2) * |y| := by nlinarith
  linarith

/-! ## Target 3: the decay of `V` -/

/-- `e^(−y²)(1+y²)e^(B|y|) ≤ 4 e^(B²) e^(−y²/2)`. -/
theorem gauss_absorb (B y : ℝ) :
    Real.exp (-y ^ 2) * (1 + y ^ 2) * Real.exp (B * |y|) ≤
      4 * Real.exp (B ^ 2) * Real.exp (-(1 / 2) * y ^ 2) := by
  have h1 : 1 + y ^ 2 ≤ 4 * Real.exp (y ^ 2 / 4) := by
    linarith [Real.add_one_le_exp (y ^ 2 / 4)]
  have h2 : B * |y| ≤ y ^ 2 / 4 + B ^ 2 := by
    nlinarith [sq_nonneg (|y| / 2 - B), sq_abs y]
  have h3 : Real.exp (B * |y|) ≤ Real.exp (y ^ 2 / 4 + B ^ 2) := Real.exp_le_exp.mpr h2
  calc Real.exp (-y ^ 2) * (1 + y ^ 2) * Real.exp (B * |y|)
      ≤ Real.exp (-y ^ 2) * (4 * Real.exp (y ^ 2 / 4)) * Real.exp (y ^ 2 / 4 + B ^ 2) := by
        gcongr
    _ = 4 * Real.exp (B ^ 2) * Real.exp (-(1 / 2) * y ^ 2) := by
        have e : Real.exp (-y ^ 2) * Real.exp (y ^ 2 / 4) * Real.exp (y ^ 2 / 4 + B ^ 2) =
            Real.exp (B ^ 2) * Real.exp (-(1 / 2) * y ^ 2) := by
          rw [← Real.exp_add, ← Real.exp_add, ← Real.exp_add]
          congr 1
          ring
        linear_combination 4 * e

theorem Q_le (n A : ℝ) (hA : 0 ≤ A) :
    (n ^ 2 + A) / n ^ 2 ≤ (A + 1) * (1 + 1 / n ^ 2) := by
  rcases eq_or_ne n 0 with h | h
  · subst h
    simp
    positivity
  · have hn : 0 < n ^ 2 := by positivity
    rw [add_div, div_self hn.ne']
    have : A / n ^ 2 = A * (1 / n ^ 2) := by ring
    rw [this]
    nlinarith [mul_le_mul_of_nonneg_right (by linarith : A ≤ A + 1)
      (by positivity : (0 : ℝ) ≤ 1 / n ^ 2)]

/-- The integrand of `V` on a strip `σ₀ ≤ Re s ≤ σ₁`, `|Re s| ≥ δ > 0`:
`‖G(s)/s·g(s,t)·x^(−s)‖ ≤ C (1 + ‖α+β‖^(−2)) (t/2π)^σ x^(−σ) e^(−y²/2)`. -/
theorem integrand_bound {σ₀ σ₁ δ : ℝ} (h0 : -(2 / 5) < σ₀) (hδ : 0 < δ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x → ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ → δ ≤ ‖(σ : ℂ) + y * I‖ →
        ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) *
            Real.exp (-(1 / 2) * y ^ 2) := by
  obtain ⟨Cg, hCg0, hCg⟩ := gY_bound (σ₁ := σ₁) h0
  set M : ℝ := |σ₀| + |σ₁| with hM
  set B : ℝ := Real.pi / 2 + M / 2 + 1 / 2 with hB
  refine ⟨Real.exp (M ^ 2) * (4 * M ^ 2 + 5) * (1 / δ) * Cg * (4 * Real.exp (B ^ 2)),
    by positivity, fun α β hα hβ t ht x hx σ y hσ0 hσ1 hδσ => ?_⟩
  set s : ℂ := (σ : ℂ) + y * I with hs
  have hsre : s.re = σ := by simp [hs]
  have hsim : s.im = y := by simp [hs]
  have hσM : |s.re| ≤ M := by
    rw [hsre, abs_le]; constructor <;>
      linarith [neg_abs_le σ₀, le_abs_self σ₁, abs_nonneg σ₀, abs_nonneg σ₁]
  have hG := ApproxShift.GY_norm_le (α := α) (β := β) hσM
  rw [hsim] at hG
  have hQ := Q_le ‖α + β‖ (4 * M ^ 2 + 4) (by positivity)
  have hQ' : (‖α + β‖ ^ 2 + 4 * M ^ 2 + 4) / ‖α + β‖ ^ 2 ≤
      (4 * M ^ 2 + 5) * (1 + 1 / ‖α + β‖ ^ 2) := by
    have e : ‖α + β‖ ^ 2 + 4 * M ^ 2 + 4 = ‖α + β‖ ^ 2 + (4 * M ^ 2 + 4) := by ring
    rw [e]
    linarith
  have hs0 : δ ≤ ‖s‖ := hδσ
  have hδ0 : 0 < ‖s‖ := lt_of_lt_of_le hδ hs0
  have hg := hCg α β hα hβ t ht σ y hσ0 hσ1
  have hx' : ‖(x : ℂ) ^ (-s)‖ = x ^ (-σ) := by
    rw [norm_cpow_eq_rpow_re_of_pos hx]
    simp [hsre]
  have hab := gauss_absorb B y
  have hEM : Real.exp (M ^ 2 - y ^ 2) = Real.exp (M ^ 2) * Real.exp (-y ^ 2) := by
    rw [← Real.exp_add]; ring_nf
  set P : ℝ := (t / (2 * Real.pi)) ^ σ * x ^ (-σ)
  have hP : 0 ≤ P := by positivity
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2
  have hN : 0 ≤ N := by positivity
  rw [norm_mul, KY, norm_mul, norm_div, hx']
  have hinv : 1 / ‖s‖ ≤ 1 / δ := one_div_le_one_div_of_le hδ hs0
  calc ‖GY α β s‖ / ‖s‖ * ‖gY α β t s‖ * x ^ (-σ)
      = ‖GY α β s‖ * (1 / ‖s‖) * ‖gY α β t s‖ * x ^ (-σ) := by ring
    _ ≤ (Real.exp (M ^ 2 - y ^ 2) * ((4 * M ^ 2 + 5) * N * (1 + y ^ 2))) * (1 / δ) *
          (Cg * (t / (2 * Real.pi)) ^ σ * Real.exp (B * |y|)) * x ^ (-σ) := by
        gcongr
        exact hG.trans (mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_right hQ' (by positivity)) (Real.exp_pos _).le)
    _ = Real.exp (M ^ 2) * (4 * M ^ 2 + 5) * (1 / δ) * Cg * N * P *
          (Real.exp (-y ^ 2) * (1 + y ^ 2) * Real.exp (B * |y|)) := by
        rw [hEM]; ring
    _ ≤ Real.exp (M ^ 2) * (4 * M ^ 2 + 5) * (1 / δ) * Cg * N * P *
          (4 * Real.exp (B ^ 2) * Real.exp (-(1 / 2) * y ^ 2)) := by
        gcongr
    _ = Real.exp (M ^ 2) * (4 * M ^ 2 + 5) * (1 / δ) * Cg * (4 * Real.exp (B ^ 2)) * N * P *
          Real.exp (-(1 / 2) * y ^ 2) := by ring

theorem norm_VY_le (α β : ℂ) (σ x t : ℝ) :
    ‖VY α β σ x t‖ ≤ 1 / (2 * Real.pi) *
      ∫ y : ℝ, ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ := by
  rw [VY, VerticalIntegral', VerticalIntegral, norm_smul, norm_smul, Complex.norm_I, one_mul]
  have h1 : ‖(1 / (2 * Real.pi * I) : ℂ)‖ = 1 / (2 * Real.pi) := by
    rw [norm_div, norm_one, norm_mul, norm_mul, Complex.norm_I, Complex.norm_real,
      Real.norm_eq_abs, abs_of_pos Real.pi_pos]
    norm_num
  rw [h1]
  exact mul_le_mul_of_nonneg_left (norm_integral_le_integral_norm _) (by positivity)

/-- `V` on one line `Re s = σ`, `σ ≠ 0`, `σ > −2/5`:
`‖V_σ(x,t)‖ ≤ C (1 + ‖α+β‖^(−2)) (t/2π)^σ x^(−σ)`. -/
theorem VY_line_bound {σ : ℝ} (h0 : -(2 / 5) < σ) (hσ : σ ≠ 0) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x →
        ‖VY α β σ x t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) := by
  obtain ⟨C, hC0, hC⟩ := integrand_bound (σ₀ := σ) (σ₁ := σ) (δ := |σ|) h0 (abs_pos.mpr hσ)
  refine ⟨C * Real.sqrt (2 * Real.pi) / (2 * Real.pi), by positivity,
    fun α β hα hβ t ht x hx => ?_⟩
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2
  set P : ℝ := (t / (2 * Real.pi)) ^ σ * x ^ (-σ)
  have hgi : Integrable (fun y : ℝ => C * N * P * Real.exp (-(1 / 2) * y ^ 2)) :=
    (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 2)).const_mul _
  have hle : ∫ y : ℝ, ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ ≤
      ∫ y : ℝ, C * N * P * Real.exp (-(1 / 2) * y ^ 2) := by
    apply integral_mono_of_nonneg (ae_of_all _ fun y => norm_nonneg _) hgi
    exact ae_of_all _ fun y => hC α β hα hβ t ht x hx σ y le_rfl le_rfl
      (by simpa using Complex.abs_re_le_norm ((σ : ℂ) + y * I))
  rw [integral_const_mul, integral_gaussian] at hle
  have hpi : Real.sqrt (Real.pi / (1 / 2)) = Real.sqrt (2 * Real.pi) := by
    congr 1; ring
  rw [hpi] at hle
  calc ‖VY α β σ x t‖ ≤ 1 / (2 * Real.pi) *
        ∫ y : ℝ, ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ := norm_VY_le _ _ _ _ _
    _ ≤ 1 / (2 * Real.pi) * (C * N * P * Real.sqrt (2 * Real.pi)) :=
        mul_le_mul_of_nonneg_left hle (by positivity)
    _ = C * Real.sqrt (2 * Real.pi) / (2 * Real.pi) * N * P := by ring

/-- The integrand of `V` is holomorphic on `Re s > 0`. -/
theorem integrand_differentiableAt {α β : ℂ} {t x : ℝ} (hx : 0 < x) (hα : -(1 / 2) < α.re)
    (hβ : -(1 / 2) < β.re) {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s := by
  have hs0 : s ≠ 0 := by
    intro h; rw [h] at hs; simp at hs
  have h1 : Gammaℝ (uA α t + s) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, uA_re]; linarith)
  have h2 : Gammaℝ (vB β t + s) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, vB_re]; linarith)
  have hx0 : (x : ℂ) ≠ 0 := by exact_mod_cast hx.ne'
  exact (KY_differentiableAt hs0 h1 h2).mul
    ((differentiableAt_id.neg).const_cpow (Or.inl hx0))

/-- `b^σ ≤ b^σ₀ + b^σ₁` for `σ₀ ≤ σ ≤ σ₁`. -/
theorem rpow_le_ends {b σ₀ σ σ₁ : ℝ} (hb : 0 < b) (h0 : σ₀ ≤ σ) (h1 : σ ≤ σ₁) :
    b ^ σ ≤ b ^ σ₀ + b ^ σ₁ := by
  rcases le_or_gt 1 b with h | h
  · have := Real.rpow_le_rpow_of_exponent_le h h1
    linarith [Real.rpow_nonneg hb.le σ₀]
  · have := Real.rpow_le_rpow_of_exponent_ge hb h.le h0
    linarith [Real.rpow_nonneg hb.le σ₁]

/-- PNT+'s `RectangleIntegral_tendsTo_VerticalIntegral` for `[a, b]` (ApproxShift's
`rect_tendsto` is the case `[−c, c]`). -/
theorem rect_tendsto_ab {f : ℂ → ℂ} {a b : ℝ}
    (hbot : Tendsto (fun y : ℝ => ∫ x : ℝ in a..b, f (x + y * I)) atBot (𝓝 0))
    (htop : Tendsto (fun y : ℝ => ∫ x : ℝ in a..b, f (x + y * I)) atTop (𝓝 0))
    (hleft : Integrable (fun y : ℝ => f (↑a + y * I)))
    (hright : Integrable (fun y : ℝ => f (↑b + y * I))) :
    Tendsto (fun T : ℝ => RectangleIntegral f (↑a - I * T) (↑b + I * T)) atTop
      (𝓝 (VerticalIntegral f b - VerticalIntegral f a)) := by
  simp only [RectangleIntegral, sub_re, ofReal_re, mul_re, I_re, zero_mul, I_im, ofReal_im,
    mul_zero, sub_self, sub_zero, add_re, add_zero, sub_im, mul_im, one_mul, zero_add, zero_sub,
    add_im]
  apply Tendsto.sub
  · rewrite [← zero_add (VerticalIntegral _ _), ← zero_sub_zero]
    apply Tendsto.add <| Tendsto.sub (hbot.comp tendsto_neg_atTop_atBot) htop
    exact (intervalIntegral_tendsto_integral hright tendsto_neg_atTop_atBot tendsto_id).const_smul I
  · exact (intervalIntegral_tendsto_integral hleft tendsto_neg_atTop_atBot tendsto_id).const_smul I

/-- `V` does not depend on the line: `V_c = V_{c'}` for `0 < c ≤ c'` (Cauchy on the rectangle
`[c, c'] × [−T, T]`, the horizontal edges `→ 0` by the Gaussian). -/
theorem VY_line_eq {c c' : ℝ} (hc : 0 < c) (hcc : c ≤ c') {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) {x : ℝ} (hx : 0 < x) :
    VY α β c x t = VY α β c' x t := by
  obtain ⟨C, hC0, hC⟩ := integrand_bound (σ₀ := c) (σ₁ := c') (δ := c) (by linarith) hc
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  set f : ℂ → ℂ := fun s => KY α β t s * (x : ℂ) ^ (-s) with hf
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2
  have hdiff : ∀ s : ℂ, 0 < s.re → DifferentiableAt ℂ f s := fun s hs =>
    integrand_differentiableAt hx (by linarith) (by linarith) hs
  have hb : ∀ σ y : ℝ, c ≤ σ → σ ≤ c' → ‖f (σ + y * I)‖ ≤
      C * N * (((t / (2 * Real.pi)) ^ c + (t / (2 * Real.pi)) ^ c') * (x ^ (-c') + x ^ (-c))) *
        Real.exp (-(1 / 2) * y ^ 2) := by
    intro σ y h1 h2
    have h := hC α β hα hβ t ht x hx σ y h1 h2
      (h1.trans (by simpa using Complex.re_le_norm ((σ : ℂ) + y * I)))
    refine h.trans ?_
    gcongr
    · exact rpow_le_ends (by positivity) h1 h2
    · exact rpow_le_ends hx (by linarith) (by linarith)
  set H : ℝ := C * N * (((t / (2 * Real.pi)) ^ c + (t / (2 * Real.pi)) ^ c') *
    (x ^ (-c') + x ^ (-c)))
  have hH : 0 ≤ H := by positivity
  -- the two lines are integrable
  have hline : ∀ σ : ℝ, c ≤ σ → σ ≤ c' → Integrable fun y : ℝ => f (↑σ + y * I) := by
    intro σ h1 h2
    have hcont : Continuous fun y : ℝ => f (↑σ + y * I) :=
      continuous_iff_continuousAt.mpr fun y => ContinuousAt.comp (g := f)
        (f := fun y : ℝ => (σ : ℂ) + y * I) (hdiff _ (by simp; linarith)).continuousAt
        (by fun_prop)
    exact Integrable.mono' ((integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 2)).const_mul H)
      hcont.aestronglyMeasurable (ae_of_all _ fun y => hb σ y h1 h2)
  -- the horizontal edges
  have hhb : ∀ y : ℝ, ‖∫ σ : ℝ in c..c', f (σ + y * I)‖ ≤
      H * Real.exp (-(1 / 2) * y ^ 2) * |c' - c| := by
    intro y
    apply intervalIntegral.norm_integral_le_of_norm_le_const
    intro σ hσ
    rw [Set.uIoc_of_le hcc] at hσ
    exact hb σ y hσ.1.le hσ.2
  have hlim : ∀ l : Filter ℝ, Tendsto (fun y : ℝ => Real.exp (-(1 / 2) * y ^ 2)) l (𝓝 0) →
      Tendsto (fun y : ℝ => H * Real.exp (-(1 / 2) * y ^ 2) * |c' - c|) l (𝓝 0) := by
    intro l hl
    simpa using (hl.const_mul H).mul_const |c' - c|
  have htop : Tendsto (fun y : ℝ => ∫ σ : ℝ in c..c', f (σ + y * I)) atTop (𝓝 0) :=
    squeeze_zero_norm hhb (hlim _ ApproxShift.gauss_atTop)
  have hbot : Tendsto (fun y : ℝ => ∫ σ : ℝ in c..c', f (σ + y * I)) atBot (𝓝 0) :=
    squeeze_zero_norm hhb (hlim _ ApproxShift.gauss_atBot)
  have hrect := rect_tendsto_ab hbot htop (hline c le_rfl hcc) (hline c' hcc le_rfl)
  have hzero : ∀ T : ℝ, RectangleIntegral f (↑c - I * T) (↑c' + I * T) = 0 := by
    intro T
    apply HolomorphicOn.vanishesOnRectangle (U := {s : ℂ | 0 < s.re})
    · intro s hs
      exact (hdiff s hs).differentiableWithinAt
    · intro p hp
      rw [Rectangle, Complex.mem_reProdIm] at hp
      have h1 := hp.1
      simp only [sub_re, ofReal_re, mul_re, I_re, zero_mul, I_im, ofReal_im, mul_zero,
        sub_self, sub_zero, add_re, add_zero] at h1
      rw [Set.uIcc_of_le hcc] at h1
      show 0 < p.re
      linarith [h1.1]
  have h0 : Tendsto (fun T : ℝ => RectangleIntegral f (↑c - I * T) (↑c' + I * T)) atTop (𝓝 0) := by
    simp only [hzero]
    exact tendsto_const_nhds
  have heq := tendsto_nhds_unique hrect h0
  have heq' : VerticalIntegral f c' = VerticalIntegral f c := sub_eq_zero.mp heq
  simp only [VY, VerticalIntegral']
  rw [← hf, heq']

/-- **Target 3**, the `j = 0` case of Young's (4.3) for `x ≥ t`, with the direction read off
the integral: shifting right, `‖V_{α,β}(x,t)‖ ≤ C_A (1 + ‖α+β‖^(−2)) (t/x)^A` for every
`A > 0`, on every line `c > 0` (so for Young's `c = 1`), uniformly in `‖α‖, ‖β‖ ≤ 1/10`,
`t ≥ 1`, `x > 0`. Large `x/t` makes `V` small. -/
theorem VY_decay {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖VY α β c x t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * (t / x) ^ A := by
  obtain ⟨C, hC0, hC⟩ := VY_line_bound (σ := A) (by linarith) hA.ne'
  refine ⟨C, hC0, fun α β hα hβ t ht x hx c hc => ?_⟩
  have ht0 : 0 < t := by linarith
  have hline : VY α β c x t = VY α β A x t := by
    rcases le_total c A with h | h
    · exact VY_line_eq hc h hα hβ ht hx
    · exact (VY_line_eq hA h hα hβ ht hx).symm
  rw [hline]
  refine (hC α β hα hβ t ht x hx).trans ?_
  apply mul_le_mul_of_nonneg_left _ (by positivity)
  have h2pi : 1 ≤ (2 * Real.pi) ^ A :=
    Real.one_le_rpow (by linarith [Real.pi_gt_three]) hA.le
  rw [Real.div_rpow ht0.le (by positivity), Real.div_rpow ht0.le hx.le, Real.rpow_neg hx.le]
  have hxA : 0 < x ^ A := by positivity
  have htA : 0 < t ^ A := by positivity
  rw [div_mul_eq_mul_div, div_le_div_iff₀ (by positivity) hxA]
  have : t ^ A * (x ^ A)⁻¹ * x ^ A = t ^ A := by field_simp; try ring
  rw [this]
  nlinarith

/-- The integrand of `V` is differentiable at `s ≠ 0` with `Re s > −2/5`. -/
theorem integrand_differentiableAt' {α β : ℂ} {t x : ℝ} (hx : 0 < x) (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ} (hs : -(2 / 5) < s.re) (hs0 : s ≠ 0) :
    DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have h1 : Gammaℝ (uA α t + s) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, uA_re]; linarith)
  have h2 : Gammaℝ (vB β t + s) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, vB_re]; linarith)
  have hx0 : (x : ℂ) ≠ 0 := by exact_mod_cast hx.ne'
  exact (KY_differentiableAt hs0 h1 h2).mul
    ((differentiableAt_id.neg).const_cpow (Or.inl hx0))

/-- The residue at `s = 0`, moving left: `V_{1/4}(x,t) − V_{−1/4}(x,t) = G(0) g(0) = 1` for
`α + β ≠ 0` (`ContourShift.residue_rectangle_of_local` on `[−1/4, 1/4] × [−T, T]`). -/
theorem VY_residue {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {t : ℝ} (ht : 1 ≤ t) {x : ℝ} (hx : 0 < x) :
    VY α β (1 / 4) x t - VY α β (-(1 / 4)) x t = 1 := by
  obtain ⟨C, hC0, hC⟩ := integrand_bound (σ₀ := -(1 / 4)) (σ₁ := 1 / 4) (δ := 1 / 4)
    (by norm_num) (by norm_num)
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  set f : ℂ → ℂ := fun s => KY α β t s * (x : ℂ) ^ (-s) with hf
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2
  set H : ℝ := C * N * (((t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) + (t / (2 * Real.pi)) ^ (1 / 4 : ℝ)) *
    (x ^ (-(1 / 4) : ℝ) + x ^ (-(-(1 / 4)) : ℝ)))
  have hH : 0 ≤ H := by positivity
  have hb : ∀ σ y : ℝ, -(1 / 4) ≤ σ → σ ≤ 1 / 4 → 1 / 4 ≤ ‖(σ : ℂ) + y * I‖ →
      ‖f (σ + y * I)‖ ≤ H * Real.exp (-(1 / 2) * y ^ 2) := by
    intro σ y h1 h2 h3
    refine (hC α β hα hβ t ht x hx σ y h1 h2 h3).trans ?_
    have ht2 : 0 < t / (2 * Real.pi) := div_pos (by linarith) (by positivity)
    simp only [H, N]
    gcongr
    all_goals first
      | exact rpow_le_ends ht2 h1 h2
      | exact rpow_le_ends hx (by linarith) (by linarith)
  -- the two lines
  have hline : ∀ σ : ℝ, |σ| = 1 / 4 → Integrable fun y : ℝ => f (↑σ + y * I) := by
    intro σ hσ
    have hσ' := abs_le.mp hσ.le
    have hcont : Continuous fun y : ℝ => f (↑σ + y * I) :=
      continuous_iff_continuousAt.mpr fun y => ContinuousAt.comp (g := f)
        (f := fun y : ℝ => (σ : ℂ) + y * I)
        (integrand_differentiableAt' hx hα hβ (by simp; linarith) (by
          intro h
          have := congrArg Complex.re h
          simp at this
          rw [this] at hσ
          norm_num at hσ)).continuousAt (by fun_prop)
    exact Integrable.mono' ((integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 2)).const_mul H)
      hcont.aestronglyMeasurable (ae_of_all _ fun y => hb σ y hσ'.1 hσ'.2
        (by rw [← hσ]; simpa using Complex.abs_re_le_norm ((σ : ℂ) + y * I)))
  -- the horizontal edges
  have hhb : ∀ y : ℝ, 1 ≤ |y| → ‖∫ σ : ℝ in (-(1 / 4))..(1 / 4), f (σ + y * I)‖ ≤
      H * Real.exp (-(1 / 2) * y ^ 2) * |1 / 4 - -(1 / 4)| := by
    intro y hy
    apply intervalIntegral.norm_integral_le_of_norm_le_const
    intro σ hσ
    rw [Set.uIoc_of_le (by norm_num)] at hσ
    exact hb σ y hσ.1.le hσ.2 (by
      have := Complex.abs_im_le_norm ((σ : ℂ) + y * I)
      simp at this
      linarith)
  have hlim : ∀ l : Filter ℝ, Tendsto (fun y : ℝ => Real.exp (-(1 / 2) * y ^ 2)) l (𝓝 0) →
      Tendsto (fun y : ℝ => H * Real.exp (-(1 / 2) * y ^ 2) * |(1 / 4 : ℝ) - -(1 / 4)|) l (𝓝 0) := by
    intro l hl
    simpa using (hl.const_mul H).mul_const |(1 / 4 : ℝ) - -(1 / 4)|
  have htop : Tendsto (fun y : ℝ => ∫ σ : ℝ in (-(1 / 4))..(1 / 4), f (σ + y * I)) atTop (𝓝 0) := by
    refine squeeze_zero_norm' ?_ (hlim _ ApproxShift.gauss_atTop)
    filter_upwards [eventually_ge_atTop 1] with y hy
    exact hhb y (by rw [abs_of_nonneg (by linarith)]; exact hy)
  have hbot : Tendsto (fun y : ℝ => ∫ σ : ℝ in (-(1 / 4))..(1 / 4), f (σ + y * I)) atBot (𝓝 0) := by
    refine squeeze_zero_norm' ?_ (hlim _ ApproxShift.gauss_atBot)
    filter_upwards [eventually_le_atBot (-1)] with y hy
    exact hhb y (by rw [abs_of_neg (by linarith)]; linarith)
  have hrect := ApproxShift.rect_tendsto (c := 1 / 4) hbot htop
    (hline (-(1 / 4)) (by norm_num)) (hline (1 / 4) (by norm_num))
  -- the residue at `0`
  have hu : Gammaℝ (uA α t) ≠ 0 := Gammaℝ_ne_zero_of_re_pos (by rw [uA_re]; linarith)
  have hv : Gammaℝ (vB β t) ≠ 0 := Gammaℝ_ne_zero_of_re_pos (by rw [vB_re]; linarith)
  set U : Set ℂ := {s : ℂ | -(1 / 3) < s.re} with hU
  have hUo : IsOpen U := isOpen_lt continuous_const Complex.continuous_re
  set Kf : ℂ → ℂ := fun s => GY α β s * gY α β t s * (x : ℂ) ^ (-s) with hKf
  have hKd : DifferentiableOn ℂ Kf U := by
    intro s hs
    have hs' : -(1 / 3) < s.re := hs
    have h1 : Gammaℝ (uA α t + s) ≠ 0 :=
      Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, uA_re]; linarith)
    have h2 : Gammaℝ (vB β t + s) ≠ 0 :=
      Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, vB_re]; linarith)
    have hx0 : (x : ℂ) ≠ 0 := by exact_mod_cast hx.ne'
    have hg1 : DifferentiableAt ℂ (fun s => Gammaℝ (uA α t + s)) s :=
      (differentiableAt_Gammaℝ h1).comp s (by fun_prop)
    have hg2 : DifferentiableAt ℂ (fun s => Gammaℝ (vB β t + s)) s :=
      (differentiableAt_Gammaℝ h2).comp s (by fun_prop)
    have hg : DifferentiableAt ℂ (gY α β t) s := by
      unfold gY
      exact (hg1.mul hg2).div_const _
    exact ((((ApproxShift.GY_analyticAt α β s).differentiableAt).mul hg).mul
      ((differentiableAt_id.neg).const_cpow (Or.inl hx0))).differentiableWithinAt
  have hKa : AnalyticAt ℂ Kf 0 :=
    hKd.analyticAt (hUo.mem_nhds (by simp [hU]))
  have hres : ∀ T : ℝ, 1 ≤ T →
      RectangleIntegral' f (↑(-(1 / 4 : ℝ)) - I * ↑T) (↑(1 / 4 : ℝ) + I * ↑T) = 1 := by
    intro T hT
    have hmain := ContourShift.residue_rectangle_of_local (f := f) (P := {0})
      (A := fun _ => 1) (z := ↑(-(1 / 4 : ℝ)) - I * ↑T) (w := ↑(1 / 4 : ℝ) + I * ↑T)
      (by simp) (by simp; linarith)
      (by
        intro p hp
        rw [Finset.mem_singleton] at hp
        subst hp
        exact ApproxShift.rect_mem_nhds (by norm_num) (by simp; linarith))
      (by
        intro s hs
        have hs1 := hs.1
        have hs2 : s ≠ 0 := by simpa using hs.2
        rw [Rectangle, Complex.mem_reProdIm] at hs1
        have hre := hs1.1
        simp only [sub_re, ofReal_re, mul_re, I_re, zero_mul, I_im, ofReal_im, mul_zero,
          sub_self, sub_zero, add_re, add_zero] at hre
        rw [Set.uIcc_of_le (by norm_num)] at hre
        exact (integrand_differentiableAt' hx hα hβ (by linarith [hre.1]) hs2).differentiableWithinAt)
      (by
        intro p hp
        rw [Finset.mem_singleton] at hp
        subst hp
        refine ApproxShift.local_simple (K := Kf) (φ := fun _ => 0) (a := 1) hKa analyticAt_const
          ?_ ?_
        · simp only [hKf, GY_zero hαβ, gY_zero hu hv, neg_zero, Complex.cpow_zero, mul_one]
        · intro s
          simp only [hf, hKf, KY, zero_add, sub_zero, one_div]
          ring)
    rw [hmain, Finset.sum_singleton]
  have hlim2 : Tendsto (fun T : ℝ =>
      RectangleIntegral' f (↑(-(1 / 4 : ℝ)) - I * ↑T) (↑(1 / 4 : ℝ) + I * ↑T)) atTop
      (𝓝 ((1 / (2 * Real.pi * I)) • (VerticalIntegral f (1 / 4) - VerticalIntegral f (-(1 / 4))))) :=
    hrect.const_smul _
  have hlim1 : Tendsto (fun T : ℝ =>
      RectangleIntegral' f (↑(-(1 / 4 : ℝ)) - I * ↑T) (↑(1 / 4 : ℝ) + I * ↑T)) atTop (𝓝 1) :=
    tendsto_const_nhds.congr' (by
      filter_upwards [eventually_ge_atTop 1] with T hT
      exact (hres T hT).symm)
  have heq := tendsto_nhds_unique hlim2 hlim1
  simp only [VY, VerticalIntegral']
  rw [← hf, ← smul_sub]
  exact heq

theorem rpow_quarter_le {b : ℝ} (hb : 0 ≤ b) : b ^ (1 / 4 : ℝ) ≤ 1 + b := by
  rcases le_or_gt b 1 with h | h
  · have := Real.rpow_le_one hb h (by norm_num : (0 : ℝ) ≤ 1 / 4)
    linarith
  · have := Real.rpow_le_rpow_of_exponent_le h.le (by norm_num : (1 / 4 : ℝ) ≤ 1)
    rw [Real.rpow_one] at this
    linarith

/-- **Target 3 in Young's form**, the `j = 0` case of (4.3) with the direction the integral
gives: `‖V_{α,β}(x,t)‖ ≤ C_A (1 + ‖α+β‖^(−2)) (1 + x/t)^(−A)` for every `A > 0`, every
`x > 0`, every line `c > 0`, uniformly in `‖α‖, ‖β‖ ≤ 1/10` with `α + β ≠ 0`, `t ≥ 1`.
For `x ≤ t` it is the residue `1` plus the line `−1/4` (`VY_residue`); for `x ≥ t`, `VY_decay`. -/
theorem VY_decay_young {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖VY α β c x t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A) := by
  obtain ⟨C₁, hC₁0, hC₁⟩ := VY_decay hA
  obtain ⟨C₂, hC₂0, hC₂⟩ := VY_line_bound (σ := -(1 / 4)) (by norm_num) (by norm_num)
  have h2A : 1 ≤ (2 : ℝ) ^ A := Real.one_le_rpow (by norm_num) hA.le
  refine ⟨(1 + 8 * C₂) * 2 ^ A + C₁ * 2 ^ A, by positivity,
    fun α β hα hβ hαβ t ht x hx c hc => ?_⟩
  have ht0 : 0 < t := by linarith
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  have hN1 : 1 ≤ N := by
    have : 0 ≤ 1 / ‖α + β‖ ^ 2 := by positivity
    linarith
  have hq : 0 < 1 + x / t := by positivity
  have hqA : 0 < (1 + x / t) ^ A := by positivity
  have hneg : (1 + x / t) ^ (-A) = ((1 + x / t) ^ A)⁻¹ := Real.rpow_neg hq.le A
  rcases le_or_gt x t with hxt | hxt
  · -- `x ≤ t`: the residue and the line `−1/4`
    have hline : VY α β c x t = VY α β (1 / 4) x t := by
      rcases le_total c (1 / 4) with h | h
      · exact VY_line_eq hc h hα hβ ht hx
      · exact (VY_line_eq (by norm_num) h hα hβ ht hx).symm
    have hres := VY_residue hα hβ hαβ ht hx
    have hV : VY α β c x t = 1 + VY α β (-(1 / 4)) x t := by
      rw [hline]; linear_combination hres
    have hb := hC₂ α β hα hβ t ht x hx
    have hP : (t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) * x ^ (-(-(1 / 4)) : ℝ) ≤ 8 := by
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
    have hVn : ‖VY α β c x t‖ ≤ (1 + 8 * C₂) * N := by
      rw [hV]
      refine (norm_add_le _ _).trans ?_
      rw [norm_one]
      have : C₂ * N * ((t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) * x ^ (-(-(1 / 4)) : ℝ)) ≤
          C₂ * N * 8 := mul_le_mul_of_nonneg_left hP (by positivity)
      nlinarith
    have hlow : (2 : ℝ) ^ (-A) ≤ (1 + x / t) ^ (-A) :=
      Real.rpow_le_rpow_of_nonpos hq (by linarith [(div_le_one ht0).mpr hxt]) (by linarith)
    have h2 : (2 : ℝ) ^ A * (2 : ℝ) ^ (-A) = 1 := by
      rw [← Real.rpow_add (by norm_num), add_neg_cancel, Real.rpow_zero]
    calc ‖VY α β c x t‖ ≤ (1 + 8 * C₂) * N := hVn
      _ = (1 + 8 * C₂) * 2 ^ A * N * (2 : ℝ) ^ (-A) := by
          linear_combination (-(1 + 8 * C₂) * N) * h2
      _ ≤ (1 + 8 * C₂) * 2 ^ A * N * (1 + x / t) ^ (-A) := by gcongr
      _ ≤ ((1 + 8 * C₂) * 2 ^ A + C₁ * 2 ^ A) * N * (1 + x / t) ^ (-A) := by
          gcongr
          nlinarith [Real.rpow_nonneg (by norm_num : (0 : ℝ) ≤ 2) A]
  · -- `x > t`: shift right
    have hb := hC₁ α β hα hβ t ht x hx c hc
    have hkey : (t / x) ^ A ≤ 2 ^ A * (1 + x / t) ^ (-A) := by
      rw [hneg, ← div_eq_mul_inv, le_div_iff₀ hqA, ← Real.mul_rpow (by positivity) hq.le]
      apply Real.rpow_le_rpow (by positivity) _ hA.le
      have : t / x * (1 + x / t) = t / x + 1 := by field_simp; try ring
      rw [this]
      have : t / x ≤ 1 := by rw [div_le_one hx]; linarith
      linarith
    calc ‖VY α β c x t‖ ≤ C₁ * N * (t / x) ^ A := hb
      _ ≤ C₁ * N * (2 ^ A * (1 + x / t) ^ (-A)) := by gcongr
      _ = C₁ * 2 ^ A * N * (1 + x / t) ^ (-A) := by ring
      _ ≤ ((1 + 8 * C₂) * 2 ^ A + C₁ * 2 ^ A) * N * (1 + x / t) ^ (-A) := by
          gcongr
          nlinarith [Real.rpow_nonneg (by norm_num : (0 : ℝ) ≤ 2) A]

/-! ## Target 2: the size of `resY` -/

theorem lY_le_abs (Y : ℝ) : lY Y ≤ |Y| := by
  unfold lY
  have h1 : 1 + Y ^ 2 ≤ (1 + |Y|) ^ 2 := by nlinarith [sq_abs Y, abs_nonneg Y]
  have h2 := Real.log_le_log (by positivity) h1
  rw [Real.log_pow] at h2
  have h3 : Real.log (1 + |Y|) ≤ |Y| := by
    have := Real.log_le_sub_one_of_pos (by positivity : (0 : ℝ) < 1 + |Y|)
    linarith
  simp only [Nat.cast_ofNat] at h2
  linarith

/-- A lower bound for `‖Gammaℝ w‖`, `Re w = 1/2 + a`, `Im w = 2Y₀`:
`log ‖Gammaℝ w‖ ≥ −2K − |log Γ(1/2)| − (π/2 + 1)|Y₀|`. -/
theorem gR_lower {w : ℂ} {a Y₀ K : ℝ} (hre : w.re = 1 / 2 + a) (him : w.im = 2 * Y₀)
    (ha : |a| ≤ 1 / 10)
    (hK : |Real.log (Real.Gamma ((1 / 2 + a) / 2))| ≤ K ∧ gErr ((1 / 2 + a) / 2) ≤ K) :
    -(2 * K + |Real.log (Real.Gamma (1 / 2))|) - (Real.pi / 2 + 1) * |Y₀| ≤
      Real.log ‖Gammaℝ w‖ := by
  have ha' := abs_le.mp ha
  have hw0 : 0 < w.re := by rw [hre]; linarith
  have e0 := abs_le.mp (log_norm_Gammaℝ_approx hw0)
  rw [hre] at e0
  have hmod : gRModel w = (1 / 2 - a) / 2 * Real.log Real.pi +
      Real.log (Real.Gamma ((1 / 2 + a) / 2)) - Real.log (Real.Gamma (1 / 2)) -
      Real.pi * |Y₀| / 2 + ((1 / 2 + a) / 2 - 1 / 2) * lY Y₀ := by
    unfold gRModel gModel
    rw [hre, him]
    have : 2 * Y₀ / 2 = Y₀ := by ring
    rw [this]
    ring
  have hlp : 0 ≤ Real.log Real.pi := Real.log_nonneg (by linarith [Real.pi_gt_three])
  have h1 : 0 ≤ (1 / 2 - a) / 2 * Real.log Real.pi := mul_nonneg (by linarith) hlp
  have h2 := lY_le_abs Y₀
  have h3 := lY_nonneg Y₀
  have h4 : ((1 / 2 + a) / 2 - 1 / 2) * lY Y₀ ≥ -|Y₀| := by nlinarith
  have g1 := abs_le.mp hK.1
  have g2 := le_abs_self (Real.log (Real.Gamma (1 / 2)))
  have hY := abs_nonneg Y₀
  linarith [hK.2, g1.1, e0.1]

/-- One term of `resY`: `‖G(s)/d · Λ(w)‖`. -/
theorem resY_term {α β s d w : ℂ} {t M : ℝ} (ht : 1 ≤ t) (hM0 : 0 ≤ M)
    (hM : ∀ w : ℂ, |w.re| ≤ 2 → 1 ≤ |w.im| → ‖completedRiemannZeta w‖ ≤ M * (6 + 4 * ‖w‖))
    (hsre : |s.re| ≤ 1) (hsim1 : t - 1 / 10 ≤ |s.im|) (hsim2 : |s.im| ≤ t + 1 / 10)
    (hd : 2 / 5 ≤ ‖d‖) (hwre : |w.re| ≤ 2) (hwim : 1 ≤ |w.im|) (hwn : ‖w‖ ≤ 2 * t + 2) :
    ‖GY α β s / d * completedRiemannZeta w‖ ≤
      Real.exp (1 - (t - 1 / 10) ^ 2) * (9 * (1 + 1 / ‖α + β‖ ^ 2) * (1 + (t + 1 / 10) ^ 2)) *
        (5 / 2) * (M * (14 + 8 * t)) := by
  have hG := ApproxShift.GY_norm_le (α := α) (β := β) hsre
  have hQ := Q_le ‖α + β‖ 8 (by norm_num)
  have hQ' : (‖α + β‖ ^ 2 + 4 * 1 ^ 2 + 4) / ‖α + β‖ ^ 2 ≤ 9 * (1 + 1 / ‖α + β‖ ^ 2) := by
    have e : ‖α + β‖ ^ 2 + 4 * 1 ^ 2 + 4 = ‖α + β‖ ^ 2 + 8 := by ring
    rw [e]; linarith
  have hs1 : (t - 1 / 10) ^ 2 ≤ s.im ^ 2 := by
    rw [← sq_abs s.im]; exact pow_le_pow_left₀ (by linarith) hsim1 2
  have hs2 : s.im ^ 2 ≤ (t + 1 / 10) ^ 2 := by
    rw [← sq_abs s.im]; exact pow_le_pow_left₀ (abs_nonneg _) hsim2 2
  have hd0 : 0 < ‖d‖ := by linarith
  have hinv : 1 / ‖d‖ ≤ 5 / 2 := by
    rw [div_le_iff₀ hd0]; linarith
  have hL := hM w hwre hwim
  have hL' : ‖completedRiemannZeta w‖ ≤ M * (14 + 8 * t) :=
    hL.trans (mul_le_mul_of_nonneg_left (by linarith) hM0)
  have hGb : ‖GY α β s‖ ≤ Real.exp (1 - (t - 1 / 10) ^ 2) *
      (9 * (1 + 1 / ‖α + β‖ ^ 2) * (1 + (t + 1 / 10) ^ 2)) := by
    refine hG.trans ?_
    gcongr
    norm_num
  rw [norm_mul, norm_div]
  calc ‖GY α β s‖ / ‖d‖ * ‖completedRiemannZeta w‖
      = ‖GY α β s‖ * (1 / ‖d‖) * ‖completedRiemannZeta w‖ := by ring
    _ ≤ _ := by gcongr

/-- The Gaussian beats the rest: for `t ≥ 1`,
`e^(1−(t−1/10)²)(1+(t+1/10)²)(14+8t)e^((π/2+1)(t+1/10)) ≤ 14 e^(L²/2+2) e^(−t²/2)`,
`L = π/2 + 5`. -/
theorem poly_exp_bound {t : ℝ} (ht : 1 ≤ t) :
    Real.exp (1 - (t - 1 / 10) ^ 2) * (1 + (t + 1 / 10) ^ 2) * (14 + 8 * t) *
        Real.exp ((Real.pi / 2 + 1) * (t + 1 / 10)) ≤
      14 * Real.exp ((Real.pi / 2 + 5) ^ 2 / 2 + 2) * Real.exp (-(t ^ 2 / 2)) := by
  have h1 : 1 + (t + 1 / 10) ^ 2 ≤ Real.exp (2 * (t + 1 / 10)) := by
    have a := Real.add_one_le_exp (t + 1 / 10)
    have b : (t + 1 / 10 + 1) ^ 2 ≤ Real.exp (t + 1 / 10) ^ 2 :=
      pow_le_pow_left₀ (by linarith) a 2
    rw [← Real.exp_nat_mul] at b
    push_cast at b
    nlinarith
  have h2 : 14 + 8 * t ≤ 14 * Real.exp t := by
    linarith [Real.add_one_le_exp t]
  have hpi := Real.pi_le_four
  have hpi0 := Real.pi_pos
  have hE : 1 - (t - 1 / 10) ^ 2 + 2 * (t + 1 / 10) + t + (Real.pi / 2 + 1) * (t + 1 / 10) ≤
      (Real.pi / 2 + 5) ^ 2 / 2 + 2 + -(t ^ 2 / 2) := by
    nlinarith [sq_nonneg (t - (Real.pi / 2 + 5))]
  calc Real.exp (1 - (t - 1 / 10) ^ 2) * (1 + (t + 1 / 10) ^ 2) * (14 + 8 * t) *
        Real.exp ((Real.pi / 2 + 1) * (t + 1 / 10))
      ≤ Real.exp (1 - (t - 1 / 10) ^ 2) * Real.exp (2 * (t + 1 / 10)) * (14 * Real.exp t) *
        Real.exp ((Real.pi / 2 + 1) * (t + 1 / 10)) := by gcongr
    _ = 14 * Real.exp (1 - (t - 1 / 10) ^ 2 + 2 * (t + 1 / 10) + t +
          (Real.pi / 2 + 1) * (t + 1 / 10)) := by
        rw [Real.exp_add, Real.exp_add, Real.exp_add]; ring
    _ ≤ 14 * Real.exp ((Real.pi / 2 + 5) ^ 2 / 2 + 2 + -(t ^ 2 / 2)) := by gcongr
    _ = 14 * Real.exp ((Real.pi / 2 + 5) ^ 2 / 2 + 2) * Real.exp (-(t ^ 2 / 2)) := by
        rw [Real.exp_add]; ring

theorem resY_T1 {M : ℝ} (hM0 : 0 ≤ M)
    (hM : ∀ w : ℂ, |w.re| ≤ 2 → 1 ≤ |w.im| → ‖completedRiemannZeta w‖ ≤ M * (6 + 4 * ‖w‖))
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) :
    ‖GY α β (1 - uA α t) / (1 - uA α t) * completedRiemannZeta (vB β t + 1 - uA α t)‖ ≤
      Real.exp (1 - (t - 1 / 10) ^ 2) * (9 * (1 + 1 / ‖α + β‖ ^ 2) *
        (1 + (t + 1 / 10) ^ 2)) * (5 / 2) * (M * (14 + 8 * t)) := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have ia := abs_le.mp ((Complex.abs_im_le_norm α).trans hα)
  have ib := abs_le.mp ((Complex.abs_im_le_norm β).trans hβ)
  have hlo : ∀ {x L : ℝ}, L ≤ x ∨ L ≤ -x → L ≤ |x| := fun h => le_abs.mpr h
  have hdn : ∀ d : ℂ, 2 / 5 ≤ d.re → 2 / 5 ≤ ‖d‖ := fun d h =>
    h.trans ((le_abs_self _).trans (Complex.abs_re_le_norm d))
  have hwn : ∀ w : ℂ, |w.re| ≤ 6 / 5 → |w.im| ≤ 2 * t + 1 / 5 → ‖w‖ ≤ 2 * t + 2 := fun w h1 h2 =>
    (Complex.norm_le_abs_re_add_abs_im w).trans (by linarith)
  have e1 : (1 - uA α t).re = 1 / 2 - α.re := by simp [uA]; ring
  have e2 : (1 - uA α t).im = -(α.im + t) := by simp [uA]
  have e3 : (vB β t + 1 - uA α t).re = 1 + β.re - α.re := by simp [uA, vB]; ring
  have e4 : (vB β t + 1 - uA α t).im = β.im - α.im - 2 * t := by simp [uA, vB]; ring
  apply resY_term ht hM0 hM
  · rw [e1, abs_le]; constructor <;> linarith
  · rw [e2]; exact hlo (Or.inr (by linarith))
  · rw [e2, abs_le]; constructor <;> linarith
  · exact hdn _ (by rw [e1]; linarith)
  · rw [e3, abs_le]; constructor <;> linarith
  · rw [e4]; exact hlo (Or.inr (by linarith))
  · exact hwn _ (by rw [e3, abs_le]; constructor <;> linarith)
      (by rw [e4, abs_le]; constructor <;> linarith)

theorem resY_T2 {M : ℝ} (hM0 : 0 ≤ M)
    (hM : ∀ w : ℂ, |w.re| ≤ 2 → 1 ≤ |w.im| → ‖completedRiemannZeta w‖ ≤ M * (6 + 4 * ‖w‖))
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) :
    ‖GY α β (-uA α t) / uA α t * completedRiemannZeta (vB β t - uA α t)‖ ≤
      Real.exp (1 - (t - 1 / 10) ^ 2) * (9 * (1 + 1 / ‖α + β‖ ^ 2) *
        (1 + (t + 1 / 10) ^ 2)) * (5 / 2) * (M * (14 + 8 * t)) := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have ia := abs_le.mp ((Complex.abs_im_le_norm α).trans hα)
  have ib := abs_le.mp ((Complex.abs_im_le_norm β).trans hβ)
  have hlo : ∀ {x L : ℝ}, L ≤ x ∨ L ≤ -x → L ≤ |x| := fun h => le_abs.mpr h
  have hdn : ∀ d : ℂ, 2 / 5 ≤ d.re → 2 / 5 ≤ ‖d‖ := fun d h =>
    h.trans ((le_abs_self _).trans (Complex.abs_re_le_norm d))
  have hwn : ∀ w : ℂ, |w.re| ≤ 6 / 5 → |w.im| ≤ 2 * t + 1 / 5 → ‖w‖ ≤ 2 * t + 2 := fun w h1 h2 =>
    (Complex.norm_le_abs_re_add_abs_im w).trans (by linarith)
  have e1 : (-uA α t).re = -(1 / 2 + α.re) := by simp [uA]
  have e2 : (-uA α t).im = -(α.im + t) := by simp [uA]
  have e3 : (vB β t - uA α t).re = β.re - α.re := by simp [uA, vB]
  have e4 : (vB β t - uA α t).im = β.im - α.im - 2 * t := by simp [uA, vB]; ring
  apply resY_term ht hM0 hM
  · rw [e1, abs_le]; constructor <;> linarith
  · rw [e2]; exact hlo (Or.inr (by linarith))
  · rw [e2, abs_le]; constructor <;> linarith
  · exact hdn _ (by rw [uA_re]; linarith)
  · rw [e3, abs_le]; constructor <;> linarith
  · rw [e4]; exact hlo (Or.inr (by linarith))
  · exact hwn _ (by rw [e3, abs_le]; constructor <;> linarith)
      (by rw [e4, abs_le]; constructor <;> linarith)

theorem resY_T3 {M : ℝ} (hM0 : 0 ≤ M)
    (hM : ∀ w : ℂ, |w.re| ≤ 2 → 1 ≤ |w.im| → ‖completedRiemannZeta w‖ ≤ M * (6 + 4 * ‖w‖))
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) :
    ‖GY α β (1 - vB β t) / (1 - vB β t) * completedRiemannZeta (uA α t + 1 - vB β t)‖ ≤
      Real.exp (1 - (t - 1 / 10) ^ 2) * (9 * (1 + 1 / ‖α + β‖ ^ 2) *
        (1 + (t + 1 / 10) ^ 2)) * (5 / 2) * (M * (14 + 8 * t)) := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have ia := abs_le.mp ((Complex.abs_im_le_norm α).trans hα)
  have ib := abs_le.mp ((Complex.abs_im_le_norm β).trans hβ)
  have hlo : ∀ {x L : ℝ}, L ≤ x ∨ L ≤ -x → L ≤ |x| := fun h => le_abs.mpr h
  have hdn : ∀ d : ℂ, 2 / 5 ≤ d.re → 2 / 5 ≤ ‖d‖ := fun d h =>
    h.trans ((le_abs_self _).trans (Complex.abs_re_le_norm d))
  have hwn : ∀ w : ℂ, |w.re| ≤ 6 / 5 → |w.im| ≤ 2 * t + 1 / 5 → ‖w‖ ≤ 2 * t + 2 := fun w h1 h2 =>
    (Complex.norm_le_abs_re_add_abs_im w).trans (by linarith)
  have e1 : (1 - vB β t).re = 1 / 2 - β.re := by simp [vB]; ring
  have e2 : (1 - vB β t).im = t - β.im := by simp [vB]
  have e3 : (uA α t + 1 - vB β t).re = 1 + α.re - β.re := by simp [uA, vB]; ring
  have e4 : (uA α t + 1 - vB β t).im = α.im - β.im + 2 * t := by simp [uA, vB]; ring
  apply resY_term ht hM0 hM
  · rw [e1, abs_le]; constructor <;> linarith
  · rw [e2]; exact hlo (Or.inl (by linarith))
  · rw [e2, abs_le]; constructor <;> linarith
  · exact hdn _ (by rw [e1]; linarith)
  · rw [e3, abs_le]; constructor <;> linarith
  · rw [e4]; exact hlo (Or.inl (by linarith))
  · exact hwn _ (by rw [e3, abs_le]; constructor <;> linarith)
      (by rw [e4, abs_le]; constructor <;> linarith)

theorem resY_T4 {M : ℝ} (hM0 : 0 ≤ M)
    (hM : ∀ w : ℂ, |w.re| ≤ 2 → 1 ≤ |w.im| → ‖completedRiemannZeta w‖ ≤ M * (6 + 4 * ‖w‖))
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) :
    ‖GY α β (-vB β t) / vB β t * completedRiemannZeta (uA α t - vB β t)‖ ≤
      Real.exp (1 - (t - 1 / 10) ^ 2) * (9 * (1 + 1 / ‖α + β‖ ^ 2) *
        (1 + (t + 1 / 10) ^ 2)) * (5 / 2) * (M * (14 + 8 * t)) := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have ia := abs_le.mp ((Complex.abs_im_le_norm α).trans hα)
  have ib := abs_le.mp ((Complex.abs_im_le_norm β).trans hβ)
  have hlo : ∀ {x L : ℝ}, L ≤ x ∨ L ≤ -x → L ≤ |x| := fun h => le_abs.mpr h
  have hdn : ∀ d : ℂ, 2 / 5 ≤ d.re → 2 / 5 ≤ ‖d‖ := fun d h =>
    h.trans ((le_abs_self _).trans (Complex.abs_re_le_norm d))
  have hwn : ∀ w : ℂ, |w.re| ≤ 6 / 5 → |w.im| ≤ 2 * t + 1 / 5 → ‖w‖ ≤ 2 * t + 2 := fun w h1 h2 =>
    (Complex.norm_le_abs_re_add_abs_im w).trans (by linarith)
  have e1 : (-vB β t).re = -(1 / 2 + β.re) := by simp [vB]
  have e2 : (-vB β t).im = t - β.im := by simp [vB]
  have e3 : (uA α t - vB β t).re = α.re - β.re := by simp [uA, vB]
  have e4 : (uA α t - vB β t).im = α.im - β.im + 2 * t := by simp [uA, vB]; ring
  apply resY_term ht hM0 hM
  · rw [e1, abs_le]; constructor <;> linarith
  · rw [e2]; exact hlo (Or.inl (by linarith))
  · rw [e2, abs_le]; constructor <;> linarith
  · exact hdn _ (by rw [vB_re]; linarith)
  · rw [e3, abs_le]; constructor <;> linarith
  · rw [e4]; exact hlo (Or.inl (by linarith))
  · exact hwn _ (by rw [e3, abs_le]; constructor <;> linarith)
      (by rw [e4, abs_le]; constructor <;> linarith)

/-- The denominator of `resY`: `‖Gammaℝ(u) Gammaℝ(v)‖ ≥ e^(−2K₂ − (π/2+1)(t + 1/10))`. -/
theorem resY_den {K : ℝ}
    (hK : ∀ r : ℝ, 1 / 5 ≤ r → r ≤ 3 / 10 → |Real.log (Real.Gamma r)| ≤ K ∧ gErr r ≤ K)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) :
    Real.exp (-(2 * (2 * K + |Real.log (Real.Gamma (1 / 2))|)) -
      (Real.pi / 2 + 1) * (t + 1 / 10)) ≤ ‖Gammaℝ (uA α t) * Gammaℝ (vB β t)‖ := by
  have ra := abs_le.mp ((Complex.abs_re_le_norm α).trans hα)
  have rb := abs_le.mp ((Complex.abs_re_le_norm β).trans hβ)
  have ia := abs_le.mp ((Complex.abs_im_le_norm α).trans hα)
  have ib := abs_le.mp ((Complex.abs_im_le_norm β).trans hβ)
  have D1 := gR_lower (w := uA α t) (a := α.re) (Y₀ := (α.im + t) / 2) (K := K) (uA_re α t)
    (by rw [uA_im]; ring) ((Complex.abs_re_le_norm α).trans hα)
    (hK _ (by linarith) (by linarith))
  have D2 := gR_lower (w := vB β t) (a := β.re) (Y₀ := (β.im - t) / 2) (K := K) (vB_re β t)
    (by rw [vB_im]; ring) ((Complex.abs_re_le_norm β).trans hβ)
    (hK _ (by linarith) (by linarith))
  have hY1 : |(α.im + t) / 2| ≤ (t + 1 / 10) / 2 := by
    rw [abs_le]; constructor <;> linarith
  have hY2 : |(β.im - t) / 2| ≤ (t + 1 / 10) / 2 := by
    rw [abs_le]; constructor <;> linarith
  have hu : 0 < (uA α t).re := by rw [uA_re]; linarith
  have hv : 0 < (vB β t).re := by rw [vB_re]; linarith
  have n1 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hu)
  have n2 := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hv)
  rw [norm_mul, ← Real.exp_log (mul_pos n1 n2), Real.log_mul n1.ne' n2.ne']
  apply Real.exp_le_exp.mpr
  have hpi : 0 < Real.pi / 2 + 1 := by positivity
  have q1 := mul_le_mul_of_nonneg_left hY1 hpi.le
  have q2 := mul_le_mul_of_nonneg_left hY2 hpi.le
  linarith

/-- **Target 2**: `‖resY α β t‖ ≤ C (1 + ‖α+β‖^(−2)) e^(−t²/2)` for `‖α‖, ‖β‖ ≤ 1/10`,
`t ≥ 1`. The Gaussian `G` at the four poles, height `≈ t`, beats the `Λ` values (polynomial,
`ApproxShift.Lambda_bound`) and `1/‖Gammaℝ(u) Gammaℝ(v)‖ ≪ e^((π/2+1)t)`. -/
theorem resY_small :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ‖resY α β t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * Real.exp (-(t ^ 2 / 2)) := by
  obtain ⟨M, hM0, hM⟩ := ApproxShift.Lambda_bound 2
  obtain ⟨K, hK0, hK⟩ := const_bound (lo := 1 / 5) (hi := 3 / 10) (by norm_num)
  set K₂ : ℝ := 2 * K + |Real.log (Real.Gamma (1 / 2))| with hK₂
  set W : ℝ := 14 * Real.exp ((Real.pi / 2 + 5) ^ 2 / 2 + 2) with hW
  refine ⟨90 * M * Real.exp (2 * K₂) * W, by positivity, fun α β hα hβ t ht => ?_⟩
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  have hD := resY_den hK hα hβ ht
  rw [← hK₂] at hD
  have hD0 : 0 < ‖Gammaℝ (uA α t) * Gammaℝ (vB β t)‖ := lt_of_lt_of_le (Real.exp_pos _) hD
  have T1 := resY_T1 hM0 hM hα hβ ht
  have T2 := resY_T2 hM0 hM hα hβ ht
  have T3 := resY_T3 hM0 hM hα hβ ht
  have T4 := resY_T4 hM0 hM hα hβ ht
  rw [← hN] at T1 T2 T3 T4
  set Tb : ℝ := Real.exp (1 - (t - 1 / 10) ^ 2) * (9 * N * (1 + (t + 1 / 10) ^ 2)) *
    (5 / 2) * (M * (14 + 8 * t)) with hTb
  have hnum : ‖GY α β (1 - uA α t) / (1 - uA α t) * completedRiemannZeta (vB β t + 1 - uA α t) +
      GY α β (-uA α t) / uA α t * completedRiemannZeta (vB β t - uA α t) +
      GY α β (1 - vB β t) / (1 - vB β t) * completedRiemannZeta (uA α t + 1 - vB β t) +
      GY α β (-vB β t) / vB β t * completedRiemannZeta (uA α t - vB β t)‖ ≤ 4 * Tb := by
    set a := GY α β (1 - uA α t) / (1 - uA α t) * completedRiemannZeta (vB β t + 1 - uA α t)
    set b := GY α β (-uA α t) / uA α t * completedRiemannZeta (vB β t - uA α t)
    set c := GY α β (1 - vB β t) / (1 - vB β t) * completedRiemannZeta (uA α t + 1 - vB β t)
    set d := GY α β (-vB β t) / vB β t * completedRiemannZeta (uA α t - vB β t)
    have h1 := norm_add_le (a + b + c) d
    have h2 := norm_add_le (a + b) c
    have h3 := norm_add_le a b
    linarith
  have hPE := poly_exp_bound ht
  rw [← hW] at hPE
  have hN0 : 0 ≤ N := by positivity
  set E : ℝ := (Real.pi / 2 + 1) * (t + 1 / 10) with hE
  have h4Tb : 4 * Tb = 90 * M * N * (Real.exp (1 - (t - 1 / 10) ^ 2) * (1 + (t + 1 / 10) ^ 2) *
      (14 + 8 * t) * Real.exp E) * Real.exp (-E) := by
    have hEE : Real.exp E * Real.exp (-E) = 1 := by
      rw [← Real.exp_add]; simp
    rw [hTb]
    linear_combination (-(90 * M * N * (Real.exp (1 - (t - 1 / 10) ^ 2) *
      (1 + (t + 1 / 10) ^ 2) * (14 + 8 * t)))) * hEE
  have hsplit : Real.exp (-(2 * K₂) - E) = Real.exp (-(2 * K₂)) * Real.exp (-E) := by
    rw [← Real.exp_add]; ring_nf
  have hone : Real.exp (2 * K₂) * Real.exp (-(2 * K₂)) = 1 := by
    rw [← Real.exp_add]; simp
  rw [resY, norm_div, div_le_iff₀ hD0]
  calc _ ≤ 4 * Tb := hnum
    _ = 90 * M * N * (Real.exp (1 - (t - 1 / 10) ^ 2) * (1 + (t + 1 / 10) ^ 2) *
          (14 + 8 * t) * Real.exp E) * Real.exp (-E) := h4Tb
    _ ≤ 90 * M * N * (W * Real.exp (-(t ^ 2 / 2))) * Real.exp (-E) := by gcongr
    _ = 90 * M * Real.exp (2 * K₂) * W * N * Real.exp (-(t ^ 2 / 2)) *
          Real.exp (-(2 * K₂) - E) := by
        rw [hsplit]
        linear_combination (90 * M * W * N * Real.exp (-(t ^ 2 / 2)) * Real.exp (-E)) * hone.symm
    _ ≤ _ := by gcongr

/-- info: 'ApproxBounds.gamma_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_shift

/-- info: 'ApproxBounds.log_norm_Gamma_approx' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_norm_Gamma_approx

/-- info: 'ApproxBounds.log_norm_Gammaℝ_approx' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_norm_Gammaℝ_approx

/-- info: 'ApproxBounds.XY_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms XY_log

/-- info: 'ApproxBounds.XY_size' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms XY_size

/-- info: 'ApproxBounds.gY_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gY_bound

/-- info: 'ApproxBounds.integrand_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integrand_bound

/-- info: 'ApproxBounds.VY_line_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_line_bound

/-- info: 'ApproxBounds.VY_line_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_line_eq

/-- info: 'ApproxBounds.VY_residue' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_residue

/-- info: 'ApproxBounds.VY_decay' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_decay

/-- info: 'ApproxBounds.VY_decay_young' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_decay_young

/-- info: 'ApproxBounds.resY_small' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms resY_small

end ApproxBounds
