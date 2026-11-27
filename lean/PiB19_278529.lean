import PiChunks

namespace PiChunks

theorem b19_278529 : Nat.count Nat.Prime 282625 = Nat.count Nat.Prime 278529 + 333 := by
  have h := count_add_chunk 278529 4096
  have hc : cntR 278529 4096 = 333 := by decide +kernel
  rw [hc, show (278529 : ℕ) + 4096 = 282625 from rfl] at h
  exact h

end PiChunks
