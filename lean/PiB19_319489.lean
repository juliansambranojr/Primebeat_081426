import PiChunks

namespace PiChunks

theorem b19_319489 : Nat.count Nat.Prime 323585 = Nat.count Nat.Prime 319489 + 325 := by
  have h := count_add_chunk 319489 4096
  have hc : cntR 319489 4096 = 325 := by decide +kernel
  rw [hc, show (319489 : ℕ) + 4096 = 323585 from rfl] at h
  exact h

end PiChunks
