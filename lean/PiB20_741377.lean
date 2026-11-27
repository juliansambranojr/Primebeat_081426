import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_741377 : Nat.count Nat.Prime 745473 = Nat.count Nat.Prime 741377 + 279 := by
  have h := count_add_chunk 741377 4096
  have hc : cntR 741377 4096 = 279 := by decide +kernel
  rw [hc, show (741377 : ℕ) + 4096 = 745473 from rfl] at h
  exact h

end PiChunks
