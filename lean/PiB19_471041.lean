import PiChunks

namespace PiChunks

theorem b19_471041 : Nat.count Nat.Prime 475137 = Nat.count Nat.Prime 471041 + 316 := by
  have h := count_add_chunk 471041 4096
  have hc : cntR 471041 4096 = 316 := by decide +kernel
  rw [hc, show (471041 : ℕ) + 4096 = 475137 from rfl] at h
  exact h

end PiChunks
