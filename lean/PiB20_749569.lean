import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_749569 : Nat.count Nat.Prime 753665 = Nat.count Nat.Prime 749569 + 300 := by
  have h := count_add_chunk 749569 4096
  have hc : cntR 749569 4096 = 300 := by decide +kernel
  rw [hc, show (749569 : ℕ) + 4096 = 753665 from rfl] at h
  exact h

end PiChunks
