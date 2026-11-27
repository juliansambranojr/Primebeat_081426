/-
MeisselLehmer — step one of a verified count past Legendre: with the primes up to `s` and
`x < (s+1)^3`, a rough number in `[1, x]` is `1`, a prime above `s`, or a product of exactly two
primes above `s` (`rough_cube`). Legendre needed `x < (s+1)^2`; the cube lets `s` be `x^(1/3)`.
-/
import Mathlib
import Legendre

namespace MeisselLehmer
open Finset Legendre

open Classical in
/-- The numbers in `[1, x]` that are a product of two primes, both above `s`. -/
noncomputable def twoRough (x s : ℕ) : Finset ℕ :=
  (Icc 1 x).filter fun n => ∃ p q, s < p ∧ p ≤ q ∧ p.Prime ∧ q.Prime ∧ n = p * q

/-- **The rough numbers below the cube.** -/
theorem rough_cube {x s : ℕ} (hx : x < (s + 1) * (s + 1) * (s + 1)) (n : ℕ) :
    n ∈ rough x (primesTo s) ↔
      n ∈ Icc 1 x ∧ (n = 1 ∨ (s < n ∧ n.Prime) ∨ n ∈ twoRough x s) := by
  simp only [rough, twoRough, mem_filter, mem_Icc, mem_primesTo]
  constructor
  · rintro ⟨⟨h1, hnx⟩, hq⟩
    refine ⟨⟨h1, hnx⟩, ?_⟩
    rcases Nat.lt_or_ge n 2 with hn | hn
    · left; omega
    have hmin := Nat.minFac_prime (show n ≠ 1 by omega)
    have hms : s < n.minFac := by
      by_contra hc; push_neg at hc
      exact hq _ ⟨hc, hmin⟩ (Nat.minFac_dvd n)
    by_cases hp : n.Prime
    · right; left; exact ⟨lt_of_lt_of_le hms (Nat.minFac_le (by omega)), hp⟩
    · right; right
      -- n = p * m with p = minFac n; m has no prime factor ≤ s and m < (s+1)^2, so m is prime
      set p := n.minFac with hpdef
      obtain ⟨m, hm⟩ := Nat.minFac_dvd n
      have hm1 : 2 ≤ m := by
        rcases Nat.lt_or_ge m 2 with h | h
        · interval_cases m
          · omega
          · rw [mul_one] at hm; exact absurd (hm ▸ hmin) hp
        · exact h
      have hpm : p ≤ m := by
        have := Nat.minFac_le_of_dvd hm1 (Dvd.intro_left p hm.symm)
        exact le_trans (Nat.minFac_le_of_dvd (Nat.minFac_prime (by omega)).two_le
          (dvd_trans (Nat.minFac_dvd m) (Dvd.intro_left p hm.symm))) (Nat.minFac_le (by omega))
      have hmq : ∀ q, q ≤ s → q.Prime → ¬ q ∣ m := fun q hqs hqp hqm =>
        hq q ⟨hqs, hqp⟩ (hm ▸ dvd_mul_of_dvd_right hqm p)
      have hms2 : m < (s + 1) * (s + 1) := by
        have hp1 : s + 1 ≤ p := hms
        by_contra hc; push_neg at hc
        have : (s + 1) * ((s + 1) * (s + 1)) ≤ p * m := Nat.mul_le_mul hp1 hc
        nlinarith
      have hmp : m.Prime := by
        have hmin' := Nat.minFac_prime (show m ≠ 1 by omega)
        have hmsm : s < m.minFac := by
          by_contra hc; push_neg at hc
          exact hmq _ hc hmin' (Nat.minFac_dvd m)
        by_contra hnp
        have := Nat.minFac_sq_le_self (by omega) hnp
        nlinarith
      exact ⟨⟨h1, hnx⟩, p, m, hms, hpm, hmin, hmp, hm⟩
  · rintro ⟨⟨h1, hnx⟩, h⟩
    refine ⟨⟨h1, hnx⟩, fun q ⟨hqs, hqp⟩ hqn => ?_⟩
    rcases h with rfl | ⟨hs, hnp⟩ | ⟨_, p, r, hsp, _, hpp, hrp, rfl⟩
    · exact hqp.one_lt.ne' (Nat.dvd_one.mp hqn)
    · have := (Nat.prime_dvd_prime_iff_eq hqp hnp).mp hqn; omega
    · rcases (Nat.Prime.dvd_mul hqp).mp hqn with h | h
      · have := (Nat.prime_dvd_prime_iff_eq hqp hpp).mp h; omega
      · have := (Nat.prime_dvd_prime_iff_eq hqp hrp).mp h; omega

end MeisselLehmer

/-- info: 'MeisselLehmer.rough_cube' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MeisselLehmer.rough_cube
