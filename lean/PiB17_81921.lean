import PiChunks

namespace PiChunks

theorem b17_81921 : Nat.count Nat.Prime 86017 = Nat.count Nat.Prime 81921 + 354 := by
  have h := count_add_chunk 81921 4096
  have hc : cntR 81921 4096 = 354 := by decide +kernel
  rw [hc, show (81921 : ℕ) + 4096 = 86017 from rfl] at h
  exact h

end PiChunks
