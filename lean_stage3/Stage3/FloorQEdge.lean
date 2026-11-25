/-
# FloorQEdge — block S13 of `lean_stage3/design/stencil.md`, B4 step 5, the assembly: the edge terms of Littlewood's lemma for a function given on the upper half-plane. 2026-11-25.

Pins: `PINS.md` § Current, "B4 step 5, the assembly".

`LevinsonMollEdge`'s right-edge and horizontal-edge bounds are stated for `G = ζ + cζ′`, and its
generic pieces ask analyticity on all of `ℂ \ {1}` and positivity on the whole line `Re s = X`.
`V = W/Gammaℝ` is analytic on `Im > 0` (`FloorQGamma.analyticAt_V_im`), and its size far right
is known on the window's heights only. Here the generic pieces are restated with the
hypotheses where the proofs use them: the right edge on `X + [a, b] i` with `‖f − 1‖ ≤ δ ≤ 1/2`
as a hypothesis, the horizontal edge with analyticity on `Im > 0` and the growth bound `Mf` as
hypotheses. Each proof is a copy of the `LevinsonMollEdge` one.

| name | content | status |
|---|---|---|
| `arg_term_le_on` | `arg_term_le_of_pos` on `[a, b]` | proved |
| `right_terms_gen` | `right_terms_le` from `‖f − 1‖ ≤ δ ≤ 1/2` on `X + [a, b] i` | proved |
| `edge_le_upper` | `edge_le_gen` with analyticity on `Im > 0` | proved |
| `horizontal_terms_gen` | `horizontal_terms_le` from the growth `Mf` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.LevinsonMollEdge

namespace FloorQ

open Complex MeasureTheory Set Littlewood LevinsonMollEdge
open scoped Interval

/-- **The argument term on `[a, b]`.** `LevinsonMollEdge.arg_term_le_of_pos` with analyticity
and `Re f > 0` asked on `X + [a, b] i` only. -/
theorem arg_term_le_on {f : ℂ → ℂ} {X a b : ℝ} (hab : a ≤ b)
    (hfa : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ f (↑X + ↑t * I))
    (hpos : ∀ t ∈ Set.Icc a b, 0 < (f (↑X + ↑t * I)).re) :
    |(∫ t in a..b, logDeriv f (↑X + ↑t * I)).re| ≤ Real.pi := by
  have hne : ∀ t ∈ Set.Icc a b, f (↑X + ↑t * I) ≠ 0 := by
    intro t ht h
    have := hpos t ht
    rw [h, Complex.zero_re] at this
    exact lt_irrefl _ this
  have hline : Continuous (fun t : ℝ => ((X : ℂ) + t * I)) := by fun_prop
  have hFcont : ∀ t ∈ Set.Icc a b, ContinuousAt (fun t : ℝ => f (↑X + ↑t * I)) t := fun t ht =>
    ContinuousAt.comp (g := f) (f := fun t : ℝ => ((X : ℂ) + t * I))
      (hfa t ht).continuousAt hline.continuousAt
  have hFc : ContinuousOn (fun t : ℝ => f (↑X + ↑t * I)) (Set.Icc a b) :=
    fun t ht => (hFcont t ht).continuousWithinAt
  have hF'c : ContinuousOn (fun t : ℝ => deriv f (↑X + ↑t * I) * I) (Set.Icc a b) := by
    intro t ht
    exact ((ContinuousAt.comp (g := deriv f) (f := fun t : ℝ => ((X : ℂ) + t * I))
      (hfa t ht).deriv.continuousAt hline.continuousAt).mul
        continuousAt_const).continuousWithinAt
  have hslit : ∀ t ∈ Set.Icc a b, f (↑X + ↑t * I) ∈ Complex.slitPlane := fun t ht =>
    Complex.mem_slitPlane_iff.mpr (Or.inl (hpos t ht))
  have hφc : ContinuousOn (fun t : ℝ => Complex.arg (f (↑X + ↑t * I))) (Set.Icc a b) := by
    intro t ht
    exact (ContinuousAt.comp (g := Complex.arg) (f := fun t : ℝ => f (↑X + ↑t * I))
      (Complex.continuousAt_arg (hslit t ht)) (hFcont t ht)).continuousWithinAt
  have hφ : ∀ t ∈ Set.Icc a b, f (↑X + ↑t * I) =
      ‖f (↑X + ↑t * I)‖ * Complex.exp ((Complex.arg (f (↑X + ↑t * I)) : ℂ) * Complex.I) :=
    fun t _ => (Complex.norm_mul_exp_arg_mul_I _).symm
  have h := LevinsonTurn.lift_turn_eq_integral (F := fun t : ℝ => f (↑X + ↑t * I))
    (F' := fun t : ℝ => deriv f (↑X + ↑t * I) * I)
    (φ := fun t : ℝ => Complex.arg (f (↑X + ↑t * I))) hab hFc
    (fun t ht => hasDerivAt_line_comp (hfa t (Set.Ioo_subset_Icc_self ht)).differentiableAt)
    hF'c hne hφc hφ
  have heq : (∫ t in a..b, deriv f (↑X + ↑t * I) * I / f (↑X + ↑t * I)) =
      ∫ t in a..b, logDeriv f (↑X + ↑t * I) * I := by
    refine intervalIntegral.integral_congr (fun t _ => ?_)
    simp only [logDeriv_apply]
    ring
  rw [heq, intervalIntegral.integral_mul_const, Complex.mul_I_im] at h
  rw [← h]
  have hb := Complex.abs_arg_lt_pi_div_two_iff.mpr (Or.inl (hpos b ⟨hab, le_rfl⟩))
  have ha := Complex.abs_arg_lt_pi_div_two_iff.mpr (Or.inl (hpos a ⟨le_rfl, hab⟩))
  rw [abs_lt] at ha hb
  rw [abs_le]
  constructor <;> linarith [ha.1, ha.2, hb.1, hb.2]

/-- **The two right-edge terms, from `‖f − 1‖ ≤ δ ≤ 1/2` on `X + [a, b] i`.** -/
theorem right_terms_gen {f : ℂ → ℂ} {X σ₀ a b δ : ℝ} (hab : a ≤ b) (hσX : σ₀ ≤ X)
    (hfa : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ f (↑X + ↑t * I))
    (hf1 : ∀ t ∈ Set.Icc a b, ‖f (↑X + ↑t * I) - 1‖ ≤ δ) (hδ : δ ≤ 1 / 2) :
    -(∫ t in a..b, Real.log ‖f (↑X + ↑t * I)‖)
      + (X - σ₀) * (∫ t in a..b, logDeriv f (↑X + ↑t * I)).re
      ≤ (b - a) * (2 * δ) + (X - σ₀) * Real.pi := by
  have hpt : ∀ t ∈ Ι a b, ‖Real.log ‖f (↑X + ↑t * I)‖‖ ≤ 2 * δ := by
    intro t ht
    rw [Set.uIoc_of_le hab] at ht
    rw [Real.norm_eq_abs]
    exact log_norm_abs_le (hf1 t ⟨ht.1.le, ht.2⟩) hδ
  have h := intervalIntegral.norm_integral_le_of_norm_le_const (a := a) (b := b) hpt
  rw [Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.mpr hab)] at h
  have h2 := neg_le_abs (∫ t in a..b, Real.log ‖f (↑X + ↑t * I)‖)
  have hpos : ∀ t ∈ Set.Icc a b, 0 < (f (↑X + ↑t * I)).re := by
    intro t ht
    have h1 := hf1 t ht
    have h3 := Complex.abs_re_le_norm (f (↑X + ↑t * I) - 1)
    rw [Complex.sub_re, Complex.one_re, abs_le] at h3
    linarith [h3.1]
  have h4 := arg_term_le_on hab hfa hpos
  have h5 := mul_le_mul_of_nonneg_left (le_trans (le_abs_self _) h4) (sub_nonneg.mpr hσX)
  linarith


/-- **The edge, analyticity above the real axis only.** `LevinsonMollEdge.edge_le_gen` with `hFa` asked on `Im > 0`; the proof is a copy. For `1 ≤ X`, `2X ≤ T`, `F` analytic off
`1`, `Re F(X + iT) ≥ 1/2`, `‖F‖ ≤ Mf` on `‖w − (X + iT)‖ ≤ X − 1/8`, `1/4 ≤ σ ≤ X` and
`F ≠ 0` on `[σ, X] + iT`: `|edgeH F X T σ| ≤ π ((8X − 1) log (2 Mf) + 1)`. -/
theorem edge_le_upper {F : ℂ → ℂ} {X T Mf σ : ℝ} (hX : 1 ≤ X) (hXT : 2 * X ≤ T)
    (hFa : ∀ w : ℂ, 0 < w.im → AnalyticAt ℂ F w)
    (h0 : 1 / 2 ≤ (F (↑X + ↑T * I)).re)
    (hM : ∀ w : ℂ, ‖w - (↑X + ↑T * I)‖ ≤ X - 1 / 8 → ‖F w‖ ≤ Mf)
    (hσ : 1 / 4 ≤ σ) (hσX : σ ≤ X)
    (hne : ∀ x ∈ Set.Icc σ X, F (↑x + ↑T * I) ≠ 0) :
    |edgeH F X T σ| ≤ Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1) := by
  have hX0 : X ≠ 0 := by intro h; rw [h] at hX; norm_num at hX
  have hXpos : 0 < X := by linarith
  have h8 : 8 * X - 1 ≠ 0 := by intro h; linarith
  set r : ℝ := (4 * X - 1) / (4 * X) with hr
  set R : ℝ := (8 * X - 1) / (8 * X) with hR
  have hr0 : 0 < r := by rw [hr]; apply div_pos <;> linarith
  have hrR : r < R := by
    rw [hr, hR, div_lt_div_iff₀ (by linarith) (by linarith)]; nlinarith
  have hR1 : R < 1 := by rw [hR, div_lt_one (by linarith)]; linarith
  -- the scaled map `z ↦ X + iT + X z`
  have hd : DifferentiableOn ℂ (fun z : ℂ => F (↑X + ↑T * I + ↑X * z))
      (Metric.ball (0 : ℂ) (11 / 10)) := by
    intro z hz
    rw [Metric.mem_ball, dist_zero_right] at hz
    have hw : 0 < (↑X + ↑T * I + ↑X * z : ℂ).im := by
      have him : (↑X + ↑T * I + ↑X * z : ℂ).im = T + X * z.im := by simp
      rw [him]
      have hzi := abs_le.mp (le_trans (Complex.abs_im_le_norm z) hz.le)
      have := mul_le_mul_of_nonneg_left hzi.1 hXpos.le
      linarith
    have hf : DifferentiableAt ℂ (fun z : ℂ => ↑X + ↑T * I + ↑X * z) z := by fun_prop
    exact (DifferentiableAt.comp (g := F) (f := fun z : ℂ => ↑X + ↑T * I + ↑X * z) z
      (hFa _ hw).differentiableAt hf).differentiableWithinAt
  have hg0 : 1 / 2 ≤ ((fun z : ℂ => F (↑X + ↑T * I + ↑X * z)) 0).re := by
    show 1 / 2 ≤ (F (↑X + ↑T * I + ↑X * 0)).re
    rw [mul_zero, add_zero]
    exact h0
  have hgM : ∀ z : ℂ, ‖z‖ ≤ R → ‖(fun z : ℂ => F (↑X + ↑T * I + ↑X * z)) z‖ ≤ Mf := by
    intro z hz
    refine hM _ ?_
    rw [show (↑X + ↑T * I + ↑X * z : ℂ) - (↑X + ↑T * I) = ↑X * z by ring, norm_mul,
      Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hXpos.le]
    have hXR : X * R = X - 1 / 8 := by
      rw [hR]
      field_simp
      try ring
    have := mul_le_mul_of_nonneg_left hz hXpos.le
    linarith
  obtain ⟨Z', hZ'mem, hZ'card⟩ := real_zero_count_gen hr0 hrR hR1 hd (by norm_num) hg0 hgM
  have hdiv : Mf / (1 / 2 : ℝ) = 2 * Mf := by ring
  rw [hdiv] at hZ'card
  -- the zeros of `Re F(x + iT)` on `(σ, X)`
  have hZ : ∀ x ∈ Set.Ioo σ X, ((fun y : ℝ => F (↑y + ↑T * I)) x).re = 0 →
      x ∈ Z'.image (fun y : ℝ => X * y + X) := by
    intro x hx hx0
    have hy : X * ((x - X) / X) = x - X := by
      field_simp
      try ring
    refine Finset.mem_image.mpr ⟨(x - X) / X, hZ'mem _ ?_ ?_, by linarith⟩
    · rw [abs_le]
      have e1 : (x - X) / X + r = (x - 1 / 4) / X := by
        rw [hr]
        field_simp
        try ring
      have e2 : 0 ≤ (x - 1 / 4) / X := div_nonneg (by linarith [hx.1]) hXpos.le
      have e3 : (x - X) / X ≤ 0 := div_nonpos_of_nonpos_of_nonneg (by linarith [hx.2]) hXpos.le
      constructor <;> linarith
    · show (F (↑X + ↑T * I + ↑X * (((x - X) / X : ℝ) : ℂ))).re = 0
      have hc : (↑X + ↑T * I + ↑X * (((x - X) / X : ℝ) : ℂ) : ℂ) = (x : ℂ) + (T : ℂ) * I := by
        rw [← Complex.ofReal_mul, hy]
        push_cast
        ring
      rw [hc]
      exact hx0
  have hcard : ((Z'.image (fun y : ℝ => X * y + X)).card : ℝ) ≤ (Z'.card : ℝ) := by
    exact_mod_cast Finset.card_image_le
  -- `1 / log (R/r) ≤ 8X − 1`
  have hrRq0 : r / R = (8 * X - 2) / (8 * X - 1) := by
    rw [hr, hR, div_div_div_eq,
      div_eq_div_iff (mul_pos (by linarith) (by linarith)).ne' h8]
    ring
  have hrRq : r / R = 1 - 1 / (8 * X - 1) := by
    rw [hrRq0, eq_sub_iff_add_eq, ← add_div, div_eq_one_iff_eq h8]
    ring
  have hlogrR : Real.log (r / R) ≤ r / R - 1 :=
    Real.log_le_sub_one_of_pos (div_pos hr0 (by linarith))
  have hL : 1 / (8 * X - 1) ≤ Real.log (R / r) := by
    rw [show R / r = (r / R)⁻¹ from (inv_div r R).symm, Real.log_inv]
    linarith
  have hLpos : 0 < Real.log (R / r) := lt_of_lt_of_le (by
    apply div_pos one_pos; linarith) hL
  have hinv : 1 / Real.log (R / r) ≤ 8 * X - 1 := by
    rw [div_le_iff₀ hLpos]
    have e : (8 * X - 1) * (1 / (8 * X - 1)) = 1 := by
      field_simp
      try ring
    have := mul_le_mul_of_nonneg_left hL (by linarith : (0 : ℝ) ≤ 8 * X - 1)
    linarith
  have hMf : 1 / 2 ≤ Mf := by
    have h1 := hM (↑X + ↑T * I) (by rw [sub_self, norm_zero]; linarith)
    linarith [Complex.re_le_norm (F (↑X + ↑T * I))]
  have hlog0 : 0 ≤ Real.log (2 * Mf) := Real.log_nonneg (by linarith)
  have hcardZ : ((Z'.image (fun y : ℝ => X * y + X)).card : ℝ)
      ≤ (8 * X - 1) * Real.log (2 * Mf) := by
    have := mul_le_mul_of_nonneg_right hinv hlog0
    linarith
  -- Backlund's step on `[σ, X]`
  have hne1 : ∀ x : ℝ, 0 < ((x : ℂ) + (T : ℂ) * I).im := by
    intro x
    simp
    linarith
  have hder : ∀ x ∈ Set.Icc σ X,
      HasDerivAt (fun y : ℝ => F ((y : ℂ) + (T : ℂ) * I))
        (deriv F ((x : ℂ) + (T : ℂ) * I)) x := by
    intro x _
    have hz : HasDerivAt (fun w : ℂ => w + (T : ℂ) * I) 1 ((x : ℝ) : ℂ) := by
      simpa using (hasDerivAt_id ((x : ℝ) : ℂ)).add_const ((T : ℂ) * I)
    have hcomp :=
      ((((hFa _ (hne1 x)).differentiableAt).hasDerivAt).comp ((x : ℝ) : ℂ) hz).comp_ofReal
    simpa [Function.comp] using hcomp
  have hcg : ContinuousOn (fun x : ℝ => F ((x : ℂ) + (T : ℂ) * I)) (Set.Icc σ X) :=
    fun x hx => ((hder x hx).continuousAt).continuousWithinAt
  have hc : ContinuousOn (fun x : ℝ => deriv F ((x : ℂ) + (T : ℂ) * I)
      / F ((x : ℂ) + (T : ℂ) * I)) (Set.Icc σ X) := by
    intro x hx
    have hf : ContinuousAt (fun y : ℝ => (y : ℂ) + (T : ℂ) * I) x := by fun_prop
    have h1 := ContinuousAt.comp (g := deriv F) (f := fun y : ℝ => (y : ℂ) + (T : ℂ) * I)
      (hFa _ (hne1 x)).deriv.continuousAt hf
    have h2 := ContinuousAt.comp (g := F) (f := fun y : ℝ => (y : ℂ) + (T : ℂ) * I)
      (hFa _ (hne1 x)).continuousAt hf
    exact (h1.div h2 (hne x hx)).continuousWithinAt
  have key := ArgLegs.segment_im_integral_le
    (g := fun x : ℝ => F ((x : ℂ) + (T : ℂ) * I))
    (g' := fun x : ℝ => deriv F ((x : ℂ) + (T : ℂ) * I))
    hσX hder hne hc hcg _ hZ
  have hgoal : edgeH F X T σ
      = (∫ x in σ..X, deriv F ((x : ℂ) + (T : ℂ) * I) / F ((x : ℂ) + (T : ℂ) * I)).im := by
    simp only [edgeH, logDeriv_apply]
  rw [hgoal]
  refine le_trans key (mul_le_mul_of_nonneg_left ?_ Real.pi_pos.le)
  linarith

/-- **The horizontal edge terms, from the growth.** For `1 ≤ X`, `2X ≤ T`, `f` analytic on
`Im > 0`, `Re f(X + iT) ≥ 1/2`, `‖f‖ ≤ Mf` on `‖w − (X + iT)‖ ≤ X − 1/8`, `1/4 ≤ σ₀ ≤ X` and
`f ≠ 0` on `[σ₀, X] + iT`: `|∫_{σ₀}^X edgeH f X T σ dσ| ≤ (X − σ₀) π ((8X − 1) log (2 Mf) + 1)`. -/
theorem horizontal_terms_gen {f : ℂ → ℂ} {X σ₀ T Mf : ℝ} (hX : 1 ≤ X) (hXT : 2 * X ≤ T)
    (hFa : ∀ w : ℂ, 0 < w.im → AnalyticAt ℂ f w)
    (h0 : 1 / 2 ≤ (f (↑X + ↑T * I)).re)
    (hM : ∀ w : ℂ, ‖w - (↑X + ↑T * I)‖ ≤ X - 1 / 8 → ‖f w‖ ≤ Mf)
    (hσ₀ : 1 / 4 ≤ σ₀) (hσX : σ₀ ≤ X)
    (hne : ∀ x ∈ Set.Icc σ₀ X, f (↑x + ↑T * I) ≠ 0) :
    |∫ σ in σ₀..X, edgeH f X T σ| ≤ (X - σ₀) * (Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1)) := by
  have hpt : ∀ σ ∈ Ι σ₀ X, ‖edgeH f X T σ‖ ≤ Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1) := by
    intro σ hσ
    rw [Set.uIoc_of_le hσX] at hσ
    rw [Real.norm_eq_abs]
    exact edge_le_upper hX hXT hFa h0 hM (by linarith [hσ.1]) hσ.2
      (fun x hx => hne x ⟨by linarith [hσ.1, hx.1], hx.2⟩)
  have h := intervalIntegral.norm_integral_le_of_norm_le_const hpt
  rw [Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.mpr hσX)] at h
  linarith

/-- info: 'FloorQ.arg_term_le_on' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms arg_term_le_on

/-- info: 'FloorQ.right_terms_gen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms right_terms_gen

/-- info: 'FloorQ.edge_le_upper' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms edge_le_upper

/-- info: 'FloorQ.horizontal_terms_gen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms horizontal_terms_gen

end FloorQ
