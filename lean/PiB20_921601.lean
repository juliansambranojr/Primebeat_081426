import PiChunks

namespace PiChunks

set_option maxHeartbeats 0 in
theorem b20_921601 : Nat.count Nat.Prime 925697 = Nat.count Nat.Prime 921601 + 318 := by
  have h := count_add_chunk 921601 4096
  have hc : cntR 921601 4096 = 318 := by decide +kernel
  rw [hc, show (921601 : ℕ) + 4096 = 925697 from rfl] at h
  exact h

end PiChunks
