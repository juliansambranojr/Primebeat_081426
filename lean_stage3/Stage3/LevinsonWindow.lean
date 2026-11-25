/-
LevinsonWindow — block S11 of `lean_stage3/design/stencil.md`, the assembled window theorem.
2026-11-25.

Levinson's count on a window `[a, b]`, with the mean square of the mollified function as the
one named input. Fix `T ≥ e^26`, `c = 1/log T`, `G = ζ + c ζ'`, the mollifier
`ψ = LevinsonMollEdge.molli M β` (`β 1 = 1`, `‖β h‖ ≤ B`, `1 ≤ M`), `σ₀ < 1/2`, `δ > 0` with
`1/4 ≤ σ₀ − δ`, `X ≥ 3` with `32 M B ≤ 2^X` and `2X ≤ a`, and a window `a + 3 ≤ b ≤ T`.

1. Good heights inside the window: `a' ∈ [a, a + 1]` and `b' ∈ [b − 1, b]` with `G ψ ≠ 0` on
   `[σ₀ − δ, X] + a' i` and on `[σ₀ − δ, X] + b' i` (`LevinsonAvoid.exists_good_height`; the
   nonzero point is `X + a i`, where `Re (G ψ) ≥ 1/2` by `LevinsonMollEdge.f_sub_one_le`).
2. A good abscissa `σ' ∈ [σ₀ − δ, σ₀]` with `G ψ ≠ 0` on `σ' + [a', b'] i`
   (`LevinsonAvoid.exists_good_abscissa`).
3. So `G ψ ≠ 0` on the border of `[σ', X] × [a', b']`, and `LevinsonRight.levinson_right`
   applies there; its terms are bounded by `LevinsonMollEdge.right_terms_le`,
   `LevinsonMollEdge.horizontal_terms_le` (at `a'` and `b'`, both `≥ 2X`) and the mean square
   hypothesis on the line `σ'` over `[a', b']`.
4. `LevinsonCount.levinson_count` on `[1/2, 3] × [a', b']`: the horizontal edges lie inside
   the good segments (`σ' ≤ 1/2`, `3 ≤ X`), the right edge has `Re G > 0`
   (`LevinsonSize.re_G_pos`). The left edge is the critical line, which no choice of
   abscissa moves. A zero of `G` on it is a zero of `ζ` (`LevinsonLine.zeta_line_zero_iff`,
   the real factor being positive by `LevinsonAvoid.factor_pos`), hence also of `ζ'`, since
   `c ≠ 0`: a multiple zero of `ζ` on the line. That case stays a hypothesis, in the form
   "every zero of `ζ` on the segment `1/2 + [a, b] i` is simple" (`hsimple`); `G_line_ne`
   turns it into `G ≠ 0` on the line.
5. The count of `levinson_count` (right side `3`) is at most the count of `levinson_right`
   (right side `X ≥ 3`) by `countRight_right_le`; the line count is monotone
   (`lineCount_mono`); `N` moves by at most `31 log u + 1250` over a unit interval
   (`N_step_le`, from `N = argS + θ/π + 1`, `ArgCount.sCrude_holds` and
   `ArgCount.phaseTheta_sub_le`), which pays for moving `a`, `b` to `a'`, `b'`.
6. The factor `2 · 1/(2π(1/2 − σ'))` is at most `1/(π(1/2 − σ₀))` since `σ' ≤ σ₀`.

  border_cases            Re z ≤ Re w, Im z ≤ Im w, p ∈ RectangleBorder z w
                            ⊢ p on the bottom, left, top or right edge
  analyticOnNhd_rect_of_im  f analytic off 1, 1 ≤ Im z, 1 ≤ Im w
                            ⊢ AnalyticOnNhd ℂ f (Rectangle z w)
  countRight_right_le     Rectangle z w' ⊆ Rectangle z w, f analytic on R(z, w), f z ≠ 0
                            ⊢ countRight f z w' σ ≤ countRight f z w σ
  lineCount_mono          T ≤ T'  ⊢ lineCount T ≤ lineCount T'
  N_step_le               4 ≤ t ≤ u ≤ t + 1  ⊢ N u − N t ≤ 31 log u + 1250
  G_line_ne               c ≠ 0, 1 − c · Re(Gammaℝ'/Gammaℝ)(1/2 + t i) ≠ 0,
                            ζ(1/2 + t i) = 0 → ζ'(1/2 + t i) ≠ 0
                            ⊢ ζ(1/2 + t i) + c ζ'(1/2 + t i) ≠ 0
  half_log_mean_le        a ≤ b, 1 ≤ K, (1/(b − a)) ∫_a^b ‖F‖² ≤ K
                            ⊢ (b − a)/2 · log ((1/(b − a)) ∫_a^b ‖F‖²) ≤ (b − a)/2 · log K
  windowE_nonneg          1 ≤ M, 1 ≤ B, 3 ≤ X, 1 ≤ T, a ≤ b  ⊢ 0 ≤ windowE M B X T a b
  levinson_window         e^26 ≤ T, c = 1/log T, 1 ≤ M, β 1 = 1, ‖β h‖ ≤ B,
                            σ₀ < 1/2, 0 < δ, 1/4 ≤ σ₀ − δ, 3 ≤ X, 32 M B ≤ 2^X, 2X ≤ a,
                            a + 3 ≤ b ≤ T, 1 ≤ K,
                            (1/(b' − a')) ∫_{a'}^{b'} ‖G ψ(σ + it)‖² dt ≤ K
                              for a ≤ a' < b' ≤ b and σ ∈ [σ₀ − δ, σ₀],
                            every zero of ζ on 1/2 + [a, b] i simple
                            ⊢ (N b − N a)
                                − (1/(π(1/2 − σ₀))) · ((b − a)/2 · log K + windowE M B X T a b)
                                − (134 log T + 2918) ≤ lineCount b

  windowE M B X T a b = (b − a) · 2 tailDelta M B X + X π
                          + 2 X π ((8X − 1)(log T + log M + log B + 8) + 1)

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonMollEdge
import Stage3.LevinsonAvoid

namespace LevinsonWindow

open Complex MeasureTheory Set Littlewood LineCount Kadiri
open scoped Interval

/-- The mollifier edge terms of the window, collected. -/
noncomputable
def windowE (M : ℕ) (B X T a b : ℝ) : ℝ :=
  (b - a) * (2 * LevinsonMollEdge.tailDelta M B X) + X * Real.pi
    + 2 * (X * (Real.pi * ((8 * X - 1)
        * (Real.log T + Real.log M + Real.log B + 8) + 1)))

/-- A border point lies on one of the four edges. -/
theorem border_cases {z w p : ℂ} (hre : z.re ≤ w.re) (him : z.im ≤ w.im)
    (hp : p ∈ RectangleBorder z w) :
    (p.im = z.im ∧ p.re ∈ Icc z.re w.re) ∨ (p.re = z.re ∧ p.im ∈ Icc z.im w.im)
      ∨ (p.im = w.im ∧ p.re ∈ Icc z.re w.re) ∨ (p.re = w.re ∧ p.im ∈ Icc z.im w.im) := by
  rw [RectangleBorder, uIcc_of_le hre, uIcc_of_le him] at hp
  simp only [mem_union, mem_reProdIm, mem_singleton_iff] at hp
  rcases hp with ((⟨h1, h2⟩ | ⟨h1, h2⟩) | ⟨h1, h2⟩) | ⟨h1, h2⟩
  · exact Or.inl ⟨h2, h1⟩
  · exact Or.inr (Or.inl ⟨h1, h2⟩)
  · exact Or.inr (Or.inr (Or.inl ⟨h2, h1⟩))
  · exact Or.inr (Or.inr (Or.inr ⟨h1, h2⟩))

/-- Analytic off the pole, a function is analytic near any rectangle above `Im = 1`. -/
theorem analyticOnNhd_rect_of_im {f : ℂ → ℂ} (hf : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ f w)
    {z w : ℂ} (hz : 1 ≤ z.im) (hw : 1 ≤ w.im) : AnalyticOnNhd ℂ f (Rectangle z w) := by
  intro p hp
  apply hf
  intro h1
  rw [Rectangle] at hp
  have h2 := (mem_reProdIm.mp hp).2
  rw [h1, Complex.one_im] at h2
  rcases mem_uIcc.mp h2 with h | h <;> linarith [h.1, h.2]

/-- The count right of `σ` grows with the rectangle. -/
theorem countRight_right_le {f : ℂ → ℂ} {z w w' : ℂ} {σ : ℝ}
    (hsub : Rectangle z w' ⊆ Rectangle z w) (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hz : f z ≠ 0) : countRight f z w' σ ≤ countRight f z w σ := by
  classical
  have hfin := order_ne_top hf hz
  have hsub' : (divisor_support_rectangle_finite f z w').toFinset
      ⊆ (divisor_support_rectangle_finite f z w).toFinset := by
    intro p hp
    rw [Set.Finite.mem_toFinset] at hp ⊢
    obtain ⟨hpR, hp0⟩ := (mem_support_divisor hsub hf hfin p).mp hp
    exact (mem_support_divisor subset_rfl hf hfin p).mpr ⟨hsub hpR, hp0⟩
  unfold countRight
  calc ∑ p ∈ (divisor_support_rectangle_finite f z w').toFinset,
        (if σ < p.re then ((MeromorphicOn.divisor f (Rectangle z w') p : ℤ) : ℝ) else 0)
      = ∑ p ∈ (divisor_support_rectangle_finite f z w').toFinset,
        (if σ < p.re then ((MeromorphicOn.divisor f (Rectangle z w) p : ℤ) : ℝ) else 0) := by
        refine Finset.sum_congr rfl fun p hp => ?_
        have hpS := (divisor_support_rectangle_finite f z w').mem_toFinset.mp hp
        have hpR := ((mem_support_divisor hsub hf hfin p).mp hpS).1
        rw [divisor_eq hsub hf hpR]
    _ ≤ ∑ p ∈ (divisor_support_rectangle_finite f z w).toFinset,
        (if σ < p.re then ((MeromorphicOn.divisor f (Rectangle z w) p : ℤ) : ℝ) else 0) := by
        refine Finset.sum_le_sum_of_subset_of_nonneg hsub' fun p _ _ => ?_
        split_ifs
        · exact LevinsonRight.divisor_nonneg_real hf p
        · exact le_refl _

/-- The line count is monotone in the height. -/
theorem lineCount_mono {T T' : ℝ} (h : T ≤ T') : lineCount T ≤ lineCount T' := by
  unfold lineCount
  refine Finset.sum_le_sum_of_subset_of_nonneg ?_
    (fun ρ _ _ => (riemannZeta_order_pos_nontrivialZero ρ).le)
  intro ρ hρ
  rw [Finset.mem_filter] at hρ ⊢
  refine ⟨?_, hρ.2⟩
  have h1 := mem_zerosUpTo.mp hρ.1
  exact mem_zerosUpTo.mpr ⟨h1.1, le_trans h1.2 h⟩

/-- **`N` over a unit interval.** For `4 ≤ t ≤ u ≤ t + 1`, `N u − N t ≤ 31 log u + 1250`. -/
theorem N_step_le {t u : ℝ} (ht : 4 ≤ t) (htu : t ≤ u) (hu : u ≤ t + 1) :
    riemannZeta.N u - riemannZeta.N t ≤ 31 * Real.log u + 1250 := by
  have hM : ∀ s ∈ Icc (u - 1) u, |Stage3.phasePoint s| ≤ Real.log u + 97 := by
    intro s hs
    have hs3 : 3 ≤ s := by linarith [hs.1]
    have h := Stage3.stmtDigammaLog_holds.1 s (by linarith)
    have hl0 : 0 ≤ Real.log (s / 2) := Real.log_nonneg (by linarith)
    have hl1 : Real.log (s / 2) ≤ Real.log u :=
      Real.log_le_log (by linarith) (by linarith [hs.2])
    have h97 : 97 / s ≤ 97 := by
      rw [div_le_iff₀ (by linarith)]; linarith
    rw [abs_le] at h ⊢
    constructor <;> linarith [h.1, h.2]
  have hθ := ArgCount.phaseTheta_sub_le htu hu hM
  have hlogu : 0 ≤ Real.log u := Real.log_nonneg (by linarith)
  have hlogt : Real.log t ≤ Real.log u := Real.log_le_log (by linarith) htu
  have hlogpi : Real.log Real.pi ≤ Real.pi - 1 := Real.log_le_sub_one_of_pos Real.pi_pos
  have hlogpi0 : 0 ≤ Real.log Real.pi := Real.log_nonneg (by linarith [Real.pi_gt_three])
  have hpi := Real.pi_lt_d2
  have hfac0 : 0 ≤ (Real.log u + 97) / 2 + Real.log Real.pi / 2 := by positivity
  have hθ1 : (u - t) * ((Real.log u + 97) / 2 + Real.log Real.pi / 2)
      ≤ 1 * ((Real.log u + 97) / 2 + Real.log Real.pi / 2) :=
    mul_le_mul_of_nonneg_right (by linarith) hfac0
  set d := Stage3.phaseTheta u - Stage3.phaseTheta t with hd
  have hdπ : d / Real.pi ≤ |d| := by
    rw [div_le_iff₀ Real.pi_pos]
    nlinarith [abs_nonneg d, le_abs_self d, Real.pi_gt_three]
  have e : riemannZeta.N u - riemannZeta.N t
      = (Stage3.argS u - Stage3.argS t) + d / Real.pi := by
    rw [hd]; unfold Stage3.argS; ring
  have hSu := abs_le.mp (ArgCount.sCrude_holds u (by linarith))
  have hSt := abs_le.mp (ArgCount.sCrude_holds t (by linarith))
  rw [e]
  linarith [hSu.1, hSu.2, hSt.1, hSt.2]

/-- **A zero of `G` on the line is a multiple zero of `ζ`.** Where the real factor is nonzero
and every zero of `ζ` at `1/2 + t i` is simple, `G = ζ + c ζ'` (`c ≠ 0`) is nonzero there. -/
theorem G_line_ne {c t : ℝ} (hc : c ≠ 0)
    (hfac : 1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0)
    (hs : riemannZeta (1/2 + t * I) = 0 → deriv riemannZeta (1/2 + t * I) ≠ 0) :
    riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I) ≠ 0 := by
  intro h0
  have hz : riemannZeta (1/2 + t * I) = 0 :=
    (LevinsonLine.zeta_line_zero_iff c t hfac).mpr (by rw [h0, mul_zero, Complex.zero_re])
  rw [hz, zero_add] at h0
  have hd := (mul_eq_zero.mp h0).resolve_left (by exact_mod_cast hc)
  exact hs hz hd

/-- The half-length times the log of a mean square, against a bound `K ≥ 1` on the mean. -/
theorem half_log_mean_le {F : ℝ → ℂ} {a b K : ℝ} (hab : a ≤ b) (hK1 : 1 ≤ K)
    (hm : (1 / (b - a)) * ∫ t in a..b, ‖F t‖ ^ 2 ≤ K) :
    (b - a) / 2 * Real.log ((1 / (b - a)) * ∫ t in a..b, ‖F t‖ ^ 2)
      ≤ (b - a) / 2 * Real.log K := by
  have hm0 : 0 ≤ (1 / (b - a)) * ∫ t in a..b, ‖F t‖ ^ 2 :=
    mul_nonneg (one_div_nonneg.mpr (by linarith))
      (intervalIntegral.integral_nonneg hab (fun t _ => by positivity))
  have hlog : Real.log ((1 / (b - a)) * ∫ t in a..b, ‖F t‖ ^ 2) ≤ Real.log K := by
    rcases hm0.lt_or_eq with h | h
    · exact Real.log_le_log h hm
    · rw [← h, Real.log_zero]; exact Real.log_nonneg hK1
  exact mul_le_mul_of_nonneg_left hlog (by linarith)

/-- `tailDelta` is nonnegative. -/
theorem tailDelta_nonneg {M : ℕ} {B X : ℝ} (hB : 0 ≤ B) :
    0 ≤ LevinsonMollEdge.tailDelta M B X := by
  unfold LevinsonMollEdge.tailDelta
  have hMB : 0 ≤ (M : ℝ) * B := mul_nonneg (Nat.cast_nonneg _) hB
  have h2 : 0 < (2 : ℝ) ^ X := by positivity
  have h3 : 0 ≤ (M : ℝ) * B / (2 : ℝ) ^ X := div_nonneg hMB h2.le
  have h4 : 0 ≤ 8 / (2 : ℝ) ^ X := by positivity
  have h5 : 0 ≤ 8 / (2 : ℝ) ^ X * (1 + M * B / (2 : ℝ) ^ X) := mul_nonneg h4 (by linarith)
  linarith

/-- The edge terms are nonnegative. -/
theorem windowE_nonneg {M : ℕ} {B X T a b : ℝ} (hM : 1 ≤ M) (hB : 1 ≤ B) (hX : 3 ≤ X)
    (hT : 1 ≤ T) (hab : a ≤ b) : 0 ≤ windowE M B X T a b := by
  unfold windowE
  have hM1 : (1 : ℝ) ≤ M := by exact_mod_cast hM
  have h1 : 0 ≤ Real.log T := Real.log_nonneg hT
  have h2 : 0 ≤ Real.log (M : ℝ) := Real.log_nonneg hM1
  have h3 : 0 ≤ Real.log B := Real.log_nonneg hB
  have htd := tailDelta_nonneg (M := M) (X := X) (by linarith : (0 : ℝ) ≤ B)
  have hπ := Real.pi_pos
  have hP : 0 ≤ Real.pi * ((8 * X - 1) * (Real.log T + Real.log M + Real.log B + 8) + 1) :=
    mul_nonneg hπ.le (by
      have := mul_nonneg (by linarith : (0 : ℝ) ≤ 8 * X - 1)
        (by linarith : (0 : ℝ) ≤ Real.log T + Real.log M + Real.log B + 8)
      linarith)
  have hA : 0 ≤ (b - a) * (2 * LevinsonMollEdge.tailDelta M B X) :=
    mul_nonneg (by linarith) (by linarith)
  have hC : 0 ≤ X * Real.pi := mul_nonneg (by linarith) hπ.le
  have hD : 0 ≤ X * (Real.pi * ((8 * X - 1) * (Real.log T + Real.log M + Real.log B + 8) + 1)) :=
    mul_nonneg (by linarith) hP
  linarith

set_option maxHeartbeats 400000 in
/-- **S11, the assembled window theorem.** For `T ≥ e^26`, `c = 1/log T`, the mollifier
`ψ = molli M β` with `β 1 = 1`, `‖β h‖ ≤ B`, `σ₀ < 1/2` with a margin `δ > 0`,
`1/4 ≤ σ₀ − δ`, `X ≥ 3` with `32 M B ≤ 2^X`, `2X ≤ a`, and a window `a + 3 ≤ b ≤ T`: if the
mean square of `G ψ` over every subwindow of `[a, b]`, on every line `σ ∈ [σ₀ − δ, σ₀]`, is at
most `K ≥ 1`, and every zero of `ζ` on the segment `1/2 + [a, b] i` is simple, then the zeros
of `ζ` on the line up to height `b`, with order, number at least
`(N b − N a) − (1/(π(1/2 − σ₀))) · ((b − a)/2 · log K + windowE) − (134 log T + 2918)`. -/
theorem levinson_window {T c σ₀ δ X a b K B : ℝ} {M : ℕ} {β : ℕ → ℂ}
    (hT : Real.exp 26 ≤ T) (hc : c = 1 / Real.log T)
    (hM : 1 ≤ M) (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B)
    (hσ₀ : σ₀ < 1 / 2) (hδ : 0 < δ) (hσδ : 1 / 4 ≤ σ₀ - δ)
    (hX : 3 ≤ X) (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hXa : 2 * X ≤ a)
    (hab : a + 3 ≤ b) (hbT : b ≤ T) (hK1 : 1 ≤ K)
    (hK : ∀ a' b' : ℝ, a ≤ a' → a' < b' → b' ≤ b → ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b',
        ‖(riemannZeta (↑σ + ↑t * I) + c * deriv riemannZeta (↑σ + ↑t * I))
          * LevinsonMollEdge.molli M β (↑σ + ↑t * I)‖ ^ 2 ≤ K)
    (hsimple : ∀ t ∈ Icc a b,
      riemannZeta (1/2 + t * I) = 0 → deriv riemannZeta (1/2 + t * I) ≠ 0) :
    (riemannZeta.N b - riemannZeta.N a)
      - (1 / (Real.pi * (1 / 2 - σ₀))) * ((b - a) / 2 * Real.log K + windowE M B X T a b)
      - (134 * Real.log T + 2918) ≤ (lineCount b : ℝ) := by
  -- the constants
  have hL26 : (26 : ℝ) ≤ Real.log T := by
    have h := Real.log_le_log (Real.exp_pos 26) hT
    rwa [Real.log_exp] at h
  have hLpos : 0 < Real.log T := by linarith
  have hc0 : 0 ≤ c := by rw [hc]; positivity
  have hc1 : c ≤ 1 := by rw [hc, div_le_one hLpos]; linarith
  have hcne : c ≠ 0 := by rw [hc]; exact (one_div_pos.mpr hLpos).ne'
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
  obtain ⟨a', ha', hgA⟩ := LevinsonAvoid.exists_good_height
    (f := fun s => (riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s)
    (σ₀ := σ₀ - δ) (X := X) (t₀ := a)
    (analyticOnNhd_rect_of_im hFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + (a : ℝ) * I, LevinsonAvoid.mem_rect_of
      (by simp) (by simp), hneX a⟩
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
  have hmean := half_log_mean_le ha'b'.le hK1 (hK a' b' ha'1 ha'b' hb'2 σ' hσ')
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
  -- step 4: `G ≠ 0` on the border of `[1/2, 3] × [a', b']`
  have hfac : ∀ t ∈ Icc a' b',
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0 := by
    intro t ht
    rw [hc]
    exact (LevinsonAvoid.factor_pos hT ⟨by linarith [ht.1], by linarith [ht.2]⟩).ne'
  have hBC : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a' * I) ((3 : ℂ) + b' * I),
      riemannZeta p + c * deriv riemannZeta p ≠ 0 := by
    intro p hp
    have e1 : ((1/2 : ℂ) + a' * I).re = 1 / 2 := by simp
    have e2 : ((1/2 : ℂ) + a' * I).im = a' := by simp
    have e3 : ((3 : ℂ) + b' * I).re = 3 := by simp
    have e4 : ((3 : ℂ) + b' * I).im = b' := by simp
    have hcases := border_cases (by rw [e1, e3]; norm_num) (by rw [e2, e4]; linarith) hp
    rw [e1, e2, e3, e4] at hcases
    have hp' : p = ↑p.re + ↑p.im * I := (Complex.re_add_im p).symm
    rcases hcases with ⟨him, hre⟩ | ⟨hre, him⟩ | ⟨him, hre⟩ | ⟨hre, him⟩
    · rw [hp', him]
      exact left_ne_zero_of_mul (hgA p.re ⟨by linarith [hre.1], by linarith [hre.2]⟩)
    · rw [hp', hre]
      push_cast
      exact G_line_ne hcne (hfac p.im him)
        (hsimple p.im ⟨by linarith [him.1], by linarith [him.2]⟩)
    · rw [hp', him]
      exact left_ne_zero_of_mul (hgB p.re ⟨by linarith [hre.1], by linarith [hre.2]⟩)
    · rw [hp', hre]
      push_cast
      intro h
      have := LevinsonSize.re_G_pos hc0 hc1 p.im
      rw [h, Complex.zero_re] at this
      exact lt_irrefl _ this
  have hLC := LevinsonCount.levinson_count hc0 hc1 (by linarith : (4 : ℝ) ≤ a') ha'b' hBC hfac
  -- step 5: the line count and `N` at the shifted heights
  have hLb : (lineCount b' : ℝ) ≤ (lineCount b : ℝ) := by
    exact_mod_cast lineCount_mono hb'2
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
  linarith [hLC, hLb, hNb, hNa, hNb', hNa', hlb, hla1, hlb', h3X, hCX']

/-- info: 'LevinsonWindow.countRight_right_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms countRight_right_le

/-- info: 'LevinsonWindow.lineCount_mono' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lineCount_mono

/-- info: 'LevinsonWindow.N_step_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms N_step_le

/-- info: 'LevinsonWindow.G_line_ne' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms G_line_ne

/-- info: 'LevinsonWindow.levinson_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_window

end LevinsonWindow
