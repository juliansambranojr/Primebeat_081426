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

namespace MeisselLehmer
open Finset Legendre

theorem not_mem_twoRough_of_prime {x s n : ℕ} (hn : n.Prime) : n ∉ twoRough x s := by
  classical
  simp only [twoRough, mem_filter, not_and, not_exists]
  intro _ p q _ _ hp hq he
  rw [he] at hn
  exact (Nat.not_prime_mul hp.one_lt.ne' hq.one_lt.ne') hn

theorem one_not_mem_twoRough {x s : ℕ} : 1 ∉ twoRough x s := by
  classical
  simp only [twoRough, mem_filter, not_and, not_exists]
  intro _ p q _ _ hp hq he
  have := Nat.eq_one_of_mul_eq_one_right he.symm
  exact hp.one_lt.ne' this

/-- **Meissel–Lehmer's identity.** For `x < (s+1)³`, `s ≤ x`, `1 ≤ x`:
`π x + 1 + P₂(x, s) = φ(x, primes ≤ s) + π s`, with `P₂` the products of two primes above `s`. -/
theorem primeCounting_add_P2 {x s : ℕ} (hx : x < (s + 1) * (s + 1) * (s + 1)) (hs : s ≤ x)
    (hx1 : 1 ≤ x) :
    Nat.primeCounting x + 1 + (twoRough x s).card = phi x (primesTo s) + Nat.primeCounting s := by
  classical
  rw [phi_eq_card _ (primesTo_prime s) (primesTo_nodup s)]
  set A := insert 1 ((Icc (s + 1) x).filter Nat.Prime) with hA
  have hsplit : rough x (primesTo s) = A ∪ twoRough x s := by
    ext n
    rw [rough_cube hx n, mem_union, hA, mem_insert, mem_filter, mem_Icc, mem_Icc]
    constructor
    · rintro ⟨⟨h1, hnx⟩, h | ⟨hs', hp⟩ | h⟩
      · left; left; exact h
      · left; right; exact ⟨⟨by omega, hnx⟩, hp⟩
      · right; exact h
    · rintro ((h | ⟨⟨h1, hnx⟩, hp⟩) | h)
      · subst h; exact ⟨⟨le_rfl, hx1⟩, Or.inl rfl⟩
      · exact ⟨⟨by omega, hnx⟩, Or.inr (Or.inl ⟨by omega, hp⟩)⟩
      · have hm : n ∈ Icc 1 x := by
          unfold twoRough at h; exact (mem_filter.mp h).1
        rw [mem_Icc] at hm
        exact ⟨hm, Or.inr (Or.inr h)⟩
  have hdisj : Disjoint A (twoRough x s) := by
    rw [disjoint_left]
    intro n hn
    rw [hA, mem_insert, mem_filter] at hn
    rcases hn with rfl | ⟨_, hp⟩
    · exact one_not_mem_twoRough
    · exact not_mem_twoRough_of_prime hp
  rw [hsplit, card_union_of_disjoint hdisj, hA,
    card_insert_of_notMem (by simp [Nat.not_prime_one])]
  have := card_primes_Icc hs
  omega

end MeisselLehmer

/-- info: 'MeisselLehmer.primeCounting_add_P2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MeisselLehmer.primeCounting_add_P2

namespace MeisselLehmer
open Finset

theorem minFac_mul_primes {p q : ℕ} (hp : p.Prime) (hq : q.Prime) (hpq : p ≤ q) :
    (p * q).minFac = p := by
  have hne : p * q ≠ 1 := by
    intro h; have := hp.two_le; have := hq.two_le; nlinarith
  have hmp := Nat.minFac_prime hne
  have hle : (p * q).minFac ≤ p := Nat.minFac_le_of_dvd hp.two_le (dvd_mul_right p q)
  rcases (Nat.Prime.dvd_mul hmp).mp (Nat.minFac_dvd (p * q)) with h | h
  · exact (Nat.prime_dvd_prime_iff_eq hmp hp).mp h
  · have := (Nat.prime_dvd_prime_iff_eq hmp hq).mp h; omega

open Classical in
/-- The primes `p` above `s` with `p² ≤ x`. -/
noncomputable def lowP (x s : ℕ) : Finset ℕ := (Icc (s + 1) x).filter fun p => p.Prime ∧ p * p ≤ x

open Classical in
/-- **`P₂` as a sum.** The products of two primes above `s` counted by their smaller factor `p`:
`P₂(x, s) = Σ_p #{q prime : p ≤ q ≤ x/p}`. -/
theorem card_twoRough (x s : ℕ) :
    (twoRough x s).card = ∑ p ∈ lowP x s, ((Icc p (x / p)).filter Nat.Prime).card := by
  have hset : twoRough x s = (lowP x s).biUnion
      (fun p => ((Icc p (x / p)).filter Nat.Prime).image (fun q => p * q)) := by
    ext n
    simp only [twoRough, lowP, mem_filter, mem_Icc, mem_biUnion, mem_image]
    constructor
    · rintro ⟨⟨h1, hnx⟩, p, q, hsp, hpq, hp, hq, rfl⟩
      have hpp : p * p ≤ x := le_trans (Nat.mul_le_mul_left p hpq) hnx
      refine ⟨p, ⟨⟨by omega, le_trans (Nat.le_mul_self p) hpp⟩, hp, hpp⟩, q, ⟨⟨hpq, ?_⟩, hq⟩, rfl⟩
      exact (Nat.le_div_iff_mul_le hp.pos).mpr (by rw [mul_comm]; exact hnx)
    · rintro ⟨p, ⟨⟨hsp, _⟩, hp, _⟩, q, ⟨⟨hpq, hqx⟩, hq⟩, rfl⟩
      refine ⟨⟨Nat.mul_pos hp.pos hq.pos, ?_⟩, p, q, by omega, hpq, hp, hq, rfl⟩
      have := (Nat.le_div_iff_mul_le hp.pos).mp hqx
      rw [mul_comm]; exact this
  rw [hset, card_biUnion]
  · refine sum_congr rfl fun p hp => ?_
    have hp0 : 0 < p := by
      simp only [lowP, mem_filter, mem_Icc] at hp; omega
    exact card_image_of_injOn fun a _ b _ h => Nat.eq_of_mul_eq_mul_left hp0 h
  · intro p hp p' hp' hne
    rw [Function.onFun, disjoint_left]
    intro n hn hn'
    simp only [mem_image, mem_filter, mem_Icc] at hn hn'
    obtain ⟨q, ⟨⟨hpq, _⟩, hq⟩, rfl⟩ := hn
    obtain ⟨q', ⟨⟨hpq', _⟩, hq'⟩, he⟩ := hn'
    have hp := mem_filter.mp (Finset.mem_coe.mp hp)
    have hp' := mem_filter.mp (Finset.mem_coe.mp hp')
    have h1 := minFac_mul_primes hp.2.1 hq hpq
    have h2 := minFac_mul_primes hp'.2.1 hq' hpq'
    rw [he] at h2
    exact hne (h1.symm.trans h2)

end MeisselLehmer

/-- info: 'MeisselLehmer.card_twoRough' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MeisselLehmer.card_twoRough
