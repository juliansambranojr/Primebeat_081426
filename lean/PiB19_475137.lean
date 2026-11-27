import PiChunks

namespace PiChunks

theorem b19_475137 : Nat.count Nat.Prime 479233 = Nat.count Nat.Prime 475137 + 322 := by
  have h := count_add_chunk 475137 4096
  have hc : cntR 475137 4096 = 322 := by decide +kernel
  rw [hc, show (475137 : ℕ) + 4096 = 479233 from rfl] at h
  exact h

end PiChunks
