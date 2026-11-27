import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1011713 : Nat.count Nat.Prime 1015809 = Nat.count Nat.Prime 1011713 + 299 := by
  have h := count_add_chunk 1011713 4096
  have hc : cntR 1011713 4096 = 299 := by decide +kernel
  rw [hc, show (1011713 : ℕ) + 4096 = 1015809 from rfl] at h
  exact h

end PiChunks
