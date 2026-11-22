/-
LandauChebyshev — the bound on `G` of Chebyshev's order:
`G y ≤ 8y` and `|G(y)| ≤ 8y(1 + log y)` for `y ≥ 1`.
Block 5b of `lean_stage3/design/landau.md`. 2026-11-22.

Each ramp `max(y/n − 1, 0)` is at most `y/n`, so the ramp sum is at most
`y·Σ_{n ≤ y} Λ(n)/n`, and upstream has that sum as `log y + E₁Λ y` with
`E₁Λ y ≤ log 4 + 4` (`Mertens.E₁Λ.le`). In `G` the `y·log y` then cancels.

  rampSum_le_log   (hy : 1 ≤ y) : rampSum y ≤ y · (log y + (log 4 + 4))
  G_le             (hy : 1 ≤ y) : G y ≤ 8 · y
  neg_le_G         (hy : 1 ≤ y) : −(y · log y) ≤ G y
  abs_G_le_log     (hy : 1 ≤ y) : |G y| ≤ 8 · y · (1 + log y)

This sharpens `LandauCrude.abs_G_le` by the factor `(1 + log y)` that block 5
named.

What the next slice needs: `abs_G_le_log`, to exchange a power series with
the Mellin integral of `G` (block 2c) and to bound the integral off the
window (block 4).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauCrude
import PrimeNumberTheoremAnd.IEANTN.Mertens

namespace LandauChebyshev

noncomputable section

open scoped ArithmeticFunction.vonMangoldt

theorem rampSum_le_log {y : ℝ} (hy : 1 ≤ y) :
    LandauWindow.rampSum y ≤ y * (Real.log y + (Real.log 4 + 4)) := by
  have hy0 : 0 < y := by linarith
  have hterm : ∀ n ∈ Finset.range (⌊y⌋₊ + 1),
      Λ n * max (y / n - 1) 0 ≤ y * (Λ n / n) := by
    intro n _
    rcases Nat.eq_zero_or_pos n with rfl | hn0
    · simp
    · have hnR : (0 : ℝ) < n := by exact_mod_cast hn0
      have h2 : max (y / n - 1) 0 ≤ y / n := max_le (by linarith) (by positivity)
      calc Λ n * max (y / n - 1) 0
          ≤ Λ n * (y / n) :=
            mul_le_mul_of_nonneg_left h2 ArithmeticFunction.vonMangoldt_nonneg
        _ = y * (Λ n / n) := by ring
  have hsub : Finset.Ioc 0 ⌊y⌋₊ ⊆ Finset.range (⌊y⌋₊ + 1) := by
    intro n hn
    rw [Finset.mem_Ioc] at hn
    exact Finset.mem_range.mpr (by omega)
  have hsum : ∑ n ∈ Finset.range (⌊y⌋₊ + 1), Λ n / (n : ℝ)
      = ∑ n ∈ Finset.Ioc 0 ⌊y⌋₊, Λ n / (n : ℝ) := by
    symm
    refine Finset.sum_subset hsub (fun n hn hn' => ?_)
    have : n = 0 := by
      rw [Finset.mem_range] at hn
      rw [Finset.mem_Ioc] at hn'
      omega
    simp [this]
  have hE := Mertens.E₁Λ.le hy
  rw [Mertens.E₁Λ] at hE
  calc LandauWindow.rampSum y
      ≤ ∑ n ∈ Finset.range (⌊y⌋₊ + 1), y * (Λ n / n) := by
        rw [LandauWindow.rampSum]; exact Finset.sum_le_sum hterm
    _ = y * ∑ n ∈ Finset.Ioc 0 ⌊y⌋₊, Λ n / (n : ℝ) := by
        rw [← Finset.mul_sum, hsum]
    _ ≤ y * (Real.log y + (Real.log 4 + 4)) :=
        mul_le_mul_of_nonneg_left (by linarith) hy0.le

private lemma log_four_lt_two : Real.log 4 < 2 := by
  have h : Real.log 4 = 2 * Real.log 2 := by
    rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.log_pow]; norm_num
  rw [h]
  linarith [Real.log_two_lt_d9]

theorem G_le {y : ℝ} (hy : 1 ≤ y) : LandauWindow.G y ≤ 8 * y := by
  have hy0 : 0 < y := by linarith
  have h1 := rampSum_le_log hy
  have hγ1 : Real.eulerMascheroniConstant < 2 / 3 := Real.eulerMascheroniConstant_lt_two_thirds
  have h4 := log_four_lt_two
  rw [LandauWindow.G]
  nlinarith

theorem neg_le_G {y : ℝ} (hy : 1 ≤ y) : -(y * Real.log y) ≤ LandauWindow.G y := by
  have hy0 : 0 < y := by linarith
  have h0 := LandauCrude.rampSum_nonneg y
  have hγ0 : 0 < Real.eulerMascheroniConstant := by
    linarith [Real.one_half_lt_eulerMascheroniConstant]
  have : 0 ≤ (1 + Real.eulerMascheroniConstant) * y := by positivity
  rw [LandauWindow.G]
  linarith

theorem abs_G_le_log {y : ℝ} (hy : 1 ≤ y) :
    |LandauWindow.G y| ≤ 8 * y * (1 + Real.log y) := by
  have hy0 : 0 < y := by linarith
  have hL : 0 ≤ Real.log y := Real.log_nonneg hy
  have h1 := G_le hy
  have h2 := neg_le_G hy
  have hyL : 0 ≤ y * Real.log y := mul_nonneg hy0.le hL
  rw [abs_le]
  constructor <;> nlinarith

/-- info: 'LandauChebyshev.rampSum_le_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rampSum_le_log

/-- info: 'LandauChebyshev.G_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms G_le

/-- info: 'LandauChebyshev.abs_G_le_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms abs_G_le_log

end

end LandauChebyshev
