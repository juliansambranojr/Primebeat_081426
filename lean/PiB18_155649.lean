import PiChunks

namespace PiChunks

theorem b18_155649 : Nat.count Nat.Prime 159745 = Nat.count Nat.Prime 155649 + 335 := by
  have h := count_add_chunk 155649 4096
  have hc : cntR 155649 4096 = 335 := by decide +kernel
  rw [hc, show (155649 : ℕ) + 4096 = 159745 from rfl] at h
  exact h

end PiChunks
