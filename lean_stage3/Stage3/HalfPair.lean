/-
# Stage3.HalfPair — two of the sieve's roundings, paired, measured from Julian's half

Unit 0588: the wobble's square root lives only in the whole, so look at the whole through its
pairs. Measured from the half, the rounding of `k/a` is `B₁(fract(k/a)) = (k mod a)/a − 1/2`.
Over one common period two of them average to

    (gcd(a,b)² + 2) / (12ab),

checked in exact fractions (scratch, 2026-11-26). Franel's identity (1924) is the continuous
average `gcd²/(12ab)`; the `+2` is the half itself, the value `−1/2 = ζ(0)` the sawtooth takes at
the whole numbers. This file builds it, starting with the parts any period needs.
-/
import Mathlib

namespace HalfPair

open Finset

/-- The rounding of `k/a` measured from the half. -/
def saw (a k : ℕ) : ℚ := ((k % a : ℕ) : ℚ) / a - 1 / 2

/-- **One period of the half's sawtooth sums to minus a half.** -/
theorem sum_saw_period {a : ℕ} (ha : 0 < a) : ∑ k ∈ range a, saw a k = -(1 / 2) := by
  have hmod : ∀ k ∈ range a, k % a = k := fun k hk => Nat.mod_eq_of_lt (mem_range.mp hk)
  have ha' : (a : ℚ) ≠ 0 := by exact_mod_cast ha.ne'
  rw [Finset.sum_congr rfl fun k hk => by rw [saw, hmod k hk]]
  rw [Finset.sum_sub_distrib, ← Finset.sum_div, Finset.sum_const, card_range, nsmul_eq_mul]
  have hg := Finset.sum_range_id_mul_two a
  have hs : (∑ i ∈ range a, (i : ℚ)) = (a : ℚ) * (a - 1) / 2 := by
    have : ((∑ i ∈ range a, i : ℕ) : ℚ) * 2 = (a : ℚ) * ((a - 1 : ℕ) : ℚ) := by exact_mod_cast hg
    rw [Nat.cast_sub (by omega : 1 ≤ a)] at this
    push_cast at this
    linarith
  rw [hs]
  field_simp
  ring

/-- **A product period splits into blocks.** `k < a·b` is `k = a·q + r`, `q < b`, `r < a`. -/
theorem sum_blocks (F : ℕ → ℚ) (a b : ℕ) :
    ∑ k ∈ range (a * b), F k = ∑ q ∈ range b, ∑ r ∈ range a, F (a * q + r) := by
  induction b with
  | zero => simp
  | succ b ih =>
    rw [Nat.mul_succ, Finset.sum_range_add, ih, Finset.sum_range_succ]

end HalfPair

/-- info: 'HalfPair.sum_saw_period' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.sum_saw_period

/-- info: 'HalfPair.sum_blocks' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.sum_blocks

namespace HalfPair

open Finset

/-- For coprime `a, b`, the shifts `q ↦ (a·q + r) mod b` run through every residue mod `b`. -/
theorem sum_shift {a b : ℕ} (hb : 0 < b) (hab : Nat.Coprime a b) (r : ℕ) (G : ℕ → ℚ) :
    ∑ q ∈ range b, G ((a * q + r) % b) = ∑ j ∈ range b, G j := by
  have hinj : Set.InjOn (fun q => (a * q + r) % b) (range b) := by
    intro q hq q' hq' h
    have h1 : a * q + r ≡ a * q' + r [MOD b] := h
    have h2 : a * q ≡ a * q' [MOD b] := Nat.ModEq.add_right_cancel' r h1
    have h3 : q ≡ q' [MOD b] := Nat.ModEq.cancel_left_of_coprime (by
      rw [Nat.gcd_comm]; exact hab) h2
    have := Nat.ModEq.eq_of_lt_of_lt h3 (mem_range.mp hq) (mem_range.mp hq')
    exact this
  have himg : (range b).image (fun q => (a * q + r) % b) = range b := by
    apply Finset.eq_of_subset_of_card_le
    · intro j hj
      obtain ⟨q, _, rfl⟩ := mem_image.mp hj
      exact mem_range.mpr (Nat.mod_lt _ hb)
    · rw [card_image_of_injOn hinj]
  conv_rhs => rw [← himg]
  rw [Finset.sum_image hinj]

/-- The sawtooth reads only the residue. -/
theorem saw_mod (a k : ℕ) : saw a (k % a) = saw a k := by unfold saw; rw [Nat.mod_mod]

/-- **The pairing identity, coprime case.** For coprime `a, b`, two of the half's sawtooths over
one common period sum to `1/4`: the average `(gcd² + 2)/(12ab)` with `gcd = 1`. -/
theorem pair_coprime {a b : ℕ} (ha : 0 < a) (hb : 0 < b) (hab : Nat.Coprime a b) :
    ∑ k ∈ range (a * b), saw a k * saw b k = 1 / 4 := by
  rw [sum_blocks]
  have h1 : ∀ q r, r < a → saw a (a * q + r) = saw a r := by
    intro q r hr
    rw [← saw_mod a (a * q + r), Nat.mul_add_mod, Nat.mod_eq_of_lt hr]
  have h2 : ∀ q r, saw b (a * q + r) = saw b ((a * q + r) % b) := fun q r => (saw_mod b _).symm
  calc ∑ q ∈ range b, ∑ r ∈ range a, saw a (a * q + r) * saw b (a * q + r)
      = ∑ r ∈ range a, saw a r * ∑ q ∈ range b, saw b ((a * q + r) % b) := by
        rw [Finset.sum_comm]
        refine Finset.sum_congr rfl fun r hr => ?_
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun q _ => ?_
        rw [h1 q r (mem_range.mp hr), h2]
    _ = ∑ r ∈ range a, saw a r * (-(1 / 2)) := by
        refine Finset.sum_congr rfl fun r _ => ?_
        rw [sum_shift hb hab r (saw b), sum_saw_period hb]
    _ = 1 / 4 := by rw [← Finset.sum_mul, sum_saw_period ha]; norm_num

end HalfPair

/-- info: 'HalfPair.pair_coprime' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.pair_coprime

namespace HalfPair

open Finset

/-- Squares up to `n`. -/
theorem sum_sq_range (n : ℕ) : ∑ t ∈ range n, ((t : ℚ)) ^ 2 = (n : ℚ) * (n - 1) * (2 * n - 1) / 6 := by
  induction n with
  | zero => simp
  | succ n ih => rw [Finset.sum_range_succ, ih]; push_cast; ring

/-- **The shared part's own sawtooth.** One period of the half's sawtooth, squared, sums to
`(g² + 2)/(12 g)`. This is the whole pairing identity once the coprime parts are taken out: a pair
of the sieve's roundings sums, over a common period, to the sawtooth of the primes they share. -/
theorem sum_saw_sq {g : ℕ} (hg : 0 < g) :
    ∑ t ∈ range g, saw g t ^ 2 = ((g : ℚ) ^ 2 + 2) / (12 * g) := by
  have hmod : ∀ t ∈ range g, t % g = t := fun t ht => Nat.mod_eq_of_lt (mem_range.mp ht)
  have hg' : (g : ℚ) ≠ 0 := by exact_mod_cast hg.ne'
  rw [Finset.sum_congr rfl fun t ht => by rw [saw, hmod t ht]]
  have hexp : ∀ t : ℕ, ((t : ℚ) / g - 1 / 2) ^ 2 = (t : ℚ) ^ 2 / g ^ 2 - (t : ℚ) / g + 1 / 4 := by
    intro t; field_simp; ring
  simp only [hexp, Finset.sum_add_distrib, Finset.sum_sub_distrib, ← Finset.sum_div,
    Finset.sum_const, card_range, nsmul_eq_mul, sum_sq_range]
  have hs : (∑ i ∈ range g, (i : ℚ)) = (g : ℚ) * (g - 1) / 2 := by
    have : ((∑ i ∈ range g, i : ℕ) : ℚ) * 2 = (g : ℚ) * ((g - 1 : ℕ) : ℚ) := by
      exact_mod_cast Finset.sum_range_id_mul_two g
    rw [Nat.cast_sub (by omega : 1 ≤ g)] at this
    push_cast at this
    linarith
  rw [hs]
  field_simp
  ring

end HalfPair

/-- info: 'HalfPair.sum_saw_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.sum_saw_sq

namespace HalfPair

open Finset

/-- The residue of `g·q + t` modulo `g·a'`, for `t < g`. -/
theorem mod_block {g a' q t : ℕ} (ht : t < g) (ha : 0 < a') :
    (g * q + t) % (g * a') = g * (q % a') + t := by
  have hq := Nat.div_add_mod q a'
  have hlt : g * (q % a') + t < g * a' := by
    have : q % a' + 1 ≤ a' := Nat.mod_lt q ha
    nlinarith
  have heq : g * q + t = (g * (q % a') + t) + (g * a') * (q / a') := by
    conv_lhs => rw [← hq]
    ring
  rw [heq, Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt hlt]

/-- **The block step.** Inside a block of the shared part `g`, the sawtooth of `g·a'` is the
sawtooth of `a'` shifted by `t/(g·a')`. -/
theorem saw_block {g a' q t : ℕ} (hg : 0 < g) (ht : t < g) (ha : 0 < a') :
    saw (g * a') (g * q + t) = saw a' q + (t : ℚ) / (g * a') := by
  unfold saw
  rw [mod_block ht ha]
  have hg' : (g : ℚ) ≠ 0 := by exact_mod_cast hg.ne'
  have ha' : (a' : ℚ) ≠ 0 := by exact_mod_cast ha.ne'
  push_cast
  field_simp
  ring

end HalfPair

/-- info: 'HalfPair.saw_block' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.saw_block

namespace HalfPair

open Finset

/-- `m` periods of the half's sawtooth sum to `−m/2`. -/
theorem sum_saw_periods {a : ℕ} (ha : 0 < a) (m : ℕ) :
    ∑ q ∈ range (a * m), saw a q = (m : ℚ) * (-(1 / 2)) := by
  rw [sum_blocks]
  have h : ∀ q r, r < a → saw a (a * q + r) = saw a r := by
    intro q r hr
    rw [← saw_mod a (a * q + r), Nat.mul_add_mod, Nat.mod_eq_of_lt hr]
  rw [Finset.sum_congr rfl fun q _ => Finset.sum_congr rfl fun r hr => h q r (mem_range.mp hr)]
  simp only [sum_saw_period ha, Finset.sum_const, card_range, nsmul_eq_mul]

/-- **The pairing identity.** For `a = g·a'`, `b = g·b'` with `a', b'` coprime, two of the half's
sawtooths over one common period `g·a'·b'` sum to `(g² + 2)/(12 g)`, the shared part's own
sawtooth squared: averaged, `(gcd² + 2)/(12ab)`. -/
theorem pair_identity {g a' b' : ℕ} (hg : 0 < g) (ha : 0 < a') (hb : 0 < b')
    (hab : Nat.Coprime a' b') :
    ∑ k ∈ range (g * (a' * b')), saw (g * a') k * saw (g * b') k = ((g : ℚ) ^ 2 + 2) / (12 * g) := by
  rw [sum_blocks, Finset.sum_comm, ← sum_saw_sq hg]
  refine Finset.sum_congr rfl fun t ht => ?_
  have ht' := mem_range.mp ht
  rw [Finset.sum_congr rfl fun q _ => by rw [saw_block hg ht' ha, saw_block hg ht' hb]]
  have hg' : (g : ℚ) ≠ 0 := by exact_mod_cast hg.ne'
  have ha' : (a' : ℚ) ≠ 0 := by exact_mod_cast ha.ne'
  have hb' : (b' : ℚ) ≠ 0 := by exact_mod_cast hb.ne'
  have e : ∀ q, (saw a' q + (t : ℚ) / (g * a')) * (saw b' q + (t : ℚ) / (g * b'))
      = saw a' q * saw b' q + (t : ℚ) / (g * b') * saw a' q + (t : ℚ) / (g * a') * saw b' q
        + (t : ℚ) ^ 2 / (g ^ 2 * a' * b') := by
    intro q; field_simp; ring
  simp only [e, Finset.sum_add_distrib, ← Finset.mul_sum, Finset.sum_const, card_range, nsmul_eq_mul]
  rw [pair_coprime ha hb hab, sum_saw_periods ha b', mul_comm a' b', sum_saw_periods hb a']
  have hst : saw g t = (t : ℚ) / g - 1 / 2 := by unfold saw; rw [Nat.mod_eq_of_lt ht']
  rw [hst]
  push_cast
  field_simp
  ring

end HalfPair

/-- info: 'HalfPair.pair_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.pair_identity
