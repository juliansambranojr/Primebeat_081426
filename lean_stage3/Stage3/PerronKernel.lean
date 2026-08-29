/-
# Slice 1a — the truncated Perron kernel bound (hEF's entry point)

COMPLETE, 2026-08-29: every branch proved, no sorry. `perron_kernel_truncated`
sits at `[propext, Classical.choice, Quot.sound]`. (Build order: entry 257;
ledger: CONTEXT.md § hEF, roadmap D. This was hEF's load-bearing unknown —
the piece both MediumPNT and StrongPNT were designed to avoid.)

The ONE previously-missing piece of the truncated explicit formula,
zeta-free:

    ‖(2πi)⁻¹ ∫_{c-iT}^{c+iT} y^s/s ds − [y > 1]‖ ≤ y^c · min(1, 1/(T·|log y|))

Classical: Davenport ch. 17 Lemma; Montgomery–Vaughan Thm 5.2 (their
constant has π in the denominator — dropping it is the crude-explicit
spec, CLAUDE.md Stage-3 conventions).

Routes, as built (the classical arc was never needed):
  K1, y < 1   one finite rectangle of width T, crude endpoint bounds — (2/π)·y^c.
  K1, y > 1   T·log y ≥ 1 from the decay branch; below that, split off the
              exact ∫ ds/s = 2i·arctan(T/c) (pure real calculus), mean-value
              bound ‖y^s−1‖ ≤ ‖s‖·log y·y^c, and the elementary two-variable
              inequality coarse_gt_ineq.
  K2, y < 1   rectangles to +∞ along the naturals; horiz_bound on both edges.
  K2, y > 1   rectangle to −∞ collects the residue at 0
              (dslope regular part + ResidueTheoremOnRectangleWithSimplePole).

Upstream probed 2026-08-28: PNT+ main's PerronFormula.lean has no sharp-
kernel min-bound (its kernel is the smoothed x^s/(s(s+1))); the pin bump
does not discharge this leaf. Its rectangle machinery (vertIntBound,
contourPull, HolomorphicOn.upperUIntegral_eq_zero) is reusable structure
for K2.

Classical reference for the statement: Davenport ch. 17; MV Thm 5.2 keeps a
π we drop (crude-explicit spec).
-/
import Mathlib
import PrimeNumberTheoremAnd.ResidueCalcOnRectangles

namespace PerronKernel

open Complex Topology

/-- The truncated Perron integral `(2πi)⁻¹ ∫_{c-iT}^{c+iT} y^s/s ds`,
parametrised on the vertical segment. -/
noncomputable def perronI (y c T : ℝ) : ℂ :=
  (2 * Real.pi * Complex.I)⁻¹
    * ∫ t in (-T)..T, (y : ℂ) ^ ((c : ℂ) + Complex.I * t)
        / ((c : ℂ) + Complex.I * t) * Complex.I

/-- The target of the kernel: the indicator of `1 < y`. -/
noncomputable def perronδ (y : ℝ) : ℂ := if 1 < y then 1 else 0

/-- `perronI` is PNT+'s right-edge `VIntegral'` of the kernel. -/
theorem perronI_eq_VIntegral' (y c T : ℝ) :
    perronI y c T = VIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) c (-T) T := by
  unfold perronI VIntegral' VIntegral
  have h : ∀ t : ℝ, (y : ℂ) ^ ((c : ℂ) + Complex.I * t) / ((c : ℂ) + Complex.I * t) * Complex.I
      = (fun s : ℂ ↦ (y : ℂ) ^ s / s) ((c : ℝ) + (t : ℝ) * Complex.I) * Complex.I := by
    intro t
    have harg : (c : ℂ) + Complex.I * (t : ℂ) = ((c : ℝ) : ℂ) + ((t : ℝ) : ℂ) * Complex.I := by
      ring
    rw [harg]
  simp_rw [h]
  rw [intervalIntegral.integral_mul_const, smul_eq_mul, smul_eq_mul]
  ring

/-- The kernel is holomorphic on the open right half-plane. -/
theorem kernel_holo {y : ℝ} (hy : 0 < y) :
    HolomorphicOn (fun s : ℂ ↦ (y : ℂ) ^ s / s) {s : ℂ | 0 < s.re} := by
  intro s hs
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    simp at hs
  exact ((differentiable_id.const_cpow
    (Or.inl (by exact_mod_cast hy.ne'))).differentiableAt.div
    differentiableAt_id hs0).differentiableWithinAt

/-- A rectangle with left edge at `c > 0` sits in the right half-plane. -/
theorem rect_subset_right {c X T : ℝ} (hc : 0 < c) (hcX : c ≤ X) :
    Rectangle ((c : ℂ) - Complex.I * T) ((X : ℂ) + Complex.I * T) ⊆ {s : ℂ | 0 < s.re} := by
  intro s hs
  rw [Rectangle, Complex.mem_reProdIm] at hs
  have h1 := hs.1
  simp only [Complex.sub_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re,
    Complex.ofReal_im, Complex.I_im, Complex.add_re] at h1
  rw [Set.uIcc_of_le (by norm_num; linarith)] at h1
  have : c ≤ s.re := by
    have := h1.1
    simpa using this
  simpa using lt_of_lt_of_le hc this

/-- **K1, case `y < 1`.** A single finite rectangle of width `T`: crude
endpoint bounds on all three far edges give `(2/π)·y^c` — no limits. -/
theorem perron_kernel_coarse_lt {y c T : ℝ} (hy : 0 < y) (hylt : y < 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c := by
  have hT0 : (0:ℝ) < T := lt_of_lt_of_le one_pos hT
  have hδ : perronδ y = 0 := by
    rw [perronδ, if_neg (not_lt.mpr hylt.le)]
  rw [hδ, sub_zero, perronI_eq_VIntegral']
  set f : ℂ → ℂ := fun s ↦ (y : ℂ) ^ s / s with hfdef
  set X : ℝ := c + T with hXdef
  have hcX : c ≤ X := by rw [hXdef]; linarith
  have hX0 : (0:ℝ) < X := by rw [hXdef]; linarith
  have hyc : (0:ℝ) < y ^ c := Real.rpow_pos_of_pos hy c
  -- the vanishing rectangle
  have hvan : RectangleIntegral f ((c:ℂ) - Complex.I * T) ((X:ℂ) + Complex.I * T) = 0 :=
    HolomorphicOn.vanishesOnRectangle (kernel_holo hy) (rect_subset_right hc hcX)
  rw [RectangleIntegral] at hvan
  simp only [Complex.sub_re, Complex.add_re, Complex.ofReal_re, Complex.mul_re,
    Complex.I_re, Complex.ofReal_im, Complex.I_im, Complex.sub_im, Complex.add_im,
    Complex.mul_im, mul_zero, mul_one, zero_mul, sub_zero, zero_sub, zero_add] at hvan
  norm_num at hvan
  have hV : VIntegral f c (-T) T
      = HIntegral f c X (-T) - HIntegral f c X T + VIntegral f X (-T) T := by
    linear_combination -hvan
  -- crude horizontal bounds at heights ±T
  have hHbound : ∀ T' : ℝ, |T'| = T → ‖HIntegral f c X T'‖ ≤ y ^ c := by
    intro T' hT'
    rw [HIntegral]
    have hpt : ∀ x ∈ Set.uIoc c X, ‖f ((x : ℝ) + (T' : ℝ) * Complex.I)‖ ≤ y ^ c / T := by
      intro x hx
      have hxc : c ≤ x := by
        rw [Set.uIoc_of_le hcX] at hx
        exact hx.1.le
      have hden : T ≤ ‖(x : ℂ) + (T' : ℂ) * Complex.I‖ := by
        have h := Complex.abs_im_le_norm ((x : ℂ) + (T' : ℂ) * Complex.I)
        rw [← hT']
        simpa using h
      have hnum : ‖(y : ℂ) ^ ((x : ℂ) + (T' : ℂ) * Complex.I)‖ = y ^ x := by
        rw [Complex.norm_cpow_eq_rpow_re_of_pos hy]
        simp
      have h1 : y ^ x ≤ y ^ c := Real.rpow_le_rpow_of_exponent_ge hy hylt.le hxc
      rw [hfdef]
      simp only [norm_div, hnum]
      calc y ^ x / ‖(x : ℂ) + (T' : ℂ) * Complex.I‖
          ≤ y ^ c / ‖(x : ℂ) + (T' : ℂ) * Complex.I‖ :=
            div_le_div_of_nonneg_right h1 (hT0.trans_le hden).le
        _ ≤ y ^ c / T := div_le_div_of_nonneg_left hyc.le hT0 hden
    calc ‖∫ x in c..X, f (↑x + ↑T' * Complex.I)‖
        ≤ y ^ c / T * |X - c| := intervalIntegral.norm_integral_le_of_norm_le_const hpt
      _ = y ^ c := by
          rw [hXdef]
          rw [show c + T - c = T by ring, abs_of_pos hT0]
          field_simp
  -- the far vertical edge
  have hVX : ‖VIntegral f X (-T) T‖ ≤ 2 * y ^ c := by
    rw [VIntegral, norm_smul, Complex.norm_I, one_mul]
    have hyX : y ^ X ≤ y ^ c := Real.rpow_le_rpow_of_exponent_ge hy hylt.le hcX
    have hpt : ∀ t ∈ Set.uIoc (-T) T, ‖f ((X : ℝ) + (t : ℝ) * Complex.I)‖ ≤ y ^ X / X := by
      intro t _
      have hden : X ≤ ‖(X : ℂ) + (t : ℂ) * Complex.I‖ := by
        have h := Complex.abs_re_le_norm ((X : ℂ) + (t : ℂ) * Complex.I)
        calc X = |X| := (abs_of_pos hX0).symm
          _ ≤ ‖(X : ℂ) + (t : ℂ) * Complex.I‖ := by simpa using h
      have hnum : ‖(y : ℂ) ^ ((X : ℂ) + (t : ℂ) * Complex.I)‖ = y ^ X := by
        rw [Complex.norm_cpow_eq_rpow_re_of_pos hy]
        simp
      rw [hfdef]
      simp only [norm_div, hnum]
      exact div_le_div_of_nonneg_left (Real.rpow_pos_of_pos hy X).le hX0 hden
    calc ‖∫ t in (-T)..T, f (↑X + ↑t * Complex.I)‖
        ≤ y ^ X / X * |T - (-T)| := intervalIntegral.norm_integral_le_of_norm_le_const hpt
      _ = y ^ X * (2 * T / X) := by
          rw [show T - (-T) = 2 * T by ring, abs_of_pos (by linarith)]
          ring
      _ ≤ y ^ c * 2 := by
          have h2TX : 2 * T / X ≤ 2 := by
            have hTX : T ≤ X := by rw [hXdef]; linarith
            calc 2 * T / X ≤ 2 * T / T :=
                  div_le_div_of_nonneg_left (by positivity) hT0 hTX
              _ = 2 := by field_simp
          have := mul_le_mul hyX h2TX (by positivity) hyc.le
          linarith [this]
      _ = 2 * y ^ c := by ring
  -- assemble
  show ‖(1 / (2 * (Real.pi : ℂ) * Complex.I)) • VIntegral f c (-T) T‖ ≤ y ^ c
  rw [norm_smul, hV]
  have hns : ‖(1 : ℂ) / (2 * (Real.pi : ℂ) * Complex.I)‖ = 1 / (2 * Real.pi) := by
    rw [norm_div, norm_one, norm_mul, norm_mul, Complex.norm_I, mul_one]
    simp [abs_of_pos Real.pi_pos]
  rw [hns]
  have htri : ‖HIntegral f c X (-T) - HIntegral f c X T + VIntegral f X (-T) T‖
      ≤ y ^ c + y ^ c + 2 * y ^ c := by
    calc ‖HIntegral f c X (-T) - HIntegral f c X T + VIntegral f X (-T) T‖
        ≤ ‖HIntegral f c X (-T) - HIntegral f c X T‖ + ‖VIntegral f X (-T) T‖ :=
          norm_add_le _ _
      _ ≤ ‖HIntegral f c X (-T)‖ + ‖HIntegral f c X T‖ + ‖VIntegral f X (-T) T‖ := by
          have := norm_sub_le (HIntegral f c X (-T)) (HIntegral f c X T)
          linarith
      _ ≤ y ^ c + y ^ c + 2 * y ^ c := by
          have h1 := hHbound (-T) (by rw [abs_neg, abs_of_pos hT0])
          have h2 := hHbound T (abs_of_pos hT0)
          linarith [hVX]
  calc 1 / (2 * Real.pi) * ‖HIntegral f c X (-T) - HIntegral f c X T + VIntegral f X (-T) T‖
      ≤ 1 / (2 * Real.pi) * (y ^ c + y ^ c + 2 * y ^ c) := by
        apply mul_le_mul_of_nonneg_left htri
        positivity
    _ ≤ y ^ c := by
        have h4 : (4:ℝ) ≤ 2 * Real.pi := by linarith [Real.pi_gt_three]
        calc 1 / (2 * Real.pi) * (y ^ c + y ^ c + 2 * y ^ c)
            = (4 * y ^ c) / (2 * Real.pi) := by ring
          _ ≤ (4 * y ^ c) / 4 := div_le_div_of_nonneg_left (by positivity) (by norm_num) h4
          _ = y ^ c := by ring

/-- The shared horizontal-edge estimate: along `Im s = T'` with `|T'| ≥ 1`,
the kernel's horizontal integral is controlled by the endpoint powers over
`|T'|·|log y|`. Every rectangle in both decay cases consumes this. -/
theorem horiz_bound {y T' : ℝ} (hy : 0 < y) (hy1 : y ≠ 1) (hT : 1 ≤ |T'|)
    {a b : ℝ} (hab : a ≤ b) :
    ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I) / ((σ : ℂ) + (T' : ℂ) * Complex.I)‖
      ≤ max (y ^ a) (y ^ b) / (|T'| * |Real.log y|) := by
  have hL : Real.log y ≠ 0 :=
    Real.log_ne_zero.mpr ⟨hy.ne', hy1, by linarith⟩
  have hT0 : (0:ℝ) < |T'| := lt_of_lt_of_le one_pos hT
  -- pointwise: ‖y^(σ+iT')/(σ+iT')‖ ≤ y^σ/|T'|
  have hpt : ∀ σ : ℝ, ‖(y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I)
      / ((σ : ℂ) + (T' : ℂ) * Complex.I)‖ ≤ y ^ σ / |T'| := by
    intro σ
    have hden : |T'| ≤ ‖(σ : ℂ) + (T' : ℂ) * Complex.I‖ := by
      have := Complex.abs_im_le_norm ((σ : ℂ) + (T' : ℂ) * Complex.I)
      simpa using this
    have hnum : ‖(y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I)‖ = y ^ σ := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos hy]
      simp
    rw [norm_div, hnum]
    apply div_le_div_of_nonneg_left _ hT0 hden
    · positivity
  -- the majorant integrates to (y^b − y^a)/log y
  have hint : (∫ σ in a..b, y ^ σ) = (y ^ b - y ^ a) / Real.log y := by
    have hrw : ∀ σ : ℝ, y ^ σ = Real.exp (Real.log y * σ) := by
      intro σ
      rw [Real.rpow_def_of_pos hy]
    simp_rw [hrw]
    have D : ∀ x : ℝ, HasDerivAt (fun t : ℝ ↦ Real.exp (Real.log y * t) / Real.log y)
        (Real.exp (Real.log y * x)) x := by
      intro x
      have h1 : HasDerivAt (fun t : ℝ ↦ Real.log y * t) (Real.log y) x := by
        simpa using (hasDerivAt_id x).const_mul (Real.log y)
      have h2 := (Real.hasDerivAt_exp (Real.log y * x)).comp x h1
      have h3 := h2.div_const (Real.log y)
      simpa [mul_div_assoc, mul_div_cancel_right₀ _ hL] using h3
    rw [intervalIntegral.integral_eq_sub_of_hasDerivAt (fun x _ ↦ D x)
      ((Real.continuous_exp.comp (continuous_const.mul continuous_id)).intervalIntegrable a b)]
    ring
  -- assemble
  have hmaj : ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I)
      / ((σ : ℂ) + (T' : ℂ) * Complex.I)‖ ≤ (∫ σ in a..b, y ^ σ) / |T'| := by
    have hgc : Continuous fun σ : ℝ ↦ y ^ σ := by
      simp_rw [Real.rpow_def_of_pos hy]
      exact Real.continuous_exp.comp (continuous_const.mul continuous_id)
    have hgi : IntervalIntegrable (fun σ : ℝ ↦ y ^ σ / |T'|) MeasureTheory.volume a b :=
      (hgc.div_const _).intervalIntegrable a b
    calc ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I) / ((σ : ℂ) + (T' : ℂ) * Complex.I)‖
        ≤ ∫ σ in a..b, y ^ σ / |T'| := by
          apply intervalIntegral.norm_integral_le_of_norm_le hab _ hgi
          filter_upwards with σ _ using hpt σ
      _ = (∫ σ in a..b, y ^ σ) / |T'| := by
          rw [intervalIntegral.integral_div]
  refine hmaj.trans ?_
  rw [hint]
  -- (y^b − y^a)/log y / |T'| ≤ max(y^a, y^b)/(|T'|·|log y|), by sign of log y
  rcases lt_or_gt_of_ne hL with hneg | hpos
  · -- y < 1: log y < 0, numerator y^b − y^a ≤ 0, quotient = (y^a − y^b)/|log y|
    have hyx : y ^ b ≤ y ^ a := Real.rpow_le_rpow_of_exponent_ge hy
      (by rcases Real.log_neg_iff hy |>.mp hneg with h; linarith [h.le]) hab
    have h1 : (y ^ b - y ^ a) / Real.log y = (y ^ a - y ^ b) / |Real.log y| := by
      rw [abs_of_neg hneg]
      field_simp
      ring
    rw [h1]
    have h2 : (y ^ a - y ^ b) / |Real.log y| ≤ y ^ a / |Real.log y| := by
      apply div_le_div_of_nonneg_right _ (abs_pos.mpr hL).le
      have : (0:ℝ) ≤ y ^ b := Real.rpow_nonneg hy.le b
      linarith
    calc (y ^ a - y ^ b) / |Real.log y| / |T'|
        ≤ y ^ a / |Real.log y| / |T'| := by
          exact div_le_div_of_nonneg_right h2 hT0.le
      _ = y ^ a / (|T'| * |Real.log y|) := by ring
      _ ≤ max (y ^ a) (y ^ b) / (|T'| * |Real.log y|) := by
          exact div_le_div_of_nonneg_right (le_max_left _ _) (by positivity)
  · -- y > 1: log y > 0, numerator ≤ y^b
    have h1 : (y ^ b - y ^ a) / Real.log y ≤ y ^ b / |Real.log y| := by
      rw [abs_of_pos hpos]
      apply div_le_div_of_nonneg_right _ hpos.le
      have : (0:ℝ) ≤ y ^ a := Real.rpow_nonneg hy.le a
      linarith
    calc (y ^ b - y ^ a) / Real.log y / |T'|
        ≤ y ^ b / |Real.log y| / |T'| := by
          exact div_le_div_of_nonneg_right h1 hT0.le
      _ = y ^ b / (|T'| * |Real.log y|) := by ring
      _ ≤ max (y ^ a) (y ^ b) / (|T'| * |Real.log y|) := by
          exact div_le_div_of_nonneg_right (le_max_right _ _) (by positivity)

/-- **K2, case `y < 1`.** No pole; rectangles to `+∞` along the naturals,
`horiz_bound` on both edges, the far vertical vanishes in the limit. -/
theorem perron_kernel_decay_lt {y c T : ℝ} (hy : 0 < y) (hylt : y < 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) := by
  have hT0 : (0:ℝ) < T := lt_of_lt_of_le one_pos hT
  have hL : Real.log y ≠ 0 := Real.log_ne_zero.mpr ⟨hy.ne', ne_of_lt hylt, by linarith⟩
  have hδ : perronδ y = 0 := by rw [perronδ, if_neg (not_lt.mpr hylt.le)]
  rw [hδ, sub_zero, perronI_eq_VIntegral']
  set f : ℂ → ℂ := fun s ↦ (y : ℂ) ^ s / s with hfdef
  set A : ℝ := y ^ c / (T * |Real.log y|) with hAdef
  have hyc : (0:ℝ) < y ^ c := Real.rpow_pos_of_pos hy c
  have hA0 : 0 < A := by rw [hAdef]; positivity
  -- the X-parametrised bound
  have key : ∀ X : ℝ, c ≤ X → 1 ≤ X →
      ‖VIntegral f c (-T) T‖ ≤ 2 * A + 2 * T * y ^ X := by
    intro X hcX hX1
    have hX0 : (0:ℝ) < X := lt_of_lt_of_le one_pos hX1
    have hvan : RectangleIntegral f ((c:ℂ) - Complex.I * T) ((X:ℂ) + Complex.I * T) = 0 :=
      HolomorphicOn.vanishesOnRectangle (kernel_holo hy) (rect_subset_right hc hcX)
    rw [RectangleIntegral] at hvan
    simp only [Complex.sub_re, Complex.add_re, Complex.ofReal_re, Complex.mul_re,
      Complex.I_re, Complex.ofReal_im, Complex.I_im, Complex.sub_im, Complex.add_im,
      Complex.mul_im, mul_zero, mul_one, zero_mul, sub_zero, zero_sub, zero_add] at hvan
    norm_num at hvan
    have hV : VIntegral f c (-T) T
        = HIntegral f c X (-T) - HIntegral f c X T + VIntegral f X (-T) T := by
      linear_combination -hvan
    have hmax : max (y ^ c) (y ^ X) = y ^ c :=
      max_eq_left (Real.rpow_le_rpow_of_exponent_ge hy hylt.le hcX)
    have hHb : ∀ T' : ℝ, |T'| = T → ‖HIntegral f c X T'‖ ≤ A := by
      intro T' hT'
      have h1T' : 1 ≤ |T'| := by rw [hT']; exact hT
      have hb := horiz_bound hy (ne_of_lt hylt) h1T' hcX
      rw [HIntegral]
      simp only [hfdef]
      rw [hAdef, ← hT']
      calc ‖∫ x in c..X,
            (y:ℂ) ^ ((x:ℂ) + (T':ℂ) * Complex.I) / ((x:ℂ) + (T':ℂ) * Complex.I)‖
          ≤ max (y ^ c) (y ^ X) / (|T'| * |Real.log y|) := hb
        _ = y ^ c / (|T'| * |Real.log y|) := by rw [hmax]
    have hVX : ‖VIntegral f X (-T) T‖ ≤ 2 * T * y ^ X := by
      rw [VIntegral, norm_smul, Complex.norm_I, one_mul]
      have hpt : ∀ t ∈ Set.uIoc (-T) T, ‖f ((X : ℝ) + (t : ℝ) * Complex.I)‖ ≤ y ^ X / X := by
        intro t _
        have hden : X ≤ ‖(X : ℂ) + (t : ℂ) * Complex.I‖ := by
          have h := Complex.abs_re_le_norm ((X : ℂ) + (t : ℂ) * Complex.I)
          calc X = |X| := (abs_of_pos hX0).symm
            _ ≤ ‖(X : ℂ) + (t : ℂ) * Complex.I‖ := by simpa using h
        have hnum : ‖(y : ℂ) ^ ((X : ℂ) + (t : ℂ) * Complex.I)‖ = y ^ X := by
          rw [Complex.norm_cpow_eq_rpow_re_of_pos hy]
          simp
        rw [hfdef]
        simp only [norm_div, hnum]
        exact div_le_div_of_nonneg_left (Real.rpow_pos_of_pos hy X).le hX0 hden
      calc ‖∫ t in (-T)..T, f (↑X + ↑t * Complex.I)‖
          ≤ y ^ X / X * |T - (-T)| := intervalIntegral.norm_integral_le_of_norm_le_const hpt
        _ = y ^ X / X * (2 * T) := by
            rw [show T - (-T) = 2 * T by ring, abs_of_pos (by linarith)]
        _ ≤ y ^ X * (2 * T) := by
            have hds : y ^ X / X ≤ y ^ X := div_le_self (Real.rpow_pos_of_pos hy X).le hX1
            exact mul_le_mul_of_nonneg_right hds (by linarith)
        _ = 2 * T * y ^ X := by ring
    rw [hV]
    calc ‖HIntegral f c X (-T) - HIntegral f c X T + VIntegral f X (-T) T‖
        ≤ ‖HIntegral f c X (-T) - HIntegral f c X T‖ + ‖VIntegral f X (-T) T‖ :=
          norm_add_le _ _
      _ ≤ ‖HIntegral f c X (-T)‖ + ‖HIntegral f c X T‖ + ‖VIntegral f X (-T) T‖ := by
          have := norm_sub_le (HIntegral f c X (-T)) (HIntegral f c X T)
          linarith
      _ ≤ 2 * A + 2 * T * y ^ X := by
          have h1 := hHb (-T) (by rw [abs_neg, abs_of_pos hT0])
          have h2 := hHb T (abs_of_pos hT0)
          linarith [hVX]
  -- limit along the naturals: the far vertical dies
  have hVc : ‖VIntegral f c (-T) T‖ ≤ 2 * A := by
    have hpow : Filter.Tendsto (fun n : ℕ ↦ y ^ (n : ℝ)) Filter.atTop (𝓝 0) := by
      have h := tendsto_pow_atTop_nhds_zero_of_lt_one hy.le hylt
      refine h.congr fun n ↦ ?_
      rw [← Real.rpow_natCast y n]
    have hlim : Filter.Tendsto (fun n : ℕ ↦ 2 * A + 2 * T * y ^ (n : ℝ))
        Filter.atTop (𝓝 (2 * A + 2 * T * 0)) :=
      Filter.Tendsto.const_add _ (Filter.Tendsto.const_mul _ hpow)
    have hev : ∀ᶠ n : ℕ in Filter.atTop,
        ‖VIntegral f c (-T) T‖ ≤ 2 * A + 2 * T * y ^ (n : ℝ) := by
      filter_upwards [Filter.eventually_ge_atTop (⌈c⌉₊ + 1)] with n hn
      have hcn : c ≤ (n : ℝ) := by
        calc c ≤ (⌈c⌉₊ : ℝ) := Nat.le_ceil c
          _ ≤ (n : ℝ) := by exact_mod_cast Nat.le_of_lt (Nat.lt_of_lt_of_le (Nat.lt_succ_self _) hn)
      have h1n : (1:ℝ) ≤ (n : ℝ) := by
        have h1 : 1 ≤ n := by omega
        exact_mod_cast h1
      exact key (n : ℝ) hcn h1n
    have := ge_of_tendsto hlim hev
    simpa using this
  -- assemble
  show ‖(1 / (2 * (Real.pi : ℂ) * Complex.I)) • VIntegral f c (-T) T‖
      ≤ y ^ c / (T * |Real.log y|)
  rw [norm_smul]
  have hns : ‖(1 : ℂ) / (2 * (Real.pi : ℂ) * Complex.I)‖ = 1 / (2 * Real.pi) := by
    rw [norm_div, norm_one, norm_mul, norm_mul, Complex.norm_I, mul_one]
    simp [abs_of_pos Real.pi_pos]
  rw [hns]
  calc 1 / (2 * Real.pi) * ‖VIntegral f c (-T) T‖
      ≤ 1 / (2 * Real.pi) * (2 * A) := by
        apply mul_le_mul_of_nonneg_left hVc
        positivity
    _ = A / Real.pi := by ring
    _ ≤ A / 1 := div_le_div_of_nonneg_left hA0.le one_pos (by linarith [Real.pi_gt_three])
    _ = y ^ c / (T * |Real.log y|) := by rw [div_one, hAdef]

/-- The kernel's regular part at the pole: `dslope` of `y^s` at `0` is entire. -/
theorem dslope_kernel_diff {y : ℝ} (hy : 0 < y) :
    Differentiable ℂ (dslope (fun s : ℂ ↦ (y : ℂ) ^ s) 0) := by
  have hy0 : (y : ℂ) ≠ 0 := by exact_mod_cast hy.ne'
  have hF : Differentiable ℂ (fun s : ℂ ↦ (y : ℂ) ^ s) :=
    differentiable_id.const_cpow (Or.inl hy0)
  intro z
  rcases eq_or_ne z 0 with rfl | hz
  · obtain ⟨p, hp⟩ := hF.analyticAt 0
    exact (HasFPowerSeriesAt.has_fpower_series_dslope_fslope hp).analyticAt.differentiableAt
  · have hev : dslope (fun s : ℂ ↦ (y : ℂ) ^ s) 0
        =ᶠ[𝓝 z] fun w : ℂ ↦ ((y : ℂ) ^ w - 1) / w := by
      filter_upwards [isOpen_compl_singleton.mem_nhds hz] with w hw
      rw [dslope_of_ne _ hw, slope_def_field, Complex.cpow_zero, sub_zero]
    have hdiff : DifferentiableAt ℂ (fun w : ℂ ↦ ((y : ℂ) ^ w - 1) / w) z :=
      ((hF.differentiableAt.sub_const 1).div differentiableAt_id hz)
    exact hdiff.congr_of_eventuallyEq hev

/-- The pole, crossed once: the rectangle boundary integral of the kernel
around `0` is `1` after `(2πi)⁻¹` normalisation. -/
theorem rect_residue {y c T X : ℝ} (hy : 0 < y) (hc : 0 < c) (hT : 0 < T)
    (hX : 0 < X) :
    RectangleIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s)
      (-(X:ℂ) - Complex.I * T) ((c:ℂ) + Complex.I * T) = 1 := by
  have hzw : (-(X:ℂ) - Complex.I * T).re ≤ ((c:ℂ) + Complex.I * T).re := by
    simp
    linarith
  have hzw' : (-(X:ℂ) - Complex.I * T).im ≤ ((c:ℂ) + Complex.I * T).im := by
    simp
    linarith
  have hpole : Rectangle (-(X:ℂ) - Complex.I * T) ((c:ℂ) + Complex.I * T) ∈ 𝓝 (0:ℂ) := by
    rw [rectangle_mem_nhds_iff, Complex.mem_reProdIm]
    constructor
    · simp only [Complex.sub_re, Complex.add_re, Complex.neg_re, Complex.ofReal_re,
        Complex.mul_re, Complex.I_re, Complex.ofReal_im, Complex.I_im, Complex.zero_re]
      rw [Set.uIoo_of_lt (by norm_num; linarith)]
      constructor <;> [linarith; linarith]
    · simp only [Complex.sub_im, Complex.add_im, Complex.neg_im, Complex.ofReal_im,
        Complex.mul_im, Complex.I_im, Complex.I_re, Complex.ofReal_re, Complex.zero_im]
      rw [Set.uIoo_of_lt (by norm_num; linarith)]
      constructor <;> [linarith; linarith]
  apply ResidueTheoremOnRectangleWithSimplePole hzw hzw' hpole
    ((dslope_kernel_diff hy).differentiableOn)
  intro s hs
  have hs0 : s ≠ 0 := by
    intro h
    exact hs.2 (by rw [h]; rfl)
  simp only [Pi.sub_apply]
  rw [dslope_of_ne _ hs0, slope_def_field, Complex.cpow_zero, sub_zero]
  rw [sub_div]

/-- **K2, case `y > 1`.** The rectangle to `−∞` collects the residue
`1 = perronδ y`; `horiz_bound` on both edges, far vertical dies. -/
theorem perron_kernel_decay_gt {y c T : ℝ} (hygt : 1 < y)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) := by
  have hy : (0:ℝ) < y := lt_trans one_pos hygt
  have hT0 : (0:ℝ) < T := lt_of_lt_of_le one_pos hT
  have hL : Real.log y ≠ 0 := Real.log_ne_zero.mpr ⟨hy.ne', ne_of_gt hygt, by linarith⟩
  have hδ : perronδ y = 1 := by rw [perronδ, if_pos hygt]
  rw [hδ, perronI_eq_VIntegral']
  set f : ℂ → ℂ := fun s ↦ (y : ℂ) ^ s / s with hfdef
  set A : ℝ := y ^ c / (T * |Real.log y|) with hAdef
  have hyc : (0:ℝ) < y ^ c := Real.rpow_pos_of_pos hy c
  have hA0 : 0 < A := by rw [hAdef]; positivity
  have h2πI : (2 * (Real.pi:ℂ) * Complex.I) ≠ 0 := by
    simp [Real.pi_ne_zero, Complex.I_ne_zero]
  have hns : ‖(1 : ℂ) / (2 * (Real.pi : ℂ) * Complex.I)‖ = 1 / (2 * Real.pi) := by
    rw [norm_div, norm_one, norm_mul, norm_mul, Complex.norm_I, mul_one]
    simp [abs_of_pos Real.pi_pos]
  -- the X-parametrised bound
  have key : ∀ X : ℝ, 1 ≤ X →
      ‖VIntegral' f c (-T) T - 1‖ ≤ 1 / (2 * Real.pi) * (2 * A + 2 * T * y ^ (-X)) := by
    intro X hX1
    have hX0 : (0:ℝ) < X := lt_of_lt_of_le one_pos hX1
    have hres := rect_residue (y := y) (c := c) (T := T) (X := X) hy hc hT0 hX0
    have hR : RectangleIntegral f (-(X:ℂ) - Complex.I * T) ((c:ℂ) + Complex.I * T)
        = 2 * (Real.pi:ℂ) * Complex.I := by
      simp only [RectangleIntegral', smul_eq_mul] at hres
      field_simp at hres
      linear_combination hres
    rw [RectangleIntegral] at hR
    simp only [Complex.sub_re, Complex.add_re, Complex.neg_re, Complex.ofReal_re,
      Complex.mul_re, Complex.I_re, Complex.ofReal_im, Complex.I_im, Complex.sub_im,
      Complex.add_im, Complex.neg_im, Complex.mul_im, mul_zero, mul_one, zero_mul,
      sub_zero, zero_sub, zero_add] at hR
    norm_num at hR
    have hV : VIntegral f c (-T) T - 2 * (Real.pi:ℂ) * Complex.I
        = -HIntegral f (-X) c (-T) + HIntegral f (-X) c T + VIntegral f (-X) (-T) T := by
      linear_combination hR
    have hsplit : VIntegral' f c (-T) T - 1
        = (1 / (2 * (Real.pi:ℂ) * Complex.I))
            • (VIntegral f c (-T) T - 2 * (Real.pi:ℂ) * Complex.I) := by
      rw [smul_sub]
      congr 1
      rw [smul_eq_mul]
      field_simp
    -- edge bounds
    have hXc : -X ≤ c := by linarith
    have hmax : max (y ^ (-X)) (y ^ c) = y ^ c :=
      max_eq_right (Real.rpow_le_rpow_of_exponent_le hygt.le hXc)
    have hHb : ∀ T' : ℝ, |T'| = T → ‖HIntegral f (-X) c T'‖ ≤ A := by
      intro T' hT'
      have h1T' : 1 ≤ |T'| := by rw [hT']; exact hT
      have hb := horiz_bound hy (ne_of_gt hygt) h1T' hXc
      rw [HIntegral]
      simp only [hfdef]
      rw [hAdef, ← hT']
      calc ‖∫ x in (-X)..c,
            (y:ℂ) ^ ((x:ℂ) + (T':ℂ) * Complex.I) / ((x:ℂ) + (T':ℂ) * Complex.I)‖
          ≤ max (y ^ (-X)) (y ^ c) / (|T'| * |Real.log y|) := hb
        _ = y ^ c / (|T'| * |Real.log y|) := by rw [hmax]
    have hVX : ‖VIntegral f (-X) (-T) T‖ ≤ 2 * T * y ^ (-X) := by
      rw [VIntegral, norm_smul, Complex.norm_I, one_mul]
      have hpt : ∀ t ∈ Set.uIoc (-T) T,
          ‖f ((-X : ℝ) + (t : ℝ) * Complex.I)‖ ≤ y ^ (-X) / X := by
        intro t _
        have hden : X ≤ ‖((-X : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ := by
          have h := Complex.abs_re_le_norm (((-X : ℝ) : ℂ) + (t : ℂ) * Complex.I)
          calc X = |(-X : ℝ)| := by rw [abs_neg, abs_of_pos hX0]
            _ ≤ ‖((-X : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ := by simpa using h
        have hnum : ‖(y : ℂ) ^ (((-X : ℝ) : ℂ) + (t : ℂ) * Complex.I)‖ = y ^ (-X) := by
          rw [Complex.norm_cpow_eq_rpow_re_of_pos hy]
          simp
        rw [hfdef]
        simp only [norm_div, hnum]
        exact div_le_div_of_nonneg_left (Real.rpow_pos_of_pos hy (-X)).le hX0 hden
      calc ‖∫ t in (-T)..T, f (↑(-X : ℝ) + ↑t * Complex.I)‖
          ≤ y ^ (-X) / X * |T - (-T)| := intervalIntegral.norm_integral_le_of_norm_le_const hpt
        _ = y ^ (-X) / X * (2 * T) := by
            rw [show T - (-T) = 2 * T by ring, abs_of_pos (by linarith)]
        _ ≤ y ^ (-X) * (2 * T) := by
            have hds : y ^ (-X) / X ≤ y ^ (-X) :=
              div_le_self (Real.rpow_pos_of_pos hy (-X)).le hX1
            exact mul_le_mul_of_nonneg_right hds (by linarith)
        _ = 2 * T * y ^ (-X) := by ring
    rw [hsplit, norm_smul, hns, hV]
    have htri : ‖-HIntegral f (-X) c (-T) + HIntegral f (-X) c T + VIntegral f (-X) (-T) T‖
        ≤ 2 * A + 2 * T * y ^ (-X) := by
      have h1 := hHb (-T) (by rw [abs_neg, abs_of_pos hT0])
      have h2 := hHb T (abs_of_pos hT0)
      calc ‖-HIntegral f (-X) c (-T) + HIntegral f (-X) c T + VIntegral f (-X) (-T) T‖
          ≤ ‖-HIntegral f (-X) c (-T) + HIntegral f (-X) c T‖ + ‖VIntegral f (-X) (-T) T‖ :=
            norm_add_le _ _
        _ ≤ ‖HIntegral f (-X) c (-T)‖ + ‖HIntegral f (-X) c T‖ + ‖VIntegral f (-X) (-T) T‖ := by
            have hn := norm_add_le (-HIntegral f (-X) c (-T)) (HIntegral f (-X) c T)
            rw [norm_neg] at hn
            linarith
        _ ≤ 2 * A + 2 * T * y ^ (-X) := by linarith [hVX]
    exact mul_le_mul_of_nonneg_left htri (by positivity)
  -- limit along the naturals
  have hfin : ‖VIntegral' f c (-T) T - 1‖ ≤ 1 / (2 * Real.pi) * (2 * A) := by
    have hinv1 : y⁻¹ < 1 := by
      rw [inv_lt_one₀ hy]
      exact hygt
    have hpow : Filter.Tendsto (fun n : ℕ ↦ y ^ (-(n : ℝ))) Filter.atTop (𝓝 0) := by
      have h := tendsto_pow_atTop_nhds_zero_of_lt_one (by positivity : (0:ℝ) ≤ y⁻¹) hinv1
      refine h.congr fun n ↦ ?_
      rw [inv_pow, ← Real.rpow_natCast y n, ← Real.rpow_neg hy.le]
    have hlim : Filter.Tendsto
        (fun n : ℕ ↦ 1 / (2 * Real.pi) * (2 * A + 2 * T * y ^ (-(n : ℝ))))
        Filter.atTop (𝓝 (1 / (2 * Real.pi) * (2 * A + 2 * T * 0))) :=
      Filter.Tendsto.const_mul _
        (Filter.Tendsto.const_add _ (Filter.Tendsto.const_mul _ hpow))
    have hev : ∀ᶠ n : ℕ in Filter.atTop,
        ‖VIntegral' f c (-T) T - 1‖ ≤ 1 / (2 * Real.pi) * (2 * A + 2 * T * y ^ (-(n : ℝ))) := by
      filter_upwards [Filter.eventually_ge_atTop 1] with n hn
      exact key (n : ℝ) (by exact_mod_cast hn)
    have := ge_of_tendsto hlim hev
    simpa using this
  calc ‖VIntegral' f c (-T) T - 1‖
      ≤ 1 / (2 * Real.pi) * (2 * A) := hfin
    _ = A / Real.pi := by ring
    _ ≤ A / 1 := div_le_div_of_nonneg_left hA0.le one_pos (by linarith [Real.pi_gt_three])
    _ = y ^ c / (T * |Real.log y|) := by rw [div_one, hAdef]

/-- **K2 — the decay branch**, assembled from its two cases. -/
theorem perron_kernel_decay {y c T : ℝ} (hy : 0 < y) (hy1 : y ≠ 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) := by
  rcases lt_or_gt_of_ne hy1 with h | h
  · exact perron_kernel_decay_lt hy h hc hT
  · exact perron_kernel_decay_gt h hc hT

/-- The elementary two-variable inequality behind K1's `y > 1` case, in
multiplied (division-free) form: for `u = c·log y > 0`, `v = T·log y ∈ (0,1]`,
`v·e^u + π − arctan(v/u) ≤ π·e^u`. -/
theorem coarse_gt_ineq {u v : ℝ} (hu : 0 < u) (hv0 : 0 < v) (hv1 : v ≤ 1) :
    v * Real.exp u + Real.pi - Real.arctan (v / u) ≤ Real.pi * Real.exp u := by
  have hπ2 : (3.14 : ℝ) < Real.pi := Real.pi_gt_d2
  have hexp : 1 + u ≤ Real.exp u := by linarith [Real.add_one_le_exp u]
  have hE1 : (1:ℝ) ≤ Real.exp u := by nlinarith
  have harct0 : 0 ≤ Real.arctan (v / u) := Real.arctan_nonneg.mpr (by positivity)
  by_cases hvu : v ≤ u
  · by_cases hu1 : u ≤ Real.pi - 1
    · nlinarith [mul_le_mul_of_nonneg_right hexp (by linarith : (0:ℝ) ≤ Real.pi - v)]
    · push_neg at hu1
      nlinarith [mul_le_mul_of_nonneg_right hexp (by linarith : (0:ℝ) ≤ Real.pi - v)]
  · push_neg at hvu
    have hq1 : (1:ℝ) < v / u := (one_lt_div hu).mpr hvu
    have harc4 : Real.pi / 4 ≤ Real.arctan (v / u) := by
      rw [← Real.arctan_one]
      exact Real.arctan_le_arctan_iff.mpr hq1.le
    by_cases hv2 : v ≤ 1/2
    · nlinarith
    · push_neg at hv2
      by_cases hu3 : (3/20 : ℝ) ≤ u
      · nlinarith [mul_le_mul_of_nonneg_right hexp (by linarith : (0:ℝ) ≤ Real.pi - v)]
      · push_neg at hu3
        have hq : (10:ℝ)/3 ≤ v / u := by
          have h1 : (10:ℝ)/3 * u ≤ v := by nlinarith
          calc (10:ℝ)/3 = ((10:ℝ)/3 * u) / u := by field_simp
            _ ≤ v / u := div_le_div_of_nonneg_right h1 hu.le
        have harc : Real.pi / 2 - 3/10 ≤ Real.arctan (v / u) := by
          have hmono : Real.arctan ((10:ℝ)/3) ≤ Real.arctan (v / u) :=
            Real.arctan_le_arctan_iff.mpr hq
          have hself : Real.arctan ((3:ℝ)/10) ≤ (3:ℝ)/10 := by
            have h3 : (0:ℝ) < Real.arctan ((3:ℝ)/10) :=
              Real.arctan_pos.mpr (by norm_num)
            have h4 := Real.lt_tan h3 (Real.arctan_lt_pi_div_two _)
            rw [Real.tan_arctan] at h4
            exact h4.le
          have h5 : Real.arctan ((10:ℝ)/3) = Real.pi / 2 - Real.arctan ((3:ℝ)/10) := by
            have h := Real.arctan_inv_of_pos (show (0:ℝ) < 3/10 by norm_num)
            rw [show ((3:ℝ)/10)⁻¹ = (10:ℝ)/3 by norm_num] at h
            exact h
          linarith
        nlinarith

/-- The segment integral of `1/s`: pure real calculus — the odd part cancels
by its antiderivative, the even part is the arctan derivative. -/
theorem seg_inv_integral {c T : ℝ} (hc : 0 < c) :
    (∫ t in (-T)..T, ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I)
      = 2 * Real.arctan (T / c) * Complex.I := by
  have hD : ∀ t : ℝ, (0:ℝ) < c^2 + t^2 := fun t ↦ by positivity
  have hsplit : ∀ t : ℝ, ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I
      = ((t / (c^2 + t^2) : ℝ) : ℂ) + ((c / (c^2 + t^2) : ℝ) : ℂ) * Complex.I := by
    intro t
    have hne : ((c : ℂ) + Complex.I * t) ≠ 0 := by
      intro h
      have hre := congrArg Complex.re h
      simp at hre
      linarith
    have hD' : ((c:ℂ)^2 + (t:ℂ)^2) ≠ 0 := by
      have : (((c^2 + t^2 : ℝ)) : ℂ) ≠ 0 := by exact_mod_cast (hD t).ne'
      push_cast at this
      exact this
    rw [inv_mul_eq_div, div_eq_iff hne]
    push_cast
    linear_combination (-((c:ℂ) * (t:ℂ) / ((c:ℂ)^2 + (t:ℂ)^2))) * Complex.I_sq
      + (-Complex.I) * (mul_inv_cancel₀ hD')
  have hcont_odd : Continuous fun t : ℝ ↦ t / (c^2 + t^2) := by
    fun_prop (disch := intro t; exact (hD t).ne')
  have hcont_even : Continuous fun t : ℝ ↦ c / (c^2 + t^2) := by
    fun_prop (disch := intro t; exact (hD t).ne')
  have hodd : (∫ t in (-T)..T, t / (c^2 + t^2)) = 0 := by
    have hF : ∀ t : ℝ, HasDerivAt (fun t : ℝ ↦ (1/2) * Real.log (c^2 + t^2))
        (t / (c^2 + t^2)) t := by
      intro t
      have h1 : HasDerivAt (fun t : ℝ ↦ c^2 + t^2) (2*t) t := by
        simpa using ((hasDerivAt_id t).pow 2).const_add (c^2)
      have h2 := h1.log (hD t).ne'
      have h3 := h2.const_mul (1/2 : ℝ)
      have hval : 1/2 * (2*t / (c^2 + t^2)) = t / (c^2 + t^2) := by
        field_simp [(hD t).ne']
        try ring
      rw [hval] at h3
      exact h3
    rw [intervalIntegral.integral_eq_sub_of_hasDerivAt (fun t _ ↦ hF t)
      (hcont_odd.intervalIntegrable _ _)]
    ring_nf
  have heven : (∫ t in (-T)..T, c / (c^2 + t^2)) = 2 * Real.arctan (T / c) := by
    have hF : ∀ t : ℝ, HasDerivAt (fun t : ℝ ↦ Real.arctan (t / c))
        (c / (c^2 + t^2)) t := by
      intro t
      have h1 : HasDerivAt (fun t : ℝ ↦ t / c) (1/c) t := (hasDerivAt_id t).div_const c
      have h2 := (Real.hasDerivAt_arctan (t/c)).comp t h1
      have hval : 1 / (1 + (t/c)^2) * (1/c) = c / (c^2 + t^2) := by
        field_simp [(hD t).ne', hc.ne']
        try ring
      rw [hval] at h2
      exact h2
    rw [intervalIntegral.integral_eq_sub_of_hasDerivAt (fun t _ ↦ hF t)
      (hcont_even.intervalIntegrable _ _)]
    rw [show (-T)/c = -(T/c) by ring, Real.arctan_neg]
    ring
  have hi1 : IntervalIntegrable (fun t : ℝ ↦ ((t / (c^2 + t^2) : ℝ) : ℂ))
      MeasureTheory.volume (-T) T :=
    (Complex.continuous_ofReal.comp hcont_odd).intervalIntegrable _ _
  have hi2 : IntervalIntegrable (fun t : ℝ ↦ ((c / (c^2 + t^2) : ℝ) : ℂ) * Complex.I)
      MeasureTheory.volume (-T) T :=
    ((Complex.continuous_ofReal.comp hcont_even).mul continuous_const).intervalIntegrable _ _
  calc (∫ t in (-T)..T, ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I)
      = ∫ t in (-T)..T, (((t / (c^2 + t^2) : ℝ) : ℂ)
          + ((c / (c^2 + t^2) : ℝ) : ℂ) * Complex.I) := by
        apply intervalIntegral.integral_congr
        intro t _
        exact hsplit t
    _ = (∫ t in (-T)..T, ((t / (c^2 + t^2) : ℝ) : ℂ))
          + ∫ t in (-T)..T, ((c / (c^2 + t^2) : ℝ) : ℂ) * Complex.I :=
        intervalIntegral.integral_add hi1 hi2
    _ = 2 * Real.arctan (T / c) * Complex.I := by
        rw [intervalIntegral.integral_mul_const, intervalIntegral.integral_ofReal,
          intervalIntegral.integral_ofReal, hodd, heven]
        push_cast
        ring

/-- Mean-value bound: `‖y^s − 1‖ ≤ ‖s‖·log y·y^(re s)` for `y > 1`. -/
theorem cpow_sub_one_bound {y : ℝ} (hygt : 1 < y) {s : ℂ} (hre : 0 ≤ s.re) :
    ‖(y : ℂ) ^ s - 1‖ ≤ ‖s‖ * Real.log y * y ^ s.re := by
  have hy : (0:ℝ) < y := lt_trans one_pos hygt
  have hy0 : (y : ℂ) ≠ 0 := by exact_mod_cast hy.ne'
  have hL0 : (0:ℝ) ≤ Real.log y := Real.log_nonneg hygt.le
  set w : ℂ := s * ((Real.log y : ℝ) : ℂ) with hwdef
  have hg : ∀ τ : ℝ, HasDerivAt (fun τ : ℝ ↦ Complex.exp ((τ : ℝ) • w))
      (w * Complex.exp ((τ : ℝ) • w)) τ := by
    intro τ
    have h1 : HasDerivAt (fun τ : ℝ ↦ (τ : ℝ) • w) w τ := by
      simpa using (hasDerivAt_id τ).smul_const w
    have h2 := h1.cexp
    simpa [mul_comm] using h2
  have hInt : IntervalIntegrable (fun τ : ℝ ↦ w * Complex.exp ((τ : ℝ) • w))
      MeasureTheory.volume 0 1 := by
    apply Continuous.intervalIntegrable
    fun_prop
  have hgsub : Complex.exp ((1:ℝ) • w) - Complex.exp ((0:ℝ) • w)
      = ∫ τ in (0:ℝ)..1, w * Complex.exp ((τ : ℝ) • w) :=
    (intervalIntegral.integral_eq_sub_of_hasDerivAt (fun τ _ ↦ hg τ) hInt).symm
  have hend : (y : ℂ) ^ s - 1 = Complex.exp ((1:ℝ) • w) - Complex.exp ((0:ℝ) • w) := by
    rw [one_smul, zero_smul, Complex.exp_zero, hwdef,
      Complex.cpow_def_of_ne_zero hy0, Complex.ofReal_log hy.le]
    congr 2
    ring
  rw [hend, hgsub]
  have hbound : ∀ τ ∈ Set.uIoc (0:ℝ) 1, ‖w * Complex.exp ((τ : ℝ) • w)‖
      ≤ ‖s‖ * Real.log y * y ^ s.re := by
    intro τ hτ
    rw [Set.uIoc_of_le zero_le_one] at hτ
    have hτ0 : 0 ≤ τ := hτ.1.le
    have hτ1 : τ ≤ 1 := hτ.2
    rw [norm_mul, Complex.norm_exp]
    have hw : ‖w‖ = ‖s‖ * Real.log y := by
      rw [hwdef, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hL0]
    have hrew : ((τ : ℝ) • w).re = τ * (Real.log y * s.re) := by
      rw [hwdef, Complex.real_smul]
      simp only [Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im]
      ring
    rw [hw, hrew]
    have hexp : Real.exp (τ * (Real.log y * s.re)) ≤ y ^ s.re := by
      rw [Real.rpow_def_of_pos hy]
      apply Real.exp_le_exp.mpr
      nlinarith [mul_nonneg hL0 hre]
    have h0 : (0:ℝ) ≤ ‖s‖ * Real.log y := by positivity
    exact mul_le_mul_of_nonneg_left hexp h0
  calc ‖∫ τ in (0:ℝ)..1, w * Complex.exp ((τ : ℝ) • w)‖
      ≤ ‖s‖ * Real.log y * y ^ s.re * |1 - 0| :=
        intervalIntegral.norm_integral_le_of_norm_le_const hbound
    _ = ‖s‖ * Real.log y * y ^ s.re := by norm_num

/-- **K1, case `y > 1`.** For `T·log y ≥ 1` this is the decay branch; below
that, split off the exact `∫ ds/s`, mean-value the rest, and close with
`coarse_gt_ineq`. -/
theorem perron_kernel_coarse_gt {y c T : ℝ} (hygt : 1 < y)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c := by
  have hy : (0:ℝ) < y := lt_trans one_pos hygt
  have hT0 : (0:ℝ) < T := lt_of_lt_of_le one_pos hT
  have hL0 : (0:ℝ) < Real.log y := Real.log_pos hygt
  have hyc : (0:ℝ) < y ^ c := Real.rpow_pos_of_pos hy c
  by_cases hbig : 1 ≤ T * |Real.log y|
  · calc ‖perronI y c T - perronδ y‖
        ≤ y ^ c / (T * |Real.log y|) := perron_kernel_decay_gt hygt hc hT
      _ ≤ y ^ c / 1 := div_le_div_of_nonneg_left hyc.le one_pos hbig
      _ = y ^ c := div_one _
  · push_neg at hbig
    have hsmall : T * Real.log y < 1 := by
      have := hbig
      rwa [abs_of_pos hL0] at this
    have hδ : perronδ y = 1 := by rw [perronδ, if_pos hygt]
    rw [hδ]
    have hsne : ∀ t : ℝ, ((c : ℂ) + Complex.I * t) ≠ 0 := by
      intro t h
      have hre := congrArg Complex.re h
      simp at hre
      linarith
    have hker : ∀ t : ℝ, (y : ℂ) ^ ((c : ℂ) + Complex.I * t) / ((c : ℂ) + Complex.I * t)
          * Complex.I
        = ((y : ℂ) ^ ((c : ℂ) + Complex.I * t) - 1) / ((c : ℂ) + Complex.I * t) * Complex.I
          + ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I := by
      intro t
      field_simp
      try ring_nf
    have hcont1 : Continuous fun t : ℝ ↦
        ((y : ℂ) ^ ((c : ℂ) + Complex.I * t) - 1) / ((c : ℂ) + Complex.I * t) * Complex.I := by
      apply Continuous.mul _ continuous_const
      apply Continuous.div
      · apply Continuous.sub _ continuous_const
        apply Continuous.const_cpow
        · fun_prop
        · exact Or.inl (by exact_mod_cast hy.ne')
      · fun_prop
      · exact hsne
    have hcont2 : Continuous fun t : ℝ ↦ ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I := by
      apply Continuous.mul _ continuous_const
      exact Continuous.inv₀ (by fun_prop) hsne
    have hint : (∫ t in (-T)..T,
          (y : ℂ) ^ ((c : ℂ) + Complex.I * t) / ((c : ℂ) + Complex.I * t) * Complex.I)
        = (∫ t in (-T)..T,
            ((y : ℂ) ^ ((c : ℂ) + Complex.I * t) - 1) / ((c : ℂ) + Complex.I * t) * Complex.I)
          + ∫ t in (-T)..T, ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I := by
      rw [← intervalIntegral.integral_add (hcont1.intervalIntegrable _ _)
        (hcont2.intervalIntegrable _ _)]
      apply intervalIntegral.integral_congr
      intro t _
      exact hker t
    rw [perronI, hint, seg_inv_integral hc]
    set Aint : ℂ := ∫ t in (-T)..T,
      ((y : ℂ) ^ ((c : ℂ) + Complex.I * t) - 1) / ((c : ℂ) + Complex.I * t) * Complex.I
      with hAdef
    have hπ0 : (0:ℝ) < Real.pi := Real.pi_pos
    have hπC : ((Real.pi : ℝ) : ℂ) ≠ 0 := by
      exact_mod_cast Real.pi_ne_zero
    have hsplit2 : (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * (Aint + 2 * Real.arctan (T/c) * Complex.I)
          - 1
        = (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * Aint
          + (((Real.arctan (T/c) / Real.pi - 1 : ℝ)) : ℂ) := by
      push_cast
      field_simp
      try ring
    rw [hsplit2]
    have harclt : Real.arctan (T/c) < Real.pi / 2 := Real.arctan_lt_pi_div_two _
    have harc0 : 0 ≤ Real.arctan (T/c) := Real.arctan_nonneg.mpr (by positivity)
    have hAbound : ‖Aint‖ ≤ 2 * T * Real.log y * y ^ c := by
      rw [hAdef]
      have hpt : ∀ t ∈ Set.uIoc (-T) T,
          ‖((y : ℂ) ^ ((c : ℂ) + Complex.I * t) - 1) / ((c : ℂ) + Complex.I * t) * Complex.I‖
          ≤ Real.log y * y ^ c := by
        intro t _
        rw [norm_mul, Complex.norm_I, mul_one, norm_div]
        have hre : ((c : ℂ) + Complex.I * t).re = c := by simp
        have hnum := cpow_sub_one_bound hygt (s := (c : ℂ) + Complex.I * t)
          (by rw [hre]; exact hc.le)
        rw [hre] at hnum
        have hden : (0:ℝ) < ‖(c : ℂ) + Complex.I * t‖ :=
          norm_pos_iff.mpr (hsne t)
        calc ‖(y : ℂ) ^ ((c : ℂ) + Complex.I * t) - 1‖ / ‖(c : ℂ) + Complex.I * t‖
            ≤ ‖(c : ℂ) + Complex.I * t‖ * Real.log y * y ^ c
                / ‖(c : ℂ) + Complex.I * t‖ :=
              div_le_div_of_nonneg_right hnum hden.le
          _ = Real.log y * y ^ c := by field_simp
      calc ‖∫ t in (-T)..T,
            ((y : ℂ) ^ ((c : ℂ) + Complex.I * t) - 1) / ((c : ℂ) + Complex.I * t) * Complex.I‖
          ≤ Real.log y * y ^ c * |T - (-T)| :=
            intervalIntegral.norm_integral_le_of_norm_le_const hpt
        _ = 2 * T * Real.log y * y ^ c := by
            rw [show T - (-T) = 2*T by ring, abs_of_pos (by linarith)]
            ring
    have hnorm1 : ‖(2 * (Real.pi:ℂ) * Complex.I)⁻¹ * Aint‖
        ≤ T * Real.log y / Real.pi * y ^ c := by
      rw [norm_mul, norm_inv]
      have h2π : ‖2 * (Real.pi:ℂ) * Complex.I‖ = 2 * Real.pi := by
        rw [norm_mul, norm_mul, Complex.norm_I, mul_one]
        simp [abs_of_pos Real.pi_pos]
      rw [h2π]
      calc (2 * Real.pi)⁻¹ * ‖Aint‖
          ≤ (2 * Real.pi)⁻¹ * (2 * T * Real.log y * y ^ c) := by
            apply mul_le_mul_of_nonneg_left hAbound
            positivity
        _ = T * Real.log y / Real.pi * y ^ c := by
            field_simp
            try ring
    have hnorm2 : ‖(((Real.arctan (T/c) / Real.pi - 1 : ℝ)) : ℂ)‖
        = 1 - Real.arctan (T/c) / Real.pi := by
      have hle : Real.arctan (T/c) / Real.pi - 1 ≤ 0 := by
        have h1 : Real.arctan (T/c) / Real.pi ≤ 1 := by
          rw [div_le_one hπ0]
          linarith
        linarith
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonpos hle]
      ring
    calc ‖(2 * (Real.pi:ℂ) * Complex.I)⁻¹ * Aint
          + (((Real.arctan (T/c) / Real.pi - 1 : ℝ)) : ℂ)‖
        ≤ ‖(2 * (Real.pi:ℂ) * Complex.I)⁻¹ * Aint‖
          + ‖(((Real.arctan (T/c) / Real.pi - 1 : ℝ)) : ℂ)‖ := norm_add_le _ _
      _ ≤ T * Real.log y / Real.pi * y ^ c + (1 - Real.arctan (T/c) / Real.pi) := by
          rw [hnorm2]
          linarith [hnorm1]
      _ ≤ y ^ c := by
          set u : ℝ := c * Real.log y with hudef
          set v : ℝ := T * Real.log y with hvdef
          have hu0 : 0 < u := by rw [hudef]; positivity
          have hv0 : 0 < v := by rw [hvdef]; positivity
          have hv1 : v ≤ 1 := by rw [hvdef]; linarith
          have hyc_exp : y ^ c = Real.exp u := by
            rw [hudef, Real.rpow_def_of_pos hy]
            ring_nf
          have hTc : T / c = v / u := by
            rw [hvdef, hudef]
            field_simp
          have hmain := coarse_gt_ineq hu0 hv0 hv1
          rw [hyc_exp, hTc]
          have hgoal : (v * Real.exp u + Real.pi - Real.arctan (v/u)) / Real.pi
              ≤ (Real.pi * Real.exp u) / Real.pi :=
            div_le_div_of_nonneg_right hmain hπ0.le
          calc v / Real.pi * Real.exp u + (1 - Real.arctan (v/u) / Real.pi)
              = (v * Real.exp u + Real.pi - Real.arctan (v/u)) / Real.pi := by
                field_simp
                ring
            _ ≤ (Real.pi * Real.exp u) / Real.pi := hgoal
            _ = Real.exp u := by
                field_simp

/-- **K1 — the coarse branch**, assembled from its two cases. -/
theorem perron_kernel_coarse {y c T : ℝ} (hy : 0 < y) (hy1 : y ≠ 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c := by
  rcases lt_or_gt_of_ne hy1 with h | h
  · exact perron_kernel_coarse_lt hy h hc hT
  · exact perron_kernel_coarse_gt h hc hT

/-- **Slice 1a — the truncated Perron kernel bound.** Assembled from K1
and K2; the two branches are the whole of the missing mathematics. -/
theorem perron_kernel_truncated {y c T : ℝ} (hy : 0 < y) (hy1 : y ≠ 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c * min 1 (1 / (T * |Real.log y|)) := by
  rcases le_total (1 : ℝ) (1 / (T * |Real.log y|)) with h | h
  · rw [min_eq_left h, mul_one]
    exact perron_kernel_coarse hy hy1 hc hT
  · rw [min_eq_right h]
    calc ‖perronI y c T - perronδ y‖
        ≤ y ^ c / (T * |Real.log y|) := perron_kernel_decay hy hy1 hc hT
      _ = y ^ c * (1 / (T * |Real.log y|)) := by ring


/-! ### Slice 1b — the far-terms sum (entry 257's build order)

`Σ_{|log(x/n)| ≥ 1/2} Λ(n)·(x/n)^c/(T·|log(x/n)|) ≤ 300·x·log(xT)²/T` at
`c = 1 + 1/log x`. The range condition buys `1/(T|log|) ≤ 2/T`; the rest is
`x^c = e·x` times `Σ Λ(n)/n^c`, bounded by dyadic blocks under Chebyshev's
`ψ ≤ (log 4 + 4)·t` against a geometric tail, with `1/(1−2^(1−c)) ≤ 5·log x`. -/

/-- Geometric-denominator bound: `δ/5 ≤ 1 − 2^(−δ)` for `0 < δ ≤ 1`. -/
theorem one_sub_two_neg_rpow {δ : ℝ} (h0 : 0 < δ) (h1 : δ ≤ 1) :
    δ / 5 ≤ 1 - (2:ℝ) ^ (-δ) := by
  have hlog2 : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hrw : (2:ℝ) ^ (-δ) = Real.exp (-(δ * Real.log 2)) := by
    rw [Real.rpow_def_of_pos two_pos,
      show Real.log 2 * (-δ) = -(δ * Real.log 2) by ring]
  rw [hrw]
  set a : ℝ := δ * Real.log 2 with ha
  have ha0 : 0 < a := by rw [ha]; nlinarith
  have ha1 : a ≤ Real.log 2 := by rw [ha]; nlinarith
  have hEF : Real.exp a * Real.exp (-a) = 1 := by
    rw [← Real.exp_add]
    simp
  have hexp1 : 1 + a ≤ Real.exp a := by linarith [Real.add_one_le_exp a]
  have hF0 : 0 < Real.exp (-a) := Real.exp_pos _
  have hE2 : Real.exp a ≤ 2 := by
    calc Real.exp a ≤ Real.exp (Real.log 2) := Real.exp_le_exp.mpr ha1
      _ = 2 := Real.exp_log two_pos
  have hFa : (1 + a) * Real.exp (-a) ≤ 1 := by
    calc (1 + a) * Real.exp (-a) ≤ Real.exp a * Real.exp (-a) :=
          mul_le_mul_of_nonneg_right hexp1 hF0.le
      _ = 1 := hEF
  have hFhalf : (1:ℝ)/2 ≤ Real.exp (-a) := by nlinarith
  nlinarith [mul_le_mul_of_nonneg_left hFhalf ha0.le]

/-- The dyadic partial-sum bound: any finite piece of `Σ Λ(n)·n^(−c)` sits
under `2(log 4 + 4)/(1 − 2^(1−c))`. -/
theorem vonMangoldt_rpow_partial {c : ℝ} (hc1 : 1 < c) (s : Finset ℕ) :
    ∑ n ∈ s, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c)
      ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) := by
  set K : ℝ := Real.log 4 + 4 with hK
  have hK0 : (0:ℝ) < K := by rw [hK]; positivity
  set q : ℝ := (2:ℝ) ^ (1 - c) with hq
  have hq0 : (0:ℝ) < q := Real.rpow_pos_of_pos two_pos _
  have hq1 : q < 1 := by
    rw [hq]
    exact Real.rpow_lt_one_of_one_lt_of_neg one_lt_two (by linarith)
  have hfnn : ∀ n : ℕ, (0:ℝ) ≤ ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) :=
    fun n ↦ mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
      (Real.rpow_nonneg (Nat.cast_nonneg n) _)
  obtain ⟨m, hm⟩ := s.exists_nat_subset_range
  have hsub : s ⊆ Finset.range (2^m) := by
    intro n hn
    have h1 := hm hn
    rw [Finset.mem_range] at h1 ⊢
    exact lt_of_lt_of_le h1 (Nat.le_of_lt m.lt_two_pow_self)
  have hstep : ∀ M : ℕ, ∑ n ∈ Finset.range (2^M),
      ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c)
      ≤ ∑ k ∈ Finset.range M, 2 * K * q ^ k := by
    intro M
    induction M with
    | zero => simp
    | succ M ih =>
      have hle2 : (2:ℕ)^M ≤ 2^(M+1) := Nat.pow_le_pow_right (by norm_num) (Nat.le_succ M)
      have hψ : ∑ n ∈ Finset.Ico (2^M) (2^(M+1)), ArithmeticFunction.vonMangoldt n
          ≤ K * (2:ℝ)^(M+1) := by
        have hsub2 : Finset.Ico ((2:ℕ)^M) (2^(M+1)) ⊆ Finset.Ioc 0 (2^(M+1)) := by
          intro n hn
          rw [Finset.mem_Ico] at hn
          rw [Finset.mem_Ioc]
          exact ⟨lt_of_lt_of_le (pow_pos (by norm_num) M) hn.1, hn.2.le⟩
        calc ∑ n ∈ Finset.Ico ((2:ℕ)^M) (2^(M+1)), ArithmeticFunction.vonMangoldt n
            ≤ ∑ n ∈ Finset.Ioc 0 (2^(M+1)), ArithmeticFunction.vonMangoldt n :=
              Finset.sum_le_sum_of_subset_of_nonneg hsub2
                (fun n _ _ ↦ ArithmeticFunction.vonMangoldt_nonneg)
          _ = Chebyshev.psi (((2:ℕ)^(M+1) : ℕ) : ℝ) := by
              rw [Chebyshev.psi, Nat.floor_natCast]
          _ ≤ K * (((2:ℕ)^(M+1) : ℕ) : ℝ) := by
              rw [hK]
              exact Chebyshev.psi_le_const_mul_self (by positivity)
          _ = K * (2:ℝ)^(M+1) := by push_cast; ring
      have hcast : (((2:ℕ)^M : ℕ) : ℝ) = (2:ℝ)^M := by push_cast; ring
      have heq : (2:ℝ)^(M+1) * ((2:ℝ)^M)^(-c) = 2 * q ^ M := by
        have h1 : ((2:ℝ)^M)^(-c) = (2:ℝ) ^ ((M:ℝ) * (-c)) := by
          rw [← Real.rpow_natCast (2:ℝ) M, ← Real.rpow_mul two_pos.le]
        have h2 : q ^ M = (2:ℝ) ^ ((1-c) * (M:ℝ)) := by
          rw [hq, ← Real.rpow_natCast ((2:ℝ)^(1-c)) M, ← Real.rpow_mul two_pos.le]
        have h3 : (2:ℝ)^(M+1) = (2:ℝ) ^ (((M+1:ℕ)):ℝ) := by
          rw [Real.rpow_natCast]
        rw [h1, h2, h3, ← Real.rpow_add two_pos, mul_comm (2:ℝ) ((2:ℝ) ^ ((1-c) * (M:ℝ))),
          ← Real.rpow_add_one two_ne_zero]
        congr 1
        push_cast
        ring
      have hblock : ∑ n ∈ Finset.Ico ((2:ℕ)^M) (2^(M+1)),
          ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c) ≤ 2 * K * q ^ M := by
        have h1 : ∀ n ∈ Finset.Ico ((2:ℕ)^M) (2^(M+1)),
            ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)
            ≤ ArithmeticFunction.vonMangoldt n * (((2:ℕ)^M : ℕ):ℝ)^(-c) := by
          intro n hn
          apply mul_le_mul_of_nonneg_left _ ArithmeticFunction.vonMangoldt_nonneg
          apply Real.rpow_le_rpow_of_nonpos (by positivity) _ (by linarith)
          exact_mod_cast (Finset.mem_Ico.mp hn).1
        calc ∑ n ∈ Finset.Ico ((2:ℕ)^M) (2^(M+1)),
              ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)
            ≤ ∑ n ∈ Finset.Ico ((2:ℕ)^M) (2^(M+1)),
              ArithmeticFunction.vonMangoldt n * (((2:ℕ)^M : ℕ):ℝ)^(-c) :=
              Finset.sum_le_sum h1
          _ = (∑ n ∈ Finset.Ico ((2:ℕ)^M) (2^(M+1)),
              ArithmeticFunction.vonMangoldt n) * (((2:ℕ)^M : ℕ):ℝ)^(-c) := by
              rw [← Finset.sum_mul]
          _ ≤ (K * (2:ℝ)^(M+1)) * (((2:ℕ)^M : ℕ):ℝ)^(-c) := by
              apply mul_le_mul_of_nonneg_right hψ
              exact Real.rpow_nonneg (by positivity) _
          _ = 2 * K * q ^ M := by
              rw [hcast, mul_assoc, heq]
              ring
      calc ∑ n ∈ Finset.range ((2:ℕ)^(M+1)),
            ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)
          = (∑ n ∈ Finset.range ((2:ℕ)^M),
              ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c))
            + ∑ n ∈ Finset.Ico ((2:ℕ)^M) (2^(M+1)),
              ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c) := by
            rw [Finset.range_eq_Ico, Finset.range_eq_Ico,
              Finset.sum_Ico_consecutive _ (Nat.zero_le ((2:ℕ)^M)) hle2]
        _ ≤ (∑ k ∈ Finset.range M, 2*K*q^k) + 2*K*q^M := add_le_add ih hblock
        _ = ∑ k ∈ Finset.range (M+1), 2*K*q^k := (Finset.sum_range_succ _ M).symm
  calc ∑ n ∈ s, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c)
      ≤ ∑ n ∈ Finset.range (2^m), ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) :=
        Finset.sum_le_sum_of_subset_of_nonneg hsub (fun n _ _ ↦ hfnn n)
    _ ≤ ∑ k ∈ Finset.range m, 2 * K * q ^ k := hstep m
    _ = 2 * K * ∑ k ∈ Finset.range m, q ^ k := by rw [Finset.mul_sum]
    _ ≤ 2 * K * (1 - q)⁻¹ := by
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        calc ∑ k ∈ Finset.range m, q ^ k
            ≤ ∑' k : ℕ, q ^ k :=
              (summable_geometric_of_lt_one hq0.le hq1).sum_le_tsum _
                (fun k _ ↦ by positivity)
          _ = (1 - q)⁻¹ := tsum_geometric_of_lt_one hq0.le hq1
    _ = 2 * K / (1 - q) := by rw [div_eq_mul_inv]

/-- The full sum, as a tsum. -/
theorem vonMangoldt_rpow_tsum {c : ℝ} (hc1 : 1 < c) :
    ∑' n : ℕ, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c)
      ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) :=
  Real.tsum_le_of_sum_le
    (fun n ↦ mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
      (Real.rpow_nonneg (Nat.cast_nonneg n) _))
    (vonMangoldt_rpow_partial hc1)

theorem vonMangoldt_rpow_summable {c : ℝ} (hc1 : 1 < c) :
    Summable (fun n : ℕ ↦ ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c)) :=
  summable_of_sum_le
    (fun n ↦ mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
      (Real.rpow_nonneg (Nat.cast_nonneg n) _))
    (vonMangoldt_rpow_partial hc1)

/-- **Slice 1b — the far-terms sum.** -/
theorem far_terms_sum {x T : ℝ} (hx : 16 ≤ x) (hT : 1 ≤ T) :
    (∑' n : ℕ, if 1/2 ≤ |Real.log (x / n)| then
        ArithmeticFunction.vonMangoldt n * (x / n) ^ (1 + 1/Real.log x)
          / (T * |Real.log (x / n)|)
      else 0)
      ≤ 300 * x * Real.log (x * T) ^ 2 / T := by
  have hx0 : (0:ℝ) < x := by linarith
  have hT0 : (0:ℝ) < T := lt_of_lt_of_le one_pos hT
  have hexp16 : Real.exp 1 < 16 := by
    have := Real.exp_one_lt_d9
    linarith
  have hlx : 1 < Real.log x := by
    have h1 : Real.log (Real.exp 1) < Real.log x :=
      Real.log_lt_log (Real.exp_pos 1) (lt_of_lt_of_le hexp16 hx)
    rwa [Real.log_exp] at h1
  have hlx0 : (0:ℝ) < Real.log x := by linarith
  set δ : ℝ := 1 / Real.log x with hδ
  have hδ0 : 0 < δ := by rw [hδ]; positivity
  have hδ1 : δ ≤ 1 := by
    rw [hδ]
    rw [div_le_one hlx0]
    linarith
  set c : ℝ := 1 + δ with hc
  have hc1 : 1 < c := by rw [hc]; linarith
  have hq : (2:ℝ) ^ (1 - c) = (2:ℝ) ^ (-δ) := by
    rw [hc]
    ring_nf
  have hxc : x ^ c = Real.exp 1 * x := by
    rw [hc, Real.rpow_add hx0, Real.rpow_one, hδ, Real.rpow_def_of_pos hx0,
      mul_one_div, div_self hlx0.ne']
    ring
  -- pointwise majorisation
  have hpt : ∀ n : ℕ, (if 1/2 ≤ |Real.log (x / n)| then
      ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|) else 0)
      ≤ (2 * Real.exp 1 * x / T) * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) := by
    intro n
    by_cases h : 1/2 ≤ |Real.log (x / n)|
    · rw [if_pos h]
      rcases Nat.eq_zero_or_pos n with rfl | hn
      · exfalso
        rw [Nat.cast_zero, div_zero, Real.log_zero, abs_zero] at h
        linarith
      · have hn0 : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn
        have hdiv : (x / n) ^ c = x ^ c * (n:ℝ) ^ (-c) := by
          rw [Real.div_rpow hx0.le hn0.le, Real.rpow_neg hn0.le, div_eq_mul_inv]
        have hnum0 : (0:ℝ) ≤ ArithmeticFunction.vonMangoldt n * (x / n) ^ c :=
          mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
            (Real.rpow_nonneg (by positivity) _)
        have hden : T / 2 ≤ T * |Real.log (x / n)| := by
          calc T / 2 = T * (1/2) := by ring
            _ ≤ T * |Real.log (x / n)| := mul_le_mul_of_nonneg_left h hT0.le
        calc ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|)
            ≤ ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T / 2) :=
              div_le_div_of_nonneg_left hnum0 (by positivity) hden
          _ = (2 / T) * (ArithmeticFunction.vonMangoldt n * (x / n) ^ c) := by
              field_simp
          _ = (2 * Real.exp 1 * x / T) * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) := by
              rw [hdiv, hxc]
              ring
    · rw [if_neg h]
      positivity
  have hg : Summable (fun n : ℕ ↦
      (2 * Real.exp 1 * x / T) * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c))) :=
    (vonMangoldt_rpow_summable hc1).mul_left _
  have hf : Summable (fun n : ℕ ↦ if 1/2 ≤ |Real.log (x / n)| then
      ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|) else 0) := by
    apply Summable.of_nonneg_of_le _ hpt hg
    intro n
    by_cases h : 1/2 ≤ |Real.log (x / n)|
    · rw [if_pos h]
      positivity
    · rw [if_neg h]
  have hq1lt : (2:ℝ) ^ (1 - c) < 1 := by
    rw [hq]
    exact Real.rpow_lt_one_of_one_lt_of_neg one_lt_two (by linarith)
  have hinv : (1 - (2:ℝ) ^ (1 - c))⁻¹ ≤ 5 * Real.log x := by
    have h5 := one_sub_two_neg_rpow hδ0 hδ1
    rw [hq]
    rw [← one_div]
    calc 1 / (1 - (2:ℝ)^(-δ)) ≤ 1 / (δ/5) :=
          one_div_le_one_div_of_le (by positivity) h5
      _ = 5 / δ := by ring
      _ = 5 * Real.log x := by
          rw [hδ]
          field_simp
  calc (∑' n : ℕ, if 1/2 ≤ |Real.log (x / n)| then
        ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|) else 0)
      ≤ ∑' n : ℕ, (2 * Real.exp 1 * x / T)
          * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) :=
        hf.tsum_le_tsum hpt hg
    _ = (2 * Real.exp 1 * x / T)
          * ∑' n : ℕ, ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c) := tsum_mul_left
    _ ≤ (2 * Real.exp 1 * x / T) * (2 * (Real.log 4 + 4) / (1 - (2:ℝ)^(1-c))) := by
        apply mul_le_mul_of_nonneg_left (vonMangoldt_rpow_tsum hc1)
        positivity
    _ ≤ (2 * Real.exp 1 * x / T) * (2 * (Real.log 4 + 4) * (5 * Real.log x)) := by
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        rw [div_eq_mul_inv]
        apply mul_le_mul_of_nonneg_left hinv
        positivity
    _ ≤ 300 * x * Real.log (x * T) ^ 2 / T := by
        have hlogx_le : Real.log x ≤ Real.log (x*T) := by
          apply Real.log_le_log hx0
          nlinarith [mul_le_mul_of_nonneg_left hT hx0.le]
        have hlogxT1 : 1 ≤ Real.log (x*T) := by
          have hex : Real.exp 1 ≤ x*T := by
            nlinarith [mul_le_mul_of_nonneg_left hT hx0.le]
          calc (1:ℝ) = Real.log (Real.exp 1) := (Real.log_exp 1).symm
            _ ≤ Real.log (x*T) := Real.log_le_log (Real.exp_pos 1) hex
        have hnum : 20 * Real.exp 1 * (Real.log 4 + 4) ≤ 300 := by
          have h1 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
          have h2 : Real.log 4 = 2 * Real.log 2 := by
            rw [show (4:ℝ) = 2^2 by norm_num, Real.log_pow]
            push_cast
            ring
          have h3 : Real.log 2 < 0.6931471808 := Real.log_two_lt_d9
          nlinarith [mul_nonneg
            (by linarith : (0:ℝ) ≤ 2.7182818286 - Real.exp 1)
            (by nlinarith : (0:ℝ) ≤ 5.3862943616 - (Real.log 4 + 4)),
            Real.exp_pos 1, Real.log_two_gt_d9]
        have hK0 : (0:ℝ) < Real.log 4 + 4 := by positivity
        have hchain : Real.log x ≤ Real.log (x*T) ^ 2 := by nlinarith
        rw [div_mul_eq_mul_div]
        apply div_le_div_of_nonneg_right _ hT0.le
        nlinarith [mul_le_mul_of_nonneg_right hnum (mul_nonneg hx0.le hlx0.le),
          mul_le_mul_of_nonneg_left hchain (by positivity : (0:ℝ) ≤ 300 * x)]

/-- info: 'PerronKernel.perron_kernel_truncated' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms perron_kernel_truncated


/-! ### Slice 1c — the near-diagonal sum (entry 257's build order)

`Σ_{0<|log(x/n)|<1/2} Λ(n)·min(1, 1/(T|log(x/n)|)) ≤ 100·x·log(xT)²/T + 4·log x`.
This is where hEF's `c₂·log x` term is born: the two integers nearest `x`
contribute `min ≤ 1` each, and everything else pays `|log(x/n)| ≥ |x−n|/(4x)`
into two harmonic sums bounded by `harmonic_le_one_add_log`. -/

/-- `|t − 1|/2 ≤ |log t|` on `[1/2, 2]`. -/
theorem abs_sub_one_le_two_abs_log {t : ℝ} (h1 : 1/2 ≤ t) (h2 : t ≤ 2) :
    |t - 1| / 2 ≤ |Real.log t| := by
  have ht0 : (0:ℝ) < t := by linarith
  by_cases ht : 1 ≤ t
  · rw [abs_of_nonneg (by linarith : (0:ℝ) ≤ t - 1),
      abs_of_nonneg (Real.log_nonneg ht)]
    have h3 : 1 - 1/t ≤ Real.log t := by
      have h4 := Real.log_le_sub_one_of_pos (show (0:ℝ) < t⁻¹ by positivity)
      rw [Real.log_inv] at h4
      rw [one_div]
      linarith
    have h6 : (t-1)/2 ≤ 1 - 1/t := by
      have he : 1 - 1/t = (t-1)/t := by field_simp
      rw [he]
      exact div_le_div_of_nonneg_left (by linarith) ht0 h2
    linarith
  · push_neg at ht
    rw [abs_of_nonpos (by linarith : t - 1 ≤ 0),
      abs_of_nonpos (Real.log_nonpos ht0.le ht.le)]
    have h3 := Real.log_le_sub_one_of_pos ht0
    linarith

/-- **Slice 1c — the near-diagonal sum.** -/
theorem near_diagonal_sum {x T : ℝ} (hx : 16 ≤ x) (hT : 1 ≤ T) :
    (∑' n : ℕ, if 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2 then
        ArithmeticFunction.vonMangoldt n * min 1 (1/(T * |Real.log (x / n)|))
      else 0)
      ≤ 100 * x * Real.log (x * T) ^ 2 / T + 4 * Real.log x := by
  have hx0 : (0:ℝ) < x := by linarith
  have hT0 : (0:ℝ) < T := lt_of_lt_of_le one_pos hT
  have hexp16 : Real.exp 1 < 16 := by linarith [Real.exp_one_lt_d9]
  have hlx : 1 < Real.log x := by
    have h1 : Real.log (Real.exp 1) < Real.log x :=
      Real.log_lt_log (Real.exp_pos 1) (lt_of_lt_of_le hexp16 hx)
    rwa [Real.log_exp] at h1
  have hlx0 : (0:ℝ) < Real.log x := by linarith
  set f : ℕ → ℝ := fun n ↦ if 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2 then
      ArithmeticFunction.vonMangoldt n * min 1 (1/(T * |Real.log (x / n)|)) else 0 with hfd
  have hfnn : ∀ n, 0 ≤ f n := by
    intro n
    rw [hfd]
    dsimp only
    by_cases h : 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2
    · rw [if_pos h]
      exact mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
        (le_min zero_le_one (by positivity))
    · rw [if_neg h]
  set N : ℕ := ⌈2*x⌉₊ with hNd
  set m : ℕ := ⌊x⌋₊ with hmd
  have hmx : (m:ℝ) ≤ x := Nat.floor_le hx0.le
  have hxm1 : x < (m:ℝ) + 1 := Nat.lt_floor_add_one x
  have hNx : 2*x ≤ (N:ℝ) := Nat.le_ceil _
  have hmN : m + 2 ≤ N := by
    have h2 : ((m + 2 : ℕ) : ℝ) ≤ (N:ℝ) := by push_cast; linarith
    exact_mod_cast h2
  -- the pointwise majorant, valid on all of ℕ
  set g : ℕ → ℝ := fun n ↦ min 1 (4*x/(T * |x - (n:ℝ)|)) with hgd
  have hgnn : ∀ n, 0 ≤ g n := fun n ↦ le_min zero_le_one (by positivity)
  have hg1 : ∀ n, g n ≤ 1 := fun n ↦ min_le_left _ _
  have hexp2 : Real.exp (1/2) ≤ 2 := by
    have h := Real.exp_le_exp.mpr
      (show (1:ℝ)/2 ≤ Real.log 2 by linarith [Real.log_two_gt_d9])
    rwa [Real.exp_log two_pos] at h
  have hmaj : ∀ n : ℕ, f n ≤ 2 * Real.log x * g n := by
    intro n
    rw [hfd]
    dsimp only
    by_cases h : 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2
    · rw [if_pos h]
      obtain ⟨hpos, hlt⟩ := h
      have hn0 : (0:ℝ) < (n:ℝ) := by
        rcases Nat.eq_zero_or_pos n with rfl | hn
        · rw [Nat.cast_zero, div_zero, Real.log_zero, abs_zero] at hpos
          linarith
        · exact_mod_cast hn
      have ht0 : (0:ℝ) < x/n := by positivity
      have hxn : x ≠ (n:ℝ) := by
        intro he
        rw [he, div_self hn0.ne', Real.log_one, abs_zero] at hpos
        linarith
      obtain ⟨hL1, hL2⟩ := abs_lt.mp hlt
      have htlo : 1/2 ≤ x/n := by
        have h3 : Real.exp (-(1/2)) ≤ Real.exp (Real.log (x/n)) :=
          Real.exp_le_exp.mpr (by linarith)
        rw [Real.exp_log ht0] at h3
        have hEinv : (0:ℝ) ≤ (Real.exp ((1:ℝ)/2))⁻¹ := by positivity
        have h4 : (1/2:ℝ) ≤ Real.exp (-(1/2)) := by
          rw [Real.exp_neg]
          nlinarith [mul_inv_cancel₀ (Real.exp_pos ((1:ℝ)/2)).ne', hexp2]
        linarith
      have hthi : x/n ≤ 2 := by
        have h5 : Real.exp (Real.log (x/n)) ≤ Real.exp (1/2) :=
          Real.exp_le_exp.mpr hL2.le
        rw [Real.exp_log ht0] at h5
        exact h5.trans hexp2
      have hn2x : (n:ℝ) ≤ 2*x := by
        nlinarith [mul_le_mul_of_nonneg_right htlo hn0.le, div_mul_cancel₀ x hn0.ne']
      have hdpos : (0:ℝ) < |x - (n:ℝ)| := abs_pos.mpr (sub_ne_zero.mpr hxn)
      -- |log(x/n)| ≥ |x−n|/(4x)
      have hlog_ge : |x - (n:ℝ)| / (4*x) ≤ |Real.log (x/n)| := by
        have h6 := abs_sub_one_le_two_abs_log htlo hthi
        have h7 : |x/(n:ℝ) - 1| = |x - n| / n := by
          rw [show x/(n:ℝ) - 1 = (x - n)/n by field_simp, abs_div, abs_of_pos hn0]
        rw [h7] at h6
        calc |x - (n:ℝ)| / (4*x) ≤ |x - n| / (2*n) := by
              apply div_le_div_of_nonneg_left (abs_nonneg _) (by positivity)
              linarith
          _ = |x - n| / n / 2 := by ring
          _ ≤ |Real.log (x/n)| := h6
      -- min comparison
      have hmin : min 1 (1/(T * |Real.log (x / n)|)) ≤ g n := by
        rw [hgd]
        dsimp only
        apply min_le_min le_rfl
        have h8 : T * (|x - n| / (4*x)) ≤ T * |Real.log (x/n)| :=
          mul_le_mul_of_nonneg_left hlog_ge hT0.le
        calc 1/(T * |Real.log (x / n)|) ≤ 1/(T * (|x - n| / (4*x))) :=
              one_div_le_one_div_of_le (by positivity) h8
          _ = 4*x/(T * |x - n|) := by
              field_simp
      -- Λ comparison
      have hΛ : ArithmeticFunction.vonMangoldt n ≤ 2 * Real.log x := by
        calc ArithmeticFunction.vonMangoldt n ≤ Real.log n :=
              ArithmeticFunction.vonMangoldt_le_log
          _ ≤ Real.log (2*x) := Real.log_le_log hn0 hn2x
          _ = Real.log 2 + Real.log x := Real.log_mul two_ne_zero hx0.ne'
          _ ≤ 2 * Real.log x := by linarith [Real.log_two_lt_d9]
      exact mul_le_mul hΛ hmin (le_min zero_le_one (by positivity)) (by positivity)
    · rw [if_neg h]
      exact mul_nonneg (by positivity) (hgnn n)
  -- the harmonic pieces
  have hharm : ∀ K : ℕ, (K:ℝ) ≤ 3*x →
      ∑ j ∈ Finset.range K, 4*x/(T*(j+1)) ≤ (4*x/T) * (3 * Real.log x) := by
    intro K hK
    have h1 : ∑ j ∈ Finset.range K, 4*x/(T*(j+1))
        = (4*x/T) * ∑ j ∈ Finset.range K, (1:ℝ)/(j+1) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      have hj : ((j:ℝ)+1) ≠ 0 := by positivity
      field_simp
    rw [h1]
    apply mul_le_mul_of_nonneg_left _ (by positivity)
    have h2 : ∑ j ∈ Finset.range K, (1:ℝ)/(j+1) = ((harmonic K : ℚ) : ℝ) := by
      rw [harmonic]
      push_cast
      apply Finset.sum_congr rfl
      intro j _
      rw [one_div]
    rw [h2]
    have h3 := harmonic_le_one_add_log K
    have h4 : Real.log K ≤ Real.log (3*x) := by
      rcases Nat.eq_zero_or_pos K with rfl | hK0
      · simp
        exact Real.log_nonneg (by linarith)
      · exact Real.log_le_log (by exact_mod_cast hK0) hK
    have h5 : Real.log (3*x) ≤ 2 * Real.log x := by
      have h6 : 3*x ≤ x^2 := by nlinarith
      calc Real.log (3*x) ≤ Real.log (x^2) := Real.log_le_log (by positivity) h6
        _ = 2 * Real.log x := by
            rw [Real.log_pow]
            push_cast
            ring
    linarith
  -- lower band: n ∈ range m
  have hlower : ∑ n ∈ Finset.range m, g n ≤ (4*x/T) * (3 * Real.log x) := by
    have hstep : ∀ n ∈ Finset.range m, g n ≤ 4*x/(T*((m - 1 - n : ℕ)+1)) := by
      intro n hn
      rw [Finset.mem_range] at hn
      have hcast : ((m - 1 - n : ℕ):ℝ) + 1 = (m:ℝ) - n := by
        have h1 : n ≤ m - 1 := by omega
        have h2 : (1:ℕ) ≤ m := by omega
        push_cast [Nat.cast_sub h1, Nat.cast_sub h2]
        ring
      rw [hgd]
      dsimp only
      calc min 1 (4*x/(T * |x - (n:ℝ)|)) ≤ 4*x/(T * |x - (n:ℝ)|) := min_le_right _ _
        _ ≤ 4*x/(T*((m - 1 - n : ℕ)+1)) := by
            rw [hcast]
            apply div_le_div_of_nonneg_left (by positivity) (by
              have : (0:ℝ) < (m:ℝ) - n := by
                have : (n:ℝ) < m := by exact_mod_cast hn
                linarith
              positivity)
            apply mul_le_mul_of_nonneg_left _ hT0.le
            rw [abs_of_nonneg (by
              have : (n:ℝ) < m := by exact_mod_cast hn
              linarith : (0:ℝ) ≤ x - n)]
            have : (n:ℝ) < m := by exact_mod_cast hn
            linarith
    calc ∑ n ∈ Finset.range m, g n
        ≤ ∑ n ∈ Finset.range m, 4*x/(T*((m - 1 - n : ℕ)+1)) := Finset.sum_le_sum hstep
      _ = ∑ j ∈ Finset.range m, 4*x/(T*((j:ℝ)+1)) := by
          rw [← Finset.sum_range_reflect (fun j ↦ 4*x/(T*((j:ℝ)+1))) m]
      _ ≤ (4*x/T) * (3 * Real.log x) := hharm m (by linarith)
  -- upper band: n ∈ Ico m N
  have hupper : ∑ n ∈ Finset.Ico m N, g n
      ≤ 2 + (4*x/T) * (3 * Real.log x) := by
    have hmN' : m ≤ N := by omega
    rw [Finset.sum_Ico_eq_sum_range]
    have hK2 : N - m = (N - m - 2) + 1 + 1 := by omega
    rw [hK2, Finset.sum_range_succ', Finset.sum_range_succ']
    have hstep : ∀ i ∈ Finset.range (N - m - 2), g (m + (i + 1 + 1))
        ≤ 4*x/(T*((i:ℝ)+1)) := by
      intro i _
      rw [hgd]
      dsimp only
      calc min 1 (4*x/(T * |x - ((m + (i+1+1) : ℕ):ℝ)|))
          ≤ 4*x/(T * |x - ((m + (i+1+1) : ℕ):ℝ)|) := min_le_right _ _
        _ ≤ 4*x/(T*((i:ℝ)+1)) := by
            apply div_le_div_of_nonneg_left (by positivity) (by positivity)
            apply mul_le_mul_of_nonneg_left _ hT0.le
            have h1 : ((m + (i+1+1) : ℕ):ℝ) = (m:ℝ) + i + 2 := by push_cast; ring
            rw [h1, abs_of_nonpos (by linarith : x - ((m:ℝ) + i + 2) ≤ 0)]
            linarith
    calc (∑ i ∈ Finset.range (N - m - 2), g (m + (i + 1 + 1)))
          + g (m + (0 + 1)) + g (m + 0)
        ≤ (∑ i ∈ Finset.range (N - m - 2), 4*x/(T*((i:ℝ)+1))) + 1 + 1 := by
          have := Finset.sum_le_sum hstep
          have g1 := hg1 (m + (0+1))
          have g2 := hg1 (m + 0)
          linarith
      _ ≤ (4*x/T) * (3 * Real.log x) + 2 := by
          have := hharm (N - m - 2) (by
            have : ((N - m - 2 : ℕ):ℝ) ≤ (N:ℝ) := by
              have : (N - m - 2 : ℕ) ≤ N := by omega
              exact_mod_cast this
            have hN3 : (N:ℝ) ≤ 3*x := by
              have := Nat.ceil_lt_add_one (by positivity : (0:ℝ) ≤ 2*x)
              linarith
            linarith)
          linarith
      _ = 2 + (4*x/T) * (3 * Real.log x) := by ring
  -- assemble the finset bound
  apply Real.tsum_le_of_sum_le hfnn
  intro s
  have hvanish : ∀ n : ℕ, n ∉ Finset.range N → f n = 0 := by
    intro n hn
    rw [Finset.mem_range, not_lt] at hn
    rw [hfd]
    dsimp only
    rw [if_neg]
    rintro ⟨hpos, hlt⟩
    have hnN : (2*x:ℝ) ≤ n := by
      have h1 : (N:ℝ) ≤ n := by exact_mod_cast hn
      linarith
    have hn0 : (0:ℝ) < n := by linarith
    have hxn2 : x / n ≤ 1/2 := by
      have h2 : x/(n:ℝ) ≤ x/(2*x) := div_le_div_of_nonneg_left hx0.le (by positivity) hnN
      have h3 : x/(2*x) = 1/2 := by field_simp
      rw [h3] at h2
      exact h2
    have h4 : Real.log (x/n) ≤ Real.log (1/2) :=
      Real.log_le_log (by positivity) hxn2
    have h5 : Real.log ((1:ℝ)/2) = -Real.log 2 := by
      rw [one_div, Real.log_inv]
    have h6 : (1/2:ℝ) ≤ |Real.log (x/n)| := by
      have h7 := neg_le_abs (Real.log (x/n))
      have h8 : (1/2:ℝ) ≤ -Real.log (x/n) := by
        rw [h5] at h4
        linarith [Real.log_two_gt_d9]
      linarith
    linarith
  have hsplit : ∑ n ∈ s, f n ≤ ∑ n ∈ Finset.range N, f n := by
    classical
    calc ∑ n ∈ s, f n
        = ∑ n ∈ s.filter (· ∈ Finset.range N), f n
          + ∑ n ∈ s.filter (fun n ↦ ¬ (n ∈ Finset.range N)), f n :=
          (Finset.sum_filter_add_sum_filter_not s _ f).symm
      _ = ∑ n ∈ s.filter (· ∈ Finset.range N), f n := by
          have hz : ∑ n ∈ s.filter (fun n ↦ ¬ (n ∈ Finset.range N)), f n = 0 := by
            apply Finset.sum_eq_zero
            intro n hn
            exact hvanish n (Finset.mem_filter.mp hn).2
          rw [hz, add_zero]
      _ ≤ ∑ n ∈ Finset.range N, f n := by
          apply Finset.sum_le_sum_of_subset_of_nonneg
          · intro n hn
            exact (Finset.mem_filter.mp hn).2
          · exact fun n _ _ ↦ hfnn n
  refine hsplit.trans ?_
  calc ∑ n ∈ Finset.range N, f n
      ≤ ∑ n ∈ Finset.range N, 2 * Real.log x * g n :=
        Finset.sum_le_sum (fun n _ ↦ hmaj n)
    _ = 2 * Real.log x * ∑ n ∈ Finset.range N, g n := by rw [Finset.mul_sum]
    _ = 2 * Real.log x * (∑ n ∈ Finset.range m, g n + ∑ n ∈ Finset.Ico m N, g n) := by
        congr 1
        rw [Finset.range_eq_Ico, Finset.range_eq_Ico,
          Finset.sum_Ico_consecutive _ (Nat.zero_le m) (by omega : m ≤ N)]
    _ ≤ 2 * Real.log x * ((4*x/T) * (3 * Real.log x)
          + (2 + (4*x/T) * (3 * Real.log x))) := by
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        linarith [hlower, hupper]
    _ ≤ 100 * x * Real.log (x * T) ^ 2 / T + 4 * Real.log x := by
        have hlog_le : Real.log x ≤ Real.log (x*T) := by
          apply Real.log_le_log hx0
          nlinarith [mul_le_mul_of_nonneg_left hT hx0.le]
        have hsq : Real.log x ^ 2 ≤ Real.log (x*T) ^ 2 := by nlinarith
        have hstep2 : 2 * Real.log x * ((4*x/T) * (3 * Real.log x)
              + (2 + (4*x/T) * (3 * Real.log x)))
            = 48 * x * Real.log x ^ 2 / T + 4 * Real.log x := by
          field_simp
          ring
        rw [hstep2]
        have h48 : 48 * x * Real.log x ^ 2 / T ≤ 100 * x * Real.log (x*T) ^ 2 / T := by
          apply div_le_div_of_nonneg_right _ hT0.le
          nlinarith [hsq, sq_nonneg (Real.log x)]
        linarith

/-- info: 'PerronKernel.far_terms_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms far_terms_sum


/-! ### Slice 1 assembly — composing 1a + 1b + 1c

`‖Σ Λ(n)·(perronI(x/n) − δ(x/n))‖ ≤ 600·x·log(xT)²/T + 12·log x`. 1a bounds
each kernel; the far range is 1b's summand verbatim, the near range is 1c's
times `(x/n)^c ≤ e`, and the diagonal `n = x` pays `arctan/π ≤ 1/2` through
the segment integral. -/

/-- The kernel at `y = 1`, directly: `‖perronI 1 c T‖ ≤ 1/2`. -/
theorem perronI_one_norm {c T : ℝ} (hc : 0 < c) :
    ‖perronI 1 c T‖ ≤ 1/2 := by
  have h1 : perronI 1 c T
      = (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * (2 * Real.arctan (T / c) * Complex.I) := by
    rw [perronI, ← seg_inv_integral hc]
    congr 1
    apply intervalIntegral.integral_congr
    intro t _
    simp only [Complex.ofReal_one, Complex.one_cpow]
    rw [← one_div, div_eq_mul_inv, one_mul]
  rw [h1, norm_mul, norm_inv]
  have h2 : ‖2 * (Real.pi:ℂ) * Complex.I‖ = 2 * Real.pi := by
    rw [norm_mul, norm_mul, Complex.norm_I, mul_one]
    simp [abs_of_pos Real.pi_pos]
  have h3 : ‖2 * (Real.arctan (T/c) : ℂ) * Complex.I‖ = 2 * |Real.arctan (T/c)| := by
    rw [norm_mul, norm_mul, Complex.norm_I, mul_one, Complex.norm_real,
      Real.norm_eq_abs]
    norm_num
  rw [h2]
  have h4 : ‖2 * ((Real.arctan (T / c) : ℝ) : ℂ) * Complex.I‖ ≤ Real.pi := by
    rw [h3]
    have h5 : |Real.arctan (T/c)| ≤ Real.pi / 2 := by
      rw [abs_le]
      constructor
      · linarith [Real.neg_pi_div_two_lt_arctan (T/c)]
      · linarith [Real.arctan_lt_pi_div_two (T/c)]
    linarith
  calc (2 * Real.pi)⁻¹ * ‖2 * ((Real.arctan (T / c) : ℝ) : ℂ) * Complex.I‖
      ≤ (2 * Real.pi)⁻¹ * Real.pi := by
        apply mul_le_mul_of_nonneg_left h4
        positivity
    _ = 1/2 := by
        field_simp

/-- **Slice 1's analytic composition.** The summed kernel error. -/
theorem kernel_sum_bound {x T : ℝ} (hx : 16 ≤ x) (hT : 1 ≤ T) :
    ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n)))‖
      ≤ 600 * x * Real.log (x * T) ^ 2 / T + 12 * Real.log x := by
  have hx0 : (0:ℝ) < x := by linarith
  have hT0 : (0:ℝ) < T := lt_of_lt_of_le one_pos hT
  have hexp16 : Real.exp 1 < 16 := by linarith [Real.exp_one_lt_d9]
  have hlx : 1 < Real.log x := by
    have h1 : Real.log (Real.exp 1) < Real.log x :=
      Real.log_lt_log (Real.exp_pos 1) (lt_of_lt_of_le hexp16 hx)
    rwa [Real.log_exp] at h1
  have hlx0 : (0:ℝ) < Real.log x := by linarith
  set c : ℝ := 1 + 1/Real.log x with hcd
  have hc0 : (0:ℝ) < c := by rw [hcd]; positivity
  have hc2 : c ≤ 2 := by
    rw [hcd]
    have h6 : 1/Real.log x ≤ 1 := by
      rw [div_le_one hlx0]
      linarith
    linarith
  set far : ℕ → ℝ := fun n ↦ if 1/2 ≤ |Real.log (x / n)| then
      ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|)
    else 0 with hfard
  set near : ℕ → ℝ := fun n ↦ if 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2 then
      ArithmeticFunction.vonMangoldt n * min 1 (1/(T * |Real.log (x / n)|))
    else 0 with hneard
  set diagI : ℕ → ℝ := fun n ↦ if n = ⌊x⌋₊ ∧ ((⌊x⌋₊ : ℕ) : ℝ) = x then Real.log x
    else 0 with hdiagd
  have hfarnn : ∀ n, 0 ≤ far n := by
    intro n
    rw [hfard]
    dsimp only
    split
    · positivity
    · exact le_rfl
  have hnearnn : ∀ n, 0 ≤ near n := by
    intro n
    rw [hneard]
    dsimp only
    split
    · exact mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
        (le_min zero_le_one (by positivity))
    · exact le_rfl
  have hdiagnn : ∀ n, 0 ≤ diagI n := by
    intro n
    rw [hdiagd]
    dsimp only
    split
    · positivity
    · exact le_rfl
  have hpt : ∀ n : ℕ, ‖(ArithmeticFunction.vonMangoldt n : ℂ)
        * (perronI (x/n) c T - perronδ (x/n))‖
      ≤ far n + Real.exp 1 * near n + diagI n := by
    intro n
    have hΛnn := ArithmeticFunction.vonMangoldt_nonneg (n := n)
    have hnorm : ‖(ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) c T - perronδ (x/n))‖
        = ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖ := by
      rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hΛnn]
    rw [hnorm]
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp only [ArithmeticFunction.map_zero, zero_mul, norm_zero]
      have h1 := hfarnn 0
      have h2 := hnearnn 0
      have h3 := hdiagnn 0
      nlinarith [Real.exp_pos 1, mul_nonneg (Real.exp_pos 1).le h2]
    · have hn0 : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn
      have hyx : (0:ℝ) < x/n := by positivity
      by_cases hne : x/(n:ℝ) = 1
      · have hnx : (n:ℝ) = x := by
          field_simp at hne
          linarith [hne]
        have hδ1 : perronδ (x/n) = 0 := by
          rw [perronδ, if_neg]
          rw [hne]
          norm_num
        have hbound : ‖perronI (x/n) c T - perronδ (x/n)‖ ≤ 1/2 := by
          rw [hδ1, sub_zero, hne]
          exact perronI_one_norm hc0
        have hfl : n = ⌊x⌋₊ := by
          rw [← hnx, Nat.floor_natCast]
        have hdiag_val : diagI n = Real.log x := by
          rw [hdiagd]
          dsimp only
          rw [if_pos ⟨hfl, by rw [← hfl]; exact hnx⟩]
        have hΛlog : ArithmeticFunction.vonMangoldt n ≤ Real.log x := by
          calc ArithmeticFunction.vonMangoldt n ≤ Real.log n :=
                ArithmeticFunction.vonMangoldt_le_log
            _ = Real.log x := by rw [hnx]
        calc ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖
            ≤ Real.log x * (1/2) := by
              apply mul_le_mul hΛlog hbound (norm_nonneg _) (by positivity)
          _ ≤ far n + Real.exp 1 * near n + diagI n := by
              rw [hdiag_val]
              have h1 := hfarnn n
              have h2 := hnearnn n
              nlinarith [Real.exp_pos 1, hlx0, mul_nonneg (Real.exp_pos 1).le h2]
      · have h1a := perron_kernel_truncated hyx hne hc0 hT
        have hlogne : Real.log (x/n) ≠ 0 := by
          intro h
          apply hne
          have h7 := Real.exp_log hyx
          rw [h, Real.exp_zero] at h7
          linarith [h7]
        have habs0 : 0 < |Real.log (x/n)| := abs_pos.mpr hlogne
        by_cases hfar : 1/2 ≤ |Real.log (x / n)|
        · have hfar_val : far n = ArithmeticFunction.vonMangoldt n
              * (x / n) ^ c / (T * |Real.log (x / n)|) := by
            rw [hfard]
            dsimp only
            rw [if_pos hfar]
          have hminle : min 1 (1/(T * |Real.log (x/n)|)) ≤ 1/(T * |Real.log (x/n)|) :=
            min_le_right _ _
          calc ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖
              ≤ ArithmeticFunction.vonMangoldt n
                  * ((x/n) ^ c * min 1 (1/(T * |Real.log (x/n)|))) :=
                mul_le_mul_of_nonneg_left h1a hΛnn
            _ ≤ ArithmeticFunction.vonMangoldt n
                  * ((x/n) ^ c * (1/(T * |Real.log (x/n)|))) := by
                apply mul_le_mul_of_nonneg_left _ hΛnn
                exact mul_le_mul_of_nonneg_left hminle
                  (Real.rpow_nonneg hyx.le _)
            _ = far n := by
                rw [hfar_val]
                field_simp
            _ ≤ far n + Real.exp 1 * near n + diagI n := by
                have h2 := hnearnn n
                have h3 := hdiagnn n
                nlinarith [Real.exp_pos 1, mul_nonneg (Real.exp_pos 1).le h2]
        · push_neg at hfar
          have hnear_val : near n = ArithmeticFunction.vonMangoldt n
              * min 1 (1/(T * |Real.log (x / n)|)) := by
            rw [hneard]
            dsimp only
            rw [if_pos ⟨habs0, hfar⟩]
          have hxc_e : (x/n) ^ c ≤ Real.exp 1 := by
            rw [Real.rpow_def_of_pos hyx]
            apply Real.exp_le_exp.mpr
            calc Real.log (x/n) * c ≤ |Real.log (x/n)| * c := by
                  apply mul_le_mul_of_nonneg_right (le_abs_self _) hc0.le
              _ ≤ (1/2) * 2 := by
                  apply mul_le_mul hfar.le hc2 hc0.le (by norm_num)
              _ = 1 := by norm_num
          calc ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖
              ≤ ArithmeticFunction.vonMangoldt n
                  * ((x/n) ^ c * min 1 (1/(T * |Real.log (x/n)|))) :=
                mul_le_mul_of_nonneg_left h1a hΛnn
            _ ≤ ArithmeticFunction.vonMangoldt n
                  * (Real.exp 1 * min 1 (1/(T * |Real.log (x/n)|))) := by
                apply mul_le_mul_of_nonneg_left _ hΛnn
                apply mul_le_mul_of_nonneg_right hxc_e
                exact le_min zero_le_one (by positivity)
            _ = Real.exp 1 * near n := by
                rw [hnear_val]
                ring
            _ ≤ far n + Real.exp 1 * near n + diagI n := by
                have h1 := hfarnn n
                have h3 := hdiagnn n
                linarith
  have hfar_sum : Summable far := by
    have hc1 : 1 < c := by
      rw [hcd]
      have h9 : 0 < 1/Real.log x := by positivity
      linarith
    apply Summable.of_nonneg_of_le hfarnn _
      ((vonMangoldt_rpow_summable hc1).mul_left (2 * Real.exp 1 * x / T))
    intro n
    rw [hfard]
    dsimp only
    by_cases h : 1/2 ≤ |Real.log (x / n)|
    · rw [if_pos h]
      rcases Nat.eq_zero_or_pos n with rfl | hn
      · simp [ArithmeticFunction.map_zero]
        try positivity
      · have hn0 : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn
        have hdiv : (x / n) ^ c = x ^ c * (n:ℝ) ^ (-c) := by
          rw [Real.div_rpow hx0.le hn0.le, Real.rpow_neg hn0.le, div_eq_mul_inv]
        have hxc : x ^ c = Real.exp 1 * x := by
          rw [hcd, Real.rpow_add hx0, Real.rpow_one, Real.rpow_def_of_pos hx0,
            mul_one_div, div_self hlx0.ne']
          ring
        have hden : T / 2 ≤ T * |Real.log (x / n)| := by
          calc T / 2 = T * (1/2) := by ring
            _ ≤ T * |Real.log (x / n)| := mul_le_mul_of_nonneg_left h hT0.le
        calc ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|)
            ≤ ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T / 2) := by
              apply div_le_div_of_nonneg_left _ (by positivity) hden
              exact mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
                (Real.rpow_nonneg (by positivity) _)
          _ = (2 * Real.exp 1 * x / T)
                * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) := by
              rw [hdiv, hxc]
              field_simp
              try ring
    · rw [if_neg h]
      positivity
  have hN2 : ∀ n : ℕ, n ∉ Finset.range (⌈2*x⌉₊ + 1) → near n = 0 := by
    intro n hn
    rw [Finset.mem_range, not_lt] at hn
    rw [hneard]
    dsimp only
    rw [if_neg]
    rintro ⟨hpos, hlt⟩
    have hnN : (2*x:ℝ) ≤ n := by
      have h1 : ((⌈2*x⌉₊ + 1 : ℕ):ℝ) ≤ n := by exact_mod_cast hn
      have h2 : (2*x:ℝ) ≤ ⌈2*x⌉₊ := Nat.le_ceil _
      push_cast at h1
      linarith
    have hn0 : (0:ℝ) < n := by linarith
    have hxn2 : x / n ≤ 1/2 := by
      have h2 : x/(n:ℝ) ≤ x/(2*x) := div_le_div_of_nonneg_left hx0.le (by positivity) hnN
      have h3 : x/(2*x) = 1/2 := by field_simp
      rw [h3] at h2
      exact h2
    have h4 : Real.log (x/n) ≤ Real.log (1/2) :=
      Real.log_le_log (by positivity) hxn2
    have h5 : Real.log ((1:ℝ)/2) = -Real.log 2 := by
      rw [one_div, Real.log_inv]
    have h6 : (1/2:ℝ) ≤ |Real.log (x/n)| := by
      have h7 := neg_le_abs (Real.log (x/n))
      rw [h5] at h4
      linarith [Real.log_two_gt_d9]
    linarith
  have hnear_sum : Summable near := summable_of_ne_finset_zero hN2
  have hdiag_sum : Summable diagI := by
    apply summable_of_ne_finset_zero (s := {⌊x⌋₊})
    intro n hn
    rw [Finset.mem_singleton] at hn
    rw [hdiagd]
    dsimp only
    rw [if_neg]
    rintro ⟨h1, _⟩
    exact hn h1
  have hmaj_sum : Summable (fun n ↦ far n + Real.exp 1 * near n + diagI n) :=
    ((hfar_sum.add (hnear_sum.mul_left _)).add hdiag_sum)
  have hnorm_sum : Summable (fun n : ℕ ↦ ‖(ArithmeticFunction.vonMangoldt n : ℂ)
      * (perronI (x/n) c T - perronδ (x/n))‖) :=
    Summable.of_nonneg_of_le (fun n ↦ norm_nonneg _) hpt hmaj_sum
  calc ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) c T - perronδ (x/n)))‖
      ≤ ∑' n : ℕ, ‖(ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) c T - perronδ (x/n))‖ :=
        norm_tsum_le_tsum_norm hnorm_sum
    _ ≤ ∑' n : ℕ, (far n + Real.exp 1 * near n + diagI n) :=
        hnorm_sum.tsum_le_tsum hpt hmaj_sum
    _ = ((∑' n, far n) + ∑' n, Real.exp 1 * near n) + ∑' n, diagI n := by
        rw [(hfar_sum.add (hnear_sum.mul_left _)).tsum_add hdiag_sum,
          hfar_sum.tsum_add (hnear_sum.mul_left _)]
    _ ≤ (300 * x * Real.log (x*T)^2 / T)
          + Real.exp 1 * (100 * x * Real.log (x*T)^2 / T + 4 * Real.log x)
          + Real.log x := by
        have h1 := far_terms_sum hx hT
        have h2 := near_diagonal_sum hx hT
        have h3 : (∑' n, diagI n) ≤ Real.log x := by
          rw [tsum_eq_single ⌊x⌋₊ (by
            intro n hn
            rw [hdiagd]
            dsimp only
            rw [if_neg]
            rintro ⟨h4, _⟩
            exact hn h4)]
          rw [hdiagd]
          dsimp only
          split
          · exact le_rfl
          · linarith
        have h5 : (∑' n, Real.exp 1 * near n)
            = Real.exp 1 * ∑' n, near n := tsum_mul_left
        have h6 : (∑' n, near n) ≤ 100 * x * Real.log (x*T)^2 / T + 4 * Real.log x := h2
        have h7 : (0:ℝ) ≤ ∑' n, near n := tsum_nonneg hnearnn
        rw [h5]
        have h8 := mul_le_mul_of_nonneg_left h6 (Real.exp_pos 1).le
        linarith [h1, h3]
    _ ≤ 600 * x * Real.log (x * T) ^ 2 / T + 12 * Real.log x := by
        have he : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
        have hA : (0:ℝ) ≤ x * Real.log (x*T)^2 / T := by positivity
        have hs : Real.exp 1 * (100 * x * Real.log (x*T)^2 / T + 4 * Real.log x)
            ≤ 272 * (x * Real.log (x*T)^2 / T) + 11 * Real.log x := by
          have h1 : Real.exp 1 * (100 * x * Real.log (x*T)^2 / T + 4 * Real.log x)
              ≤ 2.72 * (100 * x * Real.log (x*T)^2 / T + 4 * Real.log x) := by
            apply mul_le_mul_of_nonneg_right (by linarith)
            have hp1 : (0:ℝ) ≤ 100 * x * Real.log (x*T)^2 / T := by positivity
            have hp2 : (0:ℝ) ≤ 4 * Real.log x := by positivity
            linarith
          have he1 : (2.72:ℝ) * (100 * x * Real.log (x*T)^2 / T + 4 * Real.log x)
              = 272 * (x * Real.log (x*T)^2 / T) + 10.88 * Real.log x := by
            ring
          rw [he1] at h1
          have hp2 : (0:ℝ) ≤ Real.log x := hlx0.le
          linarith
        have hexp : 300 * x * Real.log (x*T)^2 / T
            = 300 * (x * Real.log (x*T)^2 / T) := by ring
        have hexp2 : 600 * x * Real.log (x * T) ^ 2 / T
            = 600 * (x * Real.log (x*T)^2 / T) := by ring
        rw [hexp, hexp2]
        linarith [hs, hA, hlx0]

/-- info: 'PerronKernel.near_diagonal_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms near_diagonal_sum

end PerronKernel
