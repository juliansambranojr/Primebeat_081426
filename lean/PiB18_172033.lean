import PiChunks

namespace PiChunks

theorem b18_172033 : Nat.count Nat.Prime 176129 = Nat.count Nat.Prime 172033 + 333 := by
  have h := count_add_chunk 172033 4096
  have hc : cntR 172033 4096 = 333 := by decide +kernel
  rw [hc, show (172033 : ℕ) + 4096 = 176129 from rfl] at h
  exact h

end PiChunks
