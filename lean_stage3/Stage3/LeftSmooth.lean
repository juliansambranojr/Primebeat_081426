/-
LeftSmooth — blocks F2c, F2 and F3 of `lean_stage3/design/leftedge.md`. 2026-11-23.

On `s = −1/4 + it` put `w = 1 − s = 5/4 − it`. The functional equation gives
`ζ′/ζ(s) + ζ′/ζ(w) = G(w) = log 2π − ψ(w) + (π/2)·tan(πw/2)` (`logDeriv_sum`).
The left edge splits into the series side (`LeftKernel.series_side`) and the smooth
side `∫ G(w)·x^s/s`. The smooth side splits three ways, each integrated against the
turning factor `x^(it)`:
  log 2π + γ        the kernel `LeftKernel.kernel_bound`;
  −ψ(w) − γ         termwise: `(−ψ(w) − γ)/s = Σ 1/((n+1)(n+w))` from the digamma
                    series, each term by parts (`kernel_conj`), summed;
  (π/2)·tan(πw/2)   by parts, `‖cos(a+ib)‖² ≥ cos²a + b²` making `∫‖h′‖` finite.
No derivative of the digamma function is needed.

  Gs, logDeriv_sum       the logarithmic derivative of the functional equation
  kc = |cos(5π/8)|, dgTerm n = 1/((n+1)(n+5/4)), c0 = log 2π + γ
  Nsm, Bsm = Nsm/log 16  the smooth-side constant
  Bleft = Bsm + Bser     the left-edge constant
  smooth_side            16 ≤ x, 2 ≤ T ⊢ ‖∫ (ζ′/ζ(s)+ζ′/ζ(w))·x^s/s‖ ≤ Bsm·x^(−1/4)
  left_edge_bound        16 ≤ x, 2 ≤ T ⊢ ‖left edge‖ ≤ Bleft·x^(−1/4)
  explicit_formula_all   16 ≤ x, 2 ≤ T ⊢ ‖ψ x − x + Σ‖ ≤ c1n·x·log²(xT)/T + c3n·log x
                           + Bleft·x^(−1/4)

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib
import PrimeNumberTheoremAnd.Mathlib.Analysis.SpecialFunctions.Gamma.DigammaSeries
import Stage3.LeftKernel

namespace LeftSmooth

open Complex Set MeasureTheory

/-- The arctan integral: for `a > 0`, `∫_{−T}^{T} dt/(a²+t²) ≤ π/a`. -/
theorem arctan_int_le {a T : ℝ} (ha : 0 < a) :
    (∫ t in (-T)..T, 1 / (a ^ 2 + t ^ 2)) ≤ Real.pi / a := by
  have hpos : ∀ t : ℝ, 0 < a ^ 2 + t ^ 2 := fun t => by positivity
  have hF : ∀ t ∈ Set.uIcc (-T) T,
      HasDerivAt (fun t => Real.arctan (t / a) / a) (1 / (a ^ 2 + t ^ 2)) t := by
    intro t _
    have := (((hasDerivAt_id' t).div_const a).arctan).div_const a
    refine this.congr_deriv ?_
    have hp := hpos t
    field_simp
    try ring
  have hfc : Continuous fun t : ℝ => 1 / (a ^ 2 + t ^ 2) :=
    continuous_const.div (by fun_prop) (fun t => (hpos t).ne')
  have hval := intervalIntegral.integral_eq_sub_of_hasDerivAt hF (hfc.intervalIntegrable _ _)
  have hA : |Real.arctan (T / a)| ≤ Real.pi / 2 :=
    abs_le.mpr ⟨(Real.neg_pi_div_two_lt_arctan _).le, (Real.arctan_lt_pi_div_two _).le⟩
  rw [hval]
  calc Real.arctan (T / a) / a - Real.arctan (-T / a) / a
      = 2 * Real.arctan (T / a) / a := by rw [neg_div, Real.arctan_neg]; ring
    _ ≤ |2 * Real.arctan (T / a) / a| := le_abs_self _
    _ = 2 * |Real.arctan (T / a)| / a := by rw [abs_div, abs_mul, abs_two, abs_of_pos ha]
    _ ≤ 2 * (Real.pi / 2) / a := by gcongr
    _ = Real.pi / a := by ring

/-- **The conjugate kernel.** For `y > 1`, `T ≥ 0`, `c > 0`:
`‖∫_{−T}^{T} y^(it)/(c − it) dt‖ ≤ (2 + π)/(c·log y)`; the endpoint terms are
bounded by `1/c`, so the bound does not see `T`. -/
theorem kernel_conj {y T c : ℝ} (hy : 1 < y) (hT : 0 ≤ T) (hc : 0 < c) :
    ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * ((c:ℂ) - (t:ℂ) * Complex.I)⁻¹‖
      ≤ (2 + Real.pi) / (c * Real.log y) := by
  have hnorm : ∀ t : ℝ, ‖(c:ℂ) - (t:ℂ) * Complex.I‖ = √(c ^ 2 + t ^ 2) := by
    intro t
    have := Complex.norm_add_mul_I c (-t)
    rw [show (c:ℂ) - (t:ℂ) * Complex.I = (c:ℂ) + ((-t : ℝ):ℂ) * Complex.I by push_cast; ring,
      this, neg_sq]
  have hpos : ∀ t : ℝ, 0 < c ^ 2 + t ^ 2 := fun t => by positivity
  have hne : ∀ t : ℝ, (c:ℂ) - (t:ℂ) * Complex.I ≠ 0 := by
    intro t h
    have := congrArg Complex.re h
    simp at this
    linarith
  have hd : ∀ t ∈ Set.uIcc (-T) T,
      HasDerivAt (fun t : ℝ => ((c:ℂ) - (t:ℂ) * Complex.I)⁻¹)
        (-(-Complex.I) / ((c:ℂ) - (t:ℂ) * Complex.I) ^ 2) t := by
    intro t _
    have h1 : HasDerivAt (fun t : ℝ => (c:ℂ) - (t:ℂ) * Complex.I) (-Complex.I) t := by
      have := (((hasDerivAt_id' t).ofReal_comp).mul_const Complex.I).const_sub (c:ℂ)
      simpa using this
    exact h1.inv (hne t)
  have hcont : Continuous fun t : ℝ => -(-Complex.I) / ((c:ℂ) - (t:ℂ) * Complex.I) ^ 2 :=
    continuous_const.div (by fun_prop) (fun t => pow_ne_zero _ (hne t))
  have hy0 : 0 < Real.log y := Real.log_pos hy
  have key := LeftKernel.osc_by_parts hy (by linarith : -T ≤ T) hd (hcont.intervalIntegrable _ _)
  refine key.trans ?_
  have hend : ∀ t : ℝ, ‖((c:ℂ) - (t:ℂ) * Complex.I)⁻¹‖ ≤ 1 / c := by
    intro t
    rw [norm_inv, hnorm, one_div]
    apply inv_anti₀ hc
    apply Real.le_sqrt_of_sq_le
    nlinarith [sq_nonneg t]
  have hder : ∀ t : ℝ, ‖-(-Complex.I) / ((c:ℂ) - (t:ℂ) * Complex.I) ^ 2‖
      = 1 / (c ^ 2 + t ^ 2) := by
    intro t
    rw [norm_div, norm_neg, norm_neg, Complex.norm_I, norm_pow, hnorm, Real.sq_sqrt (hpos t).le]
  have hI : (∫ t in (-T)..T, ‖-(-Complex.I) / ((c:ℂ) - (t:ℂ) * Complex.I) ^ 2‖)
      = ∫ t in (-T)..T, 1 / (c ^ 2 + t ^ 2) := by
    simp_rw [hder]
  rw [hI]
  have harc := arctan_int_le (T := T) hc
  have h1 := hend (-T)
  have h2 := hend T
  rw [div_le_div_iff₀ hy0 (by positivity)]
  have : (‖((c:ℂ) - ((-T:ℝ):ℂ) * Complex.I)⁻¹‖ + ‖((c:ℂ) - (T:ℂ) * Complex.I)⁻¹‖
      + ∫ t in (-T)..T, 1 / (c ^ 2 + t ^ 2)) * c ≤ 2 + Real.pi := by
    have e1 : 1 / c * c = 1 := by field_simp
    have e2 : Real.pi / c * c = Real.pi := by field_simp
    nlinarith
  nlinarith

/-- The squared norm of `cos(a + ib)` is at least `cos²a + b²`
(it equals `cos²a + sinh²b`). -/
theorem cos_sq_le_norm_cos (a b : ℝ) :
    Real.cos a ^ 2 + b ^ 2 ≤ ‖Complex.cos ((a:ℂ) + (b:ℂ) * Complex.I)‖ ^ 2 := by
  have e : Complex.cos ((a:ℂ) + (b:ℂ) * Complex.I)
      = ((Real.cos a * Real.cosh b : ℝ):ℂ) + ((-(Real.sin a * Real.sinh b)) : ℝ) * Complex.I := by
    rw [Complex.cos_add_mul_I, ← Complex.ofReal_cos, ← Complex.ofReal_cosh,
      ← Complex.ofReal_sin, ← Complex.ofReal_sinh]
    push_cast
    ring
  rw [e, Complex.sq_norm, Complex.normSq_add_mul_I]
  have h1 := Real.cosh_sq b
  have h2 := Real.sin_sq_add_cos_sq a
  have h3 : b ^ 2 ≤ Real.sinh b ^ 2 := by
    rcases le_total 0 b with hb | hb
    · have := Real.self_le_sinh_iff.mpr hb
      nlinarith
    · have := Real.self_le_sinh_iff.mpr (neg_nonneg.mpr hb)
      rw [Real.sinh_neg] at this
      nlinarith
  nlinarith [sq_nonneg (Real.cos a), sq_nonneg (Real.sin a), sq_nonneg (Real.sinh b)]

/-- `cos²a·‖sin(a + ib)‖² ≤ ‖cos(a + ib)‖²`; so `‖tan(a+ib)‖ ≤ 1/|cos a|`. -/
theorem cos_sq_mul_norm_sin_le (a b : ℝ) :
    Real.cos a ^ 2 * ‖Complex.sin ((a:ℂ) + (b:ℂ) * Complex.I)‖ ^ 2
      ≤ ‖Complex.cos ((a:ℂ) + (b:ℂ) * Complex.I)‖ ^ 2 := by
  have e : Complex.cos ((a:ℂ) + (b:ℂ) * Complex.I)
      = ((Real.cos a * Real.cosh b : ℝ):ℂ) + ((-(Real.sin a * Real.sinh b)) : ℝ) * Complex.I := by
    rw [Complex.cos_add_mul_I, ← Complex.ofReal_cos, ← Complex.ofReal_cosh,
      ← Complex.ofReal_sin, ← Complex.ofReal_sinh]
    push_cast
    ring
  have e2 : Complex.sin ((a:ℂ) + (b:ℂ) * Complex.I)
      = ((Real.sin a * Real.cosh b : ℝ):ℂ) + ((Real.cos a * Real.sinh b) : ℝ) * Complex.I := by
    rw [Complex.sin_add_mul_I, ← Complex.ofReal_cos, ← Complex.ofReal_cosh,
      ← Complex.ofReal_sin, ← Complex.ofReal_sinh]
    push_cast
    ring
  rw [e, e2, Complex.sq_norm, Complex.sq_norm, Complex.normSq_add_mul_I,
    Complex.normSq_add_mul_I]
  have h1 := Real.cosh_sq b
  have h2 := Real.sin_sq_add_cos_sq a
  have hc : Real.cos a ^ 2 ≤ 1 := by nlinarith [sq_nonneg (Real.sin a)]
  have hs : 0 ≤ Real.sinh b ^ 2 := sq_nonneg _
  -- LHS = c²(s² + sh²), RHS = c² + sh² with c = cos a, s = sin a
  have hL : Real.cos a ^ 2 * ((Real.sin a * Real.cosh b) ^ 2 + (Real.cos a * Real.sinh b) ^ 2)
      = Real.cos a ^ 2 * (Real.sin a ^ 2 + Real.sinh b ^ 2) := by
    have : Real.cosh b ^ 2 = Real.sinh b ^ 2 + 1 := h1
    linear_combination (Real.cos a ^ 2 * Real.sin a ^ 2) * this
      + (Real.cos a ^ 2 * Real.sinh b ^ 2) * h2
  have hR : (Real.cos a * Real.cosh b) ^ 2 + (-(Real.sin a * Real.sinh b)) ^ 2
      = Real.cos a ^ 2 + Real.sinh b ^ 2 := by
    linear_combination (Real.cos a ^ 2) * h1 + (Real.sinh b ^ 2) * h2
  rw [hL, hR]
  nlinarith [mul_nonneg (sq_nonneg (Real.cos a)) (sq_nonneg (Real.sin a)),
    mul_le_mul_of_nonneg_right hc hs]

/-- The smooth factor of the functional equation, as a function of `w = 1 − s`:
`G(w) = log 2π − ψ(w) + (π/2)·tan(πw/2)`, with `ψ` the digamma function. -/
noncomputable def Gs (w : ℂ) : ℂ :=
  Complex.log (2 * (Real.pi:ℂ)) - Complex.digamma w
    + ((Real.pi:ℂ) / 2) * Complex.tan ((Real.pi:ℂ) * w / 2)

/-- **The logarithmic derivative of the functional equation.** For `Re w > 1`
with `cos(πw/2) ≠ 0`: `ζ(1−w) ≠ 0` and `ζ′/ζ(1−w) + ζ′/ζ(w) = G(w)`. -/
theorem logDeriv_sum {w : ℂ} (hw : 1 < w.re)
    (hcos : Complex.cos ((Real.pi:ℂ) * w / 2) ≠ 0) :
    riemannZeta (1 - w) ≠ 0 ∧
    deriv riemannZeta (1 - w) / riemannZeta (1 - w) + deriv riemannZeta w / riemannZeta w
      = Gs w := by
  have hnat : ∀ u : ℂ, 1 < u.re → ∀ n : ℕ, u ≠ -n := by
    intro u hu n h
    have := congrArg Complex.re h
    simp at this
    have : (0:ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  have hne1 : ∀ u : ℂ, 1 < u.re → u ≠ 1 := by
    intro u hu h
    rw [h] at hu
    simp at hu
  set P : ℂ → ℂ := fun u => 2 * (2 * (Real.pi:ℂ)) ^ (-u) * Complex.Gamma u
    * Complex.cos ((Real.pi:ℂ) * u / 2) * riemannZeta u with hPdef
  have hFE : ∀ u : ℂ, 1 < u.re → riemannZeta (1 - u) = P u := by
    intro u hu
    rw [hPdef, riemannZeta_one_sub (hnat u hu) (hne1 u hu)]
  have h2pi : (2 * (Real.pi:ℂ)) ≠ 0 := by
    have : (0:ℝ) < 2 * Real.pi := by positivity
    exact_mod_cast this.ne'
  have hA : (2 * (Real.pi:ℂ)) ^ (-w) ≠ 0 := by
    rw [Complex.cpow_def_of_ne_zero h2pi]
    exact Complex.exp_ne_zero _
  have hΓ : Complex.Gamma w ≠ 0 := Complex.Gamma_ne_zero (hnat w hw)
  have hζw : riemannZeta w ≠ 0 := riemannZeta_ne_zero_of_one_lt_re hw
  have hζs : riemannZeta (1 - w) ≠ 0 := by
    rw [hFE w hw, hPdef]
    simp only
    exact mul_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero two_ne_zero hA) hΓ) hcos) hζw
  refine ⟨hζs, ?_⟩
  -- derivatives of the pieces at `w`
  have h1 : HasDerivAt (fun u : ℂ => (2 * (Real.pi:ℂ)) ^ (-u))
      ((2 * (Real.pi:ℂ)) ^ (-w) * Complex.log (2 * (Real.pi:ℂ)) * (-1)) w :=
    (hasDerivAt_neg' (x := w)).const_cpow (Or.inl h2pi)
  have hΓd : HasDerivAt Complex.Gamma (deriv Complex.Gamma w) w :=
    (Complex.differentiableAt_Gamma w (hnat w hw)).hasDerivAt
  have hg : HasDerivAt (fun u : ℂ => (Real.pi:ℂ) * u / 2) ((Real.pi:ℂ) * 1 / 2) w :=
    ((hasDerivAt_id w).const_mul (Real.pi:ℂ)).div_const 2
  have hc : HasDerivAt (fun u : ℂ => Complex.cos ((Real.pi:ℂ) * u / 2))
      (-Complex.sin ((Real.pi:ℂ) * w / 2) * ((Real.pi:ℂ) * 1 / 2)) w :=
    hg.ccos
  have hζd : HasDerivAt riemannZeta (deriv riemannZeta w) w :=
    (differentiableAt_riemannZeta (hne1 w hw)).hasDerivAt
  set D : ℂ := 2 * ((2 * (Real.pi:ℂ)) ^ (-w) * Complex.log (2 * (Real.pi:ℂ)) * (-1))
      * Complex.Gamma w * Complex.cos ((Real.pi:ℂ) * w / 2) * riemannZeta w
    + 2 * (2 * (Real.pi:ℂ)) ^ (-w) * deriv Complex.Gamma w
      * Complex.cos ((Real.pi:ℂ) * w / 2) * riemannZeta w
    + 2 * (2 * (Real.pi:ℂ)) ^ (-w) * Complex.Gamma w
      * (-Complex.sin ((Real.pi:ℂ) * w / 2) * ((Real.pi:ℂ) * 1 / 2)) * riemannZeta w
    + 2 * (2 * (Real.pi:ℂ)) ^ (-w) * Complex.Gamma w
      * Complex.cos ((Real.pi:ℂ) * w / 2) * deriv riemannZeta w with hDdef
  have hPd : HasDerivAt P D w := by
    have := (((h1.const_mul (2:ℂ)).mul hΓd).mul hc).mul hζd
    refine this.congr_deriv ?_
    rw [hDdef]
    simp only [Pi.mul_apply]
    ring
  have hPd' : HasDerivAt P D (1 - (1 - w)) := by
    rw [sub_sub_cancel]
    exact hPd
  have hcomp := hPd'.comp (1 - w) ((hasDerivAt_id (1 - w)).const_sub 1)
  have hopen : IsOpen {z : ℂ | 1 < (1 - z).re} :=
    isOpen_lt continuous_const (by fun_prop)
  have hev : riemannZeta =ᶠ[nhds (1 - w)] (fun z => P (1 - z)) := by
    have hmem : {z : ℂ | 1 < (1 - z).re} ∈ nhds (1 - w) := by
      apply hopen.mem_nhds
      simp only [Set.mem_setOf_eq, sub_sub_cancel]
      exact hw
    filter_upwards [hmem] with z hz
    rw [← hFE (1 - z) hz, sub_sub_cancel]
  have hD : deriv riemannZeta (1 - w) = D * (-1) := hev.deriv_eq.trans hcomp.deriv
  rw [hD, hFE w hw, hDdef]
  simp only [hPdef]
  rw [Gs, Complex.digamma_def, logDeriv_apply, Complex.tan_eq_sin_div_cos]
  field_simp
  try ring

/-- The point `s = −1/4 + it` of the left line. -/
noncomputable def sL (t : ℝ) : ℂ := ((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I

/-- The reflected point `w = 5/4 − it = 1 − s`. -/
noncomputable def wL (t : ℝ) : ℂ := (5/4 : ℂ) - (t:ℂ) * Complex.I

/-- `1 − w = s` on the line. -/
theorem one_sub_wL (t : ℝ) : 1 - wL t = sL t := by
  unfold sL wL
  push_cast
  ring

/-- `Re w = 5/4`. -/
theorem wL_re (t : ℝ) : (wL t).re = 5/4 := by
  unfold wL
  simp

/-- `‖s‖² = 1/16 + t²` on the line. -/
theorem norm_sL_sq (t : ℝ) : ‖sL t‖ ^ 2 = 1/16 + t ^ 2 := by
  unfold sL
  rw [Complex.norm_add_mul_I, Real.sq_sqrt (by positivity)]
  norm_num

/-- `‖s‖ ≥ 1/4` on the line. -/
theorem norm_sL_ge (t : ℝ) : 1/4 ≤ ‖sL t‖ := by
  have h := norm_sL_sq t
  have h0 := norm_nonneg (sL t)
  nlinarith [sq_nonneg t]

/-- `s ≠ 0` on the line. -/
theorem sL_ne (t : ℝ) : sL t ≠ 0 := by
  intro h
  have := norm_sL_ge t
  rw [h, norm_zero] at this
  norm_num at this

/-- The tangent's argument on the line: `πw/2 = 5π/8 − i·πt/2`. -/
theorem arg_wL (t : ℝ) :
    (Real.pi:ℂ) * wL t / 2 = ((5 * Real.pi / 8 : ℝ):ℂ) + ((-(Real.pi * t / 2)) : ℝ) * Complex.I := by
  unfold wL
  push_cast
  ring

/-- The cosine constant `κ = |cos(5π/8)|`. -/
noncomputable def kc : ℝ := |Real.cos (5 * Real.pi / 8)|

/-- `κ > 0`: `cos(5π/8) < 0`. -/
theorem kc_pos : 0 < kc := by
  unfold kc
  have h := Real.pi_pos
  have : Real.cos (5 * Real.pi / 8) < 0 :=
    Real.cos_neg_of_pi_div_two_lt_of_lt (by linarith) (by linarith)
  exact abs_pos.mpr this.ne

/-- `‖cos(πw/2)‖² ≥ κ² + t²` on the line. -/
theorem norm_cos_wL (t : ℝ) :
    kc ^ 2 + t ^ 2 ≤ ‖Complex.cos ((Real.pi:ℂ) * wL t / 2)‖ ^ 2 := by
  rw [arg_wL]
  have h := cos_sq_le_norm_cos (5 * Real.pi / 8) (-(Real.pi * t / 2))
  have hk : kc ^ 2 = Real.cos (5 * Real.pi / 8) ^ 2 := by unfold kc; exact sq_abs _
  have hpi := Real.pi_gt_three
  have : t ^ 2 ≤ (-(Real.pi * t / 2)) ^ 2 := by
    have e : (-(Real.pi * t / 2)) ^ 2 = Real.pi ^ 2 / 4 * t ^ 2 := by ring
    have h4 : (1:ℝ) ≤ Real.pi ^ 2 / 4 := by nlinarith
    rw [e]
    nlinarith [mul_le_mul_of_nonneg_right h4 (sq_nonneg t)]
  linarith

/-- `cos(πw/2) ≠ 0` on the line. -/
theorem cos_wL_ne (t : ℝ) : Complex.cos ((Real.pi:ℂ) * wL t / 2) ≠ 0 := by
  intro h
  have := norm_cos_wL t
  rw [h, norm_zero] at this
  have := kc_pos
  nlinarith [sq_nonneg t]

/-- `‖tan(πw/2)‖ ≤ 1/κ` on the line. -/
theorem norm_tan_wL (t : ℝ) : ‖Complex.tan ((Real.pi:ℂ) * wL t / 2)‖ ≤ 1 / kc := by
  have hk := kc_pos
  have hc := cos_wL_ne t
  have hcpos : 0 < ‖Complex.cos ((Real.pi:ℂ) * wL t / 2)‖ := norm_pos_iff.mpr hc
  have h := cos_sq_mul_norm_sin_le (5 * Real.pi / 8) (-(Real.pi * t / 2))
  rw [← arg_wL] at h
  have hk2 : kc ^ 2 = Real.cos (5 * Real.pi / 8) ^ 2 := by unfold kc; exact sq_abs _
  rw [← hk2] at h
  rw [Complex.tan_eq_sin_div_cos, norm_div, div_le_div_iff₀ hcpos hk]
  have hs0 := norm_nonneg (Complex.sin ((Real.pi:ℂ) * wL t / 2))
  nlinarith [sq_nonneg (‖Complex.sin ((Real.pi:ℂ) * wL t / 2)‖ * kc
    - ‖Complex.cos ((Real.pi:ℂ) * wL t / 2)‖)]

/-- `t ↦ w(t)` has derivative `−i`. -/
theorem hasDerivAt_wL (t : ℝ) : HasDerivAt wL (-Complex.I) t := by
  unfold wL
  have := (((hasDerivAt_id' t).ofReal_comp).mul_const Complex.I).const_sub (5/4:ℂ)
  simpa using this

/-- `t ↦ s(t)` has derivative `i`. -/
theorem hasDerivAt_sL (t : ℝ) : HasDerivAt sL Complex.I t := by
  unfold sL
  have := (((hasDerivAt_id' t).ofReal_comp).mul_const Complex.I).const_add (((-1/4:ℝ)):ℂ)
  simpa using this

/-- `t ↦ s(t)` is continuous. -/
theorem continuous_sL : Continuous sL := by
  unfold sL
  fun_prop

/-- `t ↦ w(t)` is continuous. -/
theorem continuous_wL : Continuous wL := by
  unfold wL
  fun_prop

/-- The tangent piece `tan(πw/2)/s` along the line. -/
noncomputable def tanPiece (t : ℝ) : ℂ :=
  Complex.tan ((Real.pi:ℂ) * wL t / 2) * (sL t)⁻¹

/-- The derivative of the tangent piece. -/
noncomputable def tanPiece' (t : ℝ) : ℂ :=
  (1 / Complex.cos ((Real.pi:ℂ) * wL t / 2) ^ 2 * ((Real.pi:ℂ) * (-Complex.I) / 2)) * (sL t)⁻¹
    + Complex.tan ((Real.pi:ℂ) * wL t / 2) * (-Complex.I / (sL t) ^ 2)

/-- The tangent piece has derivative `tanPiece'`. -/
theorem hasDerivAt_tanPiece (t : ℝ) : HasDerivAt tanPiece (tanPiece' t) t := by
  have hg : HasDerivAt (fun t : ℝ => (Real.pi:ℂ) * wL t / 2)
      ((Real.pi:ℂ) * (-Complex.I) / 2) t :=
    ((hasDerivAt_wL t).const_mul (Real.pi:ℂ)).div_const 2
  have htan := (Complex.hasDerivAt_tan (cos_wL_ne t)).comp t hg
  have hinv := (hasDerivAt_sL t).inv (sL_ne t)
  exact htan.mul hinv

/-- The tangent along the line is continuous. -/
theorem continuous_tan_wL : Continuous fun t : ℝ => Complex.tan ((Real.pi:ℂ) * wL t / 2) := by
  rw [continuous_iff_continuousAt]
  intro t
  have hg : HasDerivAt (fun t : ℝ => (Real.pi:ℂ) * wL t / 2)
      ((Real.pi:ℂ) * (-Complex.I) / 2) t :=
    ((hasDerivAt_wL t).const_mul (Real.pi:ℂ)).div_const 2
  exact ((Complex.hasDerivAt_tan (cos_wL_ne t)).comp t hg).continuousAt

/-- The derivative of the tangent piece is continuous. -/
theorem continuous_tanPiece' : Continuous tanPiece' := by
  have hcc : Continuous fun t : ℝ => Complex.cos ((Real.pi:ℂ) * wL t / 2) :=
    Complex.continuous_cos.comp (by have := continuous_wL; fun_prop)
  unfold tanPiece'
  refine Continuous.add ?_ ?_
  · refine Continuous.mul ?_ ?_
    · exact (continuous_const.div (hcc.pow 2) (fun t => pow_ne_zero _ (cos_wL_ne t))).mul
        continuous_const
    · exact continuous_sL.inv₀ sL_ne
  · exact continuous_tan_wL.mul
      (continuous_const.div (continuous_sL.pow 2) (fun t => pow_ne_zero _ (sL_ne t)))

/-- The pointwise bound on the derivative of the tangent piece:
`‖h′(t)‖ ≤ 2π/(κ²+t²) + (1/κ)/((1/4)²+t²)`. -/
theorem norm_tanPiece'_le (t : ℝ) :
    ‖tanPiece' t‖ ≤ 2 * Real.pi * (1 / (kc ^ 2 + t ^ 2))
      + (1 / kc) * (1 / ((1/4:ℝ) ^ 2 + t ^ 2)) := by
  have hk := kc_pos
  have hA1 : ‖1 / Complex.cos ((Real.pi:ℂ) * wL t / 2) ^ 2‖ ≤ 1 / (kc ^ 2 + t ^ 2) := by
    rw [norm_div, norm_one, norm_pow]
    exact one_div_le_one_div_of_le (by positivity) (norm_cos_wL t)
  have hA2 : ‖(Real.pi:ℂ) * (-Complex.I) / 2‖ = Real.pi / 2 := by
    rw [norm_div, norm_mul, norm_neg, Complex.norm_I, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos Real.pi_pos]
    norm_num
  have hA3 : ‖(sL t)⁻¹‖ ≤ 4 := by
    rw [norm_inv]
    have h := norm_sL_ge t
    rw [inv_le_comm₀ (by linarith) (by norm_num)]
    linarith
  have hB2 : ‖-Complex.I / (sL t) ^ 2‖ = 1 / ((1/4:ℝ) ^ 2 + t ^ 2) := by
    rw [norm_div, norm_neg, Complex.norm_I, norm_pow, norm_sL_sq]
    norm_num
  have hT := norm_tan_wL t
  unfold tanPiece'
  refine (norm_add_le _ _).trans ?_
  rw [norm_mul, norm_mul, norm_mul, hA2, hB2]
  have h0 : 0 ≤ ‖1 / Complex.cos ((Real.pi:ℂ) * wL t / 2) ^ 2‖ := norm_nonneg _
  have h0' : 0 ≤ 1 / ((1/4:ℝ) ^ 2 + t ^ 2) := by positivity
  have hpi := Real.pi_pos
  have e1 : ‖1 / Complex.cos ((Real.pi:ℂ) * wL t / 2) ^ 2‖ * (Real.pi / 2) * ‖(sL t)⁻¹‖
      ≤ 1 / (kc ^ 2 + t ^ 2) * (Real.pi / 2) * 4 := by
    gcongr
  have e2 : ‖Complex.tan ((Real.pi:ℂ) * wL t / 2)‖ * (1 / ((1/4:ℝ) ^ 2 + t ^ 2))
      ≤ (1 / kc) * (1 / ((1/4:ℝ) ^ 2 + t ^ 2)) :=
    mul_le_mul_of_nonneg_right hT h0'
  have e3 : 1 / (kc ^ 2 + t ^ 2) * (Real.pi / 2) * 4 = 2 * Real.pi * (1 / (kc ^ 2 + t ^ 2)) := by
    ring
  linarith

/-- **The tangent piece by parts.** For `y > 1` and `T ≥ 0`:
`‖∫_{−T}^{T} y^(it)·tan(πw/2)/s dt‖ ≤ (8 + 2π² + 4π)/(κ·log y)`. -/
theorem tan_piece {y T : ℝ} (hy : 1 < y) (hT : 0 ≤ T) :
    ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * tanPiece t‖
      ≤ (8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / (kc * Real.log y) := by
  have hk := kc_pos
  have hpi := Real.pi_pos
  have hy0 : 0 < Real.log y := Real.log_pos hy
  have key := LeftKernel.osc_by_parts hy (by linarith : -T ≤ T)
    (fun t _ => hasDerivAt_tanPiece t) (continuous_tanPiece'.intervalIntegrable _ _)
  refine key.trans ?_
  have hend : ∀ t : ℝ, ‖tanPiece t‖ ≤ 4 / kc := by
    intro t
    unfold tanPiece
    rw [norm_mul, norm_inv]
    have h := norm_sL_ge t
    have h1 : ‖sL t‖⁻¹ ≤ 4 := by
      rw [inv_le_comm₀ (by linarith) (by norm_num)]
      linarith
    have h2 := norm_tan_wL t
    calc ‖Complex.tan ((Real.pi:ℂ) * wL t / 2)‖ * ‖sL t‖⁻¹ ≤ (1 / kc) * 4 := by
          gcongr
      _ = 4 / kc := by ring
  have hbc : Continuous fun t : ℝ => 2 * Real.pi * (1 / (kc ^ 2 + t ^ 2))
      + (1 / kc) * (1 / ((1/4:ℝ) ^ 2 + t ^ 2)) := by
    refine Continuous.add (continuous_const.mul ?_) (continuous_const.mul ?_)
    · exact continuous_const.div (by fun_prop) (fun t => by positivity)
    · exact continuous_const.div (by fun_prop) (fun t => by positivity)
  have hint : (∫ t in (-T)..T, ‖tanPiece' t‖)
      ≤ ∫ t in (-T)..T, (2 * Real.pi * (1 / (kc ^ 2 + t ^ 2))
        + (1 / kc) * (1 / ((1/4:ℝ) ^ 2 + t ^ 2))) :=
    intervalIntegral.integral_mono_on (by linarith)
      (continuous_tanPiece'.norm.intervalIntegrable _ _) (hbc.intervalIntegrable _ _)
      (fun t _ => norm_tanPiece'_le t)
  have hsplit : (∫ t in (-T)..T, (2 * Real.pi * (1 / (kc ^ 2 + t ^ 2))
        + (1 / kc) * (1 / ((1/4:ℝ) ^ 2 + t ^ 2))))
      = 2 * Real.pi * (∫ t in (-T)..T, 1 / (kc ^ 2 + t ^ 2))
        + (1 / kc) * ∫ t in (-T)..T, 1 / ((1/4:ℝ) ^ 2 + t ^ 2) := by
    rw [intervalIntegral.integral_add, intervalIntegral.integral_const_mul,
      intervalIntegral.integral_const_mul]
    · exact (continuous_const.mul (continuous_const.div (by fun_prop)
        (fun t => by positivity))).intervalIntegrable _ _
    · exact (continuous_const.mul (continuous_const.div (by fun_prop)
        (fun t => by positivity))).intervalIntegrable _ _
  have ha1 := arctan_int_le (T := T) hk
  have ha2 := arctan_int_le (T := T) (by norm_num : (0:ℝ) < 1/4)
  have hb : (∫ t in (-T)..T, ‖tanPiece' t‖) ≤ (2 * Real.pi ^ 2 + 4 * Real.pi) / kc := by
    rw [hsplit] at hint
    refine hint.trans ?_
    have e : (2 * Real.pi ^ 2 + 4 * Real.pi) / kc
        = 2 * Real.pi * (Real.pi / kc) + (1 / kc) * (Real.pi / (1/4)) := by
      field_simp
      try ring
    rw [e]
    gcongr
  have h1 := hend (-T)
  have h2 := hend T
  rw [div_le_div_iff₀ hy0 (by positivity)]
  have hsum : ‖tanPiece (-T)‖ + ‖tanPiece T‖ + ∫ t in (-T)..T, ‖tanPiece' t‖
      ≤ (8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / kc := by
    have : (8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / kc
        = 4 / kc + 4 / kc + (2 * Real.pi ^ 2 + 4 * Real.pi) / kc := by ring
    linarith
  have := mul_le_mul_of_nonneg_left hsum (le_of_lt (mul_pos hk hy0))
  calc (‖tanPiece (-T)‖ + ‖tanPiece T‖ + ∫ t in (-T)..T, ‖tanPiece' t‖) * (kc * Real.log y)
      ≤ (8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / kc * (kc * Real.log y) := by
        rw [mul_comm _ (kc * Real.log y), mul_comm _ (kc * Real.log y)]; exact this
    _ = (8 + 2 * Real.pi ^ 2 + 4 * Real.pi) * Real.log y := by field_simp

/-- The digamma-series weight `1/((n+1)(n+5/4))`. -/
noncomputable def dgTerm (n : ℕ) : ℝ := 1 / (((n:ℝ) + 1) * ((n:ℝ) + 5/4))

/-- Each weight `1/((n+1)(n+5/4))` is nonnegative. -/
theorem dgTerm_nonneg (n : ℕ) : 0 ≤ dgTerm n := by
  unfold dgTerm
  positivity

/-- The weights `1/((n+1)(n+5/4))` are summable. -/
theorem dgTerm_summable : Summable dgTerm := by
  refine Summable.of_nonneg_of_le dgTerm_nonneg (fun n => ?_)
    Complex.summable_one_div_natCast_add_one_sq
  unfold dgTerm
  apply one_div_le_one_div_of_le (by positivity)
  have : (0:ℝ) ≤ n := Nat.cast_nonneg n
  nlinarith

/-- The digamma function along `w = 5/4 − it` is continuous. -/
theorem continuous_digamma_wL : Continuous fun t : ℝ => Complex.digamma (wL t) := by
  rw [continuous_iff_continuousAt]
  intro t
  have h : 0 < (wL t).re := by rw [wL_re]; norm_num
  exact (Complex.continuousAt_digamma_of_re_pos h).comp continuous_wL.continuousAt

/-- `y^(it)` is continuous in `t` for `y > 0`. -/
theorem continuous_cpow_tI {y : ℝ} (hy : 0 < y) :
    Continuous fun t : ℝ => (y:ℂ) ^ ((t:ℂ) * Complex.I) := by
  have hy0 : (y:ℂ) ≠ 0 := by exact_mod_cast hy.ne'
  exact Continuous.const_cpow (by fun_prop) (Or.inl hy0)

set_option maxHeartbeats 1600000 in
/-- **The digamma piece by the series.** For `y > 1` and `T ≥ 0`:
`‖∫_{−T}^{T} y^(it)·(−ψ(w) − γ)/s dt‖ ≤ (Σ' 1/((n+1)(n+5/4)))·(2+π)/log y`.
Termwise, `(−ψ(w) − γ)/s = Σ 1/((n+1)(n+w))` since `w − 1 = −s`, and each
term is the conjugate kernel. -/
theorem digamma_piece {y T : ℝ} (hy : 1 < y) (hT : 0 ≤ T) :
    ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I))
        * ((-Complex.digamma (wL t) - (Real.eulerMascheroniConstant:ℂ)) * (sL t)⁻¹)‖
      ≤ (∑' n : ℕ, dgTerm n) * ((2 + Real.pi) / Real.log y) := by
  have hy0 : 0 < y := by linarith
  have hly : 0 < Real.log y := Real.log_pos hy
  set F : ℕ → ℝ → ℂ := fun n t => ((y:ℂ) ^ ((t:ℂ) * Complex.I))
    * ((((n:ℂ) + 1))⁻¹ * ((((n:ℝ) + 5/4 : ℝ):ℂ) - (t:ℂ) * Complex.I)⁻¹) with hFdef
  have hc_ne : ∀ (n : ℕ) (t : ℝ), (((n:ℝ) + 5/4 : ℝ):ℂ) - (t:ℂ) * Complex.I ≠ 0 := by
    intro n t h
    have := congrArg Complex.re h
    simp at this
    have : (0:ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  have hn1 : ∀ n : ℕ, ((n:ℂ) + 1) ≠ 0 := by
    intro n
    exact_mod_cast Nat.succ_ne_zero n
  have hpt : ∀ t : ℝ, HasSum (fun n => F n t) (((y:ℂ) ^ ((t:ℂ) * Complex.I))
      * ((-Complex.digamma (wL t) - (Real.eulerMascheroniConstant:ℂ)) * (sL t)⁻¹)) := by
    intro t
    have hwn : ∀ n : ℕ, wL t ≠ -n := by
      intro n h
      have := congrArg Complex.re h
      rw [wL_re] at this
      simp at this
      have : (0:ℝ) ≤ n := Nat.cast_nonneg n
      linarith
    have hS := (Complex.hasSum_digamma hwn).mul_left
      (-((y:ℂ) ^ ((t:ℂ) * Complex.I)) * (sL t)⁻¹)
    have hval : -((y:ℂ) ^ ((t:ℂ) * Complex.I)) * (sL t)⁻¹
        * (Complex.digamma (wL t) + (Real.eulerMascheroniConstant:ℂ))
        = ((y:ℂ) ^ ((t:ℂ) * Complex.I))
          * ((-Complex.digamma (wL t) - (Real.eulerMascheroniConstant:ℂ)) * (sL t)⁻¹) := by
      ring
    rw [hval] at hS
    refine hS.congr_fun (fun n => ?_)
    have hw : (((n:ℝ) + 5/4 : ℝ):ℂ) - (t:ℂ) * Complex.I = (n:ℂ) + wL t := by
      unfold wL
      push_cast
      ring
    have hnw : (n:ℂ) + wL t ≠ 0 := by rw [← hw]; exact hc_ne n t
    have hs : sL t = 1 - wL t := (one_sub_wL t).symm
    have hs0 : (1:ℂ) - wL t ≠ 0 := by rw [← hs]; exact sL_ne t
    simp only [hFdef]
    rw [hw, hs]
    field_simp
    try ring
  have hcont : ∀ n, Continuous (F n) := by
    intro n
    simp only [hFdef]
    refine (continuous_cpow_tI hy0).mul (continuous_const.mul ?_)
    exact (by fun_prop : Continuous fun t : ℝ => (((n:ℝ) + 5/4 : ℝ):ℂ) - (t:ℂ) * Complex.I).inv₀
      (hc_ne n)
  have hnormc : ∀ (n : ℕ) (t : ℝ),
      ‖((((n:ℝ) + 5/4 : ℝ):ℂ) - (t:ℂ) * Complex.I)⁻¹‖ ≤ 1 / ((n:ℝ) + 5/4) := by
    intro n t
    have hc : (0:ℝ) < (n:ℝ) + 5/4 := by positivity
    rw [norm_inv, one_div]
    apply inv_anti₀ hc
    have e : (((n:ℝ) + 5/4 : ℝ):ℂ) - (t:ℂ) * Complex.I
        = (((n:ℝ) + 5/4 : ℝ):ℂ) + ((-t : ℝ):ℂ) * Complex.I := by push_cast; ring
    rw [e, Complex.norm_add_mul_I]
    apply Real.le_sqrt_of_sq_le
    nlinarith [sq_nonneg t]
  have hnorm1 : ∀ n : ℕ, ‖((n:ℂ) + 1)⁻¹‖ = 1 / ((n:ℝ) + 1) := by
    intro n
    rw [norm_inv, one_div]
    congr 1
    exact_mod_cast Complex.norm_natCast_add_one n
  have hbound : ∀ n t, ‖F n t‖ ≤ dgTerm n := by
    intro n t
    simp only [hFdef]
    rw [norm_mul, norm_mul, LeftKernel.norm_cpow_tI hy0, one_mul, hnorm1]
    have := hnormc n t
    unfold dgTerm
    calc 1 / ((n:ℝ) + 1) * ‖((((n:ℝ) + 5/4 : ℝ):ℂ) - (t:ℂ) * Complex.I)⁻¹‖
        ≤ 1 / ((n:ℝ) + 1) * (1 / ((n:ℝ) + 5/4)) := by gcongr
      _ = 1 / (((n:ℝ) + 1) * ((n:ℝ) + 5/4)) := by rw [one_div_mul_one_div]
  have hsum := intervalIntegral.hasSum_integral_of_dominated_convergence
    (μ := volume) (a := -T) (b := T) (F := F)
    (fun n _ => dgTerm n)
    (fun n => (hcont n).aestronglyMeasurable)
    (fun n => Filter.Eventually.of_forall (fun t _ => hbound n t))
    (Filter.Eventually.of_forall (fun _ _ => dgTerm_summable))
    intervalIntegrable_const
    (Filter.Eventually.of_forall (fun t _ => hpt t))
  have hterm : ∀ n, ‖∫ t in (-T)..T, F n t‖ ≤ dgTerm n * ((2 + Real.pi) / Real.log y) := by
    intro n
    have hc : (0:ℝ) < (n:ℝ) + 5/4 := by positivity
    have e : (fun t => F n t) = fun (t : ℝ) => ((n:ℂ) + 1)⁻¹ * (((y:ℂ) ^ ((t:ℂ) * Complex.I))
        * ((((n:ℝ) + 5/4 : ℝ):ℂ) - (t:ℂ) * Complex.I)⁻¹) := by
      funext t
      simp only [hFdef]
      ring
    rw [e, intervalIntegral.integral_const_mul, norm_mul, hnorm1]
    have hk := kernel_conj hy hT hc
    unfold dgTerm
    calc 1 / ((n:ℝ) + 1) * ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I))
          * ((((n:ℝ) + 5/4 : ℝ):ℂ) - (t:ℂ) * Complex.I)⁻¹‖
        ≤ 1 / ((n:ℝ) + 1) * ((2 + Real.pi) / (((n:ℝ) + 5/4) * Real.log y)) := by gcongr
      _ = 1 / (((n:ℝ) + 1) * ((n:ℝ) + 5/4)) * ((2 + Real.pi) / Real.log y) := by
        field_simp
  have hfin := hsum.norm_le_of_bounded
    (dgTerm_summable.hasSum.mul_right ((2 + Real.pi) / Real.log y)) hterm
  exact hfin

/-- The tangent piece is continuous. -/
theorem continuous_tanPiece : Continuous tanPiece := by
  rw [continuous_iff_continuousAt]
  exact fun t => (hasDerivAt_tanPiece t).continuousAt

/-- On the line, `x^s = x^(−1/4)·x^(it)` for `x > 0`. -/
theorem cpow_sL {x : ℝ} (hx : 0 < x) (t : ℝ) :
    (x:ℂ) ^ (sL t) = ((x ^ (-(1:ℝ)/4) : ℝ):ℂ) * (x:ℂ) ^ ((t:ℂ) * Complex.I) := by
  have hx0 : (x:ℂ) ≠ 0 := by exact_mod_cast hx.ne'
  unfold sL
  rw [Complex.cpow_add _ _ hx0, Complex.ofReal_cpow hx.le]

/-- The constant of the smooth factor's flat part: `log 2π + γ`. -/
noncomputable def c0 : ℂ := Complex.log (2 * (Real.pi:ℂ)) + (Real.eulerMascheroniConstant:ℂ)

/-- The numerator of the smooth-side constant:
`‖log 2π + γ‖·(1+4π) + (Σ' 1/((n+1)(n+5/4)))·(2+π) + (π/2)·(8+2π²+4π)/κ`. -/
noncomputable def Nsm : ℝ :=
  ‖c0‖ * (1 + 4 * Real.pi) + (∑' n : ℕ, dgTerm n) * (2 + Real.pi)
    + Real.pi / 2 * ((8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / kc)

/-- The numerator `Nsm` is nonnegative. -/
theorem Nsm_nonneg : 0 ≤ Nsm := by
  have hk := kc_pos
  have hpi := Real.pi_pos
  have hs : 0 ≤ ∑' n : ℕ, dgTerm n := tsum_nonneg dgTerm_nonneg
  unfold Nsm
  positivity

/-- **The smooth-side constant** `Bsm = Nsm / log 16`, free of `x` and `T`. -/
noncomputable def Bsm : ℝ := Nsm / Real.log 16

set_option maxHeartbeats 1600000 in
/-- **F2c, the smooth side.** For `16 ≤ x` and `2 ≤ T`, with `s = −1/4 + it` and
`w = 5/4 − it`, the integral of `(ζ′/ζ(s) + ζ′/ζ(w))·x^s/s` over `[−T, T]` has norm at
most `Bsm·x^(−1/4)`. Inside, the sum of the two logarithmic derivatives is
`log 2π − ψ(w) + (π/2)·tan(πw/2)`, and each of its three parts is integrated by
parts against `x^(it)` (the digamma part termwise through its series). -/
theorem smooth_side {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖∫ t in (-T)..T, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
          / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
        + deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
      ≤ Bsm * x ^ (-(1:ℝ)/4) := by
  have hx0 : 0 < x := by linarith
  have hx1 : 1 < x := by linarith
  have hT0 : 0 < T := by linarith
  have hlx : 0 < Real.log x := Real.log_pos hx1
  have hl16 : 0 < Real.log 16 := Real.log_pos (by norm_num)
  have hl16x : Real.log 16 ≤ Real.log x := Real.log_le_log (by norm_num) hx
  have hpi := Real.pi_pos
  have hk := kc_pos
  set X : ℝ := x ^ (-(1:ℝ)/4) with hXdef
  have hX0 : 0 ≤ X := Real.rpow_nonneg hx0.le _
  set A : ℝ → ℂ := fun t => ((x:ℂ) ^ ((t:ℂ) * Complex.I)) * (c0 * (sL t)⁻¹) with hAdef
  set M : ℝ → ℂ := fun t => ((x:ℂ) ^ ((t:ℂ) * Complex.I))
    * ((-Complex.digamma (wL t) - (Real.eulerMascheroniConstant:ℂ)) * (sL t)⁻¹) with hMdef
  set C : ℝ → ℂ := fun t => ((x:ℂ) ^ ((t:ℂ) * Complex.I)) * tanPiece t with hCdef
  have hpt : ∀ t : ℝ, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
          / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
        + deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
      = (X:ℂ) * (A t + M t + ((Real.pi:ℂ) / 2) * C t) := by
    intro t
    change (deriv riemannZeta (sL t) / riemannZeta (sL t)
        + deriv riemannZeta (wL t) / riemannZeta (wL t)) * ((x:ℂ) ^ (sL t)) / (sL t) = _
    have hw : 1 < (wL t).re := by rw [wL_re]; norm_num
    obtain ⟨_, hG⟩ := logDeriv_sum hw (cos_wL_ne t)
    rw [one_sub_wL] at hG
    rw [hG, cpow_sL hx0, ← hXdef]
    simp only [hAdef, hMdef, hCdef, tanPiece, Gs, c0]
    field_simp [sL_ne t]
    try ring
  have hint : (∫ t in (-T)..T, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
          / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
        + deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
      = ∫ t in (-T)..T, (X:ℂ) * (A t + M t + ((Real.pi:ℂ) / 2) * C t) := by
    congr 1
    funext t
    exact hpt t
  have hcA : Continuous A := (continuous_cpow_tI hx0).mul
    (continuous_const.mul (continuous_sL.inv₀ sL_ne))
  have hcM : Continuous M := (continuous_cpow_tI hx0).mul
    ((continuous_digamma_wL.neg.sub continuous_const).mul (continuous_sL.inv₀ sL_ne))
  have hcC : Continuous C := (continuous_cpow_tI hx0).mul continuous_tanPiece
  rw [hint, intervalIntegral.integral_const_mul, intervalIntegral.integral_add,
    intervalIntegral.integral_add, intervalIntegral.integral_const_mul]
  rotate_left
  · exact hcA.intervalIntegrable _ _
  · exact hcM.intervalIntegrable _ _
  · exact (hcA.add hcM).intervalIntegrable _ _
  · exact (continuous_const.mul hcC).intervalIntegrable _ _
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hX0, mul_comm Bsm X]
  apply mul_le_mul_of_nonneg_left _ hX0
  -- the three pieces
  have hAb : ‖∫ t in (-T)..T, A t‖ ≤ ‖c0‖ * (1 + 4 * Real.pi) / Real.log x := by
    have e : (fun t => A t) = fun (t : ℝ) => c0 * (((x:ℂ) ^ ((t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)) := by
      funext t
      simp only [hAdef, sL]
      ring
    rw [e, intervalIntegral.integral_const_mul, norm_mul]
    have hkb := LeftKernel.kernel_bound (y := x) (T := T) (a := -1/4) hx1 hT0 (by norm_num)
    have habs : |(-1/4 : ℝ)| = 1 / 4 := by norm_num [abs_of_neg]
    rw [habs] at hkb
    have h2T : 2 / T ≤ 1 := by rw [div_le_iff₀ hT0]; linarith
    have hkb2 : (2 / T + Real.pi / (1/4)) / Real.log x ≤ (1 + 4 * Real.pi) / Real.log x := by
      apply div_le_div_of_nonneg_right _ hlx.le
      have : Real.pi / (1/4) = 4 * Real.pi := by ring
      linarith
    calc ‖c0‖ * ‖∫ t in (-T)..T, ((x:ℂ) ^ ((t:ℂ) * Complex.I))
          / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
        ≤ ‖c0‖ * ((1 + 4 * Real.pi) / Real.log x) := by
          gcongr
          exact hkb.trans hkb2
      _ = ‖c0‖ * (1 + 4 * Real.pi) / Real.log x := by ring
  have hMb : ‖∫ t in (-T)..T, M t‖ ≤ (∑' n : ℕ, dgTerm n) * ((2 + Real.pi) / Real.log x) :=
    digamma_piece hx1 hT0.le
  have hCb : ‖((Real.pi:ℂ) / 2) * ∫ t in (-T)..T, C t‖
      ≤ Real.pi / 2 * ((8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / (kc * Real.log x)) := by
    rw [norm_mul]
    have e : ‖((Real.pi:ℂ) / 2)‖ = Real.pi / 2 := by
      rw [norm_div, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hpi]
      norm_num
    rw [e]
    gcongr
    exact tan_piece hx1 hT0.le
  have htot : ‖(∫ t in (-T)..T, A t) + (∫ t in (-T)..T, M t)
      + ((Real.pi:ℂ) / 2) * ∫ t in (-T)..T, C t‖ ≤ Nsm / Real.log x := by
    refine (norm_add_le _ _).trans ?_
    have h3 := norm_add_le (∫ t in (-T)..T, A t) (∫ t in (-T)..T, M t)
    have e : Nsm / Real.log x = ‖c0‖ * (1 + 4 * Real.pi) / Real.log x
        + (∑' n : ℕ, dgTerm n) * ((2 + Real.pi) / Real.log x)
        + Real.pi / 2 * ((8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / (kc * Real.log x)) := by
      unfold Nsm
      ring
    rw [e]
    linarith
  refine htot.trans ?_
  unfold Bsm
  exact div_le_div_of_nonneg_left Nsm_nonneg hl16 hl16x

/-- info: 'LeftSmooth.smooth_side' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms smooth_side

/-- Along a continuous path that avoids `1` and the zeros of `ζ`, the logarithmic
derivative `ζ′/ζ` is continuous. -/
theorem continuous_logDeriv_path {p : ℝ → ℂ} (hp : Continuous p) (h1 : ∀ t, p t ≠ 1)
    (h0 : ∀ t, riemannZeta (p t) ≠ 0) :
    Continuous fun t => deriv riemannZeta (p t) / riemannZeta (p t) := by
  rw [continuous_iff_continuousAt]
  intro t
  have han := ContourShift.zeta_analyticAt (h1 t)
  exact (han.deriv.continuousAt.comp hp.continuousAt).div
    (han.continuousAt.comp hp.continuousAt) (h0 t)

/-- `ζ(s) ≠ 0` on the line `Re s = −1/4`. -/
theorem zeta_sL_ne (t : ℝ) : riemannZeta (sL t) ≠ 0 := by
  have hw : 1 < (wL t).re := by rw [wL_re]; norm_num
  have h := (logDeriv_sum hw (cos_wL_ne t)).1
  rwa [one_sub_wL] at h

/-- `ζ(w) ≠ 0` on the line `Re w = 5/4`. -/
theorem zeta_wL_ne (t : ℝ) : riemannZeta (wL t) ≠ 0 :=
  riemannZeta_ne_zero_of_one_lt_re (by rw [wL_re]; norm_num)

/-- `s ≠ 1` on the line. -/
theorem sL_ne_one (t : ℝ) : sL t ≠ 1 := by
  intro h
  have := congrArg Complex.re h
  simp [sL] at this
  norm_num at this

/-- `w ≠ 1` on the line. -/
theorem wL_ne_one (t : ℝ) : wL t ≠ 1 := by
  intro h
  have := congrArg Complex.re h
  rw [wL_re] at this
  simp at this
  norm_num at this

/-- **The left-edge constant** `Bleft = Bsm + Bser`. -/
noncomputable def Bleft : ℝ := Bsm + LeftKernel.Bser

set_option maxHeartbeats 1600000 in
/-- **F2, the left edge at every height.** For `16 ≤ x` and `2 ≤ T`, the integral of
`−ζ′/ζ(s)·x^s/s` up `Re s = −1/4` from `−T` to `T` has norm at most `Bleft·x^(−1/4)`,
with `Bleft` free of `x` and `T`: the smooth side plus the series side. -/
theorem left_edge_bound {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖VIntegral (Glue.Gf x) (-1/4) (-T) T‖ ≤ Bleft * x ^ (-(1:ℝ)/4) := by
  have hx0 : 0 < x := by linarith
  have hS : ‖∫ t in (-T)..T, (deriv riemannZeta (sL t) / riemannZeta (sL t)
      + deriv riemannZeta (wL t) / riemannZeta (wL t)) * ((x:ℂ) ^ (sL t)) / (sL t)‖
      ≤ Bsm * x ^ (-(1:ℝ)/4) := smooth_side hx hT
  have hR : ‖∫ t in (-T)..T, (deriv riemannZeta (wL t) / riemannZeta (wL t))
      * ((x:ℂ) ^ (sL t)) / (sL t)‖ ≤ LeftKernel.Bser * x ^ (-(1:ℝ)/4) :=
    LeftKernel.series_side hx hT
  have hcs := continuous_logDeriv_path continuous_sL sL_ne_one zeta_sL_ne
  have hcw := continuous_logDeriv_path continuous_wL wL_ne_one zeta_wL_ne
  have hx0' : (x:ℂ) ≠ 0 := by exact_mod_cast hx0.ne'
  have hcx : Continuous fun t => (x:ℂ) ^ (sL t) :=
    Continuous.const_cpow continuous_sL (Or.inl hx0')
  have hiS : IntervalIntegrable (fun t => (deriv riemannZeta (sL t) / riemannZeta (sL t)
      + deriv riemannZeta (wL t) / riemannZeta (wL t)) * ((x:ℂ) ^ (sL t)) / (sL t))
      volume (-T) T :=
    (((hcs.add hcw).mul hcx).div continuous_sL sL_ne).intervalIntegrable _ _
  have hiR : IntervalIntegrable (fun t => (deriv riemannZeta (wL t) / riemannZeta (wL t))
      * ((x:ℂ) ^ (sL t)) / (sL t)) volume (-T) T :=
    ((hcw.mul hcx).div continuous_sL sL_ne).intervalIntegrable _ _
  have e : (∫ y in (-T)..T, Glue.Gf x (((-1/4 : ℝ):ℂ) + (y:ℂ) * Complex.I))
      = (∫ t in (-T)..T, (deriv riemannZeta (wL t) / riemannZeta (wL t))
          * ((x:ℂ) ^ (sL t)) / (sL t))
        - ∫ t in (-T)..T, (deriv riemannZeta (sL t) / riemannZeta (sL t)
          + deriv riemannZeta (wL t) / riemannZeta (wL t)) * ((x:ℂ) ^ (sL t)) / (sL t) := by
    rw [← intervalIntegral.integral_sub hiR hiS]
    congr 1
    funext t
    change Glue.Gf x (sL t) = _
    simp only [Glue.Gf]
    ring
  unfold VIntegral
  rw [norm_smul, Complex.norm_I, one_mul, e]
  refine (norm_sub_le _ _).trans ?_
  unfold Bleft
  linarith

/-- info: 'LeftSmooth.left_edge_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms left_edge_bound

/-- **F3, the explicit formula at every height.** For `16 ≤ x` and every `T ≥ 2`:
`‖ψ(x) − x + Σ_{|γ|<T} m·x^ρ/ρ‖ ≤ c1n·x·log²(xT)/T + c3n·log x + Bleft·x^(−1/4)`,
with no cap on `T` and the left edge bounded free of the height. -/
theorem explicit_formula_all {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
      ≤ Glue.c1n * x * Real.log (x*T)^2 / T + Glue.c3n * Real.log x
        + Bleft * x ^ (-(1:ℝ)/4) := by
  obtain ⟨T', hTT', _, hF⟩ := ExplicitLeft.explicit_formula_left hx hT
  have hE := left_edge_bound hx (le_trans hT hTT')
  linarith

/-- info: 'LeftSmooth.explicit_formula_all' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms explicit_formula_all

end LeftSmooth
