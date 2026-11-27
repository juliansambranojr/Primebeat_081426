import PiChunks

namespace PiChunks

theorem b19_282625 : Nat.count Nat.Prime 286721 = Nat.count Nat.Prime 282625 + 322 := by
  have h := count_add_chunk 282625 4096
  have hc : cntR 282625 4096 = 322 := by decide +kernel
  rw [hc, show (282625 : ℕ) + 4096 = 286721 from rfl] at h
  exact h

end PiChunks
