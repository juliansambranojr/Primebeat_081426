import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1028097 : Nat.count Nat.Prime 1032193 = Nat.count Nat.Prime 1028097 + 281 := by
  have h := count_add_chunk 1028097 4096
  have hc : cntR 1028097 4096 = 281 := by decide +kernel
  rw [hc, show (1028097 : ℕ) + 4096 = 1032193 from rfl] at h
  exact h

end PiChunks
