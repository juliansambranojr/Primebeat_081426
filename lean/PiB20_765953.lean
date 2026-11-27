import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_765953 : Nat.count Nat.Prime 770049 = Nat.count Nat.Prime 765953 + 305 := by
  have h := count_add_chunk 765953 4096
  have hc : cntR 765953 4096 = 305 := by decide +kernel
  rw [hc, show (765953 : ℕ) + 4096 = 770049 from rfl] at h
  exact h

end PiChunks
