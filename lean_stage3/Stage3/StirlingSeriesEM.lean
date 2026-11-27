/-
StirlingSeriesEM — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: one step of
Stirling's series by Euler–Maclaurin on `[0, 1]`. 2026-11-25.

For `Re w > 0` put `J_m(w) = ∫₀¹ B_m(x)(w+x)^{−m} dx` (`emJ`, `B_m = bernoulliFun m`). One
integration by parts against `B_{m+1}' = (m+1)B_m` and `B_{m+1}(1) = B_{m+1}(0)` (`m ≥ 1`) gives

  (m+1)·J_m(w) = B_{m+1}·((w+1)^{−m} − w^{−m}) + m·J_{m+1}(w)            (`emJ_step`),

and `J_1(w) = 1 − (w + ½)(log(w+1) − log w)` (`emJ_one`). Two steps at a time, with
`B_{2k+1} = 0`, unroll to `J_1 = Σ_{k=1}^{K} c_k((w+1)^{1−2k} − w^{1−2k}) + J_{2K}/(2K)`,
`c_k = B_{2k}/(2k(2k−1))` (`emJ_one_unroll`). With
`S_K(w) = (w − ½) log w − w + Σ_{1 ≤ k < K} c_k w^{1−2k}` (`stirMain`) this is the one-step identity

  S_{K+1}(w+1) − S_{K+1}(w) − log w = −J_{2K}(w)/(2K)                     (`stirMain_step`),

and `‖J_m(w)‖ ≤ bernBound m/‖w‖^m` on `Re w ≥ 0` (`norm_emJ_le`). The size check: the step
error is `O(‖w‖^{−2K})`, summed over `w = z + n` it is `O(‖z‖^{2−2K}/|Im z|)`; nothing grows
with the number of steps (StirlingSeriesLim).

| name | content | status |
|---|---|---|
| `emJ`, `bdiff`, `stirC`, `stirSum`, `stirMain` | `J_m`; `(w+1)^{−m} − w^{−m}`; `c_k`; `Σ_{k<K} c_k w^{1−2k}`; `S_K` | def |
| `emJ_step` | `1 ≤ m`, `0 < Re w` ⊢ `(m+1)J_m = B_{m+1}Δ_m + m J_{m+1}` | proved |
| `emJ_one` | `0 < Re w` ⊢ `J_1 = 1 − (w+½)(log(w+1) − log w)` | proved |
| `emJ_one_unroll` | `1 ≤ K` ⊢ `J_1 = Σ_{k ∈ [1,K]} c_k Δ_{2k−1} + J_{2K}/(2K)` | proved |
| `stirMain_step` | `1 ≤ K`, `0 < Re w` ⊢ `S_{K+1}(w+1) − S_{K+1}(w) − log w = −J_{2K}(w)/(2K)` | proved |
| `norm_emJ_le` | `0 ≤ Re w`, `w ≠ 0` ⊢ `‖J_m(w)‖ ≤ bernBound m/‖w‖^m` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.ZetaEM
import Stage3.StirlingLog

namespace StirlingSeries

open Complex MeasureTheory Set intervalIntegral Filter Topology

noncomputable section

/-- `J_m(w) = ∫₀¹ B_m(x)·(w+x)^{−m}`. -/
def emJ (m : ℕ) (w : ℂ) : ℂ :=
  ∫ x in (0 : ℝ)..1, ((bernoulliFun m x : ℝ) : ℂ) * ((w + (x : ℂ)) ^ m)⁻¹

/-- `Δ_m(w) = (w+1)^{−m} − w^{−m}`. -/
def bdiff (m : ℕ) (w : ℂ) : ℂ := ((w + 1) ^ m)⁻¹ - (w ^ m)⁻¹

/-- The Stirling coefficient `c_k = B_{2k}/(2k(2k−1))`. -/
def stirC (k : ℕ) : ℂ := ((bernoulli (2 * k) : ℚ) : ℂ) / ((2 * k : ℂ) * (2 * k - 1))

/-- The Stirling correction `Σ_{1 ≤ k < K} c_k w^{−(2k−1)}`. -/
def stirSum (K : ℕ) (w : ℂ) : ℂ := ∑ k ∈ Finset.Ico 1 K, stirC k * (w ^ (2 * k - 1))⁻¹

/-- The Stirling main part `S_K(w) = (w − ½) log w − w + Σ_{1 ≤ k < K} c_k w^{−(2k−1)}`. -/
def stirMain (K : ℕ) (w : ℂ) : ℂ := (w - 1 / 2) * log w - w + stirSum K w

theorem add_ofReal_ne_zero {w : ℂ} (hw : 0 < w.re) {x : ℝ} (hx : 0 ≤ x) : w + (x : ℂ) ≠ 0 := by
  intro h
  have := congrArg Complex.re h
  simp only [add_re, ofReal_re, zero_re] at this
  linarith

theorem bern_cast_zero (n : ℕ) : ((bernoulliFun n 0 : ℝ) : ℂ) = ((bernoulli n : ℚ) : ℂ) := by
  rw [bernoulliFun_eval_zero]
  push_cast
  rfl

theorem continuousOn_integrand (m : ℕ) {w : ℂ} (hw : 0 < w.re) :
    ContinuousOn (fun x : ℝ => ((bernoulliFun m x : ℝ) : ℂ) * ((w + (x : ℂ)) ^ m)⁻¹)
      (uIcc (0 : ℝ) 1) := by
  apply ContinuousOn.mul
  · exact (Complex.continuous_ofReal.comp (continuous_bernoulliFun m)).continuousOn
  · apply ContinuousOn.inv₀
    · exact (continuous_const.add Complex.continuous_ofReal).pow m |>.continuousOn
    · intro x hx
      rw [uIcc_of_le zero_le_one] at hx
      exact pow_ne_zero _ (add_ofReal_ne_zero hw hx.1)

theorem intervalIntegrable_integrand (m : ℕ) {w : ℂ} (hw : 0 < w.re) :
    IntervalIntegrable (fun x : ℝ => ((bernoulliFun m x : ℝ) : ℂ) * ((w + (x : ℂ)) ^ m)⁻¹)
      volume 0 1 :=
  (continuousOn_integrand m hw).intervalIntegrable

/-- The derivative of `(w + x)^{−(p+1)}` in the real variable `x`. -/
theorem hasDerivAt_inv_pow {w : ℂ} {x : ℝ} (hx : w + (x : ℂ) ≠ 0) (p : ℕ) :
    HasDerivAt (fun y : ℝ => ((w + (y : ℂ)) ^ (p + 1))⁻¹)
      (-((p : ℂ) + 1) * ((w + (x : ℂ)) ^ (p + 2))⁻¹) x := by
  have h1 : HasDerivAt (fun y : ℝ => w + (y : ℂ)) 1 x := by
    have := ((hasDerivAt_id x).ofReal_comp).const_add w
    simpa using this
  have h2 := (h1.pow (p + 1)).inv (pow_ne_zero _ hx)
  refine h2.congr_deriv ?_
  simp only [Pi.pow_apply, Nat.add_sub_cancel, mul_one]
  have hp : (w + (x : ℂ)) ^ (p + 1) ≠ 0 := pow_ne_zero _ hx
  have hp2 : (w + (x : ℂ)) ^ (p + 2) ≠ 0 := pow_ne_zero _ hx
  rw [show (w + (x : ℂ)) ^ (p + 2) = (w + (x : ℂ)) ^ p * (w + (x : ℂ)) ^ 2 by ring]
  push_cast
  field_simp
  ring

/-- **One integration by parts**: `(m+1)J_m = B_{m+1}Δ_m + m J_{m+1}` for `m ≥ 1`. -/
theorem emJ_step {m : ℕ} (hm : 1 ≤ m) {w : ℂ} (hw : 0 < w.re) :
    ((m : ℂ) + 1) * emJ m w
      = ((bernoulli (m + 1) : ℚ) : ℂ) * bdiff m w + (m : ℂ) * emJ (m + 1) w := by
  obtain ⟨p, rfl⟩ : ∃ p, m = p + 1 := ⟨m - 1, by omega⟩
  set F : ℝ → ℂ := fun x => ((bernoulliFun (p + 2) x : ℝ) : ℂ) * ((w + (x : ℂ)) ^ (p + 1))⁻¹
    with hF
  have hderiv : ∀ x ∈ uIcc (0 : ℝ) 1, HasDerivAt F
      ((((p + 1 : ℕ) : ℂ) + 1) * (((bernoulliFun (p + 1) x : ℝ) : ℂ) * ((w + (x : ℂ)) ^ (p + 1))⁻¹)
        - ((p + 1 : ℕ) : ℂ) * (((bernoulliFun (p + 2) x : ℝ) : ℂ)
            * ((w + (x : ℂ)) ^ (p + 2))⁻¹)) x := by
    intro x hx
    rw [uIcc_of_le zero_le_one] at hx
    have hx0 := add_ofReal_ne_zero hw hx.1
    have hB := (hasDerivAt_bernoulliFun (p + 2) x).ofReal_comp
    have hD := hB.mul (hasDerivAt_inv_pow hx0 p)
    refine hD.congr_deriv ?_
    push_cast
    ring
  have hint := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv
    (((intervalIntegrable_integrand (p + 1) hw).const_mul _).sub
      ((intervalIntegrable_integrand (p + 2) hw).const_mul _))
  rw [intervalIntegral.integral_sub ((intervalIntegrable_integrand (p + 1) hw).const_mul _)
      ((intervalIntegrable_integrand (p + 2) hw).const_mul _),
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul] at hint
  have h1 : bernoulliFun (p + 2) 1 = bernoulliFun (p + 2) 0 :=
    bernoulliFun_endpoints_eq_of_ne_one (by omega)
  simp only [hF, h1, ofReal_one, ofReal_zero, add_zero] at hint
  unfold emJ bdiff
  rw [show p + 1 + 1 = p + 2 from rfl, ← bern_cast_zero]
  linear_combination hint

/-- `∫₀¹ (w+x)⁻¹ = log(w+1) − log w` on `Re w > 0`. -/
theorem integral_inv_add {w : ℂ} (hw : 0 < w.re) :
    ∫ x in (0 : ℝ)..1, (w + (x : ℂ))⁻¹ = log (w + 1) - log w := by
  have hderiv : ∀ x ∈ uIcc (0 : ℝ) 1, HasDerivAt (fun y : ℝ => log (w + (y : ℂ)))
      ((w + (x : ℂ))⁻¹) x := by
    intro x hx
    rw [uIcc_of_le zero_le_one] at hx
    have h1 : HasDerivAt (fun y : ℝ => w + (y : ℂ)) 1 x := by
      have := ((hasDerivAt_id x).ofReal_comp).const_add w
      simpa using this
    have hre : 0 < (w + (x : ℂ)).re := by simp; linarith [hx.1]
    have h2 := h1.clog_real (mem_slitPlane_iff.mpr (Or.inl hre))
    simpa using h2
  have hcont : ContinuousOn (fun x : ℝ => (w + (x : ℂ))⁻¹) (uIcc (0 : ℝ) 1) := by
    apply ContinuousOn.inv₀ (continuous_const.add Complex.continuous_ofReal).continuousOn
    intro x hx
    rw [uIcc_of_le zero_le_one] at hx
    exact add_ofReal_ne_zero hw hx.1
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hcont.intervalIntegrable]
  simp

/-- **The base**: `J_1(w) = 1 − (w + ½)(log(w+1) − log w)`. -/
theorem emJ_one {w : ℂ} (hw : 0 < w.re) :
    emJ 1 w = 1 - (w + 1 / 2) * (log (w + 1) - log w) := by
  have hcongr : ∀ x ∈ uIcc (0 : ℝ) 1,
      ((bernoulliFun 1 x : ℝ) : ℂ) * ((w + (x : ℂ)) ^ 1)⁻¹ = 1 - (w + 1 / 2) * (w + (x : ℂ))⁻¹ := by
    intro x hx
    rw [uIcc_of_le zero_le_one] at hx
    have hx0 := add_ofReal_ne_zero hw hx.1
    rw [bernoulliFun_one, pow_one]
    push_cast
    field_simp
    ring
  have hcont : ContinuousOn (fun x : ℝ => (w + (x : ℂ))⁻¹) (uIcc (0 : ℝ) 1) := by
    apply ContinuousOn.inv₀ (continuous_const.add Complex.continuous_ofReal).continuousOn
    intro x hx
    rw [uIcc_of_le zero_le_one] at hx
    exact add_ofReal_ne_zero hw hx.1
  unfold emJ
  rw [intervalIntegral.integral_congr hcongr, intervalIntegral.integral_sub intervalIntegrable_const
    (hcont.intervalIntegrable.const_mul _), intervalIntegral.integral_const_mul,
    integral_inv_add hw]
  simp

theorem bernoulli_odd_zero {K : ℕ} (hK : 1 ≤ K) : ((bernoulli (2 * K + 1) : ℚ) : ℂ) = 0 := by
  rw [bernoulli_eq_zero_of_odd ⟨K, rfl⟩ (by omega)]
  simp

/-- **The unrolled identity**: `J_1 = Σ_{k ∈ [1,K]} c_k Δ_{2k−1} + J_{2K}/(2K)` for `K ≥ 1`. -/
theorem emJ_one_unroll {K : ℕ} (hK : 1 ≤ K) {w : ℂ} (hw : 0 < w.re) :
    emJ 1 w = ∑ k ∈ Finset.Ico 1 (K + 1), stirC k * bdiff (2 * k - 1) w
      + emJ (2 * K) w / (2 * K) := by
  induction K, hK using Nat.le_induction with
  | base =>
    have h := emJ_step (m := 1) le_rfl hw
    rw [Finset.sum_Ico_succ_top le_rfl, Finset.Ico_self, Finset.sum_empty, zero_add]
    unfold stirC
    norm_num at h ⊢
    linear_combination h / 2
  | succ K hK ih =>
    rw [ih, Finset.sum_Ico_succ_top (by omega : 1 ≤ K + 1)]
    have h1 := emJ_step (m := 2 * K) (by omega) hw
    have h2 := emJ_step (m := 2 * K + 1) (by omega) hw
    rw [bernoulli_odd_zero hK] at h1
    have hK0 : (K : ℂ) ≠ 0 := by exact_mod_cast (by omega : K ≠ 0)
    have hK1 : (2 * (K : ℂ) + 1) ≠ 0 := by
      have : (2 * (K : ℂ) + 1) = ((2 * K + 1 : ℕ) : ℂ) := by push_cast; ring
      rw [this]; exact_mod_cast (by omega : 2 * K + 1 ≠ 0)
    have hK2 : ((K : ℂ) + 1) ≠ 0 := by exact_mod_cast (by omega : K + 1 ≠ 0)
    have e1 : 2 * (K + 1) - 1 = 2 * K + 1 := by omega
    have e2 : 2 * (K + 1) = 2 * K + 1 + 1 := by omega
    rw [e1, e2]
    have hc : stirC (K + 1) = ((bernoulli (2 * K + 1 + 1) : ℚ) : ℂ)
        / ((2 * (K : ℂ) + 2) * (2 * (K : ℂ) + 1)) := by
      unfold stirC
      rw [e2]
      push_cast
      ring_nf
    rw [hc]
    have hK3 : (2 * (K : ℂ) + 2) ≠ 0 := by
      have : (2 * (K : ℂ) + 2) = ((2 * K + 2 : ℕ) : ℂ) := by push_cast; ring
      rw [this]; exact_mod_cast (by omega : 2 * K + 2 ≠ 0)
    push_cast at h1 h2 ⊢
    have key : emJ (2 * K) w / (2 * (K : ℂ)) = ((bernoulli (2 * K + 1 + 1) : ℚ) : ℂ)
        / ((2 * (K : ℂ) + 2) * (2 * (K : ℂ) + 1)) * bdiff (2 * K + 1) w
        + emJ (2 * K + 1 + 1) w / (2 * ((K : ℂ) + 1)) := by
      rw [show 2 * ((K : ℂ) + 1) = 2 * (K : ℂ) + 2 by ring]
      field_simp
      linear_combination ((K : ℂ) + 1) * h1 + (K : ℂ) * h2
    rw [key]
    ring

/-- **The one-step identity**: `S_{K+1}(w+1) − S_{K+1}(w) − log w = −J_{2K}(w)/(2K)`. -/
theorem stirMain_step {K : ℕ} (hK : 1 ≤ K) {w : ℂ} (hw : 0 < w.re) :
    stirMain (K + 1) (w + 1) - stirMain (K + 1) w - log w = -(emJ (2 * K) w / (2 * K)) := by
  have h := emJ_one_unroll hK hw
  rw [emJ_one hw] at h
  have hs : stirSum (K + 1) (w + 1) - stirSum (K + 1) w
      = ∑ k ∈ Finset.Ico 1 (K + 1), stirC k * bdiff (2 * k - 1) w := by
    unfold stirSum bdiff
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro k _
    ring
  unfold stirMain
  linear_combination hs - h

theorem abs_bern_le (m : ℕ) {x : ℝ} (hx : x ∈ Icc (0 : ℝ) 1) :
    |bernoulliFun m x| ≤ ZetaEM.bernBound m := by
  have hb := (isCompact_Icc (a := (0 : ℝ)) (b := 1)).bddAbove_image
    (f := fun x : ℝ ↦ |bernoulliFun m x|) (continuous_bernoulliFun m).abs.continuousOn
  exact le_csSup hb ⟨x, hx, rfl⟩

theorem norm_le_norm_add {w : ℂ} (hw : 0 ≤ w.re) {x : ℝ} (hx : 0 ≤ x) : ‖w‖ ≤ ‖w + (x : ℂ)‖ := by
  have h : ‖w‖ ^ 2 ≤ ‖w + (x : ℂ)‖ ^ 2 := by
    rw [Complex.sq_norm, Complex.sq_norm, Complex.normSq_apply, Complex.normSq_apply]
    simp only [add_re, ofReal_re, add_im, ofReal_im, add_zero]
    nlinarith
  nlinarith [norm_nonneg w, norm_nonneg (w + (x : ℂ))]

/-- **The size of `J_m`**: `‖J_m(w)‖ ≤ bernBound m/‖w‖^m` on `Re w ≥ 0`, `w ≠ 0`. -/
theorem norm_emJ_le (m : ℕ) {w : ℂ} (hw : 0 ≤ w.re) (hw0 : w ≠ 0) :
    ‖emJ m w‖ ≤ ZetaEM.bernBound m / ‖w‖ ^ m := by
  have hpos : 0 < ‖w‖ := norm_pos_iff.mpr hw0
  have h := intervalIntegral.norm_integral_le_of_norm_le_const (a := (0 : ℝ)) (b := 1)
    (C := ZetaEM.bernBound m / ‖w‖ ^ m)
    (f := fun x : ℝ => ((bernoulliFun m x : ℝ) : ℂ) * ((w + (x : ℂ)) ^ m)⁻¹) ?_
  · unfold emJ
    simpa using h
  · intro x hx
    rw [uIoc_of_le zero_le_one] at hx
    have hx' : x ∈ Icc (0 : ℝ) 1 := ⟨hx.1.le, hx.2⟩
    rw [norm_mul, norm_inv, norm_pow, Complex.norm_real, Real.norm_eq_abs, div_eq_mul_inv]
    apply mul_le_mul (abs_bern_le m hx') _ (by positivity)
      ((abs_nonneg _).trans (abs_bern_le m hx'))
    apply inv_anti₀ (by positivity)
    exact pow_le_pow_left₀ hpos.le (norm_le_norm_add hw hx.1.le) m

end

/-- info: 'StirlingSeries.emJ_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms emJ_step

/-- info: 'StirlingSeries.stirMain_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stirMain_step

/-- info: 'StirlingSeries.norm_emJ_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_emJ_le

end StirlingSeries
