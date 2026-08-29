/-
# S3 — the edge bound (FinalBound rescale + gap-eating)

The Landau partial fraction transported from PNT+'s normalized
`FinalBound` (unit ball) to the ball at `3/2 + iT′`, for
`g = (s−1)²·ζ` (entire; the pole cleared, one extra order-1 zero at
`1`). Inputs: `ZetaGrowth.sq_zeta_band_bound` (the B), PNT+'s
`ZetaFixedLowerBound` (the f(0)), `ContourShift`'s good heights,
fences, and reflection-order (the eating).

This file sits downstream of ContourShift and ZetaGrowth; the scratch
`edge_bound` statement in ContourShift is superseded here.
-/
import Stage3.ZetaGrowth

namespace EdgeBound

open Complex Topology Set

/-- The ball center at height `T′`. -/
noncomputable def c0 (T' : ℝ) : ℂ := 3/2 + Complex.I * T'

/-- `g = (s−1)²·ζ` — entire, zeros = ζ-zeros plus an order-1 zero at 1. -/
noncomputable def gz (s : ℂ) : ℂ := (s - 1)^2 * riemannZeta s

theorem gz_analytic (s : ℂ) : AnalyticAt ℂ gz s := ZetaGrowth.sq_mul_zeta_analytic s

theorem c0_im (T' : ℝ) : (c0 T').im = T' := by
  rw [c0]
  simp

theorem c0_re (T' : ℝ) : (c0 T').re = 3/2 := by
  rw [c0]
  simp

/-- The explicit lower bound at the center. -/
theorem gz_lower {T' : ℝ} (hT' : 2 ≤ T') :
    4 * ‖riemannZeta 3 / riemannZeta (3/2)‖ ≤ ‖gz (c0 T')‖ := by
  rw [gz, norm_mul, norm_pow]
  have h1 : T' ≤ ‖c0 T' - 1‖ := by
    have h2 := Complex.abs_im_le_norm (c0 T' - 1)
    have h3 : (c0 T' - 1).im = T' := by
      rw [Complex.sub_im, c0_im, Complex.one_im, sub_zero]
    rw [h3] at h2
    calc T' ≤ |T'| := le_abs_self _
      _ ≤ ‖c0 T' - 1‖ := h2
  have h4 := ZetaFixedLowerBound T'
  have h5 : ‖riemannZeta 3 / riemannZeta (3/2)‖
      ≤ ‖riemannZeta (3/2 + Complex.I * T')‖ := by
    exact_mod_cast h4
  have h6 : riemannZeta (c0 T') = riemannZeta (3/2 + Complex.I * (T' : ℂ)) := rfl
  rw [h6]
  have h7 : (0:ℝ) ≤ ‖riemannZeta 3 / riemannZeta (3/2)‖ := norm_nonneg _
  have h8 : (4:ℝ) ≤ ‖c0 T' - 1‖^2 := by nlinarith [norm_nonneg (c0 T' - 1)]
  have h9 : (0:ℝ) ≤ ‖riemannZeta (3/2 + Complex.I * (T':ℂ))‖ := norm_nonneg _
  calc 4 * ‖riemannZeta 3 / riemannZeta (3/2)‖
      ≤ 4 * ‖riemannZeta (3/2 + Complex.I * (T':ℂ))‖ := by linarith
    _ ≤ ‖c0 T' - 1‖^2 * ‖riemannZeta (3/2 + Complex.I * (T':ℂ))‖ := by nlinarith

/-- The lower-bound constant is positive. -/
theorem zeta_ratio_pos : (0:ℝ) < ‖riemannZeta 3 / riemannZeta (3/2)‖ := by
  rw [norm_div]
  apply div_pos
  · rw [norm_pos_iff]
    exact riemannZeta_ne_zero_of_one_lt_re (by norm_num)
  · rw [norm_pos_iff]
    exact riemannZeta_ne_zero_of_one_lt_re (by norm_num)

/-- The center's value is nonzero. -/
theorem gz_c0_ne {T' : ℝ} (hT' : 2 ≤ T') : gz (c0 T') ≠ 0 := by
  have h1 := gz_lower hT'
  have h2 := zeta_ratio_pos
  rw [← norm_pos_iff]
  linarith

/-- A `gz`-zero is `1` or a `ζ`-zero. -/
theorem gz_zero_cases {w : ℂ} (h : gz w = 0) : w = 1 ∨ riemannZeta w = 0 := by
  rw [gz, mul_eq_zero] at h
  rcases h with h | h
  · left
    have h2 := pow_eq_zero_iff (n := 2) (by norm_num) |>.mp h
    linear_combination h2
  · right
    exact h

/-- The `gz`-zeros in any ball around the center are finite. -/
theorem gz_zeros_ball_finite (T' : ℝ) {ρ : ℝ} (hρ : 0 ≤ ρ) :
    {w : ℂ | gz w = 0 ∧ ‖w - c0 T'‖ ≤ ρ}.Finite := by
  set zc : ℂ := ((3/2 - ρ : ℝ) : ℂ) - Complex.I * ((|T'| + ρ : ℝ) : ℂ) with hzcd
  set wc : ℂ := ((3/2 + ρ : ℝ) : ℂ) + Complex.I * ((|T'| + ρ : ℝ) : ℂ) with hwcd
  have hzre : zc.re = 3/2 - ρ := by rw [hzcd]; simp
  have hzim : zc.im = -(|T'| + ρ) := by rw [hzcd]; simp
  have hwre : wc.re = 3/2 + ρ := by rw [hwcd]; simp
  have hwim : wc.im = |T'| + ρ := by rw [hwcd]; simp
  apply Set.Finite.subset
    ((ContourShift.zeta_zeros_rectangle_finite zc wc).union (Set.finite_singleton 1))
  rintro w ⟨hz, hball⟩
  rcases gz_zero_cases hz with h1 | h1
  · right
    exact h1
  · left
    refine ⟨h1, ?_⟩
    have hre := Complex.abs_re_le_norm (w - c0 T')
    have him := Complex.abs_im_le_norm (w - c0 T')
    rw [Complex.sub_re, c0_re] at hre
    rw [Complex.sub_im, c0_im] at him
    have h2 : |w.re - 3/2| ≤ ρ := le_trans hre hball
    have h3 : |w.im - T'| ≤ ρ := le_trans him hball
    rw [abs_le] at h2 h3
    have hT'a : T' ≤ |T'| := le_abs_self T'
    have hT'b : -|T'| ≤ T' := neg_abs_le T'
    simp only [Rectangle]
    rw [Complex.mem_reProdIm, hzre, hwre, hzim, hwim,
      Set.uIcc_of_le (by linarith : (3/2 - ρ : ℝ) ≤ 3/2 + ρ),
      Set.uIcc_of_le (by linarith : -(|T'| + ρ) ≤ |T'| + ρ),
      Set.mem_Icc, Set.mem_Icc]
    constructor
    · constructor <;> linarith [h2.1, h2.2]
    · constructor <;> linarith [h3.1, h3.2]

end EdgeBound
