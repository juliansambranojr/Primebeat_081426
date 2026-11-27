import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_999425 : Nat.count Nat.Prime 1003521 = Nat.count Nat.Prime 999425 + 309 := by
  have h := count_add_chunk 999425 4096
  have hc : cntR 999425 4096 = 309 := by decide +kernel
  rw [hc, show (999425 : ℕ) + 4096 = 1003521 from rfl] at h
  exact h

end PiChunks
