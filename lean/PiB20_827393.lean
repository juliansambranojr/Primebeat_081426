import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_827393 : Nat.count Nat.Prime 831489 = Nat.count Nat.Prime 827393 + 292 := by
  have h := count_add_chunk 827393 4096
  have hc : cntR 827393 4096 = 292 := by decide +kernel
  rw [hc, show (827393 : ℕ) + 4096 = 831489 from rfl] at h
  exact h

end PiChunks
