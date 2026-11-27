import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_942081 : Nat.count Nat.Prime 946177 = Nat.count Nat.Prime 942081 + 291 := by
  have h := count_add_chunk 942081 4096
  have hc : cntR 942081 4096 = 291 := by decide +kernel
  rw [hc, show (942081 : ℕ) + 4096 = 946177 from rfl] at h
  exact h

end PiChunks
