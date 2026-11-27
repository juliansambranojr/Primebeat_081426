import PiChunks

namespace PiChunks

theorem b19_356353 : Nat.count Nat.Prime 360449 = Nat.count Nat.Prime 356353 + 309 := by
  have h := count_add_chunk 356353 4096
  have hc : cntR 356353 4096 = 309 := by decide +kernel
  rw [hc, show (356353 : ℕ) + 4096 = 360449 from rfl] at h
  exact h

end PiChunks
