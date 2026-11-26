/-
PiData15 — `StmtPiData` on rows 0 … 15: rows 0 … 14 from `PiRows`, row 15 from the blocks of
`PiChunks`. Row 16's assembly ran out of memory (code 137) and is not here. Kept apart from `PiChunks` so the kernel's block checks run under a light import.
-/
import Mathlib
import PiRows
import PiBlock0
import PiBlock4096
import PiBlock8192
import PiBlock12288
import PiBlock16384
import PiBlock20480
import PiBlock24576
import PiBlock28672
import PiBlock15last

namespace PiChunks

/-- Row 15: eight blocks and the single number `2^15`, which is even. -/
theorem pi15 : Nat.primeCounting (2 ^ 15) = 3512 := by
  rw [primeCounting_eq_total _ (List.replicate 8 4096 ++ [1]) (by decide)]
  simp only [List.replicate, List.cons_append, List.nil_append, total, Nat.reduceAdd,
    c_0, c_4096, c_8192, c_12288, c_16384, c_20480, c_24576, c_28672, c15_last]

/-- **`StmtPiData` on rows 0 … 15, proved.** -/
theorem piData_le15 : ∀ n : Nat, n ≤ 15 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 15 with h | h
  · exact PiRows.piData_le14 n (by omega)
  · have : n = 15 := by omega
    subst this; rw [pi15]; decide

end PiChunks

/-- info: 'PiChunks.piData_le15' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le15
