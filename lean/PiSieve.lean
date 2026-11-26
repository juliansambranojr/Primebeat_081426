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

namespace PiSieve

/-- No divisor of `n` among `d, d+2, d+4, …` while `d·d ≤ n`. -/
def noDivOdd (n : ℕ) : ℕ → ℕ → Bool
  | _, 0 => true
  | d, fuel + 1 => if n < d * d then true else if n % d = 0 then false else noDivOdd n (d + 2) fuel

theorem noDivOdd_iff (n : ℕ) (hn : n % 2 = 1) : ∀ fuel d, d % 2 = 1 →
    n < (d + 2 * fuel) * (d + 2 * fuel) →
    (noDivOdd n d fuel = true ↔ ∀ k, d ≤ k → k * k ≤ n → ¬ k ∣ n) := by
  intro fuel
  induction fuel with
  | zero =>
    intro d _ h
    simp only [noDivOdd, true_iff]
    intro k hk hkn
    exact absurd (lt_of_lt_of_le h (Nat.mul_le_mul hk hk)) (by omega)
  | succ f ih =>
    intro d hd h
    simp only [noDivOdd]
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
        rw [ih (d + 2) (by omega) (by rw [show d + 2 + 2 * f = d + 2 * (f + 1) by ring]; exact h)]
        constructor
        · intro hall k hk hkn hdk
          rcases Nat.lt_or_ge k (d + 2) with hk2 | hk2
          · rcases Nat.eq_or_lt_of_le hk with hk | hk
            · subst hk; exact hmod (Nat.mod_eq_zero_of_dvd hdk)
            · -- k = d + 1 is even, and n is odd
              have hk1 : k = d + 1 := by omega
              have h2 : 2 ∣ k := by omega
              have : 2 ∣ n := dvd_trans h2 hdk
              omega
          · exact hall k hk2 hkn hdk
        · intro hall k hk hkn; exact hall k (by omega) hkn

/-- Primality by trial division over 2 and the odd numbers. -/
def isPrimeB2 (n : ℕ) : Bool :=
  if n = 2 then true else decide (2 ≤ n) && n % 2 == 1 && noDivOdd n 3 n

theorem isPrimeB2_iff (n : ℕ) : isPrimeB2 n = true ↔ n.Prime := by
  unfold isPrimeB2
  by_cases h2 : n = 2
  · subst h2; simp [Nat.prime_two]
  simp only [h2, if_false, Bool.and_eq_true, decide_eq_true_iff, beq_iff_eq]
  rw [Nat.prime_def_le_sqrt]
  constructor
  · rintro ⟨⟨hn2, hodd⟩, hnd⟩
    rw [noDivOdd_iff n hodd n 3 (by norm_num) (by nlinarith)] at hnd
    refine ⟨hn2, fun m hm hms hdm => ?_⟩
    rcases Nat.lt_or_ge m 3 with hm3 | hm3
    · have : m = 2 := by omega
      subst this; omega
    · exact hnd m hm3 (Nat.le_sqrt.mp hms) hdm
  · rintro ⟨hn2, hall⟩
    have hodd : n % 2 = 1 := by
      by_contra hc
      have h4 : 2 * 2 ≤ n := by omega
      exact hall 2 le_rfl (Nat.le_sqrt.mpr h4) (Nat.dvd_of_mod_eq_zero (by omega))
    refine ⟨⟨hn2, hodd⟩, ?_⟩
    rw [noDivOdd_iff n hodd n 3 (by norm_num) (by nlinarith)]
    exact fun k hk hkn => hall k (by omega) (Nat.le_sqrt.mpr hkn)

/-- The count of primes below `n`, with the faster test. -/
def cnt2 : ℕ → ℕ
  | 0 => 0
  | n + 1 => cnt2 n + if isPrimeB2 n then 1 else 0

theorem cnt2_eq (n : ℕ) : cnt2 n = Nat.count Nat.Prime n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    rw [cnt2, Nat.count_succ, ih]
    by_cases h : k.Prime
    · simp [h, (isPrimeB2_iff k).mpr h]
    · have : isPrimeB2 k = false := by
        cases hb : isPrimeB2 k
        · rfl
        · exact absurd ((isPrimeB2_iff k).mp hb) h
      simp [h, this]

theorem primeCounting_eq_cnt2 (N : ℕ) : Nat.primeCounting N = cnt2 (N + 1) := by
  rw [Nat.primeCounting, Nat.primeCounting', cnt2_eq]

end PiSieve

/-- info: 'PiSieve.primeCounting_eq_cnt2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiSieve.primeCounting_eq_cnt2
