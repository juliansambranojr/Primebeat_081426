/-
# Slice 1a — the truncated Perron kernel bound (hEF's entry point)

SCRATCH: this file carries named `sorry`s by design. It is the slice map
for hEF's build order (adversary report 2026-08-28, recovered from the
session transcript; ledger: CONTEXT.md § hEF, roadmap D). Do not count
this module in any sorry-free claim.

The ONE missing piece of the truncated explicit formula, zeta-free,
provable from Mathlib alone:

    ‖(2πi)⁻¹ ∫_{c-iT}^{c+iT} y^s/s ds − [y > 1]‖ ≤ y^c · min(1, 1/(T·|log y|))

Classical: Davenport ch. 17 Lemma; Montgomery–Vaughan Thm 5.2 (their
constant has π in the denominator — dropping it is the crude-explicit
spec, CLAUDE.md Stage-3 conventions).

Routes, per branch:
  K1 (coarse, ≤ y^c)             deform the vertical segment to the circular
                                 arc through c±iT centred at 0: on the arc
                                 |y^s| ≤ y^c (both y-cases), |1/s| = 1/R,
                                 length ≤ πR — bound y^c/2. Mathlib:
                                 circleIntegral machinery; the lune between
                                 segment and arc needs a Cauchy argument.
  K2 (decay, ≤ y^c/(T|log y|))   close with a rectangle to +∞ (y < 1) or
                                 −∞ (y > 1, collecting the pole at 0);
                                 horizontals give ∫ y^σ dσ / T.

Upstream probed 2026-08-28: PNT+ main's PerronFormula.lean has no sharp-
kernel min-bound (its kernel is the smoothed x^s/(s(s+1))); the pin bump
does not discharge this leaf. Its rectangle machinery (vertIntBound,
contourPull, HolomorphicOn.upperUIntegral_eq_zero) is reusable structure
for K2.

The assembly from K1 and K2 is proved below — the two branches are the
whole of the missing mathematics.
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

/-- **K1, case `y > 1`.** Route: split off the exact `∫ ds/s = 2i·arctan(T/c)`,
mean-value bound on `(y^s−1)/s`, and an elementary two-variable inequality;
the `T·log y ≥ 1` regime follows from the decay branch. -/
theorem perron_kernel_coarse_gt {y c T : ℝ} (hygt : 1 < y)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c := by
  sorry

/-- **K1 — the coarse branch**, assembled from its two cases. -/
theorem perron_kernel_coarse {y c T : ℝ} (hy : 0 < y) (hy1 : y ≠ 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c := by
  rcases lt_or_gt_of_ne hy1 with h | h
  · exact perron_kernel_coarse_lt hy h hc hT
  · exact perron_kernel_coarse_gt h hc hT

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

/-- **K2, case `y > 1`.** Pole at `0` inside; rectangle to `−∞` collects the
residue `1 = perronδ y`; `horiz_bound` on both edges. -/
theorem perron_kernel_decay_gt {y c T : ℝ} (hygt : 1 < y)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) := by
  sorry

/-- **K2 — the decay branch**, assembled from its two cases. -/
theorem perron_kernel_decay {y c T : ℝ} (hy : 0 < y) (hy1 : y ≠ 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) := by
  rcases lt_or_gt_of_ne hy1 with h | h
  · exact perron_kernel_decay_lt hy h hc hT
  · exact perron_kernel_decay_gt h hc hT

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

end PerronKernel
