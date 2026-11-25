/-
# TwistedMoment — block S12 of `lean_stage3/design/stencil.md`, piece 2b-ii, the twisted moment. 2026-11-25.

Young's Lemma 3 (arXiv 1002.4403, §3, (3.1)–(3.3)), built in Young's order (§4 Lemma 5, §5):
`I(α,β) = ∫ w(t) ζ(1/2+α+it) ζ(1/2+β−it) |ψ(σ₀+it)|² dt = c(α,β) ŵ(0) + O(T/L)`.
Notation as in `ApproxFE`, `ApproxBounds`, `ApproxDeriv`: `u = uA α t`, `v = vB β t`,
`V = VY α β c x t` on the line `Re s = c`, `N = 1 + ‖α+β‖^(−2)`, `Δ = T/L`.
`ψ(s) = Σ_{h ≤ M} a_h h^(−s)` (`psi`), `|ψ(σ₀+it)|² = msq`. Young's mollifier is `a = aY P T θ R`.

The route. (1) `Weight T L` is (2.1)–(2.3) with `j ≤ 2`. (2) `approxFE` at every `t ≥ 1` splits
the integrand (`integrand_split`), each piece is integrable (continuity on `[T/4, 2T]`; for the
double sum `S1`, `continuousOn_tsum` under `VY_decay`), so `I = I₁ + I_X − I_res` (`I_split`);
`I_res` is `O(N T e^(−T²/32))` by `resY_small` (`Ires_small`). Fubini for the `tsum`
(`hk_dom`) and `|ψ|² = Σ_{h,k} a_h ā_k h^(−σ₀−it) k^(−σ₀+it)` (`msq_expand`) give Young's (5.1)
before the split, `I₁ = Σ_{h,k} Σ_{m,n} coefY · Jint`, `Jint = ∫ w V(mn,t) (hm/kn)^(−it) dt`
(`I1_expand`), so `I₁ = diagSum + offSum` (`I1_diag_off`). (3) Off the diagonal, two
integrations by parts (`ibp_twice`) with `‖(wV)''‖ ≪ (1+C₁+C₂) N Δ^(−2) (1+x/(2T))^(−A)`
(`Fw2_bound`, from (2.3) and `VY_deriv_bound`) give each term
`≪ T Δ^(−2) λ^(−2) (1+mn/(2T))^(−A)` (`offdiag_term`), and the gap
`λ^(−2) = log(hm/kn)^(−2) ≤ 4·hm·kn` (`inv_log_sq_le`) gives Young's form (`offdiag_term_young`).
Summed: `offSum_bound`. (4), (5): named open statements; `lemma3_res_of_parts` assembles them.

| statement | content | status |
|---|---|---|
| `Weight`, `what0` | (2.1)–(2.3), `j ≤ 2`; `ŵ(0) = ∫ w` | defined |
| `Weight.zero_out` | `w, w′, w″ = 0` off `[T/4, 2T]` | proved |
| `ibp_once`, `ibp_twice` | `∫_a^b F e^(−iλt) = −λ^(−2) ∫_a^b F″ e^(−iλt)`, `F, F′ = 0` at `a, b` | proved |
| `ibp_bound` | `‖∫_a^b F e^(−iλt)‖ ≤ B (b − a) λ^(−2)` for `‖F″‖ ≤ B` | proved |
| `Fw2_bound` | `‖(wV)″(t)‖ ≤ K (1+C₁+C₂) N Δ^(−2) (1 + x/(2T))^(−A)`, `t ≥ 1` | proved |
| `offdiag_term` | Part 3: `‖∫ w V(x,t) e^(−iλt)‖ ≤ K (1+C₁+C₂) N T Δ^(−2) λ^(−2) (1+x/(2T))^(−A)` | proved |
| `log_ratio_ge`, `inv_log_sq_le` | `log(q/p) ≥ 1/(2p)`; `log(P/Q)^(−2) ≤ 4PQ`, `P ≠ Q` | proved |
| `offdiag_term_young` | Part 3 in Young's variables: `‖Jint‖ ≤ K (…) N T Δ^(−2) · 4hkmn · (1+mn/(2T))^(−A)`, `hm ≠ kn` | proved |
| `msq_expand`, `msq_le` | Part 2: `|ψ|² = Σ_{h,k} a_h ā_k h^(−σ₀−it) k^(−σ₀+it)`; `|ψ|² ≤ (Σ |a_h| h^(−σ₀))²` | proved |
| `approxFE_small`, `integrand_split` | `ζζ = S1 + X·S1(−β,−α) − resY` at `t ≥ 1`, `‖α‖, ‖β‖ ≤ 1/10`, `c ≥ 7/10` | proved |
| `continuousAt_resY`, `continuousOn_S1` | the pieces are continuous on the support | proved |
| `I_split` | Part 2: `I = I₁ + I_X − I_res` | proved |
| `Ires_small` | `‖I_res‖ ≤ C N (Σ |a_h| h^(−σ₀))² T e^(−T²/32)` | proved |
| `coef4`, `term_integral`, `hk_dom` | Young's coefficients; Fubini for the `tsum` | proved |
| `I1_expand` | Young's (5.1) before the split: `I₁ = Σ_{h,k ≤ M} Σ_{m,n ≥ 1} coefY · Jint` | proved |
| `Jint_diag`, `I1_diag_off` | on `hm = kn`, `Jint = ∫ w V(mn,t)`; `I₁ = diagSum + offSum` | proved |
| `offTerm_le`, `summable_offTerm` | `offSeries T = Σ (mn)^(3/5)(1 + mn/(2T))^(−3)` converges | proved |
| `off_term_le`, `offSum_bound` | `‖offSum‖ ≤ K (1+C₁+C₂) N T Δ^(−2) (Σ |a_h| h^(1−σ₀))² · offSeries T` | proved |
| `StmtOffDiag` | Part 3 summed: `offSum = O(T/L)` for Young's `ψ`, `θ < 1/2` | OPEN (named Prop) |
| `StmtDiag` | Part 4: `diagSum = c₁(α,β) ŵ(0) + O(T/L)` (Young's Lemma 6, §6–§7) | OPEN (named Prop) |
| `StmtX` | Part 5: `I_X(α,β) = T^(−α−β) I₁(−β,−α) + O(T/L)` | OPEN (named Prop) |
| `norm_Tpow_le`, `Regime.swap`, `Regime.small` | `‖T^(−α−β)‖ ≤ e^(2κ)`; the range is symmetric | proved |
| `lemma3_res_of_parts` | `StmtDiag → StmtOffDiag → StmtX → StmtLemma3res` (Lemma 3 up to `‖I_res‖`) | proved |
| `StmtLemma3` | Young's (3.2) with `c(α,β)` | OPEN (named Prop) |

The lost factor (on paper, unchecked in Lean). `offSum_bound` is the `j = 2` route summed with
Young's gap. For Young's `ψ`, `Σ_{h ≤ M} |a_h| h^(1−σ₀) ≪ M^(3/2)`, `offSeries T ≍ T^(8/5) log T`
and `N ≪ L²` give `offSum ≪ L⁵ M³ T^(3/5)`, which is `O(T/L)` only for `θ < 2/15` (`θ < 1/6`
with the exponent `1/2 + O(1/L)` of Young's range in place of `3/5`). Each integration by parts
gains `(Δ |log(hm/kn)|)^(−1) ≤ 2L√(hkmn)/T`, and the terms number about `M^(j+1) T^((j+1)/2)` after
weighting, so `j` integrations close for `j > (1+2θ)/(1−2θ)`, unbounded as `θ → 1/2`. The step
is proved; the failure is in the size of the sum. Young's route needs (4.3) for every `j`
(`ApproxDeriv`'s OPEN row) and (2.3) for every `j`; this is a decision for the design block.

Differences from Young. (i) (2.3) for `j ≤ 2` only, constants `C₁, C₂` carried as `(1+C₁+C₂)`.
(ii) Parts 2–3 hold for any coefficients `a_h`; Young's are used only in the named statements.
(iii) The bounds carry `N = 1 + ‖α+β‖^(−2)` (the `1/(α+β)²` of `p(s)`), uniform in
`‖α‖, ‖β‖ ≤ 1/10`, `α + β ≠ 0`, `T ≥ 8`, `L ≥ 1`; Young has `α, β ≪ 1/L`. (iv) `j = 2` integrations
by parts, so each off-diagonal term is `O(T Δ^(−2) hkmn (1+mn/T)^(−A))`, not Young's `O(T^(−A))`
summed. (v) `V` is read on a line `c` (`c ≥ 7/10` for the split, `c = 1` in the statements);
the decay is `(1 + x/t)^(−A)`, as in `ApproxBounds`. (vi) `I1` is the whole first-sum integral;
Young's `I₁` of (5.1) is `diagSum`, and `I_X` keeps its own off-diagonal. (vii) `c(α,β)` is
`c₁(α,β) + T^(−α−β) c₁(−β,−α)` with `c₁` from (5.3) (`cY`); its equality with (3.3) is Young's
§5 computation, not proved here. (viii) The range `Regime` includes Lemma 6's `|α+β| ≥ 1/(κL)`;
Young's extension to `α + β → 0` by the maximum modulus principle is not done. (ix) The
assembled statement keeps `‖I_res‖` as a separate term, bounded by `Ires_small`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.ApproxDeriv

namespace TwistedMoment

open Complex MeasureTheory Filter Topology ApproxFE ApproxBounds ApproxDeriv
open scoped ContDiff

/-! ## Part 1: the weight -/

/-- Young's admissible weight (2.1)–(2.3), `Δ = T/L`, the derivative bounds for `j ≤ 2`. -/
structure Weight (T L : ℝ) where
  /-- the weight -/
  w : ℝ → ℝ
  smooth : ContDiff ℝ ∞ w
  supp : ∀ t, w t ≠ 0 → T / 4 ≤ t ∧ t ≤ 2 * T
  nonneg : ∀ t, 0 ≤ w t
  le_one : ∀ t, w t ≤ 1
  /-- the constant of (2.3) at `j = 1` -/
  C1 : ℝ
  /-- the constant of (2.3) at `j = 2` -/
  C2 : ℝ
  C1_nonneg : 0 ≤ C1
  C2_nonneg : 0 ≤ C2
  d1 : ∀ t, |deriv w t| ≤ C1 * (T / L)⁻¹
  d2 : ∀ t, |deriv (deriv w) t| ≤ C2 * ((T / L) ^ 2)⁻¹

/-- `ŵ(0) = ∫ w`. -/
noncomputable
def what0 {T L : ℝ} (W : Weight T L) : ℝ := ∫ t, W.w t

namespace Weight

variable {T L : ℝ} (W : Weight T L)

theorem differentiable : Differentiable ℝ W.w :=
  W.smooth.differentiable (by simp)

theorem smooth1 : ContDiff ℝ ∞ (deriv W.w) :=
  (contDiff_infty_iff_deriv.mp W.smooth).2

theorem differentiable1 : Differentiable ℝ (deriv W.w) :=
  W.smooth1.differentiable (by simp)

theorem hasDerivAt1 (t : ℝ) : HasDerivAt W.w (deriv W.w t) t :=
  (W.differentiable t).hasDerivAt

theorem hasDerivAt2 (t : ℝ) : HasDerivAt (deriv W.w) (deriv (deriv W.w) t) t :=
  (W.differentiable1 t).hasDerivAt

theorem cont : Continuous W.w := W.differentiable.continuous

theorem cont1 : Continuous (deriv W.w) := W.differentiable1.continuous

theorem cont2 : Continuous (deriv (deriv W.w)) :=
  W.smooth1.continuous_deriv (by simp)

/-- A function vanishing on an open set has derivative zero there. -/
theorem deriv_zero_on {f : ℝ → ℝ} {U : Set ℝ} (hU : IsOpen U) (h : ∀ s ∈ U, f s = 0) :
    ∀ s ∈ U, deriv f s = 0 := by
  intro s hs
  have hev : f =ᶠ[𝓝 s] fun _ => (0 : ℝ) := by
    filter_upwards [hU.mem_nhds hs] with y hy using h y hy
  rw [hev.deriv_eq, deriv_const]

theorem zero_out {t : ℝ} (ht : t ∉ Set.Icc (T / 4) (2 * T)) :
    W.w t = 0 ∧ deriv W.w t = 0 ∧ deriv (deriv W.w) t = 0 := by
  have hU : IsOpen (Set.Icc (T / 4) (2 * T))ᶜ := isClosed_Icc.isOpen_compl
  have h0 : ∀ s ∈ (Set.Icc (T / 4) (2 * T))ᶜ, W.w s = 0 := by
    intro s hs
    by_contra hne
    exact hs ⟨(W.supp s hne).1, (W.supp s hne).2⟩
  have h1 := deriv_zero_on hU h0
  have h2 := deriv_zero_on hU h1
  exact ⟨h0 t ht, h1 t ht, h2 t ht⟩

theorem abs_le_one (t : ℝ) : |W.w t| ≤ 1 := by
  rw [abs_of_nonneg (W.nonneg t)]
  exact W.le_one t

end Weight

/-! ## Part 3, the tool: two integrations by parts against `e^(−iλt)` -/

/-- `e_λ(t) = e^(−iλt)`. -/
noncomputable
def eL (l t : ℝ) : ℂ := cexp ((t : ℂ) * (-(l : ℂ) * I))

theorem continuous_eL (l : ℝ) : Continuous (eL l) := by
  unfold eL
  fun_prop

theorem eL_hasDerivAt (l t : ℝ) : HasDerivAt (eL l) (eL l t * (-(l : ℂ) * I)) t := by
  have h := (hasDerivAt_line 0 (-(l : ℂ) * I) t).cexp
  have e : (fun t : ℝ => cexp (0 + (t : ℂ) * (-(l : ℂ) * I))) = eL l := by
    funext y
    simp [eL]
  rw [e] at h
  refine h.congr_deriv ?_
  simp [eL]

theorem norm_eL (l t : ℝ) : ‖eL l t‖ = 1 := by
  unfold eL
  have : (t : ℂ) * (-(l : ℂ) * I) = ((-(l * t) : ℝ) : ℂ) * I := by
    push_cast
    ring
  rw [this, norm_exp_ofReal_mul_I]

/-- One integration by parts: `∫_a^b F e_λ = (1/(iλ)) ∫_a^b F' e_λ` when `F(a) = F(b) = 0`. -/
theorem ibp_once {F F1 : ℝ → ℂ} {a b l : ℝ} (hl : l ≠ 0)
    (hF : ∀ t, HasDerivAt F (F1 t) t) (hF1 : IntervalIntegrable F1 volume a b)
    (ha : F a = 0) (hb : F b = 0) :
    ∫ t in a..b, F t * eL l t = (1 / ((l : ℂ) * I)) * ∫ t in a..b, F1 t * eL l t := by
  have hl0 : (l : ℂ) ≠ 0 := ofReal_ne_zero.mpr hl
  have hlI : -(l : ℂ) * I ≠ 0 := mul_ne_zero (neg_ne_zero.mpr hl0) I_ne_zero
  have hv : ∀ t, HasDerivAt (fun t => eL l t / (-(l : ℂ) * I)) (eL l t) t := by
    intro t
    refine ((eL_hasDerivAt l t).div_const (-(l : ℂ) * I)).congr_deriv ?_
    field_simp
    try ring
  have key := intervalIntegral.integral_mul_deriv_eq_deriv_mul (a := a) (b := b)
    (u := F) (v := fun t => eL l t / (-(l : ℂ) * I)) (u' := F1) (v' := eL l)
    (fun t _ => hF t) (fun t _ => hv t) hF1 ((continuous_eL l).intervalIntegrable a b)
  rw [key, ha, hb, zero_mul, zero_mul, sub_zero, zero_sub]
  have e : (fun t => F1 t * (eL l t / (-(l : ℂ) * I))) =
      fun t => (-(1 / ((l : ℂ) * I))) * (F1 t * eL l t) := by
    funext t
    field_simp
    try ring
  rw [e, intervalIntegral.integral_const_mul]
  ring

/-- Two integrations by parts: `∫_a^b F e_λ = −(1/λ²) ∫_a^b F'' e_λ` when `F` and `F'`
vanish at `a` and `b`. -/
theorem ibp_twice {F F1 F2 : ℝ → ℂ} {a b l : ℝ} (hl : l ≠ 0)
    (hF : ∀ t, HasDerivAt F (F1 t) t) (hF1 : ∀ t, HasDerivAt F1 (F2 t) t)
    (hF2 : IntervalIntegrable F2 volume a b)
    (ha : F a = 0) (hb : F b = 0) (ha1 : F1 a = 0) (hb1 : F1 b = 0) :
    ∫ t in a..b, F t * eL l t = -(1 / (l : ℂ) ^ 2) * ∫ t in a..b, F2 t * eL l t := by
  have hc1 : Continuous F1 := continuous_iff_continuousAt.mpr fun t => (hF1 t).continuousAt
  rw [ibp_once hl hF (hc1.intervalIntegrable a b) ha hb, ibp_once hl hF1 hF2 ha1 hb1,
    ← mul_assoc]
  congr 1
  have hI : I ^ 2 = -1 := I_sq
  rw [div_mul_div_comm, one_mul, show (l : ℂ) * I * ((l : ℂ) * I) = -((l : ℂ) ^ 2) by
    linear_combination (l : ℂ) ^ 2 * hI, div_neg]

/-- The bound after two integrations by parts: `‖∫_a^b F e_λ‖ ≤ B (b − a)/λ²` when
`‖F''‖ ≤ B` on `[a, b]`. -/
theorem ibp_bound {F F1 F2 : ℝ → ℂ} {a b l B : ℝ} (hab : a ≤ b) (hl : l ≠ 0)
    (hF : ∀ t, HasDerivAt F (F1 t) t) (hF1 : ∀ t, HasDerivAt F1 (F2 t) t)
    (hF2 : IntervalIntegrable F2 volume a b)
    (ha : F a = 0) (hb : F b = 0) (ha1 : F1 a = 0) (hb1 : F1 b = 0)
    (hB : ∀ t ∈ Set.Icc a b, ‖F2 t‖ ≤ B) :
    ‖∫ t in a..b, F t * eL l t‖ ≤ B * (b - a) * (l ^ 2)⁻¹ := by
  rw [ibp_twice hl hF hF1 hF2 ha hb ha1 hb1, norm_mul]
  have h1 : ‖-(1 / (l : ℂ) ^ 2)‖ = (l ^ 2)⁻¹ := by
    rw [norm_neg, norm_div, norm_one, norm_pow, Complex.norm_real, Real.norm_eq_abs, sq_abs]
    ring
  have h2 : ‖∫ t in a..b, F2 t * eL l t‖ ≤ B * |b - a| := by
    refine intervalIntegral.norm_integral_le_of_norm_le_const fun t ht => ?_
    rw [Set.uIoc_of_le hab] at ht
    rw [norm_mul, norm_eL, mul_one]
    exact hB t ⟨ht.1.le, ht.2⟩
  rw [h1, abs_of_nonneg (by linarith)] at *
  have hl2 : 0 ≤ (l ^ 2)⁻¹ := by positivity
  calc (l ^ 2)⁻¹ * ‖∫ t in a..b, F2 t * eL l t‖ ≤ (l ^ 2)⁻¹ * (B * (b - a)) :=
        mul_le_mul_of_nonneg_left h2 hl2
    _ = B * (b - a) * (l ^ 2)⁻¹ := by ring

/-! ## Part 3: the off-diagonal term `∫ w(t) V(x,t) e^(−iλt) dt` -/

section OffDiag

variable {T L : ℝ} (W : Weight T L) (α β : ℂ) (c x : ℝ)

/-- `F = w·V`. -/
noncomputable
def Fw (t : ℝ) : ℂ := (W.w t : ℂ) * VY α β c x t

/-- `F' = w'V + wV₁`. -/
noncomputable
def Fw1 (t : ℝ) : ℂ := ((deriv W.w t : ℝ) : ℂ) * VY α β c x t + (W.w t : ℂ) * VY1 α β c x t

/-- `F'' = w''V + 2w'V₁ + wV₂`. -/
noncomputable
def Fw2 (t : ℝ) : ℂ :=
  ((deriv (deriv W.w) t : ℝ) : ℂ) * VY α β c x t + 2 * ((deriv W.w t : ℝ) : ℂ) * VY1 α β c x t +
    (W.w t : ℂ) * VY2 α β c x t

variable {W α β c x}

theorem Fw_hasDerivAt (hc : 0 < c) (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hx : 0 < x)
    (t : ℝ) : HasDerivAt (Fw W α β c x) (Fw1 W α β c x t) t := by
  have h := (W.hasDerivAt1 t).ofReal_comp.mul (VY_hasDerivAt (by linarith) hc.ne' hα hβ hx t)
  refine h.congr_deriv ?_
  unfold Fw1
  ring

theorem Fw1_hasDerivAt (hc : 0 < c) (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hx : 0 < x)
    (t : ℝ) : HasDerivAt (Fw1 W α β c x) (Fw2 W α β c x t) t := by
  have h1 := (W.hasDerivAt2 t).ofReal_comp.mul (VY_hasDerivAt (by linarith) hc.ne' hα hβ hx t)
  have h2 := (W.hasDerivAt1 t).ofReal_comp.mul (VY1_hasDerivAt (by linarith) hc.ne' hα hβ hx t)
  have h := h1.add h2
  refine h.congr_deriv ?_
  unfold Fw2
  ring

theorem Fw_zero_out {t : ℝ} (ht : t ∉ Set.Icc (T / 4) (2 * T)) :
    Fw W α β c x t = 0 ∧ Fw1 W α β c x t = 0 ∧ Fw2 W α β c x t = 0 := by
  obtain ⟨h0, h1, h2⟩ := W.zero_out ht
  simp [Fw, Fw1, Fw2, h0, h1, h2]

theorem continuous_VY (hc : 0 < c) (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hx : 0 < x) :
    Continuous fun t => VY α β c x t :=
  continuous_iff_continuousAt.mpr fun t =>
    (VY_hasDerivAt (by linarith) hc.ne' hα hβ hx t).continuousAt

theorem continuous_VY1 (hc : 0 < c) (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hx : 0 < x) :
    Continuous fun t => VY1 α β c x t :=
  continuous_iff_continuousAt.mpr fun t =>
    (VY1_hasDerivAt (by linarith) hc.ne' hα hβ hx t).continuousAt

theorem measurable_VY2 (hc : 0 < c) (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hx : 0 < x) :
    Measurable fun t => VY2 α β c x t := by
  have e : (fun t => VY2 α β c x t) = deriv (fun t => VY1 α β c x t) :=
    funext fun t => (VY1_hasDerivAt (by linarith) hc.ne' hα hβ hx t).deriv.symm
  rw [e]
  exact measurable_deriv _

theorem measurable_Fw2 (hc : 0 < c) (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hx : 0 < x) :
    Measurable (Fw2 W α β c x) := by
  have m0 : Measurable fun t => ((W.w t : ℝ) : ℂ) :=
    (Complex.continuous_ofReal.comp W.cont).measurable
  have m1 : Measurable fun t => ((deriv W.w t : ℝ) : ℂ) :=
    (Complex.continuous_ofReal.comp W.cont1).measurable
  have m2 : Measurable fun t => ((deriv (deriv W.w) t : ℝ) : ℂ) :=
    (Complex.continuous_ofReal.comp W.cont2).measurable
  have v0 := (continuous_VY hc hα hβ hx).measurable
  have v1 := (continuous_VY1 hc hα hβ hx).measurable
  have v2 := measurable_VY2 hc hα hβ hx
  unfold Fw2
  exact ((m2.mul v0).add ((measurable_const.mul m1).mul v1)).add (m0.mul v2)

end OffDiag

/-- `t⁻¹ ≤ 4Δ⁻¹` on the support, `Δ = T/L ≤ T`. -/
theorem inv_t_le {T L t : ℝ} (hT : 0 < T) (hL : 1 ≤ L) (ht : T / 4 ≤ t) :
    t⁻¹ ≤ 4 * (T / L)⁻¹ := by
  have hΔ : 0 < T / L := div_pos hT (by linarith)
  have hΔT : T / L ≤ T := div_le_self hT.le hL
  have h4 : T / L / 4 ≤ t := by linarith
  have h := inv_anti₀ (by positivity : 0 < T / L / 4) h4
  calc t⁻¹ ≤ (T / L / 4)⁻¹ := h
    _ = 4 * (T / L)⁻¹ := by
        field_simp
        try ring

/-- The decay factor at `t ≤ 2T`: `(1 + x/t)^(−A) ≤ (1 + x/(2T))^(−A)`. -/
theorem decay_le {T t x A : ℝ} (hA : 0 < A) (hx : 0 < x) (ht0 : 0 < t) (ht : t ≤ 2 * T) :
    (1 + x / t) ^ (-A) ≤ (1 + x / (2 * T)) ^ (-A) := by
  have hT : 0 < 2 * T := by linarith
  apply Real.rpow_le_rpow_of_nonpos (by positivity) _ (by linarith)
  have : x / (2 * T) ≤ x / t := div_le_div_of_nonneg_left hx.le ht0 ht
  linarith

/-- The pointwise bound on `F''`: `‖(wV)''(t)‖ ≤ K (1 + C₁ + C₂) N Δ^(−2) (1 + x/(2T))^(−A)`,
for `t ≥ 1`, from (2.3) and `VY_decay_young`, `VY_deriv_bound` (Young's (4.3), `j ≤ 2`). -/
theorem Fw2_bound {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : Weight T L), 0 < T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ∀ t : ℝ, 1 ≤ t →
        ‖Fw2 W α β c x t‖ ≤ K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) *
          ((T / L) ^ 2)⁻¹ * (1 + x / (2 * T)) ^ (-A) := by
  obtain ⟨C0, hC0, hV⟩ := VY_decay_young hA
  obtain ⟨Cd, hCd, hVd⟩ := VY_deriv_bound hA
  refine ⟨C0 + 24 * Cd, by positivity, fun T L W hT hL α β hα hβ hαβ x hx c hc t ht => ?_⟩
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  set D' : ℝ := (1 + x / (2 * T)) ^ (-A) with hD'
  set e : ℝ := (T / L)⁻¹ with he
  have hN0 : 0 ≤ N := by positivity
  have hD'0 : 0 ≤ D' := by positivity
  have he0 : 0 < e := inv_pos.mpr (div_pos hT (by linarith))
  have he2 : ((T / L) ^ 2)⁻¹ = e ^ 2 := by rw [he, inv_pow]
  rw [he2]
  have hK1 : 0 ≤ 1 + W.C1 + W.C2 := by linarith [W.C1_nonneg, W.C2_nonneg]
  by_cases hsupp : t ∈ Set.Icc (T / 4) (2 * T)
  swap
  · rw [(Fw_zero_out hsupp).2.2, norm_zero]
    positivity
  have ht0 : 0 < t := by linarith
  have hD := decay_le hA hx ht0 hsupp.2
  rw [← hD'] at hD
  have hti : t⁻¹ ≤ 4 * e := inv_t_le hT hL hsupp.1
  have hti0 : 0 ≤ t⁻¹ := by positivity
  -- the three factors of `V`
  have bV : ‖VY α β c x t‖ ≤ C0 * (N * D') := by
    have := hV α β hα hβ hαβ t ht x hx c hc
    calc ‖VY α β c x t‖ ≤ C0 * N * (1 + x / t) ^ (-A) := this
      _ ≤ C0 * N * D' := mul_le_mul_of_nonneg_left hD (by positivity)
      _ = C0 * (N * D') := by ring
  obtain ⟨i1, i2⟩ := iteratedDeriv_VY hα hβ hx hc
  have bV1 : ‖VY1 α β c x t‖ ≤ 4 * Cd * (N * D') * e := by
    have h := hVd α β hα hβ hαβ t ht x hx c hc 1 le_rfl (by norm_num)
    rw [i1] at h
    beta_reduce at h
    rw [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs, abs_of_pos ht0, pow_one] at h
    have h' : t * ‖VY1 α β c x t‖ ≤ Cd * N * D' :=
      h.trans (mul_le_mul_of_nonneg_left hD (by positivity))
    have : ‖VY1 α β c x t‖ = t⁻¹ * (t * ‖VY1 α β c x t‖) := by
      field_simp
      try ring
    rw [this]
    calc t⁻¹ * (t * ‖VY1 α β c x t‖) ≤ (4 * e) * (Cd * N * D') :=
          mul_le_mul hti h' (by positivity) (by positivity)
      _ = 4 * Cd * (N * D') * e := by ring
  have bV2 : ‖VY2 α β c x t‖ ≤ 16 * Cd * (N * D') * e ^ 2 := by
    have h := hVd α β hα hβ hαβ t ht x hx c hc 2 (by norm_num) le_rfl
    rw [i2] at h
    beta_reduce at h
    rw [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs, abs_of_pos ht0] at h
    have h' : t ^ 2 * ‖VY2 α β c x t‖ ≤ Cd * N * D' :=
      h.trans (mul_le_mul_of_nonneg_left hD (by positivity))
    have : ‖VY2 α β c x t‖ = (t⁻¹) ^ 2 * (t ^ 2 * ‖VY2 α β c x t‖) := by
      field_simp
      try ring
    have hti2 : (t⁻¹) ^ 2 ≤ (4 * e) ^ 2 := pow_le_pow_left₀ hti0 hti 2
    rw [this]
    calc (t⁻¹) ^ 2 * (t ^ 2 * ‖VY2 α β c x t‖) ≤ (4 * e) ^ 2 * (Cd * N * D') :=
          mul_le_mul hti2 h' (by positivity) (by positivity)
      _ = 16 * Cd * (N * D') * e ^ 2 := by ring
  -- the three factors of `w`
  have bw0 : ‖((W.w t : ℝ) : ℂ)‖ ≤ 1 := by
    rw [Complex.norm_real, Real.norm_eq_abs]; exact W.abs_le_one t
  have bw1 : ‖((deriv W.w t : ℝ) : ℂ)‖ ≤ W.C1 * e := by
    rw [Complex.norm_real, Real.norm_eq_abs]; exact W.d1 t
  have bw2 : ‖((deriv (deriv W.w) t : ℝ) : ℂ)‖ ≤ W.C2 * e ^ 2 := by
    rw [Complex.norm_real, Real.norm_eq_abs, ← he2]; exact W.d2 t
  have hP : 0 ≤ N * D' := by positivity
  have t1 : ‖((deriv (deriv W.w) t : ℝ) : ℂ) * VY α β c x t‖ ≤ (W.C2 * C0) * (N * D') * e ^ 2 := by
    rw [norm_mul]
    calc _ ≤ (W.C2 * e ^ 2) * (C0 * (N * D')) :=
          mul_le_mul bw2 bV (norm_nonneg _) (by positivity [W.C2_nonneg])
      _ = (W.C2 * C0) * (N * D') * e ^ 2 := by ring
  have t2 : ‖2 * ((deriv W.w t : ℝ) : ℂ) * VY1 α β c x t‖ ≤ (8 * W.C1 * Cd) * (N * D') * e ^ 2 := by
    rw [norm_mul, norm_mul, Complex.norm_ofNat]
    calc 2 * ‖((deriv W.w t : ℝ) : ℂ)‖ * ‖VY1 α β c x t‖ ≤
          2 * (W.C1 * e) * (4 * Cd * (N * D') * e) := by
          have := mul_le_mul bw1 bV1 (norm_nonneg _) (by positivity [W.C1_nonneg])
          nlinarith [norm_nonneg ((deriv W.w t : ℝ) : ℂ), norm_nonneg (VY1 α β c x t)]
      _ = (8 * W.C1 * Cd) * (N * D') * e ^ 2 := by ring
  have t3 : ‖((W.w t : ℝ) : ℂ) * VY2 α β c x t‖ ≤ (16 * Cd) * (N * D') * e ^ 2 := by
    rw [norm_mul]
    calc _ ≤ 1 * (16 * Cd * (N * D') * e ^ 2) :=
          mul_le_mul bw0 bV2 (norm_nonneg _) zero_le_one
      _ = (16 * Cd) * (N * D') * e ^ 2 := by ring
  have hsum : W.C2 * C0 + 8 * W.C1 * Cd + 16 * Cd ≤ (C0 + 24 * Cd) * (1 + W.C1 + W.C2) := by
    nlinarith [W.C1_nonneg, W.C2_nonneg, mul_nonneg W.C1_nonneg hCd, mul_nonneg W.C2_nonneg hCd,
      mul_nonneg W.C1_nonneg hC0]
  have hQ : 0 ≤ (N * D') * e ^ 2 := by positivity
  unfold Fw2
  calc _ ≤ ‖((deriv (deriv W.w) t : ℝ) : ℂ) * VY α β c x t‖ +
          ‖2 * ((deriv W.w t : ℝ) : ℂ) * VY1 α β c x t‖ + ‖((W.w t : ℝ) : ℂ) * VY2 α β c x t‖ :=
        norm_add₃_le
    _ ≤ (W.C2 * C0) * (N * D') * e ^ 2 + (8 * W.C1 * Cd) * (N * D') * e ^ 2 +
          (16 * Cd) * (N * D') * e ^ 2 := by linarith
    _ = (W.C2 * C0 + 8 * W.C1 * Cd + 16 * Cd) * ((N * D') * e ^ 2) := by ring
    _ ≤ (C0 + 24 * Cd) * (1 + W.C1 + W.C2) * ((N * D') * e ^ 2) :=
        mul_le_mul_of_nonneg_right hsum hQ
    _ = (C0 + 24 * Cd) * (1 + W.C1 + W.C2) * N * e ^ 2 * D' := by ring

/-- **The off-diagonal integral, two integrations by parts.** For every `A > 0` there is `K`
with `‖∫ w(t) V_{α,β}(x,t) e^(−iλt) dt‖ ≤ K (1 + C₁ + C₂) N T Δ^(−2) λ^(−2) (1 + x/(2T))^(−A)`,
`Δ = T/L`, uniformly in the weight, `‖α‖, ‖β‖ ≤ 1/10` with `α + β ≠ 0`, `x > 0`, `λ ≠ 0`, the line
`c > 0`, `T ≥ 8`, `L ≥ 1`. Young §4, Lemma 5's proof at `j = 2`. -/
theorem offdiag_term {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : Weight T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ∀ l : ℝ, l ≠ 0 →
        ‖∫ t, (W.w t : ℂ) * VY α β c x t * eL l t‖ ≤
          K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹ * (l ^ 2)⁻¹ *
            (1 + x / (2 * T)) ^ (-A) := by
  obtain ⟨K, hK0, hK⟩ := Fw2_bound hA
  refine ⟨4 * K, by positivity, fun T L W hT hL α β hα hβ hαβ x hx c hc l hl => ?_⟩
  have hT0 : 0 < T := by linarith
  have hab : T / 8 ≤ 4 * T := by linarith
  set B : ℝ := K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * ((T / L) ^ 2)⁻¹ *
    (1 + x / (2 * T)) ^ (-A) with hB
  have hB0 : 0 ≤ B := by
    have := W.C1_nonneg
    have := W.C2_nonneg
    positivity
  have hout : ∀ t, t ∉ Set.Ioc (T / 8) (4 * T) → t ∉ Set.Icc (T / 4) (2 * T) := by
    intro t ht h
    apply ht
    constructor <;> linarith [h.1, h.2]
  have hR : ∫ t, (W.w t : ℂ) * VY α β c x t * eL l t =
      ∫ t in (T / 8)..(4 * T), Fw W α β c x t * eL l t := by
    rw [intervalIntegral.integral_of_le hab]
    refine (setIntegral_eq_integral_of_forall_compl_eq_zero fun t ht => ?_).symm
    rw [show (W.w t : ℂ) * VY α β c x t = Fw W α β c x t from rfl, (Fw_zero_out (hout t ht)).1,
      zero_mul]
  have e8 : T / 8 ∉ Set.Icc (T / 4) (2 * T) := fun h => by linarith [h.1]
  have e4 : 4 * T ∉ Set.Icc (T / 4) (2 * T) := fun h => by linarith [h.2]
  have hbd : ∀ t ∈ Set.Icc (T / 8) (4 * T), ‖Fw2 W α β c x t‖ ≤ B := fun t ht =>
    hK T L W hT0 hL α β hα hβ hαβ x hx c hc t (by linarith [ht.1])
  have hint : IntervalIntegrable (Fw2 W α β c x) volume (T / 8) (4 * T) := by
    rw [intervalIntegrable_iff_integrableOn_Ioc_of_le hab]
    refine Measure.integrableOn_of_bounded measure_Ioc_lt_top.ne
      (measurable_Fw2 hc hα hβ hx).aestronglyMeasurable (M := B) ?_
    exact ae_restrict_of_forall_mem measurableSet_Ioc fun t ht => hbd t ⟨ht.1.le, ht.2⟩
  have h := ibp_bound hab hl (Fw_hasDerivAt hc hα hβ hx) (Fw1_hasDerivAt hc hα hβ hx) hint
    (Fw_zero_out e8).1 (Fw_zero_out e4).1 (Fw_zero_out e8).2.1 (Fw_zero_out e4).2.1 hbd
  rw [hR]
  have hl2 : 0 ≤ (l ^ 2)⁻¹ := by positivity
  calc _ ≤ B * (4 * T - T / 8) * (l ^ 2)⁻¹ := h
    _ ≤ B * (4 * T) * (l ^ 2)⁻¹ := by
        apply mul_le_mul_of_nonneg_right _ hl2
        apply mul_le_mul_of_nonneg_left _ hB0
        linarith
    _ = _ := by rw [hB]; ring

/-! ## Part 3, in Young's variables: `(hm/kn)^(−it)` and the gap `|log(hm/kn)|` -/

/-- `(p/q)^(−it) = e_{log(p/q)}(t)` for `p, q > 0`. -/
theorem ratio_cpow_eq {p q : ℝ} (hp : 0 < p) (hq : 0 < q) (t : ℝ) :
    ((p : ℂ) / (q : ℂ)) ^ (-((t : ℂ) * I)) = eL (Real.log (p / q)) t := by
  have hr : 0 < p / q := div_pos hp hq
  rw [← Complex.ofReal_div, cpow_def_of_ne_zero (ofReal_ne_zero.mpr hr.ne'),
    ← Complex.ofReal_log hr.le, eL]
  congr 1
  ring

/-- `log(q/p) ≥ 1/(2p)` for integers `1 ≤ p < q`. -/
theorem log_ratio_ge {p q : ℕ} (hp : 1 ≤ p) (hpq : p < q) :
    1 / (2 * (p : ℝ)) ≤ Real.log ((q : ℝ) / p) := by
  have hp0 : (0 : ℝ) < p := by exact_mod_cast hp
  have hp1 : (1 : ℝ) ≤ p := by exact_mod_cast hp
  have hq1 : (p : ℝ) + 1 ≤ q := by exact_mod_cast hpq
  have h1 : 1 - (((p : ℝ) + 1) / p)⁻¹ ≤ Real.log (((p : ℝ) + 1) / p) :=
    Real.one_sub_inv_le_log_of_pos (by positivity)
  have h2 : Real.log (((p : ℝ) + 1) / p) ≤ Real.log ((q : ℝ) / p) :=
    Real.log_le_log (by positivity) (div_le_div_of_nonneg_right hq1 hp0.le)
  have h3 : 1 - (((p : ℝ) + 1) / p)⁻¹ = 1 / ((p : ℝ) + 1) := by
    field_simp
    try ring
  have h4 : 1 / (2 * (p : ℝ)) ≤ 1 / ((p : ℝ) + 1) :=
    one_div_le_one_div_of_le (by positivity) (by linarith)
  linarith

/-- **The gap**, Young's `|log(hm/kn)| ≥ 1/(2√(hkmn))` in the squared form:
`(log(P/Q))^(−2) ≤ 4PQ` for integers `P ≠ Q`, both `≥ 1`. -/
theorem inv_log_sq_le {P Q : ℕ} (hP : 1 ≤ P) (hQ : 1 ≤ Q) (hPQ : P ≠ Q) :
    ((Real.log ((P : ℝ) / Q)) ^ 2)⁻¹ ≤ 4 * (P : ℝ) * Q := by
  have hP0 : (0 : ℝ) < P := by exact_mod_cast hP
  have hQ0 : (0 : ℝ) < Q := by exact_mod_cast hQ
  rcases lt_or_gt_of_ne hPQ with h | h
  · -- `P < Q`: `log(P/Q) = −log(Q/P)`
    have hg := log_ratio_ge hP h
    have e : Real.log ((P : ℝ) / Q) = -Real.log ((Q : ℝ) / P) := by
      rw [Real.log_div hP0.ne' hQ0.ne', Real.log_div hQ0.ne' hP0.ne']
      ring
    have hpos : 0 < (1 / (2 * (P : ℝ))) ^ 2 := by positivity
    have hsq : (1 / (2 * (P : ℝ))) ^ 2 ≤ (Real.log ((P : ℝ) / Q)) ^ 2 := by
      rw [e, neg_sq]
      exact pow_le_pow_left₀ (by positivity) hg 2
    have hPQ' : (P : ℝ) ≤ Q := by exact_mod_cast h.le
    calc ((Real.log ((P : ℝ) / Q)) ^ 2)⁻¹ ≤ ((1 / (2 * (P : ℝ))) ^ 2)⁻¹ := inv_anti₀ hpos hsq
      _ = 4 * (P : ℝ) * P := by
          field_simp
          try ring
      _ ≤ 4 * (P : ℝ) * Q := by nlinarith
  · -- `Q < P`
    have hg := log_ratio_ge hQ h
    have hpos : 0 < (1 / (2 * (Q : ℝ))) ^ 2 := by positivity
    have hsq : (1 / (2 * (Q : ℝ))) ^ 2 ≤ (Real.log ((P : ℝ) / Q)) ^ 2 :=
      pow_le_pow_left₀ (by positivity) hg 2
    have hQP : (Q : ℝ) ≤ P := by exact_mod_cast h.le
    calc ((Real.log ((P : ℝ) / Q)) ^ 2)⁻¹ ≤ ((1 / (2 * (Q : ℝ))) ^ 2)⁻¹ := inv_anti₀ hpos hsq
      _ = 4 * (Q : ℝ) * Q := by
          field_simp
          try ring
      _ ≤ 4 * (P : ℝ) * Q := by nlinarith

/-- **The off-diagonal term in Young's form.** For every `A > 0` there is `K` with, for integers
`h, k, m, n ≥ 1`, `hm ≠ kn`,
`‖∫ w(t) V_{α,β}(mn,t) (hm/kn)^(−it) dt‖ ≤ K (1 + C₁ + C₂) N T Δ^(−2) · 4hkmn · (1 + mn/(2T))^(−A)`,
uniformly as in `offdiag_term`. Young §4, Lemma 5's proof, with `j = 2`. -/
theorem offdiag_term_young {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : Weight T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ c : ℝ, 0 < c →
      ∀ h k m n : ℕ, 1 ≤ h → 1 ≤ k → 1 ≤ m → 1 ≤ n → h * m ≠ k * n →
        ‖∫ t, (W.w t : ℂ) * VY α β c ((m : ℝ) * n) t *
            ((h : ℂ) * m / ((k : ℂ) * n)) ^ (-((t : ℂ) * I))‖ ≤
          K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹ *
            (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) * (1 + (m : ℝ) * n / (2 * T)) ^ (-A) := by
  obtain ⟨K, hK0, hK⟩ := offdiag_term hA
  refine ⟨K, hK0, fun T L W hT hL α β hα hβ hαβ c hc h k m n hh hk hm hn hne => ?_⟩
  have hp : (0 : ℝ) < (h : ℝ) * m := by
    have : (0 : ℝ) < h := by exact_mod_cast hh
    have : (0 : ℝ) < m := by exact_mod_cast hm
    positivity
  have hq : (0 : ℝ) < (k : ℝ) * n := by
    have : (0 : ℝ) < k := by exact_mod_cast hk
    have : (0 : ℝ) < n := by exact_mod_cast hn
    positivity
  have hx : (0 : ℝ) < (m : ℝ) * n := by
    have : (0 : ℝ) < m := by exact_mod_cast hm
    have : (0 : ℝ) < n := by exact_mod_cast hn
    positivity
  have e : ((h : ℂ) * m / ((k : ℂ) * n)) = ((((h : ℝ) * m : ℝ) : ℂ) / (((k : ℝ) * n : ℝ) : ℂ)) := by
    push_cast
    ring
  set l : ℝ := Real.log ((h : ℝ) * m / ((k : ℝ) * n)) with hl
  have hcast : ((h * m : ℕ) : ℝ) / ((k * n : ℕ) : ℝ) = (h : ℝ) * m / ((k : ℝ) * n) := by
    push_cast
    ring
  have hne' : (h : ℝ) * m / ((k : ℝ) * n) ≠ 1 := by
    intro h1
    rw [div_eq_one_iff_eq hq.ne'] at h1
    exact hne (by exact_mod_cast h1)
  have hl0 : l ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one (div_pos hp hq) hne'
  have hgap : (l ^ 2)⁻¹ ≤ 4 * ((h : ℝ) * m) * ((k : ℝ) * n) := by
    have := inv_log_sq_le (P := h * m) (Q := k * n) (Nat.one_le_iff_ne_zero.mpr
      (Nat.mul_ne_zero (by omega) (by omega))) (Nat.one_le_iff_ne_zero.mpr
      (Nat.mul_ne_zero (by omega) (by omega))) hne
    rw [hcast] at this
    push_cast at this
    rw [hl]
    linarith
  simp only [e, ratio_cpow_eq hp hq]
  rw [← hl]
  have hb := hK T L W hT hL α β hα hβ hαβ ((m : ℝ) * n) hx c hc l hl0
  have hpre : 0 ≤ K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹ := by
    have := W.C1_nonneg
    have := W.C2_nonneg
    have : (0 : ℝ) ≤ T := by linarith
    positivity
  have hD : 0 ≤ (1 + (m : ℝ) * n / (2 * T)) ^ (-A) := by
    have : (0 : ℝ) < T := by linarith
    positivity
  calc _ ≤ _ := hb
    _ ≤ K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹ *
          (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) * (1 + (m : ℝ) * n / (2 * T)) ^ (-A) :=
        mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hgap hpre) hD

/-! ## Part 2: inserting the approximate functional equation -/

/-- The mollifier `ψ(s) = Σ_{h ≤ M} a_h h^(−s)`. Young's is `a_h = μ(h) P(log(M/h)/log M) h^(σ₀−1/2)`. -/
noncomputable
def psi (M : ℕ) (a : ℕ → ℂ) (s : ℂ) : ℂ := ∑ h ∈ Finset.Icc 1 M, a h * (h : ℂ) ^ (-s)

/-- `|ψ(σ₀+it)|²`. -/
noncomputable
def msq (M : ℕ) (a : ℕ → ℂ) (σ₀ t : ℝ) : ℝ := ‖psi M a ((σ₀ : ℂ) + t * I)‖ ^ 2

/-- Young's first double sum `Σ_{m,n} m^(−1/2−α−it) n^(−1/2−β+it) V_{α,β}(mn,t)`, the sum
`ApproxShift.approxFE` writes, indexed from `0` with `m = p.1 + 1`, `n = p.2 + 1`. -/
noncomputable
def S1 (α β : ℂ) (c t : ℝ) : ℂ :=
  ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
    VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t

section Moments

variable {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) (c : ℝ)

/-- Young's (3.1): `I(α,β) = ∫ w(t) ζ(1/2+α+it) ζ(1/2+β−it) |ψ(σ₀+it)|² dt`. -/
noncomputable
def Imom : ℂ :=
  ∫ t, (W.w t : ℂ) * (riemannZeta (uA α t) * riemannZeta (vB β t)) * (msq M a σ₀ t : ℂ)

/-- `I₁`: the first double sum of `approxFE` in place of `ζζ`. -/
noncomputable
def I1 : ℂ := ∫ t, (W.w t : ℂ) * S1 α β c t * (msq M a σ₀ t : ℂ)

/-- The `X`-term: `X_{α,β,t}` times the swapped sum `S1 (−β) (−α)`. -/
noncomputable
def IX : ℂ := ∫ t, (W.w t : ℂ) * (XY α β t * S1 (-β) (-α) c t) * (msq M a σ₀ t : ℂ)

/-- The remainder term of `approxFE`. -/
noncomputable
def Ires : ℂ := ∫ t, (W.w t : ℂ) * resY α β t * (msq M a σ₀ t : ℂ)

end Moments

/-! ### `|ψ|²` expanded -/

theorem conj_natCast_cpow (k : ℕ) (z : ℂ) : (starRingEnd ℂ) ((k : ℂ) ^ z) = (k : ℂ) ^ (starRingEnd ℂ z) := by
  have h := Complex.conj_cpow (k : ℂ) ((starRingEnd ℂ) z)
    (by rw [Complex.natCast_arg]; exact Real.pi_pos.ne)
  rw [Complex.conj_natCast, Complex.conj_conj] at h
  exact h.symm

/-- `|ψ(σ₀+it)|² = Σ_{h,k ≤ M} a_h ā_k h^(−σ₀−it) k^(−σ₀+it)`. -/
theorem msq_expand (M : ℕ) (a : ℕ → ℂ) (σ₀ t : ℝ) :
    ((msq M a σ₀ t : ℝ) : ℂ) = ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M,
      a h * (starRingEnd ℂ) (a k) * ((h : ℂ) ^ (-((σ₀ : ℂ) + t * I)) *
        (k : ℂ) ^ (-((σ₀ : ℂ) - t * I))) := by
  unfold msq
  rw [← Complex.normSq_eq_norm_sq, ← Complex.mul_conj]
  unfold psi
  rw [map_sum, Finset.sum_mul_sum]
  refine Finset.sum_congr rfl fun h _ => Finset.sum_congr rfl fun k _ => ?_
  rw [map_mul, conj_natCast_cpow]
  have : (starRingEnd ℂ) (-((σ₀ : ℂ) + t * I)) = -((σ₀ : ℂ) - t * I) := by
    simp [map_add, map_mul, Complex.conj_ofReal, Complex.conj_I]
    ring
  rw [this]
  ring

theorem norm_psi_le (M : ℕ) (a : ℕ → ℂ) (σ₀ t : ℝ) :
    ‖psi M a ((σ₀ : ℂ) + t * I)‖ ≤ ∑ h ∈ Finset.Icc 1 M, ‖a h‖ * (h : ℝ) ^ (-σ₀) := by
  unfold psi
  refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun h hh => ?_)
  have h1 : 0 < h := by
    have := (Finset.mem_Icc.mp hh).1
    omega
  rw [norm_mul, Complex.norm_natCast_cpow_of_pos h1]
  simp

/-- `|ψ(σ₀+it)|² ≤ (Σ_{h ≤ M} |a_h| h^(−σ₀))²`. -/
theorem msq_le (M : ℕ) (a : ℕ → ℂ) (σ₀ t : ℝ) :
    msq M a σ₀ t ≤ (∑ h ∈ Finset.Icc 1 M, ‖a h‖ * (h : ℝ) ^ (-σ₀)) ^ 2 :=
  pow_le_pow_left₀ (norm_nonneg _) (norm_psi_le M a σ₀ t) 2

theorem msq_nonneg (M : ℕ) (a : ℕ → ℂ) (σ₀ t : ℝ) : 0 ≤ msq M a σ₀ t := by
  unfold msq
  positivity

theorem continuous_msq (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) : Continuous (msq M a σ₀) := by
  unfold msq psi
  refine (continuous_finsetSum _ fun h hh => ?_).norm.pow 2
  have h0 : (h : ℂ) ≠ 0 := by
    have := (Finset.mem_Icc.mp hh).1
    exact_mod_cast (show h ≠ 0 by omega)
  exact continuous_const.mul
    ((by fun_prop : Continuous fun t : ℝ => -((σ₀ : ℂ) + t * I)).const_cpow (Or.inl h0))

/-! ### The pointwise split -/

theorem re_small {α : ℂ} (hα : ‖α‖ ≤ 1 / 10) : -(1 / 10) ≤ α.re ∧ α.re ≤ 1 / 10 :=
  abs_le.mp ((Complex.abs_re_le_norm α).trans hα)

theorem im_small {α : ℂ} (hα : ‖α‖ ≤ 1 / 10) : -(1 / 10) ≤ α.im ∧ α.im ≤ 1 / 10 :=
  abs_le.mp ((Complex.abs_im_le_norm α).trans hα)

theorem uA_ne_vB {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) :
    uA α t ≠ vB β t := by
  intro h
  have := congrArg Complex.im h
  rw [uA_im, vB_im] at this
  linarith [im_small hα, im_small hβ]

/-- `approxFE` at `‖α‖, ‖β‖ ≤ 1/10`, `t ≥ 1`, `c ≥ 7/10`:
`ζ(u)ζ(v) = S1 α β c t + X·S1 (−β) (−α) c t − resY α β t`. -/
theorem approxFE_small {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {c : ℝ} (hc : 7 / 10 ≤ c) {t : ℝ} (ht : 1 ≤ t) :
    riemannZeta (uA α t) * riemannZeta (vB β t) =
      S1 α β c t + XY α β t * S1 (-β) (-α) c t - resY α β t := by
  obtain ⟨a1, a2⟩ := re_small hα
  obtain ⟨b1, b2⟩ := re_small hβ
  have ha : |α.re| ≤ 1 / 10 := abs_le.mpr ⟨a1, a2⟩
  have hb : |β.re| ≤ 1 / 10 := abs_le.mpr ⟨b1, b2⟩
  exact ApproxShift.approxFE (by linarith) (by linarith) (by linarith) (by linarith)
    (by linarith) (by linarith) hαβ (uA_ne_vB hα hβ ht)

/-- The integrands split at every `t`, for `T ≥ 4`. -/
theorem integrand_split {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {c : ℝ} (hc : 7 / 10 ≤ c) (t : ℝ) :
    (W.w t : ℂ) * (riemannZeta (uA α t) * riemannZeta (vB β t)) * (msq M a σ₀ t : ℂ) =
      (W.w t : ℂ) * S1 α β c t * (msq M a σ₀ t : ℂ) +
        (W.w t : ℂ) * (XY α β t * S1 (-β) (-α) c t) * (msq M a σ₀ t : ℂ) -
        (W.w t : ℂ) * resY α β t * (msq M a σ₀ t : ℂ) := by
  by_cases hw : W.w t = 0
  · simp [hw]
  have ht : 1 ≤ t := by linarith [(W.supp t hw).1]
  rw [approxFE_small hα hβ hαβ hc ht]
  ring

/-! ### Integrability of the three integrands -/

theorem continuous_uA (α : ℂ) : Continuous fun t : ℝ => uA α t := by
  unfold uA
  fun_prop

theorem continuous_vB (β : ℂ) : Continuous fun t : ℝ => vB β t := by
  unfold vB
  fun_prop

/-- A function that vanishes off `[a, b]` and is continuous on it is integrable. -/
theorem integrable_of_Icc {f : ℝ → ℂ} {a b : ℝ} (hf : ContinuousOn f (Set.Icc a b))
    (h0 : ∀ t, t ∉ Set.Icc a b → f t = 0) : Integrable f :=
  (hf.integrableOn_compact isCompact_Icc).integrable_of_forall_notMem_eq_zero h0

/-- The `I` integrand vanishes off the support. -/
theorem w_zero_mul {T L : ℝ} (W : Weight T L) {t : ℝ} (ht : t ∉ Set.Icc (T / 4) (2 * T))
    (F G : ℂ) : (W.w t : ℂ) * F * G = 0 := by
  rw [(W.zero_out ht).1]
  simp

theorem integrable_Imom {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) :
    Integrable fun t => (W.w t : ℂ) * (riemannZeta (uA α t) * riemannZeta (vB β t)) *
      (msq M a σ₀ t : ℂ) := by
  refine integrable_of_Icc (Continuous.continuousOn ?_) fun t ht => w_zero_mul W ht _ _
  have hu : ∀ t, uA α t ≠ 1 := fun t h => by
    have := congrArg Complex.re h
    rw [uA_re] at this
    simp at this
    linarith [re_small hα]
  have hv : ∀ t, vB β t ≠ 1 := fun t h => by
    have := congrArg Complex.re h
    rw [vB_re] at this
    simp at this
    linarith [re_small hβ]
  have zu : Continuous fun t => riemannZeta (uA α t) := continuous_iff_continuousAt.mpr fun t =>
    (differentiableAt_riemannZeta (hu t)).continuousAt.comp (continuous_uA α).continuousAt
  have zv : Continuous fun t => riemannZeta (vB β t) := continuous_iff_continuousAt.mpr fun t =>
    (differentiableAt_riemannZeta (hv t)).continuousAt.comp (continuous_vB β).continuousAt
  exact ((Complex.continuous_ofReal.comp W.cont).mul (zu.mul zv)).mul
    (Complex.continuous_ofReal.comp (continuous_msq M a σ₀))

/-- One term of `resY`, continuous in `t` where its pieces are defined. -/
theorem resY_term_cAt {α β : ℂ} {f d g : ℝ → ℂ} {t : ℝ} (hf : Continuous f) (hd : Continuous d)
    (hg : Continuous g) (hd0 : d t ≠ 0) (hg0 : g t ≠ 0) (hg1 : g t ≠ 1) :
    ContinuousAt (fun t => GY α β (f t) / d t * completedRiemannZeta (g t)) t := by
  have h1 : ContinuousAt (fun t => GY α β (f t)) t :=
    (ApproxShift.GY_analyticAt α β (f t)).continuousAt.comp hf.continuousAt
  have h2 : ContinuousAt (fun t => completedRiemannZeta (g t)) t :=
    (differentiableAt_completedZeta hg0 hg1).continuousAt.comp hg.continuousAt
  exact (h1.div hd.continuousAt hd0).mul h2

theorem ne_zero_of_re_pos {z : ℂ} (h : 0 < z.re) : z ≠ 0 := fun e => by
  rw [e] at h
  simp at h

theorem ne_of_im_ne {z w : ℂ} (h : z.im ≠ w.im) : z ≠ w := fun e => h (by rw [e])

/-- `resY α β` is continuous at every `t ≥ 1`. -/
theorem continuousAt_resY {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ}
    (ht : 1 ≤ t) : ContinuousAt (fun t => resY α β t) t := by
  obtain ⟨a1, a2⟩ := re_small hα
  obtain ⟨b1, b2⟩ := re_small hβ
  obtain ⟨c1, c2⟩ := im_small hα
  obtain ⟨d1, d2⟩ := im_small hβ
  have cu := continuous_uA α
  have cv := continuous_vB β
  have hu0 : uA α t ≠ 0 := ne_zero_of_re_pos (by rw [uA_re]; linarith)
  have hv0 : vB β t ≠ 0 := ne_zero_of_re_pos (by rw [vB_re]; linarith)
  have hu1 : 1 - uA α t ≠ 0 := ne_zero_of_re_pos (by rw [re_one_sub_uA]; linarith)
  have hv1 : 1 - vB β t ≠ 0 := ne_zero_of_re_pos (by rw [re_one_sub_vB]; linarith)
  have im1 : (vB β t + 1 - uA α t).im = β.im - α.im - 2 * t := by simp [uA, vB]; ring
  have im2 : (vB β t - uA α t).im = β.im - α.im - 2 * t := by simp [uA, vB]; ring
  have im3 : (uA α t + 1 - vB β t).im = α.im - β.im + 2 * t := by simp [uA, vB]; ring
  have im4 : (uA α t - vB β t).im = α.im - β.im + 2 * t := by simp [uA, vB]; ring
  have T1 := resY_term_cAt (α := α) (β := β) (t := t) (f := fun t => 1 - uA α t)
    (d := fun t => 1 - uA α t) (g := fun t => vB β t + 1 - uA α t)
    (continuous_const.sub cu) (continuous_const.sub cu) ((cv.add continuous_const).sub cu) hu1
    (ne_of_im_ne (by rw [im1]; simp; linarith)) (ne_of_im_ne (by rw [im1]; simp; linarith))
  have T2 := resY_term_cAt (α := α) (β := β) (t := t) (f := fun t => -uA α t)
    (d := fun t => uA α t) (g := fun t => vB β t - uA α t)
    cu.neg cu (cv.sub cu) hu0
    (ne_of_im_ne (by rw [im2]; simp; linarith)) (ne_of_im_ne (by rw [im2]; simp; linarith))
  have T3 := resY_term_cAt (α := α) (β := β) (t := t) (f := fun t => 1 - vB β t)
    (d := fun t => 1 - vB β t) (g := fun t => uA α t + 1 - vB β t)
    (continuous_const.sub cv) (continuous_const.sub cv) ((cu.add continuous_const).sub cv) hv1
    (ne_of_im_ne (by rw [im3]; simp; linarith)) (ne_of_im_ne (by rw [im3]; simp; linarith))
  have T4 := resY_term_cAt (α := α) (β := β) (t := t) (f := fun t => -vB β t)
    (d := fun t => vB β t) (g := fun t => uA α t - vB β t)
    cv.neg cv (cu.sub cv) hv0
    (ne_of_im_ne (by rw [im4]; simp; linarith)) (ne_of_im_ne (by rw [im4]; simp; linarith))
  have hG := Gammaℝ_uA_ne t (α := α) (by linarith)
  have hG' := Gammaℝ_vB_ne t (β := β) (by linarith)
  have G1 : ContinuousAt (fun t => Gammaℝ (uA α t)) t :=
    (differentiableAt_Gammaℝ hG).continuousAt.comp cu.continuousAt
  have G2 : ContinuousAt (fun t => Gammaℝ (vB β t)) t :=
    (differentiableAt_Gammaℝ hG').continuousAt.comp cv.continuousAt
  unfold resY
  exact (((T1.add T2).add T3).add T4).div (G1.mul G2) (mul_ne_zero hG hG')

theorem integrable_Ires {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) :
    Integrable fun t => (W.w t : ℂ) * resY α β t * (msq M a σ₀ t : ℂ) := by
  refine integrable_of_Icc (fun t ht => ContinuousAt.continuousWithinAt ?_)
    fun t ht => w_zero_mul W ht _ _
  have ht1 : 1 ≤ t := by linarith [ht.1]
  exact (((Complex.continuous_ofReal.comp W.cont).continuousAt).mul
    (continuousAt_resY hα hβ ht1)).mul
    (Complex.continuous_ofReal.comp (continuous_msq M a σ₀)).continuousAt

/-- The majorant of the terms of `S1`: `(m+1)^(−12/5)(n+1)^(−12/5)` is summable on `ℕ × ℕ`. -/
theorem summable_major :
    Summable fun p : ℕ × ℕ => ((p.1 : ℝ) + 1) ^ (-(12 / 5) : ℝ) * ((p.2 : ℝ) + 1) ^ (-(12 / 5) : ℝ) := by
  have h : Summable fun m : ℕ => ‖((m : ℝ) + 1) ^ (-(12 / 5) : ℝ)‖ := by
    have := (summable_succ_rpow (r := -(12 / 5)) (by norm_num)).abs
    simpa [Real.norm_eq_abs] using this
  exact summable_mul_of_summable_norm h h

/-- `y^(−2/5) · y^(−2) = y^(−12/5)`. -/
theorem rpow_combine {y : ℝ} (hy : 0 < y) : y ^ (-(2 / 5) : ℝ) * y ^ (-2 : ℝ) = y ^ (-(12 / 5) : ℝ) := by
  rw [← Real.rpow_add hy]
  norm_num

/-- A term of `S1`, bounded on `1 ≤ t ≤ B` by `C N B² (m+1)^(−12/5)(n+1)^(−12/5)`. -/
theorem S1_term_bound {C : ℝ} (hC0 : 0 ≤ C)
    (hC : ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖VY α β c x t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * (t / x) ^ (2 : ℝ))
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c) {B t : ℝ}
    (ht : 1 ≤ t) (htB : t ≤ B) (p : ℕ × ℕ) :
    ‖((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
        VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t‖ ≤
      C * (1 + 1 / ‖α + β‖ ^ 2) * B ^ 2 *
        (((p.1 : ℝ) + 1) ^ (-(12 / 5) : ℝ) * ((p.2 : ℝ) + 1) ^ (-(12 / 5) : ℝ)) := by
  obtain ⟨a1, a2⟩ := re_small hα
  obtain ⟨b1, b2⟩ := re_small hβ
  set m : ℝ := (p.1 : ℝ) + 1 with hm
  set n : ℝ := (p.2 : ℝ) + 1 with hn
  have hm1 : 1 ≤ m := by rw [hm]; linarith [(p.1.cast_nonneg : (0 : ℝ) ≤ p.1)]
  have hn1 : 1 ≤ n := by rw [hn]; linarith [(p.2.cast_nonneg : (0 : ℝ) ≤ p.2)]
  have hm0 : 0 < m := by linarith
  have hn0 : 0 < n := by linarith
  have hx : 0 < m * n := by positivity
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  have hN0 : 0 ≤ N := by positivity
  have e1 : ‖((p.1 : ℂ) + 1) ^ (-uA α t)‖ = m ^ (-(1 / 2 + α.re)) := by
    rw [norm_succ_cpow, Complex.neg_re, uA_re]
  have e2 : ‖((p.2 : ℂ) + 1) ^ (-vB β t)‖ = n ^ (-(1 / 2 + β.re)) := by
    rw [norm_succ_cpow, Complex.neg_re, vB_re]
  have f1 : m ^ (-(1 / 2 + α.re)) ≤ m ^ (-(2 / 5) : ℝ) :=
    Real.rpow_le_rpow_of_exponent_le hm1 (by linarith)
  have f2 : n ^ (-(1 / 2 + β.re)) ≤ n ^ (-(2 / 5) : ℝ) :=
    Real.rpow_le_rpow_of_exponent_le hn1 (by linarith)
  have hV := hC α β hα hβ t ht (m * n) hx c hc
  have hq : (t / (m * n)) ^ (2 : ℝ) ≤ B ^ 2 * (m ^ (-2 : ℝ) * n ^ (-2 : ℝ)) := by
    have ht0 : 0 ≤ t := by linarith
    rw [Real.rpow_two, div_pow, Real.rpow_neg hm0.le, Real.rpow_neg hn0.le, Real.rpow_two,
      Real.rpow_two]
    have h2 : t ^ 2 ≤ B ^ 2 := pow_le_pow_left₀ ht0 htB 2
    have : t ^ 2 / (m * n) ^ 2 = t ^ 2 * ((m ^ 2)⁻¹ * (n ^ 2)⁻¹) := by
      field_simp
      try ring
    rw [this]
    exact mul_le_mul_of_nonneg_right h2 (by positivity)
  have hV' : ‖VY α β c (m * n) t‖ ≤ C * N * (B ^ 2 * (m ^ (-2 : ℝ) * n ^ (-2 : ℝ))) :=
    hV.trans (mul_le_mul_of_nonneg_left hq (by positivity))
  rw [norm_mul, norm_mul, e1, e2]
  have hm' : 0 ≤ m ^ (-(2 / 5) : ℝ) := by positivity
  have hn' : 0 ≤ n ^ (-(2 / 5) : ℝ) := by positivity
  calc m ^ (-(1 / 2 + α.re)) * n ^ (-(1 / 2 + β.re)) * ‖VY α β c (m * n) t‖ ≤
        (m ^ (-(2 / 5) : ℝ) * n ^ (-(2 / 5) : ℝ)) * (C * N * (B ^ 2 * (m ^ (-2 : ℝ) * n ^ (-2 : ℝ)))) :=
        mul_le_mul (mul_le_mul f1 f2 (by positivity) hm') hV' (norm_nonneg _) (by positivity)
    _ = C * N * B ^ 2 * ((m ^ (-(2 / 5) : ℝ) * m ^ (-2 : ℝ)) * (n ^ (-(2 / 5) : ℝ) * n ^ (-2 : ℝ))) := by
        ring
    _ = C * N * B ^ 2 * (m ^ (-(12 / 5) : ℝ) * n ^ (-(12 / 5) : ℝ)) := by
        rw [rpow_combine hm0, rpow_combine hn0]

/-- `S1 α β c` is continuous on `[1, B]`. -/
theorem continuousOn_S1 {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c)
    (B : ℝ) : ContinuousOn (fun t => S1 α β c t) (Set.Icc 1 B) := by
  obtain ⟨C, hC0, hC⟩ := VY_decay (A := 2) (by norm_num)
  unfold S1
  refine continuousOn_tsum (fun p => Continuous.continuousOn ?_)
    ((summable_major).mul_left (C * (1 + 1 / ‖α + β‖ ^ 2) * B ^ 2))
    fun p t ht => S1_term_bound hC0 hC hα hβ hc ht.1 ht.2 p
  have h1 : ((p.1 : ℂ) + 1) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero p.1
  have h2 : ((p.2 : ℂ) + 1) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero p.2
  have hx : (0 : ℝ) < ((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1) := by positivity
  exact (((continuous_uA α).neg.const_cpow (Or.inl h1)).mul
    ((continuous_vB β).neg.const_cpow (Or.inl h2))).mul (continuous_VY hc hα hβ hx)

theorem integrable_I1 {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c) :
    Integrable fun t => (W.w t : ℂ) * S1 α β c t * (msq M a σ₀ t : ℂ) := by
  refine integrable_of_Icc ?_ fun t ht => w_zero_mul W ht _ _
  have hsub : Set.Icc (T / 4) (2 * T) ⊆ Set.Icc 1 (2 * T) := fun t ht => ⟨by linarith [ht.1], ht.2⟩
  exact (((Complex.continuous_ofReal.comp W.cont).continuousOn).mul
    ((continuousOn_S1 hα hβ hc (2 * T)).mono hsub)).mul
    (Complex.continuous_ofReal.comp (continuous_msq M a σ₀)).continuousOn

/-- **Part 2, the split.** `I(α,β) = I₁ + I_X − I_res`, for `T ≥ 4`, `‖α‖, ‖β‖ ≤ 1/10`,
`α + β ≠ 0`, `c ≥ 7/10`. -/
theorem I_split {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {c : ℝ} (hc : 7 / 10 ≤ c) :
    Imom W M a σ₀ α β = I1 W M a σ₀ α β c + IX W M a σ₀ α β c - Ires W M a σ₀ α β := by
  have hc0 : 0 < c := by linarith
  have h0 := integrable_Imom W M a σ₀ hα hβ
  have h1 := integrable_I1 W hT M a σ₀ hα hβ hc0
  have h3 := integrable_Ires W hT M a σ₀ hα hβ
  have hsplit := integrand_split W hT M a σ₀ hα hβ hαβ hc
  have h2 : Integrable fun t => (W.w t : ℂ) * (XY α β t * S1 (-β) (-α) c t) * (msq M a σ₀ t : ℂ) := by
    refine ((h0.sub h1).add h3).congr (ae_of_all _ fun t => ?_)
    simp only [Pi.add_apply, Pi.sub_apply]
    rw [hsplit t]
    ring
  unfold Imom I1 IX Ires
  set f1 := fun t => (W.w t : ℂ) * S1 α β c t * (msq M a σ₀ t : ℂ) with hf1
  set f2 := fun t => (W.w t : ℂ) * (XY α β t * S1 (-β) (-α) c t) * (msq M a σ₀ t : ℂ) with hf2
  set f3 := fun t => (W.w t : ℂ) * resY α β t * (msq M a σ₀ t : ℂ) with hf3
  calc _ = ∫ t, ((f1 t + f2 t) - f3 t) := integral_congr_ae (ae_of_all _ fun t => hsplit t)
    _ = (∫ t, (f1 t + f2 t)) - ∫ t, f3 t := integral_sub (h1.add h2) h3
    _ = (∫ t, f1 t) + (∫ t, f2 t) - ∫ t, f3 t := by rw [integral_add h1 h2]

/-! ### The remainder term is negligible -/

/-- `‖∫ f‖ ≤ K (b − a)` for `f` vanishing off `[a, b]` with `‖f‖ ≤ K` there. -/
theorem norm_integral_le_Icc {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] {f : ℝ → E}
    {a b K : ℝ} (hab : a ≤ b) (h0 : ∀ t, t ∉ Set.Icc a b → f t = 0)
    (hK : ∀ t ∈ Set.Icc a b, ‖f t‖ ≤ K) : ‖∫ t, f t‖ ≤ K * (b - a) := by
  rw [← setIntegral_eq_integral_of_forall_compl_eq_zero h0]
  refine (norm_setIntegral_le_of_norm_le_const measure_Icc_lt_top hK).trans_eq ?_
  simp [Measure.real, Real.volume_Icc, ENNReal.toReal_ofReal (sub_nonneg.mpr hab)]

/-- **The resY-term.** `‖I_res‖ ≤ C N B_ψ T e^(−T²/32)`, `B_ψ = (Σ_{h ≤ M} |a_h| h^(−σ₀))²`,
`N = 1 + ‖α+β‖^(−2)`, for `T ≥ 4`, `‖α‖, ‖β‖ ≤ 1/10`; from `resY_small`. -/
theorem Ires_small :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (T L : ℝ) (W : Weight T L), 4 ≤ T →
      ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ), ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 →
        ‖Ires W M a σ₀ α β‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) *
          (∑ h ∈ Finset.Icc 1 M, ‖a h‖ * (h : ℝ) ^ (-σ₀)) ^ 2 * T * Real.exp (-(T ^ 2 / 32)) := by
  obtain ⟨C, hC0, hC⟩ := resY_small
  refine ⟨2 * C, by positivity, fun T L W hT M a σ₀ α β hα hβ => ?_⟩
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  set Bψ : ℝ := (∑ h ∈ Finset.Icc 1 M, ‖a h‖ * (h : ℝ) ^ (-σ₀)) ^ 2 with hB
  have hN0 : 0 ≤ N := by positivity
  have hB0 : 0 ≤ Bψ := by positivity
  have hE : 0 ≤ Real.exp (-(T ^ 2 / 32)) := (Real.exp_pos _).le
  have hT0 : 0 < T := by linarith
  have hK : ∀ t ∈ Set.Icc (T / 4) (2 * T),
      ‖(W.w t : ℂ) * resY α β t * (msq M a σ₀ t : ℂ)‖ ≤ C * N * Bψ * Real.exp (-(T ^ 2 / 32)) := by
    intro t ht
    have ht1 : 1 ≤ t := by linarith [ht.1]
    have hr := hC α β hα hβ t ht1
    have hex : Real.exp (-(t ^ 2 / 2)) ≤ Real.exp (-(T ^ 2 / 32)) := by
      apply Real.exp_le_exp.mpr
      have : T / 4 ≤ t := ht.1
      nlinarith
    have hw : ‖((W.w t : ℝ) : ℂ)‖ ≤ 1 := by
      rw [Complex.norm_real, Real.norm_eq_abs]; exact W.abs_le_one t
    have hm : ‖((msq M a σ₀ t : ℝ) : ℂ)‖ ≤ Bψ := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (msq_nonneg M a σ₀ t)]
      exact msq_le M a σ₀ t
    have hr' : ‖resY α β t‖ ≤ C * N * Real.exp (-(T ^ 2 / 32)) :=
      hr.trans (mul_le_mul_of_nonneg_left hex (by positivity))
    rw [norm_mul, norm_mul]
    calc ‖((W.w t : ℝ) : ℂ)‖ * ‖resY α β t‖ * ‖((msq M a σ₀ t : ℝ) : ℂ)‖ ≤
          1 * (C * N * Real.exp (-(T ^ 2 / 32))) * Bψ :=
          mul_le_mul (mul_le_mul hw hr' (norm_nonneg _) zero_le_one) hm (norm_nonneg _)
            (by positivity)
      _ = C * N * Bψ * Real.exp (-(T ^ 2 / 32)) := by ring
  have h := norm_integral_le_Icc (by linarith) (fun t ht => w_zero_mul W ht _ _) hK
  unfold Ires
  calc _ ≤ C * N * Bψ * Real.exp (-(T ^ 2 / 32)) * (2 * T - T / 4) := h
    _ ≤ C * N * Bψ * Real.exp (-(T ^ 2 / 32)) * (2 * T) :=
        mul_le_mul_of_nonneg_left (by linarith) (by positivity)
    _ = 2 * C * N * Bψ * T * Real.exp (-(T ^ 2 / 32)) := by ring

/-! ### Young's (5.1): `I₁` as a sum over `h, k, m, n` -/

/-- The coefficient of the `(h, k, m, n)` term of `I₁`:
`a_h ā_k h^(−σ₀) k^(−σ₀) m^(−1/2−α) n^(−1/2−β)`. -/
noncomputable
def coefY (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) (h k m n : ℕ) : ℂ :=
  a h * (starRingEnd ℂ) (a k) * ((h : ℂ) ^ (-(σ₀ : ℂ)) * (k : ℂ) ^ (-(σ₀ : ℂ)) *
    (m : ℂ) ^ (-(1 / 2 + α)) * (n : ℂ) ^ (-(1 / 2 + β)))

/-- The integral of the `(h, k, m, n)` term: `∫ w(t) V_{α,β}(mn,t) (hm/kn)^(−it) dt`. -/
noncomputable
def Jint {T L : ℝ} (W : Weight T L) (α β : ℂ) (c : ℝ) (h k m n : ℕ) : ℂ :=
  ∫ t, (W.w t : ℂ) * VY α β c ((m : ℝ) * n) t * ((h : ℂ) * m / ((k : ℂ) * n)) ^ (-((t : ℂ) * I))

/-- The four factors `h^(−σ₀−it) k^(−σ₀+it) m^(−u) n^(−v)` in Young's form. -/
theorem coef4 {h k m n : ℝ} (hh : 0 < h) (hk : 0 < k) (hm : 0 < m) (hn : 0 < n) (σ₀ t : ℝ)
    (α β : ℂ) :
    (h : ℂ) ^ (-((σ₀ : ℂ) + t * I)) * (k : ℂ) ^ (-((σ₀ : ℂ) - t * I)) *
        ((m : ℂ) ^ (-uA α t) * (n : ℂ) ^ (-vB β t)) =
      ((h : ℂ) ^ (-(σ₀ : ℂ)) * (k : ℂ) ^ (-(σ₀ : ℂ)) * (m : ℂ) ^ (-(1 / 2 + α)) *
        (n : ℂ) ^ (-(1 / 2 + β))) * ((h : ℂ) * m / ((k : ℂ) * n)) ^ (-((t : ℂ) * I)) := by
  have e : ((h : ℂ) * m / ((k : ℂ) * n)) = ((h * m / (k * n) : ℝ) : ℂ) := by
    push_cast
    ring
  have hr : 0 < h * m / (k * n) := by positivity
  have h0 : (h : ℂ) ≠ 0 := ofReal_ne_zero.mpr hh.ne'
  have k0 : (k : ℂ) ≠ 0 := ofReal_ne_zero.mpr hk.ne'
  have m0 : (m : ℂ) ≠ 0 := ofReal_ne_zero.mpr hm.ne'
  have n0 : (n : ℂ) ≠ 0 := ofReal_ne_zero.mpr hn.ne'
  have r0 : ((h * m / (k * n) : ℝ) : ℂ) ≠ 0 := ofReal_ne_zero.mpr hr.ne'
  rw [e]
  simp only [cpow_def_of_ne_zero h0, cpow_def_of_ne_zero k0, cpow_def_of_ne_zero m0,
    cpow_def_of_ne_zero n0, cpow_def_of_ne_zero r0]
  rw [← ofReal_log hr.le, Real.log_div (by positivity) (by positivity),
    Real.log_mul hh.ne' hm.ne', Real.log_mul hk.ne' hn.ne', ← ofReal_log hh.le,
    ← ofReal_log hk.le, ← ofReal_log hm.le, ← ofReal_log hn.le]
  simp only [← Complex.exp_add]
  congr 1
  push_cast
  unfold uA vB
  ring

/-- The `(h, k)` factor `h^(−σ₀−it) k^(−σ₀+it)` of `|ψ|²`. -/
noncomputable
def Ehk (σ₀ : ℝ) (h k : ℕ) (t : ℝ) : ℂ :=
  (h : ℂ) ^ (-((σ₀ : ℂ) + t * I)) * (k : ℂ) ^ (-((σ₀ : ℂ) - t * I))

theorem continuous_Ehk (σ₀ : ℝ) {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) : Continuous (Ehk σ₀ h k) := by
  have h0 : (h : ℂ) ≠ 0 := by exact_mod_cast (show h ≠ 0 by omega)
  have k0 : (k : ℂ) ≠ 0 := by exact_mod_cast (show k ≠ 0 by omega)
  unfold Ehk
  exact ((by fun_prop : Continuous fun t : ℝ => -((σ₀ : ℂ) + t * I)).const_cpow (Or.inl h0)).mul
    ((by fun_prop : Continuous fun t : ℝ => -((σ₀ : ℂ) - t * I)).const_cpow (Or.inl k0))

theorem norm_Ehk (σ₀ : ℝ) {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) (t : ℝ) :
    ‖Ehk σ₀ h k t‖ = (h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀) := by
  unfold Ehk
  rw [norm_mul, Complex.norm_natCast_cpow_of_pos (by omega),
    Complex.norm_natCast_cpow_of_pos (by omega)]
  simp

/-- The `p`-th term of `S1`. -/
noncomputable
def S1term (α β : ℂ) (c t : ℝ) (p : ℕ × ℕ) : ℂ :=
  ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
    VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t

/-- One `(h, k, p)` term, integrated: it is `coefY · Jint`. -/
theorem term_integral {T L : ℝ} (W : Weight T L) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) (c : ℝ)
    {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) (p : ℕ × ℕ) :
    a h * (starRingEnd ℂ) (a k) * ∫ t, (W.w t : ℂ) * S1term α β c t p * Ehk σ₀ h k t =
      coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1) := by
  have hh0 : (0 : ℝ) < h := by exact_mod_cast hh
  have hk0 : (0 : ℝ) < k := by exact_mod_cast hk
  have hm0 : (0 : ℝ) < (p.1 : ℝ) + 1 := by positivity
  have hn0 : (0 : ℝ) < (p.2 : ℝ) + 1 := by positivity
  have hpt : ∀ t, (W.w t : ℂ) * S1term α β c t p * Ehk σ₀ h k t =
      ((h : ℂ) ^ (-(σ₀ : ℂ)) * (k : ℂ) ^ (-(σ₀ : ℂ)) * (((p.1 + 1 : ℕ) : ℂ)) ^ (-(1 / 2 + α)) *
        (((p.2 + 1 : ℕ) : ℂ)) ^ (-(1 / 2 + β))) *
      ((W.w t : ℂ) * VY α β c (((p.1 + 1 : ℕ) : ℝ) * ((p.2 + 1 : ℕ) : ℝ)) t *
        ((h : ℂ) * ((p.1 + 1 : ℕ) : ℂ) / ((k : ℂ) * ((p.2 + 1 : ℕ) : ℂ))) ^ (-((t : ℂ) * I))) := by
    intro t
    have c4 := coef4 hh0 hk0 hm0 hn0 σ₀ t α β
    push_cast at c4 ⊢
    unfold S1term Ehk
    linear_combination (W.w t : ℂ) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t * c4
  simp only [hpt]
  rw [integral_const_mul]
  unfold coefY Jint
  ring

theorem continuous_S1term {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c)
    (p : ℕ × ℕ) : Continuous fun t => S1term α β c t p := by
  have h1 : ((p.1 : ℂ) + 1) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero p.1
  have h2 : ((p.2 : ℂ) + 1) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero p.2
  have hx : (0 : ℝ) < ((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1) := by positivity
  unfold S1term
  exact (((continuous_uA α).neg.const_cpow (Or.inl h1)).mul
    ((continuous_vB β).neg.const_cpow (Or.inl h2))).mul (continuous_VY hc hα hβ hx)

/-- The domination behind Fubini for the `(h, k)` piece: each term is integrable and the
integrals of the norms are summable over `p` (by `summable_major`). -/
theorem hk_dom {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (σ₀ : ℝ) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c) {h k : ℕ} (hh : 1 ≤ h)
    (hk : 1 ≤ k) :
    (∀ p : ℕ × ℕ, Integrable fun t => (W.w t : ℂ) * S1term α β c t p * Ehk σ₀ h k t) ∧
      Summable fun p : ℕ × ℕ => ∫ t, ‖(W.w t : ℂ) * S1term α β c t p * Ehk σ₀ h k t‖ := by
  obtain ⟨C, hC0, hC⟩ := VY_decay (A := 2) (by norm_num)
  set F : ℕ × ℕ → ℝ → ℂ := fun p t => (W.w t : ℂ) * S1term α β c t p * Ehk σ₀ h k t with hF
  have hT0 : 0 < T := by linarith
  set K : ℝ := C * (1 + 1 / ‖α + β‖ ^ 2) * (2 * T) ^ 2 * ((h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀))
    with hK
  have hK0 : 0 ≤ K := by positivity
  have hzero : ∀ p t, t ∉ Set.Icc (T / 4) (2 * T) → F p t = 0 := fun p t ht => by
    simp only [hF]
    exact w_zero_mul W ht _ _
  have hint : ∀ p, Integrable (F p) := fun p =>
    integrable_of_Icc ((((Complex.continuous_ofReal.comp W.cont).mul
      (continuous_S1term hα hβ hc p)).mul (continuous_Ehk σ₀ hh hk)).continuousOn) (hzero p)
  have hbd : ∀ p, ∀ t ∈ Set.Icc (T / 4) (2 * T), ‖F p t‖ ≤ K *
      (((p.1 : ℝ) + 1) ^ (-(12 / 5) : ℝ) * ((p.2 : ℝ) + 1) ^ (-(12 / 5) : ℝ)) := by
    intro p t ht
    have ht1 : 1 ≤ t := by linarith [ht.1]
    have b1 := S1_term_bound hC0 hC hα hβ hc ht1 ht.2 p
    have hw : ‖((W.w t : ℝ) : ℂ)‖ ≤ 1 := by
      rw [Complex.norm_real, Real.norm_eq_abs]; exact W.abs_le_one t
    simp only [hF]
    rw [norm_mul, norm_mul, norm_Ehk σ₀ hh hk]
    have hE0 : 0 ≤ (h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀) := by positivity
    calc ‖((W.w t : ℝ) : ℂ)‖ * ‖S1term α β c t p‖ * ((h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀)) ≤
          1 * (C * (1 + 1 / ‖α + β‖ ^ 2) * (2 * T) ^ 2 *
            (((p.1 : ℝ) + 1) ^ (-(12 / 5) : ℝ) * ((p.2 : ℝ) + 1) ^ (-(12 / 5) : ℝ))) *
            ((h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀)) :=
          mul_le_mul_of_nonneg_right (mul_le_mul hw b1 (norm_nonneg _) zero_le_one) hE0
      _ = _ := by rw [hK]; ring
  refine ⟨hint, ?_⟩
  refine Summable.of_nonneg_of_le (fun p => integral_nonneg fun t => norm_nonneg _)
    (fun p => ?_) ((summable_major.mul_left K).mul_right (2 * T - T / 4))
  have h1 := norm_integral_le_Icc (f := fun t => ‖F p t‖) (a := T / 4) (b := 2 * T) (by linarith)
    (fun t ht => by simp [hzero p t ht]) (fun t ht => by rw [norm_norm]; exact hbd p t ht)
  rw [Real.norm_eq_abs, abs_of_nonneg (integral_nonneg fun t => norm_nonneg _)] at h1
  exact h1

/-- The `(h, k)` piece of `I₁` is the sum over `p` of its integrated terms (Fubini for the
`tsum`). -/
theorem integral_hk {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (σ₀ : ℝ) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c) {h k : ℕ} (hh : 1 ≤ h)
    (hk : 1 ≤ k) :
    ∫ t, (W.w t : ℂ) * S1 α β c t * Ehk σ₀ h k t =
      ∑' p : ℕ × ℕ, ∫ t, (W.w t : ℂ) * S1term α β c t p * Ehk σ₀ h k t := by
  obtain ⟨hint, hsum⟩ := hk_dom W hT σ₀ hα hβ hc hh hk
  rw [integral_tsum_of_summable_integral_norm hint hsum]
  refine integral_congr_ae (ae_of_all _ fun t => ?_)
  beta_reduce
  unfold S1
  rw [← tsum_mul_left, ← tsum_mul_right]
  rfl

/-- The `(h, k)` terms `coefY · Jint` are absolutely summable over `p`. -/
theorem summable_hk {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (a : ℕ → ℂ) (σ₀ : ℝ) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c) {h k : ℕ} (hh : 1 ≤ h)
    (hk : 1 ≤ k) :
    Summable fun p : ℕ × ℕ =>
      ‖coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1)‖ := by
  obtain ⟨_, hsum⟩ := hk_dom W hT σ₀ hα hβ hc hh hk
  refine Summable.of_nonneg_of_le (fun p => norm_nonneg _) (fun p => ?_)
    (hsum.mul_left ‖a h * (starRingEnd ℂ) (a k)‖)
  rw [← term_integral W a σ₀ α β c hh hk p, norm_mul]
  exact mul_le_mul_of_nonneg_left (norm_integral_le_integral_norm _) (norm_nonneg _)

/-- **Young's (5.1).** `I₁ = Σ_{h,k ≤ M} Σ_{m,n ≥ 1} coefY(h,k,m,n) · Jint(h,k,m,n)`, for `T ≥ 4`,
`‖α‖, ‖β‖ ≤ 1/10`, `c > 0`. -/
theorem I1_expand {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c) :
    I1 W M a σ₀ α β c = ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, ∑' p : ℕ × ℕ,
      coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1) := by
  have hpt : ∀ t, (W.w t : ℂ) * S1 α β c t * (msq M a σ₀ t : ℂ) =
      ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M,
        a h * (starRingEnd ℂ) (a k) * ((W.w t : ℂ) * S1 α β c t * Ehk σ₀ h k t) := by
    intro t
    rw [msq_expand, Finset.mul_sum]
    refine Finset.sum_congr rfl fun h _ => ?_
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun k _ => ?_
    unfold Ehk
    ring
  have hG : ∀ h ∈ Finset.Icc 1 M, ∀ k ∈ Finset.Icc 1 M,
      Integrable fun t => a h * (starRingEnd ℂ) (a k) * ((W.w t : ℂ) * S1 α β c t * Ehk σ₀ h k t) := by
    intro h hh k hk
    have hh1 := (Finset.mem_Icc.mp hh).1
    have hk1 := (Finset.mem_Icc.mp hk).1
    refine (integrable_of_Icc ?_ fun t ht => w_zero_mul W ht _ _).const_mul _
    have hsub : Set.Icc (T / 4) (2 * T) ⊆ Set.Icc 1 (2 * T) := fun t ht =>
      ⟨by linarith [ht.1], ht.2⟩
    exact (((Complex.continuous_ofReal.comp W.cont).continuousOn).mul
      ((continuousOn_S1 hα hβ hc (2 * T)).mono hsub)).mul (continuous_Ehk σ₀ hh1 hk1).continuousOn
  unfold I1
  simp only [hpt]
  rw [integral_finsetSum _ fun h hh => integrable_finsetSum _ fun k hk => hG h hh k hk]
  refine Finset.sum_congr rfl fun h hh => ?_
  rw [integral_finsetSum _ fun k hk => hG h hh k hk]
  refine Finset.sum_congr rfl fun k hk => ?_
  have hh1 := (Finset.mem_Icc.mp hh).1
  have hk1 := (Finset.mem_Icc.mp hk).1
  rw [integral_const_mul, integral_hk W hT σ₀ hα hβ hc hh1 hk1, ← tsum_mul_left]
  exact tsum_congr fun p => term_integral W a σ₀ α β c hh1 hk1 p

/-! ### The diagonal and the off-diagonal of `I₁` -/

section Split

variable {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) (c : ℝ)

/-- **The diagonal `hm = kn`** of `I₁`, exactly, Young's first term of (4.4) summed in (5.1):
`Σ_{h,k ≤ M} Σ_{hm = kn} a_h ā_k (hk)^(−σ₀) m^(−1/2−α) n^(−1/2−β) ∫ w(t) V(mn,t) dt`. -/
noncomputable
def diagSum : ℂ :=
  ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, ∑' p : ℕ × ℕ,
    if h * (p.1 + 1) = k * (p.2 + 1) then
      coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1) else 0

/-- **The off-diagonal `hm ≠ kn`** of `I₁`. -/
noncomputable
def offSum : ℂ :=
  ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, ∑' p : ℕ × ℕ,
    if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
      coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1)

end Split

/-- On the diagonal the twist is `1`: `Jint = ∫ w(t) V(mn,t) dt` when `hm = kn`. -/
theorem Jint_diag {T L : ℝ} (W : Weight T L) (α β : ℂ) (c : ℝ) {h k m n : ℕ} (hk : 1 ≤ k)
    (hn : 1 ≤ n) (hd : h * m = k * n) :
    Jint W α β c h k m n = ∫ t, (W.w t : ℂ) * VY α β c ((m : ℝ) * n) t := by
  have hq : ((k : ℂ) * n) ≠ 0 := by
    have : k * n ≠ 0 := Nat.mul_ne_zero (by omega) (by omega)
    exact_mod_cast this
  have e : (h : ℂ) * m / ((k : ℂ) * n) = 1 := by
    rw [div_eq_one_iff_eq hq]
    exact_mod_cast hd
  unfold Jint
  simp only [e, Complex.one_cpow, mul_one]

/-- **`I₁` = diagonal + off-diagonal**, for `T ≥ 4`, `‖α‖, ‖β‖ ≤ 1/10`, `c > 0`. -/
theorem I1_diag_off {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c) :
    I1 W M a σ₀ α β c = diagSum W M a σ₀ α β c + offSum W M a σ₀ α β c := by
  rw [I1_expand W hT M a σ₀ hα hβ hc]
  unfold diagSum offSum
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun h hh => ?_
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun k hk => ?_
  have hs := summable_hk W hT a σ₀ hα hβ hc (Finset.mem_Icc.mp hh).1 (Finset.mem_Icc.mp hk).1
  set f : ℕ × ℕ → ℂ := fun p =>
    coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1) with hf
  have s1 : Summable fun p : ℕ × ℕ => if h * (p.1 + 1) = k * (p.2 + 1) then f p else 0 :=
    Summable.of_norm_bounded hs fun p => by
      split_ifs <;> simp [hf]
      positivity
  have s2 : Summable fun p : ℕ × ℕ => if h * (p.1 + 1) = k * (p.2 + 1) then 0 else f p :=
    Summable.of_norm_bounded hs fun p => by
      split_ifs <;> simp [hf]
      positivity
  rw [← Summable.tsum_add s1 s2]
  exact tsum_congr fun p => by split_ifs <;> simp [hf]

/-! ### The off-diagonal, summed with `j = 2` -/

/-- The term of the off-diagonal series: `(mn)^(3/5) (1 + mn/(2T))^(−3)`, `m = p.1+1`, `n = p.2+1`. -/
noncomputable
def offTerm (T : ℝ) (p : ℕ × ℕ) : ℝ :=
  (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) ^ (3 / 5 : ℝ) *
    (1 + ((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1) / (2 * T)) ^ (-3 : ℝ)

/-- **The off-diagonal series** `Σ_{m,n ≥ 1} (mn)^(3/5) (1 + mn/(2T))^(−3)`. -/
noncomputable
def offSeries (T : ℝ) : ℝ := ∑' p : ℕ × ℕ, offTerm T p

theorem offTerm_nonneg {T : ℝ} (hT : 0 < T) (p : ℕ × ℕ) : 0 ≤ offTerm T p := by
  unfold offTerm
  positivity

theorem offTerm_le {T : ℝ} (hT : 0 < T) (p : ℕ × ℕ) :
    offTerm T p ≤ (2 * T) ^ (3 : ℝ) *
      (((p.1 : ℝ) + 1) ^ (-(12 / 5) : ℝ) * ((p.2 : ℝ) + 1) ^ (-(12 / 5) : ℝ)) := by
  have hm : (0 : ℝ) < (p.1 : ℝ) + 1 := by positivity
  have hn : (0 : ℝ) < (p.2 : ℝ) + 1 := by positivity
  set x : ℝ := ((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1) with hx
  have hx0 : 0 < x := by positivity
  have h2T : 0 < 2 * T := by linarith
  have h1 : (1 + x / (2 * T)) ^ (-3 : ℝ) ≤ (x / (2 * T)) ^ (-3 : ℝ) :=
    Real.rpow_le_rpow_of_nonpos (by positivity) (by linarith) (by norm_num)
  have h2 : (x / (2 * T)) ^ (-3 : ℝ) = (2 * T) ^ (3 : ℝ) * x ^ (-3 : ℝ) := by
    rw [Real.div_rpow hx0.le h2T.le, Real.rpow_neg h2T.le]
    field_simp
    try ring
  have h3 : x ^ (3 / 5 : ℝ) * x ^ (-3 : ℝ) = ((p.1 : ℝ) + 1) ^ (-(12 / 5) : ℝ) *
      ((p.2 : ℝ) + 1) ^ (-(12 / 5) : ℝ) := by
    rw [← Real.rpow_add hx0, hx, ← Real.mul_rpow hm.le hn.le]
    norm_num
  unfold offTerm
  rw [← hx]
  calc x ^ (3 / 5 : ℝ) * (1 + x / (2 * T)) ^ (-3 : ℝ) ≤ x ^ (3 / 5 : ℝ) * (x / (2 * T)) ^ (-3 : ℝ) :=
        mul_le_mul_of_nonneg_left h1 (by positivity)
    _ = (2 * T) ^ (3 : ℝ) * (x ^ (3 / 5 : ℝ) * x ^ (-3 : ℝ)) := by rw [h2]; ring
    _ = _ := by rw [h3]

theorem summable_offTerm {T : ℝ} (hT : 0 < T) : Summable (offTerm T) :=
  Summable.of_nonneg_of_le (offTerm_nonneg hT) (offTerm_le hT)
    (summable_major.mul_left ((2 * T) ^ (3 : ℝ)))

theorem rpow_mul_self {x : ℝ} (hx : 0 < x) (s : ℝ) : x ^ s * x = x ^ (s + 1) := by
  rw [Real.rpow_add hx, Real.rpow_one]

/-- One off-diagonal term: `‖coefY · Jint‖ ≤ 4 P X_h X_k (mn)^(3/5)(1 + mn/(2T))^(−3)`,
`X_h = |a_h| h^(1−σ₀)`, `P` the prefactor of `offdiag_term_young` at `A = 3`. -/
theorem off_term_le {K : ℝ} (hK0 : 0 ≤ K)
    (hK : ∀ (T L : ℝ) (W : Weight T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ c : ℝ, 0 < c →
      ∀ h k m n : ℕ, 1 ≤ h → 1 ≤ k → 1 ≤ m → 1 ≤ n → h * m ≠ k * n →
        ‖∫ t, (W.w t : ℂ) * VY α β c ((m : ℝ) * n) t *
            ((h : ℂ) * m / ((k : ℂ) * n)) ^ (-((t : ℂ) * I))‖ ≤
          K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹ *
            (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) * (1 + (m : ℝ) * n / (2 * T)) ^ (-3 : ℝ))
    {T L : ℝ} (W : Weight T L) (hT : 8 ≤ T) (hL : 1 ≤ L) (a : ℕ → ℂ) (σ₀ : ℝ) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) {c : ℝ} (hc : 0 < c)
    {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) (p : ℕ × ℕ) (hd : h * (p.1 + 1) ≠ k * (p.2 + 1)) :
    ‖coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1)‖ ≤
      4 * (K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹) *
        ((‖a h‖ * (h : ℝ) ^ (1 - σ₀)) * (‖a k‖ * (k : ℝ) ^ (1 - σ₀))) * offTerm T p := by
  obtain ⟨a1, a2⟩ := re_small hα
  obtain ⟨b1, b2⟩ := re_small hβ
  have hJ := hK T L W hT hL α β hα hβ hαβ c hc h k (p.1 + 1) (p.2 + 1) hh hk (by omega)
    (by omega) hd
  rw [show (∫ t, (W.w t : ℂ) * VY α β c (((p.1 + 1 : ℕ) : ℝ) * ((p.2 + 1 : ℕ) : ℝ)) t *
      ((h : ℂ) * ((p.1 + 1 : ℕ) : ℂ) / ((k : ℂ) * ((p.2 + 1 : ℕ) : ℂ))) ^ (-((t : ℂ) * I))) =
      Jint W α β c h k (p.1 + 1) (p.2 + 1) from rfl] at hJ
  push_cast at hJ
  set m : ℝ := (p.1 : ℝ) + 1 with hm
  set n : ℝ := (p.2 : ℝ) + 1 with hn
  have hm0 : 0 < m := by positivity
  have hn0 : 0 < n := by positivity
  have hm1 : 1 ≤ m := by rw [hm]; linarith [(p.1.cast_nonneg : (0 : ℝ) ≤ p.1)]
  have hn1 : 1 ≤ n := by rw [hn]; linarith [(p.2.cast_nonneg : (0 : ℝ) ≤ p.2)]
  have hh0 : (0 : ℝ) < h := by exact_mod_cast hh
  have hk0 : (0 : ℝ) < k := by exact_mod_cast hk
  set P : ℝ := K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹ with hP
  have hP0 : 0 ≤ P := by
    have := W.C1_nonneg
    have := W.C2_nonneg
    have : (0 : ℝ) ≤ T := by linarith
    positivity
  set D : ℝ := (1 + m * n / (2 * T)) ^ (-3 : ℝ) with hD
  have hD0 : 0 ≤ D := by
    have : (0 : ℝ) < T := by linarith
    positivity
  have hcoef : ‖coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1)‖ = ‖a h‖ * ‖a k‖ *
      ((h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀) * m ^ (-(1 / 2 + α.re)) * n ^ (-(1 / 2 + β.re))) := by
    unfold coefY
    have e1 : (((p.1 + 1 : ℕ) : ℂ)) = ((m : ℝ) : ℂ) := by rw [hm]; push_cast; ring
    have e2 : (((p.2 + 1 : ℕ) : ℂ)) = ((n : ℝ) : ℂ) := by rw [hn]; push_cast; ring
    rw [e1, e2]
    simp only [norm_mul, Complex.norm_conj, Complex.norm_natCast_cpow_of_pos (by omega : 0 < h),
      Complex.norm_natCast_cpow_of_pos (by omega : 0 < k), norm_cpow_eq_rpow_re_of_pos hm0,
      norm_cpow_eq_rpow_re_of_pos hn0]
    simp
  have hJ' : ‖Jint W α β c h k (p.1 + 1) (p.2 + 1)‖ ≤ P * (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) * D :=
    hJ
  have em : m ^ (-(1 / 2 + α.re)) * m ≤ m ^ (3 / 5 : ℝ) := by
    rw [rpow_mul_self hm0]
    exact Real.rpow_le_rpow_of_exponent_le hm1 (by linarith)
  have en : n ^ (-(1 / 2 + β.re)) * n ≤ n ^ (3 / 5 : ℝ) := by
    rw [rpow_mul_self hn0]
    exact Real.rpow_le_rpow_of_exponent_le hn1 (by linarith)
  have eh : (h : ℝ) ^ (-σ₀) * h = (h : ℝ) ^ (1 - σ₀) := by
    rw [rpow_mul_self hh0]
    ring_nf
  have ek : (k : ℝ) ^ (-σ₀) * k = (k : ℝ) ^ (1 - σ₀) := by
    rw [rpow_mul_self hk0]
    ring_nf
  have hX : 0 ≤ (‖a h‖ * (h : ℝ) ^ (1 - σ₀)) * (‖a k‖ * (k : ℝ) ^ (1 - σ₀)) := by positivity
  rw [norm_mul, hcoef]
  calc ‖a h‖ * ‖a k‖ * ((h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀) * m ^ (-(1 / 2 + α.re)) *
        n ^ (-(1 / 2 + β.re))) * ‖Jint W α β c h k (p.1 + 1) (p.2 + 1)‖ ≤
      ‖a h‖ * ‖a k‖ * ((h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀) * m ^ (-(1 / 2 + α.re)) *
        n ^ (-(1 / 2 + β.re))) * (P * (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) * D) :=
        mul_le_mul_of_nonneg_left hJ' (by positivity)
    _ = 4 * P * ((‖a h‖ * ((h : ℝ) ^ (-σ₀) * h)) * (‖a k‖ * ((k : ℝ) ^ (-σ₀) * k))) *
          ((m ^ (-(1 / 2 + α.re)) * m) * (n ^ (-(1 / 2 + β.re)) * n) * D) := by ring
    _ = 4 * P * ((‖a h‖ * (h : ℝ) ^ (1 - σ₀)) * (‖a k‖ * (k : ℝ) ^ (1 - σ₀))) *
          ((m ^ (-(1 / 2 + α.re)) * m) * (n ^ (-(1 / 2 + β.re)) * n) * D) := by rw [eh, ek]
    _ ≤ 4 * P * ((‖a h‖ * (h : ℝ) ^ (1 - σ₀)) * (‖a k‖ * (k : ℝ) ^ (1 - σ₀))) *
          (m ^ (3 / 5 : ℝ) * n ^ (3 / 5 : ℝ) * D) := by
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        apply mul_le_mul_of_nonneg_right _ hD0
        exact mul_le_mul em en (by positivity) (by positivity)
    _ = 4 * P * ((‖a h‖ * (h : ℝ) ^ (1 - σ₀)) * (‖a k‖ * (k : ℝ) ^ (1 - σ₀))) * offTerm T p := by
        unfold offTerm
        rw [← hm, ← hn, Real.mul_rpow hm0.le hn0.le]

/-- **The off-diagonal, summed, with two integrations by parts.** There is `K` with
`‖offSum‖ ≤ K (1 + C₁ + C₂) N T Δ^(−2) (Σ_{h ≤ M} |a_h| h^(1−σ₀))² · offSeries T`,
for `T ≥ 8`, `L ≥ 1`, `‖α‖, ‖β‖ ≤ 1/10`, `α + β ≠ 0`, `c > 0`. -/
theorem offSum_bound :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : Weight T L), 8 ≤ T → 1 ≤ L →
      ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ), ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ c : ℝ, 0 < c →
        ‖offSum W M a σ₀ α β c‖ ≤ K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T *
          ((T / L) ^ 2)⁻¹ * (∑ h ∈ Finset.Icc 1 M, ‖a h‖ * (h : ℝ) ^ (1 - σ₀)) ^ 2 *
          offSeries T := by
  obtain ⟨K, hK0, hK⟩ := offdiag_term_young (A := 3) (by norm_num)
  refine ⟨4 * K, by positivity, fun T L W hT hL M a σ₀ α β hα hβ hαβ c hc => ?_⟩
  have hT0 : 0 < T := by linarith
  set P : ℝ := K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹ with hP
  have hP0 : 0 ≤ P := by
    have := W.C1_nonneg
    have := W.C2_nonneg
    positivity
  set X : ℕ → ℝ := fun h => ‖a h‖ * (h : ℝ) ^ (1 - σ₀) with hX
  have hS0 : 0 ≤ offSeries T := tsum_nonneg (offTerm_nonneg hT0)
  have hrow : ∀ h ∈ Finset.Icc 1 M, ∀ k ∈ Finset.Icc 1 M,
      ‖∑' p : ℕ × ℕ, (if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
        coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1))‖ ≤
        4 * P * (X h * X k) * offSeries T := by
    intro h hh k hk
    have hh1 := (Finset.mem_Icc.mp hh).1
    have hk1 := (Finset.mem_Icc.mp hk).1
    have hs := summable_hk W (by linarith) a σ₀ hα hβ hc hh1 hk1
    have hle : ∀ p : ℕ × ℕ, ‖(if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
        coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1))‖ ≤
        4 * P * (X h * X k) * offTerm T p := by
      intro p
      split_ifs with hd
      · rw [norm_zero]
        have := offTerm_nonneg hT0 p
        positivity
      · exact off_term_le hK0 hK W hT hL a σ₀ hα hβ hαβ hc hh1 hk1 p hd
    have hsn : Summable fun p : ℕ × ℕ => ‖(if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
        coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1))‖ :=
      Summable.of_nonneg_of_le (fun p => norm_nonneg _) (fun p => by
        split_ifs
        · rw [norm_zero]
          exact norm_nonneg _
        · exact le_rfl) hs
    calc _ ≤ ∑' p : ℕ × ℕ, ‖(if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
          coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1))‖ :=
          norm_tsum_le_tsum_norm hsn
      _ ≤ ∑' p : ℕ × ℕ, 4 * P * (X h * X k) * offTerm T p :=
          Summable.tsum_le_tsum hle hsn ((summable_offTerm hT0).mul_left _)
      _ = 4 * P * (X h * X k) * offSeries T := by
          rw [tsum_mul_left]
          rfl
  unfold offSum
  calc _ ≤ ∑ h ∈ Finset.Icc 1 M, ‖∑ k ∈ Finset.Icc 1 M, ∑' p : ℕ × ℕ,
        (if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
          coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1))‖ :=
        norm_sum_le _ _
    _ ≤ ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, 4 * P * (X h * X k) * offSeries T :=
        Finset.sum_le_sum fun h hh => (norm_sum_le _ _).trans
          (Finset.sum_le_sum fun k hk => hrow h hh k hk)
    _ = 4 * P * offSeries T * ((∑ h ∈ Finset.Icc 1 M, X h) * (∑ k ∈ Finset.Icc 1 M, X k)) := by
        rw [Finset.sum_mul_sum, Finset.mul_sum]
        refine Finset.sum_congr rfl fun h _ => ?_
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun k _ => ?_
        ring
    _ = _ := by
        rw [hP]
        simp only [hX]
        ring

/-! ## Parts 4 and 5, and Lemma 3: Young's mollifier, `c(α,β)`, the open statements -/

/-- `M = ⌊T^θ⌋`. -/
noncomputable
def Mof (T θ : ℝ) : ℕ := ⌊T ^ θ⌋₊

/-- `σ₀ = 1/2 − R/L`, `L = log T`. -/
noncomputable
def sig0 (T R : ℝ) : ℝ := 1 / 2 - R / Real.log T

/-- Young's mollifier coefficients: `ψ(s) = Σ_{h ≤ M} μ(h) P(log(M/h)/log M) h^(−(s+1/2−σ₀))`,
so `a_h = μ(h) P(log(M/h)/log M) h^(σ₀−1/2)` in `psi`. -/
noncomputable
def aY (P : Polynomial ℝ) (T θ R : ℝ) (h : ℕ) : ℂ :=
  ((ArithmeticFunction.moebius h : ℤ) : ℂ) *
    ((P.eval (Real.log ((Mof T θ : ℝ) / h) / Real.log (Mof T θ)) : ℝ) : ℂ) *
    (((h : ℝ) ^ (sig0 T R - 1 / 2) : ℝ) : ℂ)

/-- Young's (5.3): `c₁(α,β) = (1/((α+β) log M)) ∫₀¹ (P′(u) + α log M P(u))(P′(u) + β log M P(u)) du`. -/
noncomputable
def c1Y (P : Polynomial ℝ) (M : ℕ) (α β : ℂ) : ℂ :=
  1 / ((α + β) * Real.log M) * ∫ u in (0 : ℝ)..1,
    (((P.derivative.eval u : ℝ) : ℂ) + α * Real.log M * (P.eval u : ℝ)) *
      (((P.derivative.eval u : ℝ) : ℂ) + β * Real.log M * (P.eval u : ℝ))

/-- `c(α,β) = c₁(α,β) + T^(−α−β) c₁(−β,−α)`, Young's (3.3) in the form his §5 derives it
(`c₁(α,β) + c₁(−β,−α) = 1` and `(T^(−α−β) − 1) c₁(−β,−α)` the rest). -/
noncomputable
def cY (P : Polynomial ℝ) (M : ℕ) (T : ℝ) (α β : ℂ) : ℂ :=
  c1Y P M α β + (T : ℂ) ^ (-(α + β)) * c1Y P M (-β) (-α)

/-- Young's range `α, β ≪ 1/L` with `|α + β| ≫ 1/L` (Lemma 6's), constant `κ`, `L = log T`. -/
noncomputable
def Regime (κ T : ℝ) (α β : ℂ) : Prop :=
  ‖α‖ ≤ κ / Real.log T ∧ ‖β‖ ≤ κ / Real.log T ∧ 1 / (κ * Real.log T) ≤ ‖α + β‖

/-- The error size `(1 + C₁ + C₂)·T/L`. -/
noncomputable
def errY {T L : ℝ} (W : Weight T L) : ℝ := (1 + W.C1 + W.C2) * (T / L)

/-- OPEN, **Part 4, the diagonal** (Young's Lemma 6 for the diagonal `I₁` of (5.1)):
`diagSum = c₁(α,β) ŵ(0) + O(T/L)`. Route: Young §6, the Mellin formula (6.1), the Euler
product (6.2) with `A_{0,0}(0,0,0) = 1` (§7), the shift to `Re s = −δ + ε` past the pole of
`ζ(1+α+β+2s)` cancelled by the zero of `p(s)`, and Lemma 7. -/
noncomputable
def StmtDiag (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
    Regime κ T α β →
      ‖diagSum W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 -
        c1Y P (Mof T θ) α β * (what0 W : ℂ)‖ ≤ C * errY W

/-- OPEN, **Part 3 summed, the off-diagonal** (Young's Lemma 5, its `hm ≠ kn` part):
`offSum = O(T/L)` for `θ < 1/2`. `offSum_bound` proves it with `j = 2`, up to
`offSeries T`; that route closes only for small `θ` (the header gives the factor). -/
noncomputable
def StmtOffDiag (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
    Regime κ T α β →
      ‖offSum W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1‖ ≤ C * errY W

/-- OPEN, **Part 5, the X-term**: `I_X(α,β) = T^(−α−β) I₁(−β,−α) + O(T/L)`. Route: (4.2) in its
asymptotic form `X_{α,β,t} = (t/2π)^(−α−β)(1 + O(1/t))` (`XY_size` gives only the size),
`(t/(2πT))^(−α−β) = 1 + O(1/L)` on `[T/4, 2T]`, and `∫ w |S1(−β,−α)| |ψ|² ≪ T`. -/
noncomputable
def StmtX (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
    Regime κ T α β →
      ‖IX W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 -
        (T : ℂ) ^ (-(α + β)) * I1 W (Mof T θ) (aY P T θ R) (sig0 T R) (-β) (-α) 1‖ ≤ C * errY W

/-- OPEN, **Young's Lemma 3**, (3.2), on Lemma 6's range:
`I(α,β) = c(α,β) ŵ(0) + O(T/L)`. -/
noncomputable
def StmtLemma3 (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
    Regime κ T α β →
      ‖Imom W (Mof T θ) (aY P T θ R) (sig0 T R) α β - cY P (Mof T θ) T α β * (what0 W : ℂ)‖ ≤
        C * errY W

/-- Lemma 3 up to the remainder term, the form the parts assemble into. -/
noncomputable
def StmtLemma3res (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
    Regime κ T α β →
      ‖Imom W (Mof T θ) (aY P T θ R) (sig0 T R) α β - cY P (Mof T θ) T α β * (what0 W : ℂ)‖ ≤
        C * errY W + ‖Ires W (Mof T θ) (aY P T θ R) (sig0 T R) α β‖

theorem Regime.swap {κ T : ℝ} {α β : ℂ} (h : Regime κ T α β) : Regime κ T (-β) (-α) := by
  obtain ⟨h1, h2, h3⟩ := h
  refine ⟨by rwa [norm_neg], by rwa [norm_neg], ?_⟩
  rw [show -β + -α = -(α + β) by ring, norm_neg]
  exact h3

theorem Regime.small {κ T : ℝ} (hκ : 0 < κ) (hT : Real.exp (10 * κ) ≤ T) {α β : ℂ}
    (h : Regime κ T α β) : ‖α‖ ≤ 1 / 10 ∧ ‖β‖ ≤ 1 / 10 ∧ α + β ≠ 0 ∧ 0 < Real.log T := by
  have hT0 : 0 < T := lt_of_lt_of_le (Real.exp_pos _) hT
  have hL : 10 * κ ≤ Real.log T := by
    rw [← Real.log_exp (10 * κ)]
    exact Real.log_le_log (Real.exp_pos _) hT
  have hL0 : 0 < Real.log T := by linarith
  have hq : κ / Real.log T ≤ 1 / 10 := by
    rw [div_le_iff₀ hL0]
    linarith
  obtain ⟨h1, h2, h3⟩ := h
  refine ⟨h1.trans hq, h2.trans hq, ?_, hL0⟩
  intro h0
  rw [h0, norm_zero] at h3
  have : 0 < 1 / (κ * Real.log T) := by positivity
  linarith

/-- `‖T^(−α−β)‖ ≤ e^(2κ)` on the range. -/
theorem norm_Tpow_le {κ T : ℝ} (hT : 1 < T) {α β : ℂ} (h : Regime κ T α β) :
    ‖(T : ℂ) ^ (-(α + β))‖ ≤ Real.exp (2 * κ) := by
  have hT0 : 0 < T := by linarith
  have hL0 : 0 < Real.log T := Real.log_pos hT
  obtain ⟨h1, h2, _⟩ := h
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hT0, Real.rpow_def_of_pos hT0]
  apply Real.exp_le_exp.mpr
  have hre : (-(α + β)).re ≤ 2 * κ / Real.log T := by
    have e1 : (-(α + β)).re ≤ ‖α + β‖ := by
      rw [Complex.neg_re]
      linarith [neg_abs_le (α + β).re, Complex.abs_re_le_norm (α + β)]
    have e2 : ‖α + β‖ ≤ ‖α‖ + ‖β‖ := norm_add_le α β
    have e3 : 2 * κ / Real.log T = κ / Real.log T + κ / Real.log T := by ring
    linarith
  calc Real.log T * (-(α + β)).re ≤ Real.log T * (2 * κ / Real.log T) :=
        mul_le_mul_of_nonneg_left hre hL0.le
    _ = 2 * κ := by
        field_simp
        try ring

/-- **The assembly**: the three open parts give Lemma 3 up to the remainder `I_res`, which
`Ires_small` bounds by `C N B_ψ T e^(−T²/32)`. Young §5, "Lemma 6 implies Lemma 3". -/
theorem lemma3_res_of_parts {P : Polynomial ℝ} {θ R κ : ℝ} (hκ : 0 < κ)
    (hD : StmtDiag P θ R κ) (hO : StmtOffDiag P θ R κ) (hX : StmtX P θ R κ) :
    StmtLemma3res P θ R κ := by
  obtain ⟨Cd, Td, hCd, hd⟩ := hD
  obtain ⟨Co, To, hCo, ho⟩ := hO
  obtain ⟨Cx, Tx, hCx, hx⟩ := hX
  refine ⟨Cd + Co + Cx + Real.exp (2 * κ) * (Cd + Co),
    max (max Td To) (max Tx (max 8 (Real.exp (10 * κ)))), by positivity,
    fun T hT W α β hreg => ?_⟩
  have hTd : Td ≤ T := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hT
  have hTo : To ≤ T := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hT
  have hTx : Tx ≤ T := le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hT
  have hT8 : 8 ≤ T := le_trans (le_trans (le_trans (le_max_left _ _) (le_max_right _ _))
    (le_max_right _ _)) hT
  have hTe : Real.exp (10 * κ) ≤ T := le_trans (le_trans (le_trans (le_max_right _ _)
    (le_max_right _ _)) (le_max_right _ _)) hT
  obtain ⟨hα, hβ, hαβ, hL0⟩ := hreg.small hκ hTe
  have hreg' := hreg.swap
  obtain ⟨hα', hβ', hαβ', _⟩ := hreg'.small hκ hTe
  set M := Mof T θ
  set a := aY P T θ R
  set σ := sig0 T R
  have e0 : 0 ≤ errY W := by
    unfold errY
    have := W.C1_nonneg
    have := W.C2_nonneg
    have : 0 ≤ T / Real.log T := div_nonneg (by linarith) hL0.le
    positivity
  have hsplit := I_split W (by linarith) M a σ hα hβ hαβ (c := 1) (by norm_num)
  have h1 := I1_diag_off W (by linarith) M a σ hα hβ (c := 1) one_pos
  have h1' := I1_diag_off W (by linarith) M a σ hα' hβ' (c := 1) one_pos
  have bd := hd T hTd W α β hreg
  have bd' := hd T hTd W (-β) (-α) hreg'
  have bo := ho T hTo W α β hreg
  have bo' := ho T hTo W (-β) (-α) hreg'
  have bx := hx T hTx W α β hreg
  have hTp := norm_Tpow_le (by linarith) hreg
  set Tp : ℂ := (T : ℂ) ^ (-(α + β))
  set wh : ℂ := (what0 W : ℂ)
  set dg := diagSum W M a σ α β 1
  set dg' := diagSum W M a σ (-β) (-α) 1
  set of := offSum W M a σ α β 1
  set of' := offSum W M a σ (-β) (-α) 1
  set ix := IX W M a σ α β 1
  set rs := Ires W M a σ α β
  have key : Imom W M a σ α β - cY P M T α β * wh =
      (dg - c1Y P M α β * wh) + of + (ix - Tp * I1 W M a σ (-β) (-α) 1) +
        Tp * (dg' - c1Y P M (-β) (-α) * wh) + Tp * of' - rs := by
    rw [hsplit, h1, h1']
    unfold cY
    ring
  rw [key]
  have nTp0 : 0 ≤ ‖Tp‖ := norm_nonneg _
  have m1 : ‖Tp * (dg' - c1Y P M (-β) (-α) * wh)‖ ≤ Real.exp (2 * κ) * (Cd * errY W) := by
    rw [norm_mul]
    exact mul_le_mul hTp bd' (norm_nonneg _) (Real.exp_pos _).le
  have m2 : ‖Tp * of'‖ ≤ Real.exp (2 * κ) * (Co * errY W) := by
    rw [norm_mul]
    exact mul_le_mul hTp bo' (norm_nonneg _) (Real.exp_pos _).le
  calc _ ≤ ‖(dg - c1Y P M α β * wh) + of + (ix - Tp * I1 W M a σ (-β) (-α) 1) +
          Tp * (dg' - c1Y P M (-β) (-α) * wh) + Tp * of'‖ + ‖rs‖ := norm_sub_le _ _
    _ ≤ ‖dg - c1Y P M α β * wh‖ + ‖of‖ + ‖ix - Tp * I1 W M a σ (-β) (-α) 1‖ +
          ‖Tp * (dg' - c1Y P M (-β) (-α) * wh)‖ + ‖Tp * of'‖ + ‖rs‖ := by
        have n1 := norm_add_le ((dg - c1Y P M α β * wh) + of + (ix - Tp * I1 W M a σ (-β) (-α) 1) +
          Tp * (dg' - c1Y P M (-β) (-α) * wh)) (Tp * of')
        have n2 := norm_add_le ((dg - c1Y P M α β * wh) + of + (ix - Tp * I1 W M a σ (-β) (-α) 1))
          (Tp * (dg' - c1Y P M (-β) (-α) * wh))
        have n3 := norm_add_le ((dg - c1Y P M α β * wh) + of) (ix - Tp * I1 W M a σ (-β) (-α) 1)
        have n4 := norm_add_le (dg - c1Y P M α β * wh) of
        linarith
    _ ≤ Cd * errY W + Co * errY W + Cx * errY W + Real.exp (2 * κ) * (Cd * errY W) +
          Real.exp (2 * κ) * (Co * errY W) + ‖rs‖ := by linarith
    _ = (Cd + Co + Cx + Real.exp (2 * κ) * (Cd + Co)) * errY W + ‖rs‖ := by ring

/-! ## Axiom pins -/

/-- info: 'TwistedMoment.ibp_once' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ibp_once

/-- info: 'TwistedMoment.ibp_twice' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ibp_twice

/-- info: 'TwistedMoment.ibp_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ibp_bound

/-- info: 'TwistedMoment.Fw2_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Fw2_bound

/-- info: 'TwistedMoment.offdiag_term' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offdiag_term

/-- info: 'TwistedMoment.inv_log_sq_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms inv_log_sq_le

/-- info: 'TwistedMoment.offdiag_term_young' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offdiag_term_young

/-- info: 'TwistedMoment.msq_expand' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms msq_expand

/-- info: 'TwistedMoment.approxFE_small' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms approxFE_small

/-- info: 'TwistedMoment.integrand_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integrand_split

/-- info: 'TwistedMoment.continuousAt_resY' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms continuousAt_resY

/-- info: 'TwistedMoment.continuousOn_S1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms continuousOn_S1

/-- info: 'TwistedMoment.I_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms I_split

/-- info: 'TwistedMoment.Ires_small' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Ires_small

/-- info: 'TwistedMoment.coef4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms coef4

/-- info: 'TwistedMoment.I1_expand' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms I1_expand

/-- info: 'TwistedMoment.Jint_diag' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Jint_diag

/-- info: 'TwistedMoment.I1_diag_off' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms I1_diag_off

/-- info: 'TwistedMoment.offTerm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offTerm_le

/-- info: 'TwistedMoment.summable_offTerm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms summable_offTerm

/-- info: 'TwistedMoment.off_term_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms off_term_le

/-- info: 'TwistedMoment.offSum_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offSum_bound

/-- info: 'TwistedMoment.norm_Tpow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_Tpow_le

/-- info: 'TwistedMoment.lemma3_res_of_parts' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lemma3_res_of_parts

end TwistedMoment
