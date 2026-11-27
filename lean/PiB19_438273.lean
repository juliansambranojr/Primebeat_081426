import PiChunks

namespace PiChunks

theorem b19_438273 : Nat.count Nat.Prime 442369 = Nat.count Nat.Prime 438273 + 317 := by
  have h := count_add_chunk 438273 4096
  have hc : cntR 438273 4096 = 317 := by decide +kernel
  rw [hc, show (438273 : ℕ) + 4096 = 442369 from rfl] at h
  exact h

end PiChunks
