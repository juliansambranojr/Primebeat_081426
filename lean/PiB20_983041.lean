import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_983041 : Nat.count Nat.Prime 987137 = Nat.count Nat.Prime 983041 + 305 := by
  have h := count_add_chunk 983041 4096
  have hc : cntR 983041 4096 = 305 := by decide +kernel
  rw [hc, show (983041 : ℕ) + 4096 = 987137 from rfl] at h
  exact h

end PiChunks
