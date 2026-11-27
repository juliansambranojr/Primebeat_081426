/-
Legendre — the rough count `φ(x, ps)`, the numbers in `[1, x]` with no factor in `ps`, and
Legendre's recursion `φ(x, p :: ps) = φ(x, ps) − φ(x/p, ps)`. Step one of a verified π(x)
faster than trial division.
-/
import Mathlib

namespace Legendre
open Finset

/-- The numbers in `[1, x]` divisible by no member of `ps`. -/
def rough (x : ℕ) (ps : List ℕ) : Finset ℕ :=
  (Icc 1 x).filter fun n => ∀ q ∈ ps, ¬ q ∣ n

/-- **Legendre's recursion.** For a prime `p` outside the primes `ps`, the rough numbers for
`p :: ps` are those for `ps` less the multiples `p·m` of rough numbers `m ≤ x/p`. -/
theorem card_rough_cons {x p : ℕ} {ps : List ℕ} (hp : p.Prime) (hps : ∀ q ∈ ps, q.Prime)
    (hnot : p ∉ ps) :
    (rough x (p :: ps)).card + (rough (x / p) ps).card = (rough x ps).card := by
  -- the rough numbers for ps split into those p does not divide and those it does
  have hsplit : rough x ps = rough x (p :: ps) ∪ (rough x ps).filter (fun n => p ∣ n) := by
    ext n
    simp only [rough, mem_union, mem_filter, mem_Icc, List.mem_cons, forall_eq_or_imp]
    tauto
  have hdisj : Disjoint (rough x (p :: ps)) ((rough x ps).filter (fun n => p ∣ n)) := by
    rw [disjoint_left]
    intro n h1 h2
    simp only [rough, mem_filter, List.mem_cons, forall_eq_or_imp] at h1 h2
    exact h1.2.1 h2.2
  -- the multiples of p among them are p·m for the rough m ≤ x/p
  have himg : (rough x ps).filter (fun n => p ∣ n) = (rough (x / p) ps).image (fun m => p * m) := by
    ext n
    simp only [rough, mem_filter, mem_image, mem_Icc]
    constructor
    · rintro ⟨⟨⟨h1, hx⟩, hq⟩, ⟨m, rfl⟩⟩
      refine ⟨m, ⟨⟨?_, ?_⟩, fun q hq' hqm => hq q hq' (dvd_mul_of_dvd_right hqm p)⟩, rfl⟩
      · rcases Nat.eq_zero_or_pos m with h | h
        · subst h; simp at h1
        · exact h
      · exact (Nat.le_div_iff_mul_le hp.pos).mpr (by rw [mul_comm]; exact hx)
    · rintro ⟨m, ⟨⟨h1, hx⟩, hq⟩, rfl⟩
      refine ⟨⟨⟨?_, ?_⟩, fun q hq' hqd => ?_⟩, dvd_mul_right p m⟩
      · exact Nat.mul_pos hp.pos h1
      · have := (Nat.le_div_iff_mul_le hp.pos).mp hx
        rw [mul_comm]; exact this
      · rcases (Nat.Prime.dvd_mul (hps q hq')).mp hqd with h | h
        · have : q = p := (Nat.prime_dvd_prime_iff_eq (hps q hq') hp).mp h
          exact hnot (this ▸ hq')
        · exact hq q hq' h
  have hinj : Set.InjOn (fun m => p * m) (rough (x / p) ps) :=
    fun a _ b _ h => Nat.eq_of_mul_eq_mul_left hp.pos h
  rw [hsplit, card_union_of_disjoint hdisj, himg, card_image_of_injOn hinj]

/-- With no primes, every number in `[1, x]` is rough. -/
theorem card_rough_nil (x : ℕ) : (rough x []).card = x := by
  simp [rough]

end Legendre

/-- info: 'Legendre.card_rough_cons' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Legendre.card_rough_cons

namespace Legendre
open Finset

/-- Legendre's φ, computed by the recursion. -/
def phi : ℕ → List ℕ → ℕ
  | x, [] => x
  | x, p :: ps => phi x ps - phi (x / p) ps

theorem phi_eq_card (ps : List ℕ) (hps : ∀ q ∈ ps, q.Prime) (hnd : ps.Nodup) :
    ∀ x, phi x ps = (rough x ps).card := by
  induction ps with
  | nil => intro x; simp [phi, card_rough_nil]
  | cons p ps ih =>
    intro x
    have hp := hps p (List.mem_cons_self ..)
    have hps' : ∀ q ∈ ps, q.Prime := fun q hq => hps q (List.mem_cons_of_mem _ hq)
    have hnd' := (List.nodup_cons.mp hnd)
    have h := card_rough_cons (x := x) hp hps' hnd'.1
    simp only [phi, ih hps' hnd'.2]
    omega

/-- The primes up to `s`, as a list. -/
def primesTo (s : ℕ) : List ℕ := (List.range (s + 1)).filter Nat.Prime

theorem primesTo_prime (s : ℕ) : ∀ q ∈ primesTo s, q.Prime := by
  intro q hq; simp [primesTo] at hq; exact hq.2

theorem primesTo_nodup (s : ℕ) : (primesTo s).Nodup :=
  (List.nodup_range).filter _

theorem mem_primesTo {s q : ℕ} : q ∈ primesTo s ↔ q ≤ s ∧ q.Prime := by
  simp [primesTo, Nat.lt_succ_iff]

/-- **The rough numbers past `√x` are 1 and the primes.** With `x < (s+1)^2`, a number in
`[1, x]` with no prime factor `≤ s` is `1` or a prime above `s`. -/
theorem rough_primesTo {x s : ℕ} (hx : x < (s + 1) * (s + 1)) :
    rough x (primesTo s) = insert 1 ((Icc (s + 1) x).filter Nat.Prime) ∩ Icc 1 x := by
  ext n
  simp only [rough, mem_filter, mem_Icc, mem_inter, mem_insert, mem_primesTo]
  constructor
  · rintro ⟨⟨h1, hnx⟩, hq⟩
    refine ⟨?_, h1, hnx⟩
    rcases Nat.lt_or_ge n 2 with hn | hn
    · left; omega
    · right
      have hmin := Nat.minFac_prime (show n ≠ 1 by omega)
      have hms : s < n.minFac := by
        by_contra hc; push_neg at hc
        exact hq _ ⟨hc, hmin⟩ (Nat.minFac_dvd n)
      refine ⟨⟨by linarith [Nat.minFac_le (show 0 < n by omega)], hnx⟩, ?_⟩
      by_contra hnp
      have := Nat.minFac_sq_le_self (show 0 < n by omega) hnp
      nlinarith
  · rintro ⟨h, h1, hnx⟩
    refine ⟨⟨h1, hnx⟩, fun q ⟨hqs, hqp⟩ hqn => ?_⟩
    rcases h with rfl | ⟨⟨hs, _⟩, hnp⟩
    · exact hqp.one_lt.ne' (Nat.dvd_one.mp hqn)
    · have := (Nat.prime_dvd_prime_iff_eq hqp hnp).mp hqn
      omega

end Legendre

/-- info: 'Legendre.rough_primesTo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Legendre.rough_primesTo
