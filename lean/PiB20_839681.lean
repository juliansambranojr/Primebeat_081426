import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_839681 : Nat.count Nat.Prime 843777 = Nat.count Nat.Prime 839681 + 299 := by
  have h := count_add_chunk 839681 4096
  have hc : cntR 839681 4096 = 299 := by decide +kernel
  rw [hc, show (839681 : ℕ) + 4096 = 843777 from rfl] at h
  exact h

end PiChunks
