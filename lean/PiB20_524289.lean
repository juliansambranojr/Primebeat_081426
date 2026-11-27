import PiChunks

namespace PiChunks

theorem b20_524289 : Nat.count Nat.Prime 528385 = Nat.count Nat.Prime 524289 + 313 := by
  have h := count_add_chunk 524289 4096
  have hc : cntR 524289 4096 = 313 := by decide +kernel
  rw [hc, show (524289 : ℕ) + 4096 = 528385 from rfl] at h
  exact h

end PiChunks
