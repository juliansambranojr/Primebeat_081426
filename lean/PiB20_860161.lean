import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_860161 : Nat.count Nat.Prime 864257 = Nat.count Nat.Prime 860161 + 306 := by
  have h := count_add_chunk 860161 4096
  have hc : cntR 860161 4096 = 306 := by decide +kernel
  rw [hc, show (860161 : ℕ) + 4096 = 864257 from rfl] at h
  exact h

end PiChunks
