import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_851969 : Nat.count Nat.Prime 856065 = Nat.count Nat.Prime 851969 + 289 := by
  have h := count_add_chunk 851969 4096
  have hc : cntR 851969 4096 = 289 := by decide +kernel
  rw [hc, show (851969 : ℕ) + 4096 = 856065 from rfl] at h
  exact h

end PiChunks
