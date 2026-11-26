/-
PiRow16 — row 16 of the π list from its two halves (`PiHalfLo`, `PiHalfHi`), each built in its
own file so no single check holds the whole row.
-/
import PiHalfLo
import PiHalfHi
import PiData15

namespace PiChunks

theorem pi16 : Nat.primeCounting (2 ^ 16) = 6542 := by
  have h := count_total (List.replicate 8 4096 ++ [1]) 32768
  have hs : (List.replicate 8 4096 ++ [1]).sum = 32769 := by simp [List.replicate]
  simp only [hs, countLo, totalHi, Nat.reduceAdd] at h
  have e : 2 ^ 16 + 1 = 65537 := by norm_num
  simp only [Nat.primeCounting, Nat.primeCounting', e, h]

/-- **`StmtPiData` on rows 0 … 16, proved.** -/
theorem piData_le16 : ∀ n : Nat, n ≤ 16 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 16 with h | h
  · exact piData_le15 n (by omega)
  · have : n = 16 := by omega
    subst this; rw [pi16]; decide

end PiChunks

/-- info: 'PiChunks.piData_le16' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le16
