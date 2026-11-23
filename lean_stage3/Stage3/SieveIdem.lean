/-
SieveIdem — block R12 of `lean_stage3/design/runs.md`. 2026-11-23.

Julian, 2026-11-23: the settling happens one slot at a time because of
idempotence; every step is the same `f`, and it scales at any `x`.

A prime's step removes its multiples. Done twice it does nothing more; two
primes' steps give the same set in either order; the rule reads the same at
every size. The numbers left after the primes below `p` are the counts of
`CompositeSplit.rough`, and the sieve grows by one prime's step at a time. The
first slot no earlier prime reaches is a prime.

  sieveStep_idem      f_p ∘ f_p = f_p
  sieveStep_comm      f_p ∘ f_q = f_q ∘ f_p
  mem_sieveStep       m ∈ f_p A ↔ m ∈ A ∧ ¬ p ∣ m      (no size in the rule)
  sieveBelow_idem     the sieve by all primes below p, done twice, is done once
  sieveBelow_succ     p prime ⊢ sieve below p+1 = f_p (sieve below p)
  sieveBelow_succ_of_not_prime   p not prime ⊢ sieve below p+1 = sieve below p
  rough_eq_card       CompositeSplit.rough N p = #(sieve below p of [1, N/p])
  settles_on_prime    2 ≤ m, no prime below m divides m ⊢ m is prime

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.CompositeSplit

namespace SieveIdem

open Finset
open scoped Classical

/-- A prime's step: remove its multiples. -/
noncomputable
def sieveStep (p : ℕ) (A : Finset ℕ) : Finset ℕ :=
  A.filter (fun m => ¬ p ∣ m)

/-- **Idempotent.** A step done twice is done once. -/
theorem sieveStep_idem (p : ℕ) (A : Finset ℕ) :
    sieveStep p (sieveStep p A) = sieveStep p A := by
  unfold sieveStep
  rw [Finset.filter_filter]
  simp

/-- **Order-free.** Two primes' steps give the same set in either order. -/
theorem sieveStep_comm (p q : ℕ) (A : Finset ℕ) :
    sieveStep p (sieveStep q A) = sieveStep q (sieveStep p A) := by
  unfold sieveStep
  rw [Finset.filter_filter, Finset.filter_filter]
  congr 1
  ext m
  exact and_comm

/-- **No size in the rule.** A number survives a step exactly when it was
there and the prime does not divide it, at every size. -/
theorem mem_sieveStep (p : ℕ) (A : Finset ℕ) (m : ℕ) :
    m ∈ sieveStep p A ↔ m ∈ A ∧ ¬ p ∣ m := by
  unfold sieveStep
  exact Finset.mem_filter

/-- The sieve by every prime below `p`. -/
noncomputable
def sieveBelow (p : ℕ) (A : Finset ℕ) : Finset ℕ :=
  A.filter (fun m => ∀ q : ℕ, q.Prime → q < p → ¬ q ∣ m)

/-- The whole sieve below `p` is idempotent too. -/
theorem sieveBelow_idem (p : ℕ) (A : Finset ℕ) :
    sieveBelow p (sieveBelow p A) = sieveBelow p A := by
  unfold sieveBelow
  rw [Finset.filter_filter]
  simp

/-- **One slot at a time.** Past a prime `p`, the sieve grows by exactly
`p`'s step. -/
theorem sieveBelow_succ {p : ℕ} (hp : p.Prime) (A : Finset ℕ) :
    sieveBelow (p + 1) A = sieveStep p (sieveBelow p A) := by
  unfold sieveBelow sieveStep
  rw [Finset.filter_filter]
  congr 1
  ext m
  constructor
  · intro h
    exact ⟨fun q hq hqp => h q hq (by omega), h p hp (by omega)⟩
  · rintro ⟨h, hpm⟩ q hq hqp
    rcases Nat.lt_succ_iff_lt_or_eq.mp hqp with hlt | heq
    · exact h q hq hlt
    · rw [heq]; exact hpm

/-- Past a number that is not prime, the sieve does not change. -/
theorem sieveBelow_succ_of_not_prime {p : ℕ} (hp : ¬ p.Prime) (A : Finset ℕ) :
    sieveBelow (p + 1) A = sieveBelow p A := by
  unfold sieveBelow
  congr 1
  ext m
  constructor
  · intro h q hq hqp
    exact h q hq (by omega)
  · intro h q hq hqp
    rcases Nat.lt_succ_iff_lt_or_eq.mp hqp with hlt | heq
    · exact h q hq hlt
    · exact absurd (heq ▸ hq) hp

/-- **JOIN.** The counts of `CompositeSplit.rough` are the sieve below `p` of
the numbers up to `N/p`. -/
theorem rough_eq_card (N p : ℕ) :
    CompositeSplit.rough N p = (sieveBelow p (Icc 1 (N / p))).card := rfl

/-- **It settles on a prime.** A number from two up that no prime below it
divides is prime: the first slot no earlier prime reaches. -/
theorem settles_on_prime {m : ℕ} (hm : 2 ≤ m)
    (h : ∀ q : ℕ, q.Prime → q < m → ¬ q ∣ m) : m.Prime := by
  have hm1 : m ≠ 1 := by omega
  have hmin := Nat.minFac_prime hm1
  have hdvd := Nat.minFac_dvd m
  have hle : m ≤ m.minFac := by
    by_contra hlt
    exact h _ hmin (by omega) hdvd
  have heq : m.minFac = m := le_antisymm (Nat.minFac_le (by omega)) hle
  rw [← heq]
  exact hmin

/-- info: 'SieveIdem.sieveStep_idem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sieveStep_idem

/-- info: 'SieveIdem.sieveStep_comm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sieveStep_comm

/-- info: 'SieveIdem.sieveBelow_succ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sieveBelow_succ

/-- info: 'SieveIdem.rough_eq_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rough_eq_card

/-- info: 'SieveIdem.settles_on_prime' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms settles_on_prime

end SieveIdem
