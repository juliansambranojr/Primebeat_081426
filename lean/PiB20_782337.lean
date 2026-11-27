import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_782337 : Nat.count Nat.Prime 786433 = Nat.count Nat.Prime 782337 + 298 := by
  have h := count_add_chunk 782337 4096
  have hc : cntR 782337 4096 = 298 := by decide +kernel
  rw [hc, show (782337 : ℕ) + 4096 = 786433 from rfl] at h
  exact h

end PiChunks
