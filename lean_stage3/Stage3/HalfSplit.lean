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

namespace HalfSplit

open Finset SieveExact

/-- The sieve's products up to `N`. -/
def lowT (N : ℕ) : Finset (Finset ℕ) := (smallPrimes N).powerset.filter (fun T => (∏ p ∈ T, p) ≤ N)

/-- The sieve's products past `N`. -/
def highT (N : ℕ) : Finset (Finset ℕ) := (smallPrimes N).powerset.filter (fun T => ¬ (∏ p ∈ T, p) ≤ N)

/-- **The net rounding, split at `N`.** The roundings of the products up to `N`, plus the
products past `N`, each contributing exactly `N/d`. -/
theorem net_split (N : ℕ) :
    netRounding N =
      ∑ T ∈ lowT N, (-1 : ℚ) ^ T.card * Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ))
      + ∑ T ∈ highT N, (-1 : ℚ) ^ T.card * ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) := by
  unfold netRounding lowT highT
  rw [← Finset.sum_filter_add_sum_filter_not _ (fun T => (∏ p ∈ T, p) ≤ N)]
  congr 1
  refine Finset.sum_congr rfl fun T hT => ?_
  rw [fract_tail (not_le.mp (mem_filter.mp hT).2)]

/-- **The tail meets the product.** The smooth part less the tail is the exact fractions of
the products up to `N` alone. -/
theorem smooth_less_tail (N : ℕ) :
    smoothPart N - ∑ T ∈ highT N, (-1 : ℚ) ^ T.card * ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ))
      = ∑ T ∈ lowT N, (-1 : ℚ) ^ T.card * ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) := by
  unfold smoothPart lowT highT
  rw [← Finset.sum_filter_add_sum_filter_not _ (fun T => (∏ p ∈ T, p) ≤ N)]
  ring

/-- **The survivors are the floors of the products up to `N`.** With the tail gone, the
sieve's count is the signed floors `⌊N/d⌋` over the products `d ≤ N`. -/
theorem survivors_low (N : ℕ) :
    ((survivors N).card : ℚ) =
      ∑ T ∈ lowT N, (-1 : ℚ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℚ) := by
  rw [sieve_split, net_split]
  have h := smooth_less_tail N
  rw [show ∀ a b c : ℚ, a - (b + c) = (a - c) - b from fun a b c => by ring, h,
    ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun T _ => ?_
  rw [natDiv_eq_sub_fract]
  ring

end HalfSplit

/-- info: 'HalfSplit.net_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.net_split

/-- info: 'HalfSplit.smooth_less_tail' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.smooth_less_tail

/-- info: 'HalfSplit.survivors_low' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.survivors_low

namespace HalfSplit

open Finset SieveExact

/-- **The wobble through the products up to `N` alone.** The sieve's wobble is the smooth
counts `1 + Li N − Li √N` less the signed floors `⌊N/d⌋` of the products `d ≤ N`. Every
product past `N` has dropped out. -/
theorem wobble_low (N : ℕ) :
    HalfSieve.wobble N = 1 + Stage3.Li (N : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ) : ℝ)
      - ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℝ) := by
  have hs := sieve_split N
  rw [survivors_low, smoothPart_eq_prod] at hs
  have hnet : netRounding N = (N : ℚ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℚ))
      - ∑ T ∈ lowT N, (-1 : ℚ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℚ) := by linarith
  unfold HalfSieve.wobble SieveResidual.smoothNet
  rw [hnet]
  push_cast
  ring

end HalfSplit

/-- info: 'HalfSplit.wobble_low' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.wobble_low

namespace HalfSplit

open Finset SieveExact

/-- **The low part measured from the half.** Each floor `⌊N/d⌋` is `N/d` less its rounding, and
the rounding is measured from Julian's half: the wobble is the smooth counts, less the exact
fractions of the products up to `N`, plus their centered roundings, plus half their signs. -/
theorem wobble_centered_low (N : ℕ) :
    HalfSieve.wobble N = 1 + Stage3.Li (N : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ) : ℝ)
      - ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card * ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ))
      + ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
          (((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) - 1 / 2)
      + (1 / 2) * ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card := by
  rw [wobble_low]
  have key : ∀ T ∈ lowT N, (-1 : ℝ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℝ)
      = (-1 : ℝ) ^ T.card * ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ))
        - (-1 : ℝ) ^ T.card * (((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) - 1 / 2)
        - (1 / 2) * (-1 : ℝ) ^ T.card := by
    intro T _
    have h := natDiv_eq_sub_fract N (∏ p ∈ T, p)
    have h' : ((N / ∏ p ∈ T, p : ℕ) : ℝ) = (N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ)
        - ((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) := by
      have := congrArg (fun q : ℚ => (q : ℝ)) h
      push_cast at this ⊢
      exact this
    rw [h']; ring
  rw [Finset.sum_congr rfl key, Finset.sum_sub_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum]
  ring

end HalfSplit

/-- info: 'HalfSplit.wobble_centered_low' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.wobble_centered_low
