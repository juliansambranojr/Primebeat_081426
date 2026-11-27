import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1019905 : Nat.count Nat.Prime 1024001 = Nat.count Nat.Prime 1019905 + 297 := by
  have h := count_add_chunk 1019905 4096
  have hc : cntR 1019905 4096 = 297 := by decide +kernel
  rw [hc, show (1019905 : ℕ) + 4096 = 1024001 from rfl] at h
  exact h

end PiChunks
