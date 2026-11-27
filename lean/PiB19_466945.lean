import PiChunks

namespace PiChunks

theorem b19_466945 : Nat.count Nat.Prime 471041 = Nat.count Nat.Prime 466945 + 331 := by
  have h := count_add_chunk 466945 4096
  have hc : cntR 466945 4096 = 331 := by decide +kernel
  rw [hc, show (466945 : ℕ) + 4096 = 471041 from rfl] at h
  exact h

end PiChunks
