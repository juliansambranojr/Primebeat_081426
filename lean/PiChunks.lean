/-
PiChunks — rows 15 and 16 of the π list, counted in blocks of 4096 so each kernel check
recurses only 4096 deep, one file per block (`PiBlock*`), since the kernel's memory for a block stays held for the rest of its file.
-/
import PiSieve

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

end PiChunks

/-- info: 'PiChunks.count_total' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.count_total
