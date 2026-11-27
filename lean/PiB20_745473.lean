import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_745473 : Nat.count Nat.Prime 749569 = Nat.count Nat.Prime 745473 + 303 := by
  have h := count_add_chunk 745473 4096
  have hc : cntR 745473 4096 = 303 := by decide +kernel
  rw [hc, show (745473 : ℕ) + 4096 = 749569 from rfl] at h
  exact h

end PiChunks
