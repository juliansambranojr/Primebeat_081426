import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_724993 : Nat.count Nat.Prime 729089 = Nat.count Nat.Prime 724993 + 303 := by
  have h := count_add_chunk 724993 4096
  have hc : cntR 724993 4096 = 303 := by decide +kernel
  rw [hc, show (724993 : ℕ) + 4096 = 729089 from rfl] at h
  exact h

end PiChunks
