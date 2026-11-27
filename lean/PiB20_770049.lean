import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_770049 : Nat.count Nat.Prime 774145 = Nat.count Nat.Prime 770049 + 307 := by
  have h := count_add_chunk 770049 4096
  have hc : cntR 770049 4096 = 307 := by decide +kernel
  rw [hc, show (770049 : ℕ) + 4096 = 774145 from rfl] at h
  exact h

end PiChunks
