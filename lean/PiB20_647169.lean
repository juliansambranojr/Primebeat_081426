import PiChunks

namespace PiChunks

theorem b20_647169 : Nat.count Nat.Prime 651265 = Nat.count Nat.Prime 647169 + 306 := by
  have h := count_add_chunk 647169 4096
  have hc : cntR 647169 4096 = 306 := by decide +kernel
  rw [hc, show (647169 : ℕ) + 4096 = 651265 from rfl] at h
  exact h

end PiChunks
