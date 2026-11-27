import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_946177 : Nat.count Nat.Prime 950273 = Nat.count Nat.Prime 946177 + 288 := by
  have h := count_add_chunk 946177 4096
  have hc : cntR 946177 4096 = 288 := by decide +kernel
  rw [hc, show (946177 : ℕ) + 4096 = 950273 from rfl] at h
  exact h

end PiChunks
