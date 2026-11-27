import PiChunks

namespace PiChunks

theorem b19_360449 : Nat.count Nat.Prime 364545 = Nat.count Nat.Prime 360449 + 318 := by
  have h := count_add_chunk 360449 4096
  have hc : cntR 360449 4096 = 318 := by decide +kernel
  rw [hc, show (360449 : ℕ) + 4096 = 364545 from rfl] at h
  exact h

end PiChunks
