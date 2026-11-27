import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_819201 : Nat.count Nat.Prime 823297 = Nat.count Nat.Prime 819201 + 320 := by
  have h := count_add_chunk 819201 4096
  have hc : cntR 819201 4096 = 320 := by decide +kernel
  rw [hc, show (819201 : ℕ) + 4096 = 823297 from rfl] at h
  exact h

end PiChunks
