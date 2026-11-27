import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_864257 : Nat.count Nat.Prime 868353 = Nat.count Nat.Prime 864257 + 308 := by
  have h := count_add_chunk 864257 4096
  have hc : cntR 864257 4096 = 308 := by decide +kernel
  rw [hc, show (864257 : ℕ) + 4096 = 868353 from rfl] at h
  exact h

end PiChunks
