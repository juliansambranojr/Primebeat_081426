import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_1015809 : Nat.count Nat.Prime 1019905 = Nat.count Nat.Prime 1015809 + 301 := by
  have h := count_add_chunk 1015809 4096
  have hc : cntR 1015809 4096 = 301 := by decide +kernel
  rw [hc, show (1015809 : ℕ) + 4096 = 1019905 from rfl] at h
  exact h

end PiChunks
