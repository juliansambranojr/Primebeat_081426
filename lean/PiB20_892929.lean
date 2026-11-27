import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_892929 : Nat.count Nat.Prime 897025 = Nat.count Nat.Prime 892929 + 298 := by
  have h := count_add_chunk 892929 4096
  have hc : cntR 892929 4096 = 298 := by decide +kernel
  rw [hc, show (892929 : ℕ) + 4096 = 897025 from rfl] at h
  exact h

end PiChunks
