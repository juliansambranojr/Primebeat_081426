import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_790529 : Nat.count Nat.Prime 794625 = Nat.count Nat.Prime 790529 + 313 := by
  have h := count_add_chunk 790529 4096
  have hc : cntR 790529 4096 = 313 := by decide +kernel
  rw [hc, show (790529 : ℕ) + 4096 = 794625 from rfl] at h
  exact h

end PiChunks
