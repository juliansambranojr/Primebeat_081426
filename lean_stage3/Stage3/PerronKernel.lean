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

/-- **K2 — the decay branch.** The kernel misses its indicator by at most
`y^c/(T·|log y|)`. Route: rectangle to `±∞`, horizontals `∫ y^σ dσ / T`. -/
theorem perron_kernel_decay {y c T : ℝ} (hy : 0 < y) (hy1 : y ≠ 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) := by
  sorry

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
