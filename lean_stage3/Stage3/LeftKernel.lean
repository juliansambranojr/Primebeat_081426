/-
LeftKernel — blocks F2a and F2b of `lean_stage3/design/leftedge.md`. 2026-11-23.

The left edge of the explicit formula is the integral of `−ζ'/ζ(s)·x^s/s` up
the line `s = −1/4 + it`. An absolute value there loses `log²T`; the factor
`x^(it)` turns, and one integration by parts against it gains `1/log x`. This
module holds the oscillation tools and the Dirichlet-series half of the edge.

  osc_by_parts   1 < y, a ≤ b, h with derivative h′ on [a,b], h′ integrable ⊢
                   ‖∫_a^b y^(it)·h‖ ≤ (‖h a‖ + ‖h b‖ + ∫_a^b ‖h′‖)/log y
  kernel_bound   (F2a) 1 < y, 0 < T, a ≠ 0 ⊢
                   ‖∫_{−T}^{T} y^(it)/(a+it) dt‖ ≤ (2/T + π/|a|)/log y
  vmTerm n       Λ(n)·n^(−5/4)
  Bser           ((1 + 4π)/log 16)·Σ' n, vmTerm n
  series_side    (F2b) 16 ≤ x, 2 ≤ T ⊢
                   ‖∫_{−T}^{T} ζ'/ζ(5/4 − it)·x^(−1/4+it)/(−1/4+it) dt‖ ≤ Bser·x^(−1/4)

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ExplicitLeft

namespace LeftKernel

open Complex Set MeasureTheory

/-- For `y > 0`, the turning factor `y^(it)` is the exponential
`exp(log y · it)`. -/
theorem cpow_tI {y : ℝ} (hy : 0 < y) (t : ℝ) :
    (y:ℂ) ^ ((t:ℂ) * Complex.I) = Complex.exp ((Real.log y : ℂ) * ((t:ℂ) * Complex.I)) := by
  rw [Complex.cpow_def_of_ne_zero (by exact_mod_cast hy.ne'), ← Complex.ofReal_log hy.le]

/-- The exponential `exp(L · it)` of a purely imaginary number has norm one. -/
theorem norm_exp_tI (L t : ℝ) : ‖Complex.exp ((L:ℂ) * ((t:ℂ) * Complex.I))‖ = 1 := by
  rw [Complex.norm_exp]
  simp

/-- For `y > 0`, the turning factor `y^(it)` has norm one. -/
theorem norm_cpow_tI {y : ℝ} (hy : 0 < y) (t : ℝ) :
    ‖(y:ℂ) ^ ((t:ℂ) * Complex.I)‖ = 1 := by
  rw [cpow_tI hy, norm_exp_tI]

/-- **Integration by parts against the turning factor.** For `y > 1`, `a ≤ b`,
and `h` with derivative `h′` on `[a,b]`, `h′` integrable:
`‖∫_a^b y^(it)·h(t) dt‖ ≤ (‖h a‖ + ‖h b‖ + ∫_a^b ‖h′‖)/log y`. -/
theorem osc_by_parts {y a b : ℝ} (hy : 1 < y) (hab : a ≤ b) {h h' : ℝ → ℂ}
    (hd : ∀ t ∈ Set.uIcc a b, HasDerivAt h (h' t) t)
    (hi : IntervalIntegrable h' volume a b) :
    ‖∫ t in a..b, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * h t‖
      ≤ (‖h a‖ + ‖h b‖ + ∫ t in a..b, ‖h' t‖) / Real.log y := by
  have hy0 : 0 < y := by linarith
  set L : ℝ := Real.log y with hLdef
  have hL : 0 < L := Real.log_pos hy
  have hLI : (L:ℂ) * Complex.I ≠ 0 :=
    mul_ne_zero (by exact_mod_cast hL.ne') Complex.I_ne_zero
  set v : ℝ → ℂ := fun t => Complex.exp ((L:ℂ) * ((t:ℂ) * Complex.I)) / ((L:ℂ) * Complex.I)
    with hvdef
  have hv : ∀ t : ℝ, HasDerivAt v (Complex.exp ((L:ℂ) * ((t:ℂ) * Complex.I))) t := by
    intro t
    have h1 : HasDerivAt (fun t : ℝ => (L:ℂ) * ((t:ℂ) * Complex.I)) ((L:ℂ) * Complex.I) t := by
      have := (((hasDerivAt_id' t).ofReal_comp).mul_const Complex.I).const_mul (L:ℂ)
      simpa using this
    have h3 := h1.cexp.div_const ((L:ℂ) * Complex.I)
    refine h3.congr_deriv ?_
    rw [mul_div_assoc, div_self hLI, mul_one]
  have hvn : ∀ t : ℝ, ‖v t‖ = 1 / L := by
    intro t
    simp only [hvdef, norm_div, norm_exp_tI, norm_mul, Complex.norm_I, mul_one,
      Complex.norm_real, Real.norm_eq_abs, abs_of_pos hL]
  have hcont : Continuous fun t : ℝ => Complex.exp ((L:ℂ) * ((t:ℂ) * Complex.I)) := by
    fun_prop
  have hibp := intervalIntegral.integral_mul_deriv_eq_deriv_mul (u := h) (v := v)
    hd (fun t _ => hv t) hi (hcont.intervalIntegrable _ _)
  have e : (∫ t in a..b, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * h t)
      = ∫ t in a..b, h t * Complex.exp ((L:ℂ) * ((t:ℂ) * Complex.I)) := by
    congr 1
    funext t
    rw [cpow_tI hy0, mul_comm]
  rw [e, hibp]
  have hint : ‖∫ t in a..b, h' t * v t‖ ≤ (∫ t in a..b, ‖h' t‖) * (1 / L) := by
    refine (intervalIntegral.norm_integral_le_integral_norm hab).trans (le_of_eq ?_)
    simp_rw [norm_mul, hvn]
    exact intervalIntegral.integral_mul_const _ _
  have hb : ‖h b * v b‖ = ‖h b‖ * (1 / L) := by rw [norm_mul, hvn]
  have ha : ‖h a * v a‖ = ‖h a‖ * (1 / L) := by rw [norm_mul, hvn]
  calc ‖h b * v b - h a * v a - ∫ t in a..b, h' t * v t‖
      ≤ ‖h b * v b‖ + ‖h a * v a‖ + ‖∫ t in a..b, h' t * v t‖ := by
        refine (norm_sub_le _ _).trans ?_
        gcongr
        exact norm_sub_le _ _
    _ ≤ ‖h b‖ * (1 / L) + ‖h a‖ * (1 / L) + (∫ t in a..b, ‖h' t‖) * (1 / L) := by
        rw [hb, ha]
        linarith
    _ = (‖h a‖ + ‖h b‖ + ∫ t in a..b, ‖h' t‖) / L := by ring

/-- info: 'LeftKernel.osc_by_parts' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms osc_by_parts

/-- **F2a, the kernel.** For `y > 1`, `T > 0` and real `a ≠ 0`:
`‖∫_{−T}^{T} y^(it)/(a+it) dt‖ ≤ (2/T + π/|a|)/log y`. -/
theorem kernel_bound {y T a : ℝ} (hy : 1 < y) (hT : 0 < T) (ha : a ≠ 0) :
    ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) / ((a:ℂ) + (t:ℂ) * Complex.I)‖
      ≤ (2 / T + Real.pi / |a|) / Real.log y := by
  have hne : ∀ t : ℝ, (a:ℂ) + (t:ℂ) * Complex.I ≠ 0 := by
    intro t h
    apply ha
    have := congrArg Complex.re h
    simpa using this
  have hnorm : ∀ t : ℝ, ‖(a:ℂ) + (t:ℂ) * Complex.I‖ = √(a ^ 2 + t ^ 2) :=
    fun t => Complex.norm_add_mul_I a t
  have hpos : ∀ t : ℝ, 0 < a ^ 2 + t ^ 2 := fun t => by positivity
  have hd : ∀ t ∈ Set.uIcc (-T) T,
      HasDerivAt (fun t : ℝ => ((a:ℂ) + (t:ℂ) * Complex.I)⁻¹)
        (-Complex.I / ((a:ℂ) + (t:ℂ) * Complex.I) ^ 2) t := by
    intro t _
    have h1 : HasDerivAt (fun t : ℝ => (a:ℂ) + (t:ℂ) * Complex.I) Complex.I t := by
      have := (((hasDerivAt_id' t).ofReal_comp).mul_const Complex.I).const_add (a:ℂ)
      simpa using this
    exact h1.inv (hne t)
  have hcont : Continuous fun t : ℝ => -Complex.I / ((a:ℂ) + (t:ℂ) * Complex.I) ^ 2 :=
    continuous_const.div (by fun_prop) (fun t => pow_ne_zero _ (hne t))
  have key := osc_by_parts hy (by linarith : -T ≤ T) hd (hcont.intervalIntegrable _ _)
  have e : (∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) / ((a:ℂ) + (t:ℂ) * Complex.I))
      = ∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * ((a:ℂ) + (t:ℂ) * Complex.I)⁻¹ := by
    simp only [div_eq_mul_inv]
  rw [e]
  refine key.trans (div_le_div_of_nonneg_right ?_ (Real.log_pos hy).le)
  -- the two endpoint terms
  have hend : ∀ t : ℝ, |t| = T → ‖((a:ℂ) + (t:ℂ) * Complex.I)⁻¹‖ ≤ 1 / T := by
    intro t ht
    rw [norm_inv, hnorm, one_div]
    apply inv_anti₀ hT
    apply Real.le_sqrt_of_sq_le
    have : t ^ 2 = T ^ 2 := by rw [← sq_abs, ht]
    nlinarith [sq_nonneg a]
  have h1 := hend (-T) (by rw [abs_neg, abs_of_pos hT])
  have h2 := hend T (abs_of_pos hT)
  -- the derivative's norm
  have hder : ∀ t : ℝ, ‖-Complex.I / ((a:ℂ) + (t:ℂ) * Complex.I) ^ 2‖ = 1 / (a ^ 2 + t ^ 2) := by
    intro t
    rw [norm_div, norm_neg, Complex.norm_I, norm_pow, hnorm, Real.sq_sqrt (hpos t).le]
  have hI : (∫ t in (-T)..T, ‖-Complex.I / ((a:ℂ) + (t:ℂ) * Complex.I) ^ 2‖)
      = ∫ t in (-T)..T, 1 / (a ^ 2 + t ^ 2) := by
    simp_rw [hder]
  -- the arctan primitive
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
  have harc : (∫ t in (-T)..T, 1 / (a ^ 2 + t ^ 2)) ≤ Real.pi / |a| := by
    rw [hval]
    calc Real.arctan (T / a) / a - Real.arctan (-T / a) / a
        = 2 * Real.arctan (T / a) / a := by rw [neg_div, Real.arctan_neg]; ring
      _ ≤ |2 * Real.arctan (T / a) / a| := le_abs_self _
      _ = 2 * |Real.arctan (T / a)| / |a| := by rw [abs_div, abs_mul, abs_two]
      _ ≤ 2 * (Real.pi / 2) / |a| := by gcongr
      _ = Real.pi / |a| := by ring
  rw [hI]
  have : (2:ℝ) / T = 1 / T + 1 / T := by ring
  rw [this]
  linarith

/-- info: 'LeftKernel.kernel_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms kernel_bound

/-- The `n`-th term of the von Mangoldt series at `5/4`: `Λ(n)·n^(−5/4)`. -/
noncomputable def vmTerm (n : ℕ) : ℝ :=
  ArithmeticFunction.vonMangoldt n * (n:ℝ) ^ (-(5:ℝ)/4)

/-- Each term `Λ(n)·n^(−5/4)` is nonnegative. -/
theorem vmTerm_nonneg (n : ℕ) : 0 ≤ vmTerm n :=
  mul_nonneg ArithmeticFunction.vonMangoldt_nonneg (Real.rpow_nonneg (Nat.cast_nonneg _) _)

/-- The series `Σ Λ(n)·n^(−5/4)` converges. -/
theorem vmTerm_summable : Summable vmTerm := by
  have hs : 1 < ((5/4 : ℝ) : ℂ).re := by simp; norm_num
  have h := ArithmeticFunction.LSeriesSummable_vonMangoldt hs
  rw [LSeriesSummable, ← summable_norm_iff] at h
  refine h.congr (fun n => ?_)
  rw [LSeries.norm_term_eq]
  rcases eq_or_ne n 0 with rfl | hn
  · simp [vmTerm]
  · rw [if_neg hn, vmTerm, Complex.ofReal_re, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg ArithmeticFunction.vonMangoldt_nonneg,
      show -(5:ℝ)/4 = -(5/4) by ring, Real.rpow_neg (Nat.cast_nonneg _), div_eq_mul_inv]

/-- The series-side constant: `((1 + 4π)/log 16)·Σ' n, Λ(n)·n^(−5/4)`. -/
noncomputable def Bser : ℝ :=
  ((1 + 4 * Real.pi) / Real.log 16) * ∑' n : ℕ, vmTerm n

set_option maxHeartbeats 1600000 in
/-- **F2b, the series side.** For `16 ≤ x` and `2 ≤ T`, the Dirichlet-series
half of the left edge, `∫_{−T}^{T} ζ'/ζ(5/4 − it)·x^(−1/4+it)/(−1/4+it) dt`, has
norm at most `Bser·x^(−1/4)`, with `Bser` free of `x` and `T`. -/
theorem series_side {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖∫ t in (-T)..T, (deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
        / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
      ≤ Bser * x ^ (-(1:ℝ)/4) := by
  have hx0 : 0 < x := by linarith
  have hT0 : 0 < T := by linarith
  set X : ℝ := x ^ (-(1:ℝ)/4) with hXdef
  have hX0 : 0 ≤ X := Real.rpow_nonneg hx0.le _
  set K0 : ℝ := (1 + 4 * Real.pi) / Real.log 16 with hK0def
  set s : ℝ → ℂ := fun t => ((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I with hsdef
  have hs_ne : ∀ t, s t ≠ 0 := by
    intro t h
    have := congrArg Complex.re h
    simp [hsdef] at this
  have hs_norm : ∀ t, 1 / 4 ≤ ‖s t‖ := by
    intro t
    have h := Complex.abs_re_le_norm (s t)
    have hre : (s t).re = -1/4 := by simp [hsdef]
    rw [hre] at h
    norm_num at h
    linarith
  set G : ℕ → ℝ → ℂ := fun n t =>
    ((vmTerm n * X : ℝ) : ℂ) * (((x * (n:ℝ) : ℝ) : ℂ) ^ ((t:ℂ) * Complex.I) / s t) with hGdef
  have hG0 : G 0 = fun _ => 0 := by
    funext t
    simp [hGdef, vmTerm]
  -- pointwise: the series of `G n t` sums to minus the integrand
  have hpt : ∀ t : ℝ, HasSum (fun n => G n t)
      (-((deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
        / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))) := by
    intro t
    have hw : 1 < ((5/4:ℂ) - (t:ℂ) * Complex.I).re := by simp; norm_num
    have hL : HasSum (fun n => LSeries.term (fun n => ((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ))
        ((5/4:ℂ) - (t:ℂ) * Complex.I) n)
        (LSeries (fun n => ((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ))
          ((5/4:ℂ) - (t:ℂ) * Complex.I)) :=
      (ArithmeticFunction.LSeriesSummable_vonMangoldt hw).LSeriesHasSum
    rw [ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hw] at hL
    have hm := hL.mul_right ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / s t)
    have hfun : (fun n => G n t) = fun n =>
        LSeries.term (fun n => ((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ))
          ((5/4:ℂ) - (t:ℂ) * Complex.I) n
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / s t) := by
      funext n
      rcases eq_or_ne n 0 with rfl | hn
      · simp [hGdef, vmTerm]
      · have hn' : (0:ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
        rw [LSeries.term_of_ne_zero hn]
        have e1 : (n:ℂ) ^ ((5/4:ℂ) - (t:ℂ) * Complex.I)
            = Complex.exp ((Real.log n : ℂ) * ((5/4:ℂ) - (t:ℂ) * Complex.I)) := by
          rw [Complex.cpow_def_of_ne_zero (Nat.cast_ne_zero.mpr hn), Complex.natCast_log]
        have e2 : (x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
            = Complex.exp ((Real.log x : ℂ) * (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)) := by
          rw [Complex.cpow_def_of_ne_zero (by exact_mod_cast hx0.ne'),
            ← Complex.ofReal_log hx0.le]
        have e3 := cpow_tI (mul_pos hx0 hn') t
        have e4 : vmTerm n * X = ArithmeticFunction.vonMangoldt n
            * Real.exp (Real.log n * (-(5:ℝ)/4)) * Real.exp (Real.log x * (-(1:ℝ)/4)) := by
          rw [vmTerm, hXdef, Real.rpow_def_of_pos hn', Real.rpow_def_of_pos hx0]
        have key : (Complex.exp ((Real.log n : ℂ) * ((5/4:ℂ) - (t:ℂ) * Complex.I)))⁻¹
            * Complex.exp ((Real.log x : ℂ) * (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
            = Complex.exp ((Real.log n : ℂ) * (-(5:ℂ)/4))
              * Complex.exp ((Real.log x : ℂ) * (-(1:ℂ)/4))
              * Complex.exp ((Real.log (x * n) : ℂ) * ((t:ℂ) * Complex.I)) := by
          rw [← Complex.exp_neg, ← Complex.exp_add, ← Complex.exp_add, ← Complex.exp_add,
            Real.log_mul hx0.ne' hn'.ne']
          congr 1
          push_cast
          ring
        simp only [hGdef]
        rw [e1, e2, e3, e4]
        push_cast at key ⊢
        linear_combination (-((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ) / s t) * key
    have hval : -((deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
        / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        = -deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / s t) := by
      simp only [hsdef]
      ring
    rw [hfun, hval]
    exact hm
  -- continuity and the uniform bound of each `G n`
  have hcont : ∀ n, Continuous (G n) := by
    intro n
    rcases eq_or_ne n 0 with rfl | hn
    · rw [hG0]; exact continuous_const
    · have hn' : (0:ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
      have hy0 : ((x * (n:ℝ) : ℝ) : ℂ) ≠ 0 := by exact_mod_cast (mul_pos hx0 hn').ne'
      simp only [hGdef]
      exact continuous_const.mul
        ((Continuous.const_cpow (by fun_prop) (Or.inl hy0)).div (by fun_prop) hs_ne)
  have hbound : ∀ n t, ‖G n t‖ ≤ vmTerm n * X * 4 := by
    intro n t
    rcases eq_or_ne n 0 with rfl | hn
    · rw [hG0]; simp [vmTerm]
    · have hn' : (0:ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
      have hc : 0 ≤ vmTerm n * X := mul_nonneg (vmTerm_nonneg n) hX0
      simp only [hGdef]
      rw [norm_mul, norm_div, norm_cpow_tI (mul_pos hx0 hn'), Complex.norm_real,
        Real.norm_eq_abs, abs_of_nonneg hc]
      apply mul_le_mul_of_nonneg_left _ hc
      have h4 := hs_norm t
      rw [div_le_iff₀ (by linarith)]
      linarith
  -- exchange of sum and integral
  have hsum := intervalIntegral.hasSum_integral_of_dominated_convergence
    (μ := volume) (a := -T) (b := T) (F := G)
    (fun n _ => vmTerm n * X * 4)
    (fun n => (hcont n).aestronglyMeasurable)
    (fun n => Filter.Eventually.of_forall (fun t _ => hbound n t))
    (Filter.Eventually.of_forall (fun _ _ => (vmTerm_summable.mul_right X).mul_right 4))
    intervalIntegrable_const
    (Filter.Eventually.of_forall (fun t _ => hpt t))
  -- each term's integral
  have hterm : ∀ n, ‖∫ t in (-T)..T, G n t‖ ≤ vmTerm n * (X * K0) := by
    intro n
    rcases eq_or_ne n 0 with rfl | hn
    · rw [hG0]; simp [vmTerm]
    · have hn' : (0:ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
      have hn1 : (1:ℝ) ≤ n := by exact_mod_cast Nat.one_le_iff_ne_zero.mpr hn
      have hc : 0 ≤ vmTerm n * X := mul_nonneg (vmTerm_nonneg n) hX0
      have hy : 16 ≤ x * (n:ℝ) := by nlinarith
      simp only [hGdef, hsdef]
      rw [intervalIntegral.integral_const_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs,
        abs_of_nonneg hc]
      have hk := kernel_bound (y := x * (n:ℝ)) (T := T) (a := -1/4) (by linarith) hT0
        (by norm_num)
      have habs : |(-1/4 : ℝ)| = 1 / 4 := by norm_num [abs_of_neg]
      rw [habs] at hk
      have hlog16 : 0 < Real.log 16 := Real.log_pos (by norm_num)
      have hlog : Real.log 16 ≤ Real.log (x * (n:ℝ)) := Real.log_le_log (by norm_num) hy
      have h2T : 2 / T ≤ 1 := by rw [div_le_iff₀ hT0]; linarith
      have hk2 : (2 / T + Real.pi / (1/4)) / Real.log (x * (n:ℝ)) ≤ K0 := by
        rw [hK0def]
        apply div_le_div₀ (by positivity) _ hlog16 hlog
        have : Real.pi / (1/4) = 4 * Real.pi := by ring
        linarith
      calc vmTerm n * X * ‖∫ t in (-T)..T,
              ((x * (n:ℝ) : ℝ) : ℂ) ^ ((t:ℂ) * Complex.I) / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
          ≤ vmTerm n * X * K0 := by
            apply mul_le_mul_of_nonneg_left _ hc
            exact hk.trans hk2
        _ = vmTerm n * (X * K0) := by ring
  have hfin := hsum.norm_le_of_bounded (vmTerm_summable.hasSum.mul_right (X * K0)) hterm
  rw [intervalIntegral.integral_neg, norm_neg] at hfin
  refine hfin.trans (le_of_eq ?_)
  rw [Bser, ← hK0def]
  ring

/-- info: 'LeftKernel.series_side' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms series_side

end LeftKernel
