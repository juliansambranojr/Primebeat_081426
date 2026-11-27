import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_757761 : Nat.count Nat.Prime 761857 = Nat.count Nat.Prime 757761 + 317 := by
  have h := count_add_chunk 757761 4096
  have hc : cntR 757761 4096 = 317 := by decide +kernel
  rw [hc, show (757761 : ℕ) + 4096 = 761857 from rfl] at h
  exact h

end PiChunks
