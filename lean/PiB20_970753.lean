import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_970753 : Nat.count Nat.Prime 974849 = Nat.count Nat.Prime 970753 + 307 := by
  have h := count_add_chunk 970753 4096
  have hc : cntR 970753 4096 = 307 := by decide +kernel
  rw [hc, show (970753 : ℕ) + 4096 = 974849 from rfl] at h
  exact h

end PiChunks
