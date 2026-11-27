import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_843777 : Nat.count Nat.Prime 847873 = Nat.count Nat.Prime 843777 + 297 := by
  have h := count_add_chunk 843777 4096
  have hc : cntR 843777 4096 = 297 := by decide +kernel
  rw [hc, show (843777 : ℕ) + 4096 = 847873 from rfl] at h
  exact h

end PiChunks
