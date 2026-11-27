import PiChunks

namespace PiChunks

theorem b20_655361 : Nat.count Nat.Prime 659457 = Nat.count Nat.Prime 655361 + 292 := by
  have h := count_add_chunk 655361 4096
  have hc : cntR 655361 4096 = 292 := by decide +kernel
  rw [hc, show (655361 : ℕ) + 4096 = 659457 from rfl] at h
  exact h

end PiChunks
