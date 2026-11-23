/-
CountModes — block N1 of `lean_stage3/design/countmodes.md`, as corrected in
its section "After the independent check". 2026-11-23.

One zero's part of the count of primes on the ladder of doublings. Put
`w = ρ·log 2` and `z = 2^ρ = e^w`. The part `piMode ρ (2^k)` is a constant plus
`J_k(w) = ∫₀^∞ e^(k(w−s))/(w − s) ds`, and `e^(k(w−s)) = (z·e^(−s))^k`: on the
count's ladder one zero is a whole radial segment of pure modes, from `z` in to
the origin, with density `1/(w − s)`. The segment needs `Im w ≠ 0`, so the first
lemma is that no nontrivial zero is real.

  im_ne_zero              no nontrivial zero of ζ is real
  J, integrable_J, norm_J_le   the segment integral; 1 ≤ k, Im w ≠ 0
                            ⊢ ‖J k w‖ ≤ e^(k·Re w)/(k·|Im w|)
  J_sub                   1 ≤ k, Im w ≠ 0 ⊢ J k w − J 1 w = ∫₁ᵏ e^(vw)/v dv
  piMode_doubling_sub     1 ≤ k ⊢ piMode ρ (2^k) − piMode ρ 2 = ∫₁ᵏ e^(vw)/v dv
  cst, piMode_doubling    piMode ρ (2^k) = J k w + cst ρ
  norm_J_doubling_le      ‖J k w‖ ≤ 2^(kβ)/(k·|γ|·log 2)
  norm_cst_le             ‖cst ρ‖ ≤ 4/(|γ|·log 2)
  J_eq_segment            J k w = ∫₀^∞ (e^w·e^(−s))^k/(w − s) ds

What the next slice needs: block N2, the reduction with a power saving.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.FiniteOffLinePi
import PrimeNumberTheoremAnd.ZetaBounds

namespace CountModes

open MeasureTheory Kadiri

noncomputable section

/-! ### No nontrivial zero is real -/

/-- On the real interval `(0, 1)` the Euler–Maclaurin tail of `ζ` at `N = 1` is
at most `1/(2b)` in size. -/
theorem norm_tail_le {b : ℝ} (hb : 0 < b) :
    ‖∫ x in Set.Ioi ((1 : ℕ) : ℝ), ((⌊x⌋ : ℂ) + 1 / 2 - (x : ℂ)) /
      (x : ℂ) ^ ((b : ℂ) + 1)‖ ≤ 1 / (2 * b) := by
  refine (norm_integral_le_integral_norm _).trans ?_
  have hint : IntegrableOn (fun x : ℝ ↦ (1 / 2) * x ^ (-b - 1)) (Set.Ioi 1) :=
    (integrableOn_Ioi_rpow_of_lt (by linarith) one_pos).const_mul _
  have hcmp : (∫ x in Set.Ioi ((1 : ℕ) : ℝ),
      ‖((⌊x⌋ : ℂ) + 1 / 2 - (x : ℂ)) / (x : ℂ) ^ ((b : ℂ) + 1)‖) ≤
      ∫ x in Set.Ioi (1 : ℝ), (1 / 2) * x ^ (-b - 1) := by
    rw [show (((1 : ℕ) : ℝ)) = (1 : ℝ) by norm_num]
    refine integral_mono_of_nonneg
      (Filter.Eventually.of_forall fun x ↦ norm_nonneg _) hint ?_
    refine (ae_restrict_iff' measurableSet_Ioi).mpr
      (Filter.Eventually.of_forall fun x hx ↦ ?_)
    rw [Set.mem_Ioi] at hx
    have hx0 : (0 : ℝ) < x := by linarith
    change ‖((⌊x⌋ : ℂ) + 1 / 2 - (x : ℂ)) / (x : ℂ) ^ ((b : ℂ) + 1)‖ ≤
      1 / 2 * x ^ (-b - 1)
    rw [norm_div]
    have hnum : ‖((⌊x⌋ : ℂ) + 1 / 2 - (x : ℂ))‖ ≤ 1 / 2 := by
      have hcast : ((⌊x⌋ : ℂ) + 1 / 2 - (x : ℂ)) =
          (((⌊x⌋ : ℝ) + 1 / 2 - x : ℝ) : ℂ) := by push_cast; ring
      rw [hcast, Complex.norm_real, Real.norm_eq_abs]
      have hf1 : (0 : ℝ) ≤ Int.fract x := Int.fract_nonneg x
      have hf2 : Int.fract x < 1 := Int.fract_lt_one x
      have hfr : (⌊x⌋ : ℝ) + 1 / 2 - x = 1 / 2 - Int.fract x := by
        rw [Int.fract]
        ring
      rw [hfr, abs_le]
      constructor <;> linarith
    have hden : ‖(x : ℂ) ^ ((b : ℂ) + 1)‖ = x ^ (b + 1) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos hx0]
      simp [Complex.add_re, Complex.one_re]
    rw [hden, div_eq_mul_inv, ← Real.rpow_neg hx0.le]
    have hexp : -(b + 1) = -b - 1 := by ring
    rw [hexp]
    exact mul_le_mul_of_nonneg_right hnum (Real.rpow_nonneg hx0.le _)
  refine hcmp.trans (le_of_eq ?_)
  rw [integral_const_mul, integral_Ioi_rpow_of_lt (by linarith) one_pos, Real.one_rpow]
  have hb1 : -b - 1 + 1 = -b := by ring
  rw [hb1, div_neg, neg_div, neg_neg]
  ring

/-- `ζ` has no zero on the real interval `(0, 1)`. By the Euler–Maclaurin form at
`N = 1`, `ζ(b) = 1/2 − 1/(1 − b) + b·I` with `|b·I| ≤ 1/2`, while
`|1/2 − 1/(1 − b)| > 1/2`. -/
theorem riemannZeta_ne_zero_of_Ioo {b : ℝ} (hb0 : 0 < b) (hb1 : b < 1) :
    riemannZeta (b : ℂ) ≠ 0 := by
  intro hz
  have hre : (0 : ℝ) < (b : ℂ).re := by simpa using hb0
  have hne1 : (b : ℂ) ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    simp at this
    linarith
  have hne0 : (b : ℂ) ≠ 0 := by exact_mod_cast hb0.ne'
  rw [← Zeta0EqZeta one_pos hre hne1] at hz
  unfold riemannZeta0 at hz
  rw [Finset.sum_range_succ, Finset.sum_range_one] at hz
  push_cast at hz
  rw [Complex.zero_cpow hne0] at hz
  simp only [Complex.one_cpow, div_zero, zero_add] at hz
  set I := ∫ x in Set.Ioi (1 : ℝ), ((⌊x⌋ : ℂ) + 1 / 2 - (x : ℂ)) /
      (x : ℂ) ^ ((b : ℂ) + 1) with hI
  have hIle : ‖I‖ ≤ 1 / (2 * b) := by
    have := norm_tail_le hb0
    rw [show (((1 : ℕ) : ℝ)) = (1 : ℝ) by norm_num] at this
    exact this
  have h1b : (1 : ℝ) - b ≠ 0 := by linarith
  have hkey : (b : ℂ) * I = (((1 / (1 - b) - 1 / 2 : ℝ)) : ℂ) := by
    have h1b' : (1 : ℂ) - b ≠ 0 := by exact_mod_cast h1b
    push_cast
    linear_combination hz
  have hnorm : ‖(b : ℂ) * I‖ ≤ 1 / 2 := by
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hb0]
    calc b * ‖I‖ ≤ b * (1 / (2 * b)) := mul_le_mul_of_nonneg_left hIle hb0.le
      _ = 1 / 2 := by field_simp
  rw [hkey, Complex.norm_real, Real.norm_eq_abs] at hnorm
  have hgt : 1 < 1 / (1 - b) := by
    rw [lt_div_iff₀ (by linarith)]
    linarith
  rw [abs_of_pos (by linarith)] at hnorm
  linarith

/-- **No nontrivial zero of ζ is real.** A zero with imaginary part `0` would be a
zero of `ζ` on the real interval `(0, 1)`. -/
theorem im_ne_zero (ρ : NontrivialZeros) : (ρ : ℂ).im ≠ 0 := by
  intro h
  have hz : riemannZeta (ρ : ℂ) = 0 := ρ.2.2.2
  have hρ : (ρ : ℂ) = (((ρ : ℂ).re : ℝ) : ℂ) := Complex.ext (by simp) (by simp [h])
  rw [hρ] at hz
  exact riemannZeta_ne_zero_of_Ioo ρ.2.1.1 ρ.2.1.2 hz

/-- info: 'CountModes.im_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms im_ne_zero

/-! ### The segment integral -/

/-- The segment integral of one zero on the count's ladder:
`J_k(w) = ∫₀^∞ e^(k(w−s))/(w − s) ds`. -/
def J (k : ℕ) (w : ℂ) : ℂ :=
  ∫ s in Set.Ioi (0:ℝ), Complex.exp ((k:ℂ) * (w - s)) / (w - s)

/-- For `Im w ≠ 0`, the point `w − s` is never zero for real `s`. -/
theorem sub_ofReal_ne_zero {w : ℂ} (hw : w.im ≠ 0) (s : ℝ) : w - (s : ℂ) ≠ 0 := by
  intro h
  apply hw
  have := congrArg Complex.im h
  simpa using this

/-- For `Im w ≠ 0`, the integrand of `J k w` is continuous in `s`. -/
theorem continuous_integrand (k : ℕ) {w : ℂ} (hw : w.im ≠ 0) :
    Continuous (fun s : ℝ => Complex.exp ((k:ℂ) * (w - s)) / (w - s)) := by
  refine Continuous.div (by fun_prop) (by fun_prop) (sub_ofReal_ne_zero hw)

/-- The size of the integrand of `J k w`: at most `e^(k·Re w)/|Im w|·e^(−ks)`. -/
theorem norm_integrand_le (k : ℕ) {w : ℂ} (hw : w.im ≠ 0) (s : ℝ) :
    ‖Complex.exp ((k:ℂ) * (w - s)) / (w - s)‖
      ≤ Real.exp (k * w.re) / |w.im| * Real.exp (-k * s) := by
  have him : 0 < |w.im| := abs_pos.mpr hw
  rw [norm_div, Complex.norm_exp]
  have hre : ((k:ℂ) * (w - s)).re = k * w.re + -k * s := by
    simp [Complex.mul_re]
    ring
  have hden : |w.im| ≤ ‖w - (s : ℂ)‖ := by
    have := Complex.abs_im_le_norm (w - (s : ℂ))
    simpa using this
  rw [hre, Real.exp_add, div_mul_eq_mul_div, mul_comm (Real.exp _) (Real.exp _)]
  rw [div_le_div_iff₀ (lt_of_lt_of_le him hden) him]
  rw [mul_comm (Real.exp (-k * s)) (Real.exp (k * w.re))]
  exact mul_le_mul_of_nonneg_left hden (by positivity)

/-- The real exponential `e^(−ks)` integrates to `1/k` over `s > 0`. -/
theorem integral_exp_neg_mul {k : ℝ} (hk : 0 < k) :
    ∫ s in Set.Ioi (0:ℝ), Real.exp (-k * s) = 1 / k := by
  rw [integral_exp_mul_Ioi (by linarith) 0]
  simp

/-- For `1 ≤ k` and `Im w ≠ 0` the integrand of `J k w` is integrable on `s > 0`. -/
theorem integrable_J {k : ℕ} (hk : 1 ≤ k) {w : ℂ} (hw : w.im ≠ 0) :
    IntegrableOn (fun s : ℝ => Complex.exp ((k:ℂ) * (w - s)) / (w - s)) (Set.Ioi 0) := by
  have hk0 : (0:ℝ) < k := by exact_mod_cast hk
  have hg : IntegrableOn (fun s : ℝ => Real.exp (k * w.re) / |w.im| * Real.exp (-k * s))
      (Set.Ioi 0) := (exp_neg_integrableOn_Ioi 0 hk0).const_mul _
  refine Integrable.mono' hg (continuous_integrand k hw).aestronglyMeasurable ?_
  exact Filter.Eventually.of_forall (norm_integrand_le k hw)

/-- **The size of the segment integral.** For `1 ≤ k` and `Im w ≠ 0`,
`‖J k w‖ ≤ e^(k·Re w)/(k·|Im w|)`. -/
theorem norm_J_le {k : ℕ} (hk : 1 ≤ k) {w : ℂ} (hw : w.im ≠ 0) :
    ‖J k w‖ ≤ Real.exp (k * w.re) / (k * |w.im|) := by
  have hk0 : (0:ℝ) < k := by exact_mod_cast hk
  have hg : IntegrableOn (fun s : ℝ => Real.exp (k * w.re) / |w.im| * Real.exp (-k * s))
      (Set.Ioi 0) := (exp_neg_integrableOn_Ioi 0 hk0).const_mul _
  unfold J
  refine (norm_integral_le_of_norm_le hg
    (Filter.Eventually.of_forall (norm_integrand_le k hw))).trans (le_of_eq ?_)
  rw [integral_const_mul, integral_exp_neg_mul hk0]
  field_simp

/-! ### The difference of two segment integrals -/

/-- For `s` real and `Im w ≠ 0`, the difference of the integrands of `J k w` and
`J 1 w` at `s` is `∫₁ᵏ e^((w−s)v) dv`. -/
theorem integrand_sub (k : ℕ) {w : ℂ} (hw : w.im ≠ 0) (s : ℝ) :
    Complex.exp ((k:ℂ) * (w - s)) / (w - s) - Complex.exp (((1:ℕ):ℂ) * (w - s)) / (w - s)
      = ∫ v in (1:ℝ)..(k:ℝ), Complex.exp ((w - s) * v) := by
  rw [integral_exp_mul_complex (sub_ofReal_ne_zero hw s), sub_div]
  simp only [Complex.ofReal_natCast, Nat.cast_one, Complex.ofReal_one, mul_comm (w - (s:ℂ))]

/-- For `v > 0`, `∫₀^∞ e^((w−s)v) ds = e^(vw)/v`. -/
theorem integral_inner {w : ℂ} {v : ℝ} (hv : 0 < v) :
    ∫ s in Set.Ioi (0:ℝ), Complex.exp ((w - s) * v) = Complex.exp ((v:ℂ) * w) / (v:ℂ) := by
  have h : ∀ s : ℝ, Complex.exp ((w - s) * v)
      = Complex.exp ((v:ℂ) * w) * Complex.exp ((-(v:ℂ)) * s) := by
    intro s
    rw [← Complex.exp_add]
    congr 1
    ring
  simp_rw [h]
  rw [integral_const_mul, integral_exp_mul_complex_Ioi (by simpa using hv) 0]
  have hv0 : (v:ℂ) ≠ 0 := by exact_mod_cast hv.ne'
  simp
  field_simp

/-- For `1 ≤ k`, the function `(s, v) ↦ e^((w−s)v)` is integrable on
`(0, ∞) × (1, k]`. -/
theorem integrable_prod (k : ℕ) (w : ℂ) :
    Integrable (Function.uncurry fun (s v : ℝ) => Complex.exp ((w - s) * v))
      ((volume.restrict (Set.Ioi (0:ℝ))).prod (volume.restrict (Set.Ioc (1:ℝ) k))) := by
  have hf : Integrable (fun s : ℝ => Real.exp (-1 * s)) (volume.restrict (Set.Ioi (0:ℝ))) :=
    exp_neg_integrableOn_Ioi 0 one_pos
  have hg : Integrable (fun _ : ℝ => Real.exp (k * |w.re|))
      (volume.restrict (Set.Ioc (1:ℝ) k)) :=
    (continuous_const.integrableOn_Icc).mono_set Set.Ioc_subset_Icc_self
  have hG := hf.mul_prod hg
  refine Integrable.mono' hG
    ((by fun_prop : Continuous (fun z : ℝ × ℝ => Complex.exp ((w - z.1) * z.2)))
      |>.aestronglyMeasurable) ?_
  rw [Measure.prod_restrict]
  refine (ae_restrict_iff' (measurableSet_Ioi.prod measurableSet_Ioc)).mpr
    (Filter.Eventually.of_forall ?_)
  intro z hz
  obtain ⟨hs, hv⟩ := hz
  simp only [Set.mem_Ioi] at hs
  simp only [Set.mem_Ioc] at hv
  change ‖Complex.exp ((w - z.1) * z.2)‖ ≤ Real.exp (-1 * z.1) * Real.exp (k * |w.re|)
  rw [Complex.norm_exp, ← Real.exp_add]
  apply Real.exp_le_exp.mpr
  have hre : ((w - (z.1:ℂ)) * (z.2:ℂ)).re = (w.re - z.1) * z.2 := by
    simp [Complex.mul_re]
  rw [hre]
  have h1 : w.re * z.2 ≤ |w.re| * z.2 :=
    mul_le_mul_of_nonneg_right (le_abs_self _) (by linarith)
  have h2 : |w.re| * z.2 ≤ |w.re| * k := mul_le_mul_of_nonneg_left hv.2 (abs_nonneg _)
  have h3 : z.1 ≤ z.1 * z.2 := by nlinarith
  nlinarith

/-- **The difference of two segment integrals.** For `1 ≤ k` and `Im w ≠ 0`,
`J k w − J 1 w = ∫₁ᵏ e^(vw)/v dv`. By Fubini: the difference of the integrands
is `∫₁ᵏ e^((w−s)v) dv`, and `∫₀^∞ e^((w−s)v) ds = e^(vw)/v`. -/
theorem J_sub {k : ℕ} (hk : 1 ≤ k) {w : ℂ} (hw : w.im ≠ 0) :
    J k w - J 1 w = ∫ v in (1:ℝ)..(k:ℝ), Complex.exp ((v:ℂ) * w) / (v:ℂ) := by
  have hk1 : (1:ℝ) ≤ k := by exact_mod_cast hk
  unfold J
  rw [← integral_sub (integrable_J hk hw) (integrable_J le_rfl hw)]
  refine (integral_congr_ae (Filter.Eventually.of_forall (integrand_sub k hw))).trans ?_
  simp_rw [intervalIntegral.integral_of_le hk1]
  rw [integral_integral_swap (integrable_prod k w)]
  refine setIntegral_congr_fun measurableSet_Ioc (fun v hv => ?_)
  exact integral_inner (by linarith [hv.1])

/-- info: 'CountModes.J_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms J_sub

/-! ### One zero's part of the count along the doublings -/

/-- The complex power `ρ` of the real `2^v` is `e^(v·ρ·log 2)`. -/
theorem cpow_two_rpow (v : ℝ) (ρ : ℂ) :
    (((2:ℝ) ^ v : ℝ) : ℂ) ^ ρ = Complex.exp ((v:ℂ) * (ρ * (Real.log 2 : ℂ))) := by
  have hpos : (0:ℝ) < (2:ℝ) ^ v := by positivity
  have hne : (((2:ℝ) ^ v : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hpos.ne'
  rw [Complex.cpow_def_of_ne_zero hne, ← Complex.ofReal_log hpos.le,
    Real.log_rpow (by norm_num : (0:ℝ) < 2)]
  congr 1
  push_cast
  ring

/-- The first term of `piMode ρ (2^v)` is `e^(vw)/(vw)`, with `w = ρ·log 2`. -/
theorem term1_eq (v : ℝ) (ρ : ℂ) :
    (((2:ℝ) ^ v : ℝ) : ℂ) ^ ρ / ρ / (Real.log ((2:ℝ) ^ v) : ℂ)
      = Complex.exp ((v:ℂ) * (ρ * (Real.log 2 : ℂ))) / ((v:ℂ) * (ρ * (Real.log 2 : ℂ))) := by
  rw [cpow_two_rpow, Real.log_rpow (by norm_num : (0:ℝ) < 2), div_div]
  congr 1
  push_cast
  ring

/-- The integrand of `piMode` is continuous on `t > 1`. -/
theorem continuousOn_integrand (ρ : ℂ) :
    ContinuousOn (fun t : ℝ => (t : ℂ) ^ ρ / ρ * PiZeros.wt t) (Set.Ioi 1) := by
  intro t ht
  have ht1 : (1:ℝ) < t := ht
  have ht0 : t ≠ 0 := by linarith
  have hlog : Real.log t ≠ 0 := (Real.log_pos ht1).ne'
  apply ContinuousAt.continuousWithinAt
  refine ((Complex.continuousAt_ofReal_cpow_const t ρ (Or.inr ht0)).div_const ρ).mul ?_
  unfold PiZeros.wt
  refine Complex.continuous_ofReal.continuousAt.comp ?_
  refine ContinuousAt.inv₀ ?_ (by positivity)
  exact continuousAt_id.mul ((Real.continuousAt_log ht0).pow 2)

/-- The derivative of the integral part of `piMode ρ` at `y > 1` is the integrand. -/
theorem hasDerivAt_ipart (ρ : ℂ) {y : ℝ} (hy : 1 < y) :
    HasDerivAt (fun u => ∫ t in (2:ℝ)..u, (t : ℂ) ^ ρ / ρ * PiZeros.wt t)
      ((y : ℂ) ^ ρ / ρ * PiZeros.wt y) y := by
  have hc := continuousOn_integrand ρ
  have hsub : Set.uIcc (2:ℝ) y ⊆ Set.Ioi 1 := by
    intro t ht
    rcases Set.mem_uIcc.mp ht with h | h
    · exact lt_of_lt_of_le (by norm_num) h.1
    · exact lt_of_lt_of_le hy h.1
  refine intervalIntegral.integral_hasDerivAt_right
    ((hc.mono hsub).intervalIntegrable)
    (hc.stronglyMeasurableAtFilter isOpen_Ioi y hy)
    (hc.continuousAt (isOpen_Ioi.mem_nhds hy))

/-- The derivative of `e^(uw)/(uw)` at `u ≠ 0`, for `w ≠ 0`. -/
theorem hasDerivAt_term1 {w : ℂ} (hw : w ≠ 0) {v : ℝ} (hv : v ≠ 0) :
    HasDerivAt (fun u : ℝ => Complex.exp ((u:ℂ) * w) / ((u:ℂ) * w))
      ((Complex.exp ((v:ℂ) * w) * w * ((v:ℂ) * w) - Complex.exp ((v:ℂ) * w) * w)
        / ((v:ℂ) * w) ^ 2) v := by
  have hv' : (v:ℂ) ≠ 0 := by exact_mod_cast hv
  have h1 : HasDerivAt (fun u : ℂ => Complex.exp (u * w)) (Complex.exp ((v:ℂ) * w) * w) (v:ℂ) :=
    ((hasDerivAt_id (v:ℂ)).mul_const w).cexp.congr_deriv (by simp)
  have h2 : HasDerivAt (fun u : ℂ => u * w) w (v:ℂ) :=
    ((hasDerivAt_id (v:ℂ)).mul_const w).congr_deriv (by simp)
  have h3 := h1.div h2 (mul_ne_zero hv' hw)
  exact h3.comp_ofReal

/-- **The derivative of one zero's part along the doublings.** For `v > 0` and
`ρ ≠ 0`, `v ↦ piMode ρ (2^v)` has derivative `e^(vw)/v`, `w = ρ·log 2`. -/
theorem hasDerivAt_piMode_two_rpow {ρ : ℂ} (hρ : ρ ≠ 0) {v : ℝ} (hv : 0 < v) :
    HasDerivAt (fun u : ℝ => PiZeros.piMode ρ ((2:ℝ) ^ u))
      (Complex.exp ((v:ℂ) * (ρ * (Real.log 2 : ℂ))) / (v:ℂ)) v := by
  set L : ℝ := Real.log 2 with hLdef
  have hL : 0 < L := Real.log_pos (by norm_num)
  set w : ℂ := ρ * (L : ℂ) with hwdef
  have hw : w ≠ 0 := mul_ne_zero hρ (by exact_mod_cast hL.ne')
  have hfun : (fun u : ℝ => PiZeros.piMode ρ ((2:ℝ) ^ u))
      = fun u : ℝ => Complex.exp ((u:ℂ) * w) / ((u:ℂ) * w)
          + (fun y => ∫ t in (2:ℝ)..y, (t : ℂ) ^ ρ / ρ * PiZeros.wt t) ((2:ℝ) ^ u) := by
    funext u
    unfold PiZeros.piMode PiZeros.tr
    rw [term1_eq]
  rw [hfun]
  have hx : HasDerivAt (fun u : ℝ => (2:ℝ) ^ u) ((2:ℝ) ^ v * L) v :=
    (Real.hasStrictDerivAt_const_rpow (by norm_num : (0:ℝ) < 2) v).hasDerivAt
  have hX : (1:ℝ) < (2:ℝ) ^ v := Real.one_lt_rpow (by norm_num) hv
  have hI := (hasDerivAt_ipart ρ hX).scomp v hx
  have hT := hasDerivAt_term1 hw hv.ne'
  refine (hT.add hI).congr_deriv ?_
  rw [cpow_two_rpow]
  unfold PiZeros.wt
  rw [Real.log_rpow (by norm_num : (0:ℝ) < 2), Complex.real_smul]
  have hXpos : (0:ℝ) < (2:ℝ) ^ v := by positivity
  generalize (2:ℝ) ^ v = X at hXpos ⊢
  have hX0 : (X:ℂ) ≠ 0 := by exact_mod_cast hXpos.ne'
  have hv0 : (v:ℂ) ≠ 0 := by exact_mod_cast hv.ne'
  have hL0 : (L:ℂ) ≠ 0 := by exact_mod_cast hL.ne'
  rw [hwdef]
  push_cast
  simp only [← hLdef]
  field_simp
  try ring

/-- **One zero's part of the count between two doublings.** For `ρ ≠ 0` and
`1 ≤ k`, `piMode ρ (2^k) − piMode ρ 2 = ∫₁ᵏ e^(vw)/v dv`, `w = ρ·log 2`. -/
theorem piMode_doubling_sub_of {ρ : ℂ} (hρ : ρ ≠ 0) {k : ℕ} (hk : 1 ≤ k) :
    PiZeros.piMode ρ ((2:ℝ) ^ k) - PiZeros.piMode ρ 2
      = ∫ v in (1:ℝ)..(k:ℝ), Complex.exp ((v:ℂ) * (ρ * Real.log 2)) / (v:ℂ) := by
  have hk1 : (1:ℝ) ≤ k := by exact_mod_cast hk
  have hderiv : ∀ v ∈ Set.uIcc (1:ℝ) k,
      HasDerivAt (fun u : ℝ => PiZeros.piMode ρ ((2:ℝ) ^ u))
        (Complex.exp ((v:ℂ) * (ρ * (Real.log 2 : ℂ))) / (v:ℂ)) v := by
    intro v hv
    rw [Set.uIcc_of_le hk1] at hv
    exact hasDerivAt_piMode_two_rpow hρ (by linarith [hv.1])
  have hint : IntervalIntegrable
      (fun v : ℝ => Complex.exp ((v:ℂ) * (ρ * (Real.log 2 : ℂ))) / (v:ℂ)) volume 1 k := by
    apply ContinuousOn.intervalIntegrable
    refine ContinuousOn.div (by fun_prop) (by fun_prop) ?_
    intro v hv
    rw [Set.uIcc_of_le hk1] at hv
    have : (0:ℝ) < v := by linarith [hv.1]
    exact_mod_cast this.ne'
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint]
  simp only [Real.rpow_natCast, Real.rpow_one]

/-- **One zero's part of the count between two doublings**, for a nontrivial
zero: `piMode ρ (2^k) − piMode ρ 2 = ∫₁ᵏ e^(vw)/v dv`, `w = ρ·log 2`. -/
theorem piMode_doubling_sub (ρ : NontrivialZeros) (k : ℕ) (hk : 1 ≤ k) :
    PiZeros.piMode (ρ:ℂ) ((2:ℝ) ^ k) - PiZeros.piMode (ρ:ℂ) 2
      = ∫ v in (1:ℝ)..(k:ℝ), Complex.exp ((v:ℂ) * ((ρ:ℂ) * Real.log 2)) / (v:ℂ) := by
  have hρ : (ρ:ℂ) ≠ 0 := by
    intro h
    have := ρ.2.1.1
    rw [h] at this
    simp at this
  exact piMode_doubling_sub_of hρ hk

/-! ### The representation -/

/-- The imaginary part of `w = ρ·log 2` is `γ·log 2`. -/
theorem im_w (ρ : ℂ) : (ρ * (Real.log 2 : ℂ)).im = ρ.im * Real.log 2 := by
  rw [Complex.mul_im, Complex.ofReal_im, Complex.ofReal_re]
  ring

/-- The real part of `w = ρ·log 2` is `β·log 2`. -/
theorem re_w (ρ : ℂ) : (ρ * (Real.log 2 : ℂ)).re = ρ.re * Real.log 2 := by
  rw [Complex.mul_re, Complex.ofReal_im, Complex.ofReal_re]
  ring

/-- For a nontrivial zero, `w = ρ·log 2` is not real. -/
theorem w_im_ne_zero (ρ : NontrivialZeros) : ((ρ:ℂ) * (Real.log 2 : ℂ)).im ≠ 0 := by
  rw [im_w]
  exact mul_ne_zero (im_ne_zero ρ) (Real.log_pos (by norm_num)).ne'

/-- The constant of one zero's part on the count's ladder: `piMode ρ 2 − J_1(w)`. -/
def cst (ρ : NontrivialZeros) : ℂ := PiZeros.piMode (ρ:ℂ) 2 - J 1 ((ρ:ℂ) * Real.log 2)

/-- **One zero's part on the count's ladder is a segment plus a constant.** For a
nontrivial zero and `1 ≤ k`, `piMode ρ (2^k) = J_k(ρ·log 2) + cst ρ`. -/
theorem piMode_doubling (ρ : NontrivialZeros) {k : ℕ} (hk : 1 ≤ k) :
    PiZeros.piMode (ρ:ℂ) ((2:ℝ)^k) = J k ((ρ:ℂ) * Real.log 2) + cst ρ := by
  have h1 := piMode_doubling_sub ρ k hk
  have h2 := J_sub hk (w_im_ne_zero ρ)
  unfold cst
  linear_combination h1 - h2

/-- info: 'CountModes.piMode_doubling' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms piMode_doubling

/-- **The size of a zero's segment on the count's ladder.** For `1 ≤ k`,
`‖J_k(ρ·log 2)‖ ≤ 2^(kβ)/(k·|γ|·log 2)`. -/
theorem norm_J_doubling_le (ρ : NontrivialZeros) {k : ℕ} (hk : 1 ≤ k) :
    ‖J k ((ρ:ℂ) * Real.log 2)‖ ≤ (2:ℝ)^((k:ℝ) * (ρ:ℂ).re) / (k * (|(ρ:ℂ).im| * Real.log 2)) := by
  have hL : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have h := norm_J_le hk (w_im_ne_zero ρ)
  rw [re_w, im_w, abs_mul, abs_of_pos hL] at h
  refine h.trans (le_of_eq ?_)
  rw [Real.rpow_def_of_pos (by norm_num : (0:ℝ) < 2)]
  congr 2
  ring

/-- The value of one zero's part at `2`: `‖piMode ρ 2‖ ≤ 2/(|γ|·log 2)`. -/
theorem norm_piMode_two_le (ρ : NontrivialZeros) :
    ‖PiZeros.piMode (ρ:ℂ) 2‖ ≤ 2 / (|(ρ:ℂ).im| * Real.log 2) := by
  have hL : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hγ : 0 < |(ρ:ℂ).im| := abs_pos.mpr (im_ne_zero ρ)
  unfold PiZeros.piMode PiZeros.tr
  rw [intervalIntegral.integral_same, add_zero, norm_div, norm_div,
    Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num : (0:ℝ) < 2), Complex.norm_real,
    Real.norm_eq_abs, abs_of_pos hL, div_div]
  refine div_le_div₀ (by norm_num) ?_ (by positivity) ?_
  · calc (2:ℝ) ^ (ρ:ℂ).re ≤ (2:ℝ) ^ (1:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) ρ.2.1.2.le
      _ = 2 := Real.rpow_one 2
  · exact mul_le_mul_of_nonneg_right (Complex.abs_im_le_norm _) hL.le

/-- **The size of the constant.** `‖cst ρ‖ ≤ 4/(|γ|·log 2)`: each of `piMode ρ 2`
and `J_1(ρ·log 2)` is at most `2^β/(|γ|·log 2) ≤ 2/(|γ|·log 2)`. -/
theorem norm_cst_le (ρ : NontrivialZeros) : ‖cst ρ‖ ≤ 4 / (|(ρ:ℂ).im| * Real.log 2) := by
  have hL : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hγ : 0 < |(ρ:ℂ).im| := abs_pos.mpr (im_ne_zero ρ)
  have h1 := norm_piMode_two_le ρ
  have h2 := norm_J_doubling_le ρ (le_refl 1)
  have h2' : ‖J 1 ((ρ:ℂ) * Real.log 2)‖ ≤ 2 / (|(ρ:ℂ).im| * Real.log 2) := by
    refine h2.trans ?_
    simp only [Nat.cast_one, one_mul]
    refine div_le_div_of_nonneg_right ?_ (by positivity)
    calc (2:ℝ) ^ (ρ:ℂ).re ≤ (2:ℝ) ^ (1:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) ρ.2.1.2.le
      _ = 2 := Real.rpow_one 2
  unfold cst
  calc ‖PiZeros.piMode (ρ:ℂ) 2 - J 1 ((ρ:ℂ) * Real.log 2)‖
      ≤ ‖PiZeros.piMode (ρ:ℂ) 2‖ + ‖J 1 ((ρ:ℂ) * Real.log 2)‖ := norm_sub_le _ _
    _ ≤ 2 / (|(ρ:ℂ).im| * Real.log 2) + 2 / (|(ρ:ℂ).im| * Real.log 2) := add_le_add h1 h2'
    _ = 4 / (|(ρ:ℂ).im| * Real.log 2) := by ring

/-- info: 'CountModes.norm_cst_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_cst_le

/-! ### The segment form -/

/-- **The segment form.** `J_k(w) = ∫₀^∞ (e^w·e^(−s))^k/(w − s) ds`: the integrand
is the pure mode `z·e^(−s)`, `z = e^w`, raised to the `k`-th power, with density
`1/(w − s)`. It holds for every `k` and `w`. -/
theorem J_eq_segment (k : ℕ) (w : ℂ) :
    J k w = ∫ s in Set.Ioi (0:ℝ), (Complex.exp w * Real.exp (-s)) ^ k / (w - s) := by
  unfold J
  congr 1
  funext s
  rw [Complex.ofReal_exp, ← Complex.exp_add, ← Complex.exp_nat_mul]
  congr 2
  push_cast
  ring

end

end CountModes
