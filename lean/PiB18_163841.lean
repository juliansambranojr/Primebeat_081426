import PiChunks

namespace PiChunks

theorem b18_163841 : Nat.count Nat.Prime 167937 = Nat.count Nat.Prime 163841 + 335 := by
  have h := count_add_chunk 163841 4096
  have hc : cntR 163841 4096 = 335 := by decide +kernel
  rw [hc, show (163841 : ℕ) + 4096 = 167937 from rfl] at h
  exact h

end PiChunks
