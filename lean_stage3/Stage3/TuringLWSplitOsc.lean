/-
TuringLWSplitOsc — block S14 of `lean_stage3/design/stencil.md`, Turing's method, Littlewood's
pieces: the right edge oscillates (`Turing.StmtOsc`). 2026-11-25.

On `Re s = 2`, `ζ′/ζ(s) = −Σ Λ(n) n^{−s}` (`ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div`).
Write `E n t = exp(−(2 + it) log n) = n^{−(2+it)}`, so `∂_t E n t = −i log n · E n t`. Two
primitives, each a series differentiated termwise (`hasDerivAt_tsum`):

  `H t = Σ −i Λ(n)/log n · E n t`,    `H′ t = −Σ Λ(n) E n t = ζ′/ζ(2 + it)`,
  `Ψ t = Σ Λ(n)/log² n · E n t`,      `Ψ′ t = H t`.

`H 0` is purely imaginary, so `F t = Re (H t − H 0) = Re H t`, and `∫_{t₁}^{t₂} F = Re (Ψ t₂ − Ψ t₁)`.
`|E n t| = n^{−2}` and `Λ(n)/log² n ≤ 1/log 2`, so

  `|∫_{t₁}^{t₂} F| ≤ 2 Σ_{n ≥ 2} Λ(n)/(n² log² n) ≤ 2 (π²/6 − 1)/log 2 < 1.87`.

| name | content | status |
|---|---|---|
| `vm` | `Λ n` as a real | def |
| `E` | `exp(−(2 + it) log n)` | def |
| `H` | `Σ −i Λ(n)/log n · E n t` | def |
| `Ψ` | `Σ Λ(n)/log² n · E n t` | def |
| `term_eq` | `term Λ (2 + it) n = Λ n · E n t` | proved |
| `logDeriv_eq_tsum` | `ζ′/ζ(2 + it) = Σ −Λ n · E n t` | proved |
| `hasDerivAt_H` | `H′ = ζ′/ζ(2 + i·)` | proved |
| `hasDerivAt_Ψ` | `Ψ′ = H` | proved |
| `F_eq_re_H` | `F t = Re H t` | proved |
| `continuous_F` | `F` continuous | proved |
| `integral_F` | `∫_{t₁}^{t₂} F = Re Ψ t₂ − Re Ψ t₁` | proved |
| `stmtOsc_explicit` | `StmtOsc (2 (π²/6 − 1)/log 2)` | proved |
| `stmtOsc_holds` | `StmtOsc 2` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringS

namespace TuringLW

open Complex MeasureTheory

noncomputable section

/-- `Λ n` as a real number. -/
def vm (n : ℕ) : ℝ := ArithmeticFunction.vonMangoldt n

/-- `E n t = exp(−(2 + it) log n) = n^{−(2+it)}`. -/
def E (n : ℕ) (t : ℝ) : ℂ := Complex.exp (-(2 + (t : ℂ) * I) * (Real.log n : ℂ))

/-- The primitive of `ζ′/ζ(2 + it)`. -/
def H (t : ℝ) : ℂ := ∑' n : ℕ, (-I * ((vm n / Real.log n : ℝ) : ℂ)) * E n t

/-- The primitive of `H`. -/
def Ψ (t : ℝ) : ℂ := ∑' n : ℕ, ((vm n / Real.log n ^ 2 : ℝ) : ℂ) * E n t

end

theorem vm_nonneg (n : ℕ) : 0 ≤ vm n := ArithmeticFunction.vonMangoldt_nonneg

theorem vm_le_log (n : ℕ) : vm n ≤ Real.log n := ArithmeticFunction.vonMangoldt_le_log

theorem vm_eq_zero_of_log {n : ℕ} (h : Real.log n = 0) : vm n = 0 :=
  le_antisymm (h ▸ vm_le_log n) (vm_nonneg n)

theorem vm_div_log_mul (n : ℕ) : vm n / Real.log n * Real.log n = vm n := by
  by_cases h : Real.log n = 0
  · rw [h, vm_eq_zero_of_log h]; simp
  · field_simp

theorem vm_div_log_sq_mul (n : ℕ) : vm n / Real.log n ^ 2 * Real.log n = vm n / Real.log n := by
  by_cases h : Real.log n = 0
  · rw [h]; simp
  · field_simp

theorem vm_div_log_nonneg (n : ℕ) : 0 ≤ vm n / Real.log n :=
  div_nonneg (vm_nonneg n) (Real.log_natCast_nonneg n)

theorem vm_div_log_le_one (n : ℕ) : vm n / Real.log n ≤ 1 := by
  by_cases h : Real.log n = 0
  · rw [h, div_zero]; norm_num
  · have hp : 0 < Real.log n := lt_of_le_of_ne (Real.log_natCast_nonneg n) (Ne.symm h)
    rw [div_le_one hp]
    exact vm_le_log n

theorem vm_div_log_sq_nonneg (n : ℕ) : 0 ≤ vm n / Real.log n ^ 2 :=
  div_nonneg (vm_nonneg n) (sq_nonneg _)

theorem vm_div_log_sq_le (n : ℕ) : vm n / Real.log n ^ 2 ≤ 1 / Real.log 2 := by
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  by_cases h : vm n = 0
  · rw [h, zero_div]; positivity
  · have hpp : IsPrimePow n := ArithmeticFunction.vonMangoldt_ne_zero_iff.mp h
    have h2 : (2 : ℝ) ≤ n := by exact_mod_cast hpp.two_le
    have hlog : Real.log 2 ≤ Real.log n := Real.log_le_log (by norm_num) h2
    have hpos : 0 < Real.log n := lt_of_lt_of_le hl2 hlog
    rw [div_le_div_iff₀ (by positivity) hl2]
    have := vm_le_log n
    have hv := vm_nonneg n
    nlinarith

theorem hasDerivAt_E (n : ℕ) (t : ℝ) :
    HasDerivAt (E n) (-(I * (Real.log n : ℂ)) * E n t) t := by
  have h1 : HasDerivAt (fun y : ℝ => -(2 + (y : ℂ) * I) * (Real.log n : ℂ))
      (-(1 * I) * (Real.log n : ℂ)) t := by
    have h0 : HasDerivAt (fun y : ℝ => (y : ℂ)) 1 t := by
      simpa using (hasDerivAt_id t).ofReal_comp
    exact ((h0.mul_const I).const_add 2).neg.mul_const _
  have h2 := h1.cexp
  refine h2.congr_deriv ?_
  simp only [E]
  ring

theorem norm_E (n : ℕ) (t : ℝ) : ‖E n t‖ = Real.exp (-2 * Real.log n) := by
  rw [E, Complex.norm_exp]
  congr 1
  simp [Complex.mul_re, -Complex.natCast_log]

theorem E_zero (n : ℕ) : E n 0 = ((Real.exp (-2 * Real.log n) : ℝ) : ℂ) := by
  rw [E, Complex.ofReal_exp]
  congr 1
  push_cast
  ring

theorem continuous_E (n : ℕ) : Continuous (E n) := by
  unfold E
  fun_prop

theorem term_eq (n : ℕ) (t : ℝ) :
    LSeries.term (fun n => ((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ)) (2 + (t : ℂ) * I) n
      = (vm n : ℂ) * E n t := by
  rcases eq_or_ne n 0 with rfl | hn
  · simp [vm]
  · rw [LSeries.term_of_ne_zero hn,
      Complex.cpow_def_of_ne_zero (Nat.cast_ne_zero.mpr hn), ← Complex.natCast_log, E,
      div_eq_mul_inv, ← Complex.exp_neg, vm]
    congr 2
    ring

/-- `v n = n^{−2}` (and `1` at `n = 0`). -/
theorem summable_v : Summable fun n : ℕ => Real.exp (-2 * Real.log n) := by
  rw [← summable_nat_add_iff 1]
  have h := (summable_nat_add_iff 1).mpr (Real.summable_one_div_nat_pow.mpr one_lt_two)
  refine h.congr fun n => ?_
  have hpos : (0 : ℝ) < ((n + 1 : ℕ) : ℝ) := by positivity
  rw [show -2 * Real.log ((n + 1 : ℕ) : ℝ) = -Real.log (((n + 1 : ℕ) : ℝ) ^ 2) by
    rw [Real.log_pow]; push_cast; ring, Real.exp_neg, Real.exp_log (by positivity)]
  simp

theorem summable_u : Summable fun n : ℕ => vm n * Real.exp (-2 * Real.log n) := by
  have hs := ArithmeticFunction.LSeriesSummable_vonMangoldt
    (s := 2 + ((0 : ℝ) : ℂ) * I) (by simp)
  have hn := summable_norm_iff.mpr hs
  refine hn.congr fun n => ?_
  rw [term_eq, norm_mul, norm_E, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (vm_nonneg n)]

theorem logDeriv_eq_tsum (t : ℝ) :
    logDeriv riemannZeta (2 + (t : ℂ) * I) = ∑' n : ℕ, -(vm n : ℂ) * E n t := by
  have hre : 1 < (2 + (t : ℂ) * I).re := by simp
  have hL := ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hre
  rw [LSeries] at hL
  simp_rw [term_eq] at hL
  rw [logDeriv_apply]
  have : ∑' n : ℕ, -(vm n : ℂ) * E n t = -∑' n : ℕ, (vm n : ℂ) * E n t := by
    rw [← tsum_neg]; congr 1; funext n; ring
  rw [this, hL]
  ring

theorem hasDerivAt_H (t : ℝ) : HasDerivAt H (∑' n : ℕ, -(vm n : ℂ) * E n t) t := by
  unfold H
  refine hasDerivAt_tsum (𝕜 := ℝ) (F := ℂ)
    (g := fun (n : ℕ) (y : ℝ) => (-I * ((vm n / Real.log n : ℝ) : ℂ)) * E n y)
    (g' := fun (n : ℕ) (y : ℝ) => -(vm n : ℂ) * E n y)
    (u := fun n => vm n * Real.exp (-2 * Real.log n)) summable_u ?_ ?_ (y₀ := 0) ?_ t
  · intro n y
    have h6 : ((vm n / Real.log n : ℝ) : ℂ) * ((Real.log n : ℝ) : ℂ) = ((vm n : ℝ) : ℂ) := by
      rw [← Complex.ofReal_mul, vm_div_log_mul]
    refine ((hasDerivAt_E n y).const_mul (-I * ((vm n / Real.log n : ℝ) : ℂ))).congr_deriv ?_
    linear_combination (((vm n / Real.log n : ℝ) : ℂ) * ((Real.log n : ℝ) : ℂ) * E n y) * I_sq
      - E n y * h6
  · intro n y
    rw [norm_mul, norm_neg, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (vm_nonneg n),
      norm_E]
  · refine Summable.of_norm_bounded summable_v fun n => ?_
    rw [norm_mul, norm_mul, norm_neg, Complex.norm_I, one_mul, Complex.norm_real,
      Real.norm_eq_abs, abs_of_nonneg (vm_div_log_nonneg n), norm_E]
    have := vm_div_log_le_one n
    have := Real.exp_pos (-2 * Real.log n)
    nlinarith

theorem hasDerivAt_Ψ (t : ℝ) : HasDerivAt Ψ (H t) t := by
  unfold Ψ H
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  refine hasDerivAt_tsum (𝕜 := ℝ) (F := ℂ)
    (g := fun (n : ℕ) (y : ℝ) => ((vm n / Real.log n ^ 2 : ℝ) : ℂ) * E n y)
    (g' := fun (n : ℕ) (y : ℝ) => (-I * ((vm n / Real.log n : ℝ) : ℂ)) * E n y)
    (u := fun n : ℕ => Real.exp (-2 * Real.log (n : ℝ))) summable_v ?_ ?_ (y₀ := 0) ?_ t
  · intro n y
    have h6 : ((vm n / Real.log n ^ 2 : ℝ) : ℂ) * ((Real.log n : ℝ) : ℂ)
        = ((vm n / Real.log n : ℝ) : ℂ) := by
      rw [← Complex.ofReal_mul, vm_div_log_sq_mul]
    refine ((hasDerivAt_E n y).const_mul ((vm n / Real.log n ^ 2 : ℝ) : ℂ)).congr_deriv ?_
    linear_combination (-I * E n y) * h6
  · intro n y
    rw [norm_mul, norm_mul, norm_neg, Complex.norm_I, one_mul, Complex.norm_real,
      Real.norm_eq_abs, abs_of_nonneg (vm_div_log_nonneg n), norm_E]
    have := vm_div_log_le_one n
    have := Real.exp_pos (-2 * Real.log n)
    nlinarith
  · refine Summable.of_norm_bounded (summable_v.div_const (Real.log 2)) fun n => ?_
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (vm_div_log_sq_nonneg n),
      norm_E, div_eq_mul_one_div (Real.exp _), mul_comm (Real.exp _)]
    exact mul_le_mul_of_nonneg_right (vm_div_log_sq_le n) (Real.exp_pos _).le

theorem continuous_H : Continuous H :=
  continuous_iff_continuousAt.mpr fun t => (hasDerivAt_H t).continuousAt

theorem continuous_logDeriv_line :
    Continuous fun u : ℝ => ∑' n : ℕ, -(vm n : ℂ) * E n u := by
  refine continuous_tsum (u := fun n => vm n * Real.exp (-2 * Real.log n))
    (fun n => continuous_const.mul (continuous_E n)) summable_u ?_
  intro n u
  rw [norm_mul, norm_neg, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (vm_nonneg n),
    norm_E]

theorem re_H_zero : (H 0).re = 0 := by
  have h : H 0 = -I * ((∑' n : ℕ, vm n / Real.log n * Real.exp (-2 * Real.log n) : ℝ) : ℂ) := by
    rw [H, Complex.ofReal_tsum, ← tsum_mul_left]
    congr 1
    funext n
    rw [E_zero]
    push_cast
    ring
  rw [h]
  simp

theorem F_eq_re_H (t : ℝ) : Turing.F t = (H t).re := by
  have hint : ∫ u in (0 : ℝ)..t, logDeriv riemannZeta (2 + (u : ℂ) * I) = H t - H 0 := by
    simp_rw [logDeriv_eq_tsum]
    exact intervalIntegral.integral_eq_sub_of_hasDerivAt (fun x _ => hasDerivAt_H x)
      (continuous_logDeriv_line.intervalIntegrable _ _)
  rw [Turing.F, hint, Complex.sub_re, re_H_zero, sub_zero]

theorem continuous_F : Continuous Turing.F := by
  have : Turing.F = fun t => (H t).re := funext F_eq_re_H
  rw [this]
  exact Complex.continuous_re.comp continuous_H

theorem integral_F (t₁ t₂ : ℝ) : ∫ t in t₁..t₂, Turing.F t = (Ψ t₂).re - (Ψ t₁).re := by
  refine intervalIntegral.integral_eq_sub_of_hasDerivAt (f := fun t => (Ψ t).re) (fun x _ => ?_)
    (continuous_F.intervalIntegrable _ _)
  have h := Complex.reCLM.hasFDerivAt.comp_hasDerivAt x (hasDerivAt_Ψ x)
  rw [F_eq_re_H]
  exact h

/-- `Σ_{n ≥ 2} n^{−2} = π²/6 − 1`, as a sum over all `n`. -/
theorem hasSum_w : HasSum (fun n : ℕ => 1 / (n : ℝ) ^ 2 - if n = 1 then 1 else 0)
    (Real.pi ^ 2 / 6 - 1) := by
  have h1 : HasSum (fun n : ℕ => if n = 1 then (1 : ℝ) else 0) 1 := hasSum_ite_eq 1 (1 : ℝ)
  exact hasSum_zeta_two.sub h1

theorem coeff_le_w (n : ℕ) :
    vm n / Real.log n ^ 2 * Real.exp (-2 * Real.log n)
      ≤ (1 / Real.log 2) * (1 / (n : ℝ) ^ 2 - if n = 1 then 1 else 0) := by
  by_cases h : vm n = 0
  · rw [h, zero_div, zero_mul]
    have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
    rcases Nat.lt_or_ge n 2 with hn | hn
    · interval_cases n <;> simp
    · have : n ≠ 1 := by omega
      rw [if_neg this, sub_zero]
      exact mul_nonneg (div_nonneg zero_le_one hl2.le) (by positivity)
  · have hpp : IsPrimePow n := ArithmeticFunction.vonMangoldt_ne_zero_iff.mp h
    have hn2 := hpp.two_le
    have hn1 : n ≠ 1 := by omega
    rw [if_neg hn1, sub_zero]
    have hpos : (0 : ℝ) < n := by positivity
    have hv : Real.exp (-2 * Real.log n) = 1 / (n : ℝ) ^ 2 := by
      rw [show -2 * Real.log (n : ℝ) = -Real.log ((n : ℝ) ^ 2) by rw [Real.log_pow]; push_cast; ring,
        Real.exp_neg, Real.exp_log (by positivity), one_div]
    rw [hv]
    exact mul_le_mul_of_nonneg_right (vm_div_log_sq_le n) (by positivity)

/-- The explicit constant `c₀ = 2 (π²/6 − 1)/log 2`. -/
theorem stmtOsc_explicit : Turing.StmtOsc (2 * (Real.pi ^ 2 / 6 - 1) / Real.log 2) := by
  intro t₁ t₂ _
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  set d : ℕ → ℝ := fun n => vm n / Real.log n ^ 2 with hd
  set v : ℕ → ℝ := fun n => Real.exp (-2 * Real.log n) with hv
  have hdv : Summable fun n => d n * v n :=
    Summable.of_norm_bounded (summable_v.div_const (Real.log 2)) fun n => by
      rw [Real.norm_eq_abs, abs_of_nonneg (mul_nonneg (vm_div_log_sq_nonneg n)
        (Real.exp_pos _).le), div_eq_mul_one_div (Real.exp _), mul_comm (Real.exp _)]
      exact mul_le_mul_of_nonneg_right (vm_div_log_sq_le n) (Real.exp_pos _).le
  have hs : ∀ t : ℝ, Summable fun n : ℕ => ((d n : ℝ) : ℂ) * E n t := fun t =>
    Summable.of_norm_bounded hdv fun n => by
      rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (vm_div_log_sq_nonneg n),
        norm_E]
  have hdiff : Ψ t₂ - Ψ t₁ = ∑' n : ℕ, ((d n : ℝ) : ℂ) * (E n t₂ - E n t₁) := by
    rw [Ψ, Ψ, ← (hs t₂).tsum_sub (hs t₁)]
    congr 1; funext n; ring
  have hb : ∀ n, ‖((d n : ℝ) : ℂ) * (E n t₂ - E n t₁)‖ ≤ 2 * (d n * v n) := by
    intro n
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (vm_div_log_sq_nonneg n)]
    have h1 : ‖E n t₂ - E n t₁‖ ≤ 2 * v n := by
      have := norm_sub_le (E n t₂) (E n t₁)
      rw [norm_E, norm_E] at this
      simp only [hv]
      linarith
    have := vm_div_log_sq_nonneg n
    nlinarith
  have hsn : Summable fun n => ‖((d n : ℝ) : ℂ) * (E n t₂ - E n t₁)‖ :=
    Summable.of_nonneg_of_le (fun _ => norm_nonneg _) hb (hdv.mul_left 2)
  have hw := (hasSum_w.mul_left (1 / Real.log 2)).mul_left 2
  have hle : ∑' n, 2 * (d n * v n)
      ≤ 2 * ((1 / Real.log 2) * (Real.pi ^ 2 / 6 - 1)) := by
    rw [← hw.tsum_eq]
    refine Summable.tsum_le_tsum (fun n => ?_) (hdv.mul_left 2) hw.summable
    have := coeff_le_w n
    simp only [hd, hv]
    linarith
  calc |∫ t in t₁..t₂, Turing.F t| = |(Ψ t₂ - Ψ t₁).re| := by
        rw [integral_F, Complex.sub_re]
    _ ≤ ‖Ψ t₂ - Ψ t₁‖ := Complex.abs_re_le_norm _
    _ ≤ ∑' n, ‖((d n : ℝ) : ℂ) * (E n t₂ - E n t₁)‖ := by
        rw [hdiff]; exact norm_tsum_le_tsum_norm hsn
    _ ≤ ∑' n, 2 * (d n * v n) := Summable.tsum_le_tsum hb hsn (hdv.mul_left 2)
    _ ≤ 2 * ((1 / Real.log 2) * (Real.pi ^ 2 / 6 - 1)) := hle
    _ = 2 * (Real.pi ^ 2 / 6 - 1) / Real.log 2 := by ring

/-- `2 (π²/6 − 1)/log 2 ≤ 2`. -/
theorem c₀_le_two : 2 * (Real.pi ^ 2 / 6 - 1) / Real.log 2 ≤ 2 := by
  have hl2 := Real.log_two_gt_d9
  have hpi := Real.pi_lt_d4
  have hp0 := Real.pi_pos
  rw [div_le_iff₀ (by linarith)]
  nlinarith

/-- **The right edge oscillates**, `c₀ = 2`. -/
theorem stmtOsc_holds : Turing.StmtOsc 2 := fun t₁ t₂ h =>
  (stmtOsc_explicit t₁ t₂ h).trans c₀_le_two

/-- info: 'TuringLW.F_eq_re_H' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms F_eq_re_H

/-- info: 'TuringLW.integral_F' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_F

/-- info: 'TuringLW.stmtOsc_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtOsc_explicit

/-- info: 'TuringLW.stmtOsc_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtOsc_holds

end TuringLW
