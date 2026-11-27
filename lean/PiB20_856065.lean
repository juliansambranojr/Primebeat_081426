import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_856065 : Nat.count Nat.Prime 860161 = Nat.count Nat.Prime 856065 + 304 := by
  have h := count_add_chunk 856065 4096
  have hc : cntR 856065 4096 = 304 := by decide +kernel
  rw [hc, show (856065 : ℕ) + 4096 = 860161 from rfl] at h
  exact h

end PiChunks
