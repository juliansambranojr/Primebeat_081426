/-
# Stage3.PrimeStepTop — a prime's step above the cube root is a count of primes

For a prime `p` with `N/p < p²` (every `p` above `N^{1/3}`), the numbers up to `M = ⌊N/p⌋` that
no prime below `p` divides are `1` and the primes from `p` to `M`. So, by `PrimeStep.step_eq`,
that prime's step in the sieve's net rounding is `1 + #{primes in [p, N/p]}` less its smooth
part: the prime count's own error at the two scales `N/p` and `p`.
-/
import Stage3.PrimeStep

namespace PrimeStepTop

open Finset

open Classical in
/-- **Above the cube root the rough numbers are 1 and primes.** -/
theorem rough_eq_one_add_primes {p M : ℕ} (hp : p.Prime) (hM : M < p * p) (h1 : 1 ≤ M) :
    ((Icc 1 M).filter (fun m => ∀ q : ℕ, q.Prime → q < p → ¬ q ∣ m)).card
      = 1 + ((Icc p M).filter Nat.Prime).card := by
  have hset : (Icc 1 M).filter (fun m => ∀ q : ℕ, q.Prime → q < p → ¬ q ∣ m)
      = insert 1 ((Icc p M).filter Nat.Prime) := by
    ext m
    simp only [mem_filter, mem_Icc, mem_insert]
    constructor
    · rintro ⟨⟨hm1, hmM⟩, hq⟩
      by_cases h : m = 1
      · exact Or.inl h
      · right
        have hm2 : 2 ≤ m := by omega
        have hmin := Nat.minFac_prime (show m ≠ 1 from h)
        have hge : p ≤ m.minFac := by
          by_contra hlt
          exact hq _ hmin (by omega) (Nat.minFac_dvd m)
        have hprime : m.Prime := by
          by_contra hnp
          have hsq := Nat.minFac_sq_le_self (by omega : 0 < m) hnp
          have : p * p ≤ m := le_trans (Nat.mul_le_mul hge hge) (by simpa [sq] using hsq)
          omega
        exact ⟨⟨le_trans hge (Nat.minFac_le (by omega)), hmM⟩, hprime⟩
    · rintro (h | ⟨⟨hpm, hmM⟩, hmp⟩)
      · subst h
        refine ⟨⟨le_refl 1, h1⟩, fun q hq _ hdvd => ?_⟩
        exact hq.one_lt.ne' (Nat.dvd_one.mp hdvd)
      · refine ⟨⟨le_trans hp.one_lt.le hpm, hmM⟩, fun q hq hqp hdvd => ?_⟩
        have := (Nat.prime_dvd_prime_iff_eq hq hmp).mp hdvd
        omega
  rw [hset, card_insert_of_notMem]
  · ring
  · simp only [mem_filter, not_and]
    intro _ h
    exact Nat.not_prime_one h

end PrimeStepTop

/-- info: 'PrimeStepTop.rough_eq_one_add_primes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PrimeStepTop.rough_eq_one_add_primes

namespace PrimeStepTop

open Finset

open Classical in
/-- **A top prime's count in the net rounding.** For `p ∈ smallPrimes N` with `N / p < p²`, the
count in `PrimeStep.net_by_steps` (the numbers up to `⌊N/p⌋` that no smaller prime up to `√N`
divides) is `1` plus the primes from `p` to `⌊N/p⌋`. -/
theorem step_count_top {N p : ℕ} (hp : p ∈ SieveExact.smallPrimes N) (hM : N / p < p * p) :
    ((Icc 1 (N / p)).filter
        (fun m => ∀ q ∈ (SieveExact.smallPrimes N).filter (· < p), ¬ q ∣ m)).card
      = 1 + ((Icc p (N / p)).filter Nat.Prime).card := by
  have hpp : p.Prime := SieveExact.prime_of_mem_smallPrimes hp
  have hpsq : p ≤ Nat.sqrt N := by
    have := (mem_filter.mp hp).1; rw [mem_range] at this; omega
  have hpN : p * p ≤ N := by
    have := Nat.sqrt_le N
    exact le_trans (Nat.mul_le_mul hpsq hpsq) this
  have h1 : 1 ≤ N / p := by
    rw [Nat.le_div_iff_mul_le hpp.pos]; nlinarith [hpp.one_lt]
  rw [← rough_eq_one_add_primes hpp hM h1]
  congr 1
  ext m
  simp only [mem_filter, mem_Icc, SieveExact.smallPrimes, mem_range]
  constructor
  · rintro ⟨hm, h⟩
    exact ⟨hm, fun q hq hqp => h q ⟨⟨by omega, hq⟩, hqp⟩⟩
  · rintro ⟨hm, h⟩
    exact ⟨hm, fun q ⟨⟨_, hq⟩, hqp⟩ => h q hq hqp⟩

end PrimeStepTop

/-- info: 'PrimeStepTop.step_count_top' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PrimeStepTop.step_count_top
