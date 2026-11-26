/-
PiRows — the first rows of `DepthSix.piTwoPow` proved, by `PiSieve`'s verified count
evaluated in the kernel. Rows 0 … 12 by `cnt`, rows 13 and 14 by the odd-divisor count `cnt2`. Row 16 overflows the
kernel's stack: the count recurses once per number, so the next rows go in chunks.
-/
import Mathlib
import DepthSix
import PiSieve

namespace PiRows

/-- **`StmtPiData` on rows 0 … 12, proved.** -/
theorem piData_le12 : ∀ n : Nat, n ≤ 12 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  interval_cases n <;>
  · rw [PiSieve.primeCounting_eq_cnt]; decide +kernel

/-- **`StmtPiData` on rows 0 … 14, proved.** -/
theorem piData_le14 : ∀ n : Nat, n ≤ 14 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 13 with h | h
  · exact piData_le12 n (by omega)
  · interval_cases n <;>
    · rw [PiSieve.primeCounting_eq_cnt2]; decide +kernel

end PiRows

/-- info: 'PiRows.piData_le12' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiRows.piData_le12

/-- info: 'PiRows.piData_le14' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiRows.piData_le14
