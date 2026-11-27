import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_729089 : Nat.count Nat.Prime 733185 = Nat.count Nat.Prime 729089 + 299 := by
  have h := count_add_chunk 729089 4096
  have hc : cntR 729089 4096 = 299 := by decide +kernel
  rw [hc, show (729089 : ℕ) + 4096 = 733185 from rfl] at h
  exact h

end PiChunks
