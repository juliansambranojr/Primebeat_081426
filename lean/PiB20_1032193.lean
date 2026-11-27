import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1032193 : Nat.count Nat.Prime 1036289 = Nat.count Nat.Prime 1032193 + 306 := by
  have h := count_add_chunk 1032193 4096
  have hc : cntR 1032193 4096 = 306 := by decide +kernel
  rw [hc, show (1032193 : ℕ) + 4096 = 1036289 from rfl] at h
  exact h

end PiChunks
