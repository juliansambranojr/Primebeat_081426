import PiChunks

namespace PiChunks

theorem b20_528385 : Nat.count Nat.Prime 532481 = Nat.count Nat.Prime 528385 + 308 := by
  have h := count_add_chunk 528385 4096
  have hc : cntR 528385 4096 = 308 := by decide +kernel
  rw [hc, show (528385 : ℕ) + 4096 = 532481 from rfl] at h
  exact h

end PiChunks
