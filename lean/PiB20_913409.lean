import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_913409 : Nat.count Nat.Prime 917505 = Nat.count Nat.Prime 913409 + 285 := by
  have h := count_add_chunk 913409 4096
  have hc : cntR 913409 4096 = 285 := by decide +kernel
  rw [hc, show (913409 : ℕ) + 4096 = 917505 from rfl] at h
  exact h

end PiChunks
