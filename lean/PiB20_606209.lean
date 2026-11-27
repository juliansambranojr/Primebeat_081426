import PiChunks

namespace PiChunks

theorem b20_606209 : Nat.count Nat.Prime 610305 = Nat.count Nat.Prime 606209 + 309 := by
  have h := count_add_chunk 606209 4096
  have hc : cntR 606209 4096 = 309 := by decide +kernel
  rw [hc, show (606209 : ℕ) + 4096 = 610305 from rfl] at h
  exact h

end PiChunks
