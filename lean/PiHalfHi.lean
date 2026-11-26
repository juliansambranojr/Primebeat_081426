/-
PiHalfHi — the primes in `[2^15, 2^16]`, block by block: `total 32768 (…) = 3030`.
-/
import PiBlock32768
import PiBlock36864
import PiBlock40960
import PiBlock45056
import PiBlock49152
import PiBlock53248
import PiBlock57344
import PiBlock61440
import PiBlock65536

namespace PiChunks

theorem totalHi : total 32768 (List.replicate 8 4096 ++ [1]) = 3030 := by
  simp only [List.replicate, List.cons_append, List.nil_append, total, Nat.reduceAdd, c_32768, c_36864, c_40960, c_45056, c_49152, c_53248, c_57344, c_61440, c_65536]

end PiChunks
