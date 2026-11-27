import PiChunks

namespace PiChunks

theorem b19_311297 : Nat.count Nat.Prime 315393 = Nat.count Nat.Prime 311297 + 324 := by
  have h := count_add_chunk 311297 4096
  have hc : cntR 311297 4096 = 324 := by decide +kernel
  rw [hc, show (311297 : ℕ) + 4096 = 315393 from rfl] at h
  exact h

end PiChunks
