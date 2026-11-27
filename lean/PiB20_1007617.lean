import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1007617 : Nat.count Nat.Prime 1011713 = Nat.count Nat.Prime 1007617 + 305 := by
  have h := count_add_chunk 1007617 4096
  have hc : cntR 1007617 4096 = 305 := by decide +kernel
  rw [hc, show (1007617 : ℕ) + 4096 = 1011713 from rfl] at h
  exact h

end PiChunks
