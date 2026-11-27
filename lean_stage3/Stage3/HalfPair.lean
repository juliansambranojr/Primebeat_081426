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

namespace HalfPair

open Finset

/-- **The pairing identity in `a` and `b`.** Over one period `lcm(a, b)`, two of the half's
sawtooths sum to `(g² + 2)/(12 g)`, `g = gcd(a, b)`. -/
theorem pair_gcd {a b : ℕ} (ha : 0 < a) (hb : 0 < b) :
    ∑ k ∈ range (Nat.lcm a b), saw a k * saw b k
      = (((Nat.gcd a b : ℕ) : ℚ) ^ 2 + 2) / (12 * (Nat.gcd a b : ℕ)) := by
  obtain ⟨G, hG⟩ : ∃ G, G = Nat.gcd a b := ⟨_, rfl⟩
  have hg : 0 < G := hG ▸ Nat.gcd_pos_of_pos_left b ha
  obtain ⟨A, hA⟩ : ∃ A, A = a / G := ⟨_, rfl⟩
  obtain ⟨B, hB⟩ : ∃ B, B = b / G := ⟨_, rfl⟩
  have hea : a = G * A := by rw [hA, hG]; exact (Nat.mul_div_cancel' (Nat.gcd_dvd_left a b)).symm
  have heb : b = G * B := by rw [hB, hG]; exact (Nat.mul_div_cancel' (Nat.gcd_dvd_right a b)).symm
  have ha' : 0 < A := Nat.pos_of_mul_pos_left (hea ▸ ha)
  have hb' : 0 < B := Nat.pos_of_mul_pos_left (heb ▸ hb)
  have hcop : Nat.Coprime A B := by
    rw [hA, hB, hG]; exact Nat.coprime_div_gcd_div_gcd (hG ▸ hg)
  have hl : Nat.lcm a b = G * (A * B) := by
    have h1 : G * Nat.lcm a b = a * b := by rw [hG]; exact Nat.gcd_mul_lcm a b
    have h2 : a * b = G * (G * (A * B)) := by
      calc a * b = (G * A) * (G * B) := by rw [← hea, ← heb]
        _ = G * (G * (A * B)) := by ring
    exact Nat.eq_of_mul_eq_mul_left hg (h1.trans h2)
  have h := pair_identity hg ha' hb' hcop
  rw [← hea, ← heb, ← hl, hG] at h
  exact h

end HalfPair

/-- info: 'HalfPair.pair_gcd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.pair_gcd

namespace HalfPair

open Finset

/-- The sawtooth repeats over any multiple of its period. -/
theorem saw_shift {a L : ℕ} (h : a ∣ L) (q r : ℕ) : saw a (L * q + r) = saw a r := by
  unfold saw
  obtain ⟨c, rfl⟩ := h
  rw [show a * c * q + r = r + a * (c * q) by ring, Nat.add_mul_mod_self_left]

/-- **The pairing over any common period.** For `L = lcm(a,b)·m`, the pair sums to `m` times the
pairing identity. -/
theorem pair_period {a b : ℕ} (ha : 0 < a) (hb : 0 < b) (m : ℕ) :
    ∑ k ∈ range (Nat.lcm a b * m), saw a k * saw b k
      = (m : ℚ) * ((((Nat.gcd a b : ℕ) : ℚ) ^ 2 + 2) / (12 * (Nat.gcd a b : ℕ))) := by
  rw [sum_blocks]
  have h : ∀ q r, saw a (Nat.lcm a b * q + r) * saw b (Nat.lcm a b * q + r) = saw a r * saw b r :=
    fun q r => by rw [saw_shift (Nat.dvd_lcm_left a b), saw_shift (Nat.dvd_lcm_right a b)]
  simp only [h, Finset.sum_const, card_range, nsmul_eq_mul, pair_gcd ha hb]

end HalfPair

/-- info: 'HalfPair.pair_period' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.pair_period

namespace HalfPair

open Finset

/-- **The mean square as one quadratic form.** For a finite family `D` of positive periods, all
dividing `L`, with weights `c`, the half's sawtooths summed with those weights have, over the
period `L`, a square sum that is one quadratic form in the weights: every pair weighted by its
pairing identity. Nothing is bounded part by part. -/
theorem square_form (D : Finset ℕ) (hD : ∀ d ∈ D, 0 < d) (c : ℕ → ℚ) {L : ℕ}
    (hL : ∀ d ∈ D, d ∣ L) :
    ∑ k ∈ range L, (∑ d ∈ D, c d * saw d k) ^ 2
      = ∑ a ∈ D, ∑ b ∈ D, c a * c b * (((L / Nat.lcm a b : ℕ) : ℚ) *
          ((((Nat.gcd a b : ℕ) : ℚ) ^ 2 + 2) / (12 * (Nat.gcd a b : ℕ)))) := by
  have hexp : ∀ k, (∑ d ∈ D, c d * saw d k) ^ 2
      = ∑ a ∈ D, ∑ b ∈ D, c a * c b * (saw a k * saw b k) := by
    intro k
    rw [sq, Finset.sum_mul_sum]
    exact Finset.sum_congr rfl fun a _ => Finset.sum_congr rfl fun b _ => by ring
  simp only [hexp]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun a ha => ?_
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun b hb => ?_
  rw [← Finset.mul_sum]
  congr 1
  have hdvd : Nat.lcm a b ∣ L := Nat.lcm_dvd (hL a ha) (hL b hb)
  have hLeq : L = Nat.lcm a b * (L / Nat.lcm a b) := (Nat.mul_div_cancel' hdvd).symm
  conv_lhs => rw [hLeq]
  exact pair_period (hD a ha) (hD b hb) _

end HalfPair

/-- info: 'HalfPair.square_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.square_form

namespace HalfPair

open Finset

/-- **A sawtooth paired with itself.** Over `L` (a multiple of `a`), `Σ saw_a(k)² = (L/a)·(a² + 2)/(12a)`. -/
theorem pair_self {a : ℕ} (ha : 0 < a) (m : ℕ) :
    ∑ k ∈ range (a * m), saw a k * saw a k = (m : ℚ) * (((a : ℚ) ^ 2 + 2) / (12 * a)) := by
  have h := pair_period ha ha m
  simp only [Nat.lcm_self, Nat.gcd_self] at h
  exact h

/-- **The form, split into its diagonal and its pairs.** The square sum is the diagonal, each
sawtooth with itself, plus every pair of distinct periods weighted by what they share. Measured
(scratch, 2026-11-26): the whole form stays near `0.005·X` for `X = 10³ … 10⁵`; the pairs
are where the sieve's signs cancel. -/
theorem square_form_split (D : Finset ℕ) (hD : ∀ d ∈ D, 0 < d) (c : ℕ → ℚ) {L : ℕ}
    (hL : ∀ d ∈ D, d ∣ L) :
    ∑ k ∈ range L, (∑ d ∈ D, c d * saw d k) ^ 2
      = ∑ a ∈ D, c a ^ 2 * (((L / a : ℕ) : ℚ) * (((a : ℚ) ^ 2 + 2) / (12 * a)))
        + ∑ a ∈ D, ∑ b ∈ D.erase a, c a * c b * (((L / Nat.lcm a b : ℕ) : ℚ) *
            ((((Nat.gcd a b : ℕ) : ℚ) ^ 2 + 2) / (12 * (Nat.gcd a b : ℕ)))) := by
  rw [square_form D hD c hL, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun a ha => ?_
  rw [← Finset.add_sum_erase D _ ha]
  simp only [Nat.lcm_self, Nat.gcd_self, sq]

end HalfPair

/-- info: 'HalfPair.square_form_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfPair.square_form_split
