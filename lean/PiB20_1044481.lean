import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1044481 : Nat.count Nat.Prime 1048577 = Nat.count Nat.Prime 1044481 + 288 := by
  have h := count_add_chunk 1044481 4096
  have hc : cntR 1044481 4096 = 288 := by decide +kernel
  rw [hc, show (1044481 : ℕ) + 4096 = 1048577 from rfl] at h
  exact h

end PiChunks
