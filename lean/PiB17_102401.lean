import PiChunks

namespace PiChunks

theorem b17_102401 : Nat.count Nat.Prime 106497 = Nat.count Nat.Prime 102401 + 346 := by
  have h := count_add_chunk 102401 4096
  have hc : cntR 102401 4096 = 346 := by decide +kernel
  rw [hc, show (102401 : ℕ) + 4096 = 106497 from rfl] at h
  exact h

end PiChunks
