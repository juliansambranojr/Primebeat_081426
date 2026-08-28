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

namespace PerronKernel

open Complex

/-- The truncated Perron integral `(2πi)⁻¹ ∫_{c-iT}^{c+iT} y^s/s ds`,
parametrised on the vertical segment. -/
noncomputable def perronI (y c T : ℝ) : ℂ :=
  (2 * Real.pi * Complex.I)⁻¹
    * ∫ t in (-T)..T, (y : ℂ) ^ ((c : ℂ) + Complex.I * t)
        / ((c : ℂ) + Complex.I * t) * Complex.I

/-- The target of the kernel: the indicator of `1 < y`. -/
noncomputable def perronδ (y : ℝ) : ℂ := if 1 < y then 1 else 0

/-- **K1 — the coarse branch.** The kernel misses its indicator by at most
`y^c`, uniformly in `T`. Route: circular-arc deformation. -/
theorem perron_kernel_coarse {y c T : ℝ} (hy : 0 < y) (hy1 : y ≠ 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c := by
  sorry

/-- The shared horizontal-edge estimate: along `Im s = T'` with `|T'| ≥ 1`,
the kernel's horizontal integral is controlled by the endpoint powers over
`|T'|·|log y|`. Every rectangle in both decay cases consumes this. -/
theorem horiz_bound {y T' : ℝ} (hy : 0 < y) (hy1 : y ≠ 1) (hT : 1 ≤ |T'|)
    {a b : ℝ} (hab : a ≤ b) :
    ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + Complex.I * T') / ((σ : ℂ) + Complex.I * T')‖
      ≤ max (y ^ a) (y ^ b) / (|T'| * |Real.log y|) := by
  have hL : Real.log y ≠ 0 :=
    Real.log_ne_zero.mpr ⟨hy.ne', hy1, by linarith⟩
  have hT0 : (0:ℝ) < |T'| := lt_of_lt_of_le one_pos hT
  -- pointwise: ‖y^(σ+iT')/(σ+iT')‖ ≤ y^σ/|T'|
  have hpt : ∀ σ : ℝ, ‖(y : ℂ) ^ ((σ : ℂ) + Complex.I * T')
      / ((σ : ℂ) + Complex.I * T')‖ ≤ y ^ σ / |T'| := by
    intro σ
    have hden : |T'| ≤ ‖(σ : ℂ) + Complex.I * T'‖ := by
      have := Complex.abs_im_le_norm ((σ : ℂ) + Complex.I * T')
      simpa using this
    have hnum : ‖(y : ℂ) ^ ((σ : ℂ) + Complex.I * T')‖ = y ^ σ := by
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
  have hmaj : ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + Complex.I * T')
      / ((σ : ℂ) + Complex.I * T')‖ ≤ (∫ σ in a..b, y ^ σ) / |T'| := by
    have hgc : Continuous fun σ : ℝ ↦ y ^ σ := by
      simp_rw [Real.rpow_def_of_pos hy]
      exact Real.continuous_exp.comp (continuous_const.mul continuous_id)
    have hgi : IntervalIntegrable (fun σ : ℝ ↦ y ^ σ / |T'|) MeasureTheory.volume a b :=
      (hgc.div_const _).intervalIntegrable a b
    calc ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + Complex.I * T') / ((σ : ℂ) + Complex.I * T')‖
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

/-- **K2, case `y < 1`.** No pole; rectangle to `+∞`, `horiz_bound` on both
edges, vertical at `+X` vanishes. -/
theorem perron_kernel_decay_lt {y c T : ℝ} (hy : 0 < y) (hylt : y < 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) := by
  sorry

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
