import PiChunks

namespace PiChunks

theorem b20_569345 : Nat.count Nat.Prime 573441 = Nat.count Nat.Prime 569345 + 319 := by
  have h := count_add_chunk 569345 4096
  have hc : cntR 569345 4096 = 319 := by decide +kernel
  rw [hc, show (569345 : ℕ) + 4096 = 573441 from rfl] at h
  exact h

end PiChunks
