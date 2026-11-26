/-
PiChunks — rows 15 and 16 of the π list, counted in blocks of 4096 so each kernel check
recurses only 4096 deep (`count_eq_chunks`).
-/
import Mathlib
import DepthSix
import PiSieve
import PiRows

namespace PiChunks
open PiSieve

/-- The primes in `[a, a + len)`, by the odd-divisor test. -/
def cntR (a : ℕ) : ℕ → ℕ
  | 0 => 0
  | l + 1 => cntR a l + if isPrimeB2 (a + l) then 1 else 0

theorem cntR_eq (a l : ℕ) : cntR a l = Nat.count (fun k => Nat.Prime (a + k)) l := by
  induction l with
  | zero => rfl
  | succ k ih =>
    rw [cntR, Nat.count_succ, ih]
    by_cases h : (a + k).Prime
    · simp [h, (isPrimeB2_iff (a + k)).mpr h]
    · have : isPrimeB2 (a + k) = false := by
        cases hb : isPrimeB2 (a + k)
        · rfl
        · exact absurd ((isPrimeB2_iff _).mp hb) h
      simp [h, this]

theorem count_add_chunk (a l : ℕ) : Nat.count Nat.Prime (a + l) = Nat.count Nat.Prime a + cntR a l := by
  rw [Nat.count_add, cntR_eq]
/-- The primes counted block by block. -/
def total : ℕ → List ℕ → ℕ
  | _, [] => 0
  | a, l :: ls => cntR a l + total (a + l) ls

theorem count_total (ls : List ℕ) : ∀ a, Nat.count Nat.Prime (a + ls.sum) = Nat.count Nat.Prime a + total a ls := by
  induction ls with
  | nil => intro a; simp [total]
  | cons l ls ih =>
    intro a
    rw [List.sum_cons, ← add_assoc, ih (a + l), count_add_chunk, total]; ring

theorem primeCounting_eq_total (N : ℕ) (ls : List ℕ) (h : ls.sum = N + 1) :
    Nat.primeCounting N = total 0 ls := by
  rw [Nat.primeCounting, Nat.primeCounting', ← h, ← zero_add ls.sum, count_total]; simp

theorem pi15 : Nat.primeCounting (2 ^ 15) = 3512 := by
  rw [primeCounting_eq_total _ (List.replicate 8 4096 ++ [1]) (by decide)]
  decide +kernel

theorem pi16 : Nat.primeCounting (2 ^ 16) = 6542 := by
  rw [primeCounting_eq_total _ (List.replicate 16 4096 ++ [1]) (by decide)]
  decide +kernel

/-- **`StmtPiData` on rows 0 … 16, proved.** -/
theorem piData_le16 : ∀ n : Nat, n ≤ 16 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 15 with h | h
  · exact PiRows.piData_le14 n (by omega)
  · interval_cases n
    · rw [pi15]; decide
    · rw [pi16]; decide

end PiChunks

/-- info: 'PiChunks.piData_le16' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le16
