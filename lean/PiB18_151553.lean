import PiChunks

namespace PiChunks

theorem b18_151553 : Nat.count Nat.Prime 155649 = Nat.count Nat.Prime 151553 + 345 := by
  have h := count_add_chunk 151553 4096
  have hc : cntR 151553 4096 = 345 := by decide +kernel
  rw [hc, show (151553 : ℕ) + 4096 = 155649 from rfl] at h
  exact h

end PiChunks
