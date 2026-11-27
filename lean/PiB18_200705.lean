import PiChunks

namespace PiChunks

theorem b18_200705 : Nat.count Nat.Prime 204801 = Nat.count Nat.Prime 200705 + 329 := by
  have h := count_add_chunk 200705 4096
  have hc : cntR 200705 4096 = 329 := by decide +kernel
  rw [hc, show (200705 : ℕ) + 4096 = 204801 from rfl] at h
  exact h

end PiChunks
