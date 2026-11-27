import PiChunks

namespace PiChunks

theorem b19_454657 : Nat.count Nat.Prime 458753 = Nat.count Nat.Prime 454657 + 311 := by
  have h := count_add_chunk 454657 4096
  have hc : cntR 454657 4096 = 311 := by decide +kernel
  rw [hc, show (454657 : ℕ) + 4096 = 458753 from rfl] at h
  exact h

end PiChunks
