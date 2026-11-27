import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_835585 : Nat.count Nat.Prime 839681 = Nat.count Nat.Prime 835585 + 297 := by
  have h := count_add_chunk 835585 4096
  have hc : cntR 835585 4096 = 297 := by decide +kernel
  rw [hc, show (835585 : ℕ) + 4096 = 839681 from rfl] at h
  exact h

end PiChunks
