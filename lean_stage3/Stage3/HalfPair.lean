/-
# Stage3.HalfPair — two of the sieve's roundings, paired, measured from Julian's half

Unit 0588: the wobble's square root lives only in the whole, so look at the whole through its
pairs. Measured from the half, the rounding of `k/a` is `B₁(fract(k/a)) = (k mod a)/a − 1/2`.
Over one common period two of them average to

    (gcd(a,b)² + 2) / (12ab),

checked in exact fractions (scratch, 2026-11-26). Franel's identity (1924) is the continuous
average `gcd²/(12ab)`; the `+2` is the half itself, the value `−1/2 = ζ(0)` the sawtooth takes at
the whole numbers. This file builds it, starting with the parts any period needs.
-/
import Mathlib

namespace HalfPair

open Finset

/-- The rounding of `k/a` measured from the half. -/
def saw (a k : ℕ) : ℚ := ((k % a : ℕ) : ℚ) / a - 1 / 2

/-- **One period of the half's sawtooth sums to minus a half.** -/
theorem sum_saw_period {a : ℕ} (ha : 0 < a) : ∑ k ∈ range a, saw a k = -(1 / 2) := by
  have hmod : ∀ k ∈ range a, k % a = k := fun k hk => Nat.mod_eq_of_lt (mem_range.mp hk)
  have ha' : (a : ℚ) ≠ 0 := by exact_mod_cast ha.ne'
  rw [Finset.sum_congr rfl fun k hk => by rw [saw, hmod k hk]]
  rw [Finset.sum_sub_distrib, ← Finset.sum_div, Finset.sum_const, card_range, nsmul_eq_mul]
  have hg := Finset.sum_range_id_mul_two a
  have hs : (∑ i ∈ range a, (i : ℚ)) = (a : ℚ) * (a - 1) / 2 := by
    have : ((∑ i ∈ range a, i : ℕ) : ℚ) * 2 = (a : ℚ) * ((a - 1 : ℕ) : ℚ) := by exact_mod_cast hg
    rw [Nat.cast_sub (by omega : 1 ≤ a)] at this
    push_cast at this
    linarith
  rw [hs]
  field_simp
  ring

/-- **A product period splits into blocks.** `k < a·b` is `k = a·q + r`, `q < b`, `r < a`. -/
theorem sum_blocks (F : ℕ → ℚ) (a b : ℕ) :
    ∑ k ∈ range (a * b), F k = ∑ q ∈ range b, ∑ r ∈ range a, F (a * q + r) := by
  induction b with
  | zero => simp
  | succ b ih =>
    rw [Nat.mul_succ, Finset.sum_range_add, ih, Finset.sum_range_succ]

end HalfPair

/-- info: 'HalfPair.sum_saw_period' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.sum_saw_period

/-- info: 'HalfPair.sum_blocks' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.sum_blocks
