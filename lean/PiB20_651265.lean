import PiChunks

namespace PiChunks

theorem b20_651265 : Nat.count Nat.Prime 655361 = Nat.count Nat.Prime 651265 + 313 := by
  have h := count_add_chunk 651265 4096
  have hc : cntR 651265 4096 = 313 := by decide +kernel
  rw [hc, show (651265 : ℕ) + 4096 = 655361 from rfl] at h
  exact h

end PiChunks
