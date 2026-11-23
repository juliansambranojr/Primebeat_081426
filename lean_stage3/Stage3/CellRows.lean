/-
CellRows — block T3a of `lean_stage3/design/joints.md`. 2026-11-22.

The height of the zero sum taken to infinity along the rows. At row `r` the
height is the doubling of the cell's lowest row, `2^(r−d)`. The cell is then
its main term minus the sum over the zeros below that height, within a constant
times `r²`. Against square-root size that error tends to zero: the tail of the
zero sum is inside the error.

  cell_eq_zero_sum_rows   r = d + K + 1, 3 ≤ K ⊢ the cell, its main term and the
                            zeros below 2^(K+1) differ by ≤ A_d·r²
  cell_tail_tendsto       that difference over √2^r tends to 0

The height at a fixed row cannot be raised past the square of the row's
doubling: `CellZeros.cell_eq_zero_sum` asks `T ≤ (2^(r−d))²`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.FiniteOffLine

namespace CellRows

open Finset Filter Topology Kadiri FiniteOffLine

noncomputable section

/-- **The cell at the row's own height.** -/
theorem cell_eq_zero_sum_rows (d K r : ℕ) (hr : r = d + K + 1) (hK : 3 ≤ K) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
        - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
        + ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)), term d (r : ℤ) ρ‖
      ≤ 2 ^ d * ((4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n) * (r : ℝ) ^ 2) := by
  have e : ((r : ℤ) - (d : ℤ)) = ((K + 1 : ℕ) : ℤ) := by omega
  have hpow : (2:ℝ) ^ ((r : ℤ) - (d : ℤ)) = (2:ℝ) ^ (K + 1) := by rw [e, zpow_natCast]
  have hT16 : (16:ℝ) ≤ (2:ℝ) ^ (K + 1) := by
    calc (16:ℝ) = 2 ^ 4 := by norm_num
      _ ≤ 2 ^ (K + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
  exact (cell_zero_sum_finset d (r : ℤ) (T := (2:ℝ) ^ (K + 1))
    (by rw [hpow]; exact hT16) (by linarith) (by rw [hpow]; nlinarith)).trans (err_le d K r hr)

/-- **The tail of the zero sum is inside the error.** With the height `2^(r−d)`
at row `r`, the distance between the cell and its zero sum, over `√2^r`, tends
to zero. -/
theorem cell_tail_tendsto (d : ℕ) :
    Tendsto (fun r : ℕ =>
      ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
          - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
          + ∑ ρ ∈ ZF ((2:ℝ) ^ (r - d)), term d (r : ℤ) ρ‖ / Real.sqrt 2 ^ r)
      atTop (𝓝 0) := by
  have hs1 : (1:ℝ) < Real.sqrt 2 := by
    rw [Real.lt_sqrt (by norm_num)]
    norm_num
  have hs0 : (0:ℝ) < Real.sqrt 2 := by linarith
  have habs : |(Real.sqrt 2)⁻¹| < 1 := by
    rw [abs_of_pos (inv_pos.mpr hs0)]
    exact inv_lt_one_of_one_lt₀ hs1
  have hlim : Tendsto (fun r : ℕ => 2 ^ d * (4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n)
      * ((r : ℝ) ^ 2 * (Real.sqrt 2)⁻¹ ^ r)) atTop (𝓝 0) := by
    simpa using (tendsto_pow_const_mul_const_pow_of_abs_lt_one 2 habs).const_mul
      (2 ^ d * (4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n))
  refine squeeze_zero' (Eventually.of_forall fun r => by positivity) ?_ hlim
  filter_upwards [eventually_ge_atTop (d + 4)] with r hr
  obtain ⟨K, hK⟩ : ∃ K : ℕ, r = d + K + 1 := ⟨r - d - 1, by omega⟩
  have hrd : r - d = K + 1 := by omega
  rw [hrd]
  have h := cell_eq_zero_sum_rows d K r hK (by omega)
  have h1 : (Real.sqrt 2)⁻¹ ^ r * Real.sqrt 2 ^ r = 1 := by
    rw [← mul_pow, inv_mul_cancel₀ hs0.ne', one_pow]
  rw [div_le_iff₀ (by positivity)]
  calc _ ≤ 2 ^ d * ((4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n) * (r : ℝ) ^ 2) := h
    _ = 2 ^ d * (4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n) * (r : ℝ) ^ 2
          * ((Real.sqrt 2)⁻¹ ^ r * Real.sqrt 2 ^ r) := by rw [h1]; ring
    _ = _ := by ring

end

/-- info: 'CellRows.cell_eq_zero_sum_rows' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_eq_zero_sum_rows

/-- info: 'CellRows.cell_tail_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_tail_tendsto

end CellRows
