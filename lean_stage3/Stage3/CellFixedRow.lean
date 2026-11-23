/-
CellFixedRow — block F3 of `lean_stage3/design/leftedge.md`. 2026-11-23.

The cell at a fixed row with the height of the zero sum taken to infinity.
`LeftSmooth.explicit_formula_all` holds at every height `T ≥ 2`, with no cap
`T ≤ x²`. Through the stencil, the cell at row `r`, depth `d`, and its zero sum
to any height differ by the stencil of that bound. As `T → ∞` at the fixed row
the first term of the bound tends to zero, and what stays is free of the height.

  cell_eq_zero_sum_all       16 ≤ 2^(r−d), 2 ≤ T ⊢ the cell, its main term and the
                               zeros below T differ by ≤ Σ_j C(d,j)·E_all(2^(r−j), T)
  cell_zero_sum_finset_all   the same over the finite set `ZF T`
  cell_fixed_row             d + 4 ≤ r ⊢ for every ε > 0, eventually in T, the
                               difference is ≤ 2^d·(c3n·log 2·r + Bleft) + ε

`E_all(x, T)` is the right side of `LeftSmooth.explicit_formula_all`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LeftSmooth
import Stage3.CellRows

namespace CellFixedRow

open Finset Filter Topology Kadiri FiniteOffLine

noncomputable section

/-- **The cell as a sum over the zeros, at every height.** For `16 ≤ 2^(r−d)` and
any `T ≥ 2`, the cell at row `r`, depth `d`, minus its main term, plus the sum
over the zeros below `T`, has norm at most the stencil of the explicit formula's
error at every height, read on the `d + 1` rows the stencil touches. -/
theorem cell_eq_zero_sum_all (d : ℕ) (r : ℤ) {T : ℝ} (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d
        + ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
            ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                  * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                  / ((ρ : Kadiri.NontrivialZeros) : ℂ))‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + LeftSmooth.Bleft * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4)) := by
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
  have hx16 : (16:ℝ) ≤ (2:ℝ) ^ (r - (j : ℤ)) := le_trans h16 hmono
  exact LeftSmooth.explicit_formula_all hx16 hT

/-- **The same, over the finite set of zeros below the height.** -/
theorem cell_zero_sum_finset_all (d : ℕ) (r : ℤ) {T : ℝ} (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF T, term d r ρ‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + LeftSmooth.Bleft * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4)) := by
  rw [← tsum_sub_eq_sum T (term d r)]
  exact cell_eq_zero_sum_all d r h16 hT

/-- The left-edge constant is nonnegative: it bounds a norm at `x = 16`, `T = 2`. -/
theorem Bleft_nonneg : 0 ≤ LeftSmooth.Bleft := by
  have h := LeftSmooth.left_edge_bound (x := 16) (T := 2) (by norm_num) (by norm_num)
  have hp : (0:ℝ) < (16:ℝ) ^ (-(1:ℝ) / 4) := Real.rpow_pos_of_pos (by norm_num) _
  have h0 := (norm_nonneg _).trans h
  by_contra hneg
  rw [not_le] at hneg
  have : LeftSmooth.Bleft * (16:ℝ) ^ (-(1:ℝ) / 4) < 0 := mul_neg_of_neg_of_pos hneg hp
  linarith

/-- For a fixed constant `c > 0`, `log²(c·T)/T` times `a` tends to zero as `T → ∞`. -/
theorem tendsto_log_sq_div (a c : ℝ) (hc : 0 < c) :
    Tendsto (fun T : ℝ => a * c * Real.log (c * T) ^ 2 / T) atTop (𝓝 0) := by
  have h := (Real.tendsto_pow_log_div_mul_add_atTop 1 0 2 one_ne_zero).comp
    (tendsto_id.const_mul_atTop hc)
  have h2 := h.const_mul (a * c * c)
  rw [mul_zero] at h2
  refine h2.congr' ?_
  filter_upwards [eventually_gt_atTop (0:ℝ)] with T hT
  simp only [Function.comp, id]
  field_simp
  try ring

/-- **The cell at a fixed row, the height to infinity.** For `d + 4 ≤ r` and every
`ε > 0`, for all large heights `T` the cell at row `r`, depth `d`, minus its main
term, plus its sum over the zeros below `T`, has norm at most
`2^d·(c3n·log 2·r + Bleft) + ε`. The bound left is free of the height. -/
theorem cell_fixed_row (d : ℕ) (r : ℕ) (hr : d + 4 ≤ r) :
    ∀ ε : ℝ, 0 < ε → ∀ᶠ T : ℝ in Filter.atTop,
      ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
          - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
          + ∑ ρ ∈ ZF T, term d (r : ℤ) ρ‖
        ≤ 2 ^ d * (Glue.c3n * Real.log 2 * r + LeftSmooth.Bleft) + ε := by
  intro ε hε
  have h16 : (16:ℝ) ≤ (2:ℝ) ^ ((r : ℤ) - (d : ℤ)) := by
    have e : ((r : ℤ) - (d : ℤ)) = ((r - d : ℕ) : ℤ) := by omega
    rw [e, zpow_natCast]
    calc (16:ℝ) = 2 ^ 4 := by norm_num
      _ ≤ 2 ^ (r - d) := pow_le_pow_right₀ (by norm_num) (by omega)
  -- the height-dependent part tends to zero
  have hlim : Tendsto (fun T : ℝ => ∑ j ∈ range (d + 1), (d.choose j : ℝ)
      * (Glue.c1n * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
          * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * T) ^ 2 / T)) atTop (𝓝 0) := by
    have := tendsto_finsetSum (range (d + 1)) (fun j _ =>
      ((tendsto_log_sq_div Glue.c1n ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
        (zpow_pos (by norm_num) _)).const_mul (d.choose j : ℝ)))
    simpa using this
  have hev := (hlim.eventually (gt_mem_nhds hε))
  filter_upwards [hev, eventually_ge_atTop (2:ℝ)] with T hTε hT2
  refine (cell_zero_sum_finset_all d (r : ℤ) h16 hT2).trans ?_
  have hc3 := Glue.c3n_nonneg
  have hB := Bleft_nonneg
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  -- the height-free part
  have hrest : ∀ j ∈ range (d + 1),
      Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
        + LeftSmooth.Bleft * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4)
      ≤ Glue.c3n * Real.log 2 * r + LeftSmooth.Bleft := by
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
    have h1 : Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ≤ Glue.c3n * Real.log 2 * r := by
      rw [mul_assoc]; exact mul_le_mul_of_nonneg_left hlog hc3
    have h2 : LeftSmooth.Bleft * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4)
        ≤ LeftSmooth.Bleft := by
      calc _ ≤ LeftSmooth.Bleft * 1 := mul_le_mul_of_nonneg_left hp hB
        _ = _ := mul_one _
    linarith
  have hsplit : ∑ j ∈ range (d + 1), (d.choose j : ℝ)
        * (Glue.c1n * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
            * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * T) ^ 2 / T
          + Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
          + LeftSmooth.Bleft * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4))
      = ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
              * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * T) ^ 2 / T)
        + ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
            + LeftSmooth.Bleft * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4)) := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun j _ => by ring
  have hsum2 : ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
            + LeftSmooth.Bleft * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4))
      ≤ 2 ^ d * (Glue.c3n * Real.log 2 * r + LeftSmooth.Bleft) := by
    calc _ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
            * (Glue.c3n * Real.log 2 * r + LeftSmooth.Bleft) :=
          Finset.sum_le_sum fun j hj =>
            mul_le_mul_of_nonneg_left (hrest j hj) (Nat.cast_nonneg _)
      _ = (∑ j ∈ range (d + 1), (d.choose j : ℝ))
            * (Glue.c3n * Real.log 2 * r + LeftSmooth.Bleft) := by rw [Finset.sum_mul]
      _ = 2 ^ d * (Glue.c3n * Real.log 2 * r + LeftSmooth.Bleft) := by
          congr 1
          exact_mod_cast Nat.sum_range_choose d
  rw [hsplit]
  linarith

end

/-- info: 'CellFixedRow.cell_eq_zero_sum_all' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_eq_zero_sum_all

/-- info: 'CellFixedRow.cell_zero_sum_finset_all' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_zero_sum_finset_all

/-- info: 'CellFixedRow.cell_fixed_row' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_fixed_row

end CellFixedRow
