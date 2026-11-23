/-
# Stage3.SieveExact — the sieve of Legendre, exactly

Block R2 of `lean_stage3/design/runs.md` ("The sieve, exactly"). An exploratory
run (unit 0475) checked on rows 10..24 that the number of primes up to `2^r` is
given exactly by the sieve of Legendre from the primes up to `2^(r/2)`. This
module proves that identity for every `N`, with nothing computed.

Statements:
* `survivors_eq` — for `2 ≤ N`, the survivors of the sieve are `1` and the
  primes in `(√N, N]`.
* `card_survivors` — for `2 ≤ N`, `#survivors + π(√N) = 1 + π(N)`.
* `sieve_sum` — inclusion and exclusion: `#survivors = Σ_{T ⊆ P(√N)} (-1)^|T| ⌊N / ∏T⌋`.
* `pi_by_sieve` — for `2 ≤ N`, `π(N) = π(√N) - 1 + Σ_T (-1)^|T| ⌊N / ∏T⌋`.
* `sieve_by_level`, `sieve_by_level_sign`, `level_card` — the same sum arranged
  by level `k = |T|`; level `k` has `choose (#P(√N)) k` terms.
* `sieve_split` — over ℚ, `#survivors = smoothPart - netRounding`.
* `smoothPart_eq_prod` — `smoothPart N = N · ∏_{p ≤ √N} (1 - 1/p)`.
* `abs_netRounding_le`, `roundingMass_nonneg` — the net rounding is bounded by
  the rounding mass, which is nonnegative.
* `row_by_sieve` — `pi_by_sieve` at `N = 2^r`, the table's row.
-/
import Mathlib

namespace SieveExact

open Finset

/-- The primes up to the square root of `N`. -/
def smallPrimes (N : ℕ) : Finset ℕ := (Finset.range (Nat.sqrt N + 1)).filter Nat.Prime

/-- The integers from 1 to `N` that no prime up to `√N` divides. -/
def survivors (N : ℕ) : Finset ℕ :=
  (Finset.Icc 1 N).filter (fun n => ∀ p ∈ smallPrimes N, ¬ p ∣ n)

/-- Every member of `smallPrimes N` is prime. -/
lemma prime_of_mem_smallPrimes {N p : ℕ} (hp : p ∈ smallPrimes N) : p.Prime :=
  (Finset.mem_filter.1 hp).2

/-- For a set of primes, all of them divide `n` exactly when their product does. -/
lemma forall_dvd_iff_prod_dvd (T : Finset ℕ) (hT : ∀ p ∈ T, p.Prime) (n : ℕ) :
    (∀ p ∈ T, p ∣ n) ↔ (∏ p ∈ T, p) ∣ n :=
  ⟨fun h => Finset.prod_primes_dvd n (fun p hp => (hT p hp).prime) h,
   fun h _ hp => (Finset.dvd_prod_of_mem _ hp).trans h⟩

/-- Inclusion and exclusion over any finite set `A`: the members of `A` that no prime
of `s` divides, counted as an alternating sum of the members that the products of
subsets of `s` divide. -/
lemma card_filter_not_dvd (A s : Finset ℕ) (hs : ∀ p ∈ s, p.Prime) :
    ((A.filter (fun n => ∀ p ∈ s, ¬ p ∣ n)).card : ℤ) =
      ∑ T ∈ s.powerset, (-1 : ℤ) ^ T.card *
        ((A.filter (fun n => (∏ p ∈ T, p) ∣ n)).card : ℤ) := by
  have key : ∀ n, (if ∀ p ∈ s, ¬ p ∣ n then (1 : ℤ) else 0) =
      ∑ T ∈ s.powerset, (-1 : ℤ) ^ T.card * (if (∏ p ∈ T, p) ∣ n then 1 else 0) := by
    intro n
    rw [← Finset.prod_boole]
    have h1 : ∏ p ∈ s, (if ¬ p ∣ n then (1 : ℤ) else 0) =
        ∏ p ∈ s, ((fun _ => (1 : ℤ)) p - (fun p => if p ∣ n then (1 : ℤ) else 0) p) := by
      refine Finset.prod_congr rfl fun p _ => ?_
      by_cases h : p ∣ n <;> simp [h]
    rw [h1, Finset.prod_sub]
    refine Finset.sum_congr rfl fun T hT => ?_
    rw [Finset.mem_powerset] at hT
    simp only [Finset.prod_const_one, mul_one]
    rw [Finset.prod_boole]
    congr 1
    exact if_congr (forall_dvd_iff_prod_dvd T (fun p hp => hs p (hT hp)) n) rfl rfl
  rw [Finset.natCast_card_filter]
  simp_rw [key, Finset.natCast_card_filter]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun T _ => ?_
  rw [Finset.mul_sum]

/-- The multiples of `d` in `[1, N]` number `N / d`. -/
lemma card_multiples (N d : ℕ) : ((Finset.Icc 1 N).filter (fun n => d ∣ n)).card = N / d := by
  have : Finset.Icc 1 N = Finset.Ioc 0 N := by
    ext n; simp only [Finset.mem_Icc, Finset.mem_Ioc]; omega
  rw [this, Nat.Ioc_filter_dvd_card_eq_div]

/-- Inclusion and exclusion: the survivors of the sieve number the alternating sum, over
the sets `T` of primes up to `√N`, of `⌊N / ∏ T⌋`. -/
theorem sieve_sum (N : ℕ) :
    ((survivors N).card : ℤ) =
      ∑ T ∈ (smallPrimes N).powerset, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ) := by
  unfold survivors
  rw [card_filter_not_dvd _ _ (fun p hp => prime_of_mem_smallPrimes hp)]
  refine Finset.sum_congr rfl fun T _ => ?_
  rw [card_multiples]

/-- info: 'SieveExact.sieve_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sieve_sum

/-- For `2 ≤ N`, the survivors of the sieve are `1` and the primes above `√N` up to `N`. -/
theorem survivors_eq (N : ℕ) (hN : 2 ≤ N) :
    survivors N = insert 1 ((Finset.Icc 1 N).filter (fun n => Nat.Prime n ∧ Nat.sqrt N < n)) := by
  ext n
  simp only [survivors, smallPrimes, Finset.mem_insert, Finset.mem_filter, Finset.mem_Icc,
    Finset.mem_range]
  constructor
  · rintro ⟨⟨h1, hn⟩, hp⟩
    by_cases hn1 : n = 1
    · exact Or.inl hn1
    right
    refine ⟨⟨h1, hn⟩, ?_⟩
    by_cases hprime : n.Prime
    · refine ⟨hprime, ?_⟩
      rw [← not_le]
      intro hle
      exact hp n ⟨by omega, hprime⟩ dvd_rfl
    · exfalso
      have hmin : (Nat.minFac n).Prime := Nat.minFac_prime hn1
      have hsq := Nat.minFac_sq_le_self (by omega) hprime
      have hle : Nat.minFac n ≤ Nat.sqrt N := Nat.le_sqrt'.2 (hsq.trans hn)
      exact hp _ ⟨by omega, hmin⟩ (Nat.minFac_dvd n)
  · rintro (h | ⟨⟨h1, hn⟩, hprime, hlt⟩)
    · subst h
      refine ⟨⟨le_refl _, by omega⟩, fun p ⟨_, hp⟩ hdvd => ?_⟩
      exact hp.ne_one (Nat.dvd_one.1 hdvd)
    · refine ⟨⟨h1, hn⟩, fun p ⟨hpl, hp⟩ hdvd => ?_⟩
      rcases (Nat.dvd_prime hprime).1 hdvd with h | h
      · exact hp.ne_one h
      · omega

/-- For `2 ≤ N`, the survivors together with the primes up to `√N` number one more
than the primes up to `N`. -/
theorem card_survivors (N : ℕ) (hN : 2 ≤ N) :
    (survivors N).card + Nat.primeCounting (Nat.sqrt N) = 1 + Nat.primeCounting N := by
  rw [survivors_eq N hN, Finset.card_insert_of_notMem (by simp [Nat.not_prime_one])]
  rw [← Nat.primesLE_card_eq_primeCounting, ← Nat.primesLE_card_eq_primeCounting]
  have hsq : Nat.sqrt N ≤ N := Nat.sqrt_le_self N
  have hdisj : Disjoint ((Finset.Icc 1 N).filter (fun n => Nat.Prime n ∧ Nat.sqrt N < n))
      (Nat.primesLE (Nat.sqrt N)) := by
    rw [Finset.disjoint_left]
    intro a ha hb
    rw [Finset.mem_filter] at ha
    rw [Nat.mem_primesLE] at hb
    omega
  have hunion : (Finset.Icc 1 N).filter (fun n => Nat.Prime n ∧ Nat.sqrt N < n) ∪
      Nat.primesLE (Nat.sqrt N) = Nat.primesLE N := by
    ext a
    simp only [Finset.mem_union, Finset.mem_filter, Finset.mem_Icc, Nat.mem_primesLE]
    constructor
    · rintro (⟨⟨_, h⟩, hp, _⟩ | ⟨h, hp⟩)
      · exact ⟨h, hp⟩
      · exact ⟨h.trans hsq, hp⟩
    · rintro ⟨h, hp⟩
      by_cases hl : Nat.sqrt N < a
      · exact Or.inl ⟨⟨hp.one_lt.le, h⟩, hp, hl⟩
      · exact Or.inr ⟨by omega, hp⟩
  rw [← hunion, Finset.card_union_of_disjoint hdisj]
  omega

/-- For `2 ≤ N`, the number of primes up to `N` from the primes up to `√N` alone:
`π(N) = π(√N) - 1 + Σ_T (-1)^|T| ⌊N / ∏ T⌋`. -/
theorem pi_by_sieve (N : ℕ) (hN : 2 ≤ N) :
    (Nat.primeCounting N : ℤ) = (Nat.primeCounting (Nat.sqrt N) : ℤ) - 1 +
      ∑ T ∈ (smallPrimes N).powerset, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ) := by
  rw [← sieve_sum]
  have h := card_survivors N hN
  have h' : ((survivors N).card : ℤ) + (Nat.primeCounting (Nat.sqrt N) : ℤ) =
      1 + (Nat.primeCounting N : ℤ) := by exact_mod_cast h
  linarith

/-- info: 'SieveExact.pi_by_sieve' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pi_by_sieve

/-- The ladder: `pi_by_sieve` at `N = 2 ^ r`, the table's row `r`. -/
theorem row_by_sieve (r : ℕ) (hr : 1 ≤ r) :
    (Nat.primeCounting (2 ^ r) : ℤ) = (Nat.primeCounting (Nat.sqrt (2 ^ r)) : ℤ) - 1 +
      ∑ T ∈ (smallPrimes (2 ^ r)).powerset,
        (-1 : ℤ) ^ T.card * ((2 ^ r / ∏ p ∈ T, p : ℕ) : ℤ) := by
  have h2 : 2 ≤ 2 ^ r := by
    calc 2 = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ r := Nat.pow_le_pow_right (by norm_num) hr
  exact pi_by_sieve (2 ^ r) h2

/-- info: 'SieveExact.row_by_sieve' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms row_by_sieve

/-- The sieve's sum arranged by level: the sets `T` grouped by their size `k`. -/
theorem sieve_by_level (N : ℕ) :
    ∑ T ∈ (smallPrimes N).powerset, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ) =
      ∑ k ∈ Finset.range ((smallPrimes N).card + 1),
        ∑ T ∈ (smallPrimes N).powersetCard k, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ) :=
  Finset.sum_powerset _ _

/-- The sum by level with the sign of each level pulled out: level `k` carries `(-1)^k`. -/
theorem sieve_by_level_sign (N : ℕ) :
    ∑ T ∈ (smallPrimes N).powerset, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ) =
      ∑ k ∈ Finset.range ((smallPrimes N).card + 1),
        (-1 : ℤ) ^ k * ∑ T ∈ (smallPrimes N).powersetCard k, ((N / ∏ p ∈ T, p : ℕ) : ℤ) := by
  rw [sieve_by_level]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun T hT => ?_
  rw [(Finset.mem_powersetCard.1 hT).2]

/-- The number of terms at level `k` is a binomial coefficient: a row of Pascal. -/
theorem level_card (N k : ℕ) :
    ((smallPrimes N).powersetCard k).card = ((smallPrimes N).card).choose k :=
  Finset.card_powersetCard _ _

/-- info: 'SieveExact.level_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms level_card

/-- The exact-fraction part of the sieve's sum. -/
def smoothPart (N : ℕ) : ℚ :=
  ∑ T ∈ (smallPrimes N).powerset, (-1 : ℚ) ^ T.card * ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ))

/-- The net of the roundings, with their signs. -/
def netRounding (N : ℕ) : ℚ :=
  ∑ T ∈ (smallPrimes N).powerset, (-1 : ℚ) ^ T.card * Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ))

/-- The roundings added in size. -/
def roundingMass (N : ℕ) : ℚ :=
  ∑ T ∈ (smallPrimes N).powerset, Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ))

/-- A natural quotient is the exact fraction less its fractional part. -/
lemma natDiv_eq_sub_fract (n d : ℕ) :
    ((n / d : ℕ) : ℚ) = (n : ℚ) / (d : ℚ) - Int.fract ((n : ℚ) / (d : ℚ)) := by
  rw [Int.self_sub_fract, Rat.floor_natCast_div_natCast]
  rfl

/-- The survivors' count is the exact-fraction part less the net of the roundings. -/
theorem sieve_split (N : ℕ) : ((survivors N).card : ℚ) = smoothPart N - netRounding N := by
  have h : ((survivors N).card : ℚ) =
      ∑ T ∈ (smallPrimes N).powerset, (-1 : ℚ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℚ) := by
    have h0 := congrArg (fun z : ℤ => (z : ℚ)) (sieve_sum N)
    simp only [Int.cast_natCast, Int.cast_sum, Int.cast_mul, Int.cast_pow, Int.cast_neg,
      Int.cast_one] at h0
    exact h0
  rw [h, smoothPart, netRounding, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun T _ => ?_
  rw [natDiv_eq_sub_fract]
  ring

/-- info: 'SieveExact.sieve_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sieve_split

/-- The exact-fraction part is `N` times the product of `1 - 1/p` over the primes up to `√N`. -/
theorem smoothPart_eq_prod (N : ℕ) :
    smoothPart N = (N : ℚ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℚ)) := by
  have hs := Finset.prod_sub (fun _ => (1 : ℚ)) (fun p : ℕ => 1 / (p : ℚ)) (smallPrimes N)
  rw [hs, Finset.mul_sum, smoothPart]
  refine Finset.sum_congr rfl fun T _ => ?_
  simp only [Finset.prod_const_one, mul_one, Nat.cast_prod, one_div, Finset.prod_inv_distrib]
  ring

/-- info: 'SieveExact.smoothPart_eq_prod' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms smoothPart_eq_prod

/-- The net of the roundings is at most their mass in size. -/
theorem abs_netRounding_le (N : ℕ) : |netRounding N| ≤ roundingMass N := by
  unfold netRounding roundingMass
  refine (Finset.abs_sum_le_sum_abs _ _).trans (le_of_eq ?_)
  refine Finset.sum_congr rfl fun T _ => ?_
  rw [abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul, abs_of_nonneg (Int.fract_nonneg _)]

/-- The rounding mass is nonnegative. -/
theorem roundingMass_nonneg (N : ℕ) : 0 ≤ roundingMass N :=
  Finset.sum_nonneg fun _ _ => Int.fract_nonneg _

/-- **The net of the roundings, exactly.** For `N ≥ 2` the net rounding is the
closed product less the count the sieve produces: `N·Π(1 − 1/p)` over the
primes up to `√N`, less `1 + π(N) − π(√N)`. -/
theorem netRounding_eq (N : ℕ) (hN : 2 ≤ N) :
    netRounding N = (N : ℚ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℚ))
      - (1 + (Nat.primeCounting N : ℚ) - (Nat.primeCounting (Nat.sqrt N) : ℚ)) := by
  have h1 := sieve_split N
  have h2 := card_survivors N hN
  have h3 : ((survivors N).card : ℚ) + (Nat.primeCounting (Nat.sqrt N) : ℚ)
      = 1 + (Nat.primeCounting N : ℚ) := by exact_mod_cast h2
  rw [smoothPart_eq_prod] at h1
  linarith

/-- info: 'SieveExact.netRounding_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms netRounding_eq

end SieveExact
