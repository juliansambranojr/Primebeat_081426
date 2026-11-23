/-
FixedRowTwo — block G3 of `lean_stage3/design/floor.md`. 2026-11-23.

The fixed-row theorems of `CellFixedRow` and `PiFixedRow` restated on
`ExplicitTwo.explicit_formula_all_two`, the explicit formula at every height
from `x = 2`. The originals read `LeftSmooth.explicit_formula_all` and carry
its floor (`r ≥ d + 4`, `r ≥ d + 6`, `x ≥ 16`). Here every row the cell's
identity reads is at least `2`, so the theorems hold at every row where the
identity holds. For the count the whole integral `∫₂ˣ` is read from the
formula; there is no stretch below the floor, so `PiFixedRow.norm_low_integral_le`
is not used.

  c1t_nonneg, c3t_nonneg, Bleft2_nonneg   the constants of the formula are ≥ 0
  cell_eq_zero_sum_two       2 ≤ 2^(r−d), 2 ≤ T ⊢ the cell, its main term and the
                               zeros below T differ by ≤ Σ_j C(d,j)·E_two(2^(r−j), T)
  cell_zero_sum_finset_two   the same over the finite set `ZF T`
  cell_fixed_row_two         d + 1 ≤ r ⊢ for every ε > 0, eventually in T, the
                               difference is ≤ 2^d·(c3t·log 2·r + Bleft2) + ε
  Api2                       (3/2)·c3t + (9/4)·Bleft2
  norm_integrand_two_le      on [2, x]: ‖efRem T t·wt t‖ ≤ (9/4)·c1t·log²(xT)/T + Api2/t
  norm_integral_two_le       ‖∫₂ˣ efRem T t·wt t‖ ≤ (x−2)·(9/4)·c1t·log²(xT)/T + Api2·log(x/2)
  norm_tr_efRem_le_height_two  2 ≤ x, 2 ≤ T ⊢ ‖tr (efRem T) x‖
                               ≤ Api2·(1 + log x) + 4·c1t·x·log²(xT)/T
  tr_efRem_fixed_two         2 ≤ x ⊢ eventually in T, ‖tr (efRem T) x‖ ≤ Api2·(1 + log x) + ε
  pi_fixed_row_two           the count, the same
  table_cell_fixed_row_two   d + 2 ≤ r ⊢ the integer table's cell, under the stencil,
                               ≤ 2^(d+1)·(Api2·(1 + log 2·r)) + ε

`E_two(x, T)` is the right side of `ExplicitTwo.explicit_formula_all_two`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ExplicitTwo
import Stage3.PiFixedRow

namespace FixedRowTwo

open Chebyshev MeasureTheory Kadiri FiniteOffLine Finset PiZeros PiRemainder Filter Topology
open scoped Chebyshev

noncomputable section

/-- The first constant of the formula from `x = 2` is nonnegative. -/
theorem c1t_nonneg : 0 ≤ ExplicitTwo.c1t := by
  have h1 := ExplicitTwo.Cht_pos
  have h2 := Glue.Csn_pos
  unfold ExplicitTwo.c1t
  linarith

/-- The logarithmic constant of the formula from `x = 2` is nonnegative. -/
theorem c3t_nonneg : 0 ≤ ExplicitTwo.c3t := by
  have hl := Real.log_pos (by norm_num : (1:ℝ) < 2)
  have h := div_nonneg (norm_nonneg (deriv riemannZeta 0 / riemannZeta 0)) hl.le
  unfold ExplicitTwo.c3t
  linarith

/-- The left-edge constant from `x = 2` is nonnegative: it is four times `Bleft`. -/
theorem Bleft2_nonneg : 0 ≤ ExplicitTwo.Bleft2 := by
  have h := CellFixedRow.Bleft_nonneg
  unfold ExplicitTwo.Bleft2
  linarith

/-- **The cell as a sum over the zeros, at every height, from row value `2`.** For
`2 ≤ 2^(r−d)` and any `T ≥ 2`, the cell at row `r`, depth `d`, minus its main term,
plus the sum over the zeros below `T`, has norm at most the stencil of the error of
the explicit formula from `x = 2`, read on the `d + 1` rows the stencil touches. -/
theorem cell_eq_zero_sum_two (d : ℕ) (r : ℤ) {T : ℝ} (h2 : 2 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d
        + ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
            ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                  * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                  / ((ρ : Kadiri.NontrivialZeros) : ℂ))‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (ExplicitTwo.c1t * (2:ℝ) ^ (r - (j : ℤ))
              * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + ExplicitTwo.c3t * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + ExplicitTwo.Bleft2 * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4)) := by
  have hmain : CellZeros.stencil d (fun n : ℤ => (((2:ℝ) ^ n : ℝ) : ℂ)) r
      = (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d := by
    have hfun : (fun n : ℤ => (((2:ℝ) ^ n : ℝ) : ℂ)) = fun n : ℤ => (2:ℂ) ^ n := by
      funext n
      push_cast
      rfl
    rw [hfun, CellZeros.stencil_mode (by norm_num)]
  have hkey : CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d
        + ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
            ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                  * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                  / ((ρ : Kadiri.NontrivialZeros) : ℂ))
      = CellZeros.stencil d (fun n : ℤ => ((Chebyshev.psi ((2:ℝ) ^ n) : ℂ)
          - (((2:ℝ) ^ n : ℝ) : ℂ)) + Stage3.zeroPartialSum ((2:ℝ) ^ n) T) r := by
    rw [CellZeros.stencil_add, CellZeros.stencil_sub, hmain, CellZeros.stencil_zeroPartialSum]
  rw [hkey]
  refine CellZeros.norm_stencil_le d _ r _ (fun j hj => ?_)
  have hjd : (j : ℤ) ≤ (d : ℤ) := by
    exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  have hmono : (2:ℝ) ^ (r - (d : ℤ)) ≤ (2:ℝ) ^ (r - (j : ℤ)) :=
    zpow_le_zpow_right₀ (by norm_num) (by linarith)
  have hx2 : (2:ℝ) ≤ (2:ℝ) ^ (r - (j : ℤ)) := le_trans h2 hmono
  exact ExplicitTwo.explicit_formula_all_two hx2 hT

/-- info: 'FixedRowTwo.cell_eq_zero_sum_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_eq_zero_sum_two

/-- **The same, over the finite set of zeros below the height.** -/
theorem cell_zero_sum_finset_two (d : ℕ) (r : ℤ) {T : ℝ} (h2 : 2 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF T, term d r ρ‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (ExplicitTwo.c1t * (2:ℝ) ^ (r - (j : ℤ))
              * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + ExplicitTwo.c3t * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + ExplicitTwo.Bleft2 * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4)) := by
  rw [← tsum_sub_eq_sum T (term d r)]
  exact cell_eq_zero_sum_two d r h2 hT

/-- **The cell at a fixed row, the height to infinity, from row `d + 1`.** For
`d + 1 ≤ r` and every `ε > 0`, for all large heights `T` the cell at row `r`,
depth `d`, minus its main term, plus its sum over the zeros below `T`, has norm at
most `2^d·(c3t·log 2·r + Bleft2) + ε`. The bound left is free of the height. -/
theorem cell_fixed_row_two (d : ℕ) (r : ℕ) (hr : d + 1 ≤ r) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
          - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
          + ∑ ρ ∈ FiniteOffLine.ZF T, FiniteOffLine.term d (r : ℤ) ρ‖
        ≤ 2 ^ d * (ExplicitTwo.c3t * Real.log 2 * r + ExplicitTwo.Bleft2) + ε := by
  intro ε hε
  have h2 : (2:ℝ) ≤ (2:ℝ) ^ ((r : ℤ) - (d : ℤ)) := by
    have e : ((r : ℤ) - (d : ℤ)) = ((r - d : ℕ) : ℤ) := by omega
    rw [e, zpow_natCast]
    calc (2:ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ (r - d) := pow_le_pow_right₀ (by norm_num) (by omega)
  -- the height-dependent part tends to zero
  have hlim : Tendsto (fun T : ℝ => ∑ j ∈ range (d + 1), (d.choose j : ℝ)
      * (ExplicitTwo.c1t * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
          * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * T) ^ 2 / T)) atTop (𝓝 0) := by
    have := tendsto_finsetSum (range (d + 1)) (fun j _ =>
      ((CellFixedRow.tendsto_log_sq_div ExplicitTwo.c1t ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
        (zpow_pos (by norm_num) _)).const_mul (d.choose j : ℝ)))
    simpa using this
  have hev := (hlim.eventually (gt_mem_nhds hε))
  filter_upwards [hev, eventually_ge_atTop (2:ℝ)] with T hTε hT2
  refine (cell_zero_sum_finset_two d (r : ℤ) h2 hT2).trans ?_
  have hc3 := c3t_nonneg
  have hB := Bleft2_nonneg
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  -- the height-free part
  have hrest : ∀ j ∈ range (d + 1),
      ExplicitTwo.c3t * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
        + ExplicitTwo.Bleft2 * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4)
      ≤ ExplicitTwo.c3t * Real.log 2 * r + ExplicitTwo.Bleft2 := by
    intro j _
    have hlog : Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ≤ Real.log 2 * r := by
      rw [Real.log_zpow]
      push_cast
      nlinarith [(Nat.cast_nonneg j : (0:ℝ) ≤ j)]
    have hx1 : (1:ℝ) ≤ (2:ℝ) ^ ((r : ℤ) - (j : ℤ)) := by
      have : (2:ℝ) ^ ((r : ℤ) - (d : ℤ)) ≤ (2:ℝ) ^ ((r : ℤ) - (j : ℤ)) := by
        apply zpow_le_zpow_right₀ (by norm_num)
        have : (j : ℤ) ≤ d := by
          exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp ‹_›)
        linarith
      linarith
    have hp : ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos hx1 (by norm_num)
    have h1 : ExplicitTwo.c3t * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
        ≤ ExplicitTwo.c3t * Real.log 2 * r := by
      rw [mul_assoc]; exact mul_le_mul_of_nonneg_left hlog hc3
    have h2' : ExplicitTwo.Bleft2 * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4)
        ≤ ExplicitTwo.Bleft2 := by
      calc _ ≤ ExplicitTwo.Bleft2 * 1 := mul_le_mul_of_nonneg_left hp hB
        _ = _ := mul_one _
    linarith
  have hsplit : ∑ j ∈ range (d + 1), (d.choose j : ℝ)
        * (ExplicitTwo.c1t * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
            * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * T) ^ 2 / T
          + ExplicitTwo.c3t * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
          + ExplicitTwo.Bleft2 * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4))
      = ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (ExplicitTwo.c1t * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
              * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * T) ^ 2 / T)
        + ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (ExplicitTwo.c3t * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
            + ExplicitTwo.Bleft2 * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4)) := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun j _ => by ring
  have hsum2 : ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (ExplicitTwo.c3t * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
            + ExplicitTwo.Bleft2 * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4))
      ≤ 2 ^ d * (ExplicitTwo.c3t * Real.log 2 * r + ExplicitTwo.Bleft2) := by
    calc _ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
            * (ExplicitTwo.c3t * Real.log 2 * r + ExplicitTwo.Bleft2) :=
          Finset.sum_le_sum fun j hj =>
            mul_le_mul_of_nonneg_left (hrest j hj) (Nat.cast_nonneg _)
      _ = (∑ j ∈ range (d + 1), (d.choose j : ℝ))
            * (ExplicitTwo.c3t * Real.log 2 * r + ExplicitTwo.Bleft2) := by rw [Finset.sum_mul]
      _ = 2 ^ d * (ExplicitTwo.c3t * Real.log 2 * r + ExplicitTwo.Bleft2) := by
          congr 1
          exact_mod_cast Nat.sum_range_choose d
  rw [hsplit]
  linarith

/-- info: 'FixedRowTwo.cell_fixed_row_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_fixed_row_two

/-- The constant of the count at a fixed row from `x = 2`: `(3/2)·c3t + (9/4)·Bleft2`.
The factors are `1/log t ≤ 3/2` and `1/log²t ≤ 9/4` on `t ≥ 2`. -/
def Api2 : ℝ := 3 / 2 * ExplicitTwo.c3t + 9 / 4 * ExplicitTwo.Bleft2

/-- The constant `Api2` is nonnegative. -/
theorem Api2_nonneg : 0 ≤ Api2 := by
  have := c3t_nonneg
  have := Bleft2_nonneg
  unfold Api2
  linarith

/-- **The integrand on `[2, x]`.** For `2 ≤ t ≤ x` and `T ≥ 2`, the remainder of the
explicit formula times the weight has norm at most `(9/4)·c1t·log²(xT)/T + Api2/t`. -/
theorem norm_integrand_two_le {x T t : ℝ} (hT : 2 ≤ T) (ht : 2 ≤ t) (htx : t ≤ x) :
    ‖efRem T t * wt t‖
      ≤ 9 / 4 * ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T + Api2 * t⁻¹ := by
  have hc1 := c1t_nonneg
  have hc3 := c3t_nonneg
  have hB := Bleft2_nonneg
  have hT0 : 0 < T := by linarith
  have ht0 : 0 < t := by linarith
  have hlt : 0 < Real.log t := Real.log_pos (by linarith)
  have htne : t ≠ 0 := ht0.ne'
  have hlne : Real.log t ≠ 0 := hlt.ne'
  have hi1 : (Real.log t)⁻¹ ≤ 3 / 2 := by
    have h := PerronTwo.inv_log_le_of_two_le ht
    rwa [one_div] at h
  have hi2 : (Real.log t ^ 2)⁻¹ ≤ 9 / 4 := by
    rw [← inv_pow]
    calc ((Real.log t)⁻¹) ^ 2 ≤ (3 / 2) ^ 2 := pow_le_pow_left₀ (by positivity) hi1 2
      _ = 9 / 4 := by norm_num
  have hpos : 0 < t * Real.log t ^ 2 := by positivity
  have hwt : ‖wt t‖ = (t * Real.log t ^ 2)⁻¹ := by
    unfold wt
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hpos)]
  have hE : ‖efRem T t‖ ≤ ExplicitTwo.c1t * t * Real.log (t * T) ^ 2 / T
      + ExplicitTwo.c3t * Real.log t + ExplicitTwo.Bleft2 * t ^ (-(1:ℝ)/4) :=
    ExplicitTwo.explicit_formula_all_two ht hT
  have hLt0 : 0 ≤ Real.log (t * T) := Real.log_nonneg (by nlinarith)
  have hLt : Real.log (t * T) ^ 2 ≤ Real.log (x * T) ^ 2 :=
    pow_le_pow_left₀ hLt0 (Real.log_le_log (by positivity)
      (mul_le_mul_of_nonneg_right htx hT0.le)) 2
  have hp : t ^ (-(1:ℝ)/4) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos (by linarith)
    (by norm_num)
  have hp0 : 0 ≤ t ^ (-(1:ℝ)/4) := Real.rpow_nonneg ht0.le _
  have e1 : t * (t * Real.log t ^ 2)⁻¹ = (Real.log t ^ 2)⁻¹ := by
    rw [mul_inv, ← mul_assoc, mul_inv_cancel₀ htne, one_mul]
  have e2 : Real.log t * (t * Real.log t ^ 2)⁻¹ = t⁻¹ * (Real.log t)⁻¹ := by
    field_simp
    try ring
  have hA : ExplicitTwo.c1t * t * Real.log (t * T) ^ 2 / T * (t * Real.log t ^ 2)⁻¹
      ≤ 9 / 4 * ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T := by
    calc ExplicitTwo.c1t * t * Real.log (t * T) ^ 2 / T * (t * Real.log t ^ 2)⁻¹
        = (ExplicitTwo.c1t * Real.log (t * T) ^ 2 / T) * (t * (t * Real.log t ^ 2)⁻¹) := by
          ring
      _ = (ExplicitTwo.c1t * Real.log (t * T) ^ 2 / T) * (Real.log t ^ 2)⁻¹ := by rw [e1]
      _ ≤ (ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T) * (9 / 4) :=
          mul_le_mul (div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hLt hc1) hT0.le)
            hi2 (by positivity) (by positivity)
      _ = _ := by ring
  have hBt : ExplicitTwo.c3t * Real.log t * (t * Real.log t ^ 2)⁻¹
      ≤ 3 / 2 * ExplicitTwo.c3t * t⁻¹ := by
    calc ExplicitTwo.c3t * Real.log t * (t * Real.log t ^ 2)⁻¹
        = ExplicitTwo.c3t * (Real.log t * (t * Real.log t ^ 2)⁻¹) := by ring
      _ = ExplicitTwo.c3t * (t⁻¹ * (Real.log t)⁻¹) := by rw [e2]
      _ ≤ ExplicitTwo.c3t * (t⁻¹ * (3 / 2)) :=
          mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hi1 (by positivity)) hc3
      _ = _ := by ring
  have hCt : ExplicitTwo.Bleft2 * t ^ (-(1:ℝ)/4) * (t * Real.log t ^ 2)⁻¹
      ≤ 9 / 4 * ExplicitTwo.Bleft2 * t⁻¹ := by
    calc ExplicitTwo.Bleft2 * t ^ (-(1:ℝ)/4) * (t * Real.log t ^ 2)⁻¹
        = ExplicitTwo.Bleft2 * (t ^ (-(1:ℝ)/4) * (t⁻¹ * (Real.log t ^ 2)⁻¹)) := by
          rw [mul_inv]
          ring
      _ ≤ ExplicitTwo.Bleft2 * (1 * (t⁻¹ * (9 / 4))) :=
          mul_le_mul_of_nonneg_left (mul_le_mul hp
            (mul_le_mul_of_nonneg_left hi2 (by positivity)) (by positivity) (by norm_num)) hB
      _ = _ := by ring
  rw [norm_mul, hwt]
  calc ‖efRem T t‖ * (t * Real.log t ^ 2)⁻¹
      ≤ (ExplicitTwo.c1t * t * Real.log (t * T) ^ 2 / T
          + ExplicitTwo.c3t * Real.log t + ExplicitTwo.Bleft2 * t ^ (-(1:ℝ)/4))
          * (t * Real.log t ^ 2)⁻¹ :=
        mul_le_mul_of_nonneg_right hE (inv_pos.mpr hpos).le
    _ = ExplicitTwo.c1t * t * Real.log (t * T) ^ 2 / T * (t * Real.log t ^ 2)⁻¹
          + ExplicitTwo.c3t * Real.log t * (t * Real.log t ^ 2)⁻¹
          + ExplicitTwo.Bleft2 * t ^ (-(1:ℝ)/4) * (t * Real.log t ^ 2)⁻¹ := by ring
    _ ≤ 9 / 4 * ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T
          + 3 / 2 * ExplicitTwo.c3t * t⁻¹ + 9 / 4 * ExplicitTwo.Bleft2 * t⁻¹ := by
        linarith
    _ = _ := by unfold Api2; ring

/-- **The whole integral from `x = 2`.** For `2 ≤ x` and `T ≥ 2`, the integral of the
remainder against the weight over `[2, x]` is at most
`(x − 2)·(9/4)·c1t·log²(xT)/T + Api2·log(x/2)`. -/
theorem norm_integral_two_le {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖∫ t in (2:ℝ)..x, efRem T t * wt t‖
      ≤ (x - 2) * (9 / 4 * ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T)
        + Api2 * Real.log (x / 2) := by
  have hx0 : 0 < x := by linarith
  have hginv : IntervalIntegrable (fun t : ℝ => t⁻¹) volume 2 x :=
    intervalIntegral.intervalIntegrable_inv (fun t ht => by
      rw [Set.uIcc_of_le hx] at ht
      linarith [ht.1]) continuousOn_id
  have hg : IntervalIntegrable (fun t : ℝ => 9 / 4 * ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T
      + Api2 * t⁻¹) volume 2 x :=
    intervalIntegrable_const.add (hginv.const_mul _)
  have h := intervalIntegral.norm_integral_le_of_norm_le hx (f := fun t => efRem T t * wt t)
    (g := fun t : ℝ => 9 / 4 * ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T + Api2 * t⁻¹) (by
      filter_upwards with t ht
      exact norm_integrand_two_le hT ht.1.le ht.2) hg
  refine h.trans (le_of_eq ?_)
  rw [intervalIntegral.integral_add intervalIntegrable_const (hginv.const_mul _),
    intervalIntegral.integral_const, intervalIntegral.integral_const_mul,
    integral_inv_of_pos (by norm_num) hx0, smul_eq_mul]

/-- **The passage of the remainder at a fixed row and a finite height, from `x = 2`.**
For `2 ≤ x` and `T ≥ 2`, `‖tr (efRem T) x‖ ≤ Api2·(1 + log x) + 4·c1t·x·log²(xT)/T`. -/
theorem norm_tr_efRem_le_height_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖tr (efRem T) x‖
      ≤ Api2 * (1 + Real.log x) + 4 * ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T := by
  have hc1 := c1t_nonneg
  have hc3 := c3t_nonneg
  have hB := Bleft2_nonneg
  have hA := Api2_nonneg
  have hT0 : 0 < T := by linarith
  have hx0 : 0 < x := by linarith
  have hLpos : 0 < Real.log x := Real.log_pos (by linarith)
  have hi1 : (Real.log x)⁻¹ ≤ 3 / 2 := by
    have h := PerronTwo.inv_log_le_of_two_le hx
    rwa [one_div] at h
  have hi0 : 0 ≤ (Real.log x)⁻¹ := (inv_pos.mpr hLpos).le
  unfold tr
  -- the value
  have hE : ‖efRem T x‖ ≤ ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T
      + ExplicitTwo.c3t * Real.log x + ExplicitTwo.Bleft2 * x ^ (-(1:ℝ)/4) :=
    ExplicitTwo.explicit_formula_all_two hx hT
  have hp : x ^ (-(1:ℝ)/4) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos (by linarith)
    (by norm_num)
  have hp0 : 0 ≤ x ^ (-(1:ℝ)/4) := Real.rpow_nonneg hx0.le _
  have hq : 0 ≤ ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T := by positivity
  have hq' : 0 ≤ ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T := by positivity
  have hval : ‖efRem T x / (Real.log x : ℂ)‖
      ≤ 3 / 2 * (ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T)
        + ExplicitTwo.c3t + 3 / 2 * ExplicitTwo.Bleft2 := by
    rw [norm_div, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hLpos, div_eq_mul_inv]
    have h1 : (ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T) * (Real.log x)⁻¹
        ≤ (ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T) * (3 / 2) :=
      mul_le_mul_of_nonneg_left hi1 hq
    have h2 : ExplicitTwo.c3t * Real.log x * (Real.log x)⁻¹ = ExplicitTwo.c3t := by
      rw [mul_assoc, mul_inv_cancel₀ hLpos.ne', mul_one]
    have h3 : ExplicitTwo.Bleft2 * x ^ (-(1:ℝ)/4) * (Real.log x)⁻¹
        ≤ ExplicitTwo.Bleft2 * (1 * (3 / 2)) := by
      rw [mul_assoc]
      exact mul_le_mul_of_nonneg_left (mul_le_mul hp hi1 hi0 (by norm_num)) hB
    have e : (ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T
        + ExplicitTwo.c3t * Real.log x + ExplicitTwo.Bleft2 * x ^ (-(1:ℝ)/4)) * (Real.log x)⁻¹
        = (ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T) * (Real.log x)⁻¹
          + ExplicitTwo.c3t * Real.log x * (Real.log x)⁻¹
          + ExplicitTwo.Bleft2 * x ^ (-(1:ℝ)/4) * (Real.log x)⁻¹ := by ring
    have hm := mul_le_mul_of_nonneg_right hE hi0
    rw [e] at hm
    linarith
  -- the integral
  have hint := norm_integral_two_le hx hT
  have hlog2 : Real.log (x / 2) ≤ Real.log x := by
    rw [Real.log_div hx0.ne' (by norm_num)]
    have : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
    linarith
  have hAl : Api2 * Real.log (x / 2) ≤ Api2 * Real.log x :=
    mul_le_mul_of_nonneg_left hlog2 hA
  have ex : (x - 2) * (9 / 4 * ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T)
      = 9 / 4 * (ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T)
        - 9 / 2 * (ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T) := by ring
  have hn := norm_add_le (efRem T x / (Real.log x : ℂ)) (∫ t in (2:ℝ)..x, efRem T t * wt t)
  have e4 : 4 * ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T
      = 4 * (ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T) := by ring
  have eA : Api2 * (1 + Real.log x) = Api2 + Api2 * Real.log x := by ring
  have hA' : ExplicitTwo.c3t + 3 / 2 * ExplicitTwo.Bleft2 ≤ Api2 := by
    unfold Api2
    linarith
  rw [e4, eA]
  linarith

/-- **The passage of the remainder at a fixed row, the height to infinity, from
`x = 2`.** For `2 ≤ x` and every `ε > 0`, for all large heights `T`,
`‖tr (efRem T) x‖ ≤ Api2·(1 + log x) + ε`. -/
theorem tr_efRem_fixed_two {x : ℝ} (hx : 2 ≤ x) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖PiZeros.tr (PiZeros.efRem T) x‖ ≤ Api2 * (1 + Real.log x) + ε := by
  intro ε hε
  have hx0 : 0 < x := by linarith
  have hlim := CellFixedRow.tendsto_log_sq_div (4 * ExplicitTwo.c1t) x hx0
  have hev := hlim.eventually (gt_mem_nhds hε)
  filter_upwards [hev, eventually_ge_atTop (2:ℝ)] with T hTε hT2
  have h := norm_tr_efRem_le_height_two hx hT2
  linarith

/-- info: 'FixedRowTwo.tr_efRem_fixed_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tr_efRem_fixed_two

/-- **The count at a fixed row, the height to infinity, from `x = 2`.** For `2 ≤ x`
and every `ε > 0`, for all large heights `T`, the count minus `Li`, plus each zero's
part below `T`, plus the higher prime powers, is at most `Api2·(1 + log x) + ε`. -/
theorem pi_fixed_row_two {x : ℝ} (hx : 2 ≤ x) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
          + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
          + tr psiTheta x‖ ≤ Api2 * (1 + Real.log x) + ε := by
  intro ε hε
  filter_upwards [tr_efRem_fixed_two hx ε hε] with T hT
  rw [pi_eq_zero_sum hx T]
  have e : ∀ A B C : ℂ, -A + B - C + A + C = B := fun A B C => by ring
  rw [e]
  exact hT

/-- info: 'FixedRowTwo.pi_fixed_row_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pi_fixed_row_two

/-- **The integer table's cell at a fixed row, the height to infinity, from row
`d + 2`.** For `d + 2 ≤ r` and every `ε > 0`, for all large heights `T`, the cell
`(r, d)` of the table of the prime count along the doublings, less the smooth cell,
plus each zero's part below `T` under the stencil, plus the stencil of the higher
prime powers, is at most `2^(d+1)·(Api2·(1 + log 2·r)) + ε`. -/
theorem table_cell_fixed_row_two (r : ℕ) (d : ℕ) (hr : d + 2 ≤ r) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖((((Construction.tableFrom TableRoute.rowN (r : ℤ) d : ℤ) : ℝ)
          - Nonvanishing.stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) (r : ℤ)
            : ℝ) : ℂ)
        + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
            * CellZeros.stencil (d + 1) (fun m : ℤ => piMode (ρ : ℂ) ((2:ℝ) ^ (m : ℝ))) (r : ℤ)
        + CellZeros.stencil (d + 1) (fun m : ℤ => tr psiTheta ((2:ℝ) ^ (m : ℝ))) (r : ℤ)‖
        ≤ 2 ^ (d + 1) * (Api2 * (1 + Real.log 2 * r)) + ε := by
  intro ε hε
  have hA := Api2_nonneg
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have h2d : (0:ℝ) < 2 ^ (d + 1) := by positivity
  have hε' : 0 < ε / 2 ^ (d + 1) := div_pos hε h2d
  have hrow : ∀ j ∈ range (d + 1 + 1),
      (2:ℝ) ≤ (2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ) := by
    intro j hj
    have hj' : j ≤ d + 1 := Nat.lt_succ_iff.mp (mem_range.mp hj)
    have h1 : (1:ℝ) ≤ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ) := by
      have : (1:ℤ) ≤ (r : ℤ) - (j : ℤ) := by omega
      exact_mod_cast this
    calc (2:ℝ) = (2:ℝ) ^ (1:ℝ) := (Real.rpow_one 2).symm
      _ ≤ _ := Real.rpow_le_rpow_of_exponent_le (by norm_num) h1
  have hev : ∀ j ∈ range (d + 1 + 1), ∀ᶠ T : ℝ in Filter.atTop,
      ‖tr (efRem T) ((2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ))‖
        ≤ Api2 * (1 + Real.log ((2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ)))
          + ε / 2 ^ (d + 1) :=
    fun j hj => tr_efRem_fixed_two (hrow j hj) _ hε'
  filter_upwards [(Filter.eventually_all_finset _).mpr hev] with T hT
  rw [table_cell_eq_zero_sum (r : ℤ) d (by omega) T]
  have e : ∀ A B C : ℂ, -A + B - C + A + C = B := fun A B C => by ring
  rw [e]
  refine (CellZeros.norm_stencil_le (d + 1) _ (r : ℤ)
    (fun _ => Api2 * (1 + Real.log 2 * r) + ε / 2 ^ (d + 1)) (fun j hj => ?_)).trans ?_
  · refine (hT j hj).trans ?_
    have hlog : Real.log ((2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ)) ≤ Real.log 2 * r := by
      rw [Real.log_rpow (by norm_num)]
      push_cast
      nlinarith [(Nat.cast_nonneg j : (0:ℝ) ≤ j)]
    have : Api2 * (1 + Real.log ((2:ℝ) ^ ((((r : ℤ) - (j : ℤ) : ℤ)) : ℝ)))
        ≤ Api2 * (1 + Real.log 2 * r) :=
      mul_le_mul_of_nonneg_left (by linarith) hA
    linarith
  · rw [← Finset.sum_mul]
    have hs : ∑ j ∈ range (d + 1 + 1), ((d + 1).choose j : ℝ) = 2 ^ (d + 1) := by
      exact_mod_cast Nat.sum_range_choose (d + 1)
    rw [hs, mul_add, mul_div_cancel₀ _ h2d.ne']

/-- info: 'FixedRowTwo.table_cell_fixed_row_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms table_cell_fixed_row_two

end

end FixedRowTwo
