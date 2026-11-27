/-
Legendre — the rough count `φ(x, ps)`, the numbers in `[1, x]` with no factor in `ps`, and
Legendre's recursion `φ(x, p :: ps) = φ(x, ps) − φ(x/p, ps)`. Step one of a verified π(x)
faster than trial division.
-/
import Mathlib
import PiSieve

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
  | x, p :: ps => if x ≤ 1 then x else phi x ps - phi (x / p) ps

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
    simp only [phi]
    split_ifs with hx
    · -- below 2 every number is rough: 0 or the number 1
      interval_cases x
      · simp [rough]
      · have : rough 1 (p :: ps) = {1} := by
          ext n; simp only [rough, mem_filter, mem_Icc, mem_singleton]
          constructor
          · rintro ⟨⟨h1, h2⟩, _⟩; omega
          · rintro rfl
            refine ⟨⟨le_rfl, le_rfl⟩, fun q hq hd => ?_⟩
            have hq' : q.Prime := by
              rcases List.mem_cons.mp hq with rfl | hq
              · exact hp
              · exact hps' q hq
            exact hq'.one_lt.ne' (Nat.dvd_one.mp hd)
        rw [this]; rfl
    · rw [ih hps' hnd'.2, ih hps' hnd'.2]
      omega

/-- The primes up to `s`, as a list. -/
def primesTo (s : ℕ) : List ℕ := ((List.range (s + 1)).filter PiSieve.isPrimeB2).reverse

theorem mem_primesTo {s q : ℕ} : q ∈ primesTo s ↔ q ≤ s ∧ q.Prime := by
  simp [primesTo, Nat.lt_succ_iff, PiSieve.isPrimeB2_iff]

theorem primesTo_prime (s : ℕ) : ∀ q ∈ primesTo s, q.Prime :=
  fun q hq => (mem_primesTo.mp hq).2

theorem primesTo_nodup (s : ℕ) : (primesTo s).Nodup :=
  List.nodup_reverse.mpr ((List.nodup_range).filter _)

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

/-- The primes in `(s, x]` count `π x − π s`. -/
theorem card_primes_Icc {s x : ℕ} (hs : s ≤ x) :
    ((Icc (s + 1) x).filter Nat.Prime).card + Nat.primeCounting s = Nat.primeCounting x := by
  simp only [Nat.primeCounting, Nat.primeCounting', Nat.count_eq_card_filter_range]
  have hu : range (x + 1) = range (s + 1) ∪ Icc (s + 1) x := by
    ext n; simp only [mem_range, mem_union, mem_Icc]; omega
  have hd : Disjoint (range (s + 1)) (Icc (s + 1) x) := by
    rw [disjoint_left]; intro n h1 h2; simp only [mem_range, mem_Icc] at h1 h2; omega
  rw [hu, filter_union, card_union_of_disjoint (disjoint_filter_filter hd)]
  ring

/-- **Legendre's formula.** For `x < (s+1)²` and `s ≤ x`, `π x = φ(x, primes ≤ s) + π s − 1`. -/
theorem primeCounting_eq_phi {x s : ℕ} (hx : x < (s + 1) * (s + 1)) (hs : s ≤ x) (hx1 : 1 ≤ x) :
    Nat.primeCounting x + 1 = phi x (primesTo s) + Nat.primeCounting s := by
  rw [phi_eq_card _ (primesTo_prime s) (primesTo_nodup s), rough_primesTo hx]
  have hsub : insert 1 ((Icc (s + 1) x).filter Nat.Prime) ⊆ Icc 1 x := by
    intro n hn
    simp only [mem_insert, mem_filter, mem_Icc] at hn ⊢
    omega
  rw [inter_eq_left.mpr hsub, card_insert_of_notMem (by simp [Nat.not_prime_one])]
  have := card_primes_Icc hs
  omega

end Legendre

/-- info: 'Legendre.primeCounting_eq_phi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Legendre.primeCounting_eq_phi

/-- info: 'Legendre.rough_primesTo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Legendre.rough_primesTo

namespace Legendre
open Finset

/-- The terms Legendre's recursion peels off: `Σ φ(x/p, primes below p)` along the list. -/
def peel (x : ℕ) : List ℕ → ℕ
  | [] => 0
  | p :: ps => phi (x / p) ps + peel x ps

theorem peel_cons (x p : ℕ) (L : List ℕ) : peel x (p :: L) = phi (x / p) L + peel x L := rfl

/-- **The recursion unrolled.** For `x ≥ 2`, `φ(x, ps) + Σ_p φ(x/p, tail) = x`: each term can be
checked on its own, so no single kernel check holds the whole tree. -/
theorem phi_add_peel (ps : List ℕ) (hps : ∀ q ∈ ps, q.Prime) (hnd : ps.Nodup) {x : ℕ} (hx : 2 ≤ x) :
    phi x ps + peel x ps = x := by
  induction ps with
  | nil => simp [phi, peel]
  | cons p ps ih =>
    have hp := hps p (List.mem_cons_self ..)
    have hps' : ∀ q ∈ ps, q.Prime := fun q hq => hps q (List.mem_cons_of_mem _ hq)
    have hnd' := List.nodup_cons.mp hnd
    have h := card_rough_cons (x := x) hp hps' hnd'.1
    have e1 := phi_eq_card ps hps' hnd'.2 x
    have e2 := phi_eq_card ps hps' hnd'.2 (x / p)
    have := ih hps' hnd'.2
    simp only [phi, peel, show ¬ x ≤ 1 by omega, if_false]
    omega

end Legendre

/-- info: 'Legendre.phi_add_peel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Legendre.phi_add_peel
