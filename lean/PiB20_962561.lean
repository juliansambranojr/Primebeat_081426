import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_962561 : Nat.count Nat.Prime 966657 = Nat.count Nat.Prime 962561 + 304 := by
  have h := count_add_chunk 962561 4096
  have hc : cntR 962561 4096 = 304 := by decide +kernel
  rw [hc, show (962561 : ℕ) + 4096 = 966657 from rfl] at h
  exact h

end PiChunks
