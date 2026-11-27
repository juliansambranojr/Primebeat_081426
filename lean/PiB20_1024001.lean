import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1024001 : Nat.count Nat.Prime 1028097 = Nat.count Nat.Prime 1024001 + 298 := by
  have h := count_add_chunk 1024001 4096
  have hc : cntR 1024001 4096 = 298 := by decide +kernel
  rw [hc, show (1024001 : ℕ) + 4096 = 1028097 from rfl] at h
  exact h

end PiChunks
