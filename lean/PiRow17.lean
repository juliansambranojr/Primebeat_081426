/-
PiRow17 — row 17 of the π list: `pi16` and the primes in `(2^16, 2^17]`, one block of 4096
per file (`PiB17_*`), each stating the count's step as a linear fact, joined by `omega`.
-/
import PiB17_65537
import PiB17_69633
import PiB17_73729
import PiB17_77825
import PiB17_81921
import PiB17_86017
import PiB17_90113
import PiB17_94209
import PiB17_98305
import PiB17_102401
import PiB17_106497
import PiB17_110593
import PiB17_114689
import PiB17_118785
import PiB17_122881
import PiB17_126977
import PiRow16

namespace PiChunks

theorem pi17 : Nat.primeCounting (2 ^ 17) = 12251 := by
  have hp := pi16
  simp only [Nat.primeCounting, Nat.primeCounting', Nat.reducePow, Nat.reduceAdd] at hp ⊢
  have := b17_65537
  have := b17_69633
  have := b17_73729
  have := b17_77825
  have := b17_81921
  have := b17_86017
  have := b17_90113
  have := b17_94209
  have := b17_98305
  have := b17_102401
  have := b17_106497
  have := b17_110593
  have := b17_114689
  have := b17_118785
  have := b17_122881
  have := b17_126977
  omega

/-- **`StmtPiData` on rows 0 … 17, proved.** -/
theorem piData_le17 : ∀ n : Nat, n ≤ 17 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 17 with h | h
  · exact piData_le16 n (by omega)
  · have : n = 17 := by omega
    subst this; rw [pi17]; decide

end PiChunks

/-- info: 'PiChunks.piData_le17' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le17
