import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_831489 : Nat.count Nat.Prime 835585 = Nat.count Nat.Prime 831489 + 300 := by
  have h := count_add_chunk 831489 4096
  have hc : cntR 831489 4096 = 300 := by decide +kernel
  rw [hc, show (831489 : ℕ) + 4096 = 835585 from rfl] at h
  exact h

end PiChunks
