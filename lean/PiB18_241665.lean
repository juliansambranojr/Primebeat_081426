import PiChunks

namespace PiChunks

theorem b18_241665 : Nat.count Nat.Prime 245761 = Nat.count Nat.Prime 241665 + 336 := by
  have h := count_add_chunk 241665 4096
  have hc : cntR 241665 4096 = 336 := by decide +kernel
  rw [hc, show (241665 : ℕ) + 4096 = 245761 from rfl] at h
  exact h

end PiChunks
