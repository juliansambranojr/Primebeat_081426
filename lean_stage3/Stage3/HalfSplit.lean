/-
# Stage3.HalfSplit — the sieve's rounding measured from Julian's half

`HalfSieve.netRounding_centered` measures every rounding of the sieve from one half, the
offset of the doubling's midpoint (`ignition_is_zeta_zero`: the half is `−ζ(0)`). Measured from
the half, the rounding of `N/d` is a sawtooth; it jumps exactly where `d ∣ N`. This file proves
the two exact facts the split of 2026-11-26 rests on (exploratory run in scratch):

  flag_sum      over the sieve's products that divide `N`, the signs add to `1` exactly when
                no prime up to `√N` divides `N`, and to `0` otherwise: the half's jumps flag
                whether `N` has a small prime factor
  fract_tail    a product `d > N` has `fract (N/d) = N/d`: past `N` the rounding is exact
-/
import Stage3.HalfSieve

namespace HalfSplit

open Finset SieveExact

/-- **The half's jumps flag the small factors of `N`.** -/
theorem flag_sum (N : ℕ) :
    ∑ T ∈ (smallPrimes N).powerset.filter (fun T => (∏ p ∈ T, p) ∣ N), (-1 : ℤ) ^ T.card
      = if ∀ p ∈ smallPrimes N, ¬ p ∣ N then 1 else 0 := by
  have hset : (smallPrimes N).powerset.filter (fun T => (∏ p ∈ T, p) ∣ N)
      = ((smallPrimes N).filter (· ∣ N)).powerset := by
    ext T
    simp only [mem_filter, mem_powerset]
    constructor
    · rintro ⟨hT, hd⟩ p hp
      refine mem_filter.mpr ⟨hT hp, ?_⟩
      exact (forall_dvd_iff_prod_dvd T (fun q hq => prime_of_mem_smallPrimes (hT hq)) N).mpr hd p hp
    · intro hT
      have hTS : T ⊆ smallPrimes N := fun p hp => (mem_filter.mp (hT hp)).1
      refine ⟨hTS, ?_⟩
      exact (forall_dvd_iff_prod_dvd T (fun q hq => prime_of_mem_smallPrimes (hTS hq)) N).mp
        (fun p hp => (mem_filter.mp (hT hp)).2)
  rw [hset, Finset.sum_powerset_neg_one_pow_card]
  congr 1
  apply propext
  rw [filter_eq_empty_iff]

/-- **Past `N` the rounding is exact.** -/
theorem fract_tail {N d : ℕ} (hd : N < d) : Int.fract ((N : ℚ) / (d : ℚ)) = (N : ℚ) / (d : ℚ) := by
  have hd0 : (0 : ℚ) < d := by exact_mod_cast (lt_of_le_of_lt (Nat.zero_le N) hd)
  rw [Int.fract_eq_self]
  constructor
  · positivity
  · rw [div_lt_one hd0]; exact_mod_cast hd

end HalfSplit

/-- info: 'HalfSplit.flag_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.flag_sum

/-- info: 'HalfSplit.fract_tail' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.fract_tail
