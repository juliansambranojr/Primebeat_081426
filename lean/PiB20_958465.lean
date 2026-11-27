import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_958465 : Nat.count Nat.Prime 962561 = Nat.count Nat.Prime 958465 + 303 := by
  have h := count_add_chunk 958465 4096
  have hc : cntR 958465 4096 = 303 := by decide +kernel
  rw [hc, show (958465 : ℕ) + 4096 = 962561 from rfl] at h
  exact h

end PiChunks
