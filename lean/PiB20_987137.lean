import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_987137 : Nat.count Nat.Prime 991233 = Nat.count Nat.Prime 987137 + 285 := by
  have h := count_add_chunk 987137 4096
  have hc : cntR 987137 4096 = 285 := by decide +kernel
  rw [hc, show (987137 : ℕ) + 4096 = 991233 from rfl] at h
  exact h

end PiChunks
