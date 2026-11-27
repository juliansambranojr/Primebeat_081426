import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_806913 : Nat.count Nat.Prime 811009 = Nat.count Nat.Prime 806913 + 302 := by
  have h := count_add_chunk 806913 4096
  have hc : cntR 806913 4096 = 302 := by decide +kernel
  rw [hc, show (806913 : ℕ) + 4096 = 811009 from rfl] at h
  exact h

end PiChunks
