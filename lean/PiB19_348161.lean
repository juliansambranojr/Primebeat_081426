import PiChunks

namespace PiChunks

theorem b19_348161 : Nat.count Nat.Prime 352257 = Nat.count Nat.Prime 348161 + 324 := by
  have h := count_add_chunk 348161 4096
  have hc : cntR 348161 4096 = 324 := by decide +kernel
  rw [hc, show (348161 : ℕ) + 4096 = 352257 from rfl] at h
  exact h

end PiChunks
