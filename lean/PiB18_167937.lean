import PiChunks

namespace PiChunks

theorem b18_167937 : Nat.count Nat.Prime 172033 = Nat.count Nat.Prime 167937 + 336 := by
  have h := count_add_chunk 167937 4096
  have hc : cntR 167937 4096 = 336 := by decide +kernel
  rw [hc, show (167937 : ℕ) + 4096 = 172033 from rfl] at h
  exact h

end PiChunks
