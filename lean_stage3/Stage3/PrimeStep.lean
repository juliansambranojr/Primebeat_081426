/-
# Stage3.PrimeStep — a prime's step in the sieve's rounding

Unit 0499 measured each prime's step: the signed roundings of the sieve's terms whose
largest prime is `p`, and found that each step follows the one before it. Unit 0586
checked, in exact fractions, that the step is a count less its smooth expectation. This
file proves it for any finite set `S` of primes and any `p ≥ 1`: summed over the subsets
`T` of `S`, the roundings of `N / (p ∏ T)` with sign `(-1)^(|T|+1)` are the numbers up to
`⌊N/p⌋` that no prime of `S` divides, less `(N/p) ∏_{q ∈ S} (1 - 1/q)`.

With `S` the primes below `p`, the count is `CompositeSplit.rough N p`, so a prime's step
is the sieve at the scale `N/p` by the primes below `p`, less its smooth part.
-/
import Stage3.SieveExact

namespace PrimeStep

open Finset

/-- **A prime's step.** -/
theorem step_eq (S : Finset ℕ) (hS : ∀ q ∈ S, q.Prime) (N p : ℕ) :
    ∑ T ∈ S.powerset, (-1 : ℚ) ^ (T.card + 1) *
        Int.fract ((N : ℚ) / ((p * ∏ q ∈ T, q : ℕ) : ℚ))
      = (((Icc 1 (N / p)).filter (fun m => ∀ q ∈ S, ¬ q ∣ m)).card : ℚ)
        - ((N : ℚ) / (p : ℚ)) * ∏ q ∈ S, (1 - 1 / (q : ℚ)) := by
  -- the count, by inclusion and exclusion
  have hcount : (((Icc 1 (N / p)).filter (fun m => ∀ q ∈ S, ¬ q ∣ m)).card : ℚ) =
      ∑ T ∈ S.powerset, (-1 : ℚ) ^ T.card * (((N / p) / ∏ q ∈ T, q : ℕ) : ℚ) := by
    have h0 := congrArg (fun z : ℤ => (z : ℚ)) (SieveExact.card_filter_not_dvd (Icc 1 (N / p)) S hS)
    simp only [Int.cast_natCast, Int.cast_sum, Int.cast_mul, Int.cast_pow, Int.cast_neg,
      Int.cast_one] at h0
    rw [h0]
    refine Finset.sum_congr rfl fun T _ => ?_
    rw [SieveExact.card_multiples]
  -- the product
  have hprod : ((N : ℚ) / (p : ℚ)) * ∏ q ∈ S, (1 - 1 / (q : ℚ)) =
      ∑ T ∈ S.powerset, (-1 : ℚ) ^ T.card * ((N : ℚ) / ((p * ∏ q ∈ T, q : ℕ) : ℚ)) := by
    have hs := Finset.prod_sub (fun _ => (1 : ℚ)) (fun q : ℕ => 1 / (q : ℚ)) S
    rw [hs, Finset.mul_sum]
    refine Finset.sum_congr rfl fun T _ => ?_
    simp only [Finset.prod_const_one, mul_one, Nat.cast_mul, Nat.cast_prod, one_div,
      Finset.prod_inv_distrib]
    by_cases hp : (p : ℚ) = 0
    · simp [hp]
    · field_simp
  rw [hcount, hprod, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun T _ => ?_
  have hdiv : (N / p) / ∏ q ∈ T, q = N / (p * ∏ q ∈ T, q) := Nat.div_div_eq_div_mul N p _
  rw [hdiv, SieveExact.natDiv_eq_sub_fract]
  ring

end PrimeStep

/-- info: 'PrimeStep.step_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PrimeStep.step_eq
