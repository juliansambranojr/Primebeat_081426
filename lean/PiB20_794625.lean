import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_794625 : Nat.count Nat.Prime 798721 = Nat.count Nat.Prime 794625 + 304 := by
  have h := count_add_chunk 794625 4096
  have hc : cntR 794625 4096 = 304 := by decide +kernel
  rw [hc, show (794625 : ℕ) + 4096 = 798721 from rfl] at h
  exact h

end PiChunks
