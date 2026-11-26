import PiChunks

namespace PiChunks

theorem b17_110593 : Nat.count Nat.Prime 114689 = Nat.count Nat.Prime 110593 + 347 := by
  have h := count_add_chunk 110593 4096
  have hc : cntR 110593 4096 = 347 := by decide +kernel
  rw [hc, show (110593 : ℕ) + 4096 = 114689 from rfl] at h
  exact h

end PiChunks
