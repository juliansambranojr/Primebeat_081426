import PiChunks

namespace PiChunks

theorem b20_602113 : Nat.count Nat.Prime 606209 = Nat.count Nat.Prime 602113 + 311 := by
  have h := count_add_chunk 602113 4096
  have hc : cntR 602113 4096 = 311 := by decide +kernel
  rw [hc, show (602113 : ℕ) + 4096 = 606209 from rfl] at h
  exact h

end PiChunks
