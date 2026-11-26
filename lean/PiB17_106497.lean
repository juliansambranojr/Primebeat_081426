import PiChunks

namespace PiChunks

theorem b17_106497 : Nat.count Nat.Prime 110593 = Nat.count Nat.Prime 106497 + 348 := by
  have h := count_add_chunk 106497 4096
  have hc : cntR 106497 4096 = 348 := by decide +kernel
  rw [hc, show (106497 : ℕ) + 4096 = 110593 from rfl] at h
  exact h

end PiChunks
