import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_901121 : Nat.count Nat.Prime 905217 = Nat.count Nat.Prime 901121 + 297 := by
  have h := count_add_chunk 901121 4096
  have hc : cntR 901121 4096 = 297 := by decide +kernel
  rw [hc, show (901121 : ℕ) + 4096 = 905217 from rfl] at h
  exact h

end PiChunks
