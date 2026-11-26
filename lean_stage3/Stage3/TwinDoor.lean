/-
# Stage3.TwinDoor — the twins balance Julian's doorway

Julian, 2026-11-26: "each 6k flanked by twins as a doorway between the 2·3 lattice and the number
line … twin primes are like paths where you can take one twin to keep going and another to a way
back to .5". Every prime above 3 sits beside a `6k`, at `6k − 1` or `6k + 1`. The doorway's sign
`door p` is `+1` on the `6k − 1` side and `−1` on the `6k + 1` side; summed over the primes it is
the difference of the two sides, whose error is carried by the zeros of the L-function mod 3. A
twin pair puts one prime on each side, so it adds nothing to the difference: the difference is
the lone primes' alone. Measured (scratch, exploratory): the difference stays within `0.07 √x`
for `x` from `10⁴` to `10⁸`, twins contributing exactly zero.
-/
import Mathlib

namespace TwinDoor

open Finset

/-- The doorway's sign: `+1` beside `6k` from below, `−1` from above, `0` off the lattice. -/
def door (n : ℕ) : ℤ := if n % 6 = 5 then 1 else if n % 6 = 1 then -1 else 0

/-- A prime above 3 sits on one side of a `6k`. -/
theorem prime_mod_six {p : ℕ} (hp : p.Prime) (h3 : 3 < p) : p % 6 = 1 ∨ p % 6 = 5 := by
  have h2 : ¬ 2 ∣ p := fun h => by
    have := (Nat.prime_dvd_prime_iff_eq Nat.prime_two hp).mp h; omega
  have h3' : ¬ 3 ∣ p := fun h => by
    have := (Nat.prime_dvd_prime_iff_eq Nat.prime_three hp).mp h; omega
  omega

/-- **A twin pair goes through the doorway once each way.** For twins `p, p + 2` above 3, the lower
is at `6k − 1`, the upper at `6k + 1`, and their signs cancel. -/
theorem twin_balances {p : ℕ} (hp : p.Prime) (hq : (p + 2).Prime) (h3 : 3 < p) :
    door p + door (p + 2) = 0 := by
  have hlow : p % 6 = 5 := by
    rcases prime_mod_six hp h3 with h | h
    · exfalso
      have h3d : 3 ∣ p + 2 := by omega
      have := (Nat.prime_dvd_prime_iff_eq Nat.prime_three hq).mp h3d; omega
    · exact h
  have hup : (p + 2) % 6 = 1 := by omega
  unfold door; rw [if_pos hlow, if_neg (by omega), if_pos hup]; norm_num

/-- **The twins carry none of the difference.** Over any finite set of twin lower members above 3,
the doorway signs of the pairs sum to zero. -/
theorem twins_sum_zero (T : Finset ℕ) (hT : ∀ p ∈ T, p.Prime ∧ (p + 2).Prime ∧ 3 < p) :
    ∑ p ∈ T, (door p + door (p + 2)) = 0 :=
  Finset.sum_eq_zero fun p hp => twin_balances (hT p hp).1 (hT p hp).2.1 (hT p hp).2.2

end TwinDoor

/-- info: 'TwinDoor.twin_balances' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TwinDoor.twin_balances

/-- info: 'TwinDoor.twins_sum_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TwinDoor.twins_sum_zero
