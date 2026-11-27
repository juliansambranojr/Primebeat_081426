import PiChunks

namespace PiChunks

theorem b18_180225 : Nat.count Nat.Prime 184321 = Nat.count Nat.Prime 180225 + 333 := by
  have h := count_add_chunk 180225 4096
  have hc : cntR 180225 4096 = 333 := by decide +kernel
  rw [hc, show (180225 : ℕ) + 4096 = 184321 from rfl] at h
  exact h

end PiChunks
