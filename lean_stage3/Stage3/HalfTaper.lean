/-
# Stage3.HalfTaper — the sieve's Möbius sum with no sharp cut

Unit 0588: every sharp cut of the sieve's Möbius sum at a level `y` carries `N · Σ_{d≤y} μ(d)/d`,
larger than the square root unless `y = N`. Tapered by `(1 − d/y)`, the sum stays near `2√N` at
`y = √N` for `N` to `10¹⁰` (scratch, exploratory, 2026-11-26) while the sharp one reaches `60√N`.
The difference is exact and is one term: `(N/y)` times the signed count up to `y`. At the fold
`y = √N` it is `√N · M(√N)`, the Möbius count on Julian's fold line.
-/
import Mathlib

namespace HalfTaper

open Finset

/-- **The taper takes out exactly the signed count at the cut.** For any weights `c`,

    N · Σ_{d ≤ y} c(d)/d · (1 − d/y) = N · Σ_{d ≤ y} c(d)/d − (N/y) · Σ_{d ≤ y} c(d). -/
theorem taper_eq (c : ℕ → ℚ) (N y : ℕ) (hy : 0 < y) :
    (N : ℚ) * ∑ d ∈ Icc 1 y, c d / d * (1 - (d : ℚ) / y)
      = (N : ℚ) * ∑ d ∈ Icc 1 y, c d / d - ((N : ℚ) / y) * ∑ d ∈ Icc 1 y, c d := by
  have hy' : (y : ℚ) ≠ 0 := by exact_mod_cast hy.ne'
  rw [Finset.mul_sum, Finset.mul_sum, Finset.mul_sum, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun d hd => ?_
  have hd0 : (d : ℚ) ≠ 0 := by
    have := (mem_Icc.mp hd).1; exact_mod_cast (by omega : d ≠ 0)
  field_simp

end HalfTaper

/-- info: 'HalfTaper.taper_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfTaper.taper_eq

namespace HalfTaper

open Finset

/-- The signed count up to `t`. -/
def cnt (c : ℕ → ℚ) (t : ℕ) : ℚ := ∑ d ∈ Icc 1 t, c d

/-- **Julian's mirror fold, exact (the hyperbola).** For weights `c`, a fold level `y ≥ 1` and its
mirror `z = N / y`: the floors of the sieve split into the small side `d ≤ y`, the mirrored side
(the signed count at the scales `N/m`, `m ≤ z`), less the fold line `z · C(y)`. -/
theorem fold_eq (c : ℕ → ℚ) (N y : ℕ) (hy : 1 ≤ y) :
    ∑ d ∈ Icc 1 N, c d * ((N / d : ℕ) : ℚ)
      = ∑ d ∈ Icc 1 y, c d * ((N / d : ℕ) : ℚ) + ∑ m ∈ Icc 1 (N / y), cnt c (N / m)
        - ((N / y : ℕ) : ℚ) * cnt c y := by
  -- each floor is a count of `m`
  have hfl : ∀ d, c d * ((N / d : ℕ) : ℚ) = ∑ m ∈ Icc 1 (N / d), c d := by
    intro d; rw [Finset.sum_const, Nat.card_Icc, nsmul_eq_mul]; simp; ring
  -- split the `d` range at `y`
  by_cases hyN : y ≤ N
  · have hsplit : Icc 1 N = Icc 1 y ∪ Ioc y N := by
      ext x; simp only [mem_union, mem_Icc, mem_Ioc]; omega
    have hdisj : Disjoint (Icc 1 y) (Ioc y N) := by
      rw [disjoint_left]; intro x h1 h2; simp only [mem_Icc, mem_Ioc] at h1 h2; omega
    rw [hsplit, Finset.sum_union hdisj]
    -- the big side, swapped
    have hswap : ∑ d ∈ Ioc y N, ∑ m ∈ Icc 1 (N / d), c d
        = ∑ m ∈ Icc 1 (N / y), ∑ d ∈ Ioc y (N / m), c d := by
      apply Finset.sum_comm'
      intro d m
      simp only [mem_Ioc, mem_Icc]
      constructor
      · rintro ⟨⟨h1, h2⟩, h3, h4⟩
        have hdm : d * m ≤ N := (Nat.le_div_iff_mul_le (by omega)).mp h4 |>.trans_eq' (mul_comm m d)
        refine ⟨⟨h1, (Nat.le_div_iff_mul_le (by omega)).mpr hdm⟩, h3, ?_⟩
        rw [Nat.le_div_iff_mul_le (by omega)]; nlinarith
      · rintro ⟨⟨h1, h2⟩, h3, h4⟩
        have hdm : d * m ≤ N := (Nat.le_div_iff_mul_le (by omega)).mp h2
        refine ⟨⟨h1, by nlinarith⟩, h3, ?_⟩
        rw [Nat.le_div_iff_mul_le (by omega)]; linarith [mul_comm d m]
    have hbig : ∑ d ∈ Ioc y N, c d * ((N / d : ℕ) : ℚ)
        = ∑ m ∈ Icc 1 (N / y), (cnt c (N / m) - cnt c y) := by
      rw [Finset.sum_congr rfl fun d _ => hfl d, hswap]
      refine Finset.sum_congr rfl fun m hm => ?_
      have hm' := mem_Icc.mp hm
      have hyle : y ≤ N / m := by
        rw [Nat.le_div_iff_mul_le (by omega)]
        have := (Nat.le_div_iff_mul_le (by omega : 0 < y)).mp hm'.2
        linarith [mul_comm m y]
      unfold cnt
      have hs2 : Icc 1 (N / m) = Icc 1 y ∪ Ioc y (N / m) := by
        ext x; simp only [mem_union, mem_Icc, mem_Ioc]; omega
      have hd2 : Disjoint (Icc 1 y) (Ioc y (N / m)) := by
        rw [disjoint_left]; intro x h1 h2; simp only [mem_Icc, mem_Ioc] at h1 h2; omega
      rw [hs2, Finset.sum_union hd2]; ring
    rw [hbig, Finset.sum_sub_distrib, Finset.sum_const, Nat.card_Icc, nsmul_eq_mul]
    simp only [add_tsub_cancel_right]
    ring
  · -- y > N: the mirror is empty and the small side is everything
    have hz : N / y = 0 := Nat.div_eq_of_lt (by omega)
    rw [hz]
    simp only [Finset.Icc_eq_empty_of_lt (by omega : 0 < 1), Finset.sum_empty,
      Nat.cast_zero, zero_mul, sub_zero, add_zero]
    symm
    have hsplit : Icc 1 y = Icc 1 N ∪ Ioc N y := by
      ext x; simp only [mem_union, mem_Icc, mem_Ioc]; omega
    have hdisj : Disjoint (Icc 1 N) (Ioc N y) := by
      rw [disjoint_left]; intro x h1 h2; simp only [mem_Icc, mem_Ioc] at h1 h2; omega
    rw [hsplit, Finset.sum_union hdisj]
    have : ∑ d ∈ Ioc N y, c d * ((N / d : ℕ) : ℚ) = 0 := by
      refine Finset.sum_eq_zero fun d hd => ?_
      rw [Nat.div_eq_of_lt (by simp only [mem_Ioc] at hd; omega)]; simp
    rw [this, add_zero]

end HalfTaper

/-- info: 'HalfTaper.fold_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfTaper.fold_eq
