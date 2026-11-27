import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_753665 : Nat.count Nat.Prime 757761 = Nat.count Nat.Prime 753665 + 298 := by
  have h := count_add_chunk 753665 4096
  have hc : cntR 753665 4096 = 298 := by decide +kernel
  rw [hc, show (753665 : ℕ) + 4096 = 757761 from rfl] at h
  exact h

end PiChunks
