import PiChunks

namespace PiChunks

theorem b19_315393 : Nat.count Nat.Prime 319489 = Nat.count Nat.Prime 315393 + 343 := by
  have h := count_add_chunk 315393 4096
  have hc : cntR 315393 4096 = 343 := by decide +kernel
  rw [hc, show (315393 : ℕ) + 4096 = 319489 from rfl] at h
  exact h

end PiChunks
