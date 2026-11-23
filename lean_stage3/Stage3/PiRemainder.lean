/-
PiRemainder — block T2b of `lean_stage3/design/joints.md`. 2026-11-23.

The passage of the explicit formula's remainder is of square-root size, with
no hypothesis on the zeros. Take the height equal to `x` and split the integral
in `tr (efRem x) x` at `√x`. Above `√x` the explicit formula holds and bounds
the remainder by a constant times `log²x`; against the weight this is at most a
constant times `√x`. Below `√x` the remainder is at most `(7 + W)·t`, where `W`
is the sum of `m(ρ)/|ρ|` over the zeros below `x`; against the weight this is a
constant, and `W` is at most a constant times `log²x` by the dyadic count. The
zeros of height below one enter through one finite constant, `Mlow`.

  Mlow, two_le_Mlow         a constant ≥ 2 and ≥ 1/|ρ| for every zero of height < 1
  inv_norm_le_Mlow          |γ| < 1 ⊢ 1/|ρ| ≤ Mlow
  inv_norm_le_dyadic        |γ| < 2^(K+1) ⊢ 1/|ρ| ≤ Mlow · the dyadic weights
  sum_order_inv_le          Σ m/|ρ| below 2^(K+1) ≤ Mlow · the dyadic count
  zinv, zinv_nonneg         Σ_{|γ|<T} m(ρ)/|ρ|, and it is nonnegative
  zinv_le_log               4 ≤ x ⊢ zinv x ≤ 39000·Mlow·log²x
  norm_zeroPartialSum_le    1 ≤ t ⊢ ‖Σ_{|γ|<T} m·t^ρ/ρ‖ ≤ t·zinv T
  norm_psi_sub_le           0 ≤ t ⊢ |ψ t − t| ≤ 7·t
  norm_efRem_le_low         1 ≤ t ⊢ ‖efRem T t‖ ≤ (7 + zinv T)·t
  Chigh, norm_efRem_le_high 16 ≤ t ≤ x ≤ t², 1 ≤ log x ⊢ ‖efRem x t‖ ≤ Chigh·log²x
  integrable_efRem          efRem T is integrable on [2, x]
  Arem, norm_tr_efRem_le_of 256 ≤ x ⊢ ‖tr (efRem x) x‖ ≤ Arem·√x·log²x
  norm_tr_efRem_le          ∃ A x₀, 0 ≤ A, x₀ ≤ x ⊢ ‖tr (efRem x) x‖ ≤ A·√x·log²x

What the next slice needs: the same bound passed through the stencil of the
table along the doublings, cell by cell, with the height of each entry equal
to that entry.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.PiZeros

namespace PiRemainder

open Chebyshev MeasureTheory Kadiri FiniteOffLine Finset PiZeros
open scoped Chebyshev

noncomputable section

/-- A constant that is at least `2` and at least the reciprocal size of every
zero of height below one. -/
def Mlow : ℝ := 2 + ∑ ρ ∈ ZF (1 : ℝ), ‖(ρ : ℂ)‖⁻¹

/-- The constant `Mlow` is at least `2`. -/
theorem two_le_Mlow : 2 ≤ Mlow := by
  unfold Mlow
  have : 0 ≤ ∑ ρ ∈ ZF (1 : ℝ), ‖(ρ : ℂ)‖⁻¹ := Finset.sum_nonneg fun ρ _ => by positivity
  linarith

/-- A zero of height below one has reciprocal size at most `Mlow`. -/
theorem inv_norm_le_Mlow {ρ : NontrivialZeros} (h : |(ρ : ℂ).im| < 1) :
    ‖(ρ : ℂ)‖⁻¹ ≤ Mlow := by
  have hmem : ρ ∈ ZF (1 : ℝ) := mem_ZF.mpr h
  have h1 : ‖(ρ : ℂ)‖⁻¹ ≤ ∑ σ ∈ ZF (1 : ℝ), ‖(σ : ℂ)‖⁻¹ :=
    Finset.single_le_sum (f := fun σ : NontrivialZeros => ‖(σ : ℂ)‖⁻¹)
      (fun σ _ => by positivity) hmem
  unfold Mlow
  linarith

/-- Any zero below `2^(K+1)` has reciprocal size at most `Mlow` times the dyadic weights. -/
theorem inv_norm_le_dyadic (ρ : NontrivialZeros) (K : ℕ)
    (him : |(ρ : ℂ).im| < 2 ^ (K + 1)) :
    ‖(ρ : ℂ)‖⁻¹ ≤ Mlow * ∑ j ∈ range (K + 1),
      ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
  have hM := two_le_Mlow
  have hSnn : (0 : ℝ) ≤ ∑ j ∈ range (K + 1),
      ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
    apply Finset.sum_nonneg
    intro j _
    have : (0 : ℝ) ≤ (if |(ρ : ℂ).im| < 2 ^ (j + 1) then (1 : ℝ) else 0) := by
      split <;> norm_num
    positivity
  by_cases hγ : 1 ≤ |(ρ : ℂ).im|
  · have hd := Stage3.inv_le_dyadic_sum K _ hγ him
    have hinv : ‖(ρ : ℂ)‖⁻¹ ≤ |(ρ : ℂ).im|⁻¹ :=
      inv_anti₀ (by linarith) (Complex.abs_im_le_norm _)
    have hS : (∑ j ∈ range (K + 1),
        ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))
        ≤ Mlow * ∑ j ∈ range (K + 1),
        ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) :=
      le_mul_of_one_le_left hSnn (by linarith)
    linarith
  · rw [not_le] at hγ
    have hS1 : (1 : ℝ) ≤ ∑ j ∈ range (K + 1),
        ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
      have h0mem : (0 : ℕ) ∈ range (K + 1) := by simp
      have h0term : ((2 : ℝ) ^ (0 : ℕ))⁻¹
          * (if |(ρ : ℂ).im| < 2 ^ (0 + 1) then (1 : ℝ) else 0) = 1 := by
        rw [if_pos (by norm_num; linarith), pow_zero, inv_one, mul_one]
      calc (1 : ℝ) = ((2 : ℝ) ^ (0 : ℕ))⁻¹
            * (if |(ρ : ℂ).im| < 2 ^ (0 + 1) then (1 : ℝ) else 0) := h0term.symm
        _ ≤ _ := by
            apply Finset.single_le_sum (f := fun j => ((2 : ℝ) ^ j)⁻¹
              * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then (1 : ℝ) else 0)) _ h0mem
            intro j _
            have : (0 : ℝ) ≤ (if |(ρ : ℂ).im| < 2 ^ (j + 1) then (1 : ℝ) else 0) := by
              split <;> norm_num
            positivity
    have h2 := inv_norm_le_Mlow hγ
    have h3 : Mlow ≤ Mlow * ∑ j ∈ range (K + 1),
        ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) :=
      le_mul_of_one_le_right (by linarith) hS1
    linarith

/-- **All the zeros, weighted by reciprocal size, below a height.** The sum of
`m(ρ)/|ρ|` over the zeros below `2^(K+1)` is at most `Mlow` times the dyadic count. -/
theorem sum_order_inv_le (K : ℕ) :
    ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹
      ≤ Mlow * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹
          * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket) := by
  classical
  have hM := two_le_Mlow
  have hterm : ∀ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)),
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹
        ≤ ∑ j ∈ range (K + 1), Mlow * (((2 : ℝ) ^ j)⁻¹
            * (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
              * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))) := by
    intro ρ hρ
    have h := inv_norm_le_dyadic ρ K (mem_ZF.mp hρ)
    calc ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹
        ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (Mlow * ∑ j ∈ range (K + 1),
            ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0)) :=
          mul_le_mul_of_nonneg_left h (order_nonneg ρ)
      _ = _ := by
          rw [Finset.mul_sum, Finset.mul_sum]
          exact Finset.sum_congr rfl fun j _ => by ring
  refine le_trans (Finset.sum_le_sum hterm) ?_
  rw [Finset.sum_comm, Finset.mul_sum]
  refine Finset.sum_le_sum fun j hj => ?_
  have hjK : j ≤ K := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  have hle : (2 : ℝ) ^ (j + 1) ≤ (2 : ℝ) ^ (K + 1) :=
    pow_le_pow_right₀ (by norm_num) (by omega)
  have hinner : (∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
        * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))
      = ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
    simp only [mul_ite, mul_one, mul_zero]
    rw [← Finset.sum_filter]
    congr 1
    ext ρ
    simp only [Finset.mem_filter, mem_ZF]
    exact ⟨fun h => h.2, fun h => ⟨lt_of_lt_of_le h hle, h⟩⟩
  have hc : ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
      ≤ 2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket :=
    (tsum_sub_eq_sum ((2 : ℝ) ^ (j + 1))
      (fun ρ : NontrivialZeros => ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ))).symm.le.trans
      (weighted_cumulative_count_le (k := j))
  calc (∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), Mlow * (((2 : ℝ) ^ j)⁻¹
          * (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
            * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))))
      = Mlow * (((2 : ℝ) ^ j)⁻¹ * ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)),
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
            * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0)) := by
        rw [Finset.mul_sum, Finset.mul_sum]
    _ = Mlow * (((2 : ℝ) ^ j)⁻¹
          * ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)) := by
        rw [hinner]
    _ ≤ Mlow * (((2 : ℝ) ^ j)⁻¹
          * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket)) :=
        mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_left hc (by positivity)) (by linarith)

/-- The sum of `m(ρ)/|ρ|` over the zeros below a height. -/
def zinv (T : ℝ) : ℝ := ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹

/-- The sum `zinv T` is nonnegative. -/
theorem zinv_nonneg (T : ℝ) : 0 ≤ zinv T :=
  Finset.sum_nonneg fun ρ _ => mul_nonneg (order_nonneg ρ) (by positivity)

/-- **The zeros below `x`, weighted by reciprocal size, are at most a constant
times `log²x`.** For `x ≥ 4` the constant is `39000·Mlow`. -/
theorem zinv_le_log {x : ℝ} (hx : 4 ≤ x) : zinv x ≤ Mlow * 39000 * Real.log x ^ 2 := by
  have hM := two_le_Mlow
  have hx0 : 0 < x := by linarith
  have hl2 : (0.69 : ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hl2pos : 0 < Real.log 2 := by linarith
  have hL1 : 1 ≤ Real.log x := by
    have h4 : Real.log 4 = 2 * Real.log 2 := by
      rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
      push_cast
      ring
    have := Real.log_le_log (by norm_num : (0:ℝ) < 4) hx
    linarith
  have hq0 : 0 ≤ Real.log x / Real.log 2 := div_nonneg (by linarith) hl2pos.le
  obtain ⟨K, hKdef⟩ : ∃ K : ℕ, K = ⌊Real.log x / Real.log 2⌋₊ := ⟨_, rfl⟩
  have hKle : (K : ℝ) ≤ Real.log x / Real.log 2 := by rw [hKdef]; exact Nat.floor_le hq0
  have hKlt : Real.log x / Real.log 2 < (K : ℝ) + 1 := by
    rw [hKdef]; exact Nat.lt_floor_add_one _
  have hx2K : x ≤ (2 : ℝ) ^ (K + 1) := by
    have h1 : Real.log x < ((K : ℝ) + 1) * Real.log 2 := by
      rwa [div_lt_iff₀ hl2pos] at hKlt
    have h2 : Real.log x < Real.log ((2 : ℝ) ^ (K + 1)) := by
      rw [Real.log_pow]
      push_cast
      linarith
    exact ((Real.log_lt_log_iff hx0 (by positivity)).mp h2).le
  have hsub : ZF x ⊆ ZF ((2 : ℝ) ^ (K + 1)) := by
    intro ρ hρ
    rw [mem_ZF] at hρ ⊢
    linarith
  have h1 : zinv x ≤ ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)),
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹ :=
    Finset.sum_le_sum_of_subset_of_nonneg hsub
      (fun ρ _ _ => mul_nonneg (order_nonneg ρ) (by positivity))
  have h2 := (sum_order_inv_le K).trans
    (mul_le_mul_of_nonneg_left (dyadic_count_le K) (by linarith))
  have hKL : (K : ℝ) * Real.log 2 ≤ Real.log x := by rwa [le_div_iff₀ hl2pos] at hKle
  have hK0 : (0 : ℝ) ≤ (K : ℝ) := Nat.cast_nonneg K
  have hK1 : (K : ℝ) ≤ 1.45 * Real.log x := by
    nlinarith [mul_le_mul_of_nonneg_left hl2.le hK0]
  have hK2 : (K : ℝ) + 2 ≤ 3.45 * Real.log x := by linarith
  have hK3 : ((K : ℝ) + 2) ^ 2 ≤ 13 * Real.log x ^ 2 := by nlinarith
  have h3 : Mlow * (3000 * ((K : ℝ) + 2) ^ 2) ≤ Mlow * (3000 * (13 * Real.log x ^ 2)) :=
    mul_le_mul_of_nonneg_left (by linarith) (by linarith)
  calc zinv x ≤ Mlow * (3000 * ((K : ℝ) + 2) ^ 2) := h1.trans h2
    _ ≤ Mlow * (3000 * (13 * Real.log x ^ 2)) := h3
    _ = Mlow * 39000 * Real.log x ^ 2 := by ring

/-- For `t ≥ 1` the zero sum below any height is at most `t` times `zinv` of that height. -/
theorem norm_zeroPartialSum_le {t : ℝ} (ht : 1 ≤ t) (T : ℝ) :
    ‖Stage3.zeroPartialSum t T‖ ≤ t * zinv T := by
  rw [zeroPartialSum_eq_sum]
  unfold zinv
  rw [Finset.mul_sum]
  refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun ρ _ => ?_)
  have ht0 : 0 < t := by linarith
  have hre1 : (ρ : ℂ).re ≤ 1 := ρ.2.1.2.le
  have hpow : t ^ (ρ : ℂ).re ≤ t := by
    calc t ^ (ρ : ℂ).re ≤ t ^ (1:ℝ) := Real.rpow_le_rpow_of_exponent_le ht hre1
      _ = t := Real.rpow_one t
  rw [norm_mul, norm_div, Complex.norm_intCast, abs_of_nonneg (order_nonneg ρ),
    Complex.norm_cpow_eq_rpow_re_of_pos ht0]
  have hm := order_nonneg ρ
  have hi : 0 ≤ ‖(ρ : ℂ)‖⁻¹ := by positivity
  calc ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (t ^ (ρ : ℂ).re / ‖(ρ : ℂ)‖)
      = (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹) * t ^ (ρ : ℂ).re := by ring
    _ ≤ (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹) * t :=
        mul_le_mul_of_nonneg_left hpow (mul_nonneg hm hi)
    _ = t * (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹) := by ring

/-- For `t ≥ 0`, Chebyshev's bound gives `|ψ t − t| ≤ 7·t`. -/
theorem norm_psi_sub_le {t : ℝ} (ht : 0 ≤ t) : ‖((ψ t : ℝ) : ℂ) - (t : ℂ)‖ ≤ 7 * t := by
  have e : ((ψ t : ℝ) : ℂ) - (t : ℂ) = ((ψ t - t : ℝ) : ℂ) := by push_cast; ring
  rw [e, Complex.norm_real, Real.norm_eq_abs, abs_le]
  have h1 := psi_le_const_mul_self ht
  have h2 := psi_nonneg t
  have hl4 : Real.log 4 < 2 := by
    rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
    push_cast
    linarith [Real.log_two_lt_d9]
  have h3 := mul_le_mul_of_nonneg_right hl4.le ht
  constructor <;> linarith

/-- **The remainder below the explicit formula's range.** For `t ≥ 1` the
remainder at any height `T` is at most `(7 + zinv T)·t`. -/
theorem norm_efRem_le_low {t : ℝ} (ht : 1 ≤ t) (T : ℝ) :
    ‖efRem T t‖ ≤ (7 + zinv T) * t := by
  unfold efRem
  have h1 := norm_psi_sub_le (t := t) (by linarith)
  have h2 := norm_zeroPartialSum_le ht T
  calc ‖((ψ t : ℝ) : ℂ) - (t : ℂ) + Stage3.zeroPartialSum t T‖
      ≤ ‖((ψ t : ℝ) : ℂ) - (t : ℂ)‖ + ‖Stage3.zeroPartialSum t T‖ := norm_add_le _ _
    _ ≤ 7 * t + t * zinv T := by linarith
    _ = (7 + zinv T) * t := by ring

/-- The constant of the remainder inside the explicit formula's range. -/
def Chigh : ℝ := 4 * Glue.c1n + Glue.c3n + Glue.c4n

/-- The constant `Chigh` is nonnegative. -/
theorem Chigh_nonneg : 0 ≤ Chigh := by
  have := Glue.c1n_nonneg
  have := Glue.c3n_nonneg
  have := Glue.c4n_nonneg
  unfold Chigh
  linarith

/-- **The remainder inside the explicit formula's range.** For `16 ≤ t ≤ x ≤ t²`
and `log x ≥ 1`, the remainder at height `x` is at most `Chigh·log²x`. -/
theorem norm_efRem_le_high {t x : ℝ} (h16 : 16 ≤ t) (hxt : x ≤ t ^ 2) (htx : t ≤ x)
    (hL : 1 ≤ Real.log x) : ‖efRem x t‖ ≤ Chigh * Real.log x ^ 2 := by
  have hc1 := Glue.c1n_nonneg
  have hc3 := Glue.c3n_nonneg
  have hc4 := Glue.c4n_nonneg
  have h := Glue.explicit_formula_split_num t x h16 (by linarith) hxt
  unfold efRem
  refine h.trans ?_
  have ht0 : 0 < t := by linarith
  have hx0 : 0 < x := by linarith
  have hlt0 : 0 ≤ Real.log t := Real.log_nonneg (by linarith)
  have hltL : Real.log t ≤ Real.log x := Real.log_le_log ht0 htx
  have hLtx : Real.log (t * x) = Real.log t + Real.log x := Real.log_mul ht0.ne' hx0.ne'
  have t1 : Glue.c1n * t * Real.log (t * x) ^ 2 / x ≤ 4 * Glue.c1n * Real.log x ^ 2 := by
    rw [div_le_iff₀ hx0]
    have hlog2 : Real.log (t * x) ^ 2 ≤ 4 * Real.log x ^ 2 := by
      rw [hLtx]
      nlinarith
    have h1 : Glue.c1n * t ≤ Glue.c1n * x := mul_le_mul_of_nonneg_left htx hc1
    have h2 := mul_le_mul h1 hlog2 (sq_nonneg _) (by positivity)
    calc Glue.c1n * t * Real.log (t * x) ^ 2 ≤ Glue.c1n * x * (4 * Real.log x ^ 2) := h2
      _ = 4 * Glue.c1n * Real.log x ^ 2 * x := by ring
  have t2 : Glue.c3n * Real.log t ≤ Glue.c3n * Real.log x ^ 2 :=
    mul_le_mul_of_nonneg_left (by nlinarith) hc3
  have hx4 : t ^ (-(1:ℝ) / 4) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos (by linarith)
    (by norm_num)
  have hx40 : 0 ≤ t ^ (-(1:ℝ) / 4) := Real.rpow_nonneg ht0.le _
  have hlx2 : Real.log t ^ 2 ≤ Real.log x ^ 2 := pow_le_pow_left₀ hlt0 hltL 2
  have t3 : Glue.c4n * (Real.log t ^ 2 * t ^ (-(1:ℝ) / 4)) ≤ Glue.c4n * Real.log x ^ 2 := by
    apply mul_le_mul_of_nonneg_left _ hc4
    calc Real.log t ^ 2 * t ^ (-(1:ℝ) / 4) ≤ Real.log x ^ 2 * 1 :=
          mul_le_mul hlx2 hx4 hx40 (sq_nonneg _)
      _ = Real.log x ^ 2 := by ring
  unfold Chigh
  linarith

/-- For `x ≥ 2` the remainder of the explicit formula at any height is integrable on `[2, x]`. -/
theorem integrable_efRem (T : ℝ) {x : ℝ} (hx : 2 ≤ x) :
    IntervalIntegrable (efRem T) volume 2 x := by
  have hψ := integrable_ofReal_of_monotone psi_mono x
  have hid : IntervalIntegrable (fun t : ℝ => (t : ℂ)) volume 2 x :=
    Complex.continuous_ofReal.intervalIntegrable 2 x
  have hZi : ∀ ρ ∈ ZF T, IntervalIntegrable
      (fun t : ℝ => ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)))
      volume 2 x := fun ρ _ => (integrable_cpow hx (ρ : ℂ)).const_mul _
  have hZ : IntervalIntegrable (fun t : ℝ => ∑ ρ ∈ ZF T,
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ))) volume 2 x := by
    have e : (fun t : ℝ => ∑ ρ ∈ ZF T,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)))
        = ∑ ρ ∈ ZF T, fun t : ℝ =>
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)) := by
      funext t
      rw [Finset.sum_apply]
    rw [e]
    exact IntervalIntegrable.sum (ZF T) hZi
  have h := (hψ.sub hid).add hZ
  refine h.congr ?_
  intro t _
  show ((ψ t : ℝ) : ℂ) - (t : ℂ) + _ = efRem T t
  unfold efRem
  rw [zeroPartialSum_eq_sum]

/-- The constant of the main bound. -/
def Arem : ℝ := 5 * Chigh + 21 + 3 * (Mlow * 39000)

/-- The constant `Arem` is nonnegative. -/
theorem Arem_nonneg : 0 ≤ Arem := by
  have := Chigh_nonneg
  have := two_le_Mlow
  unfold Arem
  nlinarith

/-- **The passage of the remainder is of square-root size, explicitly.** For
`x ≥ 256`, with the height equal to `x`, the passage of the explicit formula's
remainder is at most `Arem·√x·log²x`. -/
theorem norm_tr_efRem_le_of {x : ℝ} (hx : 256 ≤ x) :
    ‖tr (efRem x) x‖ ≤ Arem * Real.sqrt x * Real.log x ^ 2 := by
  have hx2 : (2 : ℝ) ≤ x := by linarith
  have hx0 : 0 < x := by linarith
  have hC := Chigh_nonneg
  have hM := two_le_Mlow
  have hl2 : (0.69 : ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hL1 : 1 ≤ Real.log x := by
    have h4 : Real.log 4 = 2 * Real.log 2 := by
      rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
      push_cast
      ring
    have := Real.log_le_log (by norm_num : (0:ℝ) < 4) (by linarith : (4:ℝ) ≤ x)
    linarith
  have hLpos : 0 < Real.log x := by linarith
  have hs16 : (16 : ℝ) ≤ Real.sqrt x := by
    have e : (16 : ℝ) = Real.sqrt 256 := by
      rw [show (256:ℝ) = 16 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]
    rw [e]
    exact Real.sqrt_le_sqrt hx
  have hspos : 0 < Real.sqrt x := by linarith
  have hss : Real.sqrt x * Real.sqrt x = x := Real.mul_self_sqrt hx0.le
  have hsx : Real.sqrt x ≤ x := by nlinarith
  have hs2 : (2 : ℝ) ≤ Real.sqrt x := by linarith
  have hlogs : Real.log (Real.sqrt x) = Real.log x / 2 := Real.log_sqrt hx0.le
  -- integrability and the split
  have hI := integrable_mul_wt hx2 (integrable_efRem x hx2)
  have hmem : Real.sqrt x ∈ Set.uIcc (2 : ℝ) x := Set.mem_uIcc.mpr (Or.inl ⟨hs2, hsx⟩)
  have hI1 := hI.mono_set (Set.uIcc_subset_uIcc Set.left_mem_uIcc hmem)
  have hI2 := hI.mono_set (Set.uIcc_subset_uIcc hmem Set.right_mem_uIcc)
  have hsplit := intervalIntegral.integral_add_adjacent_intervals hI1 hI2
  unfold tr
  rw [← hsplit]
  -- the endpoint
  have hend : ‖efRem x x / (Real.log x : ℂ)‖ ≤ Chigh * Real.log x := by
    rw [norm_div, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hLpos, div_le_iff₀ hLpos]
    have h := norm_efRem_le_high (t := x) (x := x) (by linarith) (by nlinarith) le_rfl hL1
    calc ‖efRem x x‖ ≤ Chigh * Real.log x ^ 2 := h
      _ = Chigh * Real.log x * Real.log x := by ring
  -- the low piece
  have hW0 := zinv_nonneg x
  have hlow : ‖∫ t in (2:ℝ)..Real.sqrt x, efRem x t * wt t‖
      ≤ 3 * (7 + zinv x) * Real.sqrt x := by
    have hc := intervalIntegral.norm_integral_le_of_norm_le_const (a := 2) (b := Real.sqrt x)
      (C := 3 * (7 + zinv x)) (f := fun t => efRem x t * wt t) (by
        intro t ht
        rw [Set.uIoc_of_le hs2] at ht
        have h2t : (2:ℝ) ≤ t := ht.1.le
        have ht0 : 0 < t := by linarith
        have hlt : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) h2t
        have hltpos : 0 < Real.log t := by linarith
        have hpos : 0 < t * Real.log t ^ 2 := by positivity
        have hE := norm_efRem_le_low (t := t) (by linarith) x
        have hwt : ‖wt t‖ = (t * Real.log t ^ 2)⁻¹ := by
          unfold wt
          rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hpos)]
        have hinv : (Real.log t ^ 2)⁻¹ ≤ 3 := by
          rw [inv_le_comm₀ (by positivity) (by norm_num)]
          nlinarith
        rw [norm_mul, hwt]
        calc ‖efRem x t‖ * (t * Real.log t ^ 2)⁻¹
            ≤ (7 + zinv x) * t * (t * Real.log t ^ 2)⁻¹ :=
              mul_le_mul_of_nonneg_right hE (inv_pos.mpr hpos).le
          _ = (7 + zinv x) * (Real.log t ^ 2)⁻¹ := by
              field_simp
          _ ≤ (7 + zinv x) * 3 := mul_le_mul_of_nonneg_left hinv (by linarith)
          _ = 3 * (7 + zinv x) := by ring)
    have habs : |Real.sqrt x - 2| ≤ Real.sqrt x := by
      rw [abs_of_nonneg (by linarith)]
      linarith
    calc _ ≤ 3 * (7 + zinv x) * |Real.sqrt x - 2| := hc
      _ ≤ 3 * (7 + zinv x) * Real.sqrt x :=
          mul_le_mul_of_nonneg_left habs (by linarith)
  -- the high piece
  have hhigh : ‖∫ t in Real.sqrt x..x, efRem x t * wt t‖ ≤ 4 * Chigh * Real.sqrt x := by
    have hc := intervalIntegral.norm_integral_le_of_norm_le_const (a := Real.sqrt x) (b := x)
      (C := 4 * Chigh / Real.sqrt x) (f := fun t => efRem x t * wt t) (by
        intro t ht
        rw [Set.uIoc_of_le hsx] at ht
        have hst : Real.sqrt x ≤ t := ht.1.le
        have ht0 : 0 < t := by linarith
        have hxt : x ≤ t ^ 2 := by nlinarith
        have hE := norm_efRem_le_high (t := t) (x := x) (by linarith) hxt ht.2 hL1
        have hlt : Real.log x / 2 ≤ Real.log t := by
          rw [← hlogs]
          exact Real.log_le_log hspos hst
        have hpos : 0 < t * Real.log t ^ 2 := by
          have : 0 < Real.log t := by linarith
          positivity
        have hwt : ‖wt t‖ = (t * Real.log t ^ 2)⁻¹ := by
          unfold wt
          rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hpos)]
        have hden : Real.sqrt x * (Real.log x / 2) ^ 2 ≤ t * Real.log t ^ 2 :=
          mul_le_mul hst (pow_le_pow_left₀ (by linarith) hlt 2) (sq_nonneg _) ht0.le
        have hinv : (t * Real.log t ^ 2)⁻¹ ≤ (Real.sqrt x * (Real.log x / 2) ^ 2)⁻¹ :=
          inv_anti₀ (by positivity) hden
        rw [norm_mul, hwt]
        calc ‖efRem x t‖ * (t * Real.log t ^ 2)⁻¹
            ≤ (Chigh * Real.log x ^ 2) * (Real.sqrt x * (Real.log x / 2) ^ 2)⁻¹ :=
              mul_le_mul hE hinv (inv_pos.mpr hpos).le (by positivity)
          _ = 4 * Chigh / Real.sqrt x := by
              field_simp
              ring)
    have habs : |x - Real.sqrt x| ≤ x := by
      rw [abs_of_nonneg (by linarith)]
      linarith
    have e : 4 * Chigh / Real.sqrt x * x = 4 * Chigh * Real.sqrt x := by
      rw [div_mul_eq_mul_div, div_eq_iff hspos.ne']
      linear_combination (-4 * Chigh) * hss
    calc _ ≤ 4 * Chigh / Real.sqrt x * |x - Real.sqrt x| := hc
      _ ≤ 4 * Chigh / Real.sqrt x * x :=
          mul_le_mul_of_nonneg_left habs (by positivity)
      _ = 4 * Chigh * Real.sqrt x := e
  -- adding up
  have hW := zinv_le_log (x := x) (by linarith)
  have hLL : 1 ≤ Real.log x ^ 2 := by nlinarith
  have hA : Real.log x ≤ Real.sqrt x * Real.log x ^ 2 := by nlinarith
  have hB : Real.sqrt x ≤ Real.sqrt x * Real.log x ^ 2 := le_mul_of_one_le_right hspos.le hLL
  have t1 : Chigh * Real.log x ≤ Chigh * (Real.sqrt x * Real.log x ^ 2) :=
    mul_le_mul_of_nonneg_left hA hC
  have t2 : Chigh * Real.sqrt x ≤ Chigh * (Real.sqrt x * Real.log x ^ 2) :=
    mul_le_mul_of_nonneg_left hB hC
  have t3 : zinv x * Real.sqrt x ≤ Mlow * 39000 * Real.log x ^ 2 * Real.sqrt x :=
    mul_le_mul_of_nonneg_right hW hspos.le
  have hn := norm_add_le (efRem x x / (Real.log x : ℂ))
    ((∫ t in (2:ℝ)..Real.sqrt x, efRem x t * wt t) + ∫ t in Real.sqrt x..x, efRem x t * wt t)
  have hn2 := norm_add_le (∫ t in (2:ℝ)..Real.sqrt x, efRem x t * wt t)
    (∫ t in Real.sqrt x..x, efRem x t * wt t)
  have e : Arem * Real.sqrt x * Real.log x ^ 2
      = 5 * (Chigh * (Real.sqrt x * Real.log x ^ 2)) + 21 * (Real.sqrt x * Real.log x ^ 2)
        + 3 * (Mlow * 39000 * Real.log x ^ 2 * Real.sqrt x) := by
    unfold Arem
    ring
  have e2 : 3 * (7 + zinv x) * Real.sqrt x = 21 * Real.sqrt x + 3 * (zinv x * Real.sqrt x) := by
    ring
  have e3 : 4 * Chigh * Real.sqrt x = 4 * (Chigh * Real.sqrt x) := by ring
  rw [e]
  linarith

/-- **The passage of the explicit formula's remainder is of square-root size.**
There are constants `A ≥ 0` and `x₀` such that for every `x ≥ x₀`, with the height
equal to `x`, the passage of the remainder is at most `A·√x·log²x`. No hypothesis
on the zeros of ζ is made. -/
theorem norm_tr_efRem_le :
    ∃ A x₀ : ℝ, 0 ≤ A ∧ ∀ x : ℝ, x₀ ≤ x →
      ‖PiZeros.tr (PiZeros.efRem x) x‖ ≤ A * Real.sqrt x * Real.log x ^ 2 :=
  ⟨Arem, 256, Arem_nonneg, fun _ hx => norm_tr_efRem_le_of hx⟩

/-- info: 'PiRemainder.zinv_le_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zinv_le_log

/-- info: 'PiRemainder.norm_tr_efRem_le_of' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_tr_efRem_le_of

/-- info: 'PiRemainder.norm_tr_efRem_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_tr_efRem_le

end

end PiRemainder
