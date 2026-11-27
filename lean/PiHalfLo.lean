/-
PiHalfLo — the primes below `2^15`, block by block: `Nat.count Nat.Prime 32768 = 3512`.
-/
import PiBlock0
import PiBlock4096
import PiBlock8192
import PiBlock12288
import PiBlock16384
import PiBlock20480
import PiBlock24576
import PiBlock28672

namespace PiChunks

theorem countLo : Nat.count Nat.Prime 32768 = 3512 := by
  have h := count_total (List.replicate 8 4096) 0
  have hs : (List.replicate 8 4096).sum = 32768 := by simp [List.replicate]
  have ht : total 0 (List.replicate 8 4096) = 3512 := by
    simp only [List.replicate, total, Nat.reduceAdd, c_0, c_4096, c_8192, c_12288, c_16384, c_20480, c_24576, c_28672]
  simp only [hs, zero_add, Nat.count_zero, ht] at h
  exact h

end PiChunks
