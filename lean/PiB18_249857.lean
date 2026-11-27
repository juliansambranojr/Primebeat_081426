import PiChunks

namespace PiChunks

theorem b18_249857 : Nat.count Nat.Prime 253953 = Nat.count Nat.Prime 249857 + 327 := by
  have h := count_add_chunk 249857 4096
  have hc : cntR 249857 4096 = 327 := by decide +kernel
  rw [hc, show (249857 : ℕ) + 4096 = 253953 from rfl] at h
  exact h

end PiChunks
