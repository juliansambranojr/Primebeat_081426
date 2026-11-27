import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_720897 : Nat.count Nat.Prime 724993 = Nat.count Nat.Prime 720897 + 321 := by
  have h := count_add_chunk 720897 4096
  have hc : cntR 720897 4096 = 321 := by decide +kernel
  rw [hc, show (720897 : ℕ) + 4096 = 724993 from rfl] at h
  exact h

end PiChunks
