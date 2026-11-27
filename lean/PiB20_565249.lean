import PiChunks

namespace PiChunks

theorem b20_565249 : Nat.count Nat.Prime 569345 = Nat.count Nat.Prime 565249 + 306 := by
  have h := count_add_chunk 565249 4096
  have hc : cntR 565249 4096 = 306 := by decide +kernel
  rw [hc, show (565249 : ℕ) + 4096 = 569345 from rfl] at h
  exact h

end PiChunks
