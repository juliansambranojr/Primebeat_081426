import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_811009 : Nat.count Nat.Prime 815105 = Nat.count Nat.Prime 811009 + 296 := by
  have h := count_add_chunk 811009 4096
  have hc : cntR 811009 4096 = 296 := by decide +kernel
  rw [hc, show (811009 : ℕ) + 4096 = 815105 from rfl] at h
  exact h

end PiChunks
