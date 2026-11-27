import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_872449 : Nat.count Nat.Prime 876545 = Nat.count Nat.Prime 872449 + 297 := by
  have h := count_add_chunk 872449 4096
  have hc : cntR 872449 4096 = 297 := by decide +kernel
  rw [hc, show (872449 : ℕ) + 4096 = 876545 from rfl] at h
  exact h

end PiChunks
