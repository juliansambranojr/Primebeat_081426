/-
PiFixedRow — block F4 of `lean_stage3/design/leftedge.md`. 2026-11-23.

The integer count at a fixed `x` with the height of the zero sum taken to
infinity. `PiZeros.pi_eq_zero_sum` is an identity at every height; what has to
be bounded free of the height is `tr (efRem T) x`, the passage of the explicit
formula's remainder. Above `16` the explicit formula at every height does it.
On `[2, 16]` each zero is integrated by parts in `t`, which gains a factor
`1/|ρ+1|`, and the zeros weighted by `m/|ρ|²` have a sum bounded free of the height.

  Z2, sum_order_inv_sq_le    Σ_{ZF T} m(ρ)/|ρ|² ≤ Z2 for every T
  Clow, norm_low_integral_le ‖∫₂¹⁶ efRem T t·wt t dt‖ ≤ Clow for every T
  Api, tr_efRem_fixed        16 ≤ x ⊢ eventually in T, ‖tr (efRem T) x‖ ≤ Api·log x + ε
  pi_fixed_row               the count, the same
  table_cell_fixed_row       the integer table's cell, under the stencil

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.PiRemainder
import Stage3.CellFixedRow

namespace PiFixedRow

open Chebyshev MeasureTheory Kadiri FiniteOffLine Finset PiZeros PiRemainder Filter Topology
open scoped Chebyshev

noncomputable section

/-- The closed form behind `Σ_j (j+2)²/2^j ≤ 22`: the partial sum plus a
vanishing tail is exactly `22`. -/
theorem sum_sq_div_pow_eq (n : ℕ) :
    ∑ j ∈ range n, ((2:ℝ) ^ j)⁻¹ * ((j:ℝ) + 2) ^ 2
      + (2 * (n:ℝ) ^ 2 + 12 * n + 22) * ((2:ℝ) ^ n)⁻¹ = 22 := by
  induction n with
  | zero => norm_num
  | succ n ih =>
    rw [Finset.sum_range_succ]
    have e : ((2:ℝ) ^ (n + 1))⁻¹ = ((2:ℝ) ^ n)⁻¹ * 2⁻¹ := by
      rw [pow_succ, mul_inv]
    rw [e]
    push_cast
    linear_combination ih

/-- The partial sums of `(j+2)²/2^j` are at most `22`. -/
theorem sum_sq_div_pow_le (n : ℕ) :
    ∑ j ∈ range n, ((2:ℝ) ^ j)⁻¹ * ((j:ℝ) + 2) ^ 2 ≤ 22 := by
  have h := sum_sq_div_pow_eq n
  have : 0 ≤ (2 * (n:ℝ) ^ 2 + 12 * n + 22) * ((2:ℝ) ^ n)⁻¹ := by positivity
  linarith

/-- The sum of `m(ρ)/|ρ|` over the zeros below `2^(j+1)` is at most `Mlow·3000·(j+2)²`. -/
theorem zinv_dyadic_le (j : ℕ) :
    ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹
      ≤ Mlow * (3000 * ((j : ℝ) + 2) ^ 2) :=
  (sum_order_inv_le j).trans
    (mul_le_mul_of_nonneg_left (dyadic_count_le j) (by linarith [two_le_Mlow]))

/-- The constant bounding the zeros weighted by `m/|ρ|²`: `66000·Mlow²`. -/
def Z2 : ℝ := 66000 * Mlow ^ 2

/-- The constant `Z2` is nonnegative. -/
theorem Z2_nonneg : 0 ≤ Z2 := by unfold Z2; positivity

/-- **The zeros weighted by `m/|ρ|²` are bounded free of the height.** For every
`T`, the sum over the zeros below `T` of `m(ρ)·(1/|ρ|)²` is at most `Z2`. -/
theorem sum_order_inv_sq_le (T : ℝ) :
    ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (‖(ρ : ℂ)‖⁻¹) ^ 2 ≤ Z2 := by
  classical
  have hM := two_le_Mlow
  obtain ⟨K, hK⟩ := pow_unbounded_of_one_lt T (by norm_num : (1:ℝ) < 2)
  have hTK : T ≤ (2:ℝ) ^ (K + 1) :=
    hK.le.trans (pow_le_pow_right₀ (by norm_num) (Nat.le_succ K))
  have hsub : ZF T ⊆ ZF ((2 : ℝ) ^ (K + 1)) := by
    intro ρ hρ
    rw [mem_ZF] at hρ ⊢
    linarith
  have h1 := Finset.sum_le_sum_of_subset_of_nonneg hsub
    (f := fun ρ : NontrivialZeros => ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (‖(ρ : ℂ)‖⁻¹) ^ 2)
    (fun ρ _ _ => mul_nonneg (order_nonneg ρ) (by positivity))
  refine h1.trans ?_
  have hterm : ∀ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)),
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (‖(ρ : ℂ)‖⁻¹) ^ 2
        ≤ ∑ j ∈ range (K + 1), Mlow * (((2 : ℝ) ^ j)⁻¹
            * ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹)
              * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))) := by
    intro ρ hρ
    have h := inv_norm_le_dyadic ρ K (mem_ZF.mp hρ)
    have hn : 0 ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹ :=
      mul_nonneg (order_nonneg ρ) (by positivity)
    calc ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (‖(ρ : ℂ)‖⁻¹) ^ 2
        = (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹) * ‖(ρ : ℂ)‖⁻¹ := by ring
      _ ≤ (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹) * (Mlow * ∑ j ∈ range (K + 1),
            ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0)) :=
          mul_le_mul_of_nonneg_left h hn
      _ = _ := by
          rw [Finset.mul_sum, Finset.mul_sum]
          exact Finset.sum_congr rfl fun j _ => by ring
  refine le_trans (Finset.sum_le_sum hterm) ?_
  rw [Finset.sum_comm]
  have hblock : ∀ j ∈ range (K + 1),
      ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), Mlow * (((2 : ℝ) ^ j)⁻¹
            * ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹)
              * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0)))
        ≤ Mlow * (Mlow * 3000) * (((2 : ℝ) ^ j)⁻¹ * ((j : ℝ) + 2) ^ 2) := by
    intro j hj
    have hjK : j ≤ K := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
    have hle : (2 : ℝ) ^ (j + 1) ≤ (2 : ℝ) ^ (K + 1) :=
      pow_le_pow_right₀ (by norm_num) (by omega)
    have hinner : (∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)),
          (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹)
          * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))
        = ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)),
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹ := by
      simp only [mul_ite, mul_one, mul_zero]
      rw [← Finset.sum_filter]
      congr 1
      ext ρ
      simp only [Finset.mem_filter, mem_ZF]
      exact ⟨fun h => h.2, fun h => ⟨lt_of_lt_of_le h hle, h⟩⟩
    have hz := zinv_dyadic_le j
    calc (∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), Mlow * (((2 : ℝ) ^ j)⁻¹
            * ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹)
              * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))))
        = Mlow * (((2 : ℝ) ^ j)⁻¹ * ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)),
            (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹)
              * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0)) := by
          rw [Finset.mul_sum, Finset.mul_sum]
      _ = Mlow * (((2 : ℝ) ^ j)⁻¹ * ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)),
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹) := by rw [hinner]
      _ ≤ Mlow * (((2 : ℝ) ^ j)⁻¹ * (Mlow * (3000 * ((j : ℝ) + 2) ^ 2))) :=
          mul_le_mul_of_nonneg_left
            (mul_le_mul_of_nonneg_left hz (by positivity)) (by linarith)
      _ = _ := by ring
  refine (Finset.sum_le_sum hblock).trans ?_
  rw [← Finset.mul_sum]
  have hs := sum_sq_div_pow_le (K + 1)
  have hc : 0 ≤ Mlow * (Mlow * 3000) := by positivity
  calc Mlow * (Mlow * 3000) * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * ((j : ℝ) + 2) ^ 2
      ≤ Mlow * (Mlow * 3000) * 22 := mul_le_mul_of_nonneg_left hs hc
    _ = Z2 := by unfold Z2; ring

/-- info: 'PiFixedRow.sum_order_inv_sq_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_order_inv_sq_le

/-- The weight `1/(t·log²t)` as a real function. -/
def w (t : ℝ) : ℝ := (t * Real.log t ^ 2)⁻¹

/-- The derivative of the real weight: `−(log t + 2)/(t²·log³t)`. -/
def wd (t : ℝ) : ℝ := -(Real.log t + 2) / (t ^ 2 * Real.log t ^ 3)

/-- For `t > 1` the real weight has derivative `wd t`. -/
theorem hasDerivAt_w {t : ℝ} (ht : 1 < t) : HasDerivAt w (wd t) t := by
  have ht0 : 0 < t := by linarith
  have hl : 0 < Real.log t := Real.log_pos ht
  have h1 : HasDerivAt (fun s => s * Real.log s ^ 2)
      (1 * Real.log t ^ 2 + t * ((2:ℕ) * Real.log t ^ (2 - 1) * t⁻¹)) t :=
    (hasDerivAt_id t).mul ((Real.hasDerivAt_log ht0.ne').pow 2)
  have h2 := h1.inv (by positivity)
  have e : w = (fun s => s * Real.log s ^ 2)⁻¹ := by
    funext s
    simp [w]
  rw [e]
  refine h2.congr_deriv ?_
  unfold wd
  field_simp
  push_cast
  try ring

/-- For `t > 1` the weight, read as complex, has derivative `wd t`. -/
theorem hasDerivAt_wt {t : ℝ} (ht : 1 < t) : HasDerivAt wt ((wd t : ℝ) : ℂ) t :=
  (hasDerivAt_w ht).ofReal_comp

/-- On `[2, 16]` the derivative of the weight is continuous. -/
theorem continuousOn_wd : ContinuousOn wd (Set.uIcc 2 16) := by
  rw [Set.uIcc_of_le (by norm_num)]
  have hlog : ContinuousOn Real.log (Set.Icc (2:ℝ) 16) :=
    Real.continuousOn_log.mono (by
      intro t ht
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
      linarith [ht.1])
  unfold wd
  refine ((hlog.add continuousOn_const).neg).div
    ((continuousOn_id.pow 2).mul (hlog.pow 3)) ?_
  intro t ht
  have : 0 < Real.log t := Real.log_pos (by linarith [ht.1])
  have : 0 < t := by linarith [ht.1]
  positivity

/-- For `t ≥ 2` the weight is at most `2`. -/
theorem w_le_two {t : ℝ} (ht : 2 ≤ t) : w t ≤ 2 := by
  have hl2 : (0.69:ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hl : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) ht
  have hlp : 0 < Real.log t := by linarith
  have ht0 : 0 < t := by linarith
  unfold w
  rw [inv_le_comm₀ (by positivity) (by norm_num)]
  nlinarith

/-- For `t ≥ 2` the weight is positive. -/
theorem w_pos {t : ℝ} (ht : 2 ≤ t) : 0 < w t := by
  have hl : 0 < Real.log t := Real.log_pos (by linarith)
  unfold w
  have : 0 < t := by linarith
  positivity

/-- On `[2, 16]` the derivative of the weight is at most `4` in size. -/
theorem abs_wd_le {t : ℝ} (ht : 2 ≤ t) (ht' : t ≤ 16) : |wd t| ≤ 4 := by
  have hl2 : (0.69:ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hl2' : Real.log 2 < 0.7 := by
    have := Real.log_two_lt_d9
    linarith
  have hl : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) ht
  have h16 : Real.log t ≤ Real.log 16 := Real.log_le_log (by linarith) ht'
  have e16 : Real.log 16 = 4 * Real.log 2 := by
    rw [show (16:ℝ) = 2 ^ 4 by norm_num, Real.log_pow]
    push_cast
    ring
  have hlt : 0 < Real.log t := by linarith
  have hden : 0 < t ^ 2 * Real.log t ^ 3 := by positivity
  unfold wd
  rw [abs_div, abs_neg, abs_of_pos (by linarith), abs_of_pos hden, div_le_iff₀ hden]
  have h3 : (0.69:ℝ) ^ 3 ≤ Real.log t ^ 3 := pow_le_pow_left₀ (by norm_num) (by linarith) 3
  have ht2 : (4:ℝ) ≤ t ^ 2 := by nlinarith
  have := mul_le_mul ht2 h3 (by norm_num) (by positivity)
  nlinarith

/-- For `ρ` with `0 < Re ρ`, `|ρ| ≤ |ρ + 1|`. -/
theorem norm_le_norm_add_one {ρ : ℂ} (h : 0 < ρ.re) : ‖ρ‖ ≤ ‖ρ + 1‖ := by
  have h1 : ‖ρ‖ ^ 2 ≤ ‖ρ + 1‖ ^ 2 := by
    rw [Complex.sq_norm, Complex.sq_norm, Complex.normSq_apply, Complex.normSq_apply]
    simp only [Complex.add_re, Complex.one_re, Complex.add_im, Complex.one_im, add_zero]
    nlinarith
  nlinarith [norm_nonneg ρ, norm_nonneg (ρ + 1)]

/-- **One zero on `[2, 16]`, integrated by parts.** For `0 < Re ρ < 1`, the
integral of `t^ρ` against the weight over `[2, 16]` is at most `15360/|ρ + 1|`. -/
theorem norm_integral_cpow_wt_le {ρ : ℂ} (h0 : 0 < ρ.re) (h1 : ρ.re < 1) :
    ‖∫ t in (2:ℝ)..16, wt t * (t : ℂ) ^ ρ‖ ≤ 15360 * ‖ρ + 1‖⁻¹ := by
  have hρ1 : ρ ≠ -1 := by
    intro h
    rw [h] at h0
    norm_num at h0
  have hre1 : (ρ + 1).re = ρ.re + 1 := by simp
  have hB : 0 ≤ ‖ρ + 1‖⁻¹ := by positivity
  have hIcc : Set.uIcc (2:ℝ) 16 = Set.Icc 2 16 := Set.uIcc_of_le (by norm_num)
  have hu : ∀ t ∈ Set.uIcc (2:ℝ) 16, HasDerivAt wt ((wd t : ℝ) : ℂ) t := by
    intro t ht
    rw [hIcc] at ht
    exact hasDerivAt_wt (by linarith [ht.1])
  have hv : ∀ t ∈ Set.uIcc (2:ℝ) 16, HasDerivAt (fun y : ℝ => (y : ℂ) ^ (ρ + 1) / (ρ + 1))
      ((t : ℂ) ^ ρ) t := by
    intro t ht
    rw [hIcc] at ht
    exact hasDerivAt_ofReal_cpow_const' (by linarith [ht.1]) hρ1
  have hu' : IntervalIntegrable (fun t => ((wd t : ℝ) : ℂ)) volume 2 16 :=
    (Complex.continuous_ofReal.comp_continuousOn continuousOn_wd).intervalIntegrable
  have hv' : IntervalIntegrable (fun t : ℝ => (t : ℂ) ^ ρ) volume 2 16 := by
    apply ContinuousOn.intervalIntegrable
    rw [hIcc]
    intro t ht
    have ht0 : t ≠ 0 := by linarith [ht.1]
    exact (Complex.continuousAt_ofReal_cpow_const t ρ (Or.inr ht0)).continuousWithinAt
  rw [intervalIntegral.integral_mul_deriv_eq_deriv_mul hu hv hu' hv']
  -- the size of `t^(ρ+1)/(ρ+1)` on `[2, 16]`
  have hvb : ∀ t : ℝ, 2 ≤ t → t ≤ 16 →
      ‖(t : ℂ) ^ (ρ + 1) / (ρ + 1)‖ ≤ 256 * ‖ρ + 1‖⁻¹ := by
    intro t ht ht'
    have ht0 : 0 < t := by linarith
    rw [norm_div, Complex.norm_cpow_eq_rpow_re_of_pos ht0, hre1, div_eq_mul_inv]
    apply mul_le_mul_of_nonneg_right _ hB
    calc t ^ (ρ.re + 1) ≤ t ^ (2:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by linarith) (by linarith)
      _ = t ^ 2 := Real.rpow_two t
      _ ≤ 256 := by nlinarith
  have hwb : ∀ t : ℝ, 2 ≤ t → ‖wt t‖ ≤ 2 := by
    intro t ht
    show ‖((w t : ℝ) : ℂ)‖ ≤ 2
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos (w_pos ht)]
    exact w_le_two ht
  have hb16 : ‖wt 16 * ((16:ℝ) : ℂ) ^ (ρ + 1) / (ρ + 1)‖ ≤ 2 * (256 * ‖ρ + 1‖⁻¹) := by
    rw [mul_div_assoc, norm_mul]
    exact mul_le_mul (hwb 16 (by norm_num)) (hvb 16 (by norm_num) le_rfl) (norm_nonneg _)
      (by norm_num)
  have hb2 : ‖wt 2 * ((2:ℝ) : ℂ) ^ (ρ + 1) / (ρ + 1)‖ ≤ 2 * (256 * ‖ρ + 1‖⁻¹) := by
    rw [mul_div_assoc, norm_mul]
    exact mul_le_mul (hwb 2 le_rfl) (hvb 2 le_rfl (by norm_num)) (norm_nonneg _)
      (by norm_num)
  have hint : ‖∫ t in (2:ℝ)..16, ((wd t : ℝ) : ℂ) * ((t : ℂ) ^ (ρ + 1) / (ρ + 1))‖
      ≤ 4 * (256 * ‖ρ + 1‖⁻¹) * |(16:ℝ) - 2| := by
    apply intervalIntegral.norm_integral_le_of_norm_le_const
    intro t ht
    rw [Set.uIoc_of_le (by norm_num)] at ht
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    exact mul_le_mul (abs_wd_le ht.1.le ht.2) (hvb t ht.1.le ht.2) (norm_nonneg _)
      (by norm_num)
  have habs : |(16:ℝ) - 2| = 14 := by norm_num
  rw [habs] at hint
  have hn := norm_sub_le (wt 16 * ((16:ℝ) : ℂ) ^ (ρ + 1) / (ρ + 1)
    - wt 2 * ((2:ℝ) : ℂ) ^ (ρ + 1) / (ρ + 1))
    (∫ t in (2:ℝ)..16, ((wd t : ℝ) : ℂ) * ((t : ℂ) ^ (ρ + 1) / (ρ + 1)))
  have hn2 := norm_sub_le (wt 16 * ((16:ℝ) : ℂ) ^ (ρ + 1) / (ρ + 1))
    (wt 2 * ((2:ℝ) : ℂ) ^ (ρ + 1) / (ρ + 1))
  simp only [mul_div_assoc] at hn hn2 hb16 hb2 ⊢
  linarith

/-- One zero's term on `[2, 16]`: for `0 < Re ρ < 1`, the integral of `t^ρ/ρ`
against the weight is at most `15360/|ρ|²`. -/
theorem norm_zero_term_le {ρ : ℂ} (h0 : 0 < ρ.re) (h1 : ρ.re < 1) :
    ‖∫ t in (2:ℝ)..16, (t : ℂ) ^ ρ / ρ * wt t‖ ≤ 15360 * (‖ρ‖⁻¹) ^ 2 := by
  have hρ0 : ρ ≠ 0 := by
    intro h
    rw [h] at h0
    norm_num at h0
  have hn : 0 < ‖ρ‖ := norm_pos_iff.mpr hρ0
  have e : (fun t : ℝ => (t : ℂ) ^ ρ / ρ * wt t) = fun t : ℝ => ρ⁻¹ * (wt t * (t : ℂ) ^ ρ) := by
    funext t
    rw [div_eq_mul_inv]
    ring
  rw [e, intervalIntegral.integral_const_mul, norm_mul, norm_inv]
  have h := norm_integral_cpow_wt_le h0 h1
  have hle : ‖ρ + 1‖⁻¹ ≤ ‖ρ‖⁻¹ := inv_anti₀ hn (norm_le_norm_add_one h0)
  calc ‖ρ‖⁻¹ * ‖∫ t in (2:ℝ)..16, wt t * (t : ℂ) ^ ρ‖
      ≤ ‖ρ‖⁻¹ * (15360 * ‖ρ + 1‖⁻¹) := mul_le_mul_of_nonneg_left h (by positivity)
    _ ≤ ‖ρ‖⁻¹ * (15360 * ‖ρ‖⁻¹) :=
        mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hle (by norm_num)) (by positivity)
    _ = 15360 * (‖ρ‖⁻¹) ^ 2 := by ring

/-- The constant bounding the low integral: `294 + 15360·Z2`. -/
def Clow : ℝ := 294 + 15360 * Z2

/-- The constant `Clow` is nonnegative. -/
theorem Clow_nonneg : 0 ≤ Clow := by
  have := Z2_nonneg
  unfold Clow
  linarith

/-- **The low integral is bounded free of the height.** For every `T`, the
integral of the explicit formula's remainder against the weight over `[2, 16]`
is at most `Clow`. -/
theorem norm_low_integral_le (T : ℝ) :
    ‖∫ t in (2:ℝ)..16, efRem T t * wt t‖ ≤ Clow := by
  have h216 : (2:ℝ) ≤ 16 := by norm_num
  have hψ := integrable_ofReal_of_monotone psi_mono 16
  have hid : IntervalIntegrable (fun t : ℝ => (t : ℂ)) volume 2 16 :=
    Complex.continuous_ofReal.intervalIntegrable 2 16
  have hA := integrable_mul_wt h216 (hψ.sub hid)
  have hZi : ∀ ρ ∈ ZF T, IntervalIntegrable
      (fun t : ℝ => ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ) * wt t))
      volume 2 16 := fun ρ _ => (integrable_mul_wt h216 (integrable_cpow h216 (ρ : ℂ))).const_mul _
  have hZ : IntervalIntegrable (fun t : ℝ => ∑ ρ ∈ ZF T,
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ) * wt t)) volume 2 16 := by
    have e : (fun t : ℝ => ∑ ρ ∈ ZF T,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ) * wt t))
        = ∑ ρ ∈ ZF T, fun t : ℝ =>
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ) * wt t) := by
      funext t
      rw [Finset.sum_apply]
    rw [e]
    exact IntervalIntegrable.sum (ZF T) hZi
  have hfun : (fun t => efRem T t * wt t)
      = fun t => (((ψ t : ℝ) : ℂ) - (t : ℂ)) * wt t + ∑ ρ ∈ ZF T,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ) * wt t) := by
    funext t
    unfold efRem
    rw [zeroPartialSum_eq_sum, add_mul, Finset.sum_mul]
    congr 1
    exact Finset.sum_congr rfl fun ρ _ => by ring
  rw [hfun, intervalIntegral.integral_add hA hZ, intervalIntegral.integral_finsetSum hZi]
  -- the `ψ − t` part
  have hpsi : ‖∫ t in (2:ℝ)..16, (((ψ t : ℝ) : ℂ) - (t : ℂ)) * wt t‖ ≤ 21 * |(16:ℝ) - 2| := by
    apply intervalIntegral.norm_integral_le_of_norm_le_const
    intro t ht
    rw [Set.uIoc_of_le h216] at ht
    have h2t : (2:ℝ) ≤ t := ht.1.le
    have ht0 : 0 < t := by linarith
    have hl2 : (0.69:ℝ) < Real.log 2 := by
      have := Real.log_two_gt_d9
      linarith
    have hlt : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) h2t
    have hltpos : 0 < Real.log t := by linarith
    have hpos : 0 < t * Real.log t ^ 2 := by positivity
    have hE := norm_psi_sub_le (t := t) ht0.le
    have hwt : ‖wt t‖ = (t * Real.log t ^ 2)⁻¹ := by
      unfold wt
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hpos)]
    have hinv : (Real.log t ^ 2)⁻¹ ≤ 3 := by
      rw [inv_le_comm₀ (by positivity) (by norm_num)]
      nlinarith
    rw [norm_mul, hwt]
    calc ‖((ψ t : ℝ) : ℂ) - (t : ℂ)‖ * (t * Real.log t ^ 2)⁻¹
        ≤ 7 * t * (t * Real.log t ^ 2)⁻¹ :=
          mul_le_mul_of_nonneg_right hE (inv_pos.mpr hpos).le
      _ = 7 * (Real.log t ^ 2)⁻¹ := by
          field_simp
      _ ≤ 7 * 3 := mul_le_mul_of_nonneg_left hinv (by norm_num)
      _ = 21 := by norm_num
  have habs : |(16:ℝ) - 2| = 14 := by norm_num
  rw [habs] at hpsi
  -- the zeros
  have hzeros : ‖∑ ρ ∈ ZF T, ∫ t in (2:ℝ)..16,
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ) * wt t)‖
      ≤ 15360 * Z2 := by
    refine (norm_sum_le _ _).trans ?_
    have hterm : ∀ ρ ∈ ZF T, ‖∫ t in (2:ℝ)..16,
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ) * wt t)‖
        ≤ 15360 * (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (‖(ρ : ℂ)‖⁻¹) ^ 2) := by
      intro ρ _
      rw [intervalIntegral.integral_const_mul, norm_mul, Complex.norm_intCast,
        abs_of_nonneg (order_nonneg ρ)]
      have h := norm_zero_term_le (ρ := (ρ : ℂ)) ρ.2.1.1 ρ.2.1.2
      calc ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
            * ‖∫ t in (2:ℝ)..16, (t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ) * wt t‖
          ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (15360 * (‖(ρ : ℂ)‖⁻¹) ^ 2) :=
            mul_le_mul_of_nonneg_left h (order_nonneg ρ)
        _ = _ := by ring
    refine (Finset.sum_le_sum hterm).trans ?_
    rw [← Finset.mul_sum]
    exact mul_le_mul_of_nonneg_left (sum_order_inv_sq_le T) (by norm_num)
  have hn := norm_add_le (∫ t in (2:ℝ)..16, (((ψ t : ℝ) : ℂ) - (t : ℂ)) * wt t)
    (∑ ρ ∈ ZF T, ∫ t in (2:ℝ)..16,
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ) * wt t))
  unfold Clow
  linarith

/-- info: 'PiFixedRow.norm_low_integral_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_low_integral_le

/-- The constant of the count at a fixed row: `2·(c3n + Bleft) + Clow`. -/
def Api : ℝ := 2 * (Glue.c3n + LeftSmooth.Bleft) + Clow

/-- The constant `Api` is nonnegative. -/
theorem Api_nonneg : 0 ≤ Api := by
  have := Glue.c3n_nonneg
  have := CellFixedRow.Bleft_nonneg
  have := Clow_nonneg
  unfold Api
  linarith

/-- For `x ≥ 16`, `log x ≥ 1`. -/
theorem one_le_log_of_16 {x : ℝ} (hx : 16 ≤ x) : 1 ≤ Real.log x := by
  have hl2 : (0.69:ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have e16 : Real.log 16 = 4 * Real.log 2 := by
    rw [show (16:ℝ) = 2 ^ 4 by norm_num, Real.log_pow]
    push_cast
    ring
  have := Real.log_le_log (by norm_num : (0:ℝ) < 16) hx
  linarith

/-- **The high integral at a fixed height.** For `16 ≤ x` and `T ≥ 2`, the
integral of the remainder against the weight over `[16, x]` is at most
`c1n·(x − 16)·log²(xT)/T + (c3n + Bleft)·log(x/16)`. -/
theorem norm_high_integral_le {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖∫ t in (16:ℝ)..x, efRem T t * wt t‖
      ≤ (x - 16) * (Glue.c1n * Real.log (x * T) ^ 2 / T)
        + (Glue.c3n + LeftSmooth.Bleft) * Real.log (x / 16) := by
  have hc1 := Glue.c1n_nonneg
  have hc3 := Glue.c3n_nonneg
  have hB := CellFixedRow.Bleft_nonneg
  have hT0 : 0 < T := by linarith
  have hx0 : 0 < x := by linarith
  have hL0 : 0 ≤ Real.log (x * T) := Real.log_nonneg (by nlinarith)
  have hginv : IntervalIntegrable (fun t : ℝ => t⁻¹) volume 16 x :=
    intervalIntegral.intervalIntegrable_inv (fun t ht => by
      rw [Set.uIcc_of_le hx] at ht
      linarith [ht.1]) continuousOn_id
  have hg : IntervalIntegrable (fun t : ℝ => Glue.c1n * Real.log (x * T) ^ 2 / T
      + (Glue.c3n + LeftSmooth.Bleft) * t⁻¹) volume 16 x :=
    intervalIntegrable_const.add (hginv.const_mul _)
  have h := intervalIntegral.norm_integral_le_of_norm_le hx (f := fun t => efRem T t * wt t)
    (g := fun t : ℝ => Glue.c1n * Real.log (x * T) ^ 2 / T
      + (Glue.c3n + LeftSmooth.Bleft) * t⁻¹) (by
      filter_upwards with t ht
      have h16 : (16:ℝ) ≤ t := ht.1.le
      have htx : t ≤ x := ht.2
      have ht0 : 0 < t := by linarith
      have hlt1 : 1 ≤ Real.log t := one_le_log_of_16 h16
      have hq := w_pos (t := t) (by linarith)
      have hwt : ‖wt t‖ = w t := by
        show ‖((w t : ℝ) : ℂ)‖ = w t
        rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos hq]
      have htq : t * w t ≤ 1 := by
        unfold w
        rw [← div_eq_mul_inv, div_le_one (by positivity)]
        have h1 : 1 ≤ Real.log t ^ 2 := by nlinarith
        exact le_mul_of_one_le_right ht0.le h1
      have hlq : Real.log t * w t ≤ t⁻¹ := by
        unfold w
        rw [mul_inv, ← mul_assoc, mul_comm (Real.log t) t⁻¹, mul_assoc]
        have : Real.log t * (Real.log t ^ 2)⁻¹ ≤ 1 := by
          rw [← div_eq_mul_inv, div_le_one (by positivity)]
          nlinarith
        calc t⁻¹ * (Real.log t * (Real.log t ^ 2)⁻¹) ≤ t⁻¹ * 1 :=
              mul_le_mul_of_nonneg_left this (by positivity)
          _ = t⁻¹ := mul_one _
      have hqq : w t ≤ t⁻¹ := by
        have : w t ≤ Real.log t * w t := le_mul_of_one_le_left hq.le hlt1
        linarith
      have hE : ‖efRem T t‖ ≤ Glue.c1n * t * Real.log (t * T) ^ 2 / T
          + Glue.c3n * Real.log t + LeftSmooth.Bleft * t ^ (-(1:ℝ)/4) :=
        LeftSmooth.explicit_formula_all h16 hT
      have hLt0 : 0 ≤ Real.log (t * T) := Real.log_nonneg (by nlinarith)
      have hLt : Real.log (t * T) ^ 2 ≤ Real.log (x * T) ^ 2 :=
        pow_le_pow_left₀ hLt0 (Real.log_le_log (by positivity)
          (mul_le_mul_of_nonneg_right htx hT0.le)) 2
      have hp : t ^ (-(1:ℝ)/4) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos (by linarith)
        (by norm_num)
      have hp0 : 0 ≤ t ^ (-(1:ℝ)/4) := Real.rpow_nonneg ht0.le _
      have t1 : Glue.c1n * t * Real.log (t * T) ^ 2 / T * w t
          ≤ Glue.c1n * Real.log (x * T) ^ 2 / T := by
        have e : Glue.c1n * t * Real.log (t * T) ^ 2 / T * w t
            = (Glue.c1n * Real.log (t * T) ^ 2 / T) * (t * w t) := by ring
        rw [e]
        calc (Glue.c1n * Real.log (t * T) ^ 2 / T) * (t * w t)
            ≤ (Glue.c1n * Real.log (t * T) ^ 2 / T) * 1 :=
              mul_le_mul_of_nonneg_left htq (by positivity)
          _ ≤ Glue.c1n * Real.log (x * T) ^ 2 / T := by
              rw [mul_one]
              exact div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hLt hc1) hT0.le
      have t2 : Glue.c3n * Real.log t * w t ≤ Glue.c3n * t⁻¹ := by
        rw [mul_assoc]
        exact mul_le_mul_of_nonneg_left hlq hc3
      have t3 : LeftSmooth.Bleft * t ^ (-(1:ℝ)/4) * w t ≤ LeftSmooth.Bleft * t⁻¹ := by
        rw [mul_assoc]
        apply mul_le_mul_of_nonneg_left _ hB
        calc t ^ (-(1:ℝ)/4) * w t ≤ 1 * t⁻¹ := mul_le_mul hp hqq hq.le (by norm_num)
          _ = t⁻¹ := one_mul _
      rw [norm_mul, hwt]
      calc ‖efRem T t‖ * w t
          ≤ (Glue.c1n * t * Real.log (t * T) ^ 2 / T
              + Glue.c3n * Real.log t + LeftSmooth.Bleft * t ^ (-(1:ℝ)/4)) * w t :=
            mul_le_mul_of_nonneg_right hE hq.le
        _ = Glue.c1n * t * Real.log (t * T) ^ 2 / T * w t + Glue.c3n * Real.log t * w t
              + LeftSmooth.Bleft * t ^ (-(1:ℝ)/4) * w t := by ring
        _ ≤ Glue.c1n * Real.log (x * T) ^ 2 / T + Glue.c3n * t⁻¹ + LeftSmooth.Bleft * t⁻¹ := by
            linarith
        _ = _ := by ring) hg
  refine h.trans (le_of_eq ?_)
  rw [intervalIntegral.integral_add intervalIntegrable_const (hginv.const_mul _),
    intervalIntegral.integral_const, intervalIntegral.integral_const_mul,
    integral_inv_of_pos (by norm_num) hx0, smul_eq_mul]

/-- **The passage of the remainder at a fixed row and a finite height.** For
`16 ≤ x` and `T ≥ 2`, `‖tr (efRem T) x‖ ≤ Api·log x + 2·c1n·x·log²(xT)/T`. -/
theorem norm_tr_efRem_le_height {x T : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T) :
    ‖tr (efRem T) x‖ ≤ Api * Real.log x + 2 * Glue.c1n * x * Real.log (x * T) ^ 2 / T := by
  have hc1 := Glue.c1n_nonneg
  have hc3 := Glue.c3n_nonneg
  have hB := CellFixedRow.Bleft_nonneg
  have hCl := Clow_nonneg
  have hT0 : 0 < T := by linarith
  have hx0 : 0 < x := by linarith
  have hL1 := one_le_log_of_16 hx
  have hLpos : 0 < Real.log x := by linarith
  have hL0 : 0 ≤ Real.log (x * T) := Real.log_nonneg (by nlinarith)
  have hx2 : (2:ℝ) ≤ x := by linarith
  have hI := integrable_mul_wt hx2 (integrable_efRem T hx2)
  have hmem : (16:ℝ) ∈ Set.uIcc (2 : ℝ) x := Set.mem_uIcc.mpr (Or.inl ⟨by norm_num, hx⟩)
  have hI1 := hI.mono_set (Set.uIcc_subset_uIcc Set.left_mem_uIcc hmem)
  have hI2 := hI.mono_set (Set.uIcc_subset_uIcc hmem Set.right_mem_uIcc)
  have hsplit := intervalIntegral.integral_add_adjacent_intervals hI1 hI2
  unfold tr
  rw [← hsplit]
  -- the value
  have hE : ‖efRem T x‖ ≤ Glue.c1n * x * Real.log (x * T) ^ 2 / T
      + Glue.c3n * Real.log x + LeftSmooth.Bleft * x ^ (-(1:ℝ)/4) :=
    LeftSmooth.explicit_formula_all hx hT
  have hp : x ^ (-(1:ℝ)/4) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos (by linarith)
    (by norm_num)
  have hBp : LeftSmooth.Bleft * x ^ (-(1:ℝ)/4) ≤ LeftSmooth.Bleft := by
    calc _ ≤ LeftSmooth.Bleft * 1 := mul_le_mul_of_nonneg_left hp hB
      _ = _ := mul_one _
  have hval : ‖efRem T x / (Real.log x : ℂ)‖ ≤ ‖efRem T x‖ := by
    rw [norm_div, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hLpos]
    exact div_le_self (norm_nonneg _) hL1
  -- the two integrals
  have hlow := norm_low_integral_le T
  have hhigh := norm_high_integral_le hx hT
  have hlog16 : Real.log (x / 16) ≤ Real.log x := by
    rw [Real.log_div hx0.ne' (by norm_num)]
    have : 0 ≤ Real.log 16 := Real.log_nonneg (by norm_num)
    linarith
  have hq : 0 ≤ Glue.c1n * Real.log (x * T) ^ 2 / T := by positivity
  have hx16 : (x - 16) * (Glue.c1n * Real.log (x * T) ^ 2 / T)
      ≤ Glue.c1n * x * Real.log (x * T) ^ 2 / T := by
    have : (x - 16) * (Glue.c1n * Real.log (x * T) ^ 2 / T)
        ≤ x * (Glue.c1n * Real.log (x * T) ^ 2 / T) :=
      mul_le_mul_of_nonneg_right (by linarith) hq
    have e : x * (Glue.c1n * Real.log (x * T) ^ 2 / T)
        = Glue.c1n * x * Real.log (x * T) ^ 2 / T := by ring
    linarith
  have hcb : (Glue.c3n + LeftSmooth.Bleft) * Real.log (x / 16)
      ≤ (Glue.c3n + LeftSmooth.Bleft) * Real.log x :=
    mul_le_mul_of_nonneg_left hlog16 (by linarith)
  have hconst : Glue.c3n + LeftSmooth.Bleft + Clow ≤ (Glue.c3n + LeftSmooth.Bleft + Clow) * Real.log x :=
    le_mul_of_one_le_right (by linarith) hL1
  have hn := norm_add_le (efRem T x / (Real.log x : ℂ))
    ((∫ t in (2:ℝ)..16, efRem T t * wt t) + ∫ t in (16:ℝ)..x, efRem T t * wt t)
  have hn2 := norm_add_le (∫ t in (2:ℝ)..16, efRem T t * wt t)
    (∫ t in (16:ℝ)..x, efRem T t * wt t)
  have e : Api * Real.log x + 2 * Glue.c1n * x * Real.log (x * T) ^ 2 / T
      = (Glue.c3n + LeftSmooth.Bleft + Clow) * Real.log x
        + (Glue.c3n + LeftSmooth.Bleft) * Real.log x
        + 2 * (Glue.c1n * x * Real.log (x * T) ^ 2 / T) := by
    unfold Api
    ring
  have e2 : (Glue.c3n + LeftSmooth.Bleft + Clow) * Real.log x
      = Glue.c3n * Real.log x + (LeftSmooth.Bleft + Clow) * Real.log x := by ring
  have hBC : LeftSmooth.Bleft + Clow ≤ (LeftSmooth.Bleft + Clow) * Real.log x :=
    le_mul_of_one_le_right (by linarith) hL1
  rw [e]
  linarith

/-- **The passage of the remainder at a fixed row, the height to infinity.**
For `16 ≤ x` and every `ε > 0`, for all large heights `T`,
`‖tr (efRem T) x‖ ≤ Api·log x + ε`. -/
theorem tr_efRem_fixed {x : ℝ} (hx : 16 ≤ x) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop, ‖tr (efRem T) x‖ ≤ Api * Real.log x + ε := by
  intro ε hε
  have hx0 : 0 < x := by linarith
  have hlim := CellFixedRow.tendsto_log_sq_div (2 * Glue.c1n) x hx0
  have hev := hlim.eventually (gt_mem_nhds hε)
  filter_upwards [hev, eventually_ge_atTop (2:ℝ)] with T hTε hT2
  have h := norm_tr_efRem_le_height hx hT2
  linarith

/-- info: 'PiFixedRow.tr_efRem_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tr_efRem_fixed

/-- **The count at a fixed row, the height to infinity.** For `16 ≤ x` and
every `ε > 0`, for all large heights `T`, the count minus `Li`, plus each zero's
part below `T`, plus the higher prime powers, is at most `Api·log x + ε`. -/
theorem pi_fixed_row {x : ℝ} (hx : 16 ≤ x) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
          + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
          + tr psiTheta x‖ ≤ Api * Real.log x + ε := by
  intro ε hε
  filter_upwards [tr_efRem_fixed hx ε hε] with T hT
  rw [pi_eq_zero_sum (by linarith) T]
  have e : ∀ A B C : ℂ, -A + B - C + A + C = B := fun A B C => by ring
  rw [e]
  exact hT

/-- info: 'PiFixedRow.pi_fixed_row' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pi_fixed_row

/-- **The integer table's cell at a fixed row, the height to infinity.** For
`d + 6 ≤ r` and every `ε > 0`, for all large heights `T`, the cell `(r, d)` of
the table of the prime count along the doublings, less the smooth cell, plus
each zero's part below `T` under the stencil, plus the stencil of the higher
prime powers, is at most `2^(d+1)·(Api·log 2·r) + ε`. -/
theorem table_cell_fixed_row (r : ℕ) (d : ℕ) (hr : d + 6 ≤ r) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖((((Construction.tableFrom TableRoute.rowN (r : ℤ) d : ℤ) : ℝ)
          - Nonvanishing.stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) (r : ℤ)
            : ℝ) : ℂ)
        + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
            * CellZeros.stencil (d + 1) (fun m : ℤ => piMode (ρ : ℂ) ((2:ℝ) ^ (m : ℝ))) (r : ℤ)
        + CellZeros.stencil (d + 1) (fun m : ℤ => tr psiTheta ((2:ℝ) ^ (m : ℝ))) (r : ℤ)‖
        ≤ 2 ^ (d + 1) * (Api * Real.log 2 * r) + ε := by
  intro ε hε
  have hA := Api_nonneg
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have h2d : (0:ℝ) < 2 ^ (d + 1) := by positivity
  have hε' : 0 < ε / 2 ^ (d + 1) := div_pos hε h2d
  have hrow : ∀ j ∈ range (d + 1 + 1),
      (16:ℝ) ≤ (2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ) := by
    intro j hj
    have hj' : j ≤ d + 1 := Nat.lt_succ_iff.mp (mem_range.mp hj)
    have h5 : ((5:ℕ):ℝ) ≤ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ) := by
      have : (5:ℤ) ≤ (r : ℤ) - (j : ℤ) := by omega
      exact_mod_cast this
    calc (16:ℝ) ≤ 2 ^ (5:ℕ) := by norm_num
      _ = (2:ℝ) ^ ((5:ℕ):ℝ) := (Real.rpow_natCast 2 5).symm
      _ ≤ _ := Real.rpow_le_rpow_of_exponent_le (by norm_num) h5
  have hev : ∀ j ∈ range (d + 1 + 1), ∀ᶠ T : ℝ in Filter.atTop,
      ‖tr (efRem T) ((2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ))‖
        ≤ Api * Real.log ((2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ)) + ε / 2 ^ (d + 1) :=
    fun j hj => tr_efRem_fixed (hrow j hj) _ hε'
  filter_upwards [(Filter.eventually_all_finset _).mpr hev] with T hT
  rw [table_cell_eq_zero_sum (r : ℤ) d (by omega) T]
  have e : ∀ A B C : ℂ, -A + B - C + A + C = B := fun A B C => by ring
  rw [e]
  refine (CellZeros.norm_stencil_le (d + 1) _ (r : ℤ)
    (fun _ => Api * Real.log 2 * r + ε / 2 ^ (d + 1)) (fun j hj => ?_)).trans ?_
  · refine (hT j hj).trans ?_
    have hlog : Real.log ((2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ)) ≤ Real.log 2 * r := by
      rw [Real.log_rpow (by norm_num)]
      push_cast
      nlinarith [(Nat.cast_nonneg j : (0:ℝ) ≤ j)]
    have : Api * Real.log ((2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ)) ≤ Api * Real.log 2 * r := by
      rw [mul_assoc]
      exact mul_le_mul_of_nonneg_left hlog hA
    linarith
  · rw [← Finset.sum_mul]
    have hs : ∑ j ∈ range (d + 1 + 1), ((d + 1).choose j : ℝ) = 2 ^ (d + 1) := by
      exact_mod_cast Nat.sum_range_choose (d + 1)
    rw [hs, mul_add, mul_div_cancel₀ _ h2d.ne']

/-- info: 'PiFixedRow.table_cell_fixed_row' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms table_cell_fixed_row

end

end PiFixedRow
