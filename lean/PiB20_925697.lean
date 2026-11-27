import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_925697 : Nat.count Nat.Prime 929793 = Nat.count Nat.Prime 925697 + 294 := by
  have h := count_add_chunk 925697 4096
  have hc : cntR 925697 4096 = 294 := by decide +kernel
  rw [hc, show (925697 : ℕ) + 4096 = 929793 from rfl] at h
  exact h

end PiChunks
