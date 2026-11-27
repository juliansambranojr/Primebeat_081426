import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1036289 : Nat.count Nat.Prime 1040385 = Nat.count Nat.Prime 1036289 + 282 := by
  have h := count_add_chunk 1036289 4096
  have hc : cntR 1036289 4096 = 282 := by decide +kernel
  rw [hc, show (1036289 : ℕ) + 4096 = 1040385 from rfl] at h
  exact h

end PiChunks
