import PiChunks

namespace PiChunks

theorem b18_225281 : Nat.count Nat.Prime 229377 = Nat.count Nat.Prime 225281 + 336 := by
  have h := count_add_chunk 225281 4096
  have hc : cntR 225281 4096 = 336 := by decide +kernel
  rw [hc, show (225281 : ℕ) + 4096 = 229377 from rfl] at h
  exact h

end PiChunks
