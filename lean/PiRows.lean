/-
PiRows — the first rows of `DepthSix.piTwoPow` proved, by `PiSieve`'s verified count
evaluated in the kernel. Rows 0 … 12 here; row 14 takes the kernel about a minute.
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

end PiRows

/-- info: 'PiRows.piData_le12' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiRows.piData_le12
