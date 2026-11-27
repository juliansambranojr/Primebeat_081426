import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_880641 : Nat.count Nat.Prime 884737 = Nat.count Nat.Prime 880641 + 297 := by
  have h := count_add_chunk 880641 4096
  have hc : cntR 880641 4096 = 297 := by decide +kernel
  rw [hc, show (880641 : ℕ) + 4096 = 884737 from rfl] at h
  exact h

end PiChunks
