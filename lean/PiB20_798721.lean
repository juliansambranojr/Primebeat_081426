import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_798721 : Nat.count Nat.Prime 802817 = Nat.count Nat.Prime 798721 + 298 := by
  have h := count_add_chunk 798721 4096
  have hc : cntR 798721 4096 = 298 := by decide +kernel
  rw [hc, show (798721 : ℕ) + 4096 = 802817 from rfl] at h
  exact h

end PiChunks
