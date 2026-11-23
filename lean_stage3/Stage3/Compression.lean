/-
Compression — block R11 of `lean_stage3/design/runs.md`. 2026-11-23.

The primes as the compression of the composites. The combinations of the
primes up to `√N` never repeat and do not fill the numbers up to `N`. What
they leave is exactly the new primes, each with its multiples, and no number
is counted twice: a number up to `N` has at most one prime factor above `√N`.

  smooth N          the numbers 1..N that are combinations of the primes ≤ √N
  newPrimes N       the primes in (√N, N]
  unique_new_prime  a number up to N has at most one prime factor above √N
  compression       N = smooth N + Σ_{p new} ⌊N/p⌋

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.CompositeSplit

namespace Compression

open Finset SieveExact
open scoped Classical

/-- The numbers from `1` to `N` that are combinations of the primes up to `√N`:
every prime dividing them is at most `√N`. -/
noncomputable def smooth (N : ℕ) : ℕ :=
  ((Icc 1 N).filter (fun n => ∀ p : ℕ, p.Prime → p ∣ n → p ≤ Nat.sqrt N)).card

/-- The new primes: those above `√N`, up to `N`. -/
def newPrimes (N : ℕ) : Finset ℕ := (Icc 1 N).filter (fun p => p.Prime ∧ Nat.sqrt N < p)

/-- **No number is claimed twice.** A number up to `N` has at most one prime
factor above `√N`. -/
theorem unique_new_prime {N n p q : ℕ} (hn1 : 1 ≤ n) (hn : n ≤ N) (hp : p.Prime) (hq : q.Prime)
    (hpN : Nat.sqrt N < p) (hqN : Nat.sqrt N < q) (hpn : p ∣ n) (hqn : q ∣ n) : p = q := by
  by_contra hne
  have hcop : Nat.Coprime p q := (Nat.coprime_primes hp hq).mpr hne
  have hdvd : p * q ∣ n := Nat.Coprime.mul_dvd_of_dvd_of_dvd hcop hpn hqn
  have hle : p * q ≤ n := Nat.le_of_dvd hn1 hdvd
  have hlt : N < (Nat.sqrt N + 1) * (Nat.sqrt N + 1) := Nat.lt_succ_sqrt N
  have hmul : (Nat.sqrt N + 1) * (Nat.sqrt N + 1) ≤ p * q := Nat.mul_le_mul hpN hqN
  exact absurd (lt_of_lt_of_le hlt (hmul.trans (hle.trans hn))) (lt_irrefl _)

/-- The numbers that are not combinations of the primes so far are the
multiples of the new primes. -/
theorem nonSmooth_eq_biUnion (N : ℕ) :
    (Icc 1 N).filter (fun n => ¬ ∀ p : ℕ, p.Prime → p ∣ n → p ≤ Nat.sqrt N)
      = (newPrimes N).biUnion (fun p => (Icc 1 N).filter (fun n => p ∣ n)) := by
  ext n
  simp only [mem_filter, mem_Icc, mem_biUnion, newPrimes, not_forall, not_le]
  constructor
  · rintro ⟨hI, p, hp, hpn, hlt⟩
    exact ⟨p, ⟨⟨hp.one_lt.le, (Nat.le_of_dvd (by omega) hpn).trans hI.2⟩, hp, hlt⟩, hI, hpn⟩
  · rintro ⟨p, ⟨_, hp, hlt⟩, hI, hpn⟩
    exact ⟨hI, p, hp, hpn, hlt⟩

/-- **The compression.** The numbers up to `N` are the combinations of the
primes up to `√N`, and for each new prime its multiples up to `N`, with nothing
counted twice. -/
theorem compression (N : ℕ) : N = smooth N + ∑ p ∈ newPrimes N, N / p := by
  have hdisj : ∀ p ∈ newPrimes N, ∀ q ∈ newPrimes N, p ≠ q →
      Disjoint ((Icc 1 N).filter (fun n => p ∣ n)) ((Icc 1 N).filter (fun n => q ∣ n)) := by
    intro p hp q hq hne
    rw [Finset.disjoint_left]
    intro n hnp hnq
    rw [mem_filter, mem_Icc] at hnp hnq
    unfold newPrimes at hp hq
    rw [mem_filter] at hp hq
    exact hne (unique_new_prime hnp.1.1 hnp.1.2 hp.2.1 hq.2.1 hp.2.2 hq.2.2 hnp.2 hnq.2)
  have hsplit := Finset.filter_card_add_filter_neg_card_eq_card (s := Icc 1 N)
      (fun n => ∀ p : ℕ, p.Prime → p ∣ n → p ≤ Nat.sqrt N)
  rw [nonSmooth_eq_biUnion, Finset.card_biUnion hdisj, Nat.card_Icc] at hsplit
  simp only [card_multiples] at hsplit
  unfold smooth
  omega

/-- info: 'Compression.unique_new_prime' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms unique_new_prime

/-- info: 'Compression.compression' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms compression

end Compression
