import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_897025 : Nat.count Nat.Prime 901121 = Nat.count Nat.Prime 897025 + 292 := by
  have h := count_add_chunk 897025 4096
  have hc : cntR 897025 4096 = 292 := by decide +kernel
  rw [hc, show (897025 : ℕ) + 4096 = 901121 from rfl] at h
  exact h

end PiChunks
