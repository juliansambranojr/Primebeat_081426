import PiChunks

namespace PiChunks

theorem b18_143361 : Nat.count Nat.Prime 147457 = Nat.count Nat.Prime 143361 + 342 := by
  have h := count_add_chunk 143361 4096
  have hc : cntR 143361 4096 = 342 := by decide +kernel
  rw [hc, show (143361 : ℕ) + 4096 = 147457 from rfl] at h
  exact h

end PiChunks
