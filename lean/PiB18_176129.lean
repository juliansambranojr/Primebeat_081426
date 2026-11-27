import PiChunks

namespace PiChunks

theorem b18_176129 : Nat.count Nat.Prime 180225 = Nat.count Nat.Prime 176129 + 354 := by
  have h := count_add_chunk 176129 4096
  have hc : cntR 176129 4096 = 354 := by decide +kernel
  rw [hc, show (176129 : ℕ) + 4096 = 180225 from rfl] at h
  exact h

end PiChunks
