/-
LevinsonAvoid — block S11 of `lean_stage3/design/stencil.md`, avoidance. 2026-11-25.

The avoidance hypotheses of `LevinsonCount.levinson_count` and `LevinsonRight.levinson_right`
(no zero on a border edge, the real factor nonzero along the line) are met by moving an edge.
A function analytic near a compact rectangle and not identically zero there has finitely many
zeros in it (`divisor_support_rectangle_finite`, read through `Littlewood.mem_support_divisor`);
their imaginary parts (real parts) form a finite set, and an interval of positive length is
infinite, so some height (abscissa) in it meets no zero. The real factor
`1 − c · Re(Gammaℝ'/Gammaℝ)(1/2 + it)` is positive for `c = 1/log T`, `4 ≤ t ≤ T`,
`T ≥ e^26`: `Re logDeriv Gammaℝ (1/2 + it) = −log π/2 + phasePoint t/2`
(`LevinsonSize.re_logDeriv_gammaR_line`), and `phasePoint t ≤ log(t/2) + 97/t`
(`Stage3.stmtDigammaLog_holds`), so `c · Re ≤ (log T + 25)/(2 log T) < 1` once `log T ≥ 26`.

  order_ne_top_of_ne        f analytic near Rectangle z w, p ∈ Rectangle z w, f p ≠ 0
                              ⊢ ∀ q ∈ Rectangle z w, meromorphicOrderAt f q ≠ ⊤
  zeros_finite              same ⊢ {q ∈ Rectangle z w | f q = 0}.Finite
  exists_good_height        f analytic near Rectangle (σ₀ + t₀ i) (X + (t₀+1) i),
                              f p ≠ 0 for some p in it
                              ⊢ ∃ t ∈ [t₀, t₀+1], ∀ x ∈ [σ₀, X], f (x + t i) ≠ 0
  exists_good_abscissa      0 < δ, σ₀ ≤ X, f analytic near Rectangle ((σ₀ − δ) + a i) (X + b i),
                              f p ≠ 0 for some p in it
                              ⊢ ∃ σ ∈ [σ₀ − δ, σ₀], ∀ y ∈ [a, b], f (σ + y i) ≠ 0
  factor_pos                e^26 ≤ T, t ∈ [4, T]
                              ⊢ 0 < 1 − (1/log T) · Re(Gammaℝ'/Gammaℝ)(1/2 + t i)

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonSize
import Stage3.Littlewood

namespace LevinsonAvoid

open Complex Set
open scoped Interval

/-- A point `x + y i` with `x`, `y` between the corners' parts lies in the rectangle. -/
theorem mem_rect_of {z w : ℂ} {x y : ℝ} (hx : x ∈ [[z.re, w.re]]) (hy : y ∈ [[z.im, w.im]]) :
    ((x : ℂ) + y * I) ∈ Rectangle z w := by
  rw [Rectangle]
  refine mem_reProdIm.mpr ⟨?_, ?_⟩
  · simpa using hx
  · simpa using hy

/-- Isolated zeros: analytic near a rectangle and nonzero at one point of it, the order is
finite at every point of it. -/
theorem order_ne_top_of_ne {f : ℂ → ℂ} {z w p : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hp : p ∈ Rectangle z w) (hfp : f p ≠ 0) :
    ∀ q ∈ Rectangle z w, meromorphicOrderAt f q ≠ ⊤ := by
  intro q hq htop
  rw [(hf q hq).meromorphicOrderAt_eq] at htop
  have h2 : analyticOrderAt f q = ⊤ := by
    cases hn : analyticOrderAt f q
    · rfl
    · rw [hn] at htop; simp [ENat.map_coe] at htop
  have hev := analyticOrderAt_eq_top.mp h2
  have hconv : Convex ℝ (Rectangle z w) := by
    rw [Complex.rectangle_eq_convexHull]; exact convex_convexHull ℝ _
  have hzero := hf.eqOn_zero_of_preconnected_of_eventuallyEq_zero hconv.isPreconnected hq hev
  exact hfp (hzero hp)

/-- The zeros in the rectangle are finitely many. -/
theorem zeros_finite {f : ℂ → ℂ} {z w p : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hp : p ∈ Rectangle z w) (hfp : f p ≠ 0) :
    {q | q ∈ Rectangle z w ∧ f q = 0}.Finite := by
  have hfin := order_ne_top_of_ne hf hp hfp
  refine (divisor_support_rectangle_finite f z w).subset ?_
  intro q hq
  exact (Littlewood.mem_support_divisor subset_rfl hf hfin q).mpr hq

/-- **A good height.** Analytic near `[σ₀, X] × [t₀, t₀ + 1]` and not identically zero there,
some height `t ∈ [t₀, t₀ + 1]` has no zero on the horizontal segment `[σ₀, X] + t i`. -/
theorem exists_good_height {f : ℂ → ℂ} {σ₀ X t₀ : ℝ}
    (hf : AnalyticOnNhd ℂ f (Rectangle ((σ₀ : ℂ) + t₀ * I) ((X : ℂ) + (t₀ + 1 : ℝ) * I)))
    (hne : ∃ p ∈ Rectangle ((σ₀ : ℂ) + t₀ * I) ((X : ℂ) + (t₀ + 1 : ℝ) * I), f p ≠ 0) :
    ∃ t ∈ Icc t₀ (t₀ + 1), ∀ x ∈ Icc σ₀ X, f ((x : ℂ) + t * I) ≠ 0 := by
  obtain ⟨p, hp, hfp⟩ := hne
  set Z := zeros_finite hf hp hfp with hZ
  obtain ⟨t, ht, htZ⟩ :=
    (Icc_infinite (by linarith : t₀ < t₀ + 1)).exists_notMem_finset (Z.toFinset.image Complex.im)
  refine ⟨t, ht, fun x hx h0 => htZ ?_⟩
  rw [Finset.mem_image]
  refine ⟨(x : ℂ) + t * I, ?_, by simp⟩
  rw [Set.Finite.mem_toFinset]
  refine ⟨mem_rect_of ?_ ?_, h0⟩
  · simpa using Icc_subset_uIcc hx
  · simpa using Icc_subset_uIcc ht

/-- **A good abscissa.** Analytic near `[σ₀ − δ, X] × [a, b]`, `δ > 0`, `σ₀ ≤ X`, and not
identically zero there, some `σ ∈ [σ₀ − δ, σ₀]` has no zero on the vertical segment
`σ + [a, b] i`. -/
theorem exists_good_abscissa {f : ℂ → ℂ} {σ₀ δ X a b : ℝ} (hδ : 0 < δ) (hX : σ₀ ≤ X)
    (hf : AnalyticOnNhd ℂ f (Rectangle (((σ₀ - δ : ℝ) : ℂ) + a * I) ((X : ℂ) + b * I)))
    (hne : ∃ p ∈ Rectangle (((σ₀ - δ : ℝ) : ℂ) + a * I) ((X : ℂ) + b * I), f p ≠ 0) :
    ∃ σ ∈ Icc (σ₀ - δ) σ₀, ∀ y ∈ Icc a b, f ((σ : ℂ) + y * I) ≠ 0 := by
  obtain ⟨p, hp, hfp⟩ := hne
  set Z := zeros_finite hf hp hfp with hZ
  obtain ⟨σ, hσ, hσZ⟩ :=
    (Icc_infinite (by linarith : σ₀ - δ < σ₀)).exists_notMem_finset (Z.toFinset.image Complex.re)
  refine ⟨σ, hσ, fun y hy h0 => hσZ ?_⟩
  rw [Finset.mem_image]
  refine ⟨(σ : ℂ) + y * I, ?_, by simp⟩
  rw [Set.Finite.mem_toFinset]
  refine ⟨mem_rect_of ?_ ?_, h0⟩
  · have hσ' : σ ∈ Icc (σ₀ - δ) X := ⟨hσ.1, le_trans hσ.2 hX⟩
    simpa using Icc_subset_uIcc hσ'
  · simpa using Icc_subset_uIcc hy

/-- **The real factor is positive.** For `T ≥ e^26`, `c = 1/log T` and `4 ≤ t ≤ T`,
`1 − c · Re(Gammaℝ'/Gammaℝ)(1/2 + t i) > 0`. -/
theorem factor_pos {T t : ℝ} (hT : Real.exp 26 ≤ T) (ht : t ∈ Icc 4 T) :
    0 < 1 - (1 / Real.log T) *
      (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re := by
  have ht0 : (0 : ℝ) < t := by linarith [ht.1]
  have hL : (26 : ℝ) ≤ Real.log T := by
    have h := Real.log_le_log (Real.exp_pos 26) hT
    rwa [Real.log_exp] at h
  have hL0 : (0 : ℝ) < Real.log T := by linarith
  rw [← logDeriv_apply, LevinsonSize.re_logDeriv_gammaR_line]
  have h97 := (Stage3.stmtDigammaLog_holds.1 t (by linarith [ht.1]))
  have hpp : Stage3.phasePoint t ≤ Real.log (t / 2) + 97 / t := by
    have := le_abs_self (Stage3.phasePoint t - Real.log (t / 2))
    linarith
  have h97t : (97 : ℝ) / t ≤ 25 := by
    rw [div_le_iff₀ ht0]; linarith [ht.1]
  have hlog2 : Real.log (t / 2) ≤ Real.log t :=
    Real.log_le_log (by positivity) (by linarith)
  have hlogT : Real.log t ≤ Real.log T := Real.log_le_log ht0 ht.2
  have hπ : 0 ≤ Real.log Real.pi := Real.log_nonneg (by linarith [Real.pi_gt_three])
  have hg : -(Real.log Real.pi) / 2 + Stage3.phasePoint t / 2 ≤ (Real.log T + 25) / 2 := by
    linarith
  have hmul : (1 / Real.log T) * (-(Real.log Real.pi) / 2 + Stage3.phasePoint t / 2)
      ≤ (1 / Real.log T) * ((Real.log T + 25) / 2) :=
    mul_le_mul_of_nonneg_left hg (by positivity)
  have heq : (1 / Real.log T) * ((Real.log T + 25) / 2) = 1 / 2 + 25 / (2 * Real.log T) := by
    field_simp
    try ring
  have hsmall : (25 : ℝ) / (2 * Real.log T) ≤ 25 / 52 :=
    div_le_div_of_nonneg_left (by norm_num) (by norm_num) (by linarith)
  linarith

/-- info: 'LevinsonAvoid.exists_good_height' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_good_height

/-- info: 'LevinsonAvoid.exists_good_abscissa' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_good_abscissa

/-- info: 'LevinsonAvoid.factor_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms factor_pos

end LevinsonAvoid
