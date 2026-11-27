import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_761857 : Nat.count Nat.Prime 765953 = Nat.count Nat.Prime 761857 + 308 := by
  have h := count_add_chunk 761857 4096
  have hc : cntR 761857 4096 = 308 := by decide +kernel
  rw [hc, show (761857 : ℕ) + 4096 = 765953 from rfl] at h
  exact h

end PiChunks
