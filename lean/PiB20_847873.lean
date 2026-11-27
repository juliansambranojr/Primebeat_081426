import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_847873 : Nat.count Nat.Prime 851969 = Nat.count Nat.Prime 847873 + 300 := by
  have h := count_add_chunk 847873 4096
  have hc : cntR 847873 4096 = 300 := by decide +kernel
  rw [hc, show (847873 : ℕ) + 4096 = 851969 from rfl] at h
  exact h

end PiChunks
