import PiChunks

namespace PiChunks

theorem b19_442369 : Nat.count Nat.Prime 446465 = Nat.count Nat.Prime 442369 + 324 := by
  have h := count_add_chunk 442369 4096
  have hc : cntR 442369 4096 = 324 := by decide +kernel
  rw [hc, show (442369 : ℕ) + 4096 = 446465 from rfl] at h
  exact h

end PiChunks
