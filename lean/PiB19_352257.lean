import PiChunks

namespace PiChunks

theorem b19_352257 : Nat.count Nat.Prime 356353 = Nat.count Nat.Prime 352257 + 328 := by
  have h := count_add_chunk 352257 4096
  have hc : cntR 352257 4096 = 328 := by decide +kernel
  rw [hc, show (352257 : ℕ) + 4096 = 356353 from rfl] at h
  exact h

end PiChunks
