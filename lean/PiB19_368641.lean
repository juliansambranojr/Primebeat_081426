import PiChunks

namespace PiChunks

theorem b19_368641 : Nat.count Nat.Prime 372737 = Nat.count Nat.Prime 368641 + 294 := by
  have h := count_add_chunk 368641 4096
  have hc : cntR 368641 4096 = 294 := by decide +kernel
  rw [hc, show (368641 : ℕ) + 4096 = 372737 from rfl] at h
  exact h

end PiChunks
