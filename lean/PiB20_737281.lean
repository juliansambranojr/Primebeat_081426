import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_737281 : Nat.count Nat.Prime 741377 = Nat.count Nat.Prime 737281 + 304 := by
  have h := count_add_chunk 737281 4096
  have hc : cntR 737281 4096 = 304 := by decide +kernel
  rw [hc, show (737281 : ℕ) + 4096 = 741377 from rfl] at h
  exact h

end PiChunks
