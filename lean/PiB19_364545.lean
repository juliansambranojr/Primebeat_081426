import PiChunks

namespace PiChunks

theorem b19_364545 : Nat.count Nat.Prime 368641 = Nat.count Nat.Prime 364545 + 324 := by
  have h := count_add_chunk 364545 4096
  have hc : cntR 364545 4096 = 324 := by decide +kernel
  rw [hc, show (364545 : ℕ) + 4096 = 368641 from rfl] at h
  exact h

end PiChunks
