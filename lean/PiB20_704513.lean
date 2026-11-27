import PiChunks

namespace PiChunks

theorem b20_704513 : Nat.count Nat.Prime 708609 = Nat.count Nat.Prime 704513 + 321 := by
  have h := count_add_chunk 704513 4096
  have hc : cntR 704513 4096 = 321 := by decide +kernel
  rw [hc, show (704513 : ℕ) + 4096 = 708609 from rfl] at h
  exact h

end PiChunks
