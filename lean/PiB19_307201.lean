import PiChunks

namespace PiChunks

theorem b19_307201 : Nat.count Nat.Prime 311297 = Nat.count Nat.Prime 307201 + 311 := by
  have h := count_add_chunk 307201 4096
  have hc : cntR 307201 4096 = 311 := by decide +kernel
  rw [hc, show (307201 : ℕ) + 4096 = 311297 from rfl] at h
  exact h

end PiChunks
