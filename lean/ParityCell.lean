/-
ParityCell — at a depth that is a power of two, a cell's parity is the parity of two rows.

By Lucas, `C(2^k, i)` is even for `0 < i < 2^k`, so the depth-`2^k` stencil keeps only its two end
terms mod 2: `tableFrom N r (2^k) ≡ N r + N (r − 2^k)` (`two_dvd_cell_two_pow`). When those two
rows have opposite parity the cell is odd, hence not zero (`ne_zero_of_parity`), from two numbers
of the row alone and nothing about its size.
-/
import Mathlib
import ZerosStencil

namespace ParityCell
open Finset

theorem two_dvd_cell_two_pow (N : ℤ → ℤ) (r : ℤ) (k : ℕ) :
    (2 : ℤ) ∣ Construction.tableFrom N r (2 ^ k) - (N r + N (r - (2 ^ k : ℕ))) := by
  rw [Zeros.tableFrom_eq_stencil, Zeros.stencil]
  obtain ⟨m, hm⟩ : ∃ m, 2 ^ k = m + 1 := ⟨2 ^ k - 1, by have := Nat.one_le_two_pow (n := k); omega⟩
  rw [hm, sum_range_succ, sum_range_succ']
  simp only [pow_zero, Nat.choose_zero_right, Nat.cast_one, one_mul, Nat.choose_self,
    mul_one, CharP.cast_eq_zero, sub_zero, Nat.cast_zero]
  -- the middle terms are even
  have hmid : (2 : ℤ) ∣ ∑ i ∈ range m, (-1 : ℤ) ^ (i + 1) * ((m + 1).choose (i + 1) : ℤ) * N (r - ((i + 1 : ℕ) : ℤ)) := by
    refine dvd_sum fun i hi => ?_
    have hi' := mem_range.mp hi
    have h2 : 2 ∣ (2 ^ k).choose (i + 1) :=
      Nat.Prime.dvd_choose_pow Nat.prime_two (by omega) (by omega)
    rw [hm] at h2
    exact Dvd.dvd.mul_right (Dvd.dvd.mul_left (by exact_mod_cast h2) _) _
  -- the end term carries (-1)^(m+1), which is ±1
  have hend : (2 : ℤ) ∣ (-1 : ℤ) ^ (m + 1) * N (r - ((m + 1 : ℕ) : ℤ)) - N (r - ((m + 1 : ℕ) : ℤ)) := by
    rcases neg_one_pow_eq_or ℤ (m + 1) with h | h
    · rw [h]; simp
    · rw [h]; exact ⟨-N (r - ((m + 1 : ℕ) : ℤ)), by ring⟩
  have e : (∑ i ∈ range m, (-1 : ℤ) ^ (i + 1) * ((m + 1).choose (i + 1) : ℤ) * N (r - ((i + 1 : ℕ) : ℤ))
      + N r + (-1 : ℤ) ^ (m + 1) * N (r - ((m + 1 : ℕ) : ℤ))) - (N r + N (r - ((m + 1 : ℕ) : ℤ)))
      = (∑ i ∈ range m, (-1 : ℤ) ^ (i + 1) * ((m + 1).choose (i + 1) : ℤ) * N (r - ((i + 1 : ℕ) : ℤ)))
        + ((-1 : ℤ) ^ (m + 1) * N (r - ((m + 1 : ℕ) : ℤ)) - N (r - ((m + 1 : ℕ) : ℤ))) := by ring
  push_cast at e ⊢
  rw [e]
  exact dvd_add hmid hend

/-- **Opposite-parity rows give a nonzero cell at a power-of-two depth.** -/
theorem ne_zero_of_parity (N : ℤ → ℤ) (r : ℤ) (k : ℕ)
    (h : ¬ (2 : ℤ) ∣ N r + N (r - (2 ^ k : ℕ))) :
    Construction.tableFrom N r (2 ^ k) ≠ 0 := by
  intro h0
  have := two_dvd_cell_two_pow N r k
  rw [h0, zero_sub, dvd_neg] at this
  exact h this

end ParityCell

/-- info: 'ParityCell.ne_zero_of_parity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ParityCell.ne_zero_of_parity
