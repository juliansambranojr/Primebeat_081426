/-
# FloorQWindow — block S13 of `lean_stage3/design/stencil.md`, B4 step 5, the assembly: the window for a general `Q`. 2026-11-25.

Pins: `PINS.md` § Current, "B4 step 5, the assembly".

`conrey_window_diff` is `LevinsonWindowNear.levinson_window_diff` with `G = ζ + cζ′` replaced by
any `G` analytic on `Im > 0` (to be `V = W/Gammaℝ`), and with every fact the proof used about
`G` turned into a hypothesis at the place it is used:

* the count on `[1/2, 3] × [a′, b′]` (`hcount`; for `V` it is
  `DigammaBound.conrey_count_window'`, with error `Ec = 72 log T + 42 log(3A) + 154`);
* the right edge: `‖G ψ − 1‖ ≤ δ_R ≤ 1/2` on `X + [a, b] i` (`hR`; for `V`, `δ_R = O(1/L) +
  tailDelta`, `FloorQStep`);
* the growth on the discs of radius `X − 1/8` about `X + y i`, `y ∈ [a, b]` (`hMf`).

The edge terms of the window are then
`windowEQ δ_R Mf X a b = (b − a)·2δ_R + Xπ + 2Xπ((8X − 1) log(2 Mf) + 1)`, and the conclusion
is the one of `levinson_window_diff` with `134 log T + 2918` replaced by
`Ec + 62 log T + 2500` (the two Riemann–von Mangoldt steps `LevinsonWindow.N_step_le`).
The proof is a copy, with `FloorQEdge.right_terms_gen` and `FloorQEdge.horizontal_terms_gen`
for the two `LevinsonMollEdge` bounds.

| name | content | status |
|---|---|---|
| `windowEQ` | the edge terms | defined |
| `rect_upper` | analytic on `Im > 0` ⊢ analytic near a rectangle above the axis | proved |
| `conrey_window_diff` | the window, difference form, generic `G` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorQEdge
import Stage3.LevinsonWindowNear

namespace FloorQ

open Complex MeasureTheory Set Filter Topology Littlewood LineCount LevinsonWindow
open scoped Interval

/-- The edge terms of the window for `G ψ`. -/
noncomputable
def windowEQ (δR Mf X a b : ℝ) : ℝ :=
  (b - a) * (2 * δR) + X * Real.pi
    + 2 * (X * (Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1)))

/-- Analytic on `Im > 0`, a function is analytic near any rectangle above the real axis. -/
theorem rect_upper {f : ℂ → ℂ} (hf : ∀ w : ℂ, 0 < w.im → AnalyticAt ℂ f w)
    {z w : ℂ} (hz : 0 < z.im) (hw : 0 < w.im) : AnalyticOnNhd ℂ f (Rectangle z w) := by
  intro p hp
  apply hf
  rw [Rectangle] at hp
  have h2 := (mem_reProdIm.mp hp).2
  rcases mem_uIcc.mp h2 with h | h <;> linarith [h.1, h.2]

set_option maxHeartbeats 800000 in
/-- **The window for a general `G`, difference form.** For `G` analytic on `Im > 0`, `ψ` entire,
`σ₀ < 1/2` with a margin `δ > 0`, `1/4 ≤ σ₀ − δ`, `X ≥ 3`, `2X ≤ a`, `a + 3 ≤ b ≤ T`,
`1 ≤ K`, the right edge `‖G ψ − 1‖ ≤ δ_R ≤ 1/2` on `X + [a, b] i`, the growth `‖G ψ‖ ≤ Mf` on the
discs of radius `X − 1/8` about `X + y i`, `y ∈ [a, b]`, the count `hcount` at the good heights
and the mean `hK` there: the zeros of `ζ` on the line with height in `(a, b]` number at least
`(N b − N a) − (1/(π(1/2 − σ₀)))((b − a)/2 · log K + windowEQ) − (Ec + 62 log T + 2500)`. -/
theorem conrey_window_diff {G ψ : ℂ → ℂ} {T σ₀ δ X a b K δR Mf Ec : ℝ}
    (hGa : ∀ w : ℂ, 0 < w.im → AnalyticAt ℂ G w) (hψ : Differentiable ℂ ψ)
    (hσ₀ : σ₀ < 1 / 2) (hδ : 0 < δ) (hσδ : 1 / 4 ≤ σ₀ - δ)
    (hX : 3 ≤ X) (hXa : 2 * X ≤ a) (hab : a + 3 ≤ b) (hbT : b ≤ T) (hK1 : 1 ≤ K)
    (hδR : δR ≤ 1 / 2)
    (hR : ∀ t ∈ Icc a b, ‖G (↑X + ↑t * I) * ψ (↑X + ↑t * I) - 1‖ ≤ δR)
    (hMf : ∀ y ∈ Icc a b, ∀ w : ℂ, ‖w - (↑X + ↑y * I)‖ ≤ X - 1 / 8 → ‖G w * ψ w‖ ≤ Mf)
    (hcount : ∀ a' b' : ℝ, a ≤ a' → a' ≤ a + 1 → b - 1 ≤ b' → b' ≤ b → a' < b' →
      (∀ x ∈ Icc (1/2 : ℝ) 3, G (↑x + ↑a' * I) ≠ 0) →
      (∀ x ∈ Icc (1/2 : ℝ) 3, G (↑x + ↑b' * I) ≠ 0) →
      riemannZeta (1/2 + a' * I) ≠ 0 →
      (riemannZeta.N b' - riemannZeta.N a')
        - 2 * Littlewood.countRight G ((1/2 : ℂ) + a' * I) ((3 : ℂ) + b' * I) (1/2)
        - Ec ≤ (lineCount b' : ℝ) - (lineCount a' : ℝ))
    (hK : ∀ a' b' : ℝ, a ≤ a' → a' ≤ a + 1 → b - 1 ≤ b' → b' ≤ b → a' < b' →
      ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b', ‖G (↑σ + ↑t * I) * ψ (↑σ + ↑t * I)‖ ^ 2 ≤ K) :
    (riemannZeta.N b - riemannZeta.N a)
      - (1 / (Real.pi * (1 / 2 - σ₀))) * ((b - a) / 2 * Real.log K + windowEQ δR Mf X a b)
      - (Ec + 62 * Real.log T + 2500) ≤ (lineCount b : ℝ) - (lineCount a : ℝ) := by
  have ha4 : 4 ≤ a := by linarith
  have hT1 : 1 ≤ T := by linarith
  set F : ℂ → ℂ := fun s => G s * ψ s with hF
  have hFa : ∀ w : ℂ, 0 < w.im → AnalyticAt ℂ F w :=
    fun w hw => (hGa w hw).mul (hψ.analyticAt w)
  -- `G ψ` on `Re = X`
  have hreX : ∀ t ∈ Icc a b, 1 / 2 ≤ (F (↑X + ↑t * I)).re := by
    intro t ht
    have h1 := hR t ht
    have h2 := Complex.abs_re_le_norm (F (↑X + ↑t * I) - 1)
    rw [Complex.sub_re, Complex.one_re, abs_le] at h2
    have : ‖F (↑X + ↑t * I) - 1‖ ≤ δR := h1
    linarith [h2.1]
  have hneX : ∀ t ∈ Icc a b, F (↑X + ↑t * I) ≠ 0 := by
    intro t ht h
    have := hreX t ht
    rw [h, Complex.zero_re] at this
    linarith
  have hab' : a ≤ b := by linarith
  have hMf2 : 1 / 2 ≤ Mf := by
    have h1 := hMf a ⟨le_rfl, hab'⟩ (↑X + ↑a * I) (by rw [sub_self, norm_zero]; linarith)
    have h2 := Complex.re_le_norm (F (↑X + ↑a * I))
    have h3 := hreX a ⟨le_rfl, hab'⟩
    have : ‖F (↑X + ↑a * I)‖ ≤ Mf := h1
    linarith
  -- step 1: good heights
  have hζX : ∀ t : ℝ, riemannZeta (↑X + ↑t * I) ≠ 0 := fun t =>
    riemannZeta_ne_zero_of_one_lt_re (by simp; linarith)
  have hZFa : ∀ w : ℂ, 0 < w.im → AnalyticAt ℂ (fun s => riemannZeta s * F s) w := by
    intro w hw
    have hw1 : w ≠ 1 := fun h => by rw [h, Complex.one_im] at hw; exact lt_irrefl _ hw
    exact (analyticOn_riemannZeta w hw1).mul (hFa w hw)
  obtain ⟨a', ha', hgZA⟩ := LevinsonAvoid.exists_good_height
    (f := fun s => riemannZeta s * F s) (σ₀ := σ₀ - δ) (X := X) (t₀ := a)
    (rect_upper hZFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + (a : ℝ) * I, LevinsonAvoid.mem_rect_of (by simp) (by simp),
      mul_ne_zero (hζX a) (hneX a ⟨le_rfl, hab'⟩)⟩
  have hgA : ∀ x ∈ Icc (σ₀ - δ) X, F ((x : ℂ) + a' * I) ≠ 0 :=
    fun x hx => right_ne_zero_of_mul (hgZA x hx)
  have hζa' : riemannZeta (1 / 2 + a' * I) ≠ 0 := by
    have h := left_ne_zero_of_mul (hgZA (1 / 2) ⟨by linarith, by linarith⟩)
    push_cast at h
    exact h
  obtain ⟨b', hb', hgB⟩ := LevinsonAvoid.exists_good_height
    (f := F) (σ₀ := σ₀ - δ) (X := X) (t₀ := b - 1)
    (rect_upper hFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + ((b - 1 : ℝ) : ℂ) * I, LevinsonAvoid.mem_rect_of (by simp) (by simp),
      hneX (b - 1) ⟨by linarith, by linarith⟩⟩
  have hb'1 : b - 1 ≤ b' := hb'.1
  have hb'2 : b' ≤ b := by linarith [hb'.2]
  have ha'1 : a ≤ a' := ha'.1
  have ha'2 : a' ≤ a + 1 := ha'.2
  have ha'b' : a' < b' := by linarith
  -- step 2: a good abscissa
  obtain ⟨σ', hσ', hgL⟩ := LevinsonAvoid.exists_good_abscissa
    (f := F) (σ₀ := σ₀) (δ := δ) (X := X) (a := a') (b := b') hδ (by linarith)
    (rect_upper hFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + (a' : ℝ) * I, LevinsonAvoid.mem_rect_of (by simp) (by simp),
      hneX a' ⟨ha'1, by linarith⟩⟩
  have hσ'1 : σ₀ - δ ≤ σ' := hσ'.1
  have hσ'2 : σ' ≤ σ₀ := hσ'.2
  -- step 3: `G ψ ≠ 0` on the border of `[σ', X] × [a', b']`
  have hBR : ∀ p ∈ RectangleBorder ((σ' : ℂ) + a' * I) ((X : ℂ) + b' * I), G p * ψ p ≠ 0 := by
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
    · rw [hp', hre]; exact hneX p.im ⟨by linarith [him.1], by linarith [him.2]⟩
  have hGR : AnalyticOnNhd ℂ G (Rectangle ((σ' : ℂ) + a' * I) ((X : ℂ) + b' * I)) :=
    rect_upper hGa (by simp; linarith) (by simp; linarith)
  have hψR : AnalyticOnNhd ℂ ψ (Rectangle ((σ' : ℂ) + a' * I) ((X : ℂ) + b' * I)) :=
    fun p _ => hψ.analyticAt p
  have hLR := LevinsonRight.levinson_right (G := G) (M := ψ) (σ₀ := σ') (X := X) (a := a')
    (b := b') (by linarith) (by linarith) ha'b' hGR hψR hBR
  -- the edge terms
  have hRT : -(∫ t in a'..b', Real.log ‖G (↑X + ↑t * I) * ψ (↑X + ↑t * I)‖)
      + (X - σ') * (∫ t in a'..b', logDeriv (fun s => G s * ψ s) (↑X + ↑t * I)).re
      ≤ (b' - a') * (2 * δR) + (X - σ') * Real.pi :=
    right_terms_gen (f := F) ha'b'.le (by linarith)
      (fun t ht => hFa _ (by simp; linarith [ht.1]))
      (fun t ht => hR t ⟨by linarith [ht.1], by linarith [ht.2]⟩) hδR
  have hHa := abs_le.mp (horizontal_terms_gen (f := F) (σ₀ := σ') (T := a') (Mf := Mf)
    (by linarith) (by linarith) hFa (hreX a' ⟨ha'1, by linarith⟩)
    (hMf a' ⟨ha'1, by linarith⟩) (by linarith) (by linarith)
    (fun x hx => hgA x ⟨by linarith [hx.1], hx.2⟩))
  have hHb := abs_le.mp (horizontal_terms_gen (f := F) (σ₀ := σ') (T := b') (Mf := Mf)
    (by linarith) (by linarith) hFa (hreX b' ⟨by linarith, hb'2⟩)
    (hMf b' ⟨by linarith, hb'2⟩) (by linarith) (by linarith)
    (fun x hx => hgB x ⟨by linarith [hx.1], hx.2⟩))
  have hmean := half_log_mean_le (F := fun t : ℝ => G (↑σ' + ↑t * I) * ψ (↑σ' + ↑t * I))
    ha'b'.le hK1 (hK a' b' ha'1 ha'2 hb'1 hb'2 ha'b' σ' hσ')
  -- the size comparisons
  have hπ := Real.pi_pos
  have hlK : 0 ≤ Real.log K := Real.log_nonneg hK1
  have hlMf : 0 ≤ Real.log (2 * Mf) := Real.log_nonneg (by linarith)
  have hPin : 0 ≤ Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1) :=
    mul_nonneg hπ.le (by nlinarith)
  have hPa : (X - σ') * (Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1))
      ≤ X * (Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1)) :=
    mul_le_mul_of_nonneg_right (by linarith) hPin
  have hlen : (b' - a') / 2 * Real.log K ≤ (b - a) / 2 * Real.log K :=
    mul_le_mul_of_nonneg_right (by linarith) hlK
  have hδR0 : 0 ≤ δR := le_trans (norm_nonneg _) (hR a ⟨le_rfl, hab'⟩)
  have hlen2 : (b' - a') * (2 * δR) ≤ (b - a) * (2 * δR) :=
    mul_le_mul_of_nonneg_right (by linarith) (by linarith)
  have hσπ : 0 ≤ σ' * Real.pi := mul_nonneg (by linarith) hπ.le
  set U := (b - a) / 2 * Real.log K + windowEQ δR Mf X a b with hU
  have hU0 : 0 ≤ U := by
    rw [hU]; unfold windowEQ
    have h1 : 0 ≤ (b - a) / 2 * Real.log K := mul_nonneg (by linarith) hlK
    have h2 : 0 ≤ (b - a) * (2 * δR) := mul_nonneg (by linarith) (by linarith)
    have h3 : 0 ≤ X * Real.pi := mul_nonneg (by linarith) hπ.le
    have h4 : 0 ≤ X * (Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1)) :=
      mul_nonneg (by linarith) hPin
    linarith
  have hf'pos : 0 < 1 / (2 * Real.pi * (1 / 2 - σ')) := by
    have : 0 < 1 / 2 - σ' := by linarith
    positivity
  have hCX : countRight G ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I) (1 / 2)
        ≤ 1 / (2 * Real.pi * (1 / 2 - σ')) * U := by
    refine le_trans hLR (mul_le_mul_of_nonneg_left ?_ hf'pos.le)
    rw [hU]
    unfold windowEQ
    linarith [hRT, hHa.1, hHa.2, hHb.1, hHb.2, hmean, hPa, hlen, hlen2, hσπ]
  have hff : 1 / (2 * Real.pi * (1 / 2 - σ')) ≤ 1 / (2 * Real.pi * (1 / 2 - σ₀)) := by
    have h0 : 0 < 2 * Real.pi * (1 / 2 - σ₀) := by
      have : 0 < 1 / 2 - σ₀ := by linarith
      positivity
    exact one_div_le_one_div_of_le h0
      (mul_le_mul_of_nonneg_left (by linarith) (by positivity))
  have hCX' : countRight G ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I) (1 / 2)
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
  have hGX : AnalyticOnNhd ℂ G (Rectangle ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I)) :=
    rect_upper hGa (by simp; linarith) (by simp; linarith)
  have hGz : G ((1 / 2 : ℂ) + a' * I) ≠ 0 := by
    have h := hgA (1 / 2) ⟨by linarith, by linarith⟩
    push_cast at h
    exact left_ne_zero_of_mul h
  have h3X := countRight_right_le (σ := 1 / 2) hsub hGX hGz
  -- step 4: the count on `[1/2, 3] × [a', b']`
  have hLC := hcount a' b' ha'1 ha'2 hb'1 hb'2 ha'b'
    (fun x hx => left_ne_zero_of_mul (hgA x ⟨by linarith [hx.1], by linarith [hx.2]⟩))
    (fun x hx => left_ne_zero_of_mul (hgB x ⟨by linarith [hx.1], by linarith [hx.2]⟩))
    hζa'
  -- the line count and `N` at the shifted heights
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
  -- the factor
  have e2 : 1 / (Real.pi * (1 / 2 - σ₀)) * U = 2 * (1 / (2 * Real.pi * (1 / 2 - σ₀)) * U) := by
    have h1 : (1 / 2 - σ₀) ≠ 0 := by linarith
    have h2 : Real.pi ≠ 0 := hπ.ne'
    field_simp
    try ring
  rw [e2]
  linarith [hLC, hLb, hLa, hNb, hNa, hNb', hNa', hlb, hla1, h3X, hCX']

/-- info: 'FloorQ.rect_upper' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rect_upper

/-- info: 'FloorQ.conrey_window_diff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms conrey_window_diff

end FloorQ
