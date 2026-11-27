import PiChunks

namespace PiChunks

theorem b18_196609 : Nat.count Nat.Prime 200705 = Nat.count Nat.Prime 196609 + 334 := by
  have h := count_add_chunk 196609 4096
  have hc : cntR 196609 4096 = 334 := by decide +kernel
  rw [hc, show (196609 : ℕ) + 4096 = 200705 from rfl] at h
  exact h

end PiChunks
