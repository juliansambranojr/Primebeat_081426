import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_802817 : Nat.count Nat.Prime 806913 = Nat.count Nat.Prime 802817 + 297 := by
  have h := count_add_chunk 802817 4096
  have hc : cntR 802817 4096 = 297 := by decide +kernel
  rw [hc, show (802817 : ℕ) + 4096 = 806913 from rfl] at h
  exact h

end PiChunks
