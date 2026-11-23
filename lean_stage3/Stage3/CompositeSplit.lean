/-
CompositeSplit — block R10 of `lean_stage3/design/runs.md`. 2026-11-23.

The composite table has no signs. The sieve's sum counts a composite once for
every set of small primes dividing it and corrects with the Pascal signs. Each
composite has exactly one least prime. Counted under its least prime, every
composite is counted once, and every part is a positive count. The part of a
prime `p` is the same table at the scale `N/p`: the numbers up to `N/p` that no
prime below `p` divides.

  rough N p                 the numbers 1..N/p that no prime below p divides
  card_least_prime          p prime ⊢ #{n in 2..N : least prime p} = rough N p
  composites_by_least_prime #{composites up to N}
                              = Σ_{p ≤ √N} #{composites up to N with least prime p}
  composite_part            p prime, p ≤ N ⊢ that part, plus one for p itself,
                              is rough N p
  composites_no_signs       #{composites up to N} + #{primes up to √N}
                              = Σ_{p ≤ √N} rough N p

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.SieveExact
import Stage3.StepsRate

namespace CompositeSplit

open Finset SieveExact
open scoped Classical

/-- The numbers from `1` to `N/p` that no prime below `p` divides: the table at
the scale `N/p`, sieved by the primes below `p`. -/
noncomputable def rough (N p : ℕ) : ℕ :=
  ((Icc 1 (N / p)).filter (fun m => ∀ q : ℕ, q.Prime → q < p → ¬ q ∣ m)).card

/-- The numbers from `2` to `N` whose least prime is `p` are `p` times the
numbers up to `N/p` that no prime below `p` divides. -/
theorem least_prime_fiber (N : ℕ) {p : ℕ} (hp : p.Prime) :
    (Icc 2 N).filter (fun n => n.minFac = p)
      = ((Icc 1 (N / p)).filter (fun m => ∀ q : ℕ, q.Prime → q < p → ¬ q ∣ m)).image
          (fun m => p * m) := by
  ext n
  simp only [mem_filter, mem_Icc, mem_image]
  constructor
  · rintro ⟨⟨h2, hN⟩, hmin⟩
    have hdvd : p ∣ n := hmin ▸ Nat.minFac_dvd n
    obtain ⟨m, rfl⟩ := hdvd
    have hm1 : 1 ≤ m := Nat.pos_of_ne_zero (by rintro rfl; simp at h2)
    refine ⟨m, ⟨⟨hm1, ?_⟩, ?_⟩, rfl⟩
    · rw [Nat.le_div_iff_mul_le hp.pos, mul_comm]; exact hN
    · intro q hq hqp hqm
      have hle : (p * m).minFac ≤ q :=
        Nat.minFac_le_of_dvd hq.two_le (Dvd.dvd.mul_left hqm p)
      omega
  · rintro ⟨m, ⟨⟨hm1, hmN⟩, hrough⟩, rfl⟩
    have hp2 := hp.two_le
    rw [Nat.le_div_iff_mul_le hp.pos, mul_comm] at hmN
    have hn2 : 2 ≤ p * m := by nlinarith
    refine ⟨⟨hn2, hmN⟩, ?_⟩
    have hle : (p * m).minFac ≤ p := Nat.minFac_le_of_dvd hp2 (dvd_mul_right p m)
    have hqprime : (p * m).minFac.Prime := Nat.minFac_prime (by omega)
    have hqdvd : (p * m).minFac ∣ p * m := Nat.minFac_dvd _
    by_contra hne
    have hlt : (p * m).minFac < p := lt_of_le_of_ne hle hne
    rcases (Nat.Prime.dvd_mul hqprime).mp hqdvd with h | h
    · have := (Nat.prime_dvd_prime_iff_eq hqprime hp).mp h
      omega
    · exact hrough _ hqprime hlt h

/-- **The part of a prime.** The count of the numbers from `2` to `N` with
least prime `p` is the table's count at the scale `N/p`. -/
theorem card_least_prime (N : ℕ) {p : ℕ} (hp : p.Prime) :
    ((Icc 2 N).filter (fun n => n.minFac = p)).card = rough N p := by
  rw [least_prime_fiber N hp, rough]
  exact Finset.card_image_of_injective _ (mul_right_injective₀ hp.ne_zero)

/-- A composite up to `N` has its least prime among the primes up to `√N`. -/
theorem minFac_mem_smallPrimes {N n : ℕ} (h2 : 2 ≤ n) (hN : n ≤ N) (hc : ¬ n.Prime) :
    n.minFac ∈ smallPrimes N := by
  unfold smallPrimes
  rw [mem_filter, mem_range]
  refine ⟨?_, Nat.minFac_prime (by omega)⟩
  have hsq : n.minFac ^ 2 ≤ n := Nat.minFac_sq_le_self (by omega) hc
  have : n.minFac ≤ Nat.sqrt N := Nat.le_sqrt'.mpr (hsq.trans hN)
  omega

/-- **Every composite once, under its least prime.** No signs. -/
theorem composites_by_least_prime (N : ℕ) :
    ((Icc 2 N).filter (fun n => ¬ n.Prime)).card
      = ∑ p ∈ smallPrimes N,
          ((Icc 2 N).filter (fun n => ¬ n.Prime ∧ n.minFac = p)).card := by
  rw [Finset.card_eq_sum_card_fiberwise (f := Nat.minFac) (t := smallPrimes N)]
  · refine Finset.sum_congr rfl fun p _ => ?_
    rw [Finset.filter_filter]
  · intro n hn
    rw [Finset.mem_coe, mem_filter, mem_Icc] at hn
    exact minFac_mem_smallPrimes hn.1.1 hn.1.2 hn.2

/-- **A prime's part of the composites**, with the prime itself put back, is
the table's count at the scale `N/p`. -/
theorem composite_part (N : ℕ) {p : ℕ} (hp : p.Prime) (hpN : p ≤ N) :
    ((Icc 2 N).filter (fun n => ¬ n.Prime ∧ n.minFac = p)).card + 1 = rough N p := by
  rw [← card_least_prime N hp]
  have hnot : p ∉ (Icc 2 N).filter (fun n => ¬ n.Prime ∧ n.minFac = p) := by
    rw [mem_filter]
    rintro ⟨_, hnp, _⟩
    exact hnp hp
  have hins : (Icc 2 N).filter (fun n => n.minFac = p)
      = insert p ((Icc 2 N).filter (fun n => ¬ n.Prime ∧ n.minFac = p)) := by
    ext n
    simp only [mem_filter, mem_Icc, mem_insert]
    constructor
    · rintro ⟨hI, hmin⟩
      by_cases hn : n.Prime
      · left
        rw [← hmin, Nat.Prime.minFac_eq hn]
      · right
        exact ⟨hI, hn, hmin⟩
    · rintro (rfl | ⟨hI, _, hmin⟩)
      · exact ⟨⟨hp.two_le, hpN⟩, Nat.Prime.minFac_eq hp⟩
      · exact ⟨hI, hmin⟩
  rw [hins, Finset.card_insert_of_notMem hnot]

/-- **The composite table, no signs.** The composites up to `N`, with one for
each prime up to `√N`, are the sum over those primes of the table's count at
the scale `N/p`. Every term is a count. -/
theorem composites_no_signs (N : ℕ) :
    ((Icc 2 N).filter (fun n => ¬ n.Prime)).card + (smallPrimes N).card
      = ∑ p ∈ smallPrimes N, rough N p := by
  rw [composites_by_least_prime, Finset.card_eq_sum_ones, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun p hp => ?_
  have hp' := hp
  unfold smallPrimes at hp'
  rw [mem_filter, mem_range] at hp'
  have hpN : p ≤ N := by
    have := Nat.sqrt_le_self N
    omega
  exact composite_part N hp'.2 hpN

/-- info: 'CompositeSplit.card_least_prime' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms card_least_prime

/-- info: 'CompositeSplit.composites_by_least_prime' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms composites_by_least_prime

/-- info: 'CompositeSplit.composites_no_signs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms composites_no_signs

end CompositeSplit
