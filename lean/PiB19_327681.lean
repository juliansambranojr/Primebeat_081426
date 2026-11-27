import PiChunks

namespace PiChunks

theorem b19_327681 : Nat.count Nat.Prime 331777 = Nat.count Nat.Prime 327681 + 323 := by
  have h := count_add_chunk 327681 4096
  have hc : cntR 327681 4096 = 323 := by decide +kernel
  rw [hc, show (327681 : ℕ) + 4096 = 331777 from rfl] at h
  exact h

end PiChunks
