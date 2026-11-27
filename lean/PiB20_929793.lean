import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_929793 : Nat.count Nat.Prime 933889 = Nat.count Nat.Prime 929793 + 287 := by
  have h := count_add_chunk 929793 4096
  have hc : cntR 929793 4096 = 287 := by decide +kernel
  rw [hc, show (929793 : ℕ) + 4096 = 933889 from rfl] at h
  exact h

end PiChunks
