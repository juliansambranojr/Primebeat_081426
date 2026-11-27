/-
PiRow18 — row 18 of the π list: `pi17` and the primes in `(2^17, 2^18]`, one block of 4096
per file (`PiB18_*`), each stating the count's step as a linear fact, joined by `omega`.
-/
import PiB18_131073
import PiB18_135169
import PiB18_139265
import PiB18_143361
import PiB18_147457
import PiB18_151553
import PiB18_155649
import PiB18_159745
import PiB18_163841
import PiB18_167937
import PiB18_172033
import PiB18_176129
import PiB18_180225
import PiB18_184321
import PiB18_188417
import PiB18_192513
import PiB18_196609
import PiB18_200705
import PiB18_204801
import PiB18_208897
import PiB18_212993
import PiB18_217089
import PiB18_221185
import PiB18_225281
import PiB18_229377
import PiB18_233473
import PiB18_237569
import PiB18_241665
import PiB18_245761
import PiB18_249857
import PiB18_253953
import PiB18_258049
import PiRow17

namespace PiChunks

theorem pi18 : Nat.primeCounting (2 ^ 18) = 23000 := by
  have hp := pi17
  simp only [Nat.primeCounting, Nat.primeCounting', Nat.reducePow, Nat.reduceAdd] at hp ⊢
  have := b18_131073
  have := b18_135169
  have := b18_139265
  have := b18_143361
  have := b18_147457
  have := b18_151553
  have := b18_155649
  have := b18_159745
  have := b18_163841
  have := b18_167937
  have := b18_172033
  have := b18_176129
  have := b18_180225
  have := b18_184321
  have := b18_188417
  have := b18_192513
  have := b18_196609
  have := b18_200705
  have := b18_204801
  have := b18_208897
  have := b18_212993
  have := b18_217089
  have := b18_221185
  have := b18_225281
  have := b18_229377
  have := b18_233473
  have := b18_237569
  have := b18_241665
  have := b18_245761
  have := b18_249857
  have := b18_253953
  have := b18_258049
  omega

/-- **`StmtPiData` on rows 0 … 18, proved.** -/
theorem piData_le18 : ∀ n : Nat, n ≤ 18 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 18 with h | h
  · exact piData_le17 n (by omega)
  · have : n = 18 := by omega
    subst this; rw [pi18]; decide

end PiChunks

/-- info: 'PiChunks.piData_le18' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le18
