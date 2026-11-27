import PiChunks

namespace PiChunks

theorem b19_479233 : Nat.count Nat.Prime 483329 = Nat.count Nat.Prime 479233 + 315 := by
  have h := count_add_chunk 479233 4096
  have hc : cntR 479233 4096 = 315 := by decide +kernel
  rw [hc, show (479233 : ℕ) + 4096 = 483329 from rfl] at h
  exact h

end PiChunks
