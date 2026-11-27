import PiChunks

namespace PiChunks

theorem b19_344065 : Nat.count Nat.Prime 348161 = Nat.count Nat.Prime 344065 + 324 := by
  have h := count_add_chunk 344065 4096
  have hc : cntR 344065 4096 = 324 := by decide +kernel
  rw [hc, show (344065 : ℕ) + 4096 = 348161 from rfl] at h
  exact h

end PiChunks
