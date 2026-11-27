import PiChunks

namespace PiChunks

theorem b19_323585 : Nat.count Nat.Prime 327681 = Nat.count Nat.Prime 323585 + 332 := by
  have h := count_add_chunk 323585 4096
  have hc : cntR 323585 4096 = 332 := by decide +kernel
  rw [hc, show (323585 : ℕ) + 4096 = 327681 from rfl] at h
  exact h

end PiChunks
