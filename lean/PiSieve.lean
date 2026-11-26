/-
PiSieve — π(2^n) for the first rows, by a trial-division count proved correct in Lean and
evaluated by the kernel. No `native_decide`.

`noDiv n d fuel`: no divisor of `n` in `[d, √n]`, by structural recursion on the fuel.
`isPrimeB_iff`: `isPrimeB n = true ↔ n.Prime`. `cnt_eq`: `cnt n = Nat.count Nat.Prime n`.
-/
import Mathlib

namespace PiSieve

/-- No divisor of `n` from `d` while `d·d ≤ n`, within `fuel` steps. -/
def noDiv (n : ℕ) : ℕ → ℕ → Bool
  | _, 0 => true
  | d, fuel + 1 => if n < d * d then true else if n % d = 0 then false else noDiv n (d + 1) fuel

theorem noDiv_iff (n : ℕ) : ∀ fuel d, n < (d + fuel) * (d + fuel) →
    (noDiv n d fuel = true ↔ ∀ k, d ≤ k → k * k ≤ n → ¬ k ∣ n) := by
  intro fuel
  induction fuel with
  | zero =>
    intro d h
    simp only [noDiv, true_iff]
    intro k hk hkn
    exact absurd (lt_of_lt_of_le h (Nat.mul_le_mul hk hk)) (by omega)
  | succ f ih =>
    intro d h
    simp only [noDiv]
    by_cases hlt : n < d * d
    · simp only [hlt, if_true, true_iff]
      intro k hk hkn
      exact absurd (lt_of_lt_of_le hlt (Nat.mul_le_mul hk hk)) (by omega)
    · simp only [hlt, if_false]
      by_cases hmod : n % d = 0
      · simp only [hmod, if_true]
        constructor
        · intro h; exact absurd h (by simp)
        · intro hall
          exact absurd (Nat.dvd_of_mod_eq_zero hmod) (hall d le_rfl (by omega))
      · simp only [hmod, if_false]
        rw [ih (d + 1) (by rw [show d + 1 + f = d + (f + 1) by ring]; exact h)]
        constructor
        · intro hall k hk hkn
          rcases Nat.eq_or_lt_of_le hk with hk | hk
          · subst hk; intro hd; exact hmod (Nat.mod_eq_zero_of_dvd hd)
          · exact hall k hk hkn
        · intro hall k hk hkn; exact hall k (by omega) hkn

/-- Primality by trial division. -/
def isPrimeB (n : ℕ) : Bool := decide (2 ≤ n) && noDiv n 2 n

theorem isPrimeB_iff (n : ℕ) : isPrimeB n = true ↔ n.Prime := by
  unfold isPrimeB
  rw [Bool.and_eq_true, decide_eq_true_iff, noDiv_iff n n 2 (by nlinarith), Nat.prime_def_le_sqrt]
  refine and_congr_right fun _ => ⟨fun h m hm hms => h m hm (Nat.le_sqrt.mp hms),
    fun h k hk hkn => h k hk (Nat.le_sqrt.mpr hkn)⟩

/-- The count of primes below `n`. -/
def cnt : ℕ → ℕ
  | 0 => 0
  | n + 1 => cnt n + if isPrimeB n then 1 else 0

theorem cnt_eq (n : ℕ) : cnt n = Nat.count Nat.Prime n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    rw [cnt, Nat.count_succ, ih]
    by_cases h : k.Prime
    · simp [h, (isPrimeB_iff k).mpr h]
    · have : isPrimeB k = false := by
        cases hb : isPrimeB k
        · rfl
        · exact absurd ((isPrimeB_iff k).mp hb) h
      simp [h, this]

theorem primeCounting_eq_cnt (N : ℕ) : Nat.primeCounting N = cnt (N + 1) := by
  rw [Nat.primeCounting, Nat.primeCounting', cnt_eq]

end PiSieve

/-- info: 'PiSieve.primeCounting_eq_cnt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiSieve.primeCounting_eq_cnt
