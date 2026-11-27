import PiChunks

namespace PiChunks

theorem b19_397313 : Nat.count Nat.Prime 401409 = Nat.count Nat.Prime 397313 + 314 := by
  have h := count_add_chunk 397313 4096
  have hc : cntR 397313 4096 = 314 := by decide +kernel
  rw [hc, show (397313 : ℕ) + 4096 = 401409 from rfl] at h
  exact h

end PiChunks
