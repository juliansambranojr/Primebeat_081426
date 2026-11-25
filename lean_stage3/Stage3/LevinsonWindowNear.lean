/-
LevinsonWindowNear — block S12 of `lean_stage3/design/stencil.md`, the window restated.
2026-11-25.

`LevinsonMultiple.levinson_window'` asks its mean hypothesis `hK` on every subwindow
`[a', b'] ⊆ [a, b]`, but its proof uses it once, at the good heights `a' ∈ [a, a + 1]` and
`b' ∈ [b − 1, b]` that `LevinsonAvoid.exists_good_height` picks. Here the proof is copied with
`hK` asked only there, and the count on the right is sharpened to the difference
`lineCount b − lineCount a`, the zeros on the line with height in `(a, b]`, with the same
constants `134 log T + 2918`.

The difference form costs nothing in the constant. Two changes to the copied proofs:
* the bottom height `a'` is chosen to avoid the zeros of `ζ · G ψ` (`ζ ≠ 0` on `Re = X ≥ 3`),
  so `ζ(1/2 + a' i) ≠ 0`; then every crossing and every zero of `G` on the left edge found by
  `levinson_count'` has height in `(a', b']`, and `sum_order_le_lineCount_sub` counts them in
  `lineCount b' − lineCount a'`;
* `lineCount b' − lineCount a' ≤ lineCount b − lineCount a` by monotonicity, as `a ≤ a'` and
  `b' ≤ b`. No zero in `[a, a + 1]` has to be counted, so the Riemann–von Mangoldt step bound
  enters only where the original used it, for `N` (`LevinsonWindow.N_step_le`).

| statement | status |
|---|---|
| `sum_order_le_lineCount_sub` | proved |
| `lineCount_nonneg` | proved |
| `levinson_count_sub` | proved (copy of `levinson_count'`, extra `ζ(1/2 + a i) ≠ 0`) |
| `levinson_window_diff` | proved (copy of `levinson_window'`, `hK` near the ends) |
| `levinson_window_near` | proved (from `levinson_window_diff` and `lineCount a ≥ 0`) |

  sum_order_le_lineCount_sub  0 ≤ a ≤ b, E ⊆ (a, b] finite, ζ(1/2 + γ i) = 0 on E
                                ⊢ Σ_{γ ∈ E} riemannZeta.order (1/2 + γ i) ≤ lineCount b − lineCount a
  lineCount_nonneg            0 ≤ lineCount T
  levinson_count_sub          the hypotheses of `levinson_count'` and ζ(1/2 + a i) ≠ 0
                                ⊢ (N b − N a) − 2 · countRight … − (72 log b + 418)
                                    ≤ lineCount b − lineCount a
  levinson_window_diff        the hypotheses of `levinson_window'` with hK only for
                                a ≤ a' ≤ a + 1, b − 1 ≤ b' ≤ b, a' < b'
                                ⊢ (N b − N a)
                                    − (1/(π(1/2 − σ₀))) · ((b − a)/2 · log K + windowE M B X T a b)
                                    − (134 log T + 2918) ≤ lineCount b − lineCount a
  levinson_window_near        the same hypotheses ⊢ the conclusion of `levinson_window'`

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonMultiple

namespace LevinsonWindowNear

open Complex MeasureTheory Set Filter Topology Littlewood LineCount Kadiri LevinsonWindow
  LevinsonMultiple
open scoped Interval

/-- Distinct heights in `(a, b]` carrying zeros of `ζ` on the line, weighted by order, number at
most `lineCount b − lineCount a`. -/
theorem sum_order_le_lineCount_sub {a b : ℝ} (ha : 0 ≤ a) (hab : a ≤ b) (E : Finset ℝ)
    (hgt : ∀ γ ∈ E, a < γ) (hle : ∀ γ ∈ E, γ ≤ b)
    (hζ : ∀ γ ∈ E, riemannZeta (1/2 + γ * I) = 0) :
    ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) ≤ lineCount b - lineCount a := by
  classical
  have hmemZ : ∀ γ ∈ E, ((1/2 : ℂ) + (γ : ℂ) * I) ∈ NontrivialZeros := fun γ hγ => by
    refine ⟨?_, Set.mem_univ _, hζ γ hγ⟩
    rw [HardyZ.re_line]
    norm_num
  set S := (zerosUpTo b).filter
    (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2 ∧ (ρ : ℂ).im ∈ E) with hS
  have key : ∑ ρ ∈ S, riemannZeta.order (ρ : ℂ) = ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) := by
    apply Finset.sum_bij (fun (ρ : NontrivialZeros) _ => (ρ : ℂ).im)
    · intro ρ hρ
      exact (Finset.mem_filter.mp hρ).2.2
    · intro ρ₁ h₁ ρ₂ h₂ he
      apply Subtype.ext
      apply Complex.ext
      · rw [(Finset.mem_filter.mp h₁).2.1, (Finset.mem_filter.mp h₂).2.1]
      · exact he
    · intro γ hγ
      refine ⟨⟨(1/2 : ℂ) + (γ : ℂ) * I, hmemZ γ hγ⟩, ?_, by simp⟩
      rw [Finset.mem_filter, mem_zerosUpTo]
      simp only [Complex.add_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
        Complex.I_re, Complex.I_im]
      refine ⟨⟨by simp; linarith [hgt γ hγ], by simp; exact hle γ hγ⟩, HardyZ.re_line γ,
        by simpa using hγ⟩
    · intro ρ hρ
      congr 1
      apply Complex.ext
      · simp [(Finset.mem_filter.mp hρ).2.1]
      · simp
  rw [← key]
  unfold lineCount
  rw [← Finset.sum_sdiff (s₁ := (zerosUpTo a).filter
      (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2))
    (s₂ := (zerosUpTo b).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2)) ?_]
  · rw [add_sub_cancel_right]
    refine Finset.sum_le_sum_of_subset_of_nonneg ?_
      (fun z _ _ => (riemannZeta_order_pos_nontrivialZero z).le)
    intro ρ hρ
    rw [hS, Finset.mem_filter, mem_zerosUpTo] at hρ
    rw [Finset.mem_sdiff, Finset.mem_filter, Finset.mem_filter, mem_zerosUpTo, mem_zerosUpTo]
    refine ⟨⟨hρ.1, hρ.2.1⟩, fun h => ?_⟩
    linarith [hgt _ hρ.2.2, h.1.2]
  · intro ρ hρ
    rw [Finset.mem_filter, mem_zerosUpTo] at hρ ⊢
    exact ⟨⟨hρ.1.1, le_trans hρ.1.2 hab⟩, hρ.2⟩

/-- The line count is nonnegative. -/
theorem lineCount_nonneg (T : ℝ) : 0 ≤ lineCount T := by
  unfold lineCount
  exact Finset.sum_nonneg fun z _ => (riemannZeta_order_pos_nontrivialZero z).le

set_option maxHeartbeats 400000 in
/-- **The count, difference form.** `LevinsonMultiple.levinson_count'` with `ζ(1/2 + a i) ≠ 0`
added: every height its proof counts is then in `(a, b]`, so the count is in
`lineCount b − lineCount a`. The proof is a copy, changed at the count of `E`. -/
theorem levinson_count_sub {c a b : ℝ} (hc0 : 0 < c) (hc1 : c ≤ 1) (ha : 4 ≤ a) (hab : a < b)
    (hBot : ∀ x ∈ Icc (1/2 : ℝ) 3,
      riemannZeta (↑x + ↑a * I) + c * deriv riemannZeta (↑x + ↑a * I) ≠ 0)
    (hTop : ∀ x ∈ Icc (1/2 : ℝ) 3,
      riemannZeta (↑x + ↑b * I) + c * deriv riemannZeta (↑x + ↑b * I) ≠ 0)
    (hfac : ∀ t ∈ Icc a b,
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0)
    (hζa : riemannZeta (1/2 + a * I) ≠ 0) :
    (riemannZeta.N b - riemannZeta.N a)
      - 2 * Littlewood.countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
          ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      - (72 * Real.log b + 418) ≤ (lineCount b : ℝ) - (lineCount a : ℝ) := by
  classical
  set G : ℂ → ℂ := fun s => riemannZeta s + c * deriv riemannZeta s with hG_def
  have hπ : 0 < Real.pi := Real.pi_pos
  have hcne : c ≠ 0 := hc0.ne'
  -- the rectangle
  have hGa : AnalyticOnNhd ℂ G (Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I)) :=
    LevinsonCount.G_analyticOnNhd_rect c ha hab.le
  have hzre : ((1/2 : ℂ) + a * I).re = 1/2 := by simp
  have hzim : ((1/2 : ℂ) + a * I).im = a := by simp
  have hwre : ((3 : ℂ) + b * I).re = 3 := by simp
  have hwim : ((3 : ℂ) + b * I).im = b := by simp
  have hmemR : ∀ p, p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) ↔
      1/2 ≤ p.re ∧ p.re ≤ 3 ∧ a ≤ p.im ∧ p.im ≤ b := by
    intro p
    rw [mem_Rect (by rw [hzre, hwre]; norm_num) (by rw [hzim, hwim]; exact hab.le), hzre, hzim,
      hwre, hwim]
  have hlineR : ∀ t ∈ Icc a b, ((1/2 : ℂ) + t * I) ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) :=
    fun t ht => (hmemR _).mpr ⟨by rw [HardyZ.re_line], by rw [HardyZ.re_line]; norm_num,
      by simpa using ht.1, by simpa using ht.2⟩
  have hGz : G ((1/2 : ℂ) + a * I) ≠ 0 := by
    have h := hBot (1/2) ⟨le_rfl, by norm_num⟩
    push_cast at h
    exact h
  have hfinM := Littlewood.order_ne_top hGa hGz
  have hfin : ∀ p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I),
      analyticOrderAt G p ≠ ⊤ := by
    intro p hp htop
    apply hfinM p hp
    rw [(hGa p hp).meromorphicOrderAt_eq, htop]
    rfl
  -- the zeros of `G` on the left edge
  set D : Finset ℂ := (divisor_support_rectangle_finite G ((1/2 : ℂ) + a * I)
    ((3 : ℂ) + b * I)).toFinset.filter (fun p => p.re = 1/2) with hD_def
  have hmemD : ∀ p, p ∈ D ↔
      p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) ∧ G p = 0 ∧ p.re = 1/2 := by
    intro p
    rw [hD_def, Finset.mem_filter, Set.Finite.mem_toFinset,
      Littlewood.mem_support_divisor subset_rfl hGa hfinM, and_assoc]
  have hDprop : ∀ ρ ∈ D, ρ.re = 1/2 ∧ a < ρ.im ∧ ρ.im < b := by
    intro ρ hρ
    obtain ⟨hR, h0, hre⟩ := (hmemD ρ).mp hρ
    obtain ⟨-, -, h3, h4⟩ := (hmemR ρ).mp hR
    have hρeq : ρ = ↑ρ.re + ↑ρ.im * I := (Complex.re_add_im ρ).symm
    refine ⟨hre, lt_of_le_of_ne h3 ?_, lt_of_le_of_ne h4 ?_⟩
    · intro he
      apply hBot ρ.re ⟨by linarith, by linarith⟩
      rw [he, ← hρeq]
      exact h0
    · intro he
      apply hTop ρ.re ⟨by linarith, by linarith⟩
      rw [← he, ← hρeq]
      exact h0
  have hρeq : ∀ ρ ∈ D, ρ = (1/2 : ℂ) + ↑ρ.im * I := by
    intro ρ hρ
    apply Complex.ext <;> simp [(hDprop ρ hρ).1]
  have hζD : ∀ ρ ∈ D, riemannZeta ρ = 0 := by
    intro ρ hρ
    obtain ⟨hR, h0, -⟩ := (hmemD ρ).mp hρ
    have hIm := hDprop ρ hρ
    have h := (LevinsonLine.zeta_line_zero_iff c ρ.im
      (hfac ρ.im ⟨hIm.2.1.le, hIm.2.2.le⟩)).mpr (by
        rw [← hρeq ρ hρ]
        show (Gammaℝ ρ * G ρ).re = 0
        rw [h0, mul_zero, Complex.zero_re])
    rwa [← hρeq ρ hρ] at h
  -- divide them out
  set n : ℂ → ℕ := fun p => (analyticOrderAt G p).toNat with hn_def
  have hn : ∀ ρ ∈ D, (n ρ : ℕ∞) = analyticOrderAt G ρ := fun ρ hρ =>
    ENat.coe_toNat (hfin ρ ((hmemD ρ).mp hρ).1)
  obtain ⟨H, hHa, hGPH⟩ := exists_prod_mul (S := Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I))
    n D G (fun ρ hρ => ((hmemD ρ).mp hρ).1) (fun p hp => hGa p hp) (fun ρ hρ => (hn ρ hρ).le)
  have hHne_of_G : ∀ p, G p ≠ 0 → H p ≠ 0 := fun p hp h => hp (by rw [hGPH p, h, mul_zero])
  have hHneD : ∀ ρ ∈ D, H ρ ≠ 0 := by
    intro ρ hρ
    have hR := ((hmemD ρ).mp hρ).1
    have e : G = polyP D n * H := funext fun s => hGPH s
    have hord : analyticOrderAt G ρ = n ρ + analyticOrderAt H ρ := by
      rw [e, analyticOrderAt_mul (polyP_analyticAt D n ρ) (hHa ρ hR), polyP_order n hρ]
    rw [← hn ρ hρ] at hord
    have h0 : analyticOrderAt H ρ = 0 := by
      cases h : analyticOrderAt H ρ with
      | top => rw [h] at hord; simp at hord
      | coe m =>
        rw [h] at hord
        have h1 : n ρ = n ρ + m := by exact_mod_cast hord
        have hm : m = 0 := by omega
        rw [hm]
        rfl
    exact (hHa ρ hR).analyticOrderAt_eq_zero.mp h0
  have hHline : ∀ t ∈ Icc a b, H (1/2 + t * I) ≠ 0 := by
    intro t ht
    by_cases hG0 : G (1/2 + t * I) = 0
    · apply hHneD
      rw [hmemD]
      exact ⟨hlineR t ht, hG0, HardyZ.re_line t⟩
    · exact hHne_of_G _ hG0
  have hGright : ∀ t : ℝ, G (3 + t * I) ≠ 0 := by
    intro t h
    have := LevinsonSize.re_G_pos hc0.le hc1 t
    have h' : riemannZeta (3 + t * I) + c * deriv riemannZeta (3 + t * I) = 0 := h
    rw [h', Complex.zero_re] at this
    exact lt_irrefl _ this
  have hHB : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I), H p ≠ 0 := by
    intro p hp
    have hcases := LevinsonWindow.border_cases (by rw [hzre, hwre]; norm_num)
      (by rw [hzim, hwim]; exact hab.le) hp
    rw [hzre, hzim, hwre, hwim] at hcases
    have hp' : p = ↑p.re + ↑p.im * I := (Complex.re_add_im p).symm
    rcases hcases with ⟨him, hre⟩ | ⟨hre, him⟩ | ⟨him, hre⟩ | ⟨hre, him⟩
    · apply hHne_of_G
      rw [hp', him]
      exact hBot p.re hre
    · rw [hp', hre]
      push_cast
      exact hHline p.im him
    · apply hHne_of_G
      rw [hp', him]
      exact hTop p.re hre
    · apply hHne_of_G
      rw [hp', hre]
      push_cast
      exact hGright p.im
  -- the argument principle for `H`
  have hcast : ((3 : ℝ) : ℂ) = (3 : ℂ) := by norm_num
  have hHa3 : AnalyticOnNhd ℂ H (Rectangle ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I)) := by
    rw [hcast]; exact hHa
  have hHB3 : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I), H p ≠ 0 := by
    rw [hcast]; exact hHB
  have hHturn := LevinsonTurn.G_turn_eq (G := H) (X := 3) (by norm_num) hab hHa3 hHB3
  rw [hcast] at hHturn
  have hHz : H ((1/2 : ℂ) + a * I) ≠ 0 := hHne_of_G _ hGz
  have hC : Littlewood.countRight G ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      = Littlewood.countRight H ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) :=
    countRight_eq_of_mul hGa hHa (fun p => polyP_analyticAt D n p)
      (fun p _ hσ => polyP_ne_zero n (fun hpD => by
        have := (hDprop p hpD).1
        linarith))
      (funext fun s => hGPH s) hGz hHz
  -- the edges: `G = P · H`
  have e : G = fun s => polyP D n s * H s := funext hGPH
  have hbotS : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑a * I))
      = (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑a * I))
        + ∫ x in (1/2:ℝ)..3, logDeriv H (↑x + ↑a * I) := by
    rw [e]
    exact integral_logDeriv_mul (by norm_num) (by fun_prop)
      (fun x _ => polyP_analyticAt D n _)
      (fun x hx => hHa _ ((hmemR _).mpr ⟨by simpa using hx.1, by simpa using hx.2, by simp,
        by simpa using hab.le⟩))
      (fun x _ => polyP_ne_zero n (fun hD => by have := (hDprop _ hD).2.1; simp at this))
      (fun x hx => hHne_of_G _ (hBot x hx))
  have htopS : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑b * I))
      = (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑b * I))
        + ∫ x in (1/2:ℝ)..3, logDeriv H (↑x + ↑b * I) := by
    rw [e]
    exact integral_logDeriv_mul (by norm_num) (by fun_prop)
      (fun x _ => polyP_analyticAt D n _)
      (fun x hx => hHa _ ((hmemR _).mpr ⟨by simpa using hx.1, by simpa using hx.2,
        by simpa using hab.le, by simp⟩))
      (fun x _ => polyP_ne_zero n (fun hD => by have := (hDprop _ hD).2.2; simp at this))
      (fun x hx => hHne_of_G _ (hTop x hx))
  have hrtS : (∫ t in a..b, logDeriv G (3 + ↑t * I))
      = (∫ t in a..b, logDeriv (polyP D n) (3 + ↑t * I))
        + ∫ t in a..b, logDeriv H (3 + ↑t * I) := by
    rw [e]
    exact integral_logDeriv_mul hab.le (by fun_prop)
      (fun t _ => polyP_analyticAt D n _)
      (fun t ht => hHa _ ((hmemR _).mpr ⟨by simp; norm_num, by simp, by simpa using ht.1,
        by simpa using ht.2⟩))
      (fun t _ => polyP_ne_zero n (fun hD => by
        have := (hDprop _ hD).1
        simp at this
        norm_num at this))
      (fun t _ => hHne_of_G _ (hGright t))
  have hbot' := congrArg Complex.im hbotS
  have htop' := congrArg Complex.im htopS
  have hrt' := congrArg Complex.re hrtS
  rw [Complex.add_im] at hbot' htop'
  rw [Complex.add_re] at hrt'
  have hPE := polyP_edges hab.le n hDprop
  -- the line
  have hFa : ∀ t ∈ Icc a b, AnalyticAt ℂ
      (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) (1/2 + t * I) := fun t ht =>
    analyticAt_const.mul ((LevinsonTurn.analyticAt_Gammaℝ (LevinsonLine.line_facts t).2.2).mul
      (hHa _ (hlineR t ht)))
  have hFne : ∀ t ∈ Icc a b,
      (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) (1/2 + t * I) ≠ 0 := fun t ht =>
    mul_ne_zero (pow_ne_zero _ Complex.I_ne_zero)
      (mul_ne_zero (Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts t).2.2) (hHline t ht))
  have hFc : ContinuousOn (fun t : ℝ => I ^ (∑ ρ ∈ D, n ρ) *
      (Gammaℝ (1/2 + t * I) * H (1/2 + t * I))) (Icc a b) := fun t ht =>
    (ContinuousAt.comp (g := fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s))
      (f := fun t : ℝ => (1/2 + t * I : ℂ)) (hFa t ht).continuousAt
      LevinsonTurn.continuous_line.continuousAt).continuousWithinAt
  obtain ⟨φ, hφc, hφ⟩ := LevinsonArg.exists_arg_lift hab.le hFc hFne
  have hturn1 := LevinsonTurn.line_turn_eq_integral
    (f := fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) hab.le hFa hFne hφc hφ
  have hld : (∫ t in a..b, logDeriv (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s))
      (1/2 + t * I)) = ∫ t in a..b, logDeriv (fun s => Gammaℝ s * H s) (1/2 + t * I) :=
    intervalIntegral.integral_congr fun t _ =>
      logDeriv_const_mul _ _ (pow_ne_zero _ Complex.I_ne_zero)
  have hsplit := LevinsonTurn.turn_split (G := H) hab.le (fun t ht => hHa _ (hlineR t ht)) hHline
  rw [hld, hsplit] at hturn1
  -- the sizes
  have hR := abs_le.mp (LevinsonSize.right_edge_le hc0.le hc1 hab.le)
  have hHa' := abs_le.mp (LevinsonEdge.horizontal_edge_le hc0.le hc1 ha hBot)
  have hHb' := abs_le.mp (LevinsonEdge.horizontal_edge_le hc0.le hc1 (by linarith) hTop)
  have hΓ := abs_le.mp (LevinsonSize.gamma_part_count_le_gt_two (by linarith) hab.le)
  have hlog : Real.log a ≤ Real.log b := Real.log_le_log (by linarith) hab.le
  have hlogπ : 21 * Real.pi * Real.log a ≤ 21 * Real.pi * Real.log b :=
    mul_le_mul_of_nonneg_left hlog (by positivity)
  -- the turning is at least `π (Q − K)`
  set C := Littlewood.countRight G ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) with hC_def
  set Kr : ℝ := ∑ ρ ∈ D, (n ρ : ℝ) with hKr
  set Q := (riemannZeta.N b - riemannZeta.N a) - 2 * C - (72 * Real.log b + 417) with hQ
  have hdiff : Real.pi * (Q - Kr) ≤ φ b - φ a := by
    have e1 : Real.pi * (Q - Kr) = Real.pi * (riemannZeta.N b - riemannZeta.N a)
        - 2 * Real.pi * C - (72 * Real.pi * Real.log b + 417 * Real.pi) - Real.pi * Kr := by
      rw [hQ]; ring
    rw [e1]
    rw [← hC] at hHturn
    linarith [hR.1, hHa'.2, hHb'.1, hΓ.1, hlogπ, hturn1, hHturn, hbot', htop', hrt', hPE]
  -- the floor
  set k : ℕ := ⌊max 0 (Q - Kr)⌋₊ with hk_def
  have hkle : (k : ℝ) ≤ max 0 (Q - Kr) := Nat.floor_le (le_max_left _ _)
  have hklt : max 0 (Q - Kr) < (k : ℝ) + 1 := Nat.lt_floor_add_one _
  have hmax : max 0 (Q - Kr) * Real.pi ≤ |φ b - φ a| := by
    rcases le_total (Q - Kr) 0 with h | h
    · rw [max_eq_left h, zero_mul]; exact abs_nonneg _
    · rw [max_eq_right h]
      linarith [le_abs_self (φ b - φ a)]
  have hk : (k : ℝ) * Real.pi ≤ |φ b - φ a| :=
    le_trans (mul_le_mul_of_nonneg_right hkle hπ.le) hmax
  obtain ⟨t, hmono, hmem, hcos⟩ := LevinsonArg.crossings_of_arg hab.le hφc k hk
  -- every crossing is a zero of `ζ`
  have hζt : ∀ i, riemannZeta (1/2 + t i * I) = 0 := by
    intro i
    have hti := hmem i
    have hreF : (I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ (1/2 + t i * I) * H (1/2 + t i * I))).re = 0 := by
      rw [hφ _ hti, Complex.re_ofReal_mul, Complex.exp_ofReal_mul_I_re, hcos i, mul_zero]
    apply (LevinsonLine.zeta_line_zero_iff c (t i) (hfac _ hti)).mpr
    have e1 : riemannZeta (1/2 + ↑(t i) * I) + ↑c * deriv riemannZeta (1/2 + ↑(t i) * I)
        = polyP D n (1/2 + ↑(t i) * I) * H (1/2 + ↑(t i) * I) := hGPH _
    rw [e1, polyP_line n (fun ρ hρ => (hDprop ρ hρ).1)]
    have e2 : Gammaℝ (1/2 + ↑(t i) * I) * (I ^ (∑ ρ ∈ D, n ρ)
        * ((∏ ρ ∈ D, (t i - ρ.im) ^ n ρ : ℝ) : ℂ) * H (1/2 + ↑(t i) * I))
        = ((∏ ρ ∈ D, (t i - ρ.im) ^ n ρ : ℝ) : ℂ)
          * (I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ (1/2 + t i * I) * H (1/2 + t i * I))) := by ring
    rw [e2, Complex.re_ofReal_mul, hreF, mul_zero]
  -- the count: crossings once, the zeros of `D` with their order
  set Γs : Finset ℝ := D.image (fun ρ => ρ.im) with hΓs
  set E : Finset ℝ := Finset.univ.image t ∪ Γs with hE
  have hmemE : ∀ γ ∈ E, (∃ i, t i = γ) ∨ ∃ ρ ∈ D, ρ.im = γ := by
    intro γ hγ
    rw [hE, Finset.mem_union, Finset.mem_image, hΓs, Finset.mem_image] at hγ
    rcases hγ with ⟨i, -, hi⟩ | ⟨ρ, hρ, hργ⟩
    · exact Or.inl ⟨i, hi⟩
    · exact Or.inr ⟨ρ, hρ, hργ⟩
  have hEζ : ∀ γ ∈ E, riemannZeta (1/2 + γ * I) = 0 := by
    intro γ hγ
    rcases hmemE γ hγ with ⟨i, rfl⟩ | ⟨ρ, hρ, rfl⟩
    · exact hζt i
    · rw [← hρeq ρ hρ]; exact hζD ρ hρ
  have hEgt : ∀ γ ∈ E, a < γ := by
    intro γ hγ
    rcases hmemE γ hγ with ⟨i, rfl⟩ | ⟨ρ, hρ, rfl⟩
    · refine lt_of_le_of_ne (hmem i).1 fun he => hζa ?_
      rw [he]
      exact hζt i
    · exact (hDprop ρ hρ).2.1
  have hET : ∀ γ ∈ E, γ ≤ b := by
    intro γ hγ
    rcases hmemE γ hγ with ⟨i, rfl⟩ | ⟨ρ, hρ, rfl⟩
    · exact (hmem i).2
    · exact (hDprop ρ hρ).2.2.le
  have hsum := sum_order_le_lineCount_sub (by linarith) hab.le E hEgt hET hEζ
  have hord : ∀ γ ∈ E, (1 : ℤ) + (if γ ∈ Γs then (n (1/2 + γ * I) : ℤ) else 0)
      ≤ riemannZeta.order (1/2 + γ * I) := by
    intro γ hγ
    split_ifs with hγΓ
    · rw [hΓs, Finset.mem_image] at hγΓ
      obtain ⟨ρ, hρ, rfl⟩ := hγΓ
      rw [← hρeq ρ hρ]
      have hR := ((hmemD ρ).mp hρ).1
      have hρ1 : ρ ≠ 1 := by
        intro h1
        have := (hDprop ρ hρ).1
        rw [h1, Complex.one_re] at this
        norm_num at this
      have h := zeta_order_ge hcne hρ1 (hζD ρ hρ) (hfin ρ hR)
      have hnρ : ((n ρ : ℕ) : ℤ) = ((analyticOrderAt G ρ).toNat : ℤ) := rfl
      linarith
    · have hmemZ : ((1/2 : ℂ) + (γ : ℂ) * I) ∈ NontrivialZeros := by
        refine ⟨?_, Set.mem_univ _, hEζ γ hγ⟩
        rw [HardyZ.re_line]
        norm_num
      have := riemannZeta_one_le_order_nontrivialZero ⟨_, hmemZ⟩
      simpa using this
  have hsumge : ((E.card : ℤ) + ∑ ρ ∈ D, (n ρ : ℤ)) ≤ ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) := by
    have h1 := Finset.sum_le_sum hord
    rw [Finset.sum_add_distrib, Finset.sum_const, nsmul_eq_mul, mul_one, Finset.sum_ite_mem,
      Finset.inter_eq_right.mpr Finset.subset_union_right] at h1
    have h2 : ∑ γ ∈ Γs, (n (1/2 + γ * I) : ℤ) = ∑ ρ ∈ D, (n ρ : ℤ) := by
      rw [hΓs, Finset.sum_image]
      · exact Finset.sum_congr rfl fun ρ hρ => by rw [← hρeq ρ hρ]
      · intro ρ₁ h₁ ρ₂ h₂ he
        rw [hρeq ρ₁ h₁, hρeq ρ₂ h₂]
        simp only at he
        rw [he]
    rw [h2] at h1
    exact h1
  have hcardE : k ≤ E.card := by
    have h1 : (Finset.univ.image t).card = k := by
      rw [Finset.card_image_of_injective _ hmono.injective, Finset.card_univ, Fintype.card_fin]
    rw [← h1]
    exact Finset.card_le_card Finset.subset_union_left
  have hfinal : ((k : ℤ) + ∑ ρ ∈ D, (n ρ : ℤ)) ≤ lineCount b - lineCount a := by
    have : (k : ℤ) ≤ E.card := by exact_mod_cast hcardE
    linarith
  have hfinalR : (k : ℝ) + Kr ≤ (lineCount b : ℝ) - (lineCount a : ℝ) := by
    rw [hKr]
    exact_mod_cast hfinal
  have hQmax : Q - Kr ≤ max 0 (Q - Kr) := le_max_right _ _
  have hKr0 : 0 ≤ Kr := Finset.sum_nonneg fun _ _ => Nat.cast_nonneg _
  have e2 : (riemannZeta.N b - riemannZeta.N a) - 2 * C - (72 * Real.log b + 418) = Q - 1 := by
    rw [hQ]; ring
  rw [e2]
  linarith

set_option maxHeartbeats 400000 in
/-- **S12, the window restated, difference form.** `LevinsonMultiple.levinson_window'` with the
mean hypothesis `hK` asked only for `a ≤ a' ≤ a + 1`, `b − 1 ≤ b' ≤ b`, the windows its proof
uses, and the zeros on the line with height in `(a, b]` on the right. The proof is a copy: the
bottom height avoids the zeros of `ζ` too, and step 4 is `levinson_count_sub`. -/
theorem levinson_window_diff {T c σ₀ δ X a b K B : ℝ} {M : ℕ} {β : ℕ → ℂ}
    (hT : Real.exp 26 ≤ T) (hc : c = 1 / Real.log T)
    (hM : 1 ≤ M) (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B)
    (hσ₀ : σ₀ < 1 / 2) (hδ : 0 < δ) (hσδ : 1 / 4 ≤ σ₀ - δ)
    (hX : 3 ≤ X) (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hXa : 2 * X ≤ a)
    (hab : a + 3 ≤ b) (hbT : b ≤ T) (hK1 : 1 ≤ K)
    (hK : ∀ a' b' : ℝ, a ≤ a' → a' ≤ a + 1 → b - 1 ≤ b' → b' ≤ b → a' < b' →
      ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b',
        ‖(riemannZeta (↑σ + ↑t * I) + c * deriv riemannZeta (↑σ + ↑t * I))
          * LevinsonMollEdge.molli M β (↑σ + ↑t * I)‖ ^ 2 ≤ K) :
    (riemannZeta.N b - riemannZeta.N a)
      - (1 / (Real.pi * (1 / 2 - σ₀))) * ((b - a) / 2 * Real.log K + windowE M B X T a b)
      - (134 * Real.log T + 2918) ≤ (lineCount b : ℝ) - (lineCount a : ℝ) := by
  -- the constants
  have hL26 : (26 : ℝ) ≤ Real.log T := by
    have h := Real.log_le_log (Real.exp_pos 26) hT
    rwa [Real.log_exp] at h
  have hLpos : 0 < Real.log T := by linarith
  have hc0 : 0 ≤ c := by rw [hc]; positivity
  have hc1 : c ≤ 1 := by rw [hc, div_le_one hLpos]; linarith
  have hcpos : 0 < c := by rw [hc]; exact one_div_pos.mpr hLpos
  have hB1 : 1 ≤ B := by
    have := hβ 1
    rw [hβ1, norm_one] at this
    exact this
  have hT1 : 1 ≤ T := by linarith
  have ha4 : 4 ≤ a := by linarith
  have hδh := LevinsonMollEdge.tailDelta_le_half hM hB1 hXMB
  -- `G ψ` on `Re = X`
  have hreX : ∀ t : ℝ, 0 < ((riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
      * LevinsonMollEdge.molli M β (↑X + ↑t * I)).re := by
    intro t
    have h1 := LevinsonMollEdge.f_sub_one_le hc0 hc1 hM hβ1 hβ hX (s := ↑X + ↑t * I) (by simp)
    have h2 := Complex.abs_re_le_norm
      ((riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
        * LevinsonMollEdge.molli M β (↑X + ↑t * I) - 1)
    rw [Complex.sub_re, Complex.one_re, abs_le] at h2
    linarith [h2.1]
  have hneX : ∀ t : ℝ, (riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
      * LevinsonMollEdge.molli M β (↑X + ↑t * I) ≠ 0 := by
    intro t h
    have := hreX t
    rw [h, Complex.zero_re] at this
    exact lt_irrefl _ this
  have hFa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ
      (fun s => (riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s) w :=
    fun w hw => LevinsonMollEdge.f_analyticAt c M β hw
  have hGa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ (fun s => riemannZeta s + c * deriv riemannZeta s) w :=
    fun w hw => LevinsonEdge.G_analyticAt c hw
  -- step 1: good heights
  -- the bottom height also avoids the zeros of `ζ`, so no zero of `ζ` sits at height `a'`
  have hζX : ∀ t : ℝ, riemannZeta (↑X + ↑t * I) ≠ 0 := fun t =>
    riemannZeta_ne_zero_of_one_lt_re (by simp; linarith)
  have hZa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ riemannZeta w := fun w hw =>
    analyticOn_riemannZeta w hw
  have hZFa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ (fun s => riemannZeta s *
      ((riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s)) w :=
    fun w hw => (hZa w hw).mul (hFa w hw)
  obtain ⟨a', ha', hgZA⟩ := LevinsonAvoid.exists_good_height
    (f := fun s => riemannZeta s *
      ((riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s))
    (σ₀ := σ₀ - δ) (X := X) (t₀ := a)
    (analyticOnNhd_rect_of_im hZFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + (a : ℝ) * I, LevinsonAvoid.mem_rect_of
      (by simp) (by simp), mul_ne_zero (hζX a) (hneX a)⟩
  have hgA : ∀ x ∈ Icc (σ₀ - δ) X,
      (fun s => (riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s)
        ((x : ℂ) + a' * I) ≠ 0 :=
    fun x hx => right_ne_zero_of_mul (hgZA x hx)
  have hζa' : riemannZeta (1 / 2 + a' * I) ≠ 0 := by
    have h := left_ne_zero_of_mul (hgZA (1 / 2) ⟨by linarith, by linarith⟩)
    push_cast at h
    exact h
  obtain ⟨b', hb', hgB⟩ := LevinsonAvoid.exists_good_height
    (f := fun s => (riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s)
    (σ₀ := σ₀ - δ) (X := X) (t₀ := b - 1)
    (analyticOnNhd_rect_of_im hFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + ((b - 1 : ℝ) : ℂ) * I, LevinsonAvoid.mem_rect_of
      (by simp)
      (by simp), hneX (b - 1)⟩
  have hb'1 : b - 1 ≤ b' := hb'.1
  have hb'2 : b' ≤ b := by linarith [hb'.2]
  have ha'1 : a ≤ a' := ha'.1
  have ha'2 : a' ≤ a + 1 := ha'.2
  have ha'b' : a' < b' := by linarith
  -- step 2: a good abscissa
  obtain ⟨σ', hσ', hgL⟩ := LevinsonAvoid.exists_good_abscissa
    (f := fun s => (riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s)
    (σ₀ := σ₀) (δ := δ) (X := X) (a := a') (b := b') hδ (by linarith)
    (analyticOnNhd_rect_of_im hFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + (a' : ℝ) * I, LevinsonAvoid.mem_rect_of
      (by simp)
      (by simp), hneX a'⟩
  have hσ'1 : σ₀ - δ ≤ σ' := hσ'.1
  have hσ'2 : σ' ≤ σ₀ := hσ'.2
  -- step 3: `G ψ ≠ 0` on the border of `[σ', X] × [a', b']`
  have hBR : ∀ p ∈ RectangleBorder ((σ' : ℂ) + a' * I) ((X : ℂ) + b' * I),
      (riemannZeta p + c * deriv riemannZeta p) * LevinsonMollEdge.molli M β p ≠ 0 := by
    intro p hp
    have e1 : ((σ' : ℂ) + a' * I).re = σ' := by simp
    have e2 : ((σ' : ℂ) + a' * I).im = a' := by simp
    have e3 : ((X : ℂ) + b' * I).re = X := by simp
    have e4 : ((X : ℂ) + b' * I).im = b' := by simp
    have hcases := border_cases (by rw [e1, e3]; linarith) (by rw [e2, e4]; linarith) hp
    rw [e1, e2, e3, e4] at hcases
    have hp' : p = ↑p.re + ↑p.im * I := (Complex.re_add_im p).symm
    rcases hcases with ⟨him, hre⟩ | ⟨hre, him⟩ | ⟨him, hre⟩ | ⟨hre, him⟩
    · rw [hp', him]; exact hgA p.re ⟨by linarith [hre.1], hre.2⟩
    · rw [hp', hre]; exact hgL p.im him
    · rw [hp', him]; exact hgB p.re ⟨by linarith [hre.1], hre.2⟩
    · rw [hp', hre]; exact hneX p.im
  have hGR : AnalyticOnNhd ℂ (fun s => riemannZeta s + c * deriv riemannZeta s)
      (Rectangle ((σ' : ℂ) + a' * I) ((X : ℂ) + b' * I)) :=
    analyticOnNhd_rect_of_im hGa (by simp; linarith) (by simp; linarith)
  have hψR : AnalyticOnNhd ℂ (LevinsonMollEdge.molli M β)
      (Rectangle ((σ' : ℂ) + a' * I) ((X : ℂ) + b' * I)) :=
    fun p _ => (LevinsonMollEdge.molli_differentiable M β).analyticAt p
  have hLR := LevinsonRight.levinson_right (G := fun s => riemannZeta s + c * deriv riemannZeta s)
    (M := LevinsonMollEdge.molli M β) (σ₀ := σ') (X := X) (a := a') (b := b')
    (by linarith) (by linarith) ha'b' hGR hψR hBR
  -- the edge terms
  have hRT := LevinsonMollEdge.right_terms_le hc0 hc1 hM hβ1 hβ (σ₀ := σ') (a := a') (b := b')
    hX hXMB (by linarith) ha'b'.le
  have hHa := abs_le.mp (LevinsonMollEdge.horizontal_terms_le hc0 hc1 hM hβ1 hβ (σ₀ := σ')
    (T := a') hX hXMB (by linarith) (by linarith) (by linarith)
    (fun x hx => hgA x ⟨by linarith [hx.1], hx.2⟩))
  have hHb := abs_le.mp (LevinsonMollEdge.horizontal_terms_le hc0 hc1 hM hβ1 hβ (σ₀ := σ')
    (T := b') hX hXMB (by linarith) (by linarith) (by linarith)
    (fun x hx => hgB x ⟨by linarith [hx.1], hx.2⟩))
  have hmean := half_log_mean_le ha'b'.le hK1 (hK a' b' ha'1 ha'2 hb'1 hb'2 ha'b' σ' hσ')
  -- the size comparisons
  have hπ := Real.pi_pos
  have hM1 : (1 : ℝ) ≤ M := by exact_mod_cast hM
  have hlM : 0 ≤ Real.log (M : ℝ) := Real.log_nonneg hM1
  have hlB : 0 ≤ Real.log B := Real.log_nonneg hB1
  have hlK : 0 ≤ Real.log K := Real.log_nonneg hK1
  have hla' : Real.log a' ≤ Real.log T := Real.log_le_log (by linarith) (by linarith)
  have hlb' : Real.log b' ≤ Real.log T := Real.log_le_log (by linarith) (by linarith)
  have hla'0 : 0 ≤ Real.log a' := Real.log_nonneg (by linarith)
  have hlb'0 : 0 ≤ Real.log b' := Real.log_nonneg (by linarith)
  have htd := tailDelta_nonneg (M := M) (X := X) (by linarith : (0 : ℝ) ≤ B)
  have hP : ∀ y : ℝ, 0 ≤ Real.log y → Real.log y ≤ Real.log T →
      (X - σ') * (Real.pi * ((8 * X - 1) * (Real.log y + Real.log M + Real.log B + 8) + 1))
        ≤ X * (Real.pi * ((8 * X - 1) * (Real.log T + Real.log M + Real.log B + 8) + 1)) := by
    intro y hy0 hyT
    have hin : (8 * X - 1) * (Real.log y + Real.log M + Real.log B + 8)
        ≤ (8 * X - 1) * (Real.log T + Real.log M + Real.log B + 8) :=
      mul_le_mul_of_nonneg_left (by linarith) (by linarith)
    have hin0 : 0 ≤ (8 * X - 1) * (Real.log y + Real.log M + Real.log B + 8) :=
      mul_nonneg (by linarith) (by linarith)
    exact mul_le_mul (by linarith) (mul_le_mul_of_nonneg_left (by linarith) hπ.le)
      (mul_nonneg hπ.le (by linarith)) (by linarith)
  have hPa := hP a' hla'0 hla'
  have hPb := hP b' hlb'0 hlb'
  have hlen : (b' - a') / 2 * Real.log K ≤ (b - a) / 2 * Real.log K :=
    mul_le_mul_of_nonneg_right (by linarith) hlK
  have hlen2 : (b' - a') * (2 * LevinsonMollEdge.tailDelta M B X)
      ≤ (b - a) * (2 * LevinsonMollEdge.tailDelta M B X) :=
    mul_le_mul_of_nonneg_right (by linarith) (by linarith)
  have hσπ : 0 ≤ σ' * Real.pi := mul_nonneg (by linarith) hπ.le
  set U := (b - a) / 2 * Real.log K + windowE M B X T a b with hU
  have hU0 : 0 ≤ U := by
    have := windowE_nonneg (T := T) (a := a) (b := b) hM hB1 hX hT1 (by linarith)
    have h2 : 0 ≤ (b - a) / 2 * Real.log K := mul_nonneg (by linarith) hlK
    rw [hU]; linarith
  -- steps 3–4 assembled: the count right of the line with right side `X`
  have hf'pos : 0 < 1 / (2 * Real.pi * (1 / 2 - σ')) := by
    have : 0 < 1 / 2 - σ' := by linarith
    positivity
  have hCX : countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
      ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I) (1 / 2)
        ≤ 1 / (2 * Real.pi * (1 / 2 - σ')) * U := by
    refine le_trans hLR (mul_le_mul_of_nonneg_left ?_ hf'pos.le)
    rw [hU]
    unfold windowE
    linarith [hRT, hHa.1, hHa.2, hHb.1, hHb.2, hmean, hPa, hPb, hlen, hlen2, hσπ]
  have hff : 1 / (2 * Real.pi * (1 / 2 - σ')) ≤ 1 / (2 * Real.pi * (1 / 2 - σ₀)) := by
    have h0 : 0 < 2 * Real.pi * (1 / 2 - σ₀) := by
      have : 0 < 1 / 2 - σ₀ := by linarith
      positivity
    exact one_div_le_one_div_of_le h0
      (mul_le_mul_of_nonneg_left (by linarith) (by positivity))
  have hCX' : countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
      ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I) (1 / 2)
        ≤ 1 / (2 * Real.pi * (1 / 2 - σ₀)) * U :=
    le_trans hCX (mul_le_mul_of_nonneg_right hff hU0)
  -- step 5: from the right side `3` to `X`
  have hsub : Rectangle ((1 / 2 : ℂ) + a' * I) ((3 : ℂ) + b' * I)
      ⊆ Rectangle ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I) := by
    intro p hp
    rw [Rectangle] at hp ⊢
    obtain ⟨h1, h2⟩ := mem_reProdIm.mp hp
    refine mem_reProdIm.mpr ⟨?_, by simpa using h2⟩
    have e1 : ((1 / 2 : ℂ) + a' * I).re = 1 / 2 := by simp
    have e3 : ((3 : ℂ) + b' * I).re = 3 := by simp
    have eX : ((X : ℂ) + b' * I).re = X := by simp
    rw [e1, e3, uIcc_of_le (by norm_num)] at h1
    rw [e1, eX, uIcc_of_le (by linarith)]
    exact ⟨h1.1, le_trans h1.2 hX⟩
  have hGX : AnalyticOnNhd ℂ (fun s => riemannZeta s + c * deriv riemannZeta s)
      (Rectangle ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I)) :=
    analyticOnNhd_rect_of_im hGa (by simp; linarith) (by simp; linarith)
  have hGz : riemannZeta ((1 / 2 : ℂ) + a' * I) + c * deriv riemannZeta ((1 / 2 : ℂ) + a' * I)
      ≠ 0 := by
    have h := hgA (1 / 2) ⟨by linarith, by linarith⟩
    push_cast at h
    exact left_ne_zero_of_mul h
  have h3X := countRight_right_le (σ := 1 / 2) hsub hGX hGz
  -- step 4: `levinson_count'` on `[1/2, 3] × [a', b']`, no hypothesis on the line
  have hfac : ∀ t ∈ Icc a' b',
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0 := by
    intro t ht
    rw [hc]
    exact (LevinsonAvoid.factor_pos hT ⟨by linarith [ht.1], by linarith [ht.2]⟩).ne'
  have hLC := levinson_count_sub hcpos hc1 (by linarith : (4 : ℝ) ≤ a') ha'b'
    (fun x hx => left_ne_zero_of_mul (hgA x ⟨by linarith [hx.1], by linarith [hx.2]⟩))
    (fun x hx => left_ne_zero_of_mul (hgB x ⟨by linarith [hx.1], by linarith [hx.2]⟩))
    hfac hζa'
  -- step 5: the line count and `N` at the shifted heights
  have hLb : (lineCount b' : ℝ) ≤ (lineCount b : ℝ) := by
    exact_mod_cast lineCount_mono hb'2
  have hLa : (lineCount a : ℝ) ≤ (lineCount a' : ℝ) := by
    exact_mod_cast lineCount_mono ha'1
  have hNb := N_step_le (t := b - 1) (u := b) (by linarith) (by linarith) (by linarith)
  have hNa := N_step_le (t := a) (u := a + 1) (by linarith) (by linarith) (by linarith)
  have hNb' := ArgCount.N_mono hb'1
  have hNa' := ArgCount.N_mono ha'2
  have hlb : Real.log b ≤ Real.log T := Real.log_le_log (by linarith) hbT
  have hla1 : Real.log (a + 1) ≤ Real.log T := Real.log_le_log (by linarith) (by linarith)
  -- step 6: the factor
  have e2 : 1 / (Real.pi * (1 / 2 - σ₀)) * U = 2 * (1 / (2 * Real.pi * (1 / 2 - σ₀)) * U) := by
    have h1 : (1 / 2 - σ₀) ≠ 0 := by linarith
    have h2 : Real.pi ≠ 0 := hπ.ne'
    field_simp
    try ring
  rw [e2]
  linarith [hLC, hLb, hLa, hNb, hNa, hNb', hNa', hlb, hla1, hlb', h3X, hCX']


/-- **S12, the window restated.** The conclusion of `LevinsonMultiple.levinson_window'` with the
mean hypothesis `hK` asked only for `a ≤ a' ≤ a + 1`, `b − 1 ≤ b' ≤ b`. -/
theorem levinson_window_near {T c σ₀ δ X a b K B : ℝ} {M : ℕ} {β : ℕ → ℂ}
    (hT : Real.exp 26 ≤ T) (hc : c = 1 / Real.log T)
    (hM : 1 ≤ M) (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B)
    (hσ₀ : σ₀ < 1 / 2) (hδ : 0 < δ) (hσδ : 1 / 4 ≤ σ₀ - δ)
    (hX : 3 ≤ X) (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hXa : 2 * X ≤ a)
    (hab : a + 3 ≤ b) (hbT : b ≤ T) (hK1 : 1 ≤ K)
    (hK : ∀ a' b' : ℝ, a ≤ a' → a' ≤ a + 1 → b - 1 ≤ b' → b' ≤ b → a' < b' →
      ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b',
        ‖(riemannZeta (↑σ + ↑t * I) + c * deriv riemannZeta (↑σ + ↑t * I))
          * LevinsonMollEdge.molli M β (↑σ + ↑t * I)‖ ^ 2 ≤ K) :
    (riemannZeta.N b - riemannZeta.N a)
      - (1 / (Real.pi * (1 / 2 - σ₀))) * ((b - a) / 2 * Real.log K + windowE M B X T a b)
      - (134 * Real.log T + 2918) ≤ (lineCount b : ℝ) := by
  have h := levinson_window_diff hT hc hM hβ1 hβ hσ₀ hδ hσδ hX hXMB hXa hab hbT hK1 hK
  have h0 : (0 : ℝ) ≤ (lineCount a : ℝ) := by exact_mod_cast lineCount_nonneg a
  linarith

/-- info: 'LevinsonWindowNear.sum_order_le_lineCount_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_order_le_lineCount_sub

/-- info: 'LevinsonWindowNear.lineCount_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lineCount_nonneg

/-- info: 'LevinsonWindowNear.levinson_count_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_count_sub

/-- info: 'LevinsonWindowNear.levinson_window_diff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_window_diff

/-- info: 'LevinsonWindowNear.levinson_window_near' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_window_near

end LevinsonWindowNear
