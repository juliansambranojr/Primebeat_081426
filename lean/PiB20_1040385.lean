import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1040385 : Nat.count Nat.Prime 1044481 = Nat.count Nat.Prime 1040385 + 305 := by
  have h := count_add_chunk 1040385 4096
  have hc : cntR 1040385 4096 = 305 := by decide +kernel
  rw [hc, show (1040385 : ℕ) + 4096 = 1044481 from rfl] at h
  exact h

end PiChunks
