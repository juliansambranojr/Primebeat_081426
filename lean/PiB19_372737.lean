import PiChunks

namespace PiChunks

theorem b19_372737 : Nat.count Nat.Prime 376833 = Nat.count Nat.Prime 372737 + 330 := by
  have h := count_add_chunk 372737 4096
  have hc : cntR 372737 4096 = 330 := by decide +kernel
  rw [hc, show (372737 : ℕ) + 4096 = 376833 from rfl] at h
  exact h

end PiChunks
