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

namespace PrimeStep

open Finset

/-- **The subsets, by their largest element.** For a finite set `S` of naturals, a sum over
its subsets is the empty subset's term plus, for each `p ∈ S`, the sum over the subsets of the
elements of `S` below `p`, with `p` put in. -/
theorem sum_powerset_by_max {β : Type*} [AddCommMonoid β] (g : Finset ℕ → β) (S : Finset ℕ) :
    ∑ T ∈ S.powerset, g T =
      g ∅ + ∑ p ∈ S, ∑ t ∈ (S.filter (· < p)).powerset, g (insert p t) := by
  refine Finset.induction_on_max S (by simp) ?_
  intro a s ha ih
  have has : a ∉ s := fun h => lt_irrefl a (ha a h)
  rw [Finset.sum_powerset_insert has, ih, Finset.sum_insert has, add_assoc]
  congr 1
  have hfa : (insert a s).filter (· < a) = s := by
    ext x; simp only [mem_filter, mem_insert]
    constructor
    · rintro ⟨hx | hx, hlt⟩
      · exact absurd hx (ne_of_lt hlt)
      · exact hx
    · intro hx; exact ⟨Or.inr hx, ha x hx⟩
  have hfx : ∀ x ∈ s, (insert a s).filter (· < x) = s.filter (· < x) := by
    intro x hx
    ext y; simp only [mem_filter, mem_insert]
    constructor
    · rintro ⟨hy | hy, hlt⟩
      · subst hy; exact absurd (lt_trans hlt (ha x hx)) (lt_irrefl _)
      · exact ⟨hy, hlt⟩
    · rintro ⟨hy, hlt⟩; exact ⟨Or.inr hy, hlt⟩
  rw [hfa, add_comm]
  congr 1
  exact Finset.sum_congr rfl fun x hx => by rw [hfx x hx]

end PrimeStep

/-- info: 'PrimeStep.sum_powerset_by_max' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PrimeStep.sum_powerset_by_max

namespace PrimeStep

open Finset

/-- **The net rounding is the sum of the primes' steps.** Grouped by largest prime, the sieve's
net rounding at `N` is, over the primes `p ≤ √N`, the numbers up to `⌊N/p⌋` that no smaller
prime up to `√N` divides, less their smooth part `(N/p) ∏ (1 - 1/q)`. -/
theorem net_by_steps (N : ℕ) :
    (SieveExact.netRounding N : ℚ) =
      ∑ p ∈ SieveExact.smallPrimes N,
        ((((Icc 1 (N / p)).filter
            (fun m => ∀ q ∈ (SieveExact.smallPrimes N).filter (· < p), ¬ q ∣ m)).card : ℚ)
          - ((N : ℚ) / (p : ℚ)) *
              ∏ q ∈ (SieveExact.smallPrimes N).filter (· < p), (1 - 1 / (q : ℚ))) := by
  unfold SieveExact.netRounding
  rw [sum_powerset_by_max]
  simp only [card_empty, pow_zero, prod_empty, Nat.cast_one, div_one, one_mul]
  rw [show Int.fract ((N : ℚ)) = 0 from Int.fract_natCast N, zero_add]
  refine Finset.sum_congr rfl fun p hp => ?_
  rw [← step_eq _ (fun q hq => SieveExact.prime_of_mem_smallPrimes (mem_filter.mp hq).1) N p]
  refine Finset.sum_congr rfl fun t ht => ?_
  have hpt : p ∉ t := fun h => lt_irrefl p (mem_filter.mp (mem_powerset.mp ht h)).2
  rw [card_insert_of_notMem hpt, prod_insert hpt]

end PrimeStep

/-- info: 'PrimeStep.net_by_steps' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PrimeStep.net_by_steps
