/-
# UnsmoothWin — block S12 of `lean_stage3/design/stencil.md`, piece 4, unsmoothing: the near window. 2026-11-25.

A second window family beside `OffDiagClose.winW`, with the edges moved in: with `Δ = T/L`,
`w(t) = φ((t − lo)/Δ) φ((hi − t)/Δ)`, `lo = T/2 − 2Δ`, `hi = T + Δ`, `φ = smoothTransition`.
It is `1` on `[T/2 − Δ, T]`, `0` off `(lo, hi)`, and `(lo, hi) ⊆ [T/4, 2T]` once `L ≥ 8`.
Its derivative constants are `winW`'s, `winC j`, fixed before `T` and `L`: the edges are
`winW`'s edges shifted, and `winY_iter_le`'s Leibniz count does not see the shift.

| name | content | status |
|---|---|---|
| `nearLo`, `nearHi`, `winNY` | the edges `T/2 − 2T/L`, `T + T/L`; the window | defined |
| `winG_iter_le` | `|(edgeUp c lo · edgeDn c hi)^(j)| ≤ winC j Δ^(−j)`, any `lo`, `hi` | proved |
| `winNY_one` | `w = 1` on `[T/2 − T/L, T]` | proved |
| `winNY_zero` | `w = 0` off `(lo, hi)` | proved |
| `winNear` | the window as a `WeightAll T L`, `Cj = winC`, for `0 < T`, `8 ≤ L` | defined |
| `winNear_Cj` | `(winNear T L hT hL).Cj = winC` | proved |
| `what0_le_of_zero` | `ŵ(0) ≤ hi − lo` for a weight vanishing off `[lo, hi]` | proved |
| `integral_le_of_one` | `∫_a^b f ≤ ∫ w f` for `f ≥ 0` continuous and `w = 1` on `[a, b]` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.OffDiagClose

namespace Unsmooth

open Complex MeasureTheory Filter Topology TwistedMoment OffDiagClose
open scoped ContDiff

noncomputable section

/-- The near window's rising edge `T/2 − 2T/L`. -/
def nearLo (T L : ℝ) : ℝ := T / 2 - 2 * (T / L)

/-- The near window's falling edge `T + T/L`. -/
def nearHi (T L : ℝ) : ℝ := T + T / L

/-- **The near window** `φ((t − lo)/Δ) φ((hi − t)/Δ)`, `Δ = T/L`. -/
def winNY (T L t : ℝ) : ℝ :=
  edgeUp (T / L)⁻¹ (nearLo T L) t * edgeDn (T / L)⁻¹ (nearHi T L) t

end

/-- (2.3) for a window with any two edges: `|w^(j)| ≤ C_j Δ^(−j)`, the constants of `winW`. -/
theorem winG_iter_le {T L : ℝ} (hΔ : 0 < T / L) (lo hi : ℝ) (j : ℕ) (t : ℝ) :
    |iteratedDeriv j (fun t => edgeUp (T / L)⁻¹ lo t * edgeDn (T / L)⁻¹ hi t) t| ≤
      winC j * ((T / L) ^ j)⁻¹ := by
  set c : ℝ := (T / L)⁻¹ with hcdef
  have hc : 0 ≤ c := (inv_pos.mpr hΔ).le
  have hf : ContDiffAt ℝ j (edgeUp c lo) t :=
    (contDiff_infty.mp (edgeUp_contDiff c _) j).contDiffAt
  have hg : ContDiffAt ℝ j (edgeDn c hi) t :=
    (contDiff_infty.mp (edgeDn_contDiff c _) j).contDiffAt
  rw [iteratedDeriv_fun_mul hf hg]
  have hcj : ((T / L) ^ j)⁻¹ = c ^ j := by rw [hcdef, inv_pow]
  rw [hcj]
  unfold winC
  rw [Finset.sum_mul]
  refine (Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum fun i hi' => ?_)
  have hij : i ≤ j := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi')
  have hpow : c ^ i * c ^ (j - i) = c ^ j := by rw [← pow_add, Nat.add_sub_cancel' hij]
  rw [abs_mul, abs_mul, abs_of_nonneg (by positivity : (0 : ℝ) ≤ (j.choose i : ℝ))]
  have h1 := edgeUp_iter_le hc lo i t
  have h2 := edgeDn_iter_le hc hi (j - i) t
  have hB1 := phiB_nonneg i
  have hB2 := phiB_nonneg (j - i)
  calc (j.choose i : ℝ) * |iteratedDeriv i (edgeUp c lo) t| *
        |iteratedDeriv (j - i) (edgeDn c hi) t| ≤
      (j.choose i : ℝ) * (phiB i * c ^ i) * (phiB (j - i) * c ^ (j - i)) := by
        apply mul_le_mul _ h2 (abs_nonneg _) (by positivity)
        exact mul_le_mul_of_nonneg_left h1 (by positivity)
    _ = (j.choose i : ℝ) * phiB i * phiB (j - i) * (c ^ i * c ^ (j - i)) := by ring
    _ = (j.choose i : ℝ) * phiB i * phiB (j - i) * c ^ j := by rw [hpow]

theorem winNY_contDiff (T L : ℝ) : ContDiff ℝ ∞ (winNY T L) :=
  (edgeUp_contDiff _ _).mul (edgeDn_contDiff _ _)

theorem winNY_nonneg (T L t : ℝ) : 0 ≤ winNY T L t :=
  mul_nonneg (Real.smoothTransition.nonneg _) (Real.smoothTransition.nonneg _)

theorem winNY_le_one (T L t : ℝ) : winNY T L t ≤ 1 :=
  mul_le_one₀ (Real.smoothTransition.le_one _) (Real.smoothTransition.nonneg _)
    (Real.smoothTransition.le_one _)

/-- **The plateau**: `w = 1` on `[T/2 − T/L, T]`. -/
theorem winNY_one {T L : ℝ} (hΔ : 0 < T / L) {t : ℝ} (h1 : T / 2 - T / L ≤ t) (h2 : t ≤ T) :
    winNY T L t = 1 := by
  unfold winNY edgeUp edgeDn nearLo nearHi
  have e1 : 1 ≤ (T / L)⁻¹ * (t - (T / 2 - 2 * (T / L))) := by
    rw [inv_mul_eq_div, le_div_iff₀ hΔ]
    linarith
  have e2 : 1 ≤ (T / L)⁻¹ * (T + T / L - t) := by
    rw [inv_mul_eq_div, le_div_iff₀ hΔ]
    linarith
  rw [Real.smoothTransition.one_of_one_le e1, Real.smoothTransition.one_of_one_le e2, mul_one]

/-- **Off the edges** `w = 0`. -/
theorem winNY_zero {T L : ℝ} (hΔ : 0 < T / L) {t : ℝ}
    (h : t ∉ Set.Ioo (nearLo T L) (nearHi T L)) : winNY T L t = 0 := by
  have hc : 0 ≤ (T / L)⁻¹ := (inv_pos.mpr hΔ).le
  unfold winNY edgeUp edgeDn
  rcases le_or_gt t (nearLo T L) with h1 | h1
  · rw [Real.smoothTransition.zero_of_nonpos
      (mul_nonpos_of_nonneg_of_nonpos hc (by linarith)), zero_mul]
  · have h2 : nearHi T L ≤ t := by
      by_contra h3
      exact h ⟨h1, not_le.mp h3⟩
    have h3 : (T / L)⁻¹ * (nearHi T L - t) ≤ 0 :=
      mul_nonpos_of_nonneg_of_nonpos hc (by linarith)
    rw [Real.smoothTransition.zero_of_nonpos h3, mul_zero]

theorem winNY_supp {T L : ℝ} (hT : 0 < T) (hL : 8 ≤ L) (t : ℝ) (h : winNY T L t ≠ 0) :
    T / 4 ≤ t ∧ t ≤ 2 * T := by
  have hL0 : 0 < L := by linarith
  have hΔ : 0 < T / L := div_pos hT hL0
  have hmem : t ∈ Set.Ioo (nearLo T L) (nearHi T L) := by
    by_contra hn
    exact h (winNY_zero hΔ hn)
  have hΔ8 : T / L ≤ T / 8 := div_le_div_of_nonneg_left hT.le (by norm_num) hL
  unfold nearLo nearHi at hmem
  obtain ⟨h1, h2⟩ := hmem
  constructor <;> linarith

/-- **The near window** as a `WeightAll T L`, with `winW`'s constants `winC`. -/
noncomputable
def winNear (T L : ℝ) (hT : 0 < T) (hL : 8 ≤ L) : WeightAll T L where
  w := winNY T L
  smooth := winNY_contDiff T L
  supp := winNY_supp hT hL
  nonneg := winNY_nonneg T L
  le_one := winNY_le_one T L
  C1 := winC 1
  C2 := winC 2
  C1_nonneg := winC_nonneg 1
  C2_nonneg := winC_nonneg 2
  d1 t := by
    have h := winG_iter_le (div_pos hT (by linarith)) (nearLo T L) (nearHi T L) 1 t
    rwa [iteratedDeriv_one, pow_one] at h
  d2 t := by
    have h := winG_iter_le (div_pos hT (by linarith)) (nearLo T L) (nearHi T L) 2 t
    rwa [iteratedDeriv_succ, iteratedDeriv_one] at h
  Cj := winC
  Cj_nonneg := winC_nonneg
  dj := winG_iter_le (div_pos hT (by linarith)) (nearLo T L) (nearHi T L)

theorem winNear_Cj (T L : ℝ) (hT : 0 < T) (hL : 8 ≤ L) : (winNear T L hT hL).Cj = winC := rfl

theorem winNear_w (T L : ℝ) (hT : 0 < T) (hL : 8 ≤ L) : (winNear T L hT hL).w = winNY T L := rfl

/-- `ŵ(0) ≤ hi − lo` for a weight vanishing off `[lo, hi]`. -/
theorem what0_le_of_zero {T L : ℝ} (W : Weight T L) {lo hi : ℝ} (hlh : lo ≤ hi)
    (h0 : ∀ t, t ∉ Set.Icc lo hi → W.w t = 0) : what0 W ≤ hi - lo := by
  unfold what0
  rw [← setIntegral_eq_integral_of_forall_compl_eq_zero h0, integral_Icc_eq_integral_Ioc,
    ← intervalIntegral.integral_of_le hlh]
  have hm := intervalIntegral.integral_mono_on hlh (W.cont.intervalIntegrable (μ := volume) lo hi)
    (continuous_const.intervalIntegrable (μ := volume) lo hi) (fun t _ => W.le_one t)
  rw [intervalIntegral.integral_const, smul_eq_mul, mul_one] at hm
  exact hm

/-- `w` has compact support. -/
theorem w_compact {T L : ℝ} (W : Weight T L) : HasCompactSupport W.w :=
  HasCompactSupport.intro (isCompact_Icc (a := T / 4) (b := 2 * T)) fun _ ht => (W.zero_out ht).1

/-- **The sharp integral under the smooth one**: `∫_a^b f ≤ ∫ w f` for `f ≥ 0` continuous and
`w = 1` on `[a, b]`. -/
theorem integral_le_of_one {T L : ℝ} (W : Weight T L) {f : ℝ → ℝ} (hf : Continuous f)
    (hf0 : ∀ t, 0 ≤ f t) {a b : ℝ} (hab : a ≤ b) (h1 : ∀ t ∈ Set.Icc a b, W.w t = 1) :
    ∫ t in a..b, f t ≤ ∫ t, W.w t * f t := by
  rw [intervalIntegral.integral_of_le hab]
  have hint : Integrable (fun t => W.w t * f t) :=
    (W.cont.mul hf).integrable_of_hasCompactSupport ((w_compact W).mul_right)
  calc ∫ t in Set.Ioc a b, f t = ∫ t in Set.Ioc a b, W.w t * f t := by
        refine setIntegral_congr_fun measurableSet_Ioc fun t ht => ?_
        simp only [h1 t (Set.Ioc_subset_Icc_self ht), one_mul]
    _ ≤ ∫ t, W.w t * f t :=
        setIntegral_le_integral hint (Eventually.of_forall fun t => mul_nonneg (W.nonneg t) (hf0 t))

/-- info: 'Unsmooth.winG_iter_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms winG_iter_le

/-- info: 'Unsmooth.winNY_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms winNY_one

/-- info: 'Unsmooth.winNY_supp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms winNY_supp

/-- info: 'Unsmooth.what0_le_of_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms what0_le_of_zero

/-- info: 'Unsmooth.integral_le_of_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_le_of_one

end Unsmooth
