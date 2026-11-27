import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_917505 : Nat.count Nat.Prime 921601 = Nat.count Nat.Prime 917505 + 301 := by
  have h := count_add_chunk 917505 4096
  have hc : cntR 917505 4096 = 301 := by decide +kernel
  rw [hc, show (917505 : ℕ) + 4096 = 921601 from rfl] at h
  exact h

end PiChunks
