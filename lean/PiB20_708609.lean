import PiChunks

namespace PiChunks

theorem b20_708609 : Nat.count Nat.Prime 712705 = Nat.count Nat.Prime 708609 + 305 := by
  have h := count_add_chunk 708609 4096
  have hc : cntR 708609 4096 = 305 := by decide +kernel
  rw [hc, show (708609 : ℕ) + 4096 = 712705 from rfl] at h
  exact h

end PiChunks
