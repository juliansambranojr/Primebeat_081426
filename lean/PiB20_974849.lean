import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_974849 : Nat.count Nat.Prime 978945 = Nat.count Nat.Prime 974849 + 291 := by
  have h := count_add_chunk 974849 4096
  have hc : cntR 974849 4096 = 291 := by decide +kernel
  rw [hc, show (974849 : ℕ) + 4096 = 978945 from rfl] at h
  exact h

end PiChunks
