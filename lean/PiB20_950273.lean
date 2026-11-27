import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_950273 : Nat.count Nat.Prime 954369 = Nat.count Nat.Prime 950273 + 296 := by
  have h := count_add_chunk 950273 4096
  have hc : cntR 950273 4096 = 296 := by decide +kernel
  rw [hc, show (950273 : ℕ) + 4096 = 954369 from rfl] at h
  exact h

end PiChunks
