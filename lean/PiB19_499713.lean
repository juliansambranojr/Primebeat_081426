import PiChunks

namespace PiChunks

theorem b19_499713 : Nat.count Nat.Prime 503809 = Nat.count Nat.Prime 499713 + 298 := by
  have h := count_add_chunk 499713 4096
  have hc : cntR 499713 4096 = 298 := by decide +kernel
  rw [hc, show (499713 : ℕ) + 4096 = 503809 from rfl] at h
  exact h

end PiChunks
