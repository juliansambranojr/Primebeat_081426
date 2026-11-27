import PiChunks

namespace PiChunks

theorem b20_610305 : Nat.count Nat.Prime 614401 = Nat.count Nat.Prime 610305 + 307 := by
  have h := count_add_chunk 610305 4096
  have hc : cntR 610305 4096 = 307 := by decide +kernel
  rw [hc, show (610305 : ℕ) + 4096 = 614401 from rfl] at h
  exact h

end PiChunks
