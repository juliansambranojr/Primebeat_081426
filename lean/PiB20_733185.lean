import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_733185 : Nat.count Nat.Prime 737281 = Nat.count Nat.Prime 733185 + 304 := by
  have h := count_add_chunk 733185 4096
  have hc : cntR 733185 4096 = 304 := by decide +kernel
  rw [hc, show (733185 : ℕ) + 4096 = 737281 from rfl] at h
  exact h

end PiChunks
