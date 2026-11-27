import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_774145 : Nat.count Nat.Prime 778241 = Nat.count Nat.Prime 774145 + 292 := by
  have h := count_add_chunk 774145 4096
  have hc : cntR 774145 4096 = 292 := by decide +kernel
  rw [hc, show (774145 : ℕ) + 4096 = 778241 from rfl] at h
  exact h

end PiChunks
