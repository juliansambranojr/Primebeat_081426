/-
# Stage3.BuchstabStep — one more prime in the sieve

`Φ(M, S)` counts the numbers from `1` to `M` that no prime of the set `S` divides. Adding a
prime `p ∉ S` to the sieve removes exactly the multiples of `p` among the survivors, and those
are `p` times the survivors at the scale `M / p`:

    Φ(M, insert p S) = Φ(M, S) − Φ(M / p, S).

This is Buchstab's recursion, the exact rule by which the sieve of unit 0499 grows one prime at
a time (`SieveIdem`); `PrimeStep.step_eq` is its rounding. Exact, unconditional.
-/
import Stage3.SieveExact

namespace BuchstabStep

open Finset

/-- The survivors up to `M` of the sieve by the primes of `S`. -/
def Φ (M : ℕ) (S : Finset ℕ) : ℕ := ((Icc 1 M).filter (fun m => ∀ q ∈ S, ¬ q ∣ m)).card

/-- **Buchstab's recursion.** -/
theorem phi_insert {S : Finset ℕ} (hS : ∀ q ∈ S, q.Prime) {p : ℕ} (hp : p.Prime) (hpS : p ∉ S)
    (M : ℕ) : Φ M (insert p S) + Φ (M / p) S = Φ M S := by
  classical
  unfold Φ
  set A := (Icc 1 M).filter (fun m => ∀ q ∈ S, ¬ q ∣ m) with hA
  have hsplit : A.filter (fun m => ¬ p ∣ m) =
      (Icc 1 M).filter (fun m => ∀ q ∈ insert p S, ¬ q ∣ m) := by
    ext m; simp only [hA, mem_filter, mem_insert, forall_eq_or_imp]
    tauto
  have hmul : (A.filter (fun m => p ∣ m)).card =
      ((Icc 1 (M / p)).filter (fun k => ∀ q ∈ S, ¬ q ∣ k)).card := by
    refine (Finset.card_bij (fun k _ => p * k) ?_ ?_ ?_).symm
    · intro k hk
      simp only [hA, mem_filter, mem_Icc] at hk ⊢
      obtain ⟨⟨hk1, hkM⟩, hkS⟩ := hk
      refine ⟨⟨⟨by have := hp.one_lt; nlinarith, ?_⟩, fun q hq hdvd => ?_⟩, dvd_mul_right p k⟩
      · calc p * k ≤ p * (M / p) := Nat.mul_le_mul_left p hkM
          _ ≤ M := Nat.mul_div_le M p
      · have hqp : q ≠ p := fun h => hpS (h ▸ hq)
        rcases (Nat.Prime.dvd_mul (hS q hq)).mp hdvd with h | h
        · exact hqp ((Nat.prime_dvd_prime_iff_eq (hS q hq) hp).mp h)
        · exact hkS q hq h
    · intro a _ b _ h
      exact Nat.eq_of_mul_eq_mul_left hp.pos h
    · intro m hm
      simp only [hA, mem_filter, mem_Icc] at hm
      obtain ⟨⟨⟨hm1, hmM⟩, hmS⟩, hpm⟩ := hm
      obtain ⟨k, rfl⟩ := hpm
      refine ⟨k, ?_, rfl⟩
      simp only [mem_filter, mem_Icc]
      refine ⟨⟨?_, ?_⟩, fun q hq hdvd => hmS q hq (dvd_mul_of_dvd_right hdvd p)⟩
      · rcases Nat.eq_zero_or_pos k with h | h
        · subst h; simp at hm1
        · exact h
      · exact (Nat.le_div_iff_mul_le hp.pos).mpr (by linarith [mul_comm p k])
  have := Finset.card_filter_add_card_filter_not (s := A) (fun m => p ∣ m)
  rw [← hsplit, ← hmul]
  omega

end BuchstabStep

/-- info: 'BuchstabStep.phi_insert' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms BuchstabStep.phi_insert

namespace BuchstabStep

open Finset

/-- **Buchstab's identity, unrolled.** For a finite set `S` of primes, every number from `1` to
`M` either survives the sieve by `S` or has a smallest prime factor `p ∈ S`; those with smallest
factor `p` are `p` times the survivors at `M / p` of the sieve by the primes of `S` below `p`:

    Φ(M, S) + Σ_{p ∈ S} Φ(M / p, {q ∈ S, q < p}) = M. -/
theorem phi_unroll (S : Finset ℕ) (hS : ∀ q ∈ S, q.Prime) (M : ℕ) :
    Φ M S + ∑ p ∈ S, Φ (M / p) (S.filter (· < p)) = M := by
  induction S using Finset.induction_on_max generalizing M with
  | empty => simp [Φ]
  | insert a s ha ih =>
    have has : a ∉ s := fun h => lt_irrefl a (ha a h)
    have hs : ∀ q ∈ s, q.Prime := fun q hq => hS q (mem_insert_of_mem hq)
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
    have hstep := phi_insert hs (hS a (mem_insert_self a s)) has M
    rw [sum_insert has, hfa, sum_congr rfl fun x hx => by rw [hfx x hx]]
    have := ih hs M
    omega

end BuchstabStep

/-- info: 'BuchstabStep.phi_unroll' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms BuchstabStep.phi_unroll
