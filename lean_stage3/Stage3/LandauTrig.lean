/-
LandauTrig — a real exponential sum is large somewhere in every long block.
Block 6 of `lean_stage3/design/landau.md`. 2026-11-22.

`T(n) = Σ_j c_j·z_j^n` over a finite set, the `z_j` of modulus one and
distinct, `T` real-valued, the coefficient at the frequency `1` of
nonnegative real part, some `c_j ≠ 0`. Then there are `τ > 0` and `N₀` with:
every block of `N ≥ N₀` consecutive `n` holds an `n` with `T(n) ≥ τ`.

Over a block the sum of `T` is bounded below and the sum of `T²` grows like
`N·Σ|c_j|²`, both by geometric sums; `|T|` is bounded. A `T` below `τ` on a
whole long block contradicts the three.

  norm_geom_Ico_le       (hw : ‖w‖ = 1) (hw1 : w ≠ 1) :
                           ‖Σ_{n ∈ Ico a (a+N)} w^n‖ ≤ 2/‖w − 1‖
  sum_block_ge           Z1, C1, T1 : −Σ_j ‖c_j‖·(2/‖z_j − 1‖) ≤ Σ_{block} T n
  sum_sq_block_ge        Z1, Z2, T1 : N·Σ_j ‖c_j‖² − E₂ ≤ Σ_{block} (T n)²
  abs_le_sum_norm        Z1, T1 : |T n| ≤ Σ_j ‖c_j‖
  exists_large_in_block  Z1, Z2, C1, C2, T1 : ∃ τ > 0, ∃ N₀, ∀ a N, N₀ ≤ N →
                           ∃ n ∈ Ico a (a+N), τ ≤ T n

Z1 `∀ j ∈ s, ‖z j‖ = 1`; Z2 `Set.InjOn z s`; C1 `∀ j ∈ s, z j = 1 → 0 ≤ (c j).re`;
C2 `∃ j ∈ s, c j ≠ 0`; T1 `∀ n, (T n : ℂ) = ∑ j ∈ s, c j * z j ^ n`.
In Lean a division by zero is zero, so the sums `E₁`, `E₂` need no case split.

What the next slice needs: this lemma with `z_j = e^(−iφ_j)` the directions of
the poles nearest `σ₀` and `c_j` their coefficients (block 7).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib

namespace LandauTrig

noncomputable section

open Finset
open scoped ComplexConjugate

variable {ι : Type*}

/-- If `w` has modulus one and `w ≠ 1`, then the geometric sum of `w^n` over a block of `N`
consecutive `n` starting at `a` has norm at most `2/‖w - 1‖`. -/
theorem norm_geom_Ico_le {w : ℂ} (hw : ‖w‖ = 1) (hw1 : w ≠ 1) (a N : ℕ) :
    ‖∑ n ∈ Finset.Ico a (a + N), w ^ n‖ ≤ 2 / ‖w - 1‖ := by
  have hpos : 0 < ‖w - 1‖ := norm_pos_iff.mpr (sub_ne_zero.mpr hw1)
  rw [geom_sum_Ico hw1 (Nat.le_add_right a N), norm_div]
  apply div_le_div_of_nonneg_right _ hpos.le
  calc ‖w ^ (a + N) - w ^ a‖ ≤ ‖w ^ (a + N)‖ + ‖w ^ a‖ := norm_sub_le _ _
    _ = 2 := by rw [norm_pow, norm_pow, hw, one_pow, one_pow]; norm_num

/-- The real part of `c·Σ w^n` over a block, from below, when `w ≠ 1`. -/
private lemma re_mul_geom_ge (c : ℂ) {w : ℂ} (hw : ‖w‖ = 1) (hw1 : w ≠ 1) (a N : ℕ) :
    -(‖c‖ * (2 / ‖w - 1‖)) ≤ (c * ∑ n ∈ Finset.Ico a (a + N), w ^ n).re := by
  have h1 : |(c * ∑ n ∈ Finset.Ico a (a + N), w ^ n).re|
      ≤ ‖c * ∑ n ∈ Finset.Ico a (a + N), w ^ n‖ := Complex.abs_re_le_norm _
  have h2 : ‖c * ∑ n ∈ Finset.Ico a (a + N), w ^ n‖ ≤ ‖c‖ * (2 / ‖w - 1‖) := by
    rw [norm_mul]
    exact mul_le_mul_of_nonneg_left (norm_geom_Ico_le hw hw1 a N) (norm_nonneg c)
  linarith [neg_abs_le (c * ∑ n ∈ Finset.Ico a (a + N), w ^ n).re]

/-- For `T n = Σ_j c_j·z_j^n` real-valued with every `z_j` of modulus one and the coefficient at
`z_j = 1` of nonnegative real part, the sum of `T` over any block of consecutive `n` is at
least `-Σ_j ‖c_j‖·(2/‖z_j - 1‖)`. -/
theorem sum_block_ge (s : Finset ι) (c z : ι → ℂ)
    (hz : ∀ j ∈ s, ‖z j‖ = 1) (hconst : ∀ j ∈ s, z j = 1 → 0 ≤ (c j).re)
    (T : ℕ → ℝ) (hT : ∀ n, (T n : ℂ) = ∑ j ∈ s, c j * z j ^ n) (a N : ℕ) :
    -(∑ j ∈ s, ‖c j‖ * (2 / ‖z j - 1‖)) ≤ ∑ n ∈ Finset.Ico a (a + N), T n := by
  have hC : ((∑ n ∈ Finset.Ico a (a + N), T n : ℝ) : ℂ)
      = ∑ j ∈ s, c j * ∑ n ∈ Finset.Ico a (a + N), z j ^ n := by
    rw [Complex.ofReal_sum]
    simp_rw [hT, Finset.mul_sum]
    rw [Finset.sum_comm]
  have hre : ∑ n ∈ Finset.Ico a (a + N), T n
      = ∑ j ∈ s, (c j * ∑ n ∈ Finset.Ico a (a + N), z j ^ n).re := by
    rw [← Complex.re_sum, ← hC, Complex.ofReal_re]
  rw [hre, ← Finset.sum_neg_distrib]
  refine Finset.sum_le_sum fun j hj => ?_
  by_cases h1 : z j = 1
  · have h0 := hconst j hj h1
    have hsum : ∑ n ∈ Finset.Ico a (a + N), z j ^ n = (N : ℂ) := by simp [h1]
    have hre' : (c j * (N : ℂ)).re = (c j).re * N := by simp
    rw [hsum, hre', h1]
    simp only [sub_self, norm_zero, div_zero, mul_zero, neg_zero]
    positivity
  · exact re_mul_geom_ge (c j) (hz j hj) h1 a N

/-- For `T n = Σ_j c_j·z_j^n` real-valued with every `z_j` of modulus one, `|T n|` is at most
`Σ_j ‖c_j‖` for every `n`. -/
theorem abs_le_sum_norm (s : Finset ι) (c z : ι → ℂ) (hz : ∀ j ∈ s, ‖z j‖ = 1)
    (T : ℕ → ℝ) (hT : ∀ n, (T n : ℂ) = ∑ j ∈ s, c j * z j ^ n) (n : ℕ) :
    |T n| ≤ ∑ j ∈ s, ‖c j‖ := by
  have h : |T n| = ‖(T n : ℂ)‖ := by rw [Complex.norm_real, Real.norm_eq_abs]
  rw [h, hT n]
  refine le_trans (norm_sum_le _ _) (Finset.sum_le_sum fun j hj => ?_)
  rw [norm_mul, norm_pow, hz j hj, one_pow, mul_one]

/-- For `T n = Σ_j c_j·z_j^n` real-valued with the `z_j` of modulus one and distinct, the sum of
`T²` over a block of `N` consecutive `n` is at least `N·Σ_j ‖c_j‖²` minus the off-diagonal
sum `Σ_{j ≠ l} ‖c_j‖·‖c_l‖·(2/‖z_j·conj z_l - 1‖)`. -/
theorem sum_sq_block_ge [DecidableEq ι] (s : Finset ι) (c z : ι → ℂ)
    (hz : ∀ j ∈ s, ‖z j‖ = 1) (hinj : Set.InjOn z s)
    (T : ℕ → ℝ) (hT : ∀ n, (T n : ℂ) = ∑ j ∈ s, c j * z j ^ n) (a N : ℕ) :
    (N : ℝ) * ∑ j ∈ s, ‖c j‖ ^ 2
        - ∑ j ∈ s, ∑ l ∈ s, (if j = l then 0
            else ‖c j‖ * ‖c l‖ * (2 / ‖z j * conj (z l) - 1‖))
      ≤ ∑ n ∈ Finset.Ico a (a + N), T n ^ 2 := by
  have hsq : ∀ n, (T n : ℂ) ^ 2
      = ∑ j ∈ s, ∑ l ∈ s, c j * conj (c l) * (z j * conj (z l)) ^ n := by
    intro n
    have h1 : (T n : ℂ) ^ 2 = (T n : ℂ) * conj (T n : ℂ) := by
      rw [Complex.conj_ofReal, sq]
    rw [h1, hT n, map_sum, Finset.sum_mul_sum]
    refine Finset.sum_congr rfl fun j _ => Finset.sum_congr rfl fun l _ => ?_
    rw [map_mul, map_pow, mul_pow]
    ring
  have hC : ((∑ n ∈ Finset.Ico a (a + N), T n ^ 2 : ℝ) : ℂ)
      = ∑ j ∈ s, ∑ l ∈ s,
          c j * conj (c l) * ∑ n ∈ Finset.Ico a (a + N), (z j * conj (z l)) ^ n := by
    rw [Complex.ofReal_sum]
    simp_rw [Complex.ofReal_pow, hsq, Finset.mul_sum]
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [Finset.sum_comm]
  have hre : ∑ n ∈ Finset.Ico a (a + N), T n ^ 2
      = ∑ j ∈ s, ∑ l ∈ s,
          (c j * conj (c l) * ∑ n ∈ Finset.Ico a (a + N), (z j * conj (z l)) ^ n).re := by
    have := congrArg Complex.re hC
    rw [Complex.ofReal_re, Complex.re_sum] at this
    rw [this]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [Complex.re_sum]
  have hdiag : (N : ℝ) * ∑ j ∈ s, ‖c j‖ ^ 2
      = ∑ j ∈ s, ∑ l ∈ s, (if j = l then (N : ℝ) * ‖c j‖ ^ 2 else 0) := by
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun j hj => ?_
    rw [Finset.sum_ite_eq, if_pos hj]
  rw [hre, hdiag, ← Finset.sum_sub_distrib]
  refine Finset.sum_le_sum fun j hj => ?_
  rw [← Finset.sum_sub_distrib]
  refine Finset.sum_le_sum fun l hl => ?_
  by_cases hjl : j = l
  · subst hjl
    have hw : z j * conj (z j) = 1 := by
      rw [Complex.mul_conj', hz j hj]; norm_num
    have hcc : c j * conj (c j) = ((‖c j‖ ^ 2 : ℝ) : ℂ) := by
      rw [Complex.mul_conj']; push_cast; rfl
    simp only [if_true, sub_zero, hw, one_pow, Finset.sum_const, Nat.card_Ico,
      Nat.add_sub_cancel_left, nsmul_eq_mul, mul_one, hcc]
    rw [← Complex.ofReal_natCast, ← Complex.ofReal_mul, Complex.ofReal_re]
    linarith [mul_comm (N : ℝ) (‖c j‖ ^ 2)]
  · have hw : ‖z j * conj (z l)‖ = 1 := by
      rw [norm_mul, Complex.norm_conj, hz j hj, hz l hl, one_mul]
    have hw1 : z j * conj (z l) ≠ 1 := by
      intro h
      apply hjl
      apply hinj hj hl
      have hl1 : conj (z l) * z l = 1 := by
        rw [Complex.conj_mul', hz l hl]; norm_num
      calc z j = z j * (conj (z l) * z l) := by rw [hl1, mul_one]
        _ = (z j * conj (z l)) * z l := by ring
        _ = z l := by rw [h, one_mul]
    simp only [if_neg hjl, zero_sub]
    have := re_mul_geom_ge (c j * conj (c l)) hw hw1 a N
    rw [norm_mul, Complex.norm_conj] at this
    exact this

/-- For `T n = Σ_j c_j·z_j^n` real-valued with the `z_j` of modulus one and distinct, the
coefficient at `z_j = 1` of nonnegative real part and some `c_j ≠ 0`, there are `τ > 0` and
`N₀` such that every block of `N ≥ N₀` consecutive `n` holds an `n` with `τ ≤ T n`. -/
theorem exists_large_in_block [DecidableEq ι] (s : Finset ι) (c z : ι → ℂ)
    (hz : ∀ j ∈ s, ‖z j‖ = 1) (hinj : Set.InjOn z s)
    (hconst : ∀ j ∈ s, z j = 1 → 0 ≤ (c j).re) (hne : ∃ j ∈ s, c j ≠ 0)
    (T : ℕ → ℝ) (hT : ∀ n, (T n : ℂ) = ∑ j ∈ s, c j * z j ^ n) :
    ∃ τ : ℝ, 0 < τ ∧ ∃ N₀ : ℕ, ∀ a N : ℕ, N₀ ≤ N →
      ∃ n ∈ Finset.Ico a (a + N), τ ≤ T n := by
  obtain ⟨j₀, hj₀, hc₀⟩ := hne
  set B : ℝ := ∑ j ∈ s, ‖c j‖ with hB
  set S : ℝ := ∑ j ∈ s, ‖c j‖ ^ 2 with hS
  set E₁ : ℝ := ∑ j ∈ s, ‖c j‖ * (2 / ‖z j - 1‖) with hE₁
  set E₂ : ℝ := ∑ j ∈ s, ∑ l ∈ s, (if j = l then 0
      else ‖c j‖ * ‖c l‖ * (2 / ‖z j * conj (z l) - 1‖)) with hE₂
  have hBpos : 0 < B :=
    lt_of_lt_of_le (norm_pos_iff.mpr hc₀)
      (Finset.single_le_sum (f := fun j => ‖c j‖) (fun j _ => norm_nonneg _) hj₀)
  have hSpos : 0 < S :=
    lt_of_lt_of_le (pow_pos (norm_pos_iff.mpr hc₀) 2)
      (Finset.single_le_sum (f := fun j => ‖c j‖ ^ 2) (fun j _ => by positivity) hj₀)
  have hτ : 0 < S / (4 * B) := by positivity
  refine ⟨S / (4 * B), hτ, ⌊2 * (E₂ + B * E₁) / S⌋₊ + 1, fun a N hN => ?_⟩
  by_contra hcon
  push Not at hcon
  have hNlt : 2 * (E₂ + B * E₁) / S < N := by
    have h1 : 2 * (E₂ + B * E₁) / S < (⌊2 * (E₂ + B * E₁) / S⌋₊ : ℝ) + 1 :=
      Nat.lt_floor_add_one _
    have h2 : ((⌊2 * (E₂ + B * E₁) / S⌋₊ : ℝ) + 1) ≤ N := by exact_mod_cast hN
    linarith
  -- pointwise: T² ≤ B·(2τ − T)
  have hpt : ∀ n ∈ Finset.Ico a (a + N), T n ^ 2 ≤ B * (2 * (S / (4 * B)) - T n) := by
    intro n hn
    have hlt := hcon n hn
    have habs := abs_le.mp (abs_le_sum_norm s c z hz T hT n)
    rcases le_or_gt 0 (T n) with h0 | h0
    · nlinarith [habs.2]
    · nlinarith [habs.1]
  have hsum := Finset.sum_le_sum hpt
  rw [← Finset.mul_sum, Finset.sum_sub_distrib, Finset.sum_const, Nat.card_Ico,
    Nat.add_sub_cancel_left, nsmul_eq_mul] at hsum
  have hsq := sum_sq_block_ge s c z hz hinj T hT a N
  have hmean := sum_block_ge s c z hz hconst T hT a N
  rw [← hS, ← hE₂] at hsq
  rw [← hE₁] at hmean
  have hB2 : B * ((N : ℝ) * (2 * (S / (4 * B)))) = (N : ℝ) * S / 2 := by
    field_simp
    try ring
  have hfin : (N : ℝ) * S / 2 ≤ E₂ + B * E₁ := by
    have h3 : B * ((N : ℝ) * (2 * (S / (4 * B))) - ∑ n ∈ Finset.Ico a (a + N), T n)
        ≤ (N : ℝ) * S / 2 + B * E₁ := by
      rw [mul_sub, hB2]
      nlinarith [mul_le_mul_of_nonneg_left hmean hBpos.le]
    linarith
  have : (N : ℝ) ≤ 2 * (E₂ + B * E₁) / S := by
    rw [le_div_iff₀ hSpos]
    linarith
  linarith

/-- info: 'LandauTrig.sum_block_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_block_ge

/-- info: 'LandauTrig.sum_sq_block_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_sq_block_ge

/-- info: 'LandauTrig.exists_large_in_block' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_large_in_block

end

end LandauTrig
