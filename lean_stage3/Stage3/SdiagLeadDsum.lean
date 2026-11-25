/-
# Stage3.SdiagLeadDsum — layer (3), the `d`-sum, from two arithmetic facts. 2026-11-25.

`StmtDsum P A` (`Σ_{d ≤ M} W_d Â_d(β) Â_d(α) = I(α,β)/log M + o(1/log M)`) is derived here from

* `StmtGmuLog`: `Σ_{d ≤ t} μ²(d)/φ(d) = log t + O(1)` for `t ≥ 1`;
* `StmtDivLog`: `Σ_{d ≤ M} μ²(d) σ(d)²/d · Σ_{a | d} (log a)/a ≤ C(1 + log M)`.

Route. `W_d = (1/d) Σ_{a|d} μ(a) a^{−(1+α+β)}` (`Wd_eq`) and `Σ_{a|d} μ(a)/a = φ(d)/d`
(`sum_mu_div`), so `μ²σ²W_d − μ²/φ(d) = μ²σ²/d · Σ_{a|d} μ(a)(a^{−1−s} − a^{−1})`, of size
`μ²σ²/d · (2A e^{2A}/λ) Σ_{a|d} log a/a` (`weight_err`): against `‖mainS‖² ≤ C/λ²` and
`StmtDivLog` this is `O(1/λ²)`. The main sum is `Σ_d μ²(d)/φ(d) Q(ℓ_d)/λ²` with
`Q(u) = (P′(u) + βλP(u))(P′(u) + αλP(u))`, `ℓ_d = log(M/d)/λ`; Abel summation (Mathlib's
`sum_mul_eq_sub_integral_mul₀'`) against `G(t) = log t + R(t)` gives
`Σ_d μ²(d)/φ(d) Q(ℓ_d) = λ ∫₀¹ Q + Q(0) R(M) − ∫₁^M (d/dt Q(ℓ(t))) R(t) dt` (`abel_main`), and
the last two are `≤ C_R (|Q(0)| + sup |Q′|)`, uniform in `‖α‖λ, ‖β‖λ ≤ A`: `O(1/λ²)` after the
`1/λ²`. `λ ∫₀¹ Q / λ² = I(α,β)/λ`. No factor growing with `M` is lost.

| name | content | status |
|---|---|---|
| `gmu` | `μ²(d)/φ(d)` | def |
| `StmtGmuLog`, `StmtDivLog` | the two arithmetic facts | OPEN (named Props) |
| `Wd_eq`, `sum_mu_div` | `W_d = (1/d)Σ_{a|d} μ(a)a^{−1−s}`; `Σ_{a|d} μ(a)/a = φ(d)/d` | proved |
| `weight_err` | `‖μ²σ²W_d − μ²/φ(d)‖ ≤ μ²σ²/d · 2Ae^{2A}/λ · Σ_{a|d} log a/a` | proved |
| `abel_main` | `‖Σ_d μ²/φ Q(ℓ_d) − λ∫₀¹Q‖ ≤ C_R(‖Q(0)‖ + sup‖Q′‖)` | proved (from `StmtGmuLog`) |
| `stmtDsum_of_arith` | the two facts → `StmtDsum P A` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SdiagLeadAd

namespace SdiagLead

open Complex Finset MeasureTheory DiagMain
open scoped ArithmeticFunction.Moebius

noncomputable section

/-- `μ²(d)/φ(d)`. -/
def gmu (d : ℕ) : ℝ := ((μ d : ℤ) : ℝ) ^ 2 / (Nat.totient d : ℝ)

/-- OPEN, `Σ_{d ≤ t} μ²(d)/φ(d) = log t + O(1)`. -/
def StmtGmuLog : Prop := ∃ C : ℝ, 0 ≤ C ∧ ∀ t : ℝ, 1 ≤ t →
  |∑ k ∈ Icc 0 ⌊t⌋₊, gmu k - Real.log t| ≤ C

/-- OPEN, `Σ_{d ≤ M} μ²(d) σ(d)²/d · Σ_{a | d} log a/a ≤ C(1 + log M)`. -/
def StmtDivLog : Prop := ∃ C : ℝ, 0 ≤ C ∧ ∀ M : ℕ,
  ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d *
    (∑ a ∈ d.divisors, Real.log a / a) ≤ C * (1 + Real.log M)

/-! ## The weight -/

/-- `W_d = (1/d) Σ_{a | d} μ(a) a^{−(1+α+β)}`. -/
theorem Wd_eq (α β : ℂ) {d : ℕ} (hd : 1 ≤ d) :
    Wd α β d = (1 / (d : ℂ)) * ∑ a ∈ d.divisors, ((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 + α + β)) := by
  unfold Wd Jz
  rw [Finset.sum_mul, Finset.mul_sum,
    ← Nat.sum_divisorsAntidiagonal (fun a _ => (1 / (d : ℂ)) * (((μ a : ℤ) : ℂ) *
      (a : ℂ) ^ (-(1 + α + β))))]
  refine Finset.sum_congr rfl fun x hx => ?_
  obtain ⟨hxd, -⟩ := Nat.mem_divisorsAntidiagonal.mp hx
  have h1 : 1 ≤ x.1 := Nat.pos_of_ne_zero (by rintro h; rw [h, zero_mul] at hxd; omega)
  have h2 : 1 ≤ x.2 := Nat.pos_of_ne_zero (by rintro h; rw [h, mul_zero] at hxd; omega)
  have hd' : (d : ℂ) = (x.1 : ℂ) * x.2 := by exact_mod_cast hxd.symm
  rw [← hxd, Diagonal.ncpow_mul]
  have n1 := natcpow_ne h1
  have n2 := natcpow_ne h2
  have e2 : (x.2 : ℂ) ^ (1 + α + β) * (x.2 : ℂ) ^ (-(2 + α + β)) = (x.2 : ℂ)⁻¹ := by
    rw [← Complex.cpow_add _ _ n2, show 1 + α + β + -(2 + α + β) = (-1 : ℂ) by ring,
      Complex.cpow_neg_one]
  have e1 : (x.1 : ℂ) ^ (-(2 + α + β)) = (x.1 : ℂ)⁻¹ * (x.1 : ℂ) ^ (-(1 + α + β)) := by
    rw [show -(2 + α + β) = (-1 : ℂ) + -(1 + α + β) by ring, Complex.cpow_add _ _ n1,
      Complex.cpow_neg_one]
  calc ((μ x.1 : ℤ) : ℂ) * (x.2 : ℂ) ^ (1 + α + β) * ((x.1 : ℂ) ^ (-(2 + α + β)) *
        (x.2 : ℂ) ^ (-(2 + α + β)))
      = ((μ x.1 : ℤ) : ℂ) * ((x.2 : ℂ) ^ (1 + α + β) * (x.2 : ℂ) ^ (-(2 + α + β))) *
          (x.1 : ℂ) ^ (-(2 + α + β)) := by ring
    _ = _ := by rw [e2, e1]; field_simp; push_cast; ring

/-- `Σ_{a | d} μ(a)/a = φ(d)/d`. -/
theorem sum_mu_div {d : ℕ} (hd : 1 ≤ d) :
    ∑ a ∈ d.divisors, ((μ a : ℤ) : ℝ) / a = (Nat.totient d : ℝ) / d := by
  have h := (ArithmeticFunction.sum_eq_iff_sum_mul_moebius_eq (R := ℝ)
    (f := fun n => (Nat.totient n : ℝ)) (g := fun n => (n : ℝ))).mp
    (fun n _ => by exact_mod_cast Nat.sum_totient n) d hd
  rw [← h, Nat.sum_divisorsAntidiagonal (fun a b => ((μ a : ℤ) : ℝ) * (b : ℝ)),
    Finset.sum_div]
  refine Finset.sum_congr rfl fun a ha => ?_
  have ha' := Nat.mem_divisors.mp ha
  have ha0 : (0 : ℝ) < a := by exact_mod_cast Nat.pos_of_dvd_of_pos ha'.1 (by omega)
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  rw [Nat.cast_div ha'.1 ha0.ne']
  field_simp

theorem totient_pos' {d : ℕ} (hd : 1 ≤ d) : (0 : ℝ) < Nat.totient d := by
  exact_mod_cast Nat.totient_pos.mpr (by omega)

/-- **The weight error**: `‖μ²σ²W_d − μ²/φ(d)‖ ≤ μ²σ²/d · (2A e^{2A}/λ) Σ_{a|d} log a/a`. -/
theorem weight_err {M d : ℕ} (hd : 1 ≤ d) (hdM : d ≤ M) (hlM : 0 < Real.log M) {α β : ℂ} {A : ℝ}
    (hα : ‖α‖ * Real.log M ≤ A) (hβ : ‖β‖ * Real.log M ≤ A) :
    ‖((((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 : ℝ) : ℂ) * Wd α β d - ((gmu d : ℝ) : ℂ)‖ ≤
      ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d * (2 * A * Real.exp (2 * A) / Real.log M) *
        ∑ a ∈ d.divisors, Real.log a / a := by
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  have hφ := totient_pos' hd
  set s := α + β with hs
  have hsn : ‖s‖ ≤ 2 * A / Real.log M := by
    rw [le_div_iff₀ hlM]
    have := mul_le_mul_of_nonneg_right (norm_add_le α β) hlM.le
    linarith
  have hg : ((gmu d : ℝ) : ℂ) = ((((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 : ℝ) : ℂ) *
      ((1 / (d : ℂ)) * ∑ a ∈ d.divisors, ((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 : ℂ))) := by
    have e : ∑ a ∈ d.divisors, ((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 : ℂ)) =
        (((Nat.totient d : ℝ) / d : ℝ) : ℂ) := by
      rw [← sum_mu_div hd]; push_cast
      refine Finset.sum_congr rfl fun a _ => ?_
      rw [Complex.cpow_neg_one]; ring
    rw [e]; unfold gmu sig; push_cast
    have : (d : ℂ) ≠ 0 := by exact_mod_cast hd0.ne'
    have : (Nat.totient d : ℂ) ≠ 0 := by exact_mod_cast hφ.ne'
    field_simp
  rw [hg, Wd_eq α β hd, ← mul_sub, ← mul_sub, ← Finset.sum_sub_distrib, norm_mul, norm_mul,
    Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by have := sig_nonneg d; positivity),
    norm_div, norm_one, Complex.norm_natCast]
  have hterm : ∀ a ∈ d.divisors, ‖((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 + α + β)) -
      ((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 : ℂ))‖ ≤
        2 * A * Real.exp (2 * A) / Real.log M * (Real.log a / a) := by
    intro a ha
    have ha' := Nat.mem_divisors.mp ha
    have ha1 : 1 ≤ a := Nat.pos_of_dvd_of_pos ha'.1 (by omega)
    have ha0 : (0 : ℝ) < a := by exact_mod_cast ha1
    have hla : 0 ≤ Real.log a := Real.log_nonneg (by exact_mod_cast ha1)
    have hlaM : Real.log a ≤ Real.log M :=
      Real.log_le_log ha0 (by exact_mod_cast le_trans (Nat.le_of_dvd (by omega) ha'.1) hdM)
    have hsa : ‖s‖ * Real.log a ≤ 2 * A := by
      have := mul_le_mul_of_nonneg_left hlaM (norm_nonneg s)
      have := (le_div_iff₀ hlM).mp hsn
      linarith
    have hna := natcpow_ne ha1
    have e : ((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 + α + β)) - ((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 : ℂ)) =
        ((μ a : ℤ) : ℂ) * (a : ℂ)⁻¹ * ((a : ℂ) ^ (-s) - 1) := by
      rw [show -(1 + α + β) = (-1 : ℂ) + -s by rw [hs]; ring, Complex.cpow_add _ _ hna,
        Complex.cpow_neg_one]; ring
    rw [e, norm_mul, norm_mul, norm_inv, Complex.norm_natCast]
    have hmu : ‖((μ a : ℤ) : ℂ)‖ ≤ 1 := by
      rw [Complex.norm_intCast]; exact_mod_cast ArithmeticFunction.abs_moebius_le_one
    have h1 := norm_ncpow_sub_one_le ha1 hsa
    have h2 : ‖s‖ * Real.log a * Real.exp (2 * A) ≤
        2 * A / Real.log M * Real.log a * Real.exp (2 * A) :=
      mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right hsn hla) (Real.exp_pos _).le
    calc ‖((μ a : ℤ) : ℂ)‖ * (a : ℝ)⁻¹ * ‖(a : ℂ) ^ (-s) - 1‖
        ≤ 1 * (a : ℝ)⁻¹ * (2 * A / Real.log M * Real.log a * Real.exp (2 * A)) :=
          mul_le_mul (mul_le_mul_of_nonneg_right hmu (by positivity)) (le_trans h1 h2)
            (norm_nonneg _) (by positivity)
      _ = _ := by field_simp
  have hsum := le_trans (norm_sum_le _ _) (Finset.sum_le_sum hterm)
  rw [← Finset.mul_sum] at hsum
  have hc : 0 ≤ ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * (1 / (d : ℝ)) := by
    have := sig_nonneg d; positivity
  calc ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * (1 / (d : ℝ) * ‖∑ a ∈ d.divisors,
        (((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 + α + β)) - ((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 : ℂ)))‖)
      = ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * (1 / (d : ℝ)) * ‖∑ a ∈ d.divisors,
        (((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 + α + β)) - ((μ a : ℤ) : ℂ) * (a : ℂ) ^ (-(1 : ℂ)))‖ := by
          ring
    _ ≤ ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * (1 / (d : ℝ)) *
        (2 * A * Real.exp (2 * A) / Real.log M * ∑ a ∈ d.divisors, Real.log a / a) :=
          mul_le_mul_of_nonneg_left hsum hc
    _ = _ := by ring

/-! ## Abel summation against `log t + R(t)` -/

/-- `ℓ(t) = log(M/t)/λ` has derivative `−t⁻¹/λ`; `f = Q ∘ ℓ`. -/
theorem f_hasDerivAt {Q Q' : ℝ → ℂ} (hQ : ∀ u, HasDerivAt Q (Q' u) u) {Mr lM t : ℝ}
    (hM : 0 < Mr) (ht : 0 < t) :
    HasDerivAt (fun t => Q (Real.log (Mr / t) / lM))
      (((-t⁻¹ / lM : ℝ) : ℂ) * Q' (Real.log (Mr / t) / lM)) t := by
  have hl := (hasDerivAt_logdiv hM ht).div_const lM
  have h := (hQ (Real.log (Mr / t) / lM)).scomp t hl
  refine h.congr_deriv ?_
  rw [Complex.real_smul]

/-- `∫₁^M Q(ℓ(t))/t dt = λ ∫₀¹ Q`, `λ = log M`. -/
theorem int_f_div {Q : ℝ → ℂ} (hQc : Continuous Q) {Mr : ℝ} (hM : 1 < Mr) :
    ∫ t in (1 : ℝ)..Mr, Q (Real.log (Mr / t) / Real.log Mr) * ((t⁻¹ : ℝ) : ℂ) =
      (Real.log Mr : ℂ) * ∫ u in (0 : ℝ)..1, Q u := by
  have hM0 : 0 < Mr := by linarith
  have hl : 0 < Real.log Mr := Real.log_pos hM
  set 𝒬 : ℝ → ℂ := fun v => ∫ u in (0 : ℝ)..v, Q u with h𝒬
  have hderiv : ∀ t ∈ Set.uIcc (1 : ℝ) Mr, HasDerivAt
      (fun t => -(Real.log Mr : ℂ) * 𝒬 (Real.log (Mr / t) / Real.log Mr))
      (Q (Real.log (Mr / t) / Real.log Mr) * ((t⁻¹ : ℝ) : ℂ)) t := by
    intro t ht
    rw [Set.uIcc_of_le hM.le] at ht
    have ht0 : 0 < t := by linarith [ht.1]
    have h1 := f_hasDerivAt (fun v => (hQc.integral_hasStrictDerivAt 0 v).hasDerivAt) hM0 ht0
      (lM := Real.log Mr)
    refine (h1.const_mul (-(Real.log Mr : ℂ))).congr_deriv ?_
    have : (Real.log Mr : ℂ) ≠ 0 := by exact_mod_cast hl.ne'
    push_cast; field_simp
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv]
  · simp only [h𝒬, div_self hM0.ne', Real.log_one, zero_div, div_one,
      div_self hl.ne', intervalIntegral.integral_same]
    ring
  · refine ContinuousOn.intervalIntegrable fun t ht => ?_
    rw [Set.uIcc_of_le hM.le] at ht
    have ht0 : 0 < t := by linarith [ht.1]
    refine ContinuousAt.continuousWithinAt ?_
    refine ContinuousAt.mul ?_ (Complex.continuous_ofReal.continuousAt.comp
      (continuousAt_inv₀ ht0.ne'))
    exact hQc.continuousAt.comp ((hasDerivAt_logdiv hM0 ht0).continuousAt.div_const _)

/-- `∫₁^M f′(t) log t dt = Q(0) λ − λ ∫₀¹ Q`. -/
theorem int_fprime_log {Q Q' : ℝ → ℂ} (hQ : ∀ u, HasDerivAt Q (Q' u) u) (hQ'c : Continuous Q')
    {Mr : ℝ} (hM : 1 < Mr) :
    ∫ t in (1 : ℝ)..Mr, ((-t⁻¹ / Real.log Mr : ℝ) : ℂ) * Q' (Real.log (Mr / t) / Real.log Mr) *
        (Real.log t : ℂ) =
      Q 0 * Real.log Mr - (Real.log Mr : ℂ) * ∫ u in (0 : ℝ)..1, Q u := by
  have hM0 : 0 < Mr := by linarith
  have hQc : Continuous Q := continuous_iff_continuousAt.mpr fun u => (hQ u).continuousAt
  set lM := Real.log Mr with hlM
  have hcont : ∀ t, 0 < t → ContinuousAt (fun t : ℝ => Real.log (Mr / t) / lM) t :=
    fun t ht => (hasDerivAt_logdiv hM0 ht).continuousAt.div_const _
  have hI1 : IntervalIntegrable (fun t : ℝ => ((-t⁻¹ / lM : ℝ) : ℂ) *
      Q' (Real.log (Mr / t) / lM) * (Real.log t : ℂ)) volume 1 Mr := by
    refine ContinuousOn.intervalIntegrable fun t ht => ?_
    rw [Set.uIcc_of_le hM.le] at ht
    have ht0 : 0 < t := by linarith [ht.1]
    refine ContinuousAt.continuousWithinAt ((ContinuousAt.mul ?_ ?_).mul ?_)
    · exact Complex.continuous_ofReal.continuousAt.comp
        ((continuousAt_inv₀ ht0.ne').neg.div_const _)
    · exact hQ'c.continuousAt.comp (hcont t ht0)
    · exact Complex.continuous_ofReal.continuousAt.comp (Real.continuousAt_log ht0.ne')
  have hI2 : IntervalIntegrable (fun t : ℝ => Q (Real.log (Mr / t) / lM) * ((t⁻¹ : ℝ) : ℂ))
      volume 1 Mr := by
    refine ContinuousOn.intervalIntegrable fun t ht => ?_
    rw [Set.uIcc_of_le hM.le] at ht
    have ht0 : 0 < t := by linarith [ht.1]
    exact ((hQc.continuousAt.comp (hcont t ht0)).mul (Complex.continuous_ofReal.continuousAt.comp
      (continuousAt_inv₀ ht0.ne'))).continuousWithinAt
  have hderiv : ∀ t ∈ Set.uIcc (1 : ℝ) Mr, HasDerivAt
      (fun t => Q (Real.log (Mr / t) / lM) * (Real.log t : ℂ))
      (((-t⁻¹ / lM : ℝ) : ℂ) * Q' (Real.log (Mr / t) / lM) * (Real.log t : ℂ) +
        Q (Real.log (Mr / t) / lM) * ((t⁻¹ : ℝ) : ℂ)) t := by
    intro t ht
    rw [Set.uIcc_of_le hM.le] at ht
    have ht0 : 0 < t := by linarith [ht.1]
    exact (f_hasDerivAt hQ hM0 ht0).mul (Real.hasDerivAt_log ht0.ne').ofReal_comp
  have hsum := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv (hI1.add hI2)
  rw [intervalIntegral.integral_add hI1 hI2, int_f_div hQc hM] at hsum
  simp only [div_self hM0.ne', Real.log_one, zero_div, div_one, Complex.ofReal_zero, mul_zero,
    sub_zero] at hsum
  rw [← hlM] at hsum
  linear_combination hsum

theorem gmu_nonneg (d : ℕ) : 0 ≤ gmu d := div_nonneg (sq_nonneg _) (Nat.cast_nonneg _)

/-- **Abel summation**: `‖Σ_{k ≤ M} Q(ℓ_k) μ²(k)/φ(k) − λ ∫₀¹ Q‖ ≤ C_R(B + B′)`. -/
theorem abel_main (hG : StmtGmuLog) : ∃ CR : ℝ, 0 ≤ CR ∧ ∀ M : ℕ, 2 ≤ M →
    ∀ Q Q' : ℝ → ℂ, (∀ u, HasDerivAt Q (Q' u) u) → Continuous Q' → ∀ B B' : ℝ,
      ‖Q 0‖ ≤ B → (∀ u ∈ Set.Icc (0 : ℝ) 1, ‖Q' u‖ ≤ B') →
        ‖∑ k ∈ Icc 0 M, Q (Real.log ((M : ℝ) / k) / Real.log M) * ((gmu k : ℝ) : ℂ) -
          (Real.log M : ℂ) * ∫ u in (0 : ℝ)..1, Q u‖ ≤ CR * (B + B') := by
  obtain ⟨CR, hCR0, hCR⟩ := hG
  refine ⟨CR, hCR0, fun M hM Q Q' hQ hQ'c B B' hB hB' => ?_⟩
  have hM1 : (1 : ℝ) < M := by exact_mod_cast (by omega : 1 < M)
  have hM0 : (0 : ℝ) < M := by linarith
  set lM := Real.log M with hlM
  have hl : 0 < lM := Real.log_pos hM1
  set f : ℝ → ℂ := fun t => Q (Real.log (M / t) / lM) with hf
  set f' : ℝ → ℂ := fun t => ((-t⁻¹ / lM : ℝ) : ℂ) * Q' (Real.log (M / t) / lM) with hf'
  have hfd : ∀ t, 0 < t → HasDerivAt f (f' t) t := fun t ht => f_hasDerivAt hQ hM0 ht
  have hcont : ∀ t, 0 < t → ContinuousAt (fun t : ℝ => Real.log (M / t) / lM) t :=
    fun t ht => (hasDerivAt_logdiv hM0 ht).continuousAt.div_const _
  have hf'c : ContinuousOn f' (Set.Icc 1 M) := fun t ht => by
    have ht0 : 0 < t := by linarith [ht.1]
    exact ((Complex.continuous_ofReal.continuousAt.comp
      ((continuousAt_inv₀ ht0.ne').neg.div_const _)).mul
        (hQ'c.continuousAt.comp (hcont t ht0))).continuousWithinAt
  have hf'int : IntegrableOn f' (Set.Icc 1 M) := hf'c.integrableOn_compact isCompact_Icc
  have hdint : IntegrableOn (deriv f) (Set.Icc 1 M) :=
    hf'int.congr_fun (fun t ht => ((hfd t (by linarith [ht.1])).deriv).symm) measurableSet_Icc
  have habel := sum_mul_eq_sub_integral_mul₀' (fun k => ((gmu k : ℝ) : ℂ)) (by simp [gmu]) M
    (fun t ht => (hfd t (by linarith [ht.1])).differentiableAt) hdint
  set G : ℝ → ℂ := fun t => ∑ k ∈ Icc 0 ⌊t⌋₊, ((gmu k : ℝ) : ℂ) with hGdef
  have hGr : ∀ t, G t = ((∑ k ∈ Icc 0 ⌊t⌋₊, gmu k : ℝ) : ℂ) := fun t => by
    simp only [hGdef]; push_cast; rfl
  -- replace `deriv f` by `f′` under the integral
  have hint_eq : ∫ t in Set.Ioc (1 : ℝ) M, deriv f t * ∑ k ∈ Icc 0 ⌊t⌋₊, ((gmu k : ℝ) : ℂ) =
      ∫ t in (1 : ℝ)..M, f' t * G t := by
    rw [intervalIntegral.integral_of_le hM1.le]
    refine setIntegral_congr_fun measurableSet_Ioc fun t ht => ?_
    simp only [hGdef]
    rw [(hfd t (by linarith [ht.1])).deriv]
  have hfM : f M = Q 0 := by simp only [hf, div_self hM0.ne', Real.log_one, zero_div]
  rw [hint_eq, hfM] at habel
  -- split `G = log + R`
  have hIG : IntervalIntegrable (fun t => f' t * G t) volume 1 M := by
    rw [intervalIntegrable_iff_integrableOn_Icc_of_le hM1.le]
    exact integrableOn_mul_sum_Icc _ zero_le_one hf'int
  have hf'at : ∀ t, 0 < t → ContinuousAt f' t := fun t ht0 =>
    (Complex.continuous_ofReal.continuousAt.comp
      ((continuousAt_inv₀ ht0.ne').neg.div_const _)).mul (hQ'c.continuousAt.comp (hcont t ht0))
  have hIL : IntervalIntegrable (fun t => f' t * (Real.log t : ℂ)) volume 1 M := by
    refine ContinuousOn.intervalIntegrable fun t ht => ?_
    rw [Set.uIcc_of_le hM1.le] at ht
    have ht0 : 0 < t := by linarith [ht.1]
    exact ((hf'at t ht0).mul
      (Complex.continuous_ofReal.continuousAt.comp (Real.continuousAt_log ht0.ne'))).continuousWithinAt
  have hsplit : ∫ t in (1 : ℝ)..M, f' t * G t = (∫ t in (1 : ℝ)..M, f' t * (Real.log t : ℂ)) +
      ∫ t in (1 : ℝ)..M, f' t * (G t - Real.log t) := by
    have h2 : ∫ t in (1 : ℝ)..M, f' t * (G t - Real.log t) =
        ∫ t in (1 : ℝ)..M, (f' t * G t - f' t * (Real.log t : ℂ)) :=
      intervalIntegral.integral_congr fun t _ => by ring
    rw [h2, intervalIntegral.integral_sub hIG hIL]; ring
  have hlog := int_fprime_log hQ hQ'c hM1
  rw [← hlM] at hlog
  have hlog' : ∫ t in (1 : ℝ)..M, f' t * (Real.log t : ℂ) = Q 0 * lM - (lM : ℂ) * ∫ u in (0 : ℝ)..1, Q u := by
    rw [← hlog]
  -- the remainder integral
  have hR : ‖∫ t in (1 : ℝ)..M, f' t * (G t - Real.log t)‖ ≤ CR * B' := by
    have hb : ∫ t in (1 : ℝ)..M, CR * B' / lM * (1 / t) = CR * B' := by
      rw [intervalIntegral.integral_const_mul, integral_one_div_of_pos zero_lt_one hM0, div_one,
        ← hlM]
      field_simp
    rw [← hb]
    refine intervalIntegral.norm_integral_le_of_norm_le hM1.le
      (Filter.Eventually.of_forall fun t ht => ?_) ?_
    · have ht1 : 1 ≤ t := ht.1.le
      have ht0 : 0 < t := by linarith
      have hu : Real.log (M / t) / lM ∈ Set.Icc (0 : ℝ) 1 := by
        refine ⟨div_nonneg (Real.log_nonneg ((le_div_iff₀ ht0).mpr (by linarith [ht.2]))) hl.le,
          (div_le_one hl).mpr ?_⟩
        rw [Real.log_div hM0.ne' ht0.ne']; linarith [Real.log_nonneg ht1]
      have hr : ‖G t - (Real.log t : ℂ)‖ ≤ CR := by
        rw [hGr, ← Complex.ofReal_sub, Complex.norm_real, Real.norm_eq_abs]
        exact hCR t ht1
      simp only [hf']
      rw [norm_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs]
      have : |-t⁻¹ / lM| = 1 / t / lM := by
        rw [abs_div, abs_neg, abs_of_pos (inv_pos.mpr ht0), abs_of_pos hl, one_div]
      rw [this]
      have hq := hB' _ hu
      have hB'0 : 0 ≤ B' := le_trans (norm_nonneg _) hq
      calc 1 / t / lM * ‖Q' (Real.log (M / t) / lM)‖ * ‖G t - (Real.log t : ℂ)‖
          ≤ 1 / t / lM * B' * CR :=
            mul_le_mul (mul_le_mul_of_nonneg_left hq (by positivity)) hr (norm_nonneg _)
              (by positivity)
        _ = CR * B' / lM * (1 / t) := by ring
    · refine ContinuousOn.intervalIntegrable fun t ht => ?_
      rw [Set.uIcc_of_le hM1.le] at ht
      have ht0 : 0 < t := by linarith [ht.1]
      exact (continuousAt_const.mul (continuousAt_const.div continuousAt_id ht0.ne')).continuousWithinAt
  have hRM : ‖G M - (lM : ℂ)‖ ≤ CR := by
    rw [hGr, ← Complex.ofReal_sub, Complex.norm_real, Real.norm_eq_abs]
    exact hCR M hM1.le
  have hGM : G M = ∑ k ∈ Icc 0 M, ((gmu k : ℝ) : ℂ) := by
    simp only [hGdef, Nat.floor_natCast]
  have key : ∑ k ∈ Icc 0 M, Q (Real.log ((M : ℝ) / k) / lM) * ((gmu k : ℝ) : ℂ) -
      (lM : ℂ) * ∫ u in (0 : ℝ)..1, Q u =
      Q 0 * (G M - lM) - ∫ t in (1 : ℝ)..M, f' t * (G t - Real.log t) := by
    have habel' : ∑ k ∈ Icc 0 M, Q (Real.log ((M : ℝ) / k) / lM) * ((gmu k : ℝ) : ℂ) =
        Q 0 * G M - ∫ t in (1 : ℝ)..M, f' t * G t := by
      rw [hGM]; exact habel
    rw [habel', hsplit, hlog']; ring
  rw [key]
  refine le_trans (norm_sub_le _ _) ?_
  rw [norm_mul]
  have hB0 : 0 ≤ B := le_trans (norm_nonneg _) hB
  have := mul_le_mul hB hRM (norm_nonneg _) hB0
  nlinarith

/-! ## Layer (3) -/

/-- `F_γ(u) = P′(u) + γλP(u)`, so `mainS(x, γ) = F_γ(ℓ)/λ`. -/
def Fg (P : Polynomial ℝ) (lM : ℝ) (γ : ℂ) (u : ℝ) : ℂ :=
  ((P.derivative.eval u : ℝ) : ℂ) + γ * (lM : ℂ) * ((P.eval u : ℝ) : ℂ)

theorem Fg_hasDerivAt (P : Polynomial ℝ) (lM : ℝ) (γ : ℂ) (u : ℝ) :
    HasDerivAt (Fg P lM γ) (Fg P.derivative lM γ u) u := by
  have h1 := (P.derivative.hasDerivAt u).ofReal_comp
  have h2 := ((P.hasDerivAt u).ofReal_comp).const_mul (γ * (lM : ℂ))
  exact h1.add h2

theorem Fg_continuous (P : Polynomial ℝ) (lM : ℝ) (γ : ℂ) : Continuous (Fg P lM γ) :=
  continuous_iff_continuousAt.mpr fun u => (Fg_hasDerivAt P lM γ u).continuousAt

theorem Fg_bound (P : Polynomial ℝ) {B0 B1 A lM : ℝ} (hB0 : ∀ u ∈ Set.Icc (0 : ℝ) 1, |P.eval u| ≤ B0)
    (hB1 : ∀ u ∈ Set.Icc (0 : ℝ) 1, |P.derivative.eval u| ≤ B1) (hl : 0 < lM) {γ : ℂ}
    (hγ : ‖γ‖ * lM ≤ A) (hA : 0 ≤ A) {u : ℝ} (hu : u ∈ Set.Icc (0 : ℝ) 1) :
    ‖Fg P lM γ u‖ ≤ B1 + A * B0 := by
  unfold Fg
  refine le_trans (norm_add_le _ _) ?_
  rw [norm_mul, norm_mul, Complex.norm_real, Complex.norm_real, Complex.norm_real,
    Real.norm_eq_abs, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos hl]
  have := hB1 u hu
  have h0 : 0 ≤ |P.eval u| := abs_nonneg _
  have := mul_le_mul hγ (hB0 u hu) h0 hA
  linarith

theorem mainS_eq_Fg (P : Polynomial ℝ) {lM : ℝ} (hl : 0 < lM) (x : ℝ) (γ : ℂ) :
    mainS P lM x γ = Fg P lM γ (Real.log x / lM) / (lM : ℂ) := by
  unfold mainS Fg
  have : (lM : ℂ) ≠ 0 := by exact_mod_cast hl.ne'
  field_simp; ring

theorem dsum_sum0 (P : Polynomial ℝ) {M : ℕ} (hl : 0 < Real.log M) (α β : ℂ) :
    ∑ k ∈ Icc 0 M, (Fg P (Real.log M) β (Real.log ((M : ℝ) / k) / Real.log M) *
        Fg P (Real.log M) α (Real.log ((M : ℝ) / k) / Real.log M)) * ((gmu k : ℝ) : ℂ) =
      (Real.log M : ℂ) ^ 2 * ∑ d ∈ Icc 1 M, ((gmu d : ℝ) : ℂ) *
        (mainS P (Real.log M) ((M : ℝ) / d) β * mainS P (Real.log M) ((M : ℝ) / d) α) := by
  rw [Finset.Icc_eq_cons_Ioc (Nat.zero_le M), Finset.sum_cons]
  simp only [gmu, Nat.totient_zero, Nat.cast_zero, div_zero, Complex.ofReal_zero, mul_zero,
    zero_add]
  have e : Ioc 0 M = Icc 1 M := by ext; simp [Nat.lt_iff_add_one_le]
  rw [e, Finset.mul_sum]
  refine Finset.sum_congr rfl fun d _ => ?_
  rw [mainS_eq_Fg P hl, mainS_eq_Fg P hl]
  have : (Real.log M : ℂ) ≠ 0 := by exact_mod_cast hl.ne'
  field_simp

set_option maxHeartbeats 1000000 in
/-- **Layer (3) from the arithmetic**: `StmtGmuLog` and `StmtDivLog` give `StmtDsum P A`. -/
theorem stmtDsum_of_arith (P : Polynomial ℝ) {A : ℝ} (hA : 0 ≤ A) (hG : StmtGmuLog)
    (hD : StmtDivLog) : StmtDsum P A := by
  intro ε hε
  obtain ⟨Cm, hCm0, hCm⟩ := mainS_bound P hA
  obtain ⟨CR, hCR0, hCR⟩ := abel_main hG
  obtain ⟨C5, hC50, hC5⟩ := hD
  obtain ⟨B0, hB00, hB0⟩ := poly_sup P
  obtain ⟨B1, hB10, hB1⟩ := poly_sup P.derivative
  obtain ⟨B2, hB20, hB2⟩ := poly_sup P.derivative.derivative
  set B := (B1 + A * B0) ^ 2 with hB
  set B' := 2 * ((B2 + A * B1) * (B1 + A * B0)) with hB'
  set K := 4 * A * Real.exp (2 * A) * Cm ^ 2 * C5 + CR * (B + B') with hK
  have hK0 : 0 ≤ K := by positivity
  set L₁ := max 1 (max (K / ε) (Real.log 2)) with hL₁
  refine ⟨max 2 ⌈Real.exp L₁⌉₊, fun M hM α β hα hβ => ?_⟩
  have hM2 : 2 ≤ M := le_trans (le_max_left _ _) hM
  have hMe : Real.exp L₁ ≤ M := le_trans (Nat.le_ceil _) (by exact_mod_cast le_trans (le_max_right _ _) hM)
  set lM := Real.log M with hlMdef
  have hlL : L₁ ≤ lM := by rw [← Real.log_exp L₁]; exact Real.log_le_log (Real.exp_pos _) hMe
  have hl1 : 1 ≤ lM := le_trans (le_max_left _ _) hlL
  have hl : 0 < lM := by linarith
  have hlK : K / ε ≤ lM := le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hlL
  set m : ℂ → ℕ → ℂ := fun γ d => mainS P lM ((M : ℝ) / d) γ with hm
  -- the two pieces
  have hsplit : ∑ d ∈ Icc 1 M, Wd α β d * Ahat P M d β * Ahat P M d α - IY P M α β / (lM : ℂ) =
      ∑ d ∈ Icc 1 M, (((((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 : ℝ) : ℂ) * Wd α β d - ((gmu d : ℝ) : ℂ)) *
          (m β d * m α d) +
        (∑ d ∈ Icc 1 M, ((gmu d : ℝ) : ℂ) * (m β d * m α d) - IY P M α β / (lM : ℂ)) := by
    rw [← sub_add_cancel (∑ d ∈ Icc 1 M, Wd α β d * Ahat P M d β * Ahat P M d α)
      (∑ d ∈ Icc 1 M, ((gmu d : ℝ) : ℂ) * (m β d * m α d)), ← Finset.sum_sub_distrib]
    have : ∀ d ∈ Icc 1 M, Wd α β d * Ahat P M d β * Ahat P M d α - ((gmu d : ℝ) : ℂ) *
        (m β d * m α d) = (((((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 : ℝ) : ℂ) * Wd α β d -
          ((gmu d : ℝ) : ℂ)) * (m β d * m α d) := by
      intro d _; simp only [hm]; unfold Ahat; push_cast; ring
    rw [Finset.sum_congr rfl this]; ring
  rw [hsplit]
  refine le_trans (norm_add_le _ _) ?_
  -- piece one: the weight
  have h1 : ‖∑ d ∈ Icc 1 M, (((((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 : ℝ) : ℂ) * Wd α β d -
      ((gmu d : ℝ) : ℂ)) * (m β d * m α d)‖ ≤
      2 * A * Real.exp (2 * A) * Cm ^ 2 / lM ^ 3 * (C5 * (1 + lM)) := by
    refine le_trans (norm_sum_le _ _) ?_
    have hterm : ∀ d ∈ Icc 1 M, ‖(((((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 : ℝ) : ℂ) * Wd α β d -
        ((gmu d : ℝ) : ℂ)) * (m β d * m α d)‖ ≤ 2 * A * Real.exp (2 * A) * Cm ^ 2 / lM ^ 3 *
          (((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d * (∑ a ∈ d.divisors, Real.log a / a)) := by
      intro d hd
      obtain ⟨hd1, hdM⟩ := Finset.mem_Icc.mp hd
      have hd0 : (0 : ℝ) < d := by exact_mod_cast hd1
      have hx1 : 1 ≤ (M : ℝ) / d :=
        (le_div_iff₀ hd0).mpr (by simpa using (by exact_mod_cast hdM : (d : ℝ) ≤ M))
      have hxl : Real.log ((M : ℝ) / d) ≤ lM :=
        Real.log_le_log (by linarith) (div_le_self (Nat.cast_nonneg _) (by exact_mod_cast hd1))
      have hw := weight_err hd1 hdM hl hα hβ
      have hmb := hCm lM hl _ hx1 hxl β hβ
      have hma := hCm lM hl _ hx1 hxl α hα
      rw [norm_mul, norm_mul]
      have hmm : ‖m β d‖ * ‖m α d‖ ≤ Cm / lM * (Cm / lM) :=
        mul_le_mul hmb hma (norm_nonneg _) (by positivity)
      have hs0 : 0 ≤ ∑ a ∈ d.divisors, Real.log a / a := Finset.sum_nonneg fun a _ =>
        div_nonneg (Real.log_natCast_nonneg a) (Nat.cast_nonneg a)
      have hc : 0 ≤ ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d := by have := sig_nonneg d; positivity
      calc _ ≤ ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d * (2 * A * Real.exp (2 * A) / lM) *
            (∑ a ∈ d.divisors, Real.log a / a) * (Cm / lM * (Cm / lM)) :=
            mul_le_mul hw hmm (by positivity) (by positivity)
        _ = _ := by field_simp
    refine le_trans (Finset.sum_le_sum hterm) ?_
    rw [← Finset.mul_sum]
    exact mul_le_mul_of_nonneg_left (hC5 M) (by positivity)
  -- piece two: Abel
  set Q : ℝ → ℂ := fun u => Fg P lM β u * Fg P lM α u with hQ
  set Q' : ℝ → ℂ := fun u => Fg P.derivative lM β u * Fg P lM α u +
    Fg P lM β u * Fg P.derivative lM α u with hQ'
  have hQd : ∀ u, HasDerivAt Q (Q' u) u := fun u =>
    (Fg_hasDerivAt P lM β u).mul (Fg_hasDerivAt P lM α u)
  have hQ'c : Continuous Q' := by
    have := Fg_continuous P lM β; have := Fg_continuous P lM α
    have := Fg_continuous P.derivative lM β; have := Fg_continuous P.derivative lM α
    simp only [hQ']; fun_prop
  have hb0 : ‖Q 0‖ ≤ B := by
    simp only [hQ]; rw [norm_mul, hB, sq]
    have hu : (0 : ℝ) ∈ Set.Icc (0 : ℝ) 1 := ⟨le_rfl, zero_le_one⟩
    exact mul_le_mul (Fg_bound P hB0 hB1 hl hβ hA hu) (Fg_bound P hB0 hB1 hl hα hA hu)
      (norm_nonneg _) (by positivity)
  have hb1 : ∀ u ∈ Set.Icc (0 : ℝ) 1, ‖Q' u‖ ≤ B' := by
    intro u hu
    simp only [hQ']
    refine le_trans (norm_add_le _ _) ?_
    rw [norm_mul, norm_mul]
    have a1 := Fg_bound P.derivative hB1 hB2 hl hβ hA hu
    have a2 := Fg_bound P hB0 hB1 hl hα hA hu
    have a3 := Fg_bound P hB0 hB1 hl hβ hA hu
    have a4 := Fg_bound P.derivative hB1 hB2 hl hα hA hu
    have := mul_le_mul a1 a2 (norm_nonneg _) (by positivity)
    have := mul_le_mul a3 a4 (norm_nonneg _) (by positivity)
    rw [hB']; nlinarith
  have hab := hCR M hM2 Q Q' hQd hQ'c B B' hb0 hb1
  have hIY : IY P M α β = ∫ u in (0 : ℝ)..1, Q u := by
    unfold IY
    refine intervalIntegral.integral_congr fun u _ => ?_
    simp only [hQ, Fg]; ring
  have hsum0 := dsum_sum0 P hl α β (M := M)
  have h2 : ‖∑ d ∈ Icc 1 M, ((gmu d : ℝ) : ℂ) * (m β d * m α d) - IY P M α β / (lM : ℂ)‖ ≤
      CR * (B + B') / lM ^ 2 := by
    have e : ∑ d ∈ Icc 1 M, ((gmu d : ℝ) : ℂ) * (m β d * m α d) - IY P M α β / (lM : ℂ) =
        (∑ k ∈ Icc 0 M, Q (Real.log ((M : ℝ) / k) / lM) * ((gmu k : ℝ) : ℂ) -
          (lM : ℂ) * ∫ u in (0 : ℝ)..1, Q u) / (lM : ℂ) ^ 2 := by
      rw [hsum0, hIY]
      have : (lM : ℂ) ≠ 0 := by exact_mod_cast hl.ne'
      field_simp
      ring
    rw [e, norm_div, norm_pow, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hl]
    exact div_le_div_of_nonneg_right hab (by positivity)
  -- the final arithmetic
  have hq : (1 + lM) ≤ 2 * lM := by linarith
  have f1 : 2 * A * Real.exp (2 * A) * Cm ^ 2 / lM ^ 3 * (C5 * (1 + lM)) ≤
      4 * A * Real.exp (2 * A) * Cm ^ 2 * C5 / lM ^ 2 := by
    rw [div_mul_eq_mul_div, div_le_div_iff₀ (by positivity) (by positivity)]
    have h0 : 0 ≤ 2 * A * Real.exp (2 * A) * Cm ^ 2 * C5 := by positivity
    have : 2 * A * Real.exp (2 * A) * Cm ^ 2 * (C5 * (1 + lM)) * lM ^ 2 ≤
        2 * A * Real.exp (2 * A) * Cm ^ 2 * C5 * (2 * lM) * lM ^ 2 := by
      have := mul_le_mul_of_nonneg_left hq h0
      nlinarith [sq_nonneg lM]
    nlinarith [pow_pos hl 3, pow_pos hl 2]
  have fK : K / lM ^ 2 ≤ ε / lM := by
    rw [div_le_div_iff₀ (by positivity) hl]
    rw [div_le_iff₀ hε] at hlK
    nlinarith
  have : 4 * A * Real.exp (2 * A) * Cm ^ 2 * C5 / lM ^ 2 + CR * (B + B') / lM ^ 2 = K / lM ^ 2 := by
    rw [hK]; ring
  linarith

end

/-- info: 'SdiagLead.stmtDsum_of_arith' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDsum_of_arith

/-- info: 'SdiagLead.abel_main' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms abel_main

/-- info: 'SdiagLead.weight_err' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms weight_err

end SdiagLead
