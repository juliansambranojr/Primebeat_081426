import PiChunks

namespace PiChunks

theorem b19_409601 : Nat.count Nat.Prime 413697 = Nat.count Nat.Prime 409601 + 312 := by
  have h := count_add_chunk 409601 4096
  have hc : cntR 409601 4096 = 312 := by decide +kernel
  rw [hc, show (409601 : ℕ) + 4096 = 413697 from rfl] at h
  exact h

end PiChunks
