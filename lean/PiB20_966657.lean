import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_966657 : Nat.count Nat.Prime 970753 = Nat.count Nat.Prime 966657 + 287 := by
  have h := count_add_chunk 966657 4096
  have hc : cntR 966657 4096 = 287 := by decide +kernel
  rw [hc, show (966657 : ℕ) + 4096 = 970753 from rfl] at h
  exact h

end PiChunks
