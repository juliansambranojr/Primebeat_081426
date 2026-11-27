import PiChunks

namespace PiChunks

theorem b18_159745 : Nat.count Nat.Prime 163841 = Nat.count Nat.Prime 159745 + 337 := by
  have h := count_add_chunk 159745 4096
  have hc : cntR 159745 4096 = 337 := by decide +kernel
  rw [hc, show (159745 : ℕ) + 4096 = 163841 from rfl] at h
  exact h

end PiChunks
