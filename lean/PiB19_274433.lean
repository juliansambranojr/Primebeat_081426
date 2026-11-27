import PiChunks

namespace PiChunks

theorem b19_274433 : Nat.count Nat.Prime 278529 = Nat.count Nat.Prime 274433 + 326 := by
  have h := count_add_chunk 274433 4096
  have hc : cntR 274433 4096 = 326 := by decide +kernel
  rw [hc, show (274433 : ℕ) + 4096 = 278529 from rfl] at h
  exact h

end PiChunks
