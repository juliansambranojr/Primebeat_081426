import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1003521 : Nat.count Nat.Prime 1007617 = Nat.count Nat.Prime 1003521 + 294 := by
  have h := count_add_chunk 1003521 4096
  have hc : cntR 1003521 4096 = 294 := by decide +kernel
  rw [hc, show (1003521 : ℕ) + 4096 = 1007617 from rfl] at h
  exact h

end PiChunks
