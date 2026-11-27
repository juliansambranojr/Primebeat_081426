import PiChunks

namespace PiChunks

theorem b20_573441 : Nat.count Nat.Prime 577537 = Nat.count Nat.Prime 573441 + 313 := by
  have h := count_add_chunk 573441 4096
  have hc : cntR 573441 4096 = 313 := by decide +kernel
  rw [hc, show (573441 : ℕ) + 4096 = 577537 from rfl] at h
  exact h

end PiChunks
