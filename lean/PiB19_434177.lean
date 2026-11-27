import PiChunks

namespace PiChunks

theorem b19_434177 : Nat.count Nat.Prime 438273 = Nat.count Nat.Prime 434177 + 316 := by
  have h := count_add_chunk 434177 4096
  have hc : cntR 434177 4096 = 316 := by decide +kernel
  rw [hc, show (434177 : ℕ) + 4096 = 438273 from rfl] at h
  exact h

end PiChunks
