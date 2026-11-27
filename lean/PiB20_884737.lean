import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_884737 : Nat.count Nat.Prime 888833 = Nat.count Nat.Prime 884737 + 305 := by
  have h := count_add_chunk 884737 4096
  have hc : cntR 884737 4096 = 305 := by decide +kernel
  rw [hc, show (884737 : ℕ) + 4096 = 888833 from rfl] at h
  exact h

end PiChunks
