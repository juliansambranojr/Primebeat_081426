import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_888833 : Nat.count Nat.Prime 892929 = Nat.count Nat.Prime 888833 + 293 := by
  have h := count_add_chunk 888833 4096
  have hc : cntR 888833 4096 = 293 := by decide +kernel
  rw [hc, show (888833 : ℕ) + 4096 = 892929 from rfl] at h
  exact h

end PiChunks
