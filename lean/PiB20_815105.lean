import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_815105 : Nat.count Nat.Prime 819201 = Nat.count Nat.Prime 815105 + 291 := by
  have h := count_add_chunk 815105 4096
  have hc : cntR 815105 4096 = 291 := by decide +kernel
  rw [hc, show (815105 : ℕ) + 4096 = 819201 from rfl] at h
  exact h

end PiChunks
