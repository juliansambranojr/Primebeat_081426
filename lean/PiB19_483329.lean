import PiChunks

namespace PiChunks

theorem b19_483329 : Nat.count Nat.Prime 487425 = Nat.count Nat.Prime 483329 + 294 := by
  have h := count_add_chunk 483329 4096
  have hc : cntR 483329 4096 = 294 := by decide +kernel
  rw [hc, show (483329 : ℕ) + 4096 = 487425 from rfl] at h
  exact h

end PiChunks
