/-
LandauCrude — a crude bound on `G`: `|G(y)| ≤ 2y(1 + log y)²` for `y ≥ 1`.
Block 5 of `lean_stage3/design/landau.md`. 2026-11-22.

`G y = rampSum y − y·log y + (1+γ)·y` and `rampSum y = Σ_{n ≤ y} Λ(n)·max(y/n − 1, 0)`
are `LandauWindow.G` and `LandauWindow.rampSum`. Each `Λ(n) ≤ log n ≤ log y`,
each ramp is at most `y/n`, and `Σ_{n ≤ y} 1/n ≤ 1 + log y`.

  rampSum_nonneg   0 ≤ rampSum y
  rampSum_le       (hy : 1 ≤ y) : rampSum y ≤ y · log y · (1 + log y)
  abs_G_le         (hy : 1 ≤ y) : |G y| ≤ 2 · y · (1 + log y)²

The bound has one more factor `(1 + log y)` than Chebyshev's would give. The
block's Sizes line names it: downstream it is a factor polynomial in `k`
against a strict exponential gap.

What the next slice needs: this bound, to exchange a power series with the
Mellin integral of `G` (block 2c) and to bound the integral off the window
(block 4).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauWindow

namespace LandauCrude

noncomputable section

open scoped ArithmeticFunction.vonMangoldt

theorem rampSum_nonneg (y : ℝ) : 0 ≤ LandauWindow.rampSum y := by
  rw [LandauWindow.rampSum]
  exact Finset.sum_nonneg fun n _ =>
    mul_nonneg ArithmeticFunction.vonMangoldt_nonneg (le_max_right _ _)

/-- The reciprocals up to `N`, with the term at `0` (which is `0`). -/
private lemma sum_inv_le (N : ℕ) :
    ∑ n ∈ Finset.range (N + 1), ((n : ℝ))⁻¹ ≤ 1 + Real.log N := by
  have h := harmonic_le_one_add_log N
  have hc : ((harmonic N : ℚ) : ℝ) = ∑ n ∈ Finset.range (N + 1), ((n : ℝ))⁻¹ := by
    rw [Finset.sum_range_succ', harmonic]
    push_cast
    simp
  rw [← hc]
  exact h

theorem rampSum_le {y : ℝ} (hy : 1 ≤ y) :
    LandauWindow.rampSum y ≤ y * Real.log y * (1 + Real.log y) := by
  have hy0 : 0 < y := by linarith
  have hL : 0 ≤ Real.log y := Real.log_nonneg hy
  have hN1 : 1 ≤ ⌊y⌋₊ := Nat.one_le_iff_ne_zero.mpr (by
    rw [Ne, Nat.floor_eq_zero]; linarith)
  have hNy : (⌊y⌋₊ : ℝ) ≤ y := Nat.floor_le hy0.le
  have hterm : ∀ n ∈ Finset.range (⌊y⌋₊ + 1),
      Λ n * max (y / n - 1) 0 ≤ y * Real.log y * ((n : ℝ))⁻¹ := by
    intro n hn
    rcases Nat.eq_zero_or_pos n with rfl | hn0
    · simp
    · have hnR : (0 : ℝ) < n := by exact_mod_cast hn0
      have hny : (n : ℝ) ≤ y := by
        have : n ≤ ⌊y⌋₊ := Nat.lt_succ_iff.mp (Finset.mem_range.mp hn)
        exact le_trans (by exact_mod_cast this) hNy
      have h1 : Λ n ≤ Real.log y :=
        le_trans ArithmeticFunction.vonMangoldt_le_log (Real.log_le_log hnR hny)
      have h2 : max (y / n - 1) 0 ≤ y * ((n : ℝ))⁻¹ := by
        rw [← div_eq_mul_inv]
        exact max_le (by linarith) (by positivity)
      calc Λ n * max (y / n - 1) 0
          ≤ Real.log y * (y * ((n : ℝ))⁻¹) :=
            mul_le_mul h1 h2 (le_max_right _ _) hL
        _ = y * Real.log y * ((n : ℝ))⁻¹ := by ring
  have hlogN : Real.log (⌊y⌋₊ : ℝ) ≤ Real.log y :=
    Real.log_le_log (by exact_mod_cast hN1) hNy
  calc LandauWindow.rampSum y
      ≤ ∑ n ∈ Finset.range (⌊y⌋₊ + 1), y * Real.log y * ((n : ℝ))⁻¹ := by
        rw [LandauWindow.rampSum]; exact Finset.sum_le_sum hterm
    _ = y * Real.log y * ∑ n ∈ Finset.range (⌊y⌋₊ + 1), ((n : ℝ))⁻¹ := by
        rw [Finset.mul_sum]
    _ ≤ y * Real.log y * (1 + Real.log y) :=
        mul_le_mul_of_nonneg_left (le_trans (sum_inv_le _) (by linarith))
          (mul_nonneg hy0.le hL)

theorem abs_G_le {y : ℝ} (hy : 1 ≤ y) :
    |LandauWindow.G y| ≤ 2 * y * (1 + Real.log y) ^ 2 := by
  have hy0 : 0 < y := by linarith
  have hL : 0 ≤ Real.log y := Real.log_nonneg hy
  have h0 := rampSum_nonneg y
  have h1 := rampSum_le hy
  have hγ0 : 0 < Real.eulerMascheroniConstant := by
    linarith [Real.one_half_lt_eulerMascheroniConstant]
  have hγ1 : Real.eulerMascheroniConstant < 2 / 3 := Real.eulerMascheroniConstant_lt_two_thirds
  have hyL : 0 ≤ y * Real.log y := mul_nonneg hy0.le hL
  have hyLL : 0 ≤ y * Real.log y * Real.log y := mul_nonneg hyL hL
  have hγy : 0 ≤ Real.eulerMascheroniConstant * y := mul_nonneg hγ0.le hy0.le
  have hγy' : Real.eulerMascheroniConstant * y ≤ y := by nlinarith
  rw [LandauWindow.G, abs_le]
  constructor <;> nlinarith

/-- info: 'LandauCrude.rampSum_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rampSum_nonneg

/-- info: 'LandauCrude.rampSum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rampSum_le

/-- info: 'LandauCrude.abs_G_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms abs_G_le

end

end LandauCrude
