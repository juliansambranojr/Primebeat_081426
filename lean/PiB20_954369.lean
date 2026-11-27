import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_954369 : Nat.count Nat.Prime 958465 = Nat.count Nat.Prime 954369 + 283 := by
  have h := count_add_chunk 954369 4096
  have hc : cntR 954369 4096 = 283 := by decide +kernel
  rw [hc, show (954369 : ℕ) + 4096 = 958465 from rfl] at h
  exact h

end PiChunks
